extends Control

onready var edit_question = get_node("EditQuestion")
onready var edit_answer = get_node("EditAnswer")
onready var label_question_number = get_node("LabelQuestionNumber")
onready var label_question_type = get_node("LabelQuestionType")
onready var label_anwer_type = get_node("LabelAnswerType")
onready var label_subject = get_node("LabelSubject")
onready var label_topc = get_node("LabelTopic")
var cycle_enabled: bool = false
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

func _ready():

   pass


func set_data(ignore_categories: bool, subject: String, topic: String, question_type: int, cycle: bool):
   if question_type == 0:
      label_question_type.text = "Term:"
      label_anwer_type.text = "Definition:"
   elif question_type == 1:
      label_question_type.text = "Definition:"
      label_anwer_type.text = "Term:"
   cycle_enabled = cycle
   question_mode = question_type
   questions = GlobalDatabase.filter(ignore_categories, subject, topic, cycle_enabled)
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
      edit_question.text = current_question.text
   elif question_mode == 1:
      edit_question.text = current_question.definition

   var random_tf = randi() % 2    ### TRUE(0) OR FALSE(1) ANSWER
   if random_tf == 0:   #### TRUE ANSWER
      edit_answer.text = current_question.definition
   elif random_tf == 1:
      var tmp_wrong_answers: Dictionary = {}   ### FALSE ANSWERS
      tmp_wrong_answers.merge(questions)
      tmp_wrong_answers.merge(answered_wrong)
      if tmp_wrong_answers.size() <= 1:
         tmp_wrong_answers.merge(answered_right)
      if tmp_wrong_answers.has(current_question_index) and \
         tmp_wrong_answers.size() > 1:  ## because if the all question base is 1, erasing the self, makes the possibile  answers to be 0 .. >:3
         tmp_wrong_answers.erase(current_question_index)
      tmp_random_i = randi() % tmp_wrong_answers.size() ### RANDOM FALSE ANSWER
      tmp_random_counter = 0
      for i in tmp_wrong_answers:  ## SELECT THE RNADOM ANSWER
         if question_mode == 0:  ## SETTING RANDOM ANSWER BASED ON QUESTION MODE
            edit_answer.text = tmp_wrong_answers[i].definition
         elif question_mode == 1:
            edit_answer.text = tmp_wrong_answers[i].text
         if tmp_random_counter == tmp_random_i:
            break
         tmp_random_counter += 1
   pass


func question_answered(answer:bool):
   if (((current_question.text == edit_answer.text) and (current_question.definition == edit_question.text)) and (question_mode == 1) or \
   ((current_question.definition == edit_answer.text) and (current_question.text == edit_question.text)) and (question_mode == 0)) == answer:
      question_answered_right()
   else:
      question_answered_wrong()
   pass

func question_answered_right():
   answered_right[current_question_index] = current_question
   questions.erase(current_question_index)
   if cycle_enabled:
      if current_question.actuality_day_count == GlobalDatabase.term_returning_cycles[-1]:
         current_question.actuality_day_count = -1   #####ADDITIONAL THINGS IF IT IS DONE, REMOVE OR WHAT
      elif current_question.actuality_day_count != -1:
         current_question.actuality_day_count = GlobalDatabase.term_returning_cycles[GlobalDatabase.term_returning_cycles.find(current_question.actuality_day_count)+1]
   animate_feedback(true)
   pass

func question_answered_wrong():
   answered_wrong[current_question_index] = current_question
   questions.erase(current_question_index)
   animate_feedback(false)
   pass

func animate_feedback(green:bool):
   if green:
      animation_player.play("Green Cover")
   else:
      animation_player.play("Red Cover")
   yield(animation_player, "animation_finished")
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
