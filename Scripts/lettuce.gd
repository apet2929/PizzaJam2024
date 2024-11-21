extends Area3D

signal lettuce_body_entered(lettuce, body)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	print("foo")
	EventBus.lettuce_body_entered.emit(self, body)
	
