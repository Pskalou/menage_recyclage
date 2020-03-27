extends MarginContainer


var reprendre_label
var retour_label

var over_reprendre_label:bool
var over_retour_label:bool


func _ready():
	reprendre_label= get_node("HBoxContainer/VBoxContainer/CenterContainer/Modes_jeux/Reprendre")
	over_reprendre_label= false
	retour_label= get_node("HBoxContainer/VBoxContainer/CenterContainer/Modes_jeux/Retour")
	over_retour_label= false
	
	





func _on_CenterContainer_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if over_reprendre_label:
				Singleton.emit_signal("fin_pause")
				_on_Reprendre_mouse_exited()
				print("fin de pause: emit_signal('fin_pause')")
			elif over_retour_label:
				Singleton.emit_signal("main_menu")
				_on_Retour_mouse_exited()
				print("fin de pause: emit_signal('main_menu')")
			




func _on_Reprendre_mouse_entered():
	over_reprendre_label= true
	Singleton._on_label_entered(reprendre_label)

func _on_Reprendre_mouse_exited():
	over_reprendre_label= false
	Singleton._on_label_exited(reprendre_label)


func _on_Retour_mouse_entered():
	over_retour_label= true
	Singleton._on_label_entered(retour_label)
	
func _on_Retour_mouse_exited():
	over_retour_label= false
	Singleton._on_label_exited(retour_label)

