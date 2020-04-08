extends MarginContainer


var reprendre_label
var retour_label

var over_reprendre_label:bool
var over_retour_label:bool


func _ready():
	reprendre_label= get_node("HBoxContainer/VBoxContainer/CenterContainer/Modes_jeux/Reprendre_label")
	over_reprendre_label= false
	retour_label= get_node("HBoxContainer/VBoxContainer/CenterContainer/Modes_jeux/Retour_label")
	over_retour_label= false
	
	




func _on_Reprendre_pressed():
	Singleton.emit_signal("fin_pause")
	_on_Reprendre_mouse_exited()
	print("fin de pause: emit_signal('fin_pause')")

func _on_Reprendre_mouse_entered():
	over_reprendre_label= true
	Singleton._on_label_entered(reprendre_label)

func _on_Reprendre_mouse_exited():
	over_reprendre_label= false
	Singleton._on_label_exited(reprendre_label)


func _on_Retour_pressed():
	Singleton.emit_signal("main_menu")
	_on_Retour_mouse_exited()
	print("fin de pause: emit_signal('main_menu')")

func _on_Retour_mouse_entered():
	over_retour_label= true
	Singleton._on_label_entered(retour_label)
	
func _on_Retour_mouse_exited():
	over_retour_label= false
	Singleton._on_label_exited(retour_label)

