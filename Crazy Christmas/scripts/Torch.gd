extends Spatial

onready var flames = get_node("AnimatedSprite3D")
onready var light = get_node("OmniLight")
onready var soundPlayer = get_node("AudioStreamPlayer3D")

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
				soundPlayer.stream_paused = !soundPlayer.stream_paused
			STATES.ON:
				flames.visible = true
				light.light_energy = 1
				soundPlayer.stream_paused = !soundPlayer.stream_paused

func _on_Area_body_entered(body):
	if(body.is_in_group("snowball")):
		setState(STATES.OFF)

