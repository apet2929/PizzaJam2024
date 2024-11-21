extends Node

signal lettuce_body_entered(lettuce, body)
signal button_pressed(button, body)
signal button_unpressed(button, body)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("EventBus entered")
