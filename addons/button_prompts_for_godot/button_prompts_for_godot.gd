@tool
extends EditorPlugin

var category = "Addons/ButtonPrompts";

var custom_settings: Array;

func _enter_tree() -> void:
	add_autoload_singleton("button_prompts_manager", "res://addons/button_prompts_for_godot/Scripts/button_prompts_manager.gd");
	add_custom_type("ButtonPromptSprite", "Sprite2D", preload("res://addons/button_prompts_for_godot/Scripts/sprite_button_prompt.gd"), preload("res://addons/button_prompts_for_godot/Icons/sprite_button_prompt_icon.svg"));
	add_custom_type("ButtonPromptLabel", "RichTextLabel", preload("res://addons/button_prompts_for_godot/Scripts/ui_button_prompt.gd"), preload("res://addons/button_prompts_for_godot/Icons/ui_button_prompt_icon.svg"));
	
	add_setting({
		"name": category + "/light_themed_keyboard_and_mouse",
		"type": TYPE_BOOL,
		"hint": PROPERTY_HINT_NONE,
		"usage": PROPERTY_USAGE_DEFAULT,
		"default_value": false,
	});
	
	add_setting({
		"name": category + "/positional_controller_button_prompts",
		"type": TYPE_BOOL,
		"hint": PROPERTY_HINT_NONE,
		"usage": PROPERTY_USAGE_DEFAULT,
		"default_value": false,
	})
	
	ProjectSettings.save();
	
	pass


func _exit_tree() -> void:
	remove_autoload_singleton("button_prompts_manager");
	remove_custom_type("ButtonPromptSprite");
	remove_custom_type("ButtonPromptLabel");
	
	for setting in custom_settings:
		ProjectSettings.set_setting(setting, null);
	
	pass

func add_setting(info: Dictionary) -> void:
	if 	ProjectSettings.has_setting(info["name"]): return;
	
	ProjectSettings.set_setting(info["name"], info["default_value"]);
	ProjectSettings.add_property_info(info);
	
	custom_settings.append(info["name"]);
