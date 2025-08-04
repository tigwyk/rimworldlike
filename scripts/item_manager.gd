extends Node2D

@export var base_item : PackedScene
@export var base_food : PackedScene

enum ItemCategory {
	ITEM = 0,
	FOOD = 1,
	WEAPON = 2,
	MELEEWEAPON = 3,
	PROJECTILEWEAPON = 4
}

var food_prototypes = []

var items_in_world = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_food()
	print(food_prototypes)
	spawn_item(food_prototypes[0], Vector2(10,10))
	spawn_item(food_prototypes[1], Vector2(20,20))

func map_to_world_position(mapPosX : int, mapPosY : int) -> Vector2:
	return Vector2(mapPosX * 16+8, mapPosY * 16+8)

func spawn_item(item : Item, map_position : Vector2i):
	var new_item = base_item.instantiate()
	new_item.item_data = item
	add_child(new_item)
	items_in_world.append(new_item)
	new_item.position = map_to_world_position(map_position.x, map_position.y)

func find_nearest_item():
	pass

func load_food():
	var path = "res://items/food"
	var dir = DirAccess.open(path)
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file_name = dir.get_next()
		if file_name == "":
			break
		elif file_name.ends_with(".tres"):
			food_prototypes.append(load(path+"/"+file_name))
			print(file_name)
	dir.list_dir_end()
