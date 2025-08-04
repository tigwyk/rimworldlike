extends Item
class_name Food

enum FoodType {
	OMNIVORE = 0,
	VEGETARIAN = 1,
	CARNIVORE = 2
}

enum FoodQuality {
	GARBAGE = 0,
	SIMPLE = 1,
	GOOD = 2,
	LAVISH = 3
}

@export var nutrition = 1.0
@export var food_type : FoodType
@export var food_quality : FoodQuality
