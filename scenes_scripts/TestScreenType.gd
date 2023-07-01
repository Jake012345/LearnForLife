extends Control

onready var label_question_number = get_node("LabelQuestionNumber")
onready var label_question_mode = get_node("LabelQuestionMode")
onready var label_subject = get_node("LabelSubject")
onready var label_topic = get_node("LabelTopic")
var questions = {} #> Subdirectory of GlobalDatabase's Topics
var answered = {}
onready var edit_question = get_node("EditQuestion")
onready var edit_answer = get_node("EditAnswer")
var question_mode = 0 # 0 if asking with Term and 1 if asking with def.
var question_number = 0
var question_number_all = 0
var current_question = Term
var current_question_index
var right_answer_count = 0
onready var animation_player = get_node("AnimationPlayer")
onready var main = get_parent()
signal answered_with_text  ## not empty answer

func _ready():
   GlobalFunctions.set_font(edit_question, 50)
   GlobalFunctions.set_font(edit_answer, 50)
   pass

func set_data(subject: String, topic: String, question_type: int):
   label_subject.text = "Subject: " + subject
   label_topic.text = "Topic: " + topic
   label_question_mode.text = "   Asking with: " + ("Term" if question_type == 0 else "Definition") + "\n" + \
   "Answering with: " + ("Term" if question_type == 1 else "Definition")
   question_mode = question_type
   
   questions = GlobalDatabase.filter(subject, topic, false)
   question_number_all = questions.size()
   question_number = 0
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
   pass

func validate_answer():
   if edit_answer.text != "":
      emit_signal("answered_with_text")
   pass

func question_answered():
   if (question_mode == 0 and edit_answer.text.to_lower().strip_edges() == current_question.definition.to_lower()) or \
      (question_mode == 1 and edit_answer.text.to_lower().strip_edges() == current_question.text.to_lower()):
         right_answer_count += 1
         current_question.creation_day = int(Time.get_unix_time_from_system())
         animation_player.play("GreenCover")
   else:
      animation_player.play("RedCover")
   yield(animation_player, "animation_finished")
   questions.erase(current_question_index)
   answered[current_question_index] = current_question
   question_number += 1
   if question_number == question_number_all:
      summarize()
   else:
      next_question()
   pass

func summarize():
   main.change_screen(2)
   GlobalFunctions.show_warning(main, "", String(question_number_all) + " answered, " + "\n" + \
   String(right_answer_count) + " was correct.")
   GlobalDatabase.save_data()
   pass
