extends Control

onready var MAIN = get_node("/root/Main")
onready var GLOBALS = get_node("/root/Main/Globals")
onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

onready var curtain = get_node("Curtain")

func _ready():
	SIGNAL_BUS.connect("uiToggleCurtain", self, "toggleCurtain")

func toggleCurtain():
	curtain.visible = !curtain.visible
