extends Node

signal conversation_updated(message_history)
signal response_received(response_text)
signal error(error_message)

var conversation_history = []

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if ApiClient:
		ApiClient.response_received.connect(_on_response)
		ApiClient.error.connect(_on_error)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func reply(message: String):
	#if message.strip_edges()=="":
		#return
	print("i'm here for message "+message)
	var user_message = {"role": "user", "content": message}
	conversation_history.append(user_message)
	emit_signal("conversation_updated", conversation_history)
	
	ApiClient.send_message(message, conversation_history)
	print(conversation_history)
	

func _on_response(response_text: String):
	var message = {"role": "assistant", "content": response_text}
	print(response_text)
	conversation_history.append(message)
	
	emit_signal("response_received", response_text)
	emit_signal("conversation_updated", conversation_history)
	print(conversation_history)
	
func _on_error(error_message:String):
	emit_signal("error", error_message)
	
