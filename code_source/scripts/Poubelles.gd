extends Node2D


var poubelle_scene= preload("res://Poubelle.tscn")


func _ready():
	Singleton.connect("init_poubelles", self, "init")
	pass
		

# placement des poubelles sur la scène
func init():
	var poubelles=[]

	# mélange des identifiants
	var ids=[]
	for _i in range (Singleton.max_poubelles): 
		ids.append(_i)
	ids.shuffle()
	
	for _i in range (Singleton.max_poubelles):
		poubelles.append(poubelle_scene.instance())
		poubelles[-1].id= ids[_i]
		poubelles[-1].set_position(Vector2(100+_i*275,465))
		poubelles[-1].z_index=1
		add_child(poubelles[-1])

