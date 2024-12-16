extends Node2D

enum SUPPORTED_CONTROLLERS {
	dualshock4,
	dualshock3,
	dualsense,
	xbox_one,
	xbox360,
	xbox_series,
	steam_deck,
	switch
}

var connected_controller: SUPPORTED_CONTROLLERS;

var maps: Dictionary = {
	"keyboard_map": preload("res://addons/button_prompts_for_godot/Textures/keyboard_and_mouse/keyboard_mapping.tres"),
	"mouse_map": preload("res://addons/button_prompts_for_godot/Textures/keyboard_and_mouse/mouse_mapping.tres"),
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
	"dualshock4": {"Hframes": 5, "Vframes": 5, "image": preload("res://addons/button_prompts_for_godot/Textures/controller/dualshock4.png")},
	"dualshock3": {"Hframes": 5, "Vframes": 5, "image": preload("res://addons/button_prompts_for_godot/Textures/controller/dualshock3.png")},
	"dualsense": {"Hframes": 5, "Vframes": 5, "image": preload("res://addons/button_prompts_for_godot/Textures/controller/dualsense.png")},
	"xbox360": {"Hframes": 5, "Vframes": 5, "image": preload("res://addons/button_prompts_for_godot/Textures/controller/xbox360.png")},
	"xbox_series": {"Hframes": 5, "Vframes": 5, "image": preload("res://addons/button_prompts_for_godot/Textures/controller/xboxSeries.png")},
	"steam_deck": {"Hframes": 5, "Vframes": 5, "image": preload("res://addons/button_prompts_for_godot/Textures/controller/steam_deck.png")},
	"switch": {"Hframes": 5, "Vframes": 5, "image": preload("res://addons/button_prompts_for_godot/Textures/controller/switch.png")}
}

var keyboard: Dictionary;
var mouse: Dictionary;
var buttons: Dictionary;

func _ready() -> void:	
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

func get_controller_type(controller_name: String):	
	var _name = controller_name.to_lower();
	
	if _name.contains("ps3") or _name.contains("dualshock 3"):
		buttons = maps["sony_map"].map;
		connected_controller = SUPPORTED_CONTROLLERS.dualshock3
		;
	if _name.contains("ps4") or _name.contains("dualshock 4"):
		buttons = maps["sony_map"].map;
		connected_controller = SUPPORTED_CONTROLLERS.dualshock4;
		
	if _name.contains("ps5"):
		buttons = maps["sony_map"].map;
		connected_controller = SUPPORTED_CONTROLLERS.dualsense;
	
	if _name.contains("xbox 360"):
		buttons = maps["xbox_map"].map;
		connected_controller = SUPPORTED_CONTROLLERS.xbox360;
	
	if _name.contains("xbox one"):
		buttons = maps["xbox_map"].map;
		connected_controller = SUPPORTED_CONTROLLERS.xbox_one;
		
	if _name.contains("xbox series") or _name.contains("xinput"):
		buttons = maps["xbox_map"].map;
		connected_controller = SUPPORTED_CONTROLLERS.xbox_series;
	
	if _name.contains("steam deck"):
		buttons = maps["steam_deck_map"].map;
		connected_controller = SUPPORTED_CONTROLLERS.steam_deck;
	
	if _name.contains("nintendo switch"):
		buttons = maps["switch_map"].map;
		connected_controller = SUPPORTED_CONTROLLERS.switch;
	pass;

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
