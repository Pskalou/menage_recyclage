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
	# print("tete_id=%d et poubelle_id=%d"%[sprite.get_id(), sprite.get_poubelle_id()])
	# retourne l'unique tête à déplacer
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

# func _create_preview():
# 	printt("création de preview de ", tete_to_move)
# 	preview= tete_scene.instance()
# 	add_child(preview)
	
# fonction utilisée pour savoir s'il y a des têtes à déplacer
func is_dragging():
	if sprites_list == []:
		return false
	else:
		return true

var is_preview_present= false

var preview
func _input(event):
	if event is InputEventMouseButton:
		if  not event.is_pressed():
			# si on était en train de déplacer une tête
			if is_dragging():
				# arrête la grimace
				tete_to_move.tete.set_frame(0)
				tete_to_move.tete.set_scale(Vector2(1,1))
				tete_to_move.z_index= -1
				# signaler que la tete est posée
				# → Poubelle.gd
				Singleton.emit_signal("tete_lachee", preview, tete_to_move, tete_to_move.get_poubelle_id()) 
				# vider la liste des têtes déplaçables
				sprites_list = []
				# supprimer preview
				if is_preview_present:
					is_preview_present= false
					preview.queue_free()

	if event is InputEventMouseMotion:
		
		if is_dragging():


			if not is_preview_present:
				# fait la grimace
				tete_to_move.tete.set_frame(1)
				tete_to_move.tete.set_scale(Vector2(1.6,1.6))
				tete_to_move.z_index= 0
				# création de preview
				preview= tete_scene.instance()
				preview.set_id(tete_to_move.get_id())
				preview.set_modulate(Color(1,1,1,0.5))
				add_child(preview)
				is_preview_present= true

			tete_to_move.look_at(event.position)
			tete_to_move.rotation -= 1.5 

			# déplacer la tête du dessus
			preview.position= event.position
			# empêche la tête de sortir du cadre
			if preview.position.x < 100:
				preview.position.x= 100
			if preview.position.x> 950:
				preview.position.x= 950
			if preview.position.y < 100:
				preview.position.y= 100
			if preview.position.y > 500:
				preview.position.y= 500


# teste la fin de la partie (pourquoi ici)
# TODO déplacer dans World ?
func _on_nouvelle_tete():
	# printt("Tetes._on_nouvelle_tete:","nb_tete:",Singleton.nb_tetes)
	if Singleton.nb_tetes < Singleton.fin_partie_max_tete:
		add_tete()#randi())
	else:
		printt("game over")
		# → World : fin de partie
		Singleton.emit_signal("game_over")


# ajoute réellement une tête sur le plateau
func add_tete(id=null):
	if Singleton.max_tetes == 0:
		return
	Singleton.nb_tetes += 1
	if id == null:
		id = randi() % (Singleton.max_tetes)
		# printt("choix aléatoire de tête:",id)
	
	tetes.append(tete_scene.instance())
	tetes[-1].set_id(id)
	
	# en cas du tutoriel, ne pas mettre de tête trop à droite
	var randx
	if Singleton.tuto_state1 or Singleton.tuto_state2 or Singleton.tuto_state3 :
		randx= 100 + randi()%350
	else:
		randx= 100 + randi()%850
	var randy= 100 + randi()%200
	tetes[-1].set_position(Vector2(randx,randy))
	add_child(tetes[-1])
	tetes[-1].z_index=-1


func _on_good_poubelle(preview, tete_node, tete_id):
#	printt("supprime", tete_node, "id:",tete_id)
	# Singleton.over_list.erase(tete_node)
	_supprime_tete(preview, tete_node)
	Singleton.nb_tetes = max(Singleton.nb_tetes - 1, 0)
	
	Singleton.emit_signal("increase_score")


func _supprime_tete(preview, tete):
	tete.queue_free()

	


var Explosion = preload("res://Explosion.tscn")

func _on_bad_poubelle(tete_node, tete_id):

	var pos= tete_node.get_position()

	# suppression de la tête
	tete_node.queue_free()

	# animation de l'explosion
	var explosion= Explosion.instance()
	explosion.set_position(pos)
	add_child(explosion)
	explosion.play()


	# Annonce à World que la poubelle est mauvaise	
	Singleton.emit_signal("mauvaise_poubelle", tete_id)
	Singleton.nb_tetes = Singleton.nb_tetes - 1
