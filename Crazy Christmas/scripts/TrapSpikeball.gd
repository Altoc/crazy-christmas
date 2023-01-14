extends RigidBody

###REFS
onready var MAIN = get_node("/root/Main")
onready var GLOBALS = get_node("/root/Main/Globals")
onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

onready var startPos = translation

# Called when the node enters the scene tree for the first time.
func _ready():
	SIGNAL_BUS.connect("playerMoveToSpawn", self, "onPlayerMoveToSpawn")

func onPlayerMoveToSpawn(_argPlayerSpawnCoords):
	mode = MODE_KINEMATIC
	translation = startPos
	mode = MODE_RIGID

func _on_Area_body_entered(body):
	if(body.is_in_group("player")):
		SIGNAL_BUS.emit_signal("playerDie")
