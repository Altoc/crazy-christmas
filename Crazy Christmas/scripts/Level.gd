extends Spatial

onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")
export var nextLevelPath = "res://scenes/level/LevelCredits.tscn"
export var myLevel = -1

func _ready():
	if(myLevel != 0):
		SIGNAL_BUS.emit_signal("playMusic", "wind")

func getPlayerSpawnCoords():
	return get_node("PlayerSpawn").transform.origin
