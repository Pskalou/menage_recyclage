extends Area2D


var sprite
var id = 0
var poubelles= {0:"bleue", 1:"jaune", 2:"verte", 3:"rouge"}


func _ready():
	self.z_index=2
	sprite= $AnimatedSprite 
	Singleton.connect("tete_lachee", self, "_on_tete_lachee")
	
	sprite.set_animation(poubelles[id])


func _on_tete_lachee(area, id):
	if tete == area:
		if self.id == id:
			printt("supprime", area, "id:",id)
			area.queue_free()
			Singleton.emit_signal("increase_score")
		else:
			Singleton.emit_signal("decrease_score")


var tete:Area2D


func _on_Poubelle_area_entered(area):
	tete= area
	sprite.set_frame(1)


func _on_Poubelle_area_exited(area):
	sprite.set_frame(0)
	tete= null
