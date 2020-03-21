extends Node



var score_label
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	Singleton.connect("increase_score", self, "increase_score")
	score_label= get_node("GUI/Score")
	
	update_score()
	pass # Replace with function body.


func increase_score():
	self.score += 1
	update_score()


func update_score():
	score_label.set_text("Score : " + str(score))
	pass
