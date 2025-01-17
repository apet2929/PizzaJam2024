extends Node3D

@export var color: Colors.COLOR
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print($Fence.open)
	$Fence.open_fence()
	await get_tree().create_timer(1).timeout
	print($Fence.open)
	$Fence.close_fence()
	print($Fence.open)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
