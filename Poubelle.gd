extends Area2D



var sprite


func _ready():
	sprite= $AnimatedSprite 
	Singleton.connect("tete_lachee", self, "_on_tete_lachee")



func _on_tete_lachee(area):
	if tete == area:
		printt("supprime", area)
		area.queue_free()
		Singleton.emit_signal("increase_score")
	


var tete:Area2D

func _on_Poubelle_area_entered(area):
	tete= area
	sprite.set_frame(1)

func _on_Poubelle_area_exited(area):
	sprite.set_frame(0)
	tete= null
