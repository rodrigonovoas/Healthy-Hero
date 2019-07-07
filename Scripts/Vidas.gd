extends Control

onready var label = self.get_node("Label")

func _physics_process(delta):
	label.text = "Vidas: " + str(VarGlobal.vidas)