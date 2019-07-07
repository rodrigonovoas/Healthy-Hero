extends Node

onready var selector = get_node("Selector")
onready var label_1 = get_node("Continuar")
onready var label_2 = get_node("Salir")

var empezar = true
var salir = false

func _ready():
	selector.position = Vector2(label_1.position.x - 300, label_1.position.y)
	pass

func _input(event):
	if Input.is_action_pressed("ui_up"):
		selector.position = Vector2(label_1.position.x - 300, label_1.position.y)
		empezar = true
		salir = false
	elif Input.is_action_pressed("ui_down"):
		selector.position = Vector2(label_2.position.x - 300, label_2.position.y)
		salir = true
		empezar = false

	if Input.is_action_pressed("ui_accept"):
		if empezar == true:
			VarGlobal.vidas = 4
			get_tree().reload_current_scene()
			self.queue_free()
		elif salir == true:
			get_tree().quit()