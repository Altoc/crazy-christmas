extends Control

onready var MAIN = get_node("/root/Main")
onready var GLOBALS = get_node("/root/Main/Globals")
onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

onready var pauseContainer = get_node("PauseContainer")
onready var mainMenuContainer = get_node("MainMenuContainer")
onready var animPlayer = get_node("AnimationPlayer")
onready var curtain = get_node("Curtain")
onready var curtainLabel = get_node("Curtain/Label")
onready var playOutro = false
onready var curtainLabelStartPos
onready var playOutroTimer = 0
const playOutroTime = 5
onready var levelOutroText = {
	0:"This is the story of a snowman.",
	1:"The snowman lived inside of a snow globe, all by himself.",
	2:"The snowman was very lonely, he had nobody to chill with in his snowglobe.",
	3:"\"Who is that?\"",
	4:"The snowman was determined to visit this other snowman, and become friends.",
	5:"Nothing can stop the snowman from getting to his new friend.",
	6:"\"At last!\" The snowman made it.",
	7:"What a wonderful ending.",
}

func _ready():
	SIGNAL_BUS.connect("uiToggleCurtain", self, "toggleCurtain")
	SIGNAL_BUS.connect("startGame", self, "onStartGame")
	SIGNAL_BUS.connect("pauseGame", self, "onPauseGame")
	SIGNAL_BUS.connect("resumeGame", self, "onResumeGame")
	curtainLabelStartPos = curtainLabel.rect_position
	curtainLabel.text = levelOutroText[1]

func onStartGame():
	toggleCurtain()
	yield(animPlayer, "animation_finished")
	mainMenuContainer.visible = false

func onPauseGame(_argPauseMusicFlag, argShowMenuFlag):
	if(argShowMenuFlag):
		pauseContainer.visible = true

func onResumeGame(_argResumeMusicFlag, argHideMenuFlag):
	if(argHideMenuFlag):
		pauseContainer.visible = false

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
		curtainLabel.rect_position = curtainLabelStartPos
		curtainLabel.text = levelOutroText[GLOBALS.CURRENT_LEVEL_ID]
		animPlayer.play("FADE_IN")
		yield(animPlayer, "animation_finished")
		playOutro = true
	else:
		animPlayer.play("FADE_OUT")
		yield(animPlayer, "animation_finished")
		SIGNAL_BUS.emit_signal("uiCurtainAnimationFinished")
		playOutro = false

func _on_BtnResume_pressed():
	SIGNAL_BUS.emit_signal("resumeGame", true, true)

func _on_HSlider_value_changed(value):
	SIGNAL_BUS.emit_signal("changeVolume", value)

func _on_Button_pressed():
	SIGNAL_BUS.emit_signal("startGame")
