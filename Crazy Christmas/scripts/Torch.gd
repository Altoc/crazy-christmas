extends Spatial

onready var flames = get_node("AnimatedSprite3D")
onready var light = get_node("OmniLight")

enum STATES {
	OFF=0,
	ON=1
}

onready var currState = STATES.ON

func setState(argNewState):
	if(argNewState != currState):
		currState = argNewState
		match(currState):
			STATES.OFF:
				flames.visible = false
				light.light_energy = 0
			STATES.ON:
				flames.visible = true
				light.light_energy = 1

func _on_Area_body_entered(body):
	if(body.is_in_group("snowball")):
		setState(STATES.OFF)

