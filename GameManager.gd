extends Node

var chests_opened = 0
var total_chests = 5
var chest_label
var game_end_label
var timer_label
var time_start = 181
var time_remaining = time_start  
var timer_active = false

const main_menu_end_filepath = "res://main_menu.tscn"
const MAIN_MENU_END = preload("res://main_menu.tscn")
var timerStart = true

func _ready():
	update_chest_label()

func _process(delta):
	if (get_tree().current_scene.name == "Main" && timerStart == true):
		find_timer_label()
		start_timer()
		timerStart == false
	if timer_active:
		time_remaining -= delta
		update_timer_label()
		
		if time_remaining <= 0:
			timer_active = false
			game_over("Time's Up!")

func start_timer():
	timer_active = true

func find_timer_label():
	var main_scene = get_tree().current_scene
	if main_scene:
		timer_label = main_scene.get_node_or_null("VBoxContainer/Timer")

func update_timer_label():
	if timer_label:
		var minutes: int = int(floor(time_remaining / 60))
		var seconds: int = int(floor(time_remaining)) % 60
		timer_label.text = "%02d:%02d" % [minutes, seconds]

func open_chest():
	chests_opened += 1
	find_chest_label()
	update_chest_label()
	
	if chests_opened == total_chests:
		game_over("Congratulations, You Won!")

func find_chest_label():
	var main_scene = get_tree().current_scene
	if main_scene:
		chest_label = main_scene.get_node_or_null("VBoxContainer/ChestLabel")

func find_game_end_label():
	var current_scene = get_tree().current_scene
	if current_scene:
		game_end_label = current_scene.get_node_or_null("VBoxContainer/ScorePoints")
		if game_end_label == null:
			push_error("Could not find game end label at VBoxContainer/ScorePoints")

func update_chest_label():
	if chest_label:
		chest_label.text = "Chests Opened: %d" % chests_opened

func update_game_end_label(message: String):
	if game_end_label:
		game_end_label.text = message
	else:
		push_error("Tried to update game end label but it was null")

func game_over(end_message: String):
	time_remaining = time_start
	chests_opened = 0
	# Stop the timer
	timer_active = false
	timerStart == true
	
	# Reset mouse settings
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Change to the end game scene
	var end_scene = MAIN_MENU_END.instantiate()
	get_tree().root.add_child(end_scene)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = end_scene
	
	# Wait a frame for the scene to be ready
	await get_tree().process_frame
	
	# Now try to find and update the label
	find_game_end_label()
	update_game_end_label(end_message)
