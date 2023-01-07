extends Spatial

onready var GLOBALS = get_node("Globals")
onready var SIGNAL_BUS = get_node("SignalBus")

func _ready():
	GLOBALS.RNG.randomize()
	SIGNAL_BUS.connect("startGame", self, "startGame")
	SIGNAL_BUS.connect("pauseGame", self, "pauseGame")
	SIGNAL_BUS.connect("resumeGame", self, "unpauseGame")
	SIGNAL_BUS.connect("playerAnimationFinished", self, "onPlayerAnimationFinished")
	SIGNAL_BUS.connect("uiCurtainAnimationFinished", self, "onUiCurtainAnimationFinished")

func _process(_delta):
	if(Input.is_action_just_released("ui_cancel")):
		if(GLOBALS.PAUSED):
			SIGNAL_BUS.emit_signal("resumeGame")
		else:
			SIGNAL_BUS.emit_signal("pauseGame")

func startGame():
	changeLevel()

func togglePauseGame():
	GLOBALS.PAUSED = !GLOBALS.PAUSED
	get_tree().paused = GLOBALS.PAUSED
	
func pauseGame():
	SIGNAL_BUS.emit_signal("pauseMusic")
	GLOBALS.PAUSED = true
	get_tree().paused = true
	
func unpauseGame():
	SIGNAL_BUS.emit_signal("resumeMusic")
	GLOBALS.PAUSED = false
	get_tree().paused = false

func endGame():
	SIGNAL_BUS.emit_signal("playerTeleportOut")

func onUiCurtainAnimationFinished():
	#stub
	pass

func onPlayerAnimationFinished(argAnimation):
	if(argAnimation == "TELEPORT_OUT"):
		changeLevel()

func changeLevel():
	SIGNAL_BUS.emit_signal("uiToggleCurtain")
	yield(SIGNAL_BUS, "uiCurtainAnimationFinished")
	if(GLOBALS.CURRENT_LEVEL.nextLevelPath == "res://scenes/level/LevelCredits.tscn"):
		loadCredits()
	else:
		loadLevel()

func loadLevel():
	GLOBALS.CURRENT_LEVEL_ID += 1
	var nextLevelPath = GLOBALS.CURRENT_LEVEL.nextLevelPath
	GLOBALS.CURRENT_LEVEL.queue_free()
	var nextLevel = load(nextLevelPath).instance()
	GLOBALS.CURRENT_LEVEL = nextLevel
	GLOBALS.CURRENT_LEVEL_PARENT.add_child(GLOBALS.CURRENT_LEVEL)
	GLOBALS.CURRENT_LEVEL_PARENT.move_child(GLOBALS.CURRENT_LEVEL, 0)
	GLOBALS.CURRENT_LEVEL.set_owner(GLOBALS.CURRENT_LEVEL_PARENT)
	SIGNAL_BUS.emit_signal("playerMoveToSpawn", GLOBALS.CURRENT_LEVEL.getPlayerSpawnCoords())
	SIGNAL_BUS.emit_signal("uiToggleCurtain")
	yield(SIGNAL_BUS, "uiCurtainAnimationFinished")
	SIGNAL_BUS.emit_signal("playerTeleportIn")

func loadCredits():
	var nextLevelPath = GLOBALS.CURRENT_LEVEL.nextLevelPath
	GLOBALS.CURRENT_LEVEL.queue_free()
	get_node("Game/SnowParticles").queue_free()
	get_node("Game/Camera").queue_free()
	var nextLevel = load(nextLevelPath).instance()
	GLOBALS.CURRENT_LEVEL = nextLevel
	GLOBALS.CURRENT_LEVEL_PARENT.add_child(GLOBALS.CURRENT_LEVEL)
	GLOBALS.CURRENT_LEVEL_PARENT.move_child(GLOBALS.CURRENT_LEVEL, 0)
	GLOBALS.CURRENT_LEVEL.set_owner(GLOBALS.CURRENT_LEVEL_PARENT)
	SIGNAL_BUS.emit_signal("uiToggleCurtain")
