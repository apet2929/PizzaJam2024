extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	preload_assets()
	update_available_levels()

func preload_assets():
	preload("res://assets/3d_btn_material.tres")
	preload("res://assets/guillotine.glb")
	preload("res://assets/bird.glb")
	preload("res://assets/box.glb")
	preload("res://assets/lettuce.glb")
	preload("res://assets/Button_Model.glb")
	preload("res://assets/button_small.glb")
	preload("res://assets/fence.glb")
	preload("res://assets/salt.glb")
	preload("res://assets/spikes.glb")
	preload("res://scenes/Levels/Level1.tscn")

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
