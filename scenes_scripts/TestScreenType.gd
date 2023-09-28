extends Control

onready var label_question_number = get_node("LabelQuestionNumber")
onready var label_subject = get_node("LabelSubject")
onready var label_topic = get_node("LabelTopic")
onready var label_question_type = get_node("LabelQuestionType")
onready var label_answer_type = get_node("LabelAnswerType")
var questions = {} #> Subdirectory of GlobalDatabase's Topics
onready var edit_question = get_node("EditQuestion")
onready var edit_answer = get_node("EditAnswer")
var question_mode = 0 # 0 if asking with Term and 1 if asking with def.
var question_number = 0
var question_number_all = 0
var current_question: Term
var current_question_index = 0
onready var animation_player = get_node("AnimationPlayer")
onready var main = get_parent()
signal answered_with_text  ## not empty answer
var cycle_enabled = false
var answered_right = {}
var answered_wrong = {}
onready var button_next = get_node("ButtonNext")


func _ready():
   GlobalFunctions.set_font(edit_question, 50)
   GlobalFunctions.set_font(edit_answer, 50)
   if not button_next.is_connected("pressed", self, "validate_answer"):
      button_next.connect("pressed", self, "validate_answer")  # needs to be set bcz for some reason it sometimes resets
   if not self.is_connected("answered_with_text", self, "question_answered"):
      self.connect("answered_with_text", self, "question_answered")
   pass

func set_data(ignore_categories: bool, subject: String, topic: String, question_type: int, cycle: bool):
   question_mode = question_type
   if question_mode == 0:
      label_question_type.text = "Term:"
      label_answer_type.text = "Definition:"
   elif question_mode == 1:
      label_question_number.text = "Definition:"
      label_answer_type.text = "Term:"
   
   questions = GlobalDatabase.filter(ignore_categories, subject, topic, cycle)
   cycle_enabled = cycle
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
   
   if question_mode == 0:
     edit_question.text = current_question.text
   else:
     edit_question.text = current_question.definition
   edit_answer.text = ""
   label_subject.text = "Subject: " + current_question.subject
   label_topic.text = "Topic: " + current_question.topic
   pass

func validate_answer():
   if edit_answer.text != "":
     emit_signal("answered_with_text")
   pass

func question_answered():
   if (question_mode == 0 and edit_answer.text.to_lower().strip_edges() == current_question.definition.to_lower()) or \
     (question_mode == 1 and edit_answer.text.to_lower().strip_edges() == current_question.text.to_lower()):
       answered_right[current_question_index] = current_question
       if cycle_enabled:
         if current_question.actuality_day_count == GlobalDatabase.term_returning_cycles[-1]:
            current_question.actuality_day_count = -1   #####ADDITIONAL THINGS IF IT IS DONE, REMOVE OR WHAT
         elif current_question.actuality_day_count != -1:
            current_question.actuality_day_count = GlobalDatabase.term_returning_cycles[GlobalDatabase.term_returning_cycles.find(current_question.actuality_day_count)+1]
       animation_player.play("GreenCover")
   else:
     animation_player.play("RedCover")
     answered_wrong[current_question_index] = current_question
   yield(animation_player, "animation_finished")
   questions.erase(current_question_index)
   question_number += 1
   if question_number == question_number_all:
     summarize()
   else:
     next_question()
   pass

func summarize():
   main.change_screen(2)
   GlobalFunctions.show_warning(main, "", String(question_number_all) + " answered, " + "\n" + \
   String(answered_right.size()) + " was correct.")
   GlobalDatabase.save_data()
   pass
