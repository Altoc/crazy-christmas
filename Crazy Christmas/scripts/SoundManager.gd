extends AudioStreamPlayer

onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

const SONGS = {
	"wind":"res://sound/music/wind_01.mp3",
	"credits":""
}

onready var currentlyPlaying = "wind"
onready var pauseTime = 0

func _ready():
	SIGNAL_BUS.connect("playMusic", self, "playMusic")
	SIGNAL_BUS.connect("changeVolume", self, "changeVolume")
	SIGNAL_BUS.connect("pauseMusic", self, "pauseMusic")
	SIGNAL_BUS.connect("resumeMusic", self, "resumeMusic")
	volume_db = -10

func changeVolume(value):
	volume_db = value
	print(volume_db)

func pauseMusic():
	pauseTime = get_playback_position()
	stop()

func resumeMusic():
	play(pauseTime)

func playMusic(argNameOfSong):
	match(argNameOfSong):
		"wind":
			currentlyPlaying = "wind"
			self.stream = load(SONGS["wind"])
			play()
		"credits":
			currentlyPlaying = "credits"
			pass
