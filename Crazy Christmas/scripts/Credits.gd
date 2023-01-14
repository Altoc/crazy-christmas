extends Control

export var creditsText = "A game made for SAIC 2.\n\nCreated by anonymous!!!"
onready var creditsLabel = get_node("VBoxContainer/Label")

func _ready():
	creditsLabel.text = creditsText

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	creditsLabel.rect_position = Vector2(creditsLabel.rect_position.x, creditsLabel.rect_position.y - (20 * delta))
