extends Sprite2D
class_name Item

@export var item_data : ItemData

func _init() -> void:
	add_to_group("Item")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture = item_data.texture
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
