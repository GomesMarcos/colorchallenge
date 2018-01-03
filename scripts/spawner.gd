extends Sprite
var texturaRand = []
const pathFormas = "res://assets/formas/"

func _ready():
	get_node(".").set_texture()

func random_texture():
	return texturaRand[randi() % pathFormas.size()]