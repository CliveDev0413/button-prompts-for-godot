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

var connected_controller: SUPPORTED_CONTROLLERS;

var disabled_prompts: Array;

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

func _ready() -> void:	
	load_optional_textures();
	
	keyboard = maps["keyboard_map"].map;
	mouse = maps["mouse_map"].map;

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

func load_optional_textures():	
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

func get_controller_type(controller_name: String):	
	var _name = controller_name.to_lower();
	
	if _name.contains("ps3") or _name.contains("dualshock 3"):
		buttons = maps["sony_map"].map;
		connected_controller = !disabled_prompts.has("dualshock_3") if SUPPORTED_CONTROLLERS.dualshock_3 else SUPPORTED_CONTROLLERS.dualsense;
		;
	elif _name.contains("ps4") or _name.contains("dualshock 4"):
		buttons = maps["sony_map"].map;
		connected_controller = !disabled_prompts.has("dualshock_4") if SUPPORTED_CONTROLLERS.dualshock_4 else SUPPORTED_CONTROLLERS.dualsense;
		
	elif _name.contains("ps5"):
		buttons = maps["sony_map"].map;
		connected_controller = SUPPORTED_CONTROLLERS.dualsense;
	
	elif _name.contains("xbox 360"):
		buttons = maps["xbox_map"].map;
		connected_controller = !disabled_prompts.has("xbox_360") if SUPPORTED_CONTROLLERS.xbox_360 else SUPPORTED_CONTROLLERS.xbox_series;
	
	elif _name.contains("xbox one"):
		buttons = maps["xbox_map"].map;
		connected_controller = !disabled_prompts.has("xbox_one") if SUPPORTED_CONTROLLERS.xbox_one else SUPPORTED_CONTROLLERS.xbox_series;
		
	elif _name.contains("xbox series") or _name.contains("xinput"):
		buttons = maps["xbox_map"].map;
		connected_controller = SUPPORTED_CONTROLLERS.xbox_series;
	
	elif _name.contains("steam deck"):
		buttons = maps["steam_deck_map"].map;
		connected_controller = !disabled_prompts.has("steam_deck") if SUPPORTED_CONTROLLERS.steam_deck else SUPPORTED_CONTROLLERS.xbox_series;
	
	elif _name.contains("nintendo switch"):
		buttons = maps["switch_map"].map;
		connected_controller = !disabled_prompts.has("nintendo_switch") if SUPPORTED_CONTROLLERS.nintendo_switch else SUPPORTED_CONTROLLERS.xbox_series;
	
	else:
		# if nothing specific, just use xbox series
		buttons = maps["xbox_map"].map;
		connected_controller = SUPPORTED_CONTROLLERS.xbox_series;

func mouse_button_index_to_name(button_index: int):
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
