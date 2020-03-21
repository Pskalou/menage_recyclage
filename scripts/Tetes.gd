extends Node2D

var tete_scene= preload("res://Tete.tscn")
var tetes=[]


func _ready():
	randomize()
	Singleton.connect("mauvaise_poubelle", self, "_on_mauvaise_poubelle")
	Singleton.connect("nouvelle_tete", self, "_on_nouvelle_tete")
	Singleton.connect("begin_game", self, "_on_begin_game")

func _on_begin_game():
	# qq têtes pour commencer	
	for i in range (10):
		add_tete(i)


func _on_nouvelle_tete():
	add_tete(randi())


func add_tete(id):
	tetes.append(tete_scene.instance())
	tetes[-1].set_id(id)
	
	var randx= 100 + randi()%850
	var randy= 100 + randi()%200
	tetes[-1].set_position(Vector2(randx,randy))
	add_child(tetes[-1])
	Singleton.nb_tetes += 1
	print (Singleton.nb_tetes)
#	print (tetes[-1])


func _on_mauvaise_poubelle(id):
	for i in range (3):
		add_tete(i)
