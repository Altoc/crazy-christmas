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
	ACTION_MOVE_RIGHT=3,
	ACTION_MOVE_UP=4,
	ACTION_MOVE_LEFT=5,
	ACTION_MOVE_DOWN=6,
	IDLE_AFTER=7
}

##REFS
onready var animPlayer = get_node("AnimationPlayer")
onready var currState = STATES.IDLE_BEFORE

##MEMVARS
export var signalChannel = -1

##FUNCS

func _ready():
	SIGNAL_BUS.connect("obstacleAction", self, "setState")

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
				print(STATES.keys()[STATES.ACTION_RISE])
				animPlayer.play(STATES.keys()[STATES.ACTION_RISE])
			STATES.ACTION_FALL:
				pass
			STATES.ACTION_MOVE_RIGHT:
				pass
			STATES.ACTION_MOVE_UP:
				pass
			STATES.ACTION_MOVE_LEFT:
				pass
			STATES.ACTION_MOVE_DOWN:
				pass
			STATES.ACTION_DESTROY:
				pass
			STATES.IDLE_AFTER:
				pass

func rise():
	setState(STATES.ACTION_RISE)
