extends LevelBase

var next_level_scene = "res://scenes/Levels/Level2.tscn"

func _ready() -> void:
	super._ready()

func _process(delta) -> void:
	super._process(delta)
	if Input.is_action_just_pressed("skip"):
		super._next_level(next_level_scene)
		return

func next_level(_body):
	super._next_level(next_level_scene)

func init_signals():
	EventBus.connect("button_pressed", self._on_button_pressed)
	EventBus.connect("button_unpressed", self._on_button_unpressed)
	EventBus.connect("level_finished", next_level)

func _on_button_pressed(button, body) -> void:
	print(button)
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
