extends KinematicBody2D

const GRAVITY = 1
const SPEED = 10

var velocity = Vector2()
var direction = 1


func _physics_process(delta):
	velocity.x += 1 * direction * SPEED
	velocity.y = 0
	move_and_slide(velocity, Vector2(0, -1))


func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free()
	pass 