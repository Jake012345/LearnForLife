extends TabContainer

onready var selector_button_terms = get_parent().get_node("HBoxContainer/ButtonEditTerms")
onready var selector_button_subjects = get_parent().get_node("HBoxContainer/ButtonEditSubjects")
onready var selector_button_topics = get_parent().get_node("HBoxContainer/ButtonEditTopic")
signal refresh_data

func _ready():
   current_tab = 0
   pass

func change_edit_mode(to: int):
   current_tab = to
   emit_signal("refresh_data")
   if to == 0:
      selector_button_subjects.pressed = false
      selector_button_topics.pressed = false
   elif to == 1:
      selector_button_terms.pressed = false
      selector_button_topics.pressed = false
   else:
      selector_button_subjects.pressed = false
      selector_button_terms.pressed = false
   pass
