extends Spatial

onready var endGameTimer = 0
const endGameTime = 0.25
onready var endGameFlag = false

###REFS
onready var MAIN = get_node("/root/Main")
onready var GLOBALS = get_node("/root/Main/Globals")
onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

func _process(delta):
	if(endGameFlag):
		endGameTimer += delta
		if(endGameTimer >= endGameTime):
			MAIN.endGame()
			endGameTimer = -99999

func _on_Area_body_entered(body):
	if(body.is_in_group("player")):
		endGameFlag = true
