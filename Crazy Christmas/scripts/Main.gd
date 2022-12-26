extends Spatial

onready var GLOBALS = get_node("Globals")

func _ready():
	GLOBALS.RNG.randomize()

func _process(_delta):
	if(Input.is_action_pressed("ui_cancel")):
		togglePauseGame()

func togglePauseGame():
	GLOBALS.PAUSED = !GLOBALS.PAUSED
	get_tree().paused = GLOBALS.PAUSED
