extends KinematicBody2D


var id = 0
# var tetes= Singleton.tetes
var tete:AnimatedSprite


func set_id(current_id):
	self.id = current_id % len(Singleton.tetes)
	# printt("tete.gd : id = ", self.id)


func _ready():
	Singleton.max_tetes= len(Singleton.tetes)
	tete= get_node("sprite")
	tete.set_animation(Singleton.tetes[id])


func _on_Tete_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed():
		# → tetes
		# signale que la tête est touchée et envoie le node tête en argument
		Singleton.emit_signal("update_sprites_touched", self)


# retourne l'id de la poubelle associée à la tête
func get_poubelle_id():
	return self.id % Singleton.max_poubelles

# retourne l'id de la tête
func get_id():
	return self.id
