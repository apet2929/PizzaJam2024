extends Area3D

func _on_body_entered(body: Node3D) -> void:
	EventBus.salt_body_entered.emit(self, body)
