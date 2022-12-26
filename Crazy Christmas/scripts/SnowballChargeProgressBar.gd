extends ProgressBar

##REFS
onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

##CONSTS
const fadeOutTime = 1

##MEMVARS
onready var fadeOutTimer = 0
onready var fadeOutFlag = false
onready var prevValue = value

# Called when the node enters the scene tree for the first time.
func _ready():
	SIGNAL_BUS.connect("playerChargingSnowball", self, "onPlayerCharging")
	visible = false

func _process(delta):
	if(fadeOutFlag):
		fadeOutTimer += delta
		if(fadeOutTimer >= fadeOutTime):
			visible = false
			value = 0
			fadeOutTimer = 0
			fadeOutFlag = false

func onPlayerCharging(snowballChargeFactor):
	prevValue = value
	if(snowballChargeFactor <= 0):
		fadeOutFlag = true
	else:
		value = snowballChargeFactor
		visible = true
