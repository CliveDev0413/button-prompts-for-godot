@tool
@icon("res://addons/button_prompts_for_godot/Icons/ui_button_prompt_icon.svg")

extends RichTextLabel

var manager;

@export_range(0, 100) var PROMPT_SCALE: float = 20; ## In percentage of the label's width.

var using_keyboard: bool;
var light_keys;
var actions: Array;
var og_text: String;

var keybord_mouse_handler = Keyboard_Mouse_Input_Handler.new();
var controller_handler = Controller_Input_Handler.new();

func _enter_tree() -> void:
	bbcode_enabled = true;
	fit_content = true;
	scroll_active = false;

func _ready() -> void:
	if Engine.is_editor_hint(): return;
	
	assert(has_node("/root/button_prompts_manager"), "The Button Prompts manager could not be found. Please check if the Button Prompts plugin is enabled.");
	manager = get_node("/root/button_prompts_manager");
	
	light_keys = ProjectSettings.get_setting("Addons/ButtonPrompts/prompts/light_themed_keyboard_and_mouse");
	
	actions = get_all_actions_in_text();
	og_text = text;

	keybord_mouse_handler.on_keyboard_mouse_input.connect(_on_keyboard_mouse_input);
	controller_handler.on_controller_input.connect(_on_controller_input);

func _input(event):	
	if keybord_mouse_handler.detects_input(event):
		if using_keyboard: return;

		using_keyboard = true;
		restart_text();
		for action in actions:
			keybord_mouse_handler.process_input(action);
	elif controller_handler.detects_input(event):
		if !using_keyboard: return;

		using_keyboard = false;
		restart_text();
		manager.get_controller_type(Input.get_joy_name(Input.get_connected_joypads().find(event.device)));
		for action in actions:
			controller_handler.process_input(action);

func _on_keyboard_mouse_input(key_name, mouse_properties, action):
	var sprite: String;
		
	if mouse_properties != null:
		if light_keys:
			sprite = "mouse_light";
		else:
			sprite = "mouse_dark";
		
		var frame = manager.mouse_button_index_to_name(mouse_properties.button_index).to_lower();
		var region: Vector2 = get_frame_region(manager.mouse, frame, sprite)
		replace_action_in_text(action, make_prompt(region, sprite));
		
	else:
		if light_keys:
			sprite = "keyboard_light"
		else:
			sprite = "keyboard_dark"
	
		var region: Vector2 = get_frame_region(manager.keyboard, key_name, sprite);
		replace_action_in_text(action, make_prompt(region, sprite));


func _on_controller_input(button_properties, joystick_properties, action_has_controller, action):		
	if action_has_controller:
		var texture_name = manager.SUPPORTED_CONTROLLERS.keys()[manager.connected_controller];
		var frame: String;
		var region;
		
		if joystick_properties != null:
			if joystick_properties.axis == 0 || joystick_properties.axis == 1:
				frame = "left-stick";
			elif joystick_properties.axis == 2 || joystick_properties.axis == 3:
				frame = "right-stick";
			elif joystick_properties.axis == 4:
				frame = "left-trigger";
			elif joystick_properties.axis == 5:
				frame = "right-trigger";
		else:
			frame = str(button_properties.button_index);
		
		if ProjectSettings.get_setting("Addons/ButtonPrompts/prompts/positional_controller_button_prompts") == true:
			if button_properties.button_index < 4:
				texture_name = "positional_prompts";
			else: 
				texture_name = manager.SUPPORTED_CONTROLLERS.keys()[manager.connected_controller];
		
		region = get_frame_region(manager.buttons, frame, texture_name);
		replace_action_in_text(action, make_prompt(region, texture_name));
	else:
		replace_action_in_text(action, " ");

func get_frame_region(input_dictionary, frame_name: String, texture_name: String) -> Vector2:
	var region: Vector2;
	
	var frame = input_dictionary[frame_name];
	var texture = manager.textures[texture_name];
	
	region.x = (int(frame) % texture.Hframes) * 100;
	region.y = (int(frame) / texture.Vframes) * 100;
	
	#if frame / texture.Vframes < 0.5:
		#region.y = floor(frame / texture.Vframes);
	#else:
		#region.y = ceil(frame / texture.Vframes);
	#
	#return Vector2(region.x, region.y * 100);
	
	return region;

func get_all_actions_in_text() -> Array:
	var regex = RegEx.new();
	regex.compile(r"\{(.*?)\}");
	
	var matches = regex.search_all(text);
	
	var action_names = [];
	for match in matches:
		action_names.append(match.get_string(1));
	
	return action_names;

func make_prompt(frame_region: Vector2, texture_name: String) -> String:
	var prompt = "[img width=%s%% height=%s%% region=%s,%s,100,100]%s[/img]" % [PROMPT_SCALE, PROMPT_SCALE, frame_region.x, frame_region.y, manager.textures[texture_name].image.resource_path];
	return prompt;

func replace_action_in_text(action_name: String, to: String):
	text = text.replace("{" + action_name + "}", to);

func restart_text():
	text = og_text;
