extends Node2D

var tete_scene= preload("res://Tete.tscn")

func _ready():
	randomize()
	var tetes=[]
	
	for i in range (3):
		tetes.append(tete_scene.instance())
		tetes[-1].id= i
		
		var randx= 200+i*200 # 100 + randi()%850
		var randy= 200 #100 + randi()%200
		tetes[-1].set_position(Vector2(randx,randy))
		add_child(tetes[-1])
