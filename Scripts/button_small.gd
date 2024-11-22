extends Area3D


@export var button_id: String

@export var unpress_timer = 0.0
var pressed = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed = false
	$Model/AnimationPlayer.play("ButtonUnpress")

func press(body: Node3D):
	if !pressed:
		pressed = true
		$Model/AnimationPlayer.play("ButtonPress")
		EventBus.button_pressed.emit(self, body)

func unpress(body: Node3D):
	if unpress_timer >= 0:
		await get_tree().create_timer(unpress_timer).timeout
		$Model/AnimationPlayer.play("ButtonUnpress")
		EventBus.button_unpressed.emit(self, body)
		pressed = false

func _on_body_entered(body: Node3D) -> void:
	press(body)

func _on_body_exited(body: Node3D) -> void:
	unpress(body)
