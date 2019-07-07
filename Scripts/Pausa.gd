extends Control

var temporizador 

onready var label = self.get_node("Label")

func _input(event):
	if Input.is_action_pressed("ui_accept") and VarGlobal.pausado == true:
		get_tree().paused = false
		label.visible = false
		_crearTemporizador()


func _crearTemporizador():
	temporizador = Timer.new()
	temporizador.one_shot = true
	temporizador.wait_time = 1
	temporizador.connect("timeout",self,"_on_Timer_timeout")
	add_child(temporizador)
	temporizador.start()

func _on_Timer_timeout():
	VarGlobal.pausado = false
	self.queue_free()