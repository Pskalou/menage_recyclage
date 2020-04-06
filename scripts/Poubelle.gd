extends Area2D


var sprite
var id = 0
var poubelles= Singleton.poubelles


func _ready():
	Singleton.max_poubelles= len(poubelles)
	
	sprite= $AnimatedSprite 
	Singleton.connect("tete_lachee", self, "_on_tete_lachee")
	
	sprite.set_animation(poubelles[id])


func _on_tete_lachee(tete_lachee, poubelle_id):
	if tete == tete_lachee:
		# bonne poubelle
		if self.id == poubelle_id:
			Singleton.emit_signal("good_poubelle", tete_lachee, poubelle_id)
			printt("nombre de tetes restant:",Singleton.nb_tetes)
			if Singleton.nb_tetes < 1 :
				# cas du tuto 1 → tuto 2
				if Singleton.tuto_state1:
					print("signal → lancement tuto page 2")
					Singleton.emit_signal("jeux_tutoriel2")
				elif Singleton.tuto_state2:
					print("signal → lancement tuto page 3")
					Singleton.emit_signal("jeux_tutoriel3")
				elif Singleton.tuto_state3:
					print("signal → fin tuto")
					Singleton.emit_signal("fin_tuto")
				else:
					Singleton.emit_signal("plateau_vide")
			# printt("poubelle id:",self.id , "tete id:",current_id)
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


var tete:Area2D


func _on_Poubelle_area_entered(area):
	tete= area
	sprite.set_frame(1)


func _on_Poubelle_area_exited(area):
	sprite.set_frame(0)
	tete= null

