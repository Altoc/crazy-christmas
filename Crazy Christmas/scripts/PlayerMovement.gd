extends KinematicBody

###REFS
onready var MAIN = get_node("/root/Main")
onready var GLOBALS = get_node("/root/Main/Globals")
onready var camera = get_node("../Camera")

###MEM VARS
const RAY_LENGTH = 100
enum PLAYER_STATES {
	IDLE=0,
	RUN=1
}
onready var currPlayerState = PLAYER_STATES.IDLE
onready var prevPlayerState = PLAYER_STATES.IDLE
onready var input = Vector3()
var gravity
onready var movementSpeedMax = 10.0
onready var movementSpeedIncreaseFactor = 30.0
onready var currMovementSpeed = 0.0
onready var velocity = Vector3()
onready var inputReceived = false
onready var toRay = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready():
	gravity = GLOBALS.GRAVITY

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#gravity
	velocity.y -= gravity * delta
	#wipe movement direction
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
	velocity = move_and_slide(velocity, Vector3(0, 1, 0),
									true, 4, PI/4, false)
	look_at(Vector3(toRay.x, 0, toRay.z), Vector3(0,1,0))

func _input(event):
	if event is InputEventMouseMotion:
		var fromRay = camera.project_ray_origin(event.position)
		toRay = fromRay + camera.project_ray_normal(event.position) * RAY_LENGTH
	if event is InputEventMouseButton:
		spawnSnowball(event.position)

func spawnSnowball(argTargetPos):
	var snowballScenePath = "res://scenes/Snowball.tscn"
	var snowball = load(snowballScenePath).instance()
	MAIN.add_child(snowball)
	snowball.set_owner(MAIN)
	snowball.transform.origin = transform.origin
	snowball.apply_central_impulse(Vector3(toRay.x, 10, toRay.z))

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

func setPlayerState(argNewState):
	if(currPlayerState != null):
		prevPlayerState = currPlayerState
	if(argNewState != null):
		currPlayerState = argNewState
	#match currPlayerState:
		#PLAYER_STATES.IDLE:
			#currMovementSpeed = 0.0
		#PLAYER_STATES.RUN:
			
