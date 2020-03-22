extends Node


signal increase_score
signal decrease_score
signal tete_lachee
signal mauvaise_poubelle
signal nouvelle_tete
signal good_poubelle
signal bad_poubelle
signal game_over


var score= 15
var tetes= {0:"juju", 1:"titi", 2:"guigui", 3:"noe"}
var poubelles= {0:"bleue", 1:"jaune", 2:"verte", 3:"rouge"}
var fin_partie_max_tete = 10
var pelpel = true
var boubou = false
var bouscadilla= true


var max_tetes= len(self.tetes)
var max_poubelles= len(self.poubelles)


var nb_tetes= 0
var over_list = {}

func init_game():
    score= 15
    tetes= {0:"juju", 1:"titi", 2:"guigui", 3:"noe"}
    poubelles= {0:"bleue", 1:"jaune", 2:"verte", 3:"rouge"}
    fin_partie_max_tete = 10
    pelpel = true
    boubou = false
    bouscadilla= true
    nb_tetes= 0
    over_list = {}

