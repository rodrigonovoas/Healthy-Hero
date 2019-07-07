extends Node

#escenas a cargar
const golosina = preload("res://Escenas/Golosina.tscn")
const chicle = preload("res://Escenas/Chicle.tscn")
const regaliz = preload("res://Escenas/Regaliz.tscn")
const menu_emergente = preload("res://Escenas/MenuEmergente.tscn")

#nodos
onready var limitador_izquierda = self.get_node("Limitador/Fondo_Izquierda")
onready var limitador_derecha = self.get_node("Limitador/Fondo_Derecha")
onready var fin_label = self.get_node("Label")

#variables para manejar el crear enemigos
var crear_golosina = true
var crear_chicle = true
var crear_regaliz = true
var fin_nivel = false

#variables para contar el tiempo
var time = 0
var time_mult = 1.0
var temporizador

#variables de apoyo
var game_over = false
var empezar = false


func _ready():
	randomize()
	if VarGlobal.vidas > 0 and game_over == false:
		VarGlobal.instanciar_personajePrincipal()
		VarGlobal.instanciar_contadorInicial()
	_instanciaEscenario(1)
	set_process(true)
	pass

func _physics_process(delta):
	if VarGlobal.vidas == 0 and game_over == false:
		game_over = VarGlobal.instanciar_menuGameOver()
	if self.has_node("ContadorInicio") == false:
		empezar = true

func _process(delta):
	if empezar == true:
		if game_over == false:
			time += delta * time_mult
			if crear_golosina == true:
				_crear_temporizadorGolosina()
			if int(time) > 20 and crear_chicle == true:
				_crear_temporizadorChicle()
			if int(time) > 40 and crear_regaliz == true:
				_crear_temporizadorRegaliz()
			if int(time) > 60:
				fin_label.Visible = true
				crear_golosina = false
				crear_chicle = false
				crear_regaliz = false
				_crear_temporizadorFinNivel()
				if fin_nivel == true:
					get_tree().change_scene("res://Escenas/NivelDos.tscn")

func _instanciaEscenario(var fase):
	var suelo_nodo = preload("res://Escenas/Suelo.tscn")
	var suelo = suelo_nodo.instance()
	if fase == 1:
		suelo.anchor_left = 0.5
		suelo.anchor_right = 0.5
		suelo.anchor_top = 0.5
		suelo.anchor_bottom = 0.5
		var texture_size = suelo.get_size()
		suelo.margin_left = -texture_size.x / 2
		suelo.margin_right = -texture_size.x / 2
		suelo.margin_top = 275
		suelo.margin_bottom = -texture_size.y / 2
		self.add_child(suelo)
	elif fase == 2:
		suelo = self.get_node("Suelo")
		suelo.rect_scale.x = 0.80
		suelo.anchor_left = 0.5
		suelo.anchor_right = 0.5
		suelo.anchor_top = 0.5
		suelo.anchor_bottom = 0.5
		var texture_size = suelo.get_size()
		suelo.margin_left = -texture_size.x / 2
		suelo.margin_right = -texture_size.x / 2
		suelo.margin_top = 275
		suelo.margin_bottom = -texture_size.y / 2
	elif fase == 3:
		suelo = self.get_node("Suelo")
		suelo.rect_scale.x = 0.65
		suelo.anchor_left = 0.5
		suelo.anchor_right = 0.5
		suelo.anchor_top = 0.5
		suelo.anchor_bottom = 0.5
		var texture_size = suelo.get_size()
		suelo.margin_left = -texture_size.x / 2
		suelo.margin_right = -texture_size.x / 2
		suelo.margin_top = 275
		suelo.margin_bottom = -texture_size.y / 2
	elif fase == 4:
		suelo = self.get_node("Suelo")
		suelo.rect_scale.x = 0.50
		suelo.anchor_left = 0.5
		suelo.anchor_right = 0.5
		suelo.anchor_top = 0.5
		suelo.anchor_bottom = 0.5
		var texture_size = suelo.get_size()
		suelo.margin_left = -texture_size.x / 2
		suelo.margin_right = -texture_size.x / 2
		suelo.margin_top = 275
		suelo.margin_bottom = -texture_size.y / 2

func _crear_temporizadorGolosina():
	crear_golosina = false
	temporizador = Timer.new()
	temporizador.one_shot = true
	temporizador.wait_time = 0.25
	temporizador.connect("timeout",self,"_on_GolosinaTimer_timeout")
	add_child(temporizador)
	temporizador.start()

func _on_GolosinaTimer_timeout():
		var instanciar_golosina = golosina.instance()
		var pos = Vector2()
		pos.x = rand_range(350,925)
		instanciar_golosina.position = pos
		self.add_child(instanciar_golosina)
		crear_golosina = true

func _randomizarLado(numero):
	if numero == 0:
		return (limitador_izquierda.rect_position.x + limitador_izquierda.rect_size.x + 30)
	elif numero == 1:
		return limitador_derecha.rect_position.x - 30

func _crear_temporizadorChicle():
	crear_chicle = false
	temporizador = Timer.new()
	temporizador.one_shot = true
	temporizador.wait_time = 5
	temporizador.connect("timeout",self,"_on_ChicleTimer_timeout")
	add_child(temporizador)
	temporizador.start()

func _on_ChicleTimer_timeout():
		var instanciar_chicle = chicle.instance()
		var pos = Vector2()
		pos.x = _randomizarLado(randi()%2)
		pos.y = rand_range(200,400)
		if pos.x == (limitador_izquierda.rect_position.x + limitador_izquierda.rect_size.x + 30):
			instanciar_chicle.get_node("Body").direction = 1
		else:
			instanciar_chicle.get_node("Body").direction = -1
		instanciar_chicle.position = pos
		self.add_child(instanciar_chicle)
		crear_chicle = true

func _crear_temporizadorRegaliz():
	crear_regaliz = false
	temporizador = Timer.new()
	temporizador.one_shot = true
	temporizador.wait_time = 4
	temporizador.connect("timeout",self,"_on_RegalizTimer_timeout")
	add_child(temporizador)
	temporizador.start()

func _on_RegalizTimer_timeout():
	var instanciar_regaliz = regaliz.instance()
	var pos = Vector2()
	pos.x = rand_range(325,950)
	instanciar_regaliz.position = pos
	self.add_child(instanciar_regaliz)
	crear_regaliz = true

func _crear_temporizadorFinNivel():
	temporizador = Timer.new()
	temporizador.one_shot = true
	temporizador.wait_time = 3
	temporizador.connect("timeout",self,"_on_FinNivelTimer_timeout")
	add_child(temporizador)
	temporizador.start()

func _on_FinNivelTimer_timeout():
	fin_nivel = true