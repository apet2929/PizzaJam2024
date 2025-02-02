extends LevelBase

var next_level_scene = "res://scenes/Menu/YouWin.tscn"
const LETTUCE_SCENE = preload("res://scenes/lettuce.tscn")
var lettuce_dropped = false

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
	if button == $ButtonSmall:
		$Guillotine.drop()
		$Fence.open_fence()
	if button == $ButtonSmall2:
		$Guillotine2.drop()
		$Fence2.open_fence()
	elif button == $ButtonSmall4:
		$Fence3.open_fence()
	elif button == $ButtonSmall5:
		if !lettuce_dropped:
			var l = LETTUCE_SCENE.instantiate()
			l.position = $LettuceSpawnPosition.position
			var l2 = LETTUCE_SCENE.instantiate()
			l2.position = $LettuceSpawnPosition2.position
			add_child(l)
			add_child(l2)
			lettuce_dropped = true

func _on_button_unpressed(_button, _body) -> void:
	pass
