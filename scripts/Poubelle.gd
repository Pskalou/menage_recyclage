extends Area2D


var sprite
var id = 0
var poubelles= Singleton.poubelles


func _ready():
	Singleton.max_poubelles= len(poubelles)
	
	self.z_index=2
	sprite= $AnimatedSprite 
	Singleton.connect("tete_lachee", self, "_on_tete_lachee")
	
	sprite.set_animation(poubelles[id])


func _on_tete_lachee(area, id):
	if tete == area:
		if self.id == id:
			printt("supprime", area, "id:",id)
			Singleton.over_list.erase(area)
			area.queue_free()
			Singleton.emit_signal("increase_score")
		else:
			area.input_pickable = false
			area.z_index = 3
			area.get_node("sprite").set_visible(false)
			area.get_node("explosion").set_frame(0)
			area.get_node("explosion").set_visible(true)
			area.get_node("explosion").play()
			
			Singleton.emit_signal("mauvaise_poubelle", id)
			Singleton.emit_signal("decrease_score")

		


var tete:Area2D


func _on_Poubelle_area_entered(area):
	tete= area
	sprite.set_frame(1)


func _on_Poubelle_area_exited(area):
	sprite.set_frame(0)
	tete= null
