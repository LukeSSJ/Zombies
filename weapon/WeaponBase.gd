extends Node2D

signal ammo_changed

@export var weapon_name = "WEAPON"
@export var max_ammo = 12
@export var is_full_auto = false
@export var damage = 40
@export var shotgun = false
@export var Bullet: PackedScene

@onready var MuzzleFlash = $MuzzleFlash
@onready var PointShoot = $PointShoot
@onready var TimerShoot = $TimerShoot
@onready var TimerFlash = $TimerFlash
@onready var AP = $AP
@onready var Gunshot = $Gunshot

var ammo
var can_shoot = true
var reloading = false

func _ready():
	TimerShoot.connect("timeout", Callable(self, "can_shoot_again"))
	ammo = max_ammo
	MuzzleFlash.hide()

func set_active():
	update_ammo()
	if ammo == 0:
		reload()

func update_ammo():
	emit_signal("ammo_changed", ammo, max_ammo)

func fire_single():
	if not is_full_auto:
		shoot()

func fire_auto():
	if is_full_auto:
		shoot()

func shoot():
	if can_shoot and ammo > 0:
		can_shoot = false
		TimerShoot.start()
		
		if shotgun:
			for i in range(-12, 15, 3):
				create_bullet(i)
		else:
			create_bullet()
		
		ammo -= 1
		update_ammo()
		
		MuzzleFlash.show()
		TimerFlash.start()
		
		Gunshot.play()
	if ammo == 0:
		reload()

func create_bullet(add_deg=0):
	var bullet = Bullet.instantiate()
	bullet.position = PointShoot.global_position
	bullet.rotation = global_rotation
	bullet.rotation_degrees += add_deg
	bullet.damage = damage
	Global.root.add_child(bullet)

func can_shoot_again():
	can_shoot = true

func reload():
	if not reloading and ammo != max_ammo:
		can_shoot = false
		reloading = true
		TimerShoot.stop()
		AP.stop()
		AP.play("reload")

func reload_done():
	can_shoot = true
	reloading = false
	ammo = max_ammo
	update_ammo()

func stop():
	AP.stop()

func flash_stop():
	MuzzleFlash.hide()
