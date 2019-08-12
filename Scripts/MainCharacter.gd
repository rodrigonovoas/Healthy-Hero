extends KinematicBody2D

onready var animation = get_node("Sprite")
onready var audio = get_node("Audio")

const GRAVITY = 250
const WALK_SPEED = 230

var velocity = Vector2() 
var puede_saltar = true
var temporizador

func _physics_process(delta):
	velocity.y += delta * GRAVITY * 2

	if Input.is_action_just_pressed('saltar') and puede_saltar == true:
		velocity.y = - GRAVITY

	if self.is_on_floor() == false:
		if Input.is_action_just_pressed('saltar') and puede_saltar == true:
			velocity.y = - GRAVITY
			puede_saltar = false
	else:
		puede_saltar = true

	if Input.is_action_pressed("ui_left"):
		velocity.x = -WALK_SPEED
		animation.flip_h = true
		animation.play("run")
	elif Input.is_action_pressed("ui_right"):
		velocity.x =  WALK_SPEED
		animation.flip_h = false
		animation.play("run")
	else:
		velocity.x = 0
		animation.play("idle")

	move_and_slide(velocity, Vector2(0, -1))

func _on_Area2D_area_entered(area):
	if area.is_in_group("enemigos"):
		VarGlobal.vidas = VarGlobal.vidas - 1 
		get_tree().reload_current_scene()
		self.queue_free()
	pass 


func _on_Area2D_body_entered(body):
	if body.is_in_group("enemigos"):
		VarGlobal.vidas = VarGlobal.vidas - 1
		get_tree().reload_current_scene()
		self.queue_free()
	pass 

func _on_Audio_finished():
	audio.playing = true
	pass # Replace with function body.
