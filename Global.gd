extends Node

var root
var player
var base

var can_pause = false

onready var Paused = $Paused

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	Paused.hide()

func _unhandled_key_input(event):
	if event.pressed and can_pause:
		if event.scancode == KEY_ESCAPE:
			var paused = not get_tree().paused
			get_tree().paused = paused
			Paused.visible = paused
		elif event.scancode == KEY_F4:
			OS.window_fullscreen = not OS.window_fullscreen
