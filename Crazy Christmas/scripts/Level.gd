extends Spatial

export var nextLevelPath = "res://scenes/level/LevelCredits.tscn"

func getPlayerSpawnCoords():
	return get_node("PlayerSpawn").transform.origin
