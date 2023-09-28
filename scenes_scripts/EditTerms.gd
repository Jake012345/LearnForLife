extends Control

onready var sort_selector = get_node("OptionButtonSort")
onready var select_subject = get_node("OptionButtonSubject")
onready var select_topic = get_node("OptionButtonTopic")
onready var list_terms = get_node("TermsList")
onready var terms_sorted = []
onready var definition_display = get_node("DefinitonDisplay")
onready var label_selected_subject = get_node("LabelSelectedSubject")
onready var label_selected_topic = get_node("LabelSelectedTopic")
onready var label_selected_creation_day = get_node("LabelSelectedCreationDay")
onready var label_selected_cycle_state = get_node("LabelSelectedCycleState")
onready var term_editor = get_node("TermEditor")
onready var edit_term = get_node("TermEditor/Panel/EditTerm")
onready var edit_definition = get_node("TermEditor/Panel/EditDefinition")
onready var check_reset_cycle = get_node("TermEditor/Panel/CheckResetCycle")
onready var term_edit_select_subject = get_node("TermEditor/Panel/SubjectSelector")
onready var term_edit_select_topic = get_node("TermEditor/Panel/TopicSelector")
var selected_term: Term = null

func _ready():
   GlobalFunctions.set_font(sort_selector, 32)
   GlobalFunctions.set_font(select_subject, 32)
   GlobalFunctions.set_font(select_topic, 32)
   GlobalFunctions.set_font(list_terms, 32)
   GlobalFunctions.set_font(term_edit_select_subject, 32)
   GlobalFunctions.set_font(term_edit_select_topic, 32)
   list_terms.get_v_scroll().visible = true
   GlobalFunctions.set_wide_scroll(list_terms.get_v_scroll())
   term_editor.visible = false
   pass

func refresh_data(_args = 0):
   definition_display.text = ""
   list_terms.clear()
   if sort_selector.selected == 0:
     refresh_data_alphabetical()
   if sort_selector.selected == 1:
     if select_subject.selected != -1:
       if select_topic.selected != -1:
         refresh_data_st_based()
   label_selected_subject.text = "Subject:"
   label_selected_topic.text = "Topic:"
   label_selected_creation_day.text = "Creation day:"
   label_selected_cycle_state.text = "Current cycle: \nDate: \nRemainig:"
   pass

func refresh_data_alphabetical():
   var tmp_terms = []
   var tmp_terms_sorted = []  
   for i in GlobalDatabase.terms:
     tmp_terms.append([i, GlobalDatabase.terms[i]])
   while tmp_terms.size() > 0:
     var tmp_min = tmp_terms[0]
     for i in tmp_terms:
       if i[1].text < tmp_min[1].text:
         tmp_min = i
     tmp_terms_sorted.append(tmp_min)
     tmp_terms.remove(tmp_terms.find(tmp_min))
   #theorically we have the list ordered
   list_terms.clear()
   for i in tmp_terms_sorted:
     list_terms.add_item(i[1].text)
     # conditions if we need to see the subject/topic etc.
   terms_sorted = tmp_terms_sorted
   pass

func refresh_data_st_based():
   terms_sorted.clear()
   var filter_subject = select_subject.text
   var filter_topic = select_topic.text
   for i in GlobalDatabase.terms:
     if GlobalDatabase.terms[i].subject == filter_subject:
       if GlobalDatabase.terms[i].topic == filter_topic:
         list_terms.add_item(GlobalDatabase.terms[i].text)
         terms_sorted.append([i, GlobalDatabase.terms[i]])
   pass

func delete_term():
   if selected_term != null:
      GlobalFunctions.show_warning(self, "delete_term_accepted", "Are you sure you want to delete the selected Term?")
   else:
      GlobalFunctions.show_warning(self, "", "You need to select a Term first.")
   pass

func delete_term_accepted():
   list_terms.remove_item(terms_sorted.find(selected_term))
   GlobalDatabase.remove_term(selected_term)
   terms_sorted.remove(terms_sorted.find(selected_term))
   refresh_data()
   selected_term = null
   pass


func term_selected(index):
   selected_term = terms_sorted[index][1]
   definition_display.text = selected_term.definition
   label_selected_subject.text = "Subject:" + "\n" + selected_term.subject
   label_selected_topic.text = "Topic:" + "\n" + selected_term.topic
   label_selected_creation_day.text = "Day of creation: \n" + String(selected_term.creation_day.year) + "/" + String(selected_term.creation_day.month) + "/" + String(selected_term.creation_day.day)
   if selected_term.actuality_day_count != -1:
     var date_of_cycle = selected_term.creation_day.date_after_days(selected_term.actuality_day_count)
     label_selected_cycle_state.text = "Current cycle: " + String(selected_term.actuality_day_count) + "\n" + "Date: " + String(date_of_cycle["year"]) + "/" + String(date_of_cycle["month"]) + "/" + String(date_of_cycle["day"])
     var unix_date_of_cycle = selected_term.creation_day.unix_date_after_days(selected_term.actuality_day_count)
     var difference_between_dates = int((unix_date_of_cycle - Time.get_unix_time_from_datetime_dict(Time.get_date_dict_from_system())) / 86400)
     if difference_between_dates == 0:
       label_selected_cycle_state.text += "\n" + "Actual Today!"
     if difference_between_dates < 0:
       label_selected_cycle_state.text += "\n" + "Overdue by: " + String(abs(difference_between_dates)) + " day(s)"
     if difference_between_dates > 0:
       label_selected_cycle_state.text += "\n" + "Remaining: " + String(abs(difference_between_dates)) + " day(s)"
   else:
     label_selected_cycle_state.text = "You know it!"
   pass


func refresh_subject_list(index):
   select_subject.clear()
   select_topic.clear()
   if index == 1:
     for i in GlobalDatabase.subjects:
       select_subject.add_item(i.text)
   if select_subject.get_item_count() > 0:
     select_subject.select(0)
     select_subject.emit_signal("item_selected", [0])
   pass


func refresh_topic_list(_index):
   select_topic.clear()
   for i in GlobalDatabase.get_subject_by_name(select_subject.text).topics:
     select_topic.add_item(i)
   if select_topic.get_item_count() > 0:
     select_topic.select(0)
     select_topic.emit_signal("item_selected", [0])
   pass


func edit_selected_term():
   term_edit_select_subject.clear()
   if list_terms.get_selected_items().size() > 0:
      selected_term = terms_sorted[list_terms.get_selected_items()[0]][1]
      term_editor.show()  #### somewhy any other kind of show does not work as well as .popup does not D:
      edit_term.text = selected_term.text
      edit_definition.text = selected_term.definition
      for i in GlobalDatabase.subjects:
         term_edit_select_subject.add_item(i.text)
      term_edit_select_subject.select(term_edit_select_subject.items.find(selected_term.subject))
      refresh_term_edit_topic(term_edit_select_subject.selected)
   else:
      GlobalFunctions.show_warning(self, "", "You haven't selected a term to edit yet.")
   pass

func refresh_term_edit_topic(index: int = -1):
   term_edit_select_topic.clear()
   selected_term = terms_sorted[list_terms.get_selected_items()[0]][1]
   var selected_subject: Subject = GlobalDatabase.get_subject_by_name(term_edit_select_subject.get_item_text(index))
   for i in selected_subject.topics:
      term_edit_select_topic.add_item(i)
   term_edit_select_topic.select(term_edit_select_topic.items.find(selected_term.topic))
   pass


func term_edit_cancel():
   term_editor.hide()
   pass


func term_edit_accept():
   if edit_term.text != "" and edit_definition.text != "" and \
   term_edit_select_subject.selected != -1 and term_edit_select_topic.selected != -1:
      GlobalFunctions.show_warning(self, "term_edit_accepted", "Are you sure that you want to set these new vales on the card?")
   else:
      GlobalFunctions.show_warning(self, "", "You need to set every data propeerly on the card. \n(Term, Definition, Subject and Topic)")
   pass

func term_edit_accepted():
   term_editor.hide()
   selected_term.text = edit_term.text
   selected_term.definition = edit_definition.text
   selected_term.subject = term_edit_select_subject.text
   selected_term.topic = term_edit_select_topic.text
   if check_reset_cycle.pressed:
      selected_term.creation_day.set_today()
      selected_term.actuality_day_count = GlobalDatabase.term_returning_cycles[0]
   GlobalDatabase.save_data()
   pass
