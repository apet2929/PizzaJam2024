extends Node3D


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass



const LETTUCE_SCENE = preload("res://scenes/lettuce.tscn")
# Spawn lettuce
func _on_pressure_pad_9_pressed() -> void:
	var l = LETTUCE_SCENE.instantiate()
	#l.global_position = 
	pass # Replace with function body.
