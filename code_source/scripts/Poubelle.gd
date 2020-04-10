extends Area2D


var sprite
var id = 0
var poubelles= Singleton.poubelles


func _ready():
	Singleton.max_poubelles= len(poubelles)
	
	sprite= $AnimatedSprite 
	Singleton.connect("tete_lachee", self, "_on_tete_lachee")
	
	sprite.set_animation(poubelles[id])


func _on_tete_lachee(preview, tete_lachee, poubelle_id):
	if tete == preview:
		# bonne poubelle
		if self.id == poubelle_id:
			# → Tetes.gd
			Singleton.emit_signal("good_poubelle",preview, tete_lachee, poubelle_id)
			# printt("nombre de tetes restant:",Singleton.nb_tetes)
			if Singleton.nb_tetes < 1 :
				Singleton.emit_signal("plateau_vide")
				
			# joue un pop
			# signal à destination de World
			Singleton.emit_signal("play_pop")
		# mauvaise poubelle
		else:
			Singleton.emit_signal("bad_poubelle", tete_lachee, poubelle_id)	
			# printt("poubelle id:",self.id , "tete id:",current_id)
			# joue un cris
			# signal à destination de World
			Singleton.emit_signal("play_clic", tete_lachee.get_id())


var tete:KinematicBody2D

func _on_Poubelle_body_entered(body):
	tete= body
	sprite.set_frame(1)


func _on_Poubelle_body_exited(body):
	sprite.set_frame(0)
	tete= null

