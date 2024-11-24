extends LevelBase

var next_level_scene = "res://scenes/Levels/Level5.tscn"


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
	EventBus.connect("level_finished", self.next_level)

func _on_button_pressed(button, body) -> void:
	if button == $PressurePad:
		$Fence.open_fence()

func _on_button_unpressed(button, body) -> void:
	if button == $PressurePad:
		if $Fence.open:
			$Fence.close_fence()

		
