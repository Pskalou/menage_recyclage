extends Node

var chrono
var score_label
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
var duree_niv4= 5#2
var coef_niv4= 1#0.6
var duree


var index= 0

func _ready():
	Singleton.connect("increase_score", self, "increase_score")
	Singleton.connect("decrease_score", self, "decrease_score")
	Singleton.connect("mauvaise_poubelle", self, "_on_mauvaise_poubelle")
	
	score= Singleton.score
	score_label= get_node("GUI/Score")
	chrono= get_node("GUI/Chrono")
	
	_update_score()
	
	deltatimer = Timer.new()
	deltatimer.connect("timeout", self, "_on_deltatimer_timeout")
	add_child(deltatimer)
	deltatimer.set_one_shot(true)
	deltatimer2 = Timer.new()
	deltatimer2.connect("timeout", self, "_on_deltatimer_timeout")
	add_child(deltatimer2)
	deltatimer2.set_one_shot(true)
	deltatimer3 = Timer.new()
	deltatimer3.connect("timeout", self, "_on_deltatimer_timeout")
	add_child(deltatimer3)
	deltatimer3.set_one_shot(true)
	
	timer = Timer.new()
	timer.connect("timeout", self, "_on_timer_timeout")
	add_child(timer)
	timer.set_one_shot(true)
	timer.stop()
	
	$GUI/StartDialog.popup_centered(Vector2(250,100))


func _update_chrono():
	var duree= round(timer.get_time_left()*10)/10
	chrono.set_text("Compte à rebours.... " + str(duree)+ " s")



func _on_deltatimer_timeout():
	$Tetes/AudioStreamPlayer.play()
	Singleton.emit_signal("nouvelle_tete")
#	printt("BOOM", "score", score)


func _on_timer_timeout():
	index += 1
	print(index)
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
		_nouvelle_tetes(10)


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
	
	timers[0].start(durees[0])
	for _i in range(1, nb_total_tete):
#		printt("_i:",_i)
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


func _process(delta):
	_update_chrono()


func _on_StartDialog_confirmed():
	Singleton.emit_signal("begin_game")
	duree= duree_init
	timer.start(duree)
	_update_chrono()
	pass # Replace with function body.


func _on_mauvaise_poubelle(id):
	_nouvelle_tetes(3, 0.1)







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
