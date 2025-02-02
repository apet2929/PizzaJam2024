extends LevelBase

var next_level_scene = "res://scenes/Levels/Level2.tscn"

func _ready() -> void:
	super._ready()

func _process(delta) -> void:
	super._process(delta)
	if Input.is_action_just_pressed("skip"):
		super._next_level(next_level_scene)
		return

func next_level(body):
	if get_tree().get_nodes_in_group("head").size() != 1:
		body.kill()
	else:
		super._next_level(next_level_scene)

func init_signals():
	EventBus.connect("button_pressed", self._on_button_pressed)
	EventBus.connect("button_unpressed", self._on_button_unpressed)
	EventBus.connect("level_finished", next_level)

func _on_button_pressed(button, _body) -> void:
	print(button)
	if button == $ButtonSmall:
		if !$Fence.open:
			$Fence.open_fence()
	elif button == $PressurePad:
		$Guillotine.drop()

func _on_button_unpressed(button, _body) -> void:
	if button == $PressurePad:
		$Guillotine.undrop()
