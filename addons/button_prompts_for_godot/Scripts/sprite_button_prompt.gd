@tool
@icon("res://addons/button_prompts_for_godot/Icons/sprite_button_prompt_icon.svg")

extends Sprite2D

var manager: ButtonPromptsManager;

@export var ACTION = "";

var using_keyboard: bool;
var light_keys;

var keybord_mouse_handler = Keyboard_Mouse_Input_Handler.new();
var controller_handler = Controller_Input_Handler.new();

func _enter_tree() -> void:
	texture = preload("res://addons/button_prompts_for_godot/Textures/key_blank.png");

func _ready() -> void:
	if Engine.is_editor_hint(): return;
	
	manager = ButtonPromptsManager.Instance;
	
	light_keys = ProjectSettings.get_setting("Addons/ButtonPrompts/prompts/light_themed_keyboard_and_mouse");

	keybord_mouse_handler.on_keyboard_mouse_input.connect(_on_keyboard_mouse_input);
	controller_handler.on_controller_input.connect(_on_controller_input);

func _input(event) -> void:
	if keybord_mouse_handler.detects_input(event):
		if using_keyboard: return;

		using_keyboard = true;
		keybord_mouse_handler.process_input(ACTION);
	elif controller_handler.detects_input(event):
		if !using_keyboard: return;

		using_keyboard = false;
		controller_handler.process_input(ACTION, event.device);

func _on_keyboard_mouse_input(key_name, mouse_properties, action):	
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

func _on_controller_input(button_properties, joystick_properties, action_has_controller, action, controller_type):
	if action_has_controller:
		set_sprite(manager.SUPPORTED_CONTROLLERS.keys()[controller_type]);
		
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
		
		if ProjectSettings.get_setting("Addons/ButtonPrompts/prompts/positional_controller_button_prompts") == true:
			if button_properties != null && button_properties.button_index < 4:
				set_sprite("positional_prompts");
			else: 
				set_sprite(manager.SUPPORTED_CONTROLLERS.keys()[controller_type]);
				
		
		frame = manager.buttons[str(button_properties.button_index)];

func set_sprite(texture_name: String) -> void:
	var prompt_texture = manager.textures[texture_name];
	
	texture = prompt_texture.image;
	hframes = prompt_texture.Hframes;
	vframes = prompt_texture.Vframes;
