extends Spatial

export var zOffset = 0
export var yOffset = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_transform.origin.x = get_node("../../Player").global_transform.origin.x
	global_transform.origin.y = get_node("../../Player").global_transform.origin.y + yOffset
	global_transform.origin.z = get_node("../../Player").global_transform.origin.z + zOffset
