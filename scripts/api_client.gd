extends Node

""" 
This script handles prompting your conversational AI model.
It is written with OpenAI API in mind but you should be able to modify it
to use any LLM through API.
The functions are only the most basic parts of creating a conversational agent,
you can add your own functions to add diferent actions in this and other scripts.
"""

var API_KEY = ""  # your API key here
var base_url = "https://api.openai.com/v1/chat/completions"

signal response_received(response_text)
signal error(error_message)

func _ready():
	# load API key from env
	Dotenv.load_("res://scripts/.env")
	API_KEY = OS.get_environment("API_KEY")
	print(API_KEY)

func send_message(message: String, conversation_history: Array=[]) -> void:
	
	var http_request = HTTPRequest.new()
	add_child(http_request)
	
	http_request.request_completed.connect(_on_request_completed.bind(http_request))
	
	var headers = ["Content-Type: application/json", "Authorization: Bearer " + API_KEY]
	
	# messages array to keep history as context
	var messages = []
	
	# set system prompt
	var system_prompt = _system_prompt()
	messages.append({"role": "system", "content": system_prompt})
	
	for msg in conversation_history:
		messages.append(msg)
		
	messages.append({"role": "user", "content": message})
	
	var body = JSON.stringify({
		"model": "gpt-3.5-turbo",
		"messages": messages,
		"max_tokens": 150,
		"temperature": 0.7
		})
   
	var error = http_request.request(base_url, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		emit_signal("error", "Error creating request: " + str(error))
		http_request.queue_free()
	print("API client send message has been accessed")


func _system_prompt():
	"""
	set the system prompt as the "backgrount" prompt you want for your agent
	"""
	# example system prompt
	var system_prompt = """
	You are a tired Data Science and AI student annoyed with all the assignments you have to do.
	Reply to all questions as this tired student.
	"""
	
	return system_prompt
	
func _on_request_completed(result, response_code, headers, body):
	print("response code: "+response_code)
	
	if response_code == 200:
		var json = JSON.new()
		var parse_result = json.parse(body.get_string_from_utf8())
		
		if parse_result == OK:
			var response_data = json.get_data()
			var response_text = response_data["choices"][0]["message"]["content"]
			emit_signal("response_received", response_text.strip())
		else:
			emit_signal("error", "can't parse")
	else:
		emit_signal("error", "request failed")
		
	
