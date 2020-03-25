extends Node2D


var poubelle_scene= preload("res://Poubelle.tscn")


func _ready():
	Singleton.connect("init_poubelles", self, "init")
	pass
		

func init():
	var poubelles=[]
	
	for i in range (4):
		poubelles.append(poubelle_scene.instance())
		poubelles[-1].id= i
		poubelles[-1].set_position(Vector2(100+i*275,465))
		poubelles[-1].z_index=1
		add_child(poubelles[-1])

