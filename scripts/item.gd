extends Sprite2D

@export var item_data : Item

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture = item_data.texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
