extends KinematicBody2D

const GRAVITY = 4.9
const FLOOR = Vector2(0,-1)

var velocity = Vector2()
var speed = 200
var direction = 1
var timer
var impulso_inicial = true

func _physics_process(delta):
	if impulso_inicial == true:
		_impulsoInicial()

func _impulsoInicial():
	speed = rand_range(250,500)
	velocity.x = speed * direction
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity,FLOOR)

func _on_Timer_timeout():
	self.queue_free()
