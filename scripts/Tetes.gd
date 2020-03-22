extends Node2D

var tete_scene= preload("res://Tete.tscn")
var tetes=[]


func _ready():
	randomize()
	Singleton.connect("nouvelle_tete", self, "_on_nouvelle_tete")
#	Singleton.connect("begin_game", self, "_on_begin_game")
	Singleton.connect("good_poubelle", self, "_on_good_poubelle")
	Singleton.connect("bad_poubelle", self, "_on_bad_poubelle")
#
#
#func _on_begin_game():
#	# qq têtes pour commencer	
#	for i in range (1):
#		add_tete()


func _on_nouvelle_tete():
	Singleton.nb_tetes += 1
	printt("Tetes._on_nouvelle_tete:","nb_tete:",Singleton.nb_tetes)
	add_tete(randi())


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


func _on_good_poubelle(tete_node, tete_id):
#	printt("supprime", tete_node, "id:",tete_id)
	Singleton.over_list.erase(tete_node)
	tete_node.queue_free()
	Singleton.nb_tetes = max(Singleton.nb_tetes - 1, 0)
	
	Singleton.emit_signal("increase_score")


func _on_bad_poubelle(tete_node, tete_id):
	tete_node.input_pickable = false
	tete_node.z_index = 3
	tete_node.get_node("sprite").set_visible(false)
	tete_node.get_node("explosion").set_frame(0)
	tete_node.get_node("explosion").set_visible(true)
	tete_node.get_node("explosion").play()
	
	# Annonce à World que la poubelle est mauvaise	
	Singleton.emit_signal("mauvaise_poubelle", tete_id)
	Singleton.nb_tetes = Singleton.nb_tetes - 1

