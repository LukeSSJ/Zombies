extends StaticBody2D

signal dead

var max_hp = 1000
var hp = max_hp

onready var HealthBar = $HealthBar

func _ready():
	HealthBar.max_value = max_hp
	HealthBar.value = hp

func get_hit(other):
	hp -= other.damage
	if hp <= 0:
		emit_signal("dead")
	HealthBar.value = hp

func heal():
	hp = max_hp
	HealthBar.value = hp
