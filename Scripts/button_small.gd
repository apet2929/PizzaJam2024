extends Area3D


@export var button_id: String


@onready var WORM = preload("res://Scripts/worm_body.gd")

signal button_pressed
signal button_unpressed

var pressed = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed = false
	$Model/AnimationPlayer.play("ButtonUnpress")



func _on_body_entered(body: Node3D) -> void:
	print("foo")
	if is_worm(body):
		press()
		

func _on_body_exited(body: Node3D) -> void:
	print("bar")
	if is_worm(body):
		unpress()
			
func is_worm(body: Node3D) -> bool:
	match body.get_script():
		WORM:
			return true
		_:
			return false

func press():
	pressed = true
	print("Pressing")
	$Model/AnimationPlayer.play("ButtonPress")
	emit_signal("button_pressed", button_id)

func unpress():
	await get_tree().create_timer(2).timeout
	print("Unpressing")
	$Model/AnimationPlayer.play("ButtonUnpress")
	emit_signal("button_unpressed", button_id)
