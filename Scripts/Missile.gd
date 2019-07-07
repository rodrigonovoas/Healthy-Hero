extends KinematicBody2D

var time = 0
var time_mult = 1.0
var paused = false
var speed = 100
var velocity = Vector2()

onready var obj = get_tree().get_root().get_node("NivelTres/MainCharacter")

const GRAVITY = 1
const SPEED = 20

func _physics_process(delta):
	time += delta * time_mult
	if time < 4:
		var dir = (obj.global_position - global_position).normalized()
		move_and_collide(dir * speed * delta)
	else:
		velocity.x = 0
		velocity.y += GRAVITY * SPEED
		move_and_slide(velocity, Vector2(0, -1))

func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free()
	pass # Replace with function body.
