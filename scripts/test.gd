extends Control

@onready var input_field = $VBoxContainer/InputField
#@onready var chat_display = $VBoxContainer/ChatDisplay
@onready var chat_display = $ChatDisplay
@onready var send_button = $VBoxContainer/SendButton
@onready var agent = $Agent

# Called when the node enters the scene tree for the first time.
func _ready():
	#send_button.pressed.connect(_on_send_button_pressed)
	agent.response_received.connect(_on_agent_response)
	agent.error.connect(_on_agent_error)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_send_button_pressed():
	var message = input_field.text
	agent.reply(message)
	chat_display.text +="\nYou: " + message
	input_field.text=""
	print(chat_display.text)
	
	
func _on_agent_response(response_text):
	print("on agent response called")
	chat_display.text += "\nAI: " + response_text

func _on_agent_error(error_message):
	chat_display.text += "\nError: " + error_message
	print("Error ", error_message)
