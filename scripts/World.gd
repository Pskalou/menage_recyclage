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
	
	Singleton.init_game()

	score= Singleton.score
	score_label= get_node("GUI/Score")
	chrono_label= get_node("GUI/Chrono")
	nbtete_label= get_node("GUI/Nbtetes")
	
	timer = Timer.new()
	timer.connect("timeout", self, "_on_timer_timeout")
	add_child(timer)
	timer.set_one_shot(true)
	timer.stop()
	
	_update_score()

	$GUI/Debut_partie.popup_centered(Vector2(200,100))


func _on_game_over():
	timer.stop()

	for e in get_node("Tetes").get_children():
		e.input_pickable = false

	var texte = "Plus de " + str(Singleton.fin_partie_max_tete)
	texte += " intrus ?!? C'est Beaucoup trop."
	texte += "\n\nDommage pour toi..."
	texte += "\n\nTon score est de "
	texte += str(Singleton.score) + " points."
	texte += "\n\nEncore une partie ?"
	$GUI/Fin_partie.dialog_text = texte
	$GUI/Fin_partie.popup_centered(Vector2(200,100))



func  _on_Fin_partie_confirmed():
	printt("fin de partie")
	_update_nbtete_label()
	_update_score()
	_on_StartDialog_confirmed()
	


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



func _on_StartDialog_confirmed():
#	Singleton.emit_signal("begin_game")
	for element in get_node("Tetes").get_children():
		element.queue_free()
	
	Singleton.init_game()

	duree= duree_init
	timer.start(duree)
	_update_chrono()
	
	_nouvelle_tetes(3, 0.3)
	pass # Replace with function body.


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
