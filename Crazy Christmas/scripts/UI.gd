extends Control

onready var MAIN = get_node("/root/Main")
onready var GLOBALS = get_node("/root/Main/Globals")
onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

onready var animPlayer = get_node("AnimationPlayer")
onready var curtain = get_node("Curtain")

func _ready():
	SIGNAL_BUS.connect("uiToggleCurtain", self, "toggleCurtain")

func toggleCurtain():
	#if alpha is invisible
	if(curtain.modulate.a == 0):
		animPlayer.play("FADE_IN")
	else:
		animPlayer.play("FADE_OUT")
	yield(animPlayer, "animation_finished")
	SIGNAL_BUS.emit_signal("uiCurtainAnimationFinished")
