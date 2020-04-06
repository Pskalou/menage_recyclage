extends MarginContainer


var tutoriel_label
var histoire_label
var arcade_label
var quitter_label


var over_tutoriel:bool
var over_histoire:bool
var over_arcade:bool
var over_quitter:bool

func _ready():
	tutoriel_label= get_node("HBoxContainer/VBoxContainer/CenterContainer/Modes_jeux/Tutoriel")
	over_tutoriel= false
	histoire_label= get_node("HBoxContainer/VBoxContainer/CenterContainer/Modes_jeux/Histoire")
	over_histoire= false
	arcade_label= get_node("HBoxContainer/VBoxContainer/CenterContainer/Modes_jeux/Arcade")
	over_arcade= false
	quitter_label= get_node("HBoxContainer/VBoxContainer/CenterContainer/Modes_jeux/Quitter")
	over_quitter= false
	

				
func _on_Tuto_button_pressed():
	Singleton.emit_signal("jeux_tutoriel1")
	_on_Tuto_button_mouse_exited()
	print("lancement jeux tutoriel")

func _on_Tuto_button_mouse_entered():
	over_tutoriel= true
	Singleton._on_label_entered(tutoriel_label)

func _on_Tuto_button_mouse_exited():
	over_tutoriel= false
	Singleton._on_label_exited(tutoriel_label)



func _on_Arcade_button_pressed():
	Singleton.emit_signal("jeux_arcade")
	_on_Arcade_button_mouse_exited()
	print("lancement jeux arcade")

func _on_Arcade_button_mouse_entered():
	over_arcade= true
	Singleton._on_label_entered(arcade_label)

func _on_Arcade_button_mouse_exited():
	over_arcade= false
	Singleton._on_label_exited(arcade_label)



func _on_Histoire_button_pressed():
	Singleton.emit_signal("jeux_histoire")
	_on_Histoire_button_mouse_exited()
	print("lancement jeux histoire")

func _on_Histoire_button_mouse_entered():
	over_histoire= true
	Singleton._on_label_entered(histoire_label)
	
func _on_Histoire_button_mouse_exited():
	over_histoire= false
	Singleton._on_label_exited(histoire_label)



func _on_Quitter_button_pressed():
	Singleton.emit_signal("exit")
	_on_Quitter_button_mouse_exited()
	print("quitter le jeux")

func _on_Quitter_button_mouse_entered():
	over_quitter= true
	Singleton._on_label_entered(quitter_label)

func _on_Quitter_button_mouse_exited():
	over_quitter= false
	Singleton._on_label_exited(quitter_label)



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
