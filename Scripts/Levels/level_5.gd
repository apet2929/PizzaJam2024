extends LevelBase

var next_level_scene = "res://scenes/Levels/Level6.tscn"

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
	EventBus.connect("level_finished", self.next_level)
	EventBus.connect("spike_entered", self._on_spike_entered)

func _on_button_pressed(button, _body) -> void:
	if button == $ButtonSmall:
		$Guillotine.drop()
		$Fence.open_fence()

func _on_button_unpressed(button, _body) -> void:
	if button == $ButtonSmall:
		$Guillotine.drop()

func _on_spike_entered(_spike, body) -> void:
	if is_worm(body):
		EventBus.emit_signal("game_over")
