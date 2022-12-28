extends RigidBody

onready var deathFlag = false
onready var explodeFlag = false
onready var deathTime = 30
onready var deathTimer = 0

onready var mesh = get_node("MeshInstance")
onready var particles = get_node("Particles")

func _process(delta):
	if(deathFlag):
		deathTimer += delta
		if(deathTimer >= deathTime):
			die()

func _on_Snowball_body_entered(_body):
	deathFlag = true
	if(!explodeFlag):
		explode()

func explode():
	mesh.visible = false
	particles.emitting = true

func die():
	queue_free()

