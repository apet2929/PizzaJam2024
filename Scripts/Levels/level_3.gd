extends LevelBase

var next_level_scene = "res://scenes/Levels/Level4.tscn"

var buttons_that_close_the_fence = [
	"PressurePad", "PressurePad2", "PressurePad3",
	"PressurePad4", "PressurePad5", "PressurePad6"
]

func _ready() -> void:
	super._ready()

func _process(delta) -> void:
	var should_be_open = true
	for btn_name in buttons_that_close_the_fence:
		if get_node(btn_name).is_pressed:
			should_be_open = false
	
	if should_be_open and !$Fence.open:
		$Fence.open_fence()
	elif !should_be_open and $Fence.open:
		$Fence.close_fence()
	
			
	super._process(delta)

func next_level(_body):
	super._next_level(next_level_scene)
	
func init_signals():
	EventBus.connect("button_pressed", self._on_button_pressed)
	EventBus.connect("button_unpressed", self._on_button_unpressed)
	EventBus.connect("level_finished", next_level)

func _on_button_pressed(button: Node3D, _body) -> void:
	if buttons_that_close_the_fence.has(button.name):
		$Fence.close_fence()
	elif button == $PressurePad7:
		$Guillotine.drop()

func _on_button_unpressed(button, _body) -> void:
	if button == $PressurePad7:
		$Guillotine.undrop()
