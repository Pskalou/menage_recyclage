extends Node

var chrono
var score_label
var score = 0
var timer
var deltatimer

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

func _ready():
	Singleton.connect("increase_score", self, "increase_score")
	Singleton.connect("decrease_score", self, "decrease_score")
	score_label= get_node("GUI/Score")
	chrono= get_node("GUI/Chrono")

	update_score()
	
	
	deltatimer = Timer.new()
	deltatimer.connect("timeout", self, "_on_deltatimer_timeout")
	add_child(deltatimer)
	deltatimer.set_one_shot(true)
	deltatimer.start(1)
	
	
	timer = Timer.new()
	timer.connect("timeout", self, "_on_timer_timeout")
	add_child(timer)
	timer.set_one_shot(true)
	
	$GUI/StartDialog.popup_centered(Vector2(250,100))
	


func update_chrono():
	var duree= round(timer.get_time_left()*10)/10
	chrono.set_text("Compte à rebours >>> " + str(duree)+ " s")


func _on_deltatimer_timeout():
	$Tetes/AudioStreamPlayer2D.play()
	Singleton.emit_signal("nouvelle_tete")
	printt("BOOM", "score", score)
	
	
func _on_timer_timeout():
	index += 1
	print(index)
	var score= Singleton.score
	
	if score < 3 :
		timer.start(duree)
	
	elif score < 6:
		
		timer.start(duree * coef_init)
		
		deltatimer.start(randf()/2)
#		$Tetes/AudioStreamPlayer2D.play()
#		Singleton.emit_signal("nouvelle_tete")
	elif score < 9:
		timer.start(duree_niv2 * coef_niv2)
		
		
		deltatimer.start(randf()/2)
#		$Tetes/AudioStreamPlayer2D.play()
#		Singleton.emit_signal("nouvelle_tete")
		
		deltatimer.start(randf()/2)
		
	elif score < 12:
		timer.start(duree_niv3 * coef_niv3)
		
		
		deltatimer.start(randf()/2)
#		$Tetes/AudioStreamPlayer2D.play()
#		Singleton.emit_signal("nouvelle_tete")
#		printt("BOOM", "score", score)

		deltatimer.start(randf()/2)
	
	else:
		timer.start(duree_niv4 * coef_niv4)
		
		
		deltatimer.start(randf()/2)
#		$Tetes/AudioStreamPlayer2D.play()
#		Singleton.emit_signal("nouvelle_tete")
#		printt("BOOM", "score", score)
		
		deltatimer.start(randf()/1.5)
	
		deltatimer.start(randf()/1.5)
		
		
		
	
		


func increase_score():
	Singleton.score += 1
	update_score()


func decrease_score():
	Singleton.score -= 1
	update_score()


func update_score():
	score_label.set_text("Score : " + str(Singleton.score))
	pass


func _on_ConfirmationDialog_confirmed():
	
	pass # Replace with function body.


func _process(delta):
	update_chrono()


func _on_StartDialog_confirmed():
	Singleton.emit_signal("begin_game")
	duree= duree_init
	timer.start(duree)
	update_chrono()
	pass # Replace with function body.
