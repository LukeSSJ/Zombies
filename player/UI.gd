extends CanvasLayer

signal unlock_weapon

onready var Crosshair = $Crosshair
onready var Ammo = $Ammo/HBoxContainer/Label
onready var MaxAmmo = $Ammo/HBoxContainer/Label3
onready var WeaponName = $Weapon/Label
onready var HealthBar = $Health/HealthBar
onready var MoneyAmount = $Money/Label
onready var Shop = $Shop
onready var WeaponButtons = $Shop/Content/VBox/WeaponButtons

var player_money = 0

func _ready():
	for i in WeaponButtons.get_child_count():
		var WeaponButton = WeaponButtons.get_child(i)
		WeaponButton.connect("pressed", self, "purchase_weapon", [i, WeaponButton])
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Shop.hide()

func update_weapon(weapon_name):
	WeaponName.text = weapon_name

func update_ammo(ammo, max_ammo):
	Ammo.text = str(ammo)
	MaxAmmo.text = str(max_ammo)

func update_hp(hp, max_hp):
	HealthBar.value = hp
	HealthBar.max_value = max_hp

func update_money(amount):
	player_money = amount
	MoneyAmount.text = "£" + str(player_money)

func toggle_shop(in_shop):
	Shop.visible = in_shop
	Crosshair.visible = not in_shop
	if in_shop:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func purchase_weapon(weapon_index, WeaponButton):
	var cost = WeaponButton.cost
	if player_money >= cost:
		WeaponButton.purchased()
		emit_signal("unlock_weapon", weapon_index, cost)

func player_dead():
	Shop.hide()
	Crosshair.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
