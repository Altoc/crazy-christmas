extends Camera

onready var cameraTarget = get_node("../Target")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	transform = transform.interpolate_with(cameraTarget.transform, 0.10)
