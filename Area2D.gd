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

#func _input(event):
#	print(event.as_text())
#	if event is InputEventMouseButton and event.is_pressed():
#		print(event,"mouse button event at ", event.position)
#		tete.set_frame(1)
#		tete.set_scale(Vector2(1.2,1.2))
#	else:
#		tete.set_frame(0)
#		tete.set_scale(Vector2(1,1))

#
#


var is_over= false

func _on_Area2D_mouse_entered():
	is_over= true
func _on_Area2D_mouse_exited():
	is_over= false


var dragging = false
var delta_pos


func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		# commence à déplacer la tete
		if is_over and !dragging and event.pressed:
			dragging= true
			delta_pos= event.position - position
			print(dragging, event.position, position)
		# arrête de déplacer la tete
		if dragging and !event.pressed:
			dragging= false
			print(dragging)
			
	if dragging:
		tete.set_frame(1)
		tete.set_scale(Vector2(1.2,1.2))
		position.x = event.position.x - delta_pos.x
		position.y = event.position.y - delta_pos.y
		if position.x < 100:
			position.x= 100
		if position.x> 950:
			position.x= 950
		if position.y < 100:
			position.y= 100
		if position.y > 500:
			position.y= 500
	else:
		tete.set_frame(0)
		tete.set_scale(Vector2(1,1))
