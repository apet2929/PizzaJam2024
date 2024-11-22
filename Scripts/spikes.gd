extends StaticBody3D

func _on_spikes_body_entered(body: Node3D) -> void:
	EventBus.spike_entered.emit(self, body)
