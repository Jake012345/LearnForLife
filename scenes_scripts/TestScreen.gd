extends Control

onready var subject_selector = get_node("SubjectSelector")
onready var topic_selector = get_node("TopicSelector")
onready var check_cards = get_node("CheckCards")
onready var check_type = get_node("CheckType")
onready var check_true_false = get_node("CheckTrueFalse")
onready var main = get_parent()
onready var screen_true_false = main.get_node("TestScreenTrueFalse")
onready var screen_type = main.get_node("TestScreenType")
onready var screen_cards = main.get_node("TestScreenCard")
onready var question_type_selector = get_node("QuestionTypeSelector")
onready var answer_type_selector = get_node("AnswerTypeSelector")
onready var check_cycle = get_node("CheckEnableCycle")
onready var check_ignore_categories = get_node("CheckIgnoreCategories")


func _ready():
   GlobalFunctions.set_font(subject_selector, 32)
   GlobalFunctions.set_font(topic_selector, 32)
   GlobalFunctions.set_font(question_type_selector, 32)
   GlobalFunctions.set_font(answer_type_selector, 32)
   pass


func mode_select(mode: int = -1):   # later maybe with group? :D
   if mode == 0:  #card mode
      check_type.pressed = false
      check_true_false.pressed = false
   if mode == 1:  #type mode
      check_cards.pressed = false
      check_true_false = false
   if mode == 2: #true-false mode
      check_cards.pressed = false
      check_type.pressed = false
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
   if GlobalDatabase.terms.size() == 0:
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
      screen_cards.set_data(check_ignore_categories.pressed, subject_selector.text, topic_selector.text, question_type_selector.selected, check_cycle.pressed)
   elif check_type.pressed:
      main.change_screen(5) #type screen
      screen_type.set_data(check_ignore_categories.pressed, subject_selector.text, topic_selector.text, question_type_selector.selected, check_cycle.pressed)
   elif check_true_false.pressed:
      main.change_screen(6)
      #screen_cards.set_data(check_ignore_categories.pressed, subject_selector.text, topic_selector.text, question_type_selector.selected, check_cycle.pressed)
   #elif ..... other screens
   else: # nothing selected
      GlobalFunctions.show_warning(self, "", "You have to choose a mode for testing.")
   pass


func help_cycle():
   GlobalFunctions.show_warning(self, "", "Enable the cycle system to answer questions if the preveiously set amount of days have passed. \n (See more in the Settings)")
   pass


func help_ignore_categories():
   GlobalFunctions.show_warning(self, "", "Ignoring categories causes you to get questions from all categories. \n (The cycle system can be enabled still)")
   pass
