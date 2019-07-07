extends KinematicBody2D

const GRAVITY = 1
const SPEED = 30

var direction = 1
var velocity = Vector2()
var temporizador
var continuar = false
var continuar_detector = true

onready var raycast = self.get_node("RayCast2D")
onready var detector = self.get_node("Detector/CollisionShape2D")


func _physics_process(delta):
	if self.is_on_floor() == false:
		velocity.x = 0
		velocity.y += GRAVITY * SPEED
		move_and_slide(velocity, Vector2(0, -1))
	else:
		_crear_temporizador()
		if raycast.is_colliding() == false and continuar == true:
			print("CAMBIO POR RAYCAST")
			direction = direction * (-1)
			raycast.position.x = raycast.position.x * (-1)
		velocity.x = 1 * 250 * direction
		velocity.y = 0
		move_and_slide(velocity, Vector2(0, -1))

func _crear_temporizador():
	temporizador = Timer.new()
	temporizador.one_shot = true
	temporizador.wait_time = 1
	temporizador.connect("timeout",self,"_on_Continuar_timeout")
	add_child(temporizador)
	temporizador.start()

func _on_Continuar_timeout():
	continuar = true
	pass

func _on_Detector_body_entered(body):
	if body.is_in_group("perseguidor") and continuar_detector == true:
		print("CAMBIO POR CONTACTO")
		direction = direction * (-1)
		raycast.position.x = raycast.position.x * (-1)
		continuar_detector = false
		_crear_temporizadorDetector()
	pass 

func _crear_temporizadorDetector():
	temporizador = Timer.new()
	temporizador.one_shot = true
	temporizador.wait_time = 1.5
	temporizador.connect("timeout",self,"_on_ContinuarDetector_timeout")
	add_child(temporizador)
	temporizador.start()

func _on_ContinuarDetector_timeout():
	continuar_detector = true
	pass
