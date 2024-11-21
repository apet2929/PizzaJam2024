extends Node3D

const WORM_SCRIPT = preload("res://Scripts/new_worm.gd")
# Contains all the setup/interaction logic specific to this level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func is_worm(body):
	return body.get_script() == WORM_SCRIPT

func _on_button_small_button_pressed(button_id, body) -> void:
	if is_worm(body):
		$Fence.open_fence()

func _on_button_small_button_unpressed(button_id, body) -> void:
	if $Fence.open:
		$Fence.close_fence()

func _on_pressure_pad_body_entered(body: Node3D) -> void:
	if is_worm(body):
		$Guillotine.drop()
		
func _on_pressure_pad_pressed(pressure_pad, body) -> void:
	if pressure_pad == $PressurePad:
		$Guillotine.drop()

func _on_pressure_pad_unpressed(pressure_pad, body) -> void:
	if pressure_pad == $PressurePad:
		$Guillotine.undrop()
