extends Spatial

##CONSTS
onready var MAIN = get_node("/root/Main")
onready var GLOBALS = get_node("/root/Main/Globals")
onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

#States are also the names of the animation keys
enum STATES {
	IDLE_BEFORE=0,
	ACTION_RISE=1,
	ACTION_FALL=2,
	ACTION_RIGHT=3,
	ACTION_UP=4,
	ACTION_LEFT=5,
	ACTION_DOWN=6,
	IDLE_AFTER=7
}

##REFS
onready var animPlayer = get_node("AnimationPlayer")
onready var currState = STATES.IDLE_BEFORE

##MEMVARS
export var signalChannel = -1

##FUNCS

func _ready():
	SIGNAL_BUS.connect("obstacleAction", self, "obstacleActionReceiver")

func obstacleActionReceiver(argActionIdx, argSignalChannel):
	if(argSignalChannel == signalChannel):
		setState(argActionIdx)

func setState(argNewState):
	if(argNewState != currState):
		currState = argNewState
		match(currState):
			STATES.IDLE_BEFORE:
				pass
			STATES.ACTION_RISE:
				animPlayer.play(STATES.keys()[STATES.ACTION_RISE])
			STATES.ACTION_FALL:
				animPlayer.play(STATES.keys()[STATES.ACTION_FALL])
			STATES.ACTION_RIGHT:
				animPlayer.play(STATES.keys()[STATES.ACTION_RIGHT])
			STATES.ACTION_UP:
				animPlayer.play(STATES.keys()[STATES.ACTION_UP])
			STATES.ACTION_LEFT:
				animPlayer.play(STATES.keys()[STATES.ACTION_LEFT])
			STATES.ACTION_DOWN:
				animPlayer.play(STATES.keys()[STATES.ACTION_DOWN])
			STATES.ACTION_DESTROY:
				pass
			STATES.IDLE_AFTER:
				pass
