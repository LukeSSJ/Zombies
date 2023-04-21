extends CharacterBody2D

signal zombie_killed

@export var hp = 100
@export var WALK_SPEED = 80
@export var knockback_mod = 1.0
@export var damage = 30
@export var money_gained = 20
@export var Explosion: PackedScene

@onready var MaterialBuff = preload("res://zombie/MaterialBuff.tres")
@onready var Blood = preload("res://zombie/Blood.tscn")

@onready var AttackCol = $HitArea/CollisionShape2D

var dead = false
var target = Global.player
var hit_target
var knockback_vel = Vector2.ZERO
var buffed = false

func _ready():
	connect("zombie_killed", Callable(Global.root, "zombie_killed"))
	
	$HitArea.connect("body_entered", Callable(self, "attack"))
	$TimerTarget.connect("timeout", Callable(self, "find_target"))
	$TimerAttackReset.connect("timeout", Callable(self, "attack_reset"))

func _process(_delta):
	if not dead:
		look_at(target.position)
		set_velocity(Vector2(WALK_SPEED, 0).rotated(rotation) + knockback_vel)
		move_and_slide()
		knockback_vel = knockback_vel.lerp(Vector2.ZERO, 0.2)

func find_target():
	if position.distance_squared_to(Global.base.position) < position.distance_squared_to(Global.player.position):
		target = Global.base
	else:
		target = Global.player

func attack(body):
	body.get_hit(self)
	AttackCol.set_deferred("disabled", true)
	$TimerAttackReset.start()

func attack_reset():
	AttackCol.set_deferred("disabled", false)

func get_hit(other):
	if hp <= 0:
		return
	
	knockback_vel = Vector2(other.knockback, 0).rotated(other.rotation)
	knockback_vel *= knockback_mod
	
	var blood = Blood.instantiate()
	blood.position = global_position
	blood.rotation = rotation
	get_parent().add_child(blood)
	
	hp -= other.damage
	if hp <= 0:
		dead = true
		$CollisionShape2D.set_deferred("disabled", true)
		AttackCol.set_deferred("disabled", true)
		
		$TimerTarget.stop()
		$TimerAttackReset.stop()
		$TimerDelete.start()
		
		$Sprite2D.modulate.a = 0.5
		$Sprite2D.material = null
		
		$Splat.play()
		
		if Explosion:
			call_deferred("create_explosion")
		
		emit_signal("zombie_killed", self)
	
	if other.buff and not buffed:
		buffed = true
		WALK_SPEED *= 1.5
		damage *= 1.5
		$Sprite2D.material = MaterialBuff

func create_explosion():
	var explosion = Explosion.instantiate()
	explosion.position = global_position
	get_parent().add_child(explosion)
