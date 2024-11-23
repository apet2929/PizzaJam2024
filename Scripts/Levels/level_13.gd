extends LevelBase

var next_level_scene = "res://scenes/Levels/Level14.tscn"

func _ready() -> void:
	super._ready()

func _process(delta) -> void:
	super._process(delta)

func next_level(body):
	if body.has_crown:
		if get_tree().get_nodes_in_group("head").size() != 1:
			body.kill()
		else:
			super._next_level(next_level_scene)
			return

func init_signals():
	EventBus.connect("button_pressed", self._on_button_pressed)
	EventBus.connect("button_unpressed", self._on_button_unpressed)
	EventBus.connect("worm_died", self._on_worm_died)

func _on_button_pressed(button, body) -> void:
	if button == $ButtonSmall:
		$Guillotine.drop()
	if button == $ButtonSmall2:
		$Guillotine2.drop()
	

func _on_button_unpressed(button, body) -> void:
	pass

func _on_worm_died(worm) -> void:
	if worm.has_crown:
		game_over()
