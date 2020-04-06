extends Node

var chrono_label
var score_label
var nbtete_label

var score = 0
var timer
var deltatimer
var deltatimer2
var deltatimer3




var audio_clics = []
var audio_pops = []
var options_label


# crée les 2  tableaux contenant tous les sons (cris et pop)
func _populate_audio():
	for e in get_node("Audio/clics").get_children():
		audio_clics.append(e)
	for e in get_node("Audio/pops").get_children():
		audio_pops.append(e)


func _randomize_audio():
	audio_clics.shuffle()
	audio_pops.shuffle()


func _ready():
	Singleton.connect("increase_score", self, "increase_score")
	Singleton.connect("decrease_score", self, "decrease_score")
	Singleton.connect("mauvaise_poubelle", self, "_on_mauvaise_poubelle")
	Singleton.connect("game_over", self, "_on_game_over")

	# audio
	Singleton.connect("play_clic", self, "_play_clic")
	Singleton.connect("play_pop", self, "_play_pop")
	Singleton.connect("jeux_arcade", self, "_on_jeux_arcade")
	
	# tutoriel
	Singleton.connect("jeux_tutoriel", self, "_on_jeux_tutoriel")
	
	Singleton.connect("main_menu", self, "_on_main_menu")
	Singleton.connect("debut_pause", self, "_on_debut_pause")
	Singleton.connect("fin_pause", self, "_on_fin_pause")
	Singleton.connect("exit", self, "_on_exit")

	# ordre de mélanger les sons (nouvelle partie)
	Singleton.connect("randomize_audio", self, "_randomize_audio")

	# Plateau de jeu vidé : bonus !
	Singleton.connect("plateau_vide", self, "_on_plateau_vide")

	# supprimer têtes et poubelles
	Singleton.connect("clean_world", self, "_clean_world")

	# message de popup
	Singleton.connect("popup_message", self, "_popup_message")
	
	

	# import de tous les effets sonores
	_populate_audio()
	_randomize_audio()


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
	get_node("Tuto").set_visible(false)
	

func _clean_world():
	for element in get_node("Tetes").get_children():
		element.queue_free()
	for element in get_node("Poubelles").get_children():
		element.queue_free()


# quand le plateau est vidé : 3 nouvelles têtes + bonus
func _on_plateau_vide():
	# cas du tuto 1 → tuto 2
	if Singleton.tuto_state1:
		# print("signal → lancement tuto page 2")
		Singleton.emit_signal("jeux_tutoriel2")
	elif Singleton.tuto_state2:
		# print("signal → lancement tuto page 3")
		Singleton.emit_signal("jeux_tutoriel3")
	elif Singleton.tuto_state3:
		# print("signal → fin tuto")
		Singleton.emit_signal("fin_tuto")
	else:
		_nouvelle_tetes(3, 0.3)
	for _i in range(3):
		increase_score()


func _on_exit():
	get_tree().quit()


func _on_jeux_tutoriel():
	get_node("Main_menu").set_visible(false)
	get_node("Pause_menu").set_visible(false)
	get_node("Tuto").set_visible(true)
	# → Tuto.gd pour lancer le tuto
	Singleton.emit_signal("jeux_tutoriel1")


func _on_game_over():
	timer.stop()
	
	_clean_world()
	
	var texte = "Déjà fini ?!?"
	texte += "\n\nDommage pour toi..."
	texte += "\n\nTon score est de "
	texte += str(Singleton.score) + " points."
	texte += "\n\nEncore une partie ?"

	_popup_message(texte)


func _popup_message(texte):
	$GUI/Fin_partie.dialog_text = texte
	$GUI/Fin_partie.popup_centered(Vector2(200,100))
	


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
	


func _play_pop(id=null):
	if id == null:
		var random_index= randi() % audio_pops.size()
		audio_pops[random_index].play()
		# printt("audio:", random_index)
	else:
		audio_pops[id].play()



func _play_clic(id=null):
	if id == null:
		var random_index= randi() % audio_clics.size()
		audio_clics[random_index].play()
		# printt("audio:", random_index)
	else:
		audio_clics[id%audio_clics.size()].play()



func _on_deltatimer_timeout():
	_play_pop()
	Singleton.emit_signal("nouvelle_tete")


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
	var nb_famille= 0
	if Singleton.with_bouscadilla:
		nb_famille += 1
	if Singleton.with_pelpel:
		nb_famille += 1
	if Singleton.with_boubou:
		nb_famille += 1
	if Singleton.with_rourou:
		nb_famille += 1
	
	Singleton.score += nb_famille
	_update_score()


func decrease_score():
	Singleton.score -= 0
	_update_score()


func _update_score():
	score_label.set_text("Score : " + str(Singleton.score))
	pass


func _update_chrono():
	var duree= round(timer.get_time_left()*10)/10
	chrono_label.set_text("Compte à rebours.... " + str(duree)+ " s")


func _update_nbtete_label():
	nbtete_label.set_text("Fin de partie dans " + str(Singleton.fin_partie_max_tete - Singleton.nb_tetes) + " têtes")
	pass


func _process(delta):
	_update_chrono()
	_update_nbtete_label()
	pass


func _on_mauvaise_poubelle(id):
	Singleton.emit_signal("decrease_score")
	_nouvelle_tetes(3, 0.3)


func _on_jeux_arcade():
	print("nouvelle partie en cours de chargement")
	
	# supprime têtes et poubelles
	_clean_world()
	
	Singleton.init_game()
	index= 0
	bonus= 0

	get_node("Main_menu").set_visible(false)
	get_node("Pause_menu").set_visible(false)
	get_node("Tuto").set_visible(false)

	duree= duree_init
	# fin de la pause si le chrono a début démarré à une partie précédente
	timer.set_paused(false)
	timer.start(duree)
	_update_score()
	_update_chrono()

	_nouvelle_tetes(3, 0.3)


var duree_init= 2
var coef_init= 0.95
var duree_niv2= 3
var coef_niv2= 0.8
var duree_niv3= 2.5
var coef_niv3= 0.7
var duree_niv4= 2
var coef_niv4= 0.6
var duree

var index= 0
var bonus= 0

# définition des niveaux
func _on_timer_timeout():
	index += 1

	var tempo
	var nb_tete	
	if index < 20:
		tempo= duree * pow(coef_init, index)
		nb_tete= 1
	else:
		index= 0
		bonus += 1
		tempo= duree
		nb_tete= 1

	printt("index:", index, "bonus:", bonus, "tempo:", tempo)
	
	timer.start(tempo)
	_nouvelle_tetes(nb_tete + bonus)


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

