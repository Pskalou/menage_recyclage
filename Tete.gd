extends Area2D


var tete:AnimatedSprite
var node_index


func _ready():
	# TODO pb de supperposition des tetes
	node_index = get_index()
	tete= get_node("AnimatedSprite")
	print(node_index)


var is_over= false

func _on_Area2D_mouse_entered():
	is_over= true
func _on_Area2D_mouse_exited():
	is_over= false


var dragging = false
var delta_pos

signal tete_lachee

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		# commence à déplacer la tete
		if is_over and !dragging and event.pressed:
			dragging= true
			delta_pos= event.position - position
		# arrête de déplacer la tete
		if dragging and !event.pressed:
			dragging= false
			Singleton.emit_signal("tete_lachee", self)
			
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

