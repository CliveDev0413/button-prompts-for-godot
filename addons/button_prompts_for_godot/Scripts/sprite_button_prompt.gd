@tool
@icon("res://addons/button_prompts_for_godot/Icons/sprite_button_prompt_icon.svg")

extends Sprite2D

var manager;

@export var ACTION = "";

var using_keyboard: bool;
var light_keys;

func _enter_tree() -> void:
	texture = preload("res://addons/button_prompts_for_godot/Textures/key_blank.png");

func _ready() -> void:
	if Engine.is_editor_hint(): return;
	
	assert(has_node("/root/button_prompts_manager"), "The Button Prompts manager could not be found. Please check if the Button Prompts plugin is enabled in Project > Project Settings > Plugins");
	manager = get_node("/root/button_prompts_manager");
	
	light_keys = ProjectSettings.get_setting("Addons/ButtonPrompts/prompts/light_themed_keyboard_and_mouse");

func _input(event) -> void:
	if event is InputEventKey || event is InputEventMouseMotion:
		
		if using_keyboard: return;
		
		using_keyboard = true;
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
		process_keyboard_input();
		
	elif event is InputEventJoypadButton or (event is InputEventJoypadMotion && abs(event.axis_value) > 0.5):
		
		if !using_keyboard: return;
		
		using_keyboard = false;
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;
		manager.get_controller_type(Input.get_joy_name(Input.get_connected_joypads().find(event.device)))
		process_controller_input();

func process_keyboard_input():
	var inputs;

	assert(ACTION != "", "The action variable is not assigned.");
	
	inputs = InputMap.action_get_events(ACTION);
	
	assert(inputs.size() != 0, "The assigned action, " + ACTION + "has no events. Or the action is non-existent.");

	var key_name: String = "";
	var mouse_properties: InputEventMouseButton = null;
	
	for input in inputs:
		if input is InputEventKey:
			var the_key_name = input.as_text().to_lower();
			
			if "(physical)" in the_key_name:
				the_key_name = the_key_name.replace(" (physical)", "");
			
			key_name = the_key_name;
		elif input is InputEventMouseButton:
			mouse_properties = input;
	
	if mouse_properties != null:
		
		if light_keys:
			set_sprite("mouse_light")
		else:
			set_sprite("mouse_dark");
		
		frame = manager.mouse[manager.mouse_button_index_to_name(mouse_properties.button_index).to_lower()];
		return;
	
	if light_keys:
		set_sprite("keyboard_light");
	else:
		set_sprite("keyboard_dark");;
	
	frame = manager.keyboard[key_name];

func process_controller_input():
	var inputs;

	assert(ACTION != "", "The action variable is not assigned.");
	
	inputs = InputMap.action_get_events(ACTION);
	
	assert(inputs.size() != 0, "The assigned action, " + ACTION + ", has no events. Or the action is non-existent.");

	var button_properties: InputEventJoypadButton = null;
	var joystick_properties: InputEventJoypadMotion = null;
	
	var has_controller = false;
	
	for input in inputs:
		if input is InputEventJoypadButton:
			button_properties = input;
			has_controller = true;
		elif input is InputEventJoypadMotion:
			joystick_properties = input;
			has_controller = true;
	
	if has_controller:
		set_sprite(manager.SUPPORTED_CONTROLLERS.keys()[manager.connected_controller])
		
		if joystick_properties != null:
			if joystick_properties.axis == 0 || joystick_properties.axis == 1:
				frame = manager.buttons["left-stick"];
			elif joystick_properties.axis == 2 || joystick_properties.axis == 3:
				frame = manager.buttons["right-stick"];
			elif joystick_properties.axis == 4:
				frame = manager.buttons["left-trigger"];
			elif joystick_properties.axis == 5:
				frame = manager.buttons["right-trigger"];
			return;
		
		frame = manager.buttons[str(button_properties.button_index)];

func set_sprite(texture_name: String) -> void:
	var prompt_texture = manager.textures[texture_name];
	
	texture = prompt_texture.image;
	hframes = prompt_texture.Hframes;
	vframes = prompt_texture.Vframes;
