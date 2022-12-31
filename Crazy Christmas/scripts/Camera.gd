extends Camera

onready var MAIN = get_node("/root/Main")
onready var GLOBALS = get_node("/root/Main/Globals")
onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")
onready var cameraTarget = get_node("../Target")

enum STATES {
	FOLLOW_PLAYER=0,
	CUTSCENE=1
}
onready var currState = STATES.FOLLOW_PLAYER

func _ready():
	SIGNAL_BUS.connect("cutsceneStart", self, "onCutsceneStart")
	SIGNAL_BUS.connect("cutsceneEnd", self, "onFollowPlayer")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(currState == STATES.FOLLOW_PLAYER):
		transform = transform.interpolate_with(cameraTarget.transform, 0.10)

func setState(argNewState):
	if(currState != argNewState):
		currState = argNewState
		match(currState):
			STATES.FOLLOW_PLAYER:
				pass
			STATES.CUTSCENE:
				pass

func onCutsceneStart():
	setState(STATES.CUTSCENE)

func onFollowPlayer():
	setState(STATES.FOLLOW_PLAYER)
