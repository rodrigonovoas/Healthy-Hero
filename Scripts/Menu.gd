extends Node

onready var selector = get_node("Selector")
onready var label_1 = get_node("Empezar")
onready var label_2 = get_node("Salir")

var empezar = true
var salir = false

func _process(delta):
	if Input.is_action_pressed("ui_up"):
		selector.position = label_1.rect_position - Vector2(40,-20)
		empezar = true
		salir = false
	elif Input.is_action_pressed("ui_down"):
		selector.position = label_2.rect_position - Vector2(40,-20)
		salir = true
		empezar = false

func _input(event):
	if Input.is_action_pressed("ui_accept"):
		if empezar == true:
			get_tree().change_scene("res://Escenas/NivelUno.tscn")
		elif salir == true:
			get_tree().quit()