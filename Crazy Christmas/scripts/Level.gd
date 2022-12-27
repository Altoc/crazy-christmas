extends Spatial

export var nextLevelPath = "res://scenes/level/Level00.tscn"

func getPlayerSpawnCoords():
	return get_node("PlayerSpawn").transform.origin
