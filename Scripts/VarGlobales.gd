extends Node

var menu_emergente = preload("res://Escenas/MenuEmergente.tscn")
var contador_inicio = preload("res://Escenas/ContadorInicio.tscn")
var pj_principal = preload("res://Escenas/MainCharacter.tscn")
var vidas = 3
var pausado = false


func instanciar_menuGameOver():
	var menu = menu_emergente.instance()
	self.get_node("../").add_child(menu)
	menu.set("z",0)
	return true

func instanciar_contadorInicial():
	var contador
	contador = contador_inicio.instance()
	get_tree().get_root().get_child(2).add_child(contador)

func instanciar_personajePrincipal():
	var pj = pj_principal.instance()
	pj.position.x = get_viewport().size.x 
	pj.position.y = get_viewport().size.y
	pj.set("z",0)
	get_tree().get_root().get_child(2).add_child(pj)