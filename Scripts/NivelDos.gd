extends Node

#escenas a cargar
const hotdog = preload("res://Escenas/HotDog.tscn")
const pizza = preload("res://Escenas/Pizza.tscn")
const patatas_gigantes = preload("res://Escenas/PatatasGigantes.tscn")
const menu_emergente = preload("res://Escenas/MenuEmergente.tscn")

#nodos
onready var fin_label = self.get_node("Label")

#variables para manejar el crear enemigos
var crear_hotdog = true
var crear_pizza = true
var crear_patatas = true
var crear_suelo = true

#variables para contar el tiempo
var time = 0
var time_mult = 1.0
var temporizador

#variables de apoyo
var fin_nivel = false
var segunda_fase = false
var ultimo_suelo 
var ultimo_sueloaux
var ultima_posicion_x = 0
var game_over
var empezar = false

func _ready():
	randomize()
	if VarGlobal.vidas > 0:
		VarGlobal.instanciar_personajePrincipal()
		VarGlobal.instanciar_contadorInicial()
	game_over = false
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
			if segunda_fase == false:
				if crear_hotdog == true:
					_crear_temporizadorHotdog()
				if int(time) > 15 and crear_pizza == true:
					_crear_temporizadorPizza()
				if int(time) > 40 and crear_patatas == true:
					_crear_temporizadorPatatas()
				if int(time) == 60:
					segunda_fase = true
			elif segunda_fase == true:
				if int(time) > 63 and int(time) < 80 and crear_suelo == true:
					_crear_temporizadorPlataformas()
				if int(time) > 80:
					fin_label.Visible = true
					crear_hotdog = false
					crear_pizza = false
					crear_patatas = false
					_crear_temporizadorFinNivel()
					if fin_nivel == true:
						get_tree().change_scene("res://Escenas/NivelDos.tscn")

func _crear_temporizadorHotdog():
	crear_hotdog = false
	temporizador = Timer.new()
	temporizador.one_shot = true
	temporizador.wait_time = 0.5
	temporizador.connect("timeout",self,"_on_HotdogTimer_timeout")
	add_child(temporizador)
	temporizador.start()

func _on_HotdogTimer_timeout():
	var cont = 0
	while cont < 3:
		var instanciar_hotdgot = hotdog.instance()
		var pos = Vector2()
		pos.x = rand_range(325,950)
		instanciar_hotdgot.position = pos
		self.add_child(instanciar_hotdgot)
		crear_hotdog = true
		cont = cont + 1
	pass

func _crear_temporizadorPizza():
	crear_pizza= false
	temporizador = Timer.new()
	temporizador.one_shot = true
	temporizador.wait_time = 5
	temporizador.connect("timeout",self,"_on_PizzaTimer_timeout")
	add_child(temporizador)
	temporizador.start()

func _on_PizzaTimer_timeout():
	var instanciar_pizza = pizza.instance()
	var pos = Vector2()
	pos.x = _randomizarLado(randi()%2)
	pos.y = 622
	if pos.x == 0:
		instanciar_pizza.direction = 1
		get_node("Sprite").flip_h = false
	else:
		instanciar_pizza.direction = -1
		instanciar_pizza.get_node("Sprite").flip_h = true
	instanciar_pizza.position = pos
	self.add_child(instanciar_pizza)
	crear_pizza = true
	pass

func _randomizarLado(numero):
	if numero == 0:
		return 0
	elif numero == 1:
		return 1280

func _crear_temporizadorPatatas():
	crear_patatas = false
	temporizador = Timer.new()
	temporizador.one_shot = true
	temporizador.wait_time = 5
	temporizador.connect("timeout",self,"_on_PatatasTimer_timeout")
	add_child(temporizador)
	temporizador.start()

func _on_PatatasTimer_timeout():
	var instanciar_patatas = patatas_gigantes.instance()
	var pos = Vector2()
	pos.x = rand_range(325,950)
	instanciar_patatas.position = pos
	self.add_child(instanciar_patatas)
	crear_patatas = true
	pass


func _instanciaEscenario():
	var suelo
	var suelo_nodo = preload("res://Escenas/SueloDos.tscn")
	suelo = suelo_nodo.instance()
	suelo.anchor_left = 0.5
	suelo.anchor_right = 0.5
	suelo.anchor_top = 0.5
	suelo.anchor_bottom = 0.5
	var texture_size = suelo.get_size()
	suelo.margin_left = -texture_size.x / 2
	suelo.margin_right = -texture_size.x / 2
	suelo.margin_top = 350
	suelo.margin_bottom = -texture_size.y / 2
	self.add_child(suelo)

func _crear_temporizadorPlataformas():
	crear_suelo = false
	temporizador = Timer.new()
	temporizador.one_shot = true
	temporizador.wait_time = 2
	temporizador.connect("timeout",self,"_instanciarPlataformas")
	add_child(temporizador)
	temporizador.start()
	
func _instanciarPlataformas(): 
	ultimo_sueloaux = ultimo_suelo
	_crear_temporizadorEliminarPlataforma()
	var suelo_nodo = preload("res://Escenas/SueloPequeno.tscn")
	var instanciar_suelo = suelo_nodo.instance()
	ultimo_suelo = instanciar_suelo
	instanciar_suelo.anchor_left = 0.5
	instanciar_suelo.anchor_right = 0.5
	instanciar_suelo.anchor_top = 0.5
	instanciar_suelo.anchor_bottom = 0.5
	var texture_size = instanciar_suelo.get_size()
	instanciar_suelo.margin_left = -texture_size.x / 2
	instanciar_suelo.margin_right = -texture_size.x / 2
	instanciar_suelo.margin_top = -texture_size.x / 2
	instanciar_suelo.margin_bottom = -texture_size.y / 2
	var pos = Vector2()
	pos.y =rand_range(220,300)
	if ultima_posicion_x == 0:
		pos.x = rand_range(-500,200)
		ultima_posicion_x = pos.x
	else:
		ultima_posicion_x = _devolverCoordenadasX(ultima_posicion_x)
		pos.x = ultima_posicion_x
	instanciar_suelo.rect_position = pos
	self.add_child(instanciar_suelo)
	crear_suelo = true
	pass

func _devolverCoordenadasX(num):
	var coordenada 
	if (randi()%2) == 0:
		coordenada = num + 220
	else:
		coordenada = num - 220
	if coordenada < -500:
		coordenada = num + 350
	elif coordenada > 200:
		coordenada = num - 350
	return coordenada

func _crear_temporizadorEliminarPlataforma():
	temporizador = Timer.new()
	temporizador.one_shot = true
	temporizador.wait_time = 1.2
	temporizador.connect("timeout",self,"_eliminarPlataforma")
	add_child(temporizador)
	temporizador.start()

func _eliminarPlataforma():
	if ultimo_sueloaux != null:
		ultimo_sueloaux.queue_free()
	else:
		self.get_node("SueloDos").queue_free()

func _crear_temporizadorFinNivel():
	temporizador = Timer.new()
	temporizador.one_shot = true
	temporizador.wait_time = 3
	temporizador.connect("timeout",self,"_on_FinNivelTimer_timeout")
	add_child(temporizador)
	temporizador.start()

func _on_FinNivelTimer_timeout():
	fin_nivel = true