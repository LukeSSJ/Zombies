extends KinematicBody2D

signal dead

const WALK_SPEED = 200

var max_hp = 200
var hp = max_hp
var dead = false
var in_shop = false
var weapon_unlocked = []

var money = 0 + 10000

onready var Weapons = $Weapons.get_children()
onready var ActiveWeapon = $Weapons/Uzi
onready var UI = $UI

# Called when the node enters the scene tree for the first time.
func _ready():
	UI.connect("unlock_weapon", self, "unlock_weapon")
	
	for weapon in Weapons:
		weapon.connect("update_ammo", UI, "update_ammo")
		weapon.hide()
		weapon_unlocked.append(false)
	weapon_unlocked[0] = true
	
	ActiveWeapon = Weapons[0]
	switch_weapon(ActiveWeapon)
	
	UI.update_money(money)

func _process(_delta):
	if dead:
		return
	
	if Input.is_action_just_pressed("shop"):
		in_shop = not in_shop
		UI.toggle_shop(in_shop)
	if in_shop:
		return
	
	var vel = WALK_SPEED * Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	vel = move_and_slide(vel)
	
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	
	if Input.is_action_just_pressed("shoot"):
		ActiveWeapon.fire_single()
	if Input.is_action_pressed("shoot"):
		ActiveWeapon.fire_auto()
	if Input.is_action_just_pressed("reload"):
		ActiveWeapon.reload()
	
	for i in range(0, 6):
		if Input.is_action_just_pressed("weapon" + str(i + 1)) and weapon_unlocked[i]:
			switch_weapon(Weapons[i])

func switch_weapon(Weapon):
	ActiveWeapon.hide()
	ActiveWeapon = Weapon
	UI.update_weapon(ActiveWeapon.weapon_name)
	ActiveWeapon.set_active()
	ActiveWeapon.show()

func add_money(amount):
	money += amount
	UI.update_money(money)

func get_hit(other):
	hp -= other.damage
	if hp <= 0:
		lose()
		emit_signal("dead")
	UI.update_hp(hp, max_hp)

func lose():
	dead = true
	UI.player_dead()

func unlock_weapon(weapon_index, cost):
	weapon_unlocked[weapon_index] = true
	money -= cost
	UI.update_money(money)
	
	switch_weapon(Weapons[weapon_index])

func heal():
	hp = max_hp
	UI.update_hp(hp, max_hp)
