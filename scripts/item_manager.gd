extends Node
class_name ItemManager

@export var base_item : PackedScene
@export var base_food : PackedScene

enum ItemCategory {
	ITEM = 0,
	FOOD = 1,
	WEAPON = 2,
	MELEEWEAPON = 3,
	PROJECTILEWEAPON = 4
}

var item_categories = [
	"Item",
	"Food",
	"Weapons",
	"MeleeWeapon",
	"ProjectileWeapon"
]

var food_prototypes = []

var items_in_world = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.item_manager = self
	#print("Item manager: %s" % Globals.item_manager)
	load_food()
	print(food_prototypes)
	spawn_item(food_prototypes[0], Vector2(10,10))
	spawn_item(food_prototypes[1], Vector2(20,20))
	print("Food? %s" % is_item_in_category(food_prototypes[0], ItemCategory.FOOD))
	print("Item? %s " % is_item_in_category(food_prototypes[0], ItemCategory.ITEM))
	print("Weapon? %s " % is_item_in_category(food_prototypes[0], ItemCategory.WEAPON))

func map_to_world_position(mapPosX : int, mapPosY : int) -> Vector2:
	return Vector2(mapPosX * 16+8, mapPosY * 16+8)

func spawn_item(item : Item, map_position : Vector2i):
	add_child(item)
	items_in_world.append(item)
	item.position = map_to_world_position(map_position.x, map_position.y)

func remove_item_from_world(item : Item):
	remove_child(item)
	items_in_world.erase(item)

func is_item_in_category(item : Item, category : ItemCategory) -> bool:
	return item.is_in_group(item_categories[category])

func find_nearest_item(item_category : ItemCategory, world_position : Vector2):
	if len(items_in_world) == 0:
		return null
	
	var nearest_item = null
	var nearest_distance = 999999
	
	for item in items_in_world:
		if is_item_in_category(item, item_category):
			var distance = world_position.distance_to(item.position)
			
			if nearest_item == null:
				nearest_item = item
				nearest_distance = distance
				continue
			
			if distance < nearest_distance:
				nearest_item = item
				nearest_distance = distance

	return nearest_item

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
			var food_base = base_food.instantiate()
			food_base.item_data = load(path+"/"+file_name)
			food_prototypes.append(food_base)
			print(file_name)
	dir.list_dir_end()
