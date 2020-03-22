extends Node


signal increase_score
signal decrease_score
signal tete_lachee
signal mauvaise_poubelle
signal nouvelle_tete
signal good_poubelle
signal bad_poubelle


var score= 15
var tetes= {0:"juju", 1:"titi", 2:"guigui", 3:"noe"}
var poubelles= {0:"bleue", 1:"jaune", 2:"verte", 3:"rouge"}


var max_tetes= len(self.tetes)
var max_poubelles= len(self.poubelles)


var nb_tetes= 0
var over_list = {}
