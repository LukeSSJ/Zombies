extends Node

var root
var player
var base

var can_pause = false
var pause_from_esc = false

onready var Paused = $Paused

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	Paused.hide()

func _unhandled_key_input(event):
	if event.pressed and can_pause:
		if event.scancode == KEY_ESCAPE:
			toggle_pause()
		elif event.scancode == KEY_F4:
			OS.window_fullscreen = not OS.window_fullscreen

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		pause()
	elif what == MainLoop.NOTIFICATION_WM_FOCUS_IN:
		if not pause_from_esc:
			unpause()

func toggle_pause():
	if get_tree().paused:
		unpause()
		pause_from_esc = false
	else:
		pause()
		pause_from_esc = true

func pause():
	if can_pause:
		get_tree().paused = true
		Paused.visible = true

func unpause():
	get_tree().paused = false
	Paused.visible = false
