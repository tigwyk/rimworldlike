extends Node
class_name TaskManager


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.task_manager = self
	#print("Task manager: %s" % Globals.task_manager)

func request_task():
	var task = Task.new()
	task.init_find_and_eat_food_task()
	return task

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
