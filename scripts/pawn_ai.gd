extends Node

@onready var char_controller = $".."

@export var hunger_bar : ProgressBar

enum PawnAction {
	Idle,
	DoingTask
}

var food_need : float = 0.4
var eat_speed : float = 0.5
var food_need_deplete_speed : float = 0.1

var in_hand

var current_action : PawnAction = PawnAction.Idle
var current_task : Task = null

func _process(delta):
	food_need -= food_need_deplete_speed * delta
	hunger_bar.value = food_need * 100
	if current_task != null:
		do_current_task(delta)
	else:
		if food_need < 0.5:
			current_task = Globals.task_manager.request_task()

func on_finished_subtask():
	current_action = PawnAction.Idle
	
	if current_task.is_finished():
		print("Done!")
		current_task = null

func on_pickup_item(item):
	in_hand = item
	Globals.item_manager.remove_item_from_world(item)

func do_current_task(delta):
	var subtask = current_task.get_current_subtask()
	if current_action == PawnAction.Idle:
		#print("It's taskin' time! Working on %s." % Task.TaskType.keys()[subtask.task_type])
		start_subtask(subtask)
	else:
		match subtask.task_type:
			Task.TaskType.WalkTo:
				if char_controller.has_reached_destination():
					print("Arrived!")
					current_task.on_reached_destination()
					on_finished_subtask()
			
			Task.TaskType.Eat:
				if in_hand.nutrition > 0 and food_need < 1:
					in_hand.nutrition -= eat_speed * delta
					food_need += eat_speed * delta
				else:
					print("finished eating")
					in_hand = null
					current_task.on_finish_subtask()
					on_finished_subtask()

func start_subtask(subtask):
	print("Starting subtask: %s" % Task.TaskType.keys()[subtask.task_type])
	
	match subtask.task_type:
		Task.TaskType.FindItem:
			var target_item = Globals.item_manager.find_nearest_item(subtask.target_item_type, char_controller.position)
			if target_item == null:
				print("no items nearby, task ending")
				current_task.finish()
			else:
				current_task.on_found_item(target_item)
			on_finished_subtask()
		
		Task.TaskType.WalkTo:
			char_controller.set_move_target(subtask.target_item.position)
			current_action = PawnAction.DoingTask
		
		Task.TaskType.Pickup:
			on_pickup_item(subtask.target_item)
			current_task.on_finish_subtask()
			on_finished_subtask()
		
		Task.TaskType.Eat:
			print("What's in my hand? %s" % in_hand)
			current_action = PawnAction.DoingTask
