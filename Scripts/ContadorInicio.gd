extends Control

var tiempo = 0
var time_mult = 1.0
var temporizador

onready var contador_label = self.get_node("Label")

func _process(delta):
	if int(tiempo) < 4:
		tiempo += delta * time_mult
		contador_label.text = str(int(tiempo))
	if int(tiempo) == 4:
		contador_label.text = "GO"
		_crearTemporizador()

func _crearTemporizador():
	temporizador = Timer.new()
	temporizador.one_shot = true
	temporizador.wait_time = 1
	temporizador.connect("timeout",self,"_on_Timer_timeout")
	add_child(temporizador)
	temporizador.start()

func _on_Timer_timeout():
	self.queue_free()