extends Spatial

###REFS
onready var MAIN = get_node("/root/Main")
onready var GLOBALS = get_node("/root/Main/Globals")
onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

func _on_Area_body_entered(body):
	if(body.is_in_group("player")):
		MAIN.endGame()
