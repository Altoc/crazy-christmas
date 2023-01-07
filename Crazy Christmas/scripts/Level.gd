extends Spatial

onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")
export var nextLevelPath = "res://scenes/level/LevelCredits.tscn"

func _ready():
	SIGNAL_BUS.emit_signal("playMusic", "wind")

func getPlayerSpawnCoords():
	return get_node("PlayerSpawn").transform.origin
