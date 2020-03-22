extends Area2D


var sprite
var id = 0
var poubelles= Singleton.poubelles


func _ready():
	Singleton.max_poubelles= len(poubelles)
	
	sprite= $AnimatedSprite 
	Singleton.connect("tete_lachee", self, "_on_tete_lachee")
	
	sprite.set_animation(poubelles[id])


func _on_tete_lachee(area, current_id):
	if tete == area:
		if self.id == current_id:
			Singleton.emit_signal("good_poubelle", area, current_id)
		else:
			Singleton.emit_signal("bad_poubelle", area, current_id)	


var tete:Area2D


func _on_Poubelle_area_entered(area):
	tete= area
	sprite.set_frame(1)


func _on_Poubelle_area_exited(area):
	sprite.set_frame(0)
	tete= null

