extends Control

export var creditsText = "This is the default credits text"
onready var creditsLabel = get_node("VBoxContainer/Label")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	creditsLabel.rect_position = Vector2(creditsLabel.rect_position.x, creditsLabel.rect_position.y - (20 * delta))
