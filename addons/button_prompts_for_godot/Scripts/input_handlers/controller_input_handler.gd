class_name Controller_Input_Handler
extends Node

signal on_controller_input(button_properties, joystick_properties, action_has_controller, action, controller_type);

func detects_input (event) -> bool:
	if event is InputEventJoypadButton or (event is InputEventJoypadMotion && abs(event.axis_value) > 0.5):        
		return true;
	else:
		return false;

func process_input(action: String, device_id: int) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;

	var inputs = InputMap.action_get_events(action);
	var controller;

	assert(inputs.size() != 0, "The action, " + action + ", has no events. Or the action is non-existent.");

	var button_properties: InputEventJoypadButton = null;
	var joystick_properties: InputEventJoypadMotion = null;

	var has_controller = false;

	for input in inputs:
		if Editor_ButtonPromptsManager.Instance.auto_switch_prompts:
			var device_number;

			if input.device < 0: device_number = device_id;
			else: device_number = input.device;

			controller = Input.get_joy_name(Input.get_connected_joypads().find(device_number));
			
			if controller == "":
				controller = Input.get_joy_name(Input.get_connected_joypads().find(device_id));
			
			controller = Editor_ButtonPromptsManager.Instance.get_controller_type(controller);
			
		else:
			controller = Editor_ButtonPromptsManager.Instance.connected_controller;
		
		if input is InputEventJoypadButton:
			button_properties = input;
			has_controller = true;
		elif input is InputEventJoypadMotion:
			joystick_properties = input;
			has_controller = true;

	on_controller_input.emit(button_properties, joystick_properties, has_controller, action, controller);