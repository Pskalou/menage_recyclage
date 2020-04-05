extends Node2D

var tete_scene= preload("res://Tete.tscn")
var tetes=[]


func _ready():
	randomize()
	Singleton.connect("nouvelle_tete", self, "_on_nouvelle_tete")
	Singleton.connect("good_poubelle", self, "_on_good_poubelle")
	Singleton.connect("bad_poubelle", self, "_on_bad_poubelle")
	Singleton.connect("update_sprites_touched", self, "_update_sprites_list")


var sprites_list= []
var tete_to_move
var goog_poubelle_id

func _update_sprites_list(sprite):
	# ajoute la tête à déplacer dans la liste des têtes déplaçables
	sprites_list.append(sprite)
	print("tete_id=%d et poubelle_id=%d"%[sprite.get_id(), sprite.get_poubelle_id()])
	tete_to_move= choose_over_head()


# définir la tête à déplacer dans la liste des têtes 
func choose_over_head():
	var id= 0
	var head= null
	for e in sprites_list:
		if e.get_instance_id() > id:
			id= e.get_instance_id()
			head= e
	return head

# fonction utilisée pour savoir s'il y a des têtes à déplacer
func is_dragging():
	if sprites_list == []:
		return false
	else:
		return true


func _input(event):
	if event is InputEventMouseButton and not event.is_pressed():
		# si on était en train de déplacer une tête
		if is_dragging():
			# arrête la grimace
			tete_to_move.tete.set_frame(0)
			tete_to_move.tete.set_scale(Vector2(1,1))
			# signaler que la tete est posée
			# à destination de Poubelle
			Singleton.emit_signal("tete_lachee", tete_to_move, tete_to_move.get_poubelle_id()) 
			# vider la liste des têtes déplaçables
			sprites_list = []

	if event is InputEventMouseMotion:
		if is_dragging():
			# fait la grimace
			tete_to_move.tete.set_frame(1)
			tete_to_move.tete.set_scale(Vector2(1.2,1.2))
			# déplacer la tête du dessus
			tete_to_move.position= event.position
			# empêche la tête de sortir du cadre
			if tete_to_move.position.x < 100:
				tete_to_move.position.x= 100
			if tete_to_move.position.x> 950:
				tete_to_move.position.x= 950
			if tete_to_move.position.y < 100:
				tete_to_move.position.y= 100
			if tete_to_move.position.y > 500:
				tete_to_move.position.y= 500


func _on_nouvelle_tete():
	# printt("Tetes._on_nouvelle_tete:","nb_tete:",Singleton.nb_tetes)
	if Singleton.nb_tetes < Singleton.fin_partie_max_tete:
		add_tete()#randi())
	else:
		printt("game over")
		Singleton.emit_signal("game_over")


func add_tete(id=null):
	if Singleton.max_tetes == 0:
		return
	Singleton.nb_tetes += 1
	if id == null:
		id = randi() % (Singleton.max_tetes)
		# printt("choix aléatoire de tête:",id)
	
	tetes.append(tete_scene.instance())
	tetes[-1].set_id(id)
	
	var randx= 100 + randi()%850
	var randy= 100 + randi()%200
	tetes[-1].set_position(Vector2(randx,randy))
	add_child(tetes[-1])
	tetes[-1].z_index=-1


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

