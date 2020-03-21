extends Node


var score_label
var score = 0


func _ready():
	Singleton.connect("increase_score", self, "increase_score")
	Singleton.connect("decrease_score", self, "decrease_score")
	score_label= get_node("GUI/Score")

	update_score()


func increase_score():
	self.score += 1
	update_score()


func decrease_score():
	self.score -= 1
	update_score()


func update_score():
	score_label.set_text("Score : " + str(score))
	pass
