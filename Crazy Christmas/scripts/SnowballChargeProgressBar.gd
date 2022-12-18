extends ProgressBar

onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

# Called when the node enters the scene tree for the first time.
func _ready():
	SIGNAL_BUS.connect("playerChargingSnowball", self, "onPlayerCharging")

func onPlayerCharging(snowballChargeFactor):
	value = snowballChargeFactor
