extends Node2D

var player_words = []
var current_story
var intro_text

func _ready():
	reset_textbox()
	set_random_story()
	$Background/StoryText.bbcode_enabled = true
	var intro = get_from_JSON("other_text.json")
	intro_text = intro[0]
	$Background/StoryText.bbcode_text = (intro_text.intro +
		"\nCan I have " + current_story.inputs[player_words.size()] + " , please?")
		
func set_random_story():
	var stories = get_from_JSON("loopy_lips.JSON")
	randomize()
	current_story = stories[randi() % stories.size()]
	
func get_from_JSON(filename):
	var file = File.new()
	file.open(filename, File.READ)
	var text = file.get_as_text()
	var data = parse_json(text)
	file.close()
	return data

	
func _on_TextBox_text_entered(new_text):
	player_words.append(new_text)
	check_number_of_words()
	reset_textbox()

func _on_EnterButton_pressed():
	if is_story_done():
		get_tree().reload_current_scene()
	else:
		var new_text = $Background/TextBox.get_text()
		_on_TextBox_text_entered(new_text)

func reset_textbox():
	$Background/TextBox.text = ""
	
func prompt_player():
	$Background/StoryText.bbcode_text = ("Can I have " + current_story.inputs[player_words.size()] + " , please?")
	
func is_story_done():
	return player_words.size() == current_story.inputs.size()
	
func check_number_of_words():
	if is_story_done():
		tell_story()
	else:
		prompt_player()
		
func game_over():
	$Background/TextBox.queue_free()
	
func tell_story():
	$Background/StoryText.bbcode_text = current_story.story % player_words
	$Background/EnterButton/ButtonLabel.text = "Doogan?"
	game_over()