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
			pause(true)
		elif event.scancode == KEY_F4:
			OS.window_fullscreen = not OS.window_fullscreen

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		pause()

func pause(toggle=false):
	if not can_pause:
		return
		
	var paused = true
	if toggle:
		paused = not get_tree().paused
	get_tree().paused = paused
	Paused.visible = paused
