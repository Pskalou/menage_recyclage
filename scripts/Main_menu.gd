extends MarginContainer


var tutoriel_label
var histoire_label
var arcade_label


var over_tutoriel:bool
var over_histoire:bool
var over_arcade:bool
func _ready():
	tutoriel_label= get_node("HBoxContainer/VBoxContainer/CenterContainer/Modes_jeux/Tutoriel")
	over_tutoriel= false
	histoire_label= get_node("HBoxContainer/VBoxContainer/CenterContainer/Modes_jeux/Histoire")
	over_histoire= false
	arcade_label= get_node("HBoxContainer/VBoxContainer/CenterContainer/Modes_jeux/Arcade")
	over_arcade= false
	





func _on_CenterContainer_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if over_arcade:
				Singleton.emit_signal("jeux_arcade")
				print("lancement jeux arcade")
			elif over_histoire:
				Singleton.emit_signal("jeux_histoire")
				print("lancement jeux histoire")
			elif over_tutoriel:
				Singleton.emit_signal("jeux_tutoriel")
				print("lancement jeux tutoriel")
			


func _on_label_entered(bouton_label:Label):
	var new_theme= load('res://assets/Theme_20_invert.tres')
	bouton_label.theme= new_theme
	
func _on_label_exited(bouton_label):
	var new_theme= load('res://assets/Theme_20.tres')
	bouton_label.theme= new_theme


func _on_Tutoriel_mouse_entered():
	over_tutoriel= true
	_on_label_entered(tutoriel_label)

func _on_Tutoriel_mouse_exited():
	over_tutoriel= false
	_on_label_exited(tutoriel_label)


func _on_Histoire_mouse_entered():
	over_histoire= true
	_on_label_entered(histoire_label)
	
func _on_Histoire_mouse_exited():
	over_histoire= false
	_on_label_exited(histoire_label)


func _on_Nouvelle_partie_mouse_entered():
	over_arcade= true
	_on_label_entered(arcade_label)

func _on_Nouvelle_partie_mouse_exited():
	over_arcade= false
	_on_label_exited(arcade_label)


func _on_Pelpel_pressed():
	Singleton.with_pelpel = not Singleton.with_pelpel
	printt("pelpel:",Singleton.with_pelpel)
	
func _on_Bouscadilla_pressed():
	Singleton.with_bouscadilla = not Singleton.with_bouscadilla
	printt("bouscadilla", Singleton.with_bouscadilla)

func _on_Rourou_pressed():
	Singleton.with_rourou = not Singleton.with_rourou
	printt("rourou:", Singleton.with_rourou)

func _on_Boubou_pressed():
	Singleton.with_boubou = not Singleton.with_boubou
	printt("boubou", Singleton.with_boubou)
