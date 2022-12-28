extends Spatial

##CONSTS
onready var MAIN = get_node("/root/Main")
onready var GLOBALS = get_node("/root/Main/Globals")
onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

onready var shrinkPlayer = false
onready var shrinkOther = false
onready var bodyToShrink = null
onready var shrinkFactor = 0
const shrinkMin = Vector3(0.01, 0.01, 0.01)
const shrinkNorm = Vector3.ONE

func _on_Area_body_entered(body):
	if(body.is_in_group("snowball")):
		shrinkOther = true
		bodyToShrink = body
	if(body.is_in_group("player")):
		shrinkPlayer = true
		bodyToShrink = body

func _process(delta):
	if(shrinkPlayer || shrinkOther):
		shrinkFactor += delta * 2
		bodyToShrink.scale = shrinkNorm + (shrinkMin - shrinkNorm) * shrinkFactor
		if(bodyToShrink.scale <= shrinkMin):
			bodyToShrink.scale = shrinkNorm
			shrinkFactor = 0
			if(shrinkPlayer):
				SIGNAL_BUS.emit_signal("playerTeleportIn")
				SIGNAL_BUS.emit_signal("playerMoveToSpawn", GLOBALS.CURRENT_LEVEL.getPlayerSpawnCoords())
				shrinkPlayer = false
			else:
				shrinkOther = false
