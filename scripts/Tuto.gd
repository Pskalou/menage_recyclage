extends Node2D

# timer du speech
var tuto_speech_timer

# sprite animé
var perso


func _ready():
	# tutoriel en 3étapes
	Singleton.connect("jeux_tutoriel1", self, "_on_jeux_tutoriel1")
	Singleton.connect("jeux_tutoriel2", self, "_on_jeux_tutoriel2")
	Singleton.connect("jeux_tutoriel3", self, "_on_jeux_tutoriel3")
	Singleton.connect("fin_tuto", self, "_on_fin_tuto")

	# timer pour la durée de l'animation
	tuto_speech_timer = Timer.new()
	tuto_speech_timer.connect("timeout", self, "_on_fin_speech_tuto")
	add_child(tuto_speech_timer)


# fonction lancée à la fin du speech pour arrêter l'animation de la bouche
# appelée à la fin du timer
func _on_fin_speech_tuto():
	get_node("Perso").stop()
	get_node("Perso").set_frame(0)
	tuto_speech_timer.stop()


# efface les têtes et poubelles antérieures, affiche la bonne bulle
func _clean():
	get_node("Texte1").set_visible(Singleton.tuto_state1)
	get_node("Texte2").set_visible(Singleton.tuto_state2)
	get_node("Texte3").set_visible(Singleton.tuto_state3)
	# nettoyage éventuel des têtes et poubelle
	Singleton.emit_signal("clean_world")


# anime le personnage un certain temps
func _speech(time):
	# animation
	get_node("Perso").play()
	# duree du speech
	tuto_speech_timer.start(time)


# lance le tuto avec un nombre de tête initial 
# (sur un total de tête dispo et un total de poubelles)
func _start(nb_tete, total_tete, total_poubelle):
	# initialisation du jeu : 3 têtes et 3 poubelles
	Singleton.init_game(total_tete, total_poubelle)

	# affichage des têtes
	for _i in range(nb_tete):
		Singleton.emit_signal("nouvelle_tete")

	
# première partie du tuto
func _on_jeux_tutoriel1():
	print("page1")
	Singleton.tuto_state1= true
	Singleton.tuto_state2= false
	Singleton.tuto_state3= false
	
	_clean()
	_speech(2)
	# affiche 4 têtes sur 10 possible avec 1 poubelles
	_start(4, 10, 1)


# deuxième partie du tuto
func _on_jeux_tutoriel2():
	Singleton.tuto_state1= false
	Singleton.tuto_state2= true
	Singleton.tuto_state3= false
	
	_clean()
	_speech(3)
	# affiche 3 têtes sur 2 possible avec 2 poubelles
	_start(3,2,2)
	

# troisième partie du tutoriel
func _on_jeux_tutoriel3():
	Singleton.tuto_state1= false
	Singleton.tuto_state2= false
	Singleton.tuto_state3= true
	
	_clean()
	_speech(2)
	# affiche 2 têtes sur 3 possible avec 3 poubelles
	_start(2,3,3)


func _on_fin_tuto():
	Singleton.tuto_state1= false
	Singleton.tuto_state2= false
	Singleton.tuto_state3= false

	get_node("Texte1").set_visible(Singleton.tuto_state1)
	get_node("Texte2").set_visible(Singleton.tuto_state2)
	get_node("Texte3").set_visible(Singleton.tuto_state3)

	# nettoyage éventuel des têtes et poubelle
	Singleton.emit_signal("clean_world")

	set_visible(false)

	var texte = "Et voilà, à toi de jouer"
	texte += "\n\nBonne chance !"

	Singleton.emit_signal("popup_message", texte)
