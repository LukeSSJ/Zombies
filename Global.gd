extends Node

var root
var player
var base

var can_pause = false
var pause_from_esc = false

@onready var Paused = $Paused

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	Paused.hide()

func _unhandled_key_input(event):
	if event.pressed and can_pause:
		if event.keycode == KEY_ESCAPE:
			toggle_pause()
		elif event.keycode == KEY_F4:
			get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (not ((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN))) else Window.MODE_WINDOWED

func _notification(what):
	if what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT:
		pause()
	elif what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_IN:
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
