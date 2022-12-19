extends KinematicBody

###REFS
onready var MAIN = get_node("/root/Main")
onready var GLOBALS = get_node("/root/Main/Globals")
onready var SIGNAL_BUS = get_node("/root/Main/SignalBus")
onready var camera = get_node("../Camera")

###CONSTS
const snowballScenePath = "res://scenes/Snowball.tscn"
const RAY_LENGTH = 20
const snowballThrowStrengthMin = Vector3(5, 12, 5)
const snowballThrowStrengthMax = Vector3(25, 7, 25)
const movementSpeedMax = 10.0
const movementSpeedIncreaseFactor = 30.0
const snowballTime = 1
const snowballChargeTime = 0.25

###MEM VARS
enum PLAYER_STATES {
	IDLE=0,
	RUN=1,
	SNOWBALL_CHARGE=2,
	SNOWBALL_THROW=3
}
onready var currPlayerState = PLAYER_STATES.IDLE
onready var prevPlayerState = PLAYER_STATES.IDLE
onready var input = Vector3()
onready var velocity = Vector3()
onready var toRay = Vector3()
var gravity
onready var currMovementSpeed = 0.0
onready var inputReceived = false
onready var snowballReady = true
onready var snowballThrowStrength = snowballThrowStrengthMin
onready var snowballChargeFactor = 0.0

###TIMERS
onready var snowballTimer = 0
onready var snowballChargeTimer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	gravity = GLOBALS.GRAVITY

func _process(delta):
	match(currPlayerState):
		PLAYER_STATES.SNOWBALL_CHARGE:
			snowballChargeTimer += delta
			if(snowballChargeTimer >= snowballChargeTime):
				chargeSnowball(delta)
				snowballChargeTimer = 0
	if(!snowballReady):
		snowballTimer += delta
		if(snowballTimer >= snowballTime):
			snowballReady = true
			snowballTimer = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.y -= gravity * delta
	velocity.x = 0
	velocity.z = 0
	handleInput(Input)
	input = input.normalized()
	if (Input.get_action_strength("PlayerLeft") > 0.0 || Input.get_action_strength("PlayerRight") > 0.0
	|| Input.get_action_strength("PlayerBackward") > 0.0 || Input.get_action_strength("PlayerForward") > 0.0):
		if(currMovementSpeed < movementSpeedMax):
			currMovementSpeed += movementSpeedIncreaseFactor * delta
		velocity.x = input.x * currMovementSpeed
		velocity.z = input.z * currMovementSpeed
		setPlayerState(PLAYER_STATES.RUN)
	velocity = move_and_slide(velocity, Vector3(0, 1, 0),
									true, 4, PI/4, false)
	look_at(toRay, Vector3(0,1,0))
	rotation.x = 0
	rotation.z = 0

func _input(event):
	if event is InputEventMouseMotion:
		var fromRay = camera.project_ray_origin(event.position)
		toRay = fromRay + camera.project_ray_normal(event.position) * RAY_LENGTH
	if event is InputEventMouseButton && event.button_index == 0 && snowballReady:
		var fromRay = camera.project_ray_origin(event.position)
		toRay = fromRay + camera.project_ray_normal(event.position) * RAY_LENGTH
		setPlayerState(PLAYER_STATES.SNOWBALL_CHARGE)

func chargeSnowball(delta):
	snowballChargeFactor += delta * 10
	if(snowballChargeFactor < 1.0):
		snowballThrowStrength = snowballThrowStrengthMin + (snowballThrowStrengthMax - snowballThrowStrengthMin) * snowballChargeFactor
	SIGNAL_BUS.emit_signal("playerChargingSnowball", snowballChargeFactor)

func throwSnowball():
	var snowball = load(snowballScenePath).instance()
	MAIN.add_child(snowball)
	snowball.set_owner(MAIN)
	snowball.transform.origin = transform.origin
	var targetPos = Vector3()
	targetPos.x = snowballThrowStrength.x * sin(rotation.y) * -1
	targetPos.y = snowballThrowStrength.y
	targetPos.z = snowballThrowStrength.z * cos(rotation.y) * -1
	snowball.apply_impulse(Vector3.ZERO, targetPos)
	snowballReady = false
	snowballThrowStrength = snowballThrowStrengthMin
	snowballChargeFactor = 0
	SIGNAL_BUS.emit_signal("playerChargingSnowball", snowballChargeFactor)

func handleInput(argInput):
	inputReceived = false
	if(argInput.is_action_pressed("PlayerForward")):
		inputReceived = true
		input.z -= 1
		setPlayerState(PLAYER_STATES.RUN)
	if(argInput.is_action_pressed("PlayerRight")):
		inputReceived = true
		input.x += 1
		setPlayerState(PLAYER_STATES.RUN)
	if(argInput.is_action_pressed("PlayerLeft")):
		inputReceived = true
		input.x -= 1
		setPlayerState(PLAYER_STATES.RUN)
	if(argInput.is_action_pressed("PlayerBackward")):
		inputReceived = true
		input.z += 1
		setPlayerState(PLAYER_STATES.RUN)
	if(argInput.is_action_pressed("ThrowSnowball")):
		setPlayerState(PLAYER_STATES.SNOWBALL_CHARGE)
	if(argInput.is_action_just_released("ThrowSnowball")):
		setPlayerState(PLAYER_STATES.SNOWBALL_THROW)

func setPlayerState(argNewState):
	if(currPlayerState != null):
		prevPlayerState = currPlayerState
	if(argNewState != null):
		currPlayerState = argNewState
	match currPlayerState:
		PLAYER_STATES.IDLE:
			currMovementSpeed = 0.0
		PLAYER_STATES.RUN:
			pass
		PLAYER_STATES.SNOWBALL_CHARGE:
			#charging in process func
			pass
		PLAYER_STATES.SNOWBALL_THROW:
			throwSnowball()
