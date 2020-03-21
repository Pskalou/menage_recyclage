extends Node2D

var poubelle_scene= preload("res://Poubelle.tscn")

func _ready():
	
	var poubelles=[]
	
	for i in range (4):
		poubelles.append(poubelle_scene.instance())
		poubelles[-1].id= i
		poubelles[-1].set_position(Vector2(200+i*200,425))
		add_child(poubelles[-1])
