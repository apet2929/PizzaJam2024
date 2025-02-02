extends Control

var is_visible = false
var level_scene: String

func _ready() -> void:
	self.visible = is_visible

func _process(_delta: float) -> void:
	self.visible = is_visible

func run():
	is_visible = true
	$AnimationPlayer.play("ui_visibility")

func _on_resume_pressed() -> void:
	get_parent().retry()
