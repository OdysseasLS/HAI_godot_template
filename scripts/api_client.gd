extends Node

""" 
This script handles prompting your conversational AI model.
It is written with OpenAI API in mind but you should be able to modify it
to use any LLM through API.
"""

var API_KEY = ""  # your API key here
var base_url = "https://api.openai.com/v1/chat/completions"

func get_answer(context):
	#TODO: finish getting answer logic
	var http_request = HTTPRequest.new()
	add_child(http_request)
	
	http_request.connect("request_completed", self, "_on_request_completed")

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
	# TODO: fix errors
	if response_code == 200:
		var json_instance = JSON
		var json = json_instance.parse(body.get_string_from_utf8())
		var response_text = json.result.choices[0].message.content
		return response_text
	else:
		#TODO: add error message and logic
		push_error()
	
