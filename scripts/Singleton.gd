extends Node

signal update_sprites_touched
signal increase_score
signal decrease_score
signal tete_lachee

# → World : bonus + ajoute têtes
signal plateau_vide
signal mauvaise_poubelle
signal nouvelle_tete
signal good_poubelle
signal bad_poubelle
signal game_over
signal play_clic
signal play_pop
signal randomize_audio

# from main_menu.gd → world.gd
signal jeux_arcade
signal jeux_tutoriel1
signal jeux_tutoriel2
signal jeux_tutoriel3
var tuto_state1= false
var tuto_state2= false
var tuto_state3= false
signal jeux_histoire
signal exit

# from pause_menu.gd → world.gd
signal debut_pause
signal fin_pause
signal main_menu

signal init_poubelles


# mode tutoriel
var tuto_state= false

var score
var tetes = {}
var poubelles

var with_bouscadilla= true
var with_pelpel = true
var with_boubou = true
var with_rourou = true

var max_tetes
var max_poubelles

# nombre de têtes sur le jeu
var nb_tetes= 0


# initialise une partie avec pour paramètres :
#   * nb têtes à piocher
#   * nb poubelles disponibles


# TODO diminuer la tete1 de noe

# définition des varibales (à mettre à jour si nouvelle têtes ou poubelles)
# les sprites
var tetes_pelpel= ["guigui", "noe", "lucia", "emile"]
var tetes_boubou= ["bruno", "cecile", "lolo", "marius"]
var tetes_bouscadilla= ["titi", "juju"]
var tetes_rourou= ["guirou", "amelia", "elsa", "simon"]
var poubelles_disponibles= ["bleue", "jaune", "verte", "rouge"]
# condition de fin de partie
var fin_partie_max_tete = 30


func init_game(nb_tete= INF, nb_poubelle= INF):
    # score actuel
    score= 0
    # nombre de têtes sur la scène
    nb_tetes= 0

    # initialiser le dictionnaire des têtes
    # paramètre : nb de tête maxi
    init_dict_tetes(nb_tete)

    # initialise le dictionnaire des poubelles
    # paramètre : nb de poubelles à utiliser
    init_dict_poubelles(nb_poubelle)

    # mise à jour du nombre maximal de tete
    # et de poubelles
    max_tetes= len(tetes)
    max_poubelles= len(poubelles)

    # affichage des poubelles
    # → Poubelles.gd
    emit_signal("init_poubelles")

    # mélange des différents sons
    # → World.gd
    emit_signal("randomize_audio")


func update_game(nb_tete= INF, nb_poubelle= INF):
    # initialiser le dictionnaire des têtes
    # paramètre : nb de tête maxi
    update_dict_tetes(nb_tete)

    # initialise le dictionnaire des poubelles
    # paramètre : nb de poubelles à utiliser
    update_dict_poubelles(nb_poubelle)

    # mise à jour du nombre maximal de tete
    # et de poubelles
    max_tetes= len(tetes)
    max_poubelles= len(poubelles)

    # affichage des poubelles
    # → Poubelles.gd
    emit_signal("init_poubelles")

    
func update_dict_tetes(nb_tete):
    pass

func update_dict_poubelles(nb_poubelle):
    pass


# initialise le dictionnaire des poubelles
# paramètre : nb de poubelles à utiliser
func init_dict_poubelles(nb_poubelles= INF):
    var temp= poubelles_disponibles.duplicate()
    var n= min(nb_poubelles, len(temp))

    poubelles= {}
    for _i in range(n):
        var index= randi() % len(temp)
        poubelles[_i]= temp[index]
        _i = _i + 1
        temp.remove(index)
    
    # print(poubelles)


# initialiser le dictionnaire des têtes
# paramètre : nb de tête maxi
func init_dict_tetes(nb_tete= INF):
    # vide le conteneur de tetes
    tetes= {}
    # établir la liste de toutes les têtes disponilbles
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
    if with_rourou:
        for e in tetes_rourou:
            temp.append(e)
    
    # piocher parmis toutes les têtes disponible
    #  * soir nb_tete fois
    #  * soit mettre toutes les têtes
    var n= min(nb_tete, len(temp))
    for _i in range (n):
        randomize()
        var index= randi() % len(temp)
        tetes[_i]= temp[index]
        _i = _i + 1
        temp.remove(index)

    # print(tetes)
        



func _on_label_entered(bouton_label:Label):
	var new_theme= load('res://assets/Theme_20_invert.tres')
	bouton_label.theme= new_theme
	
func _on_label_exited(bouton_label):
	var new_theme= load('res://assets/Theme_20.tres')
	bouton_label.theme= new_theme
