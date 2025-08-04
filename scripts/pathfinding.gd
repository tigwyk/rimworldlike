@tool
extends Node2D

@onready var terrain = $"../TerrainLayer"

var astar_grid = AStarGrid2D.new()
var path = []
@export var start = Vector2i(0,0)
@export var end = Vector2i(78, 23)
@export var calculate_path : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_pathfinding()
	
func _draw():
	if len(path) > 0:
		for i in range(len(path) - 1):
			draw_line(path[i], path[i+1], Color.PURPLE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if calculate_path:
		calculate_path = false
		init_pathfinding
		request_path(start, end)
		
func request_path(pstart : Vector2i, pend : Vector2i):
	path = astar_grid.get_point_path(pstart, pend)
	
	for i in range(len(path)):
		path[i] += Vector2(terrain.rendering_quadrant_size/2,terrain.rendering_quadrant_size/2)
	queue_redraw()
	return path

func init_pathfinding():
	astar_grid.region = Rect2i(0,0, terrain.mapWidth, terrain.mapHeight)
	astar_grid.cell_size = Vector2(16,16)
	astar_grid.update()
	
	for x in range(terrain.mapWidth):
		for y in range(terrain.mapHeight):
			if get_terrain_difficulty(Vector2i(x,y)) >= 8.0:
				astar_grid.set_point_solid(Vector2i(x,y))
			astar_grid.set_point_weight_scale(Vector2i(x,y), get_terrain_difficulty(Vector2i(x, y)))

func get_terrain_difficulty(coords : Vector2i):
	#print("Terrain Coords: %s" % coords)
	var tile_data = terrain.get_cell_tile_data(coords)
	return tile_data.get_custom_data("movement_difficulty")
