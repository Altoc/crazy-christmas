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
onready var meshInstance = get_node("MeshInstance")

##MEMVARS
onready var currState = STATES.UNPRESSED
export var signalChannel = -1

##FUNCS

func _ready():
	#make mesh unique so changing color doenst effect other buttons
	meshInstance.set_surface_material(0, meshInstance.get_active_material(0).duplicate(true))
	meshInstance.get_surface_material(0).albedo_color = GLOBALS.COLOR_RED

func press():
	setState(STATES.PRESSED)

func setState(argNewState):
	if(currState != argNewState):
		currState = argNewState
		match(currState):
			STATES.UNPRESSED:
				pass
			STATES.PRESSED:
				meshInstance.get_surface_material(0).albedo_color = GLOBALS.COLOR_GREEN
				SIGNAL_BUS.emit_signal("obstacleAction", 1, signalChannel)
				pass


func _on_Area_body_entered(body):
	if(body.is_in_group("snowball")):
		press()
