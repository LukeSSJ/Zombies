extends Node2D

onready var ZombieTypes = [
	[preload("res://zombie/Zombie.tscn")],
	[preload("res://zombie/FastZombie.tscn"), preload("res://zombie/ArmouredZombie.tscn")],
	[preload("res://zombie/ExplosiveZombie.tscn"), preload("res://zombie/BufferZombie.tscn")],
	[preload("res://zombie/ShooterZombie.tscn")],
	[preload("res://zombie/Tank.tscn")],
]

onready var Spawns = $Spawns
onready var TimerSpawn = $TimerSpawn
onready var TimerNextWave = $TimerNextWave

onready var Wave = $UI/Wave
onready var WaveNumber = $UI/Wave/HBoxContainer/Label2
onready var GameOver = $UI/GameOver
onready var YouSurvived = $UI/GameOver/Content/VBoxContainer/YouSurvived
onready var Retry = $UI/GameOver/Content/VBoxContainer/Retry

var wave = 0
var active = true
var zombies_to_spawn = 0
var zombies_left = 0
var zombie_type_left = [INF, 0, 0, 0, 0]
var zombie_type_rate = [0, 4, 4, 9, 19]

func _ready():
	Global.root = self
	Global.player = $Player
	Global.base = $Base
	
	Global.player.connect("dead", self, "game_over")
	Global.base.connect("dead", self, "game_over")
	TimerSpawn.connect("timeout", self, "spawn_zombie")
	TimerNextWave.connect("timeout", self, "next_wave")
	Retry.connect("pressed", self, "retry")
	
	randomize()
	next_wave()
	
func next_wave():
	if not active:
		return
	
	wave += 1
	zombies_to_spawn = wave * 8
	zombies_left = zombies_to_spawn
	
	if wave >= 2:
		zombie_type_left[1] = wave * 2
	if wave >= 3:
		zombie_type_left[2] = wave
	if wave >= 4:
		zombie_type_left[3] = wave
	if wave >= 5:
		zombie_type_left[4] = ceil(wave / 5)
	
	var wave_name = "wave" + str(wave)
	WaveNumber.text = str(wave)

	TimerSpawn.start()
	TimerSpawn.wait_time = max(0.1, 1 - wave * 0.1)
	
	$NextWave.play()

func spawn_zombie():
	if zombies_to_spawn > 0:
		var ZombieType = get_zombie_type()
		Spawns.get_child(randi() % Spawns.get_child_count()).add_to_stack(ZombieType)
		zombies_to_spawn -= 1

func get_zombie_type():
	for i in range(4, 0, -1):
		if zombie_type_left[i] > 0 and randi() % zombie_type_rate[i] == 0:
			return ZombieTypes[i][randi() % len(ZombieTypes[i])]
	return ZombieTypes[0][0]

func zombie_killed(zombie):
	Global.player.add_money(zombie.money_gained)
	zombies_left -= 1
	if zombies_left == 0:
		TimerNextWave.start()
		Global.player.heal()
		Global.base.heal()

func game_over():
	if not active:
		return
	
	active = false
	YouSurvived.text = str("You survived to wave " + str(wave))
	GameOver.show()
	Global.player.lose()

func retry():
	get_tree().reload_current_scene()
