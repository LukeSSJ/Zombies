extends Area2D

export var BULLET_SPEED = 1200
export var knockback = 400
export var free_on_hit = true
export (PackedScene) var Explosion
export var buff = false

var vel = Vector2.ZERO
export var damage = 40

func _ready():
	connect("body_entered", self, "hit_zombie")
	vel = Vector2(BULLET_SPEED, 0).rotated(rotation)

func _process(delta):
	position += vel * delta

func hit_zombie(zombie):
	if is_queued_for_deletion():
		return
	
	zombie.get_hit(self)
	if free_on_hit:
		queue_free()
	
	if Explosion:
		call_deferred("create_explosion")

func create_explosion():
	var explosion = Explosion.instance()
	explosion.position = global_position
	get_parent().add_child(explosion)
