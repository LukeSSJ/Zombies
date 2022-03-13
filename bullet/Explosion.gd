extends "res://bullet/Bullet.gd"

export var explosion_color = Color.white

onready var radius = $CollisionShape2D.shape.radius

func _ready():
	$Explosion.play()

func _draw():
	draw_circle(Vector2.ZERO, radius, explosion_color)

func make_inactive():
	$CollisionShape2D.set_deferred("disabled", true)
	hide()
