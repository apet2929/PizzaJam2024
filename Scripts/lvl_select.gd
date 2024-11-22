extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_available_levels()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_available_levels()
	
func update_available_levels():
	var lvls = get_levels()
	for lvl in lvls:
		get_node(lvl).visible = false

	for i in range(0, min(EventBus.levels_beaten.size()+1, lvls.size())):
		get_node(lvls[i]).visible = true

func get_levels():
	return [
		"LVL1", "LVL2", "LVL3",
		"LVL4", "LVL5", "LVL6",
		"LVL7", "LVL8", "LVL9",
		"LVL10"
	]
