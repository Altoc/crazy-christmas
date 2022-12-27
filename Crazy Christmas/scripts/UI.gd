extends Control

onready var MAIN = get_node("/root/Main")
onready var GLOBALS = get_node("/root/Main/Globals")
onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

onready var animPlayer = get_node("AnimationPlayer")
onready var curtain = get_node("Curtain")
onready var curtainLabel = get_node("Curtain/Label")
onready var playOutro = false
onready var curtainLabelStartPos
onready var playOutroTimer = 0
const playOutroTime = 5
onready var levelOutroText = {
	1:"This is \n Level 1's \n outro message!\n\n!",
	2:"lolz level 2 done",
	3:"lolz level 3 done",
	4:"lolz level 4 done",
	5:"lolz level 5 done",
	6:"lolz",
	7:"",
}

func _ready():
	SIGNAL_BUS.connect("uiToggleCurtain", self, "toggleCurtain")
	curtainLabelStartPos = curtainLabel.rect_position
	curtainLabel.text = levelOutroText[1]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(playOutro):
		playOutroTimer += delta
		if(playOutroTimer >= playOutroTime):
			playOutro = false
			playOutroTimer = 0
			SIGNAL_BUS.emit_signal("uiCurtainAnimationFinished")

func toggleCurtain():
	#if alpha is invisible
	if(curtain.modulate.a == 0):
		animPlayer.play("FADE_IN")
		yield(animPlayer, "animation_finished")
		playOutro = true
	else:
		animPlayer.play("FADE_OUT")
		yield(animPlayer, "animation_finished")
		SIGNAL_BUS.emit_signal("uiCurtainAnimationFinished")
		curtainLabel.rect_position = curtainLabelStartPos
		curtainLabel.text = levelOutroText[GLOBALS.CURRENT_LEVEL_ID]
		playOutro = false
