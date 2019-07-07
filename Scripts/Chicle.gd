extends KinematicBody2D

onready var sprite_inicial = get_node("SpriteInicial")
onready var sprite_final = get_node("SpriteFinal")
onready var collision_inicial = get_node("CollisionInicial")
onready var collision_final = get_node("CollisionFinal")

const GRAVITY = 4.9
const FLOOR = Vector2(0,-1)

var velocity = Vector2()
var speed = 250
var direction = 1
var timer
var impulso_inicial = true

func _physics_process(delta):
	if impulso_inicial == true:
		_impulsoInicial()
	if self.is_on_floor():
		sprite_inicial.visible = false
		sprite_final.visible = true
		collision_inicial.disabled = true
		collision_final.disabled = false
		impulso_inicial = false
		_crear_temporizador()

func _impulsoInicial():
	speed = rand_range(200,300)
	velocity.x = speed * direction
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity,FLOOR)

func _crear_temporizador():
	var temporizador
	temporizador = Timer.new()
	temporizador.one_shot = true
	temporizador.wait_time = 7
	temporizador.connect("timeout",self,"_on_Timer_timeout")
	add_child(temporizador)
	temporizador.start()

func _on_Timer_timeout():
	self.queue_free()
