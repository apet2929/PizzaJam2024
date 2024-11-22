extends LevelBase

var next_level_scene = "res://scenes/Levels/Level4.tscn"

var buttons_that_close_the_fence = [
	"PressurePad", "PressurePad2", "PressurePad3",
	"PressurePad4", "PressurePad5", "PressurePad6"
]

func _ready() -> void:
	super._ready()

func _process(delta) -> void:
	super._process(delta)

func next_level():
	super._next_level(next_level_scene)
	
func init_signals():
	EventBus.connect("button_pressed", self._on_button_pressed)
	EventBus.connect("button_unpressed", self._on_button_unpressed)

func _on_button_pressed(button: Node3D, body) -> void:
	print(button)
	if buttons_that_close_the_fence.has(button.name):
		$Fence.close_fence()
	elif button == $PressurePad7:
		$Guillotine.drop()

func _on_button_unpressed(button, body) -> void:
	if buttons_that_close_the_fence.has(button.name):
		$Fence.open_fence()
	elif button == $PressurePad7:
		$Guillotine.undrop()
