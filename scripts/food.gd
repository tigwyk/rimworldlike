extends Item
class_name Food

@export var nutrition : float

func _ready() -> void:
	super._ready()
	nutrition = item_data.nutrition

func _init() -> void:
	super._init()
	add_to_group("Food")
