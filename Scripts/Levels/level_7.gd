extends LevelBase

var next_level_scene = "res://scenes/Levels/Level8.tscn"
var fence5_open = false

func _ready() -> void:
	super._ready()

func _process(delta) -> void:
	if Input.is_action_just_pressed("skip"):
		super._next_level(next_level_scene)
		return
	
	super._process(delta)


func next_level(body):
	if get_tree().get_nodes_in_group("head").size() != 1:
		body.kill()
	else:
		super._next_level(next_level_scene)

func init_signals():
	EventBus.connect("button_pressed", self._on_button_pressed)
	EventBus.connect("button_unpressed", self._on_button_unpressed)
	EventBus.connect("level_finished", self.next_level)

func _on_button_pressed(button, _body) -> void:
	if button == $ButtonSmall:
		$Guillotine.drop()
	if button == $ButtonSmall2:
		fence5_open = true
		$Fence5.open_fence()
	elif button == $PressurePad3:
		$Fence5.open_fence()
		$Fence6.close_fence()
	elif button == $PressurePad:
		$Fence4.open_fence()

func _on_button_unpressed(button, _body) -> void:
	if button == $PressurePad3:
		if !fence5_open:
			$Fence5.close_fence()
		$Fence6.open_fence()
	elif button == $PressurePad:
		$Fence4.close_fence()
