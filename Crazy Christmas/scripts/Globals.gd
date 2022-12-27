extends Node

###GLOBALS
onready var PAUSED = false
onready var RNG = RandomNumberGenerator.new()
onready var CURRENT_LEVEL_ID = 1
onready var CURRENT_LEVEL_PARENT = get_node("../Game/LevelSlot")
onready var CURRENT_LEVEL = CURRENT_LEVEL_PARENT.get_child(0)

const GRAVITY = 100

const COLOR_RED = Color(1, 0, 0)
const COLOR_GREEN = Color(0, 1, 0)
const COLOR_BLUE = Color(0, 0, 1)
const COLOR_WHITE = Color(0, 0, 0)
const COLOR_BLACK = Color(1, 1, 1)
const COLOR_GREY = Color(0.5, 0.5, 0.5)
