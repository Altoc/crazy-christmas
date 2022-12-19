extends Camera


export var zOffset = 0
export var yOffset = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	transform.origin.x = get_node("../Player").transform.origin.x
	transform.origin.y = get_node("../Player").transform.origin.y + yOffset
	transform.origin.z = get_node("../Player").transform.origin.z + zOffset
