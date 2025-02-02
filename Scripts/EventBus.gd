extends Node

var restart_count = 0
var levels_beaten = []
@warning_ignore("unused_signal")
signal lettuce_body_entered(lettuce, body)
@warning_ignore("unused_signal")
signal button_pressed(button, body)
@warning_ignore("unused_signal")
signal button_unpressed(button, body)
@warning_ignore("unused_signal")
signal level_finished(body)
@warning_ignore("unused_signal")
signal box_body_entered(box, body)
@warning_ignore("unused_signal")
signal salt_body_entered(salt, body)
@warning_ignore("unused_signal")
signal spike_entered(spike, body)
@warning_ignore("unused_signal")
signal worm_died(worm)
@warning_ignore("unused_signal")
signal game_over
