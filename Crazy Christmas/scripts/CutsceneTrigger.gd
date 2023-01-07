extends Area

###REFS
onready var GLOBALS = get_node("/root/Main/Globals")
onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")

onready var camera = get_node("/root/Main/Game/Camera/Camera")
export(NodePath) var targetObj
onready var cameraMovementFactor = 0
onready var cameraRotationFactor = 0
onready var playCutscene = 0
onready var cameraStartPos = Vector3.ZERO
onready var cameraTargetPos = Vector3.ZERO
onready var cameraStartRot = Vector3.ZERO
onready var cameraTargetRot = Vector3.ZERO

onready var timer = 0
export var time = 0

func _ready():
		cameraTargetPos = Vector3(
			get_node(targetObj).transform.origin.x + 4,
			get_node(targetObj).transform.origin.y + 4,
			get_node(targetObj).transform.origin.z + 4
		)
		cameraTargetRot = Vector3(0, 30, 30)
		cameraStartRot = camera.rotation

func _process(delta):
	if(playCutscene == 1):
		if(camera.global_transform.origin.distance_to(cameraTargetPos) > 0.1):
			cameraMovementFactor += delta * 0.5
			cameraRotationFactor += delta * 0.01
			camera.global_transform.origin = cameraStartPos + (cameraTargetPos - cameraStartPos) * cameraMovementFactor
			if(camera.rotation.distance_to(cameraTargetRot) > 0.1):
				camera.rotation = cameraStartRot + (cameraTargetRot - cameraStartRot) * cameraRotationFactor
		else:
			timer += delta
			if(timer >= time):
				SIGNAL_BUS.emit_signal("resumeGame", false, false)
				timer = 0
				cameraMovementFactor = 0
				playCutscene = 2
				SIGNAL_BUS.emit_signal("cutsceneEnd")

func _on_CutsceneTrigger_body_entered(body):
	if(body.is_in_group("player") && playCutscene == 0):
		playCutscene += 1
		cameraStartPos = camera.global_transform.origin
		SIGNAL_BUS.emit_signal("pauseGame", false, false)
		SIGNAL_BUS.emit_signal("cutsceneStart")
