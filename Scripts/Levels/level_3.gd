extends Node3D

# Design Courtesy of the Nutt
# There is no way to pass through this corridor with a length greater than 2

var buttons_pressed = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.connect("button_pressed", self._on_button_pressed)
	EventBus.connect("button_pressed", self._on_button_unpressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func _on_button_pressed(button, _body) -> void:
	if buttons_pressed.find(button) == -1:
		buttons_pressed.append(button)
		if $Fence.open:
			$Fence.close_fence()
	
func _on_button_unpressed(button, _body) -> void:
	buttons_pressed.erase(button)
	if buttons_pressed.is_empty():
		$Fence.open_fence()

# Guillotine
func _on_pressure_pad_7_pressed(_button, _body) -> void:
	$Guillotine.drop()

func _on_pressure_pad_7_unpressed(_button, _body) -> void:
	$Guillotine.undrop()
