extends Spatial

onready var GLOBALS = get_node("Globals")
onready var SIGNAL_BUS = get_node("SignalBus")

func _ready():
	GLOBALS.RNG.randomize()

func _process(_delta):
	if(Input.is_action_pressed("ui_cancel")):
		togglePauseGame()

func togglePauseGame():
	GLOBALS.PAUSED = !GLOBALS.PAUSED
	get_tree().paused = GLOBALS.PAUSED

func endGame():
	print("Game Over You Win")
	SIGNAL_BUS.emit_signal("playerTeleportOut")
