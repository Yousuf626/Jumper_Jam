extends Node

func add_log_msg(log_str: String):
	print("printer called")
	var console = get_tree().get_first_node_in_group("debug_console")
	print(console)
	if console:
		var log_label = console.get_node("ScrollContainer/VBoxContainer/LogLabel")
		if log_label:
			print("LogLabel found: ", log_label)
			log_label.text += "\n" + log_str
		else:
			print("LogLabel not found")
	  
			
