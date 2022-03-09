extends Control

func _draw():
	var pos = get_global_mouse_position()
	draw_line(pos + Vector2(0, -5), pos + Vector2(0, -20), Color.white)
	draw_line(pos + Vector2(0, 5), pos + Vector2(0, 20), Color.white)
	draw_line(pos + Vector2(-5, 0), pos + Vector2(-20, 0), Color.white)
	draw_line(pos + Vector2(5, 0), pos + Vector2(20, 0), Color.white)

func _process(_delta):
	update()
