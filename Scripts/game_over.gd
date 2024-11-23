extends Control

var show = false
var level_scene: String

func _ready() -> void:
	self.visible = show

func _process(_delta: float) -> void:
	self.visible = show

func run():
	show = true
	$AnimationPlayer.play("ui_visibility")

func _on_resume_pressed() -> void:
	get_parent().retry()
