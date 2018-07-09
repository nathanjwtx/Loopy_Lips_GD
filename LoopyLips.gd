extends Node2D

var story
var player_words = []
var inputs = ["a name", "a thing", "a feeling", "another feeling", "some things"]
var current_story = {
	"prompt": ["a name", "a thing", "a feeling", "another feeling", "some things"],
	"story": ["Once upon a time a %s ate a %s and felt very %s. It was a %s day for all good %s"]
	}

func _ready():
	reset_textbox()
	story = "Once upon a time a %s ate a %s and felt very %s. It was a %s day for all good %s"
	$Background/StoryText.bbcode_enabled = true
	$Background/StoryText.bbcode_text = ("Welcome to Loopy Lips. \nPlease follow the prompts for a word or phrase."
		+ "\nCan I have " + inputs[player_words.size()] + " , please?")
	

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
	$Background/StoryText.bbcode_text = ("Can I have " + inputs[player_words.size()] + " , please?")
	
func is_story_done():
	return player_words.size() == inputs.size()
	
func check_number_of_words():
	if is_story_done():
		tell_story()
	else:
		prompt_player()
		
func game_over():
	$Background/TextBox.queue_free()
	
func tell_story():
	$Background/StoryText.bbcode_text = story % player_words
	$Background/EnterButton/ButtonLabel.text = "Doogan?"
	game_over()