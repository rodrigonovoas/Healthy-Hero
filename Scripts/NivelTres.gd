extends Node

#escenas a instanciar
const dorito = preload("res://Escenas/Dorito.tscn")
const donut = preload("res://Escenas/Donut.tscn")
const lollipop = preload("res://Escenas/Lollipop.tscn")
const perseguidor = preload("res://Escenas/Perseguidor.tscn")
const menu_emergente = preload("res://Escenas/MenuEmergente.tscn")

#nodos
onready var limitador_izquierda = self.get_node("Limitador/Fondo_Izquierda")
onready var limitador_derecha = self.get_node("Limitador/Fondo_Derecha")
onready var fin_label = self.get_node("Label")

#variables para manejar el  crear enemigos
var crear_dorito = true
var crear_donut = true
var crear_lollipop = true
var crear_perseguidor = true

#variables para contar el tiempo
var time = 0
var time_mult = 1.0
var temporizador

#variables de apoyo
var game_over
var empezar = false
var fin_juego = false

func _ready():
	randomize()
	game_over = false
	if VarGlobal.vidas > 0:
		VarGlobal.instanciar_personajePrincipal()
		VarGlobal.instanciar_contadorInicial()
	_instanciaEscenario()
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
			if crear_dorito == true:
				_crear_temporizadorDorito()
			if int(time) > 20 and crear_donut == true:
				_crear_temporizadorDonut()
			if int(time) > 40 and crear_lollipop == true:
				_crear_temporizadorLollipop()
			if int(time) > 90 and fin_juego == false:
				crear_dorito = false
				crear_donut = false
				crear_lollipop = false
				fin_label.visible = true
				fin_juego = true

func _crear_temporizadorDorito():
	crear_dorito = false
	temporizador = Timer.new()
	temporizador.one_shot = true
	temporizador.wait_time = 0.4
	temporizador.connect("timeout",self,"_on_DoritoTimer_timeout")
	add_child(temporizador)
	temporizador.start()

func _on_DoritoTimer_timeout():
	var instanciar_dorito = dorito.instance()
	var pos = Vector2()
	pos.x = rand_range(325,950)
	instanciar_dorito.position = pos
	self.add_child(instanciar_dorito)
	crear_dorito = true

func _crear_temporizadorDonut():
	crear_donut = false
	temporizador = Timer.new()
	temporizador.one_shot = true
	temporizador.wait_time = 5
	temporizador.connect("timeout",self,"_on_DonutTimer_timeout")
	add_child(temporizador)
	temporizador.start()

func _on_DonutTimer_timeout():
	var instanciar_donut = donut.instance()
	var pos = Vector2()
	pos.x = _randomizarLado(randi()%2)
	pos.y = rand_range(200,500)
	if pos.x == (limitador_izquierda.rect_position.x + limitador_izquierda.rect_size.x + 30):
		instanciar_donut.get_node("Body").direction = 1
	else:
		instanciar_donut.get_node("Body").direction = -1
	instanciar_donut.position = pos
	self.add_child(instanciar_donut)
	crear_donut = true
	pass

func _randomizarLado(numero):
	if numero == 0:
		return (limitador_izquierda.rect_position.x + limitador_izquierda.rect_size.x + 30)
	elif numero == 1:
		return limitador_derecha.rect_position.x - 30

func _crear_temporizadorLollipop():
	crear_lollipop = false
	temporizador = Timer.new()
	temporizador.one_shot = true
	temporizador.wait_time = 5
	temporizador.connect("timeout",self,"_on_LollipopTimer_timeout")
	add_child(temporizador)
	temporizador.start()

func _on_LollipopTimer_timeout():
	var instanciar_lollipop = lollipop.instance()
	var pos = Vector2()
	pos.x = rand_range(400,950)
	instanciar_lollipop.position = pos
	self.add_child(instanciar_lollipop)
	crear_lollipop = true
	pass

func _crear_temporizadorPerseguidor():
	crear_perseguidor = false
	temporizador = Timer.new()
	temporizador.one_shot = true
	temporizador.wait_time = 2
	temporizador.connect("timeout",self,"_crearPerseguidor")
	add_child(temporizador)
	temporizador.start()

func _crearPerseguidor():
	var instanciar_perseguidor = perseguidor.instance()
	var pos = Vector2()
	pos.x = get_viewport().size.x
	instanciar_perseguidor.position = pos
	self.add_child(instanciar_perseguidor)
	crear_perseguidor = true

func _instanciaEscenario():
	var suelo
	var suelo_nodo = preload("res://Escenas/Suelo.tscn")
	suelo = suelo_nodo.instance()
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