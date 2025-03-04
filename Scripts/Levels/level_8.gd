extends LevelBase

var next_level_scene =  "res://scenes/Levels/Level9.tscn"

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

func _on_button_pressed(button, _body) -> void:
	if button == $PressurePad:
		$Fence.open_fence()
	elif button == $PressurePad2:
		$Fence2.open_fence()
	elif button == $PressurePad3:
		$Fence3.open_fence()
	elif button == $PressurePad7:
		$Guillotine.drop()
	elif button == $ButtonSmall:
		$Fence4.open_fence()

func _on_button_unpressed(button, _body) -> void:
	if button == $PressurePad:
		if $Fence.open:
			$Fence.close_fence()
	elif button == $PressurePad2:
		if $Fence2.open:
			$Fence2.close_fence()
	elif button == $PressurePad3:
		if $Fence3.open:
			$Fence3.close_fence()
	elif button == $PressurePad7:
		$Guillotine.undrop()
