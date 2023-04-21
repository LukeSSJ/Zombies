extends Node2D

var stack = []

func _ready():
	$Timer.connect("timeout", Callable(self, "spawn"))

func add_to_stack(ZombieType):
	stack.append(ZombieType)
	if $Timer.is_stopped():
		$Timer.start()

func spawn():
	var ZombieType = stack.pop_front()
	var zombie = ZombieType.instantiate()
	zombie.position = global_position
	Global.root.add_child(zombie)
	
	if len(stack) > 0:
		$Timer.start()
