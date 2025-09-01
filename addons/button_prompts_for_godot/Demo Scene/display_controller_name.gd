extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event) -> void:
	text = "Connected controller: " + Input.get_joy_name(0) + ". Loaded Texture: " + str(ButtonPromptsManager.Instance.textures);
