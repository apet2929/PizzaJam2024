extends StaticBody3D

@onready var hit_sfx: AudioStreamPlayer3D = $hit_SFX

func _on_spikes_body_entered(body: Node3D) -> void:
	EventBus.spike_entered.emit(self, body)
	
	if body.is_in_group("body"):
		hit_sfx.play()
