extends Control

onready var subject_selector = get_node("SubjectSelector")
onready var topic_selector = get_node("TopicSelector")
onready var check_cards = get_node("CheckCards")
onready var check_type = get_node("CheckType")
onready var main = get_parent()
onready var screen_cards = main.get_node("TestScreenCard")
onready var screen_type = main.get_node("TestScreenType")
onready var question_type_selector = get_node("QuestionTypeSelector")
onready var answer_type_selector = get_node("AnswerTypeSelector")


func _ready():
   GlobalFunctions.set_font(subject_selector, 32)
   GlobalFunctions.set_font(topic_selector, 32)
   GlobalFunctions.set_font(question_type_selector, 32)
   GlobalFunctions.set_font(answer_type_selector, 32)
   pass


func mode_select(mode: int = -1):
   if mode == 0:  #card mode
      check_type.pressed = false
   if mode == 1:  #type mode
      check_cards.pressed = false
   pass


func refresh_data():
   subject_selector.clear()
   for i in GlobalDatabase.subjects:
      subject_selector.add_item(i.text)
   refresh_topic_data()
   pass

func refresh_topic_data(selected_subject: int = -1):
   if selected_subject == -1:
      selected_subject = subject_selector.get_selected_id()
   topic_selector.clear()
   if selected_subject  != -1:
      for i in GlobalDatabase.subjects[selected_subject].topics:
         topic_selector.add_item(i)
   else:
      GlobalFunctions.show_warning(main, "go_to_add", "You need to add cards first!")
   pass

func question_type_changed(index):
   answer_type_selector.selected = abs(1 - index) # sets to 1 if 0 or 0 if 1
   pass

func answer_type_changed(index):
   question_type_selector.selected = abs(1 - index) # sets to 1 if 0 or 0 if 1
   pass

func start_test():
   if subject_selector.text == "" or topic_selector.text == "": #nothing's selected
      GlobalFunctions.show_warning(self, "", "Both Subject and topic needs to be specified to start the test.")
      return
   if check_cards.pressed:
      main.change_screen(4)  #cards screen
      screen_cards
   elif check_type.pressed:
      main.change_screen(5) #type screen
      screen_type.set_data(subject_selector.text, topic_selector.text, question_type_selector.selected)
   #elif ..... other screens
   else: # nothing selected
      GlobalFunctions.show_warning(self, "", "You have to choose a mode for testing.")
   pass
