extends "res://bullet/Bullet.gd"

@export var explosion_color = Color.WHITE

@onready var radius = $CollisionShape2D.shape.radius

func _ready():
	super()
	$Explosion.play()

func _draw():
	draw_circle(Vector2.ZERO, radius, explosion_color)

func make_inactive():
	$CollisionShape2D.set_deferred("disabled", true)
	hide()
