extends Button

export var cost = 0

func _ready():
	if cost > 0:
		$Cost.text = "£" + str(cost)
	else:
		disabled = true
		$Cost.text = ""

func purchased():
	disabled = true
	$Cost.text = "Purchased"
