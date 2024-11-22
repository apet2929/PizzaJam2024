extends LevelBase

var next_level_scene = null

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
	pass

func _on_button_unpressed(button, body) -> void:
	pass