extends Spatial

##CONSTS
onready var MAIN = get_node("/root/Main")
onready var GLOBALS = get_node("/root/Main/Globals")
onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

onready var shrinkPlayer = false
onready var player = get_node("/root/Main/Game/Player")
onready var playerShrinkFactor = 0
const shrinkPlayerMin = Vector3(0.01, 0.01, 0.01)
const shrinkPlayerNorm = Vector3.ONE

func _on_Area_body_entered(body):
	if(body.is_in_group("player")):
		shrinkPlayer = true

func _process(delta):
	if(shrinkPlayer):
		playerShrinkFactor += delta * 2
		player.scale = shrinkPlayerNorm + (shrinkPlayerMin - shrinkPlayerNorm) * playerShrinkFactor
		if(player.scale <= shrinkPlayerMin):
			player.scale = shrinkPlayerNorm
			playerShrinkFactor = 0
			SIGNAL_BUS.emit_signal("playerTeleportIn")
			SIGNAL_BUS.emit_signal("playerMoveToSpawn", GLOBALS.CURRENT_LEVEL.getPlayerSpawnCoords())
			shrinkPlayer = false
