extends Node2D

var tete_scene= preload("res://Tete.tscn")
var tetes=[]


func _ready():
	randomize()
	Singleton.connect("nouvelle_tete", self, "_on_nouvelle_tete")
	Singleton.connect("begin_game", self, "_on_begin_game")

func _on_begin_game():
	# qq têtes pour commencer	
	for i in range (1):
		add_tete()


func _on_nouvelle_tete():
	Singleton.nb_tetes += 1
	add_tete(randi())
	print (Singleton.nb_tetes)


func add_tete(id=null):
	
	if id == null:
		id = randi() % (Singleton.max_tetes)
		printt("choix aléatoire de tête:",id)
	
	tetes.append(tete_scene.instance())
	tetes[-1].set_id(id)
	
	var randx= 100 + randi()%850
	var randy= 100 + randi()%200
	tetes[-1].set_position(Vector2(randx,randy))
	add_child(tetes[-1])

