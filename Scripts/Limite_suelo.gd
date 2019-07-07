extends Area2D



func _on_Limite_suelo_body_entered(body):
	if body.name == 'MainCharacter':
		VarGlobal.vidas = VarGlobal.vidas - 1
		body.queue_free()
		get_tree().reload_current_scene()
	pass # Replace with function body.
