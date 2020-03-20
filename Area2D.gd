extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tete:AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	tete= get_node("AnimatedSprite")
	set_position(Vector2(200,200))
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		print(event,"mouse button event at ", event.position)
		tete.set_frame(1)
		tete.set_scale(Vector2(1.2,1.2))
	else:
		tete.set_frame(0)
		tete.set_scale(Vector2(1,1))
