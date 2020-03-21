extends Node2D

var tete_scene= preload("res://Tete.tscn")
var tetes=[]
	
func _ready():
	randomize()
	# qq têtes pour commencer	
	for i in range (10):
		add_tete(i)


func add_tete(id):
	tetes.append(tete_scene.instance())
	tetes[-1].set_id(id)
	
	var randx= 100 + randi()%850
	var randy= 100 + randi()%200
	tetes[-1].set_position(Vector2(randx,randy))
	add_child(tetes[-1])
	
