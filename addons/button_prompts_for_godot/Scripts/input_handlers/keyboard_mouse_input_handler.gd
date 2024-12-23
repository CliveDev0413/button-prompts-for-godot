class_name Keyboard_Mouse_Input_Handler
extends Node

signal on_keyboard_mouse_input(key_name, mouse_properties, action);

func detects_input (event) -> bool:
    if event is InputEventKey || event is InputEventMouseMotion:        
        return true;
    else:
        return false;

func process_input(action: String) -> void:
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;

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

    on_keyboard_mouse_input.emit(key_name, mouse_properties, action);