extends LevelBase

var next_level_scene = "res://scenes/Levels/Level2.tscn"

func _ready() -> void:
	super._ready()

func _process(delta) -> void:
	super._process(delta)

func next_level():
	super._next_level(next_level_scene)

func init_signals():
	EventBus.connect("button_pressed", self._on_button_pressed)
	EventBus.connect("button_unpressed", self._on_button_unpressed)

func _on_button_pressed(button, body) -> void:
	if button == $ButtonSmall:
		if !$Fence.open:
			$Fence.open_fence()
	elif button == $PressurePad:
		$Guillotine.drop()

func _on_button_unpressed(button, body) -> void:
	if button == $ButtonSmall:
		if $Fence.open:
			$Fence.close_fence()
	elif button == $PressurePad:
		$Guillotine.undrop()
