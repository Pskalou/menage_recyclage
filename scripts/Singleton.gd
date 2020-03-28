extends Node


signal increase_score
signal decrease_score
signal tete_lachee
signal mauvaise_poubelle
signal nouvelle_tete
signal good_poubelle
signal bad_poubelle
signal game_over
signal play_clic

# from main_menu.gd → world.gd
signal jeux_arcade
signal jeux_tutoriel
signal jeux_histoire
signal exit

# from pause_menu.gd → world.gd
signal debut_pause
signal fin_pause
signal main_menu

signal init_poubelles


var score
var tetes = {}
var poubelles= {0:"bleue", 1:"jaune", 2:"verte", 3:"rouge"}
var fin_partie_max_tete
var with_bouscadilla= true
var with_pelpel = false
var with_boubou = false
var with_rourou = false
var tetes_pelpel
var tetes_bouscadilla
var tetes_boubou


var max_tetes
var max_poubelles


var nb_tetes= 0
var over_list = {}


func init_game():
    score= 0

    # TODO diminuer la tete1 de noe
    tetes_pelpel= ["guigui", "noe", "lucia"]
    tetes_boubou= ["bruno", "cecile", "lolo", "marius"]
    tetes_bouscadilla= ["titi", "juju"]
    
    
    tetes= {}
    fin_partie_max_tete = 30

    
    init_dict()
    
    nb_tetes= 0
    over_list = {}
    max_tetes= len(tetes)
    max_poubelles= len(poubelles)

    emit_signal("init_poubelles")


    
func init_dict():
    var temp= []
    if with_boubou:
        for e in tetes_boubou:
            temp.append(e)
    if with_bouscadilla:
        for e in tetes_bouscadilla:
            temp.append(e)
    if with_pelpel:
        for e in tetes_pelpel:
            temp.append(e)
    
    var i= 0
    while temp != [] :
        randomize()
        # print(temp)
        var index= randi() % len(temp)
        tetes[i]= temp[index]
        i = i + 1
        temp.remove(index)
    
    print(tetes)
        



func _on_label_entered(bouton_label:Label):
	var new_theme= load('res://assets/Theme_20_invert.tres')
	bouton_label.theme= new_theme
	
func _on_label_exited(bouton_label):
	var new_theme= load('res://assets/Theme_20.tres')
	bouton_label.theme= new_theme
