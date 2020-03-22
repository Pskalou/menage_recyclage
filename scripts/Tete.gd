extends Area2D

var id = 0

var tetes= Singleton.tetes


var tete:AnimatedSprite


func set_id(id):
	self.id = id%len(tetes)


func _ready():
	# TODO pb de supperposition des tetes
	Singleton.max_tetes= len(tetes)
	tete= get_node("sprite")
	
	tete.set_animation(tetes[id])


var mouse_over= false
func _on_Area2D_mouse_entered():
	Singleton.over_list[self] = self.get_index()
#	print(Singleton.over_list)
	mouse_over= true
func _on_Area2D_mouse_exited():
	Singleton.over_list.erase(self)
#	print(Singleton.over_list)
	mouse_over= false


var dragging = false
var delta_pos
# utilisé pour vérifier que la tete est la première


signal tete_lachee


var maxIndex
var tete_over
var maxNode

func _input_event(viewport, event, shape_idx):
	# travail sur les calques de tete pour prendre la première
#	print(Singleton.over_list)
	
	maxNode= self
	maxIndex= maxNode.get_index()
	for e in Singleton.over_list:
		if e.get_index() > maxIndex:
			maxNode= e
			maxIndex= maxNode.get_index()
	
	tete_over = self.get_index() == maxIndex
		

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
	
		# commence à déplacer la tete
		if mouse_over and !dragging and event.pressed and tete_over:
			dragging= true
			delta_pos= event.position - position
		# arrête de déplacer la tete
		if dragging and !event.pressed:
			dragging= false
			Singleton.emit_signal("tete_lachee", self, id)


	if dragging:
		tete.z_index= 1
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
		tete.z_index= 0
		tete.set_frame(0)
		tete.set_scale(Vector2(1,1))



func _on_Tete_area_entered(area):
#	printt(self, area)
	pass # Replace with function body.


func _on_Tete_area_exited(area):
	pass # Replace with function body.



func _on_explosion_animation_finished():
	self.queue_free()
