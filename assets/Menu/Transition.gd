extends Node

@onready var anim: AnimationPlayer = $Anim
@export var new_scene = ""
var was_played = false

@onready var pause_menu: Control = $PauseMenu
@onready var on_btn: AudioStreamPlayer2D = $PauseMenu/On_btn
@onready var btn_click: AudioStreamPlayer2D = $PauseMenu/btn_click
var is_menu_open = false

signal anim_done

func _ready() -> void:
	anim.play("RESET")
	if pause_menu != null:
		pause_menu.visible = false
	is_menu_open = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("menu_toggle") and is_menu_open:
		is_menu_open = false
		if pause_menu != null:
			pause_menu.visible = false
	elif Input.is_action_just_pressed("menu_toggle"):
		is_menu_open = true
		if pause_menu != null:
			pause_menu.visible = true
	
	# TODO : what is this for?
	if was_played == false:
		anim.play_backwards("load_out")
		was_played = true

func load_in() -> void:
	anim.play_backwards("load_out")
	was_played = false

func load_out(target: String) -> void:
	anim.play("load_out")
	new_scene = target
	was_played = true

func change_scene(target: String):
	anim.play("load_out")
	new_scene = target

func _on_anim_animation_finished(anim_name: StringName) -> void:
	# TODO: this isn't how it should work 
	if anim_name == "load_out":
		get_tree().change_scene_to_file(new_scene)
	anim_done.emit()


func _on_resume_pressed() -> void:
	pause_menu.visible = false
	is_menu_open = false
	btn_click.play()


func _on_main_menu_mouse_entered() -> void:
	on_btn.play()
