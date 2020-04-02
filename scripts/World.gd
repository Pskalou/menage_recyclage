extends Node

var chrono_label
var score_label
var nbtete_label

var score = 0
var timer
var deltatimer
var deltatimer2
var deltatimer3

var duree_init= 2
var coef_init= 0.6
var duree_niv2= 3
var coef_niv2= 0.8
var duree_niv3= 2.5
var coef_niv3= 0.7
var duree_niv4= 2
var coef_niv4= 0.6
var duree


var index= 0


var audio_clics = []
var audio_pops = []

var options_label

func _populate_audio():
	for e in get_node("Audio/clics").get_children():
		audio_clics.append(e)
	for e in get_node("Audio/pops").get_children():
		audio_pops.append(e)
	

func _ready():
	_populate_audio()
	Singleton.connect("increase_score", self, "increase_score")
	Singleton.connect("decrease_score", self, "decrease_score")
	Singleton.connect("mauvaise_poubelle", self, "_on_mauvaise_poubelle")
	Singleton.connect("game_over", self, "_on_game_over")
	Singleton.connect("play_clic", self, "_play_clic")
	Singleton.connect("jeux_arcade", self, "_on_jeux_arcade")
	Singleton.connect("jeux_tutoriel", self, "_on_jeux_tutoriel")

	# pause_menu.gd (faire pause, reprendre le jeux, retour accueil)
	Singleton.connect("main_menu", self, "_on_main_menu")
	Singleton.connect("debut_pause", self, "_on_debut_pause")
	Singleton.connect("fin_pause", self, "_on_fin_pause")
	Singleton.connect("exit", self, "_on_exit")
	

	# Singleton.init_game()

	score= Singleton.score
	score_label= get_node("GUI/Score")
	chrono_label= get_node("GUI/Chrono")
	nbtete_label= get_node("GUI/Nbtetes")
	options_label= get_node("GUI/Options_label")
	
	timer = Timer.new()
	timer.connect("timeout", self, "_on_timer_timeout")
	add_child(timer)
	timer.set_one_shot(true)
	timer.stop()
	
	_update_score()

	get_node("Main_menu").set_visible(true)
	get_node("Pause_menu").set_visible(false)
	


func _on_jeux_tutoriel():
	$GUI/Debut_partie.popup_centered(Vector2(200,100))


func _on_exit():
	get_tree().quit()


func _on_game_over():
	timer.stop()

	for e in get_node("Tetes").get_children():
		e.input_pickable = false

	var texte = "Déjà fini ?!?"
	texte += "\n\nDommage pour toi..."
	texte += "\n\nTon score est de "
	texte += str(Singleton.score) + " points."
	texte += "\n\nEncore une partie ?"
	$GUI/Fin_partie.dialog_text = texte
	$GUI/Fin_partie.popup_centered(Vector2(200,100))


	for e in get_node("Tetes").get_children():
		e.queue_free()
	
	for e in get_node("Poubelles").get_children():
		e.queue_free()




func _input(event):
	if(event.is_action_pressed("ui_cancel")):
		if is_paused:
			_on_fin_pause()
		elif get_node("Main_menu").visible == false :
			_on_debut_pause()



var is_paused= false

func _on_debut_pause():
	is_paused= true
	get_node("Pause_menu").set_visible(true)
	timer.set_paused(true)


func _on_fin_pause():
	is_paused= false
	get_node("Pause_menu").set_visible(false)
	timer.set_paused(false)


func _on_main_menu():
	_on_game_over()


func  _on_Fin_partie_confirmed():
	printt("fin de partie")
	_update_nbtete_label()
	_update_score()
	get_node("Main_menu").set_visible(true)
	get_node("Pause_menu").set_visible(false)
	


func play_pop(id=null):
	if id == null:
		var random_index= randi() % audio_pops.size()
		audio_pops[random_index].play()
		printt("audio:", random_index)
	else:
		audio_pops[id].play()



func _play_clic(id=null):
	if id == null:
		var random_index= randi() % audio_clics.size()
		audio_clics[random_index].play()
		printt("audio:", random_index)
	else:
		audio_clics[id].play()


func _on_deltatimer_timeout():
	play_pop()
	Singleton.emit_signal("nouvelle_tete")


func _on_timer_timeout():
	index += 1
	var score= Singleton.score
	
	if score < 3 :
		timer.start(duree)
	
	elif score < 6:
		timer.start(duree * coef_init)
		_nouvelle_tetes(1)
		
	elif score < 9:
		timer.start(duree_niv2 * coef_niv2)
		_nouvelle_tetes(2)
		
	elif score < 12:
		timer.start(duree_niv3 * coef_niv3)
		_nouvelle_tetes(2)
	
	else:
		timer.start(duree_niv4 * coef_niv4)
		_nouvelle_tetes(3)


func _nouvelle_tetes(nb_total_tete=1, coef_reducteur=0.5):
	var timers= []
	var durees= []
	
	for _i in range(nb_total_tete):
		timers.append( Timer.new() )
		timers[-1].connect("timeout", self, "_on_deltatimer_timeout")
		add_child(timers[-1])
		timers[-1].set_one_shot(true)
	
	for _i in range(nb_total_tete):
		durees.append(randf() * coef_reducteur)
	
	if timers != []:
		timers[0].start(durees[0])
		for _i in range(1, nb_total_tete):
			timers[_i].start(durees[_i-1] + durees[_i])


func increase_score():
	Singleton.score += 1
	_update_score()


func decrease_score():
	Singleton.score -= 1
	_update_score()


func _update_score():
	score_label.set_text("Score : " + str(Singleton.score))
	pass


func _update_chrono():
	var duree= round(timer.get_time_left()*10)/10
	chrono_label.set_text("Compte à rebours.... " + str(duree)+ " s")


func _update_nbtete_label():
	nbtete_label.set_text("Nombre total d'intrus : " + str(Singleton.nb_tetes))
	pass


func _process(delta):
	_update_chrono()
	_update_nbtete_label()
	pass



func _on_jeux_arcade():
	print("nouvelle partie en cours de chargement")
	for element in get_node("Tetes").get_children():
		element.queue_free()
	
	Singleton.init_game()

	get_node("Main_menu").set_visible(false)
	get_node("Pause_menu").set_visible(false)

	duree= duree_init
	timer.start(duree)
	_update_score()
	_update_chrono()
	
	_nouvelle_tetes(3, 0.3)
	


func _on_mauvaise_poubelle(id):
	Singleton.emit_signal("decrease_score")
	_nouvelle_tetes(3, 0.3)







########## TUTO

#Pour gagner, tu dois faire le ménage et supprimer tous les intrus.
#Mais il est très important de bien recycler et de choisir la bonne poubelle.
#
#Fais bien attention car si tu te trompes, de nouveaux intrus appaîtront...


# * 5 têtes / 2 différentes (titi & juju)
# * 3 poubelles


############# classique

# Niveau 1
#* < 5 points
#* 3 poubelles
#* 5 têtes / sur total nb de poubelle
#* le temps accélère
#
#Niveau 2
#* < 10 points
#* 4 poubelles
#* le temps accélère
#
#Niveau 3
#* < 15 points
#* 5 poubelles
#* le temps accélère
#
#Niveau 4
#* < 20 points
#* 6 poubelles
#* le temps accélère
#
#Niveau 5
#* < 25 points
#* 7 poubelles
#* le temps accélère
#





######### Histoire

var over_options_label= false

func _on_Options_mouse_entered():
	Singleton._on_label_entered(options_label)
	over_options_label= true
	pass # Replace with function body.


func _on_Options_mouse_exited():
	Singleton._on_label_exited(options_label)
	over_options_label= false
	pass # Replace with function body.


func _on_Options_pressed():
	Singleton.emit_signal("debut_pause")
	print("option menu")

