extends CharacterBody2D

@onready var terrain = $"../TerrainLayer"
@onready var pathfinding = $"../Pathfinding"
@onready var item_manager = $"../ItemManager"

const SPEED = 300.0

var hunger = 0
var thirst = 0

var path = []

func set_move_target(worldPos : Vector2):
	var pos = position / terrain.rendering_quadrant_size
	var targetPos = worldPos / terrain.rendering_quadrant_size
	path = pathfinding.request_path(pos, targetPos)

func has_reached_destination():
	#print("Remaining path: %d" % len(path))
	return len(path) == 0

func _physics_process(delta: float) -> void:

	if Input.is_action_just_pressed("left_click"):
		var pos = position / terrain.rendering_quadrant_size
		var targetPos = get_global_mouse_position() / terrain.rendering_quadrant_size
		path = pathfinding.request_path(pos, targetPos)
	
	if Input.is_action_just_pressed("ui_accept"):
		var pos = position / terrain.rendering_quadrant_size
		var targetPos = item_manager.find_nearest_item(item_manager.ItemCategory.FOOD,position).position / terrain.rendering_quadrant_size
		path = pathfinding.request_path(pos, targetPos)
	
	if len(path) > 0:
		var direction = global_position.direction_to(path[0])
		var terrain_diff = pathfinding.get_terrain_difficulty(position/terrain.rendering_quadrant_size)
		velocity = direction * SPEED * (1 / terrain_diff)
		
		if position.distance_to(path[0]) < SPEED * delta:
			path.remove_at(0)
	else: 
		velocity = Vector2(0,0)
	move_and_slide()
