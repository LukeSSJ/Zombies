extends Node2D

func _ready():
	$Particles.amount = 6 + (randi() % 6)
	$Particles.emitting = true
