extends Resource
class_name Task

enum TaskType {
	BaseTask,
	FindItem,
	WalkTo,
	Pickup,
	Eat,
	Manipulate,
	Harvest
}

var task_name : String
var task_type : TaskType = TaskType.BaseTask

var subtasks = []
var current_subtask : int = 0

var target_item
var target_item_type

func is_finished():
	return current_subtask == len(subtasks)
	
func finish():
	current_subtask = len(subtasks)
	
func get_current_subtask():
	return subtasks[current_subtask]
	
func on_finish_subtask():
	current_subtask += 1
	
func on_found_item(item):
	on_finish_subtask()
	get_current_subtask().target_item = item

func on_reached_destination():
	on_finish_subtask()
	get_current_subtask().target_item = subtasks[current_subtask - 1].target_item
	
func init_find_and_eat_food_task():
	task_name = "Find and eat food"
	
	var subtask = Task.new()
	subtask.task_type = TaskType.FindItem
	subtask.target_item_type = ItemManager.ItemCategory.FOOD
	subtasks.append(subtask)
	
	subtask = Task.new()
	subtask.task_type = TaskType.WalkTo
	subtasks.append(subtask)
	
	subtask = Task.new()
	subtask.task_type = TaskType.Pickup
	subtasks.append(subtask)
	
	subtask = Task.new()
	subtask.task_type = TaskType.Eat
	subtasks.append(subtask)
