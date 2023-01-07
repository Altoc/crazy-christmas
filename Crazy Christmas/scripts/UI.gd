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
	1:"There once lived a snowman, who lived inside a globe.\n\nThe snowman remembered being happy there, once...",
	2:"But the snowman hadn't been happy in a very long time.\n\nThe snowman began to search his globe for happiness.",
	3:"\"Who was that?\" thought the snowman.\n\nSuddenly, the snowman realized; He was lonely.",
	4:"lolz level 4 done",
	5:"lolz level 5 done",
	6:"lolz",
	7:"",
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

func onPauseGame():
	pauseContainer.visible = true

func onResumeGame():
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

func _on_BtnResume_pressed():
	SIGNAL_BUS.emit_signal("resumeGame")

func _on_HSlider_value_changed(value):
	SIGNAL_BUS.emit_signal("changeVolume", value)

func _on_Button_pressed():
	SIGNAL_BUS.emit_signal("startGame")
