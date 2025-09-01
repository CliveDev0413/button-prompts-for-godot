class_name Editor_ButtonPromptsManager
extends Node2D

enum SUPPORTED_CONTROLLERS {
	dualsense,
	dualshock_4,
	dualshock_3,
	xbox_series,
	xbox_one, #xbox one uses xbox series prompts
	xbox_360,
	steam_deck,
	nintendo_switch
}

var connected_controller: SUPPORTED_CONTROLLERS = SUPPORTED_CONTROLLERS.dualsense;
var disabled_prompts: Array;
var auto_switch_prompts: bool = true;

signal on_switch_controller(prev_prompt: SUPPORTED_CONTROLLERS, new_prompt: SUPPORTED_CONTROLLERS);

var maps: Dictionary = {
	"keyboard_map": preload("res://addons/button_prompts_for_godot/Textures/keyboard_and_mouse/keyboard_mapping.tres"),
	"mouse_map": preload("res://addons/button_prompts_for_godot/Textures/keyboard_and_mouse/mouse_mapping.tres"),
	"positional_map": preload("res://addons/button_prompts_for_godot/Textures/controller/positional_prompts_mapping.tres"),
	"sony_map": preload("res://addons/button_prompts_for_godot/Textures/controller/sony_mapping.tres"),
	"xbox_map": preload("res://addons/button_prompts_for_godot/Textures/controller/xbox_mapping.tres"),
	"steam_deck_map": preload("res://addons/button_prompts_for_godot/Textures/controller/steam_deck_mapping.tres"),
	"switch_map": preload("res://addons/button_prompts_for_godot/Textures/controller/switch_mapping.tres")
}

var textures: Dictionary = {
	"blank_key": {"Hframes": 1, "Vframes": 1, "image": preload("res://addons/button_prompts_for_godot/Textures/key_blank.png")},
	"keyboard_dark": {"Hframes": 10, "Vframes": 10, "image": preload("res://addons/button_prompts_for_godot/Textures/keyboard_and_mouse/keyboard_dark.png")},
	"keyboard_light": {"Hframes": 10, "Vframes": 10, "image": preload("res://addons/button_prompts_for_godot/Textures/keyboard_and_mouse/keyboard_light.png")},
	"mouse_dark": {"Hframes": 3, "Vframes": 3, "image": preload("res://addons/button_prompts_for_godot/Textures/keyboard_and_mouse/mouse_dark.png")},
	"mouse_light": {"Hframes": 3, "Vframes": 3, "image": preload("res://addons/button_prompts_for_godot/Textures/keyboard_and_mouse/mouse_light.png")},
	"dualsense": {"Hframes": 5, "Vframes": 5, "image": preload("res://addons/button_prompts_for_godot/Textures/controller/dualsense.png")},
	"xbox_series": {"Hframes": 5, "Vframes": 5, "image": preload("res://addons/button_prompts_for_godot/Textures/controller/xboxSeries.png")},
	"positional_prompts": {"Hframes": 3, "Vframes": 3, "image": preload("res://addons/button_prompts_for_godot/Textures/controller/positional_prompts.png")}
}

var unloaded_controller_textures: Dictionary = {
	"dualshock_4": {"Hframes": 5, "Vframes": 5, "image": "res://addons/button_prompts_for_godot/Textures/controller/dualshock4.png"},
	"dualshock_3": {"Hframes": 5, "Vframes": 5, "image": "res://addons/button_prompts_for_godot/Textures/controller/dualshock3.png"},
	"xbox_one": {"Hframes": 5, "Vframes": 5, "image": "res://addons/button_prompts_for_godot/Textures/controller/xboxSeries.png"},
	"xbox_360": {"Hframes": 5, "Vframes": 5, "image": "res://addons/button_prompts_for_godot/Textures/controller/xbox360.png"},
	"steam_deck": {"Hframes": 5, "Vframes": 5, "image": "res://addons/button_prompts_for_godot/Textures/controller/steam_deck.png"},
	"nintendo_switch": {"Hframes": 5, "Vframes": 5, "image": "res://addons/button_prompts_for_godot/Textures/controller/switch.png"}
}

var keyboard: Dictionary;
var mouse: Dictionary;
var buttons: Dictionary;

static var Instance: Editor_ButtonPromptsManager;

func _ready() -> void:	
	_load_optional_textures();

	Instance = self;
	
	keyboard = maps["keyboard_map"].map;
	mouse = maps["mouse_map"].map;

# func _process(delta: float) -> void:
# 	if Input.is_action_just_pressed("player1_jump"):
# 		cycle_next_controller();

# donut delete
#func jsons_to_resources() -> void:
	#var json_keys = json_maps.keys()
	#
	#for json in json_keys:
		#var value = JSON.parse_string(json_maps[json].get_as_text());
		#print(str(json) + ": " + str(value));
		#
		#var new_resource = PromptMap.new();
		#new_resource.map = value;
		#var save_result = ResourceSaver.save(new_resource, "res://" + json + ".tres")
	#
	#print("conversion complete.");

func _load_optional_textures() -> void:	
	for controller in SUPPORTED_CONTROLLERS:	
		var setting_value = ProjectSettings.get_setting("Addons/ButtonPrompts/optional_supported_controllers/" + str(controller));
		
		# if controller is not toggleable, skip
		if setting_value == null: continue; 
		
		# get the texture details of the current controller setting
		var unloaded_texture = unloaded_controller_textures[controller];
		
		if setting_value == true:
			# if enabled, load controller into textures
			textures[controller] = {
				"Hframes": unloaded_texture.Hframes,
				"Vframes": unloaded_texture.Vframes,
				"image": ResourceLoader.load(unloaded_texture.image),
			};
		else:
			# if not, add to list of disabled prompts
			disabled_prompts.append(controller);

## Forces all Button Prompts present in the scene to use the prompts of the given controller type. Make [member auto_switch_prompts] true for auto-switching again.
func force_set_controller_prompts(controller_type: SUPPORTED_CONTROLLERS) -> void:
	auto_switch_prompts = false;

	var prev_prompt = connected_controller;
	connected_controller = controller_type;

	on_switch_controller.emit(prev_prompt, controller_type);

## Forces all Button Prompts present in the scene to use the prompts of the next controller in the [member SUPPORTED_CONTROLLERS] list. Make [member auto_switch_prompts] true for auto-switching again.
func cycle_next_controller() -> void:
	auto_switch_prompts = false;
	var prev_prompt = connected_controller;
	var next_controller: int = connected_controller + 1;

	if next_controller >= SUPPORTED_CONTROLLERS.keys().size():
		next_controller = 0;

	connected_controller = SUPPORTED_CONTROLLERS[SUPPORTED_CONTROLLERS.keys()[next_controller]];

	on_switch_controller.emit(prev_prompt, connected_controller);

## Forces all Button Prompts present in the scene to use the prompts of the previous controller in the [member SUPPORTED_CONTROLLERS] list. Make [member auto_switch_prompts] true for auto-switching again.
func cycle_prev_controller() -> void:
	auto_switch_prompts = false;
	var prev_prompt = connected_controller;
	var next_controller: int = connected_controller - 1;

	if next_controller < 0:
		next_controller = SUPPORTED_CONTROLLERS.keys().size() - 1;

	connected_controller = SUPPORTED_CONTROLLERS[SUPPORTED_CONTROLLERS.keys()[next_controller]];

	on_switch_controller.emit(prev_prompt, connected_controller);

func update_connected_controller(controller_name: String) -> void:
	connected_controller = get_controller_type(controller_name);

## Checks if the [member light_themed_keyboard_and_mouse] setting is enabled in Project Settings.
func is_light_keys_enabled() -> bool:
	return ProjectSettings.get_setting("Addons/ButtonPrompts/prompts/light_themed_keyboard_and_mouse");

## Checks the connected controller's type based on the controller name. Controller types are from the [member SUPPORTED_CONTROLLERS] enum.
func get_controller_type(controller_name: String) -> SUPPORTED_CONTROLLERS:	
	var _name = controller_name.to_lower();
	
	if _name.contains("ps3") or _name.contains("dualshock 3"):
		buttons = maps["sony_map"].map;
		return SUPPORTED_CONTROLLERS.dualshock_3 if !disabled_prompts.has("dualshock_3") else SUPPORTED_CONTROLLERS.dualsense;
		
	elif _name.contains("ps4") or _name.contains("dualshock 4"):
		buttons = maps["sony_map"].map;
		return SUPPORTED_CONTROLLERS.dualshock_4 if !disabled_prompts.has("dualshock_4") else SUPPORTED_CONTROLLERS.dualsense;
		
	elif _name.contains("ps5"):
		buttons = maps["sony_map"].map;
		return SUPPORTED_CONTROLLERS.dualsense;
	
	elif _name.contains("xbox 360"):
		buttons = maps["xbox_map"].map;
		return SUPPORTED_CONTROLLERS.xbox_360 if !disabled_prompts.has("xbox_360") else SUPPORTED_CONTROLLERS.xbox_series;
	
	elif _name.contains("xbox one"):
		buttons = maps["xbox_map"].map;
		return SUPPORTED_CONTROLLERS.xbox_one if !disabled_prompts.has("xbox_one") else SUPPORTED_CONTROLLERS.xbox_series;
		
	elif _name.contains("xbox series") or _name.contains("xinput"):
		buttons = maps["xbox_map"].map;
		return SUPPORTED_CONTROLLERS.xbox_series;
	
	elif _name.contains("steam virtual gamepad") or _name.contains("steam"):
		buttons = maps["steam_deck_map"].map;
		return SUPPORTED_CONTROLLERS.steam_deck if !disabled_prompts.has("steam_deck") else SUPPORTED_CONTROLLERS.xbox_series;
	
	elif _name.contains("nintendo switch"):
		buttons = maps["switch_map"].map;
		return SUPPORTED_CONTROLLERS.nintendo_switch if !disabled_prompts.has("nintendo_switch") else SUPPORTED_CONTROLLERS.xbox_series;
	
	else:
		# if nothing specific, just use xbox series
		buttons = maps["xbox_map"].map;
		return SUPPORTED_CONTROLLERS.xbox_series;

## Returns an understandable mouse input text based on the button index. Example: button index 1 is "MOUSE_BUTTON_LEFT".
func mouse_button_index_to_name(button_index: int) -> String:
	match(button_index):
		1:
			return "MOUSE_BUTTON_LEFT";
		2:
			return "MOUSE_BUTTON_RIGHT";
		3:
			return "MOUSE_BUTTON_MIDDLE";
		4:
			return "MOUSE_WHEEL_UP";
		5:
			return "MOUSE_WHEEL_DOWN";
		6:
			return "MOUSE_WHEEL_LEFT";
		7:
			return "MOUSE_WHEEL_RIGHT";
		_:
			return "invalid";
