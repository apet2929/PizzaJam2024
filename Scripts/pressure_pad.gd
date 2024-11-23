extends Area3D

var bodies = []
var is_pressed = false

signal pressed
signal unpressed

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("body") or body.is_in_group("head") or body.is_in_group("box"):
		bodies.append(body)
		
		if body.is_in_group("head") or body.is_in_group("box"):
			print("foo ", str(body))
			is_pressed = true
			pressed.emit(self, body)
			EventBus.button_pressed.emit(self, body)

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("body") or body.is_in_group("head") or body.is_in_group("box"):
		bodies.erase(body)
		if bodies.is_empty():
			is_pressed = false
			unpressed.emit(self, body)
			EventBus.button_unpressed.emit(self, body)
