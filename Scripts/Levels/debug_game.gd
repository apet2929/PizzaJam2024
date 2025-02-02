extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_pressure_pad_pressed(_pad, _body) -> void:
	print("pressed 2")
	$Guillotine.drop()
	

func _on_pressure_pad_unpressed(_pad, _body) -> void:
	$Guillotine.undrop()
	
