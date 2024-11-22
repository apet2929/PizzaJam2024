extends Node

var restart_count = 0
var levels_beaten = {}
signal lettuce_body_entered(lettuce, body)
signal button_pressed(button, body)
signal button_unpressed(button, body)
signal level_finished
signal box_body_entered(box, body)
signal salt_body_entered(salt, body)
signal spike_entered(spike, body)
