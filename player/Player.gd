extends CharacterBody2D

signal dead

const WALK_SPEED = 200
const ROOM_WIDTH = 1024
const ROOM_HEIGHT = 600

var max_hp = 200
var hp = max_hp
var is_dead = false
var in_shop = false
var weapon_selected = 0
var weapon_unlocked = []

var money = 0

@onready var Weapons = $Weapons.get_children()
@onready var ActiveWeapon = Weapons[weapon_selected]
@onready var UI = $UI

# Called when the node enters the scene tree for the first time.
func _ready():
	UI.connect("unlock_weapon", Callable(self, "unlock_weapon"))
	
	for weapon in Weapons:
		weapon.connect("ammo_changed", Callable(UI, "update_ammo"))
		weapon.hide()
		weapon_unlocked.append(false)
	weapon_unlocked[0] = true
	
	switch_weapon(0)
	
	UI.update_money(money)

func _process(_delta):
	if is_dead:
		return
	
	if Input.is_action_just_pressed("shop"):
		in_shop = not in_shop
		UI.toggle_shop(in_shop)
	if in_shop:
		return
	
	var vel = WALK_SPEED * Input.get_vector("move_left", "move_right", "move_up", "move_down")
	set_velocity(vel)
	move_and_slide()
	vel = velocity
	position.x = clamp(position.x, 0, ROOM_WIDTH)
	position.y = clamp(position.y, 0, ROOM_HEIGHT)
	
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
			switch_weapon(i)
	if Input.is_action_just_released("weapon_prev"):
		scroll_weapon(-1)
	elif Input.is_action_just_released("weapon_next"):
		scroll_weapon(1)

func switch_weapon(index):
	ActiveWeapon.hide()
	weapon_selected = index
	ActiveWeapon = Weapons[weapon_selected]
	UI.update_weapon(ActiveWeapon.weapon_name)
	ActiveWeapon.set_active()
	ActiveWeapon.show()

func scroll_weapon(add):
	var index = weapon_selected + add
	while index >= 0 and index < 6:
		if weapon_unlocked[index]:
			switch_weapon(index)
			return
		index += add

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
	is_dead = true
	UI.player_dead()
	ActiveWeapon.stop()

func unlock_weapon(weapon_index, cost):
	weapon_unlocked[weapon_index] = true
	money -= cost
	UI.update_money(money)
	switch_weapon(weapon_index)

func heal():
	hp = max_hp
	UI.update_hp(hp, max_hp)
