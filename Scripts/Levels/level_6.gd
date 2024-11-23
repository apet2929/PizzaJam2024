extends LevelBase

var next_level_scene = "res://scenes/Levels/Level7.tscn"
var num_finished = 0

func _ready() -> void:
	super._ready()

func _process(delta) -> void:
	super._process(delta)

func next_level(body):
	num_finished += 1
	body.kill()
	if num_finished == 2:
		super._next_level(next_level_scene)

func init_signals():
	EventBus.connect("level_finished", self.next_level)
	EventBus.connect("button_pressed", self._on_button_pressed)
	EventBus.connect("button_unpressed", self._on_button_unpressed)
	EventBus.connect("worm_died", self._on_worm_died)

func _on_worm_died(worm) -> void:	
	game_over()

func _on_button_pressed(button, body) -> void:
	if button == $PressurePad:
		$Fence.open_fence()

func _on_button_unpressed(button, body) -> void:
	if button == $PressurePad:
		$Fence.close_fence()
