extends RigidBody2D

func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free()
	pass 
