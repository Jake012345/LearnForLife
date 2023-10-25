extends Control

onready var display_text = get_node("DisplayText")
onready var label_question_number = get_node("LabelQuestionNumber")
onready var label_subject = get_node("LabelSubject")
onready var label_topic = get_node("LabelTopic")
onready var label_mode = get_node("LabelMode")
var cycle_filter_enabled: bool = false
var cycle_apply_enabled: bool = false
var questions = {}
onready var main = get_parent()
var question_number_all = 0
var question_number = 0
var answered_right = {}
var answered_wrong = {}
var current_question_index = 0
var current_question: Term = null
var question_mode = 0
onready var animation_player = get_node("AnimationPlayer")
export var showing: int # 0--> term is being showed;  1--> definition is on stage

func _ready():

   pass


func set_data(ignore_categories: bool, subject: String, topic: String, question_type: int, cycle_filter: bool, cycle_apply: bool):
   cycle_filter_enabled = cycle_filter
   cycle_apply_enabled = cycle_apply
   question_mode = question_type
   questions = GlobalDatabase.filter(ignore_categories, subject, topic, cycle_filter)
   if questions.size() == 0:
     GlobalFunctions.show_warning(self, "", "You dont have any cards matching the conditions.")
     main.change_screen(2)
     return
   question_number_all = questions.size()
   question_number = 0
   answered_right.clear()
   answered_wrong.clear()
   next_question()
   pass

func next_question():
   label_question_number.text = String(question_number + 1) + "/" + String(question_number_all)
   var tmp_random_i
   var tmp_random_counter = 0
   for i in rand_range(0, questions.size()):  ### random elenemt from the dictionary
     tmp_random_i = i
   for i in questions:
     current_question_index = i
     current_question = questions[i]
     if tmp_random_counter == tmp_random_i:
       break
     tmp_random_counter += 1
   
   if question_mode == 0:  ####ASKING /W TERM
      display_text.text = current_question.text
      showing = 0
   elif question_mode == 1:
      display_text.text = current_question.definition
      showing = 1
   label_subject.text = "Subject: " + current_question.subject
   label_topic.text = "Topic: " + current_question.topic
   pass


func question_answered(answer:bool):
   if answer:
      answered_right[current_question_index] = current_question
      questions.erase(current_question_index)
      if cycle_apply_enabled and GlobalDatabase.calculate_actuality_of_term(current_question):
         if current_question.actuality_day_count == GlobalDatabase.term_returning_cycles[-1]:
            current_question.actuality_day_count = -1   #####ADDITIONAL THINGS IF IT IS DONE, REMOVE OR WHAT
         elif current_question.actuality_day_count != -1:
            current_question.actuality_day_count = GlobalDatabase.term_returning_cycles[GlobalDatabase.term_returning_cycles.find(current_question.actuality_day_count)+1]
   else:
      answered_wrong[current_question_index] = current_question
      questions.erase(current_question_index)
   question_number += 1
   if questions.size() > 0:
      next_question()
   else:
      summarize()
   pass


func summarize():
   main.change_screen(2)
   GlobalFunctions.show_warning(main, "", String(question_number_all) + " answered, " + "\n" + \
   String(answered_right.size()) + " was correct.")
   GlobalDatabase.save_data()
   pass


func turn():
   GlobalFunctions.animate_text(label_mode, float(0.3), false)
   animation_player.play("Narrowing")
   yield(animation_player, "animation_finished")
   if showing == 0: #terms is showed
      showing = 1
      display_text.text = current_question.definition
      label_mode.text = "Definition:"
      GlobalFunctions.animate_text(label_mode, float(0.5))
   else: #definition is showed
      showing = 0
      display_text.text = current_question.text
      label_mode.text = "Term:"
      GlobalFunctions.animate_text(label_mode, float(0.5))
   animation_player.play("Widening")
   pass
