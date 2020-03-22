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

var score
var tetes = {}
var poubelles= {0:"bleue", 1:"jaune", 2:"verte", 3:"rouge"}
var fin_partie_max_tete
var with_pelpel:bool
var with_boubou:bool
var with_bouscadilla:bool
var tetes_pelpel
var tetes_bouscadilla
var tetes_boubou


var max_tetes
var max_poubelles


var nb_tetes= 0
var over_list = {}


func init_game():
    score= 0
    tetes_pelpel= ["guigui", "noe"]
    tetes_boubou= []
    tetes_bouscadilla= ["titi", "juju"]
    
    
    tetes= {}
    fin_partie_max_tete = 30

    with_pelpel = true
    with_boubou = false
    with_bouscadilla= true
    
    init_dict()
    
    nb_tetes= 0
    over_list = {}
    max_tetes= len(tetes)
    max_poubelles= len(poubelles)


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
    
    for _i in range(len(temp)):
        tetes[_i]= temp[_i]
    
