extends Area3D


@export var button_id: String


@onready var WORM = preload("res://Scripts/new_worm.gd")

signal button_pressed
signal button_unpressed

@export var unpress_timer = 0.0
var pressed = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed = false
	$Model/AnimationPlayer.play("ButtonUnpress")

func is_worm(body: Node3D) -> bool:
	match body.get_script():
		WORM:
			return true
		_:
			return false

func press(body: Node3D):
	pressed = true
	print("Pressing")
	$Model/AnimationPlayer.play("ButtonPress")
	emit_signal("button_pressed", button_id, body)

func unpress(body: Node3D):
	await get_tree().create_timer(unpress_timer).timeout
	print("Unpressing")
	$Model/AnimationPlayer.play("ButtonUnpress")
	emit_signal("button_unpressed", button_id, body)


func _on_body_entered(body: Node3D) -> void:
	press(body)


func _on_body_exited(body: Node3D) -> void:
	unpress(body)
