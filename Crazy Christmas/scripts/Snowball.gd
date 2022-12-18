extends RigidBody

onready var deathTime = 3
onready var deathTimer = 0

func _process(delta):
	deathTimer += delta
	if(deathTimer >= deathTime):
		die()

func die():
	queue_free()
