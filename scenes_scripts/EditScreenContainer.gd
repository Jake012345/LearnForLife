extends TabContainer

onready var selector_button_terms = get_parent().get_node("HBoxContainer/ButtonEditTerms")
onready var selector_button_subjects = get_parent().get_node("HBoxContainer/ButtonEditSubjects")

func _ready():
   current_tab = 0
   selector_button_terms.pressed = true
   pass

func change_edit_mode(to: int):
   if to != current_tab:
     current_tab = to
     get_child(current_tab).refresh_data()
     if to == 0:
       selector_button_subjects.pressed = false
     elif to == 1:
       selector_button_terms.pressed = false
