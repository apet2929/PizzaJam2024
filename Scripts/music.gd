extends Node

enum States {
	MENU,
	GAME
}

var state
var transition_queued = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state = States.MENU
	$MenuMusic.play()
	set_volume(0)

func game_state():
	if state == States.MENU:
		transition_queued = true
	state = States.GAME

func menu_state():
	state = States.MENU
	transition_queued = false

func set_volume(val: float):
	$MenuMusic.volume_db = linear_to_db(val)
	$GameMusic.volume_db = linear_to_db(val)
	$TransitionMusic.volume_db = linear_to_db(val) 

func _on_menu_music_finished() -> void:
	if state == States.MENU:
		$MenuMusic.play()
	if transition_queued:
		$TransitionMusic.play()

func _on_game_music_finished() -> void:
	if state == States.MENU:
		$MenuMusic.play()
	else:
		$GameMusic.play()

func _on_transition_music_finished() -> void:
	if transition_queued:
		transition_queued = false
		$GameMusic.play()
	else:
		$MenuMusic.play()
