extends Spatial


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("AnimationPlayer").play("SPIN")
