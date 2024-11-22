extends Node

@export var scene_path = "res://"
@onready var scene_transition: CanvasLayer = $"../SceneTransition"
@onready var select_arrow: Node3D = $Select_Arrow
@onready var gfx: CSGBox3D = $gfx
@onready var on_btn_sfx: AudioStreamPlayer2D = $"On_btn"
@onready var btn_click: AudioStreamPlayer2D = $"btn_click"

@export var quit_btn = false
var on_btn = false

func _ready() -> void:
	select_arrow.visible = false

func _process(delta: float) -> void:
	if on_btn and Input.is_action_just_pressed("left_click"):
		if quit_btn:
			get_tree().quit()
		
		btn_click.play()
		scene_transition.change_scene(scene_path)


func _on_mouse_entered() -> void:
	on_btn = true
	select_arrow.visible = true
	on_btn_sfx.play()

func _on_mouse_exited() -> void:
	on_btn = false
	select_arrow.visible = false
