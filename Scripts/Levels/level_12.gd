extends LevelBase

var next_level_scene = "res://scenes/Levels/Level1.tscn"
const LETTUCE_SCENE = preload("res://scenes/lettuce.tscn")
var lettuce_dropped = false

func _ready() -> void:
	super._ready()

func _process(delta) -> void:
	super._process(delta)

func next_level(body):
	print("foo")
	if body.has_crown:
		if get_tree().get_nodes_in_group("head").size() != 1:
			body.kill()
		else:
			super._next_level(next_level_scene)
			return
	get_tree().get_nodes_in_group("head")[0].has_crown = true

func init_signals():
	EventBus.connect("button_pressed", self._on_button_pressed)
	EventBus.connect("button_unpressed", self._on_button_unpressed)
	EventBus.connect("level_finished", self.next_level)


func _on_button_pressed(button, body) -> void:
	if button == $ButtonSmall:
		$Guillotine.drop()
		$Fence.open_fence()
	elif button == $ButtonSmall4:
		$Fence3.open_fence()
	elif button == $ButtonSmall5:
		if !lettuce_dropped:
			var l = LETTUCE_SCENE.instantiate()
			l.position = $LettuceSpawnPosition.position
			var l2 = LETTUCE_SCENE.instantiate()
			l.position = $LettuceSpawnPosition2.position
			add_child(l)
			add_child(l2)
	elif button == $ButtonSmall6:
		$Fence2.open_fence()

func _on_button_unpressed(button, body) -> void:
	pass
