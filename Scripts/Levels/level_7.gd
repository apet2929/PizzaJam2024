extends LevelBase

var next_level_scene = "res://scenes/Levels/Level8.tscn"
var fence5_open = false

func _ready() -> void:
	super._ready()

func _process(delta) -> void:
	super._process(delta)
	var should_open_fence3 = true
	for plate in get_tree().get_nodes_in_group("fence3_pps"):
		if !plate.is_pressed:
			should_open_fence3 = false
	if should_open_fence3 and not $Fence3.open:
		$Fence3.open_fence()

func next_level(_body):
	super._next_level(next_level_scene)
	
func init_signals():
	EventBus.connect("button_pressed", self._on_button_pressed)
	EventBus.connect("button_unpressed", self._on_button_unpressed)

func _on_button_pressed(button, body) -> void:
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

func _on_button_unpressed(button, body) -> void:
	if button == $PressurePad3:
		if !fence5_open:
			$Fence5.close_fence()
		$Fence6.open_fence()
	elif button == $PressurePad:
		$Fence4.close_fence()
