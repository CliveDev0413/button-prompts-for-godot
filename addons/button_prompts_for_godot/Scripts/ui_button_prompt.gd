@tool
@icon("res://addons/button_prompts_for_godot/Icons/ui_button_prompt_icon.svg")

extends RichTextLabel

var manager;

@export_range(0, 100) var PROMPT_SCALE: float = 20; ## In percentage of the label's width.

var using_keyboard: bool;
var light_keys;
var actions: Array;
var og_text: String;

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

func _input(event):	
	if event is InputEventKey or event is InputEventMouseMotion:
		
		if using_keyboard: return;
		
		using_keyboard = true;
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
		restart_text();
		process_keyboard_input();

	elif event is InputEventJoypadButton or (event is InputEventJoypadMotion && abs(event.axis_value) > 0.5):
				
		if !using_keyboard: return;
		
		using_keyboard = false;
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;
		manager.get_controller_type(Input.get_joy_name(Input.get_connected_joypads().find(event.device)))
		restart_text();
		process_controller_input();

func process_keyboard_input():
	for action in actions:
		var inputs = InputMap.action_get_events(action);
		
		assert(inputs.size() != 0, "The action, " + action + ", has no events. Or the action is non-existent.");
		
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

func process_controller_input():
	for action in actions:
		var inputs = InputMap.action_get_events(action);
		
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
			
			region = get_frame_region(manager.buttons, frame, texture_name);
			replace_action_in_text(action, make_prompt(region, texture_name));
		else:
			replace_action_in_text(action, " ")

	#if has_controller:
		#set_sprite(manager.SUPPORTED_CONTROLLERS.keys()[manager.connected_controller])
		#
		#if joystick_properties != null:
			#if joystick_properties.axis == 0 || joystick_properties.axis == 1:
				#sprite.frame = manager.buttons["left-stick"];
			#elif joystick_properties.axis == 2 || joystick_properties.axis == 3:
				#sprite.frame = manager.buttons["right-stick"];
			#elif joystick_properties.axis == 4:
				#sprite.frame = manager.buttons["left-trigger"];
			#elif joystick_properties.axis == 5:
				#sprite.frame = manager.buttons["right-trigger"];
			#return;
		#
		#sprite.frame = manager.buttons[str(button_properties.button_index)];
	pass;

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
