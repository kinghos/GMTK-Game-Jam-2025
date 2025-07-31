extends Sprite2D

var target: Node2D
var animal: String

const POINTER_TEXTURES = {
	"Sheep": preload("res://assets/graphics/misc/skip_button_hovering.png")
}

func _ready():
	hide()
	texture = POINTER_TEXTURES[animal]

func _process(delta):
	if not target or target.is_visible_on_screen:
		hide()
		return
	
	position = Vector2(0, 0) # edge of screen, in direction of target node from the current screen center
	# no need to detect whether on screen, since we have is_visible_on_screen

	if not visible:
		show()
