extends Control

@onready var input = $Input
@onready var display = $Display
@onready var button = $Button
@onready var agent = $Agent

# Called when the node enters the scene tree for the first time.
func _ready():

	button.pressed.connect(_on_button_pressed)
	agent.response_received.connect(_on_agent_response)
	agent.error.connect(_on_agent_error)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_pressed():
	var message = input.text
	agent.reply(message)
	display.text +="\nYou: " + message
	input.text = ""
	print(display.text)
	
func _on_agent_response(response_text):
	display.text += "\nAI: " + response_text
	
func _on_agent_error(error_message):
	display.text += "\nError: "+error_message
	print("error ", error_message)
