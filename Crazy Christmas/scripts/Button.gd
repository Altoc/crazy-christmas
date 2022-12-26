extends Spatial

##CONSTS
onready var MAIN = get_node("/root/Main")
onready var GLOBALS = get_node("/root/Main/Globals")
onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

#States are also the names of the animation keys
enum STATES {
	UNPRESSED=0,
	PRESSED=1
}

##REFS
onready var animPlayer = get_node("AnimationPlayer")
onready var currState = STATES.UNPRESSED

##MEMVARS
export var signalChannel = -1

##FUNCS

func _ready():
	press()

func press():
	setState(STATES.PRESSED)

func setState(argNewState):
	if(currState != argNewState):
		currState = argNewState
		match(currState):
			STATES.UNPRESSED:
				pass
			STATES.PRESSED:
				print("Button Pressed")
				SIGNAL_BUS.emit_signal("obstacleAction", 1, 0)
				pass
