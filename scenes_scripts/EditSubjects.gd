extends Control

onready var list_subjects = get_node("SubjectSelector")
onready var list_topics = get_node("TopicSelector")
onready var edit_dialog = get_node("EditDialog")
onready var edit_dialog_text = get_node("EditDialog/LineEdit")
onready var edit_dialog_cancel = get_node("EditDialog/ButtonCancel")
onready var edit_dialog_accept = get_node("EditDialog/ButtonAccept")
onready var edit_dialog_title = get_node("EditDialog/Label")
var dialog_accepted = false
signal dialog_answered
onready var label_subject_topics = get_node("LabelSubjectTopics")
onready var label_subject_terms = get_node("LabelSubjectTerms")
onready var label_topic_terms = get_node("LabelTopicTerms")
var selected_subject: Subject = null
var selected_topic = ""


func _ready():
   
   pass

func refresh_all_data():
   refresh_data()
   refresh_topic_data()
   label_subject_terms.text = 'Terms:'
   label_subject_topics.text = "Topics:"
   label_topic_terms.text = "Terms:"
   pass

func refresh_data():
   list_subjects.clear()
   for i in GlobalDatabase.subjects:
     list_subjects.add_item(i.text)
   list_subjects.sort_items_by_text()
   pass

func refresh_topic_data(index = -1):
   list_topics.clear()
   selected_subject = null
   if index != -1:
      selected_subject = GlobalDatabase.get_subject_by_name(list_subjects.get_item_text(index))
   if selected_subject != null:
      for i in selected_subject.topics:
         list_topics.add_item(i)
      label_subject_topics.text = "Topics:" + "\n" + String(selected_subject.topics.size())
      label_subject_terms.text = "Terms:" + "\n" + String(GlobalDatabase.get_terms_by_subject(selected_subject).size())
   list_topics.sort_items_by_text()
   topic_selected()
   pass


func delete_subject():
   if selected_subject != null:
      GlobalFunctions.show_warning(self, "subject_deletion_accepted", \
   "Do you really want to delete the selected Subject(s)?" + "\n" + \
   "(The connected Topics and Terms are going to be deleted as well.)")
   else:
      GlobalFunctions.show_warning(self, "", "You need to select a Subject to remove.")
   pass

func subject_deletion_accepted():
   if selected_subject != null:
      GlobalDatabase.remove_subject_by_index(GlobalDatabase.subjects.find(selected_subject))
      list_subjects.remove_item(list_subjects.items.find(selected_subject.text))
      refresh_all_data()
      selected_subject = null
   pass

func delete_topic():
   if list_topics.get_selected_items().size() > 0:
      selected_topic = list_topics.get_item_text(list_topics.get_selected_items()[0])
      GlobalFunctions.show_warning(self, "topic_deletion_accepted", \
   "Do you really want to delete the selected Topic(s)?" + "\n" + \
   "(The connected Terms are going to be deleted as well.)")
   else:
      GlobalFunctions.show_warning(self, "", "You need to select a Topic to remove.")
   pass

func topic_deletion_accepted():
   if selected_topic != "":
      GlobalDatabase.remove_topic(selected_subject, selected_topic)
      list_topics.remove_item(list_topics.get_selected_items()[0])
      #list_topics.remove_item(list_topics.items.find(selected_topic))
      selected_topic = ""
      topic_selected()
   pass


func edit_subject():
   if list_subjects.get_selected_items().size() > 0:
     dialog_accepted = false
     edit_dialog_text.text = ""
     var selected_subject_name = list_subjects.get_item_text(list_subjects.get_selected_items()[0])
     var selected_subject = GlobalDatabase.get_subject_by_name(selected_subject_name)
     edit_dialog.popup_centered(Vector2(1000, 500))  #### somewhy the editor settins are twisted in runtime so need to se these from code
     edit_dialog_text.rect_size = Vector2(900, 100)
     edit_dialog_text.rect_position = Vector2(40, 150)
     edit_dialog_accept.rect_size = Vector2(200, 100)
     edit_dialog_accept.rect_position = Vector2(600, 350)
     edit_dialog_cancel.rect_size = Vector2(200, 100)
     edit_dialog_cancel.rect_position = Vector2(200, 350)
     edit_dialog_title.rect_position = Vector2(0, 50)
     edit_dialog_title.rect_size = Vector2(1000, 100)
     edit_dialog_accept.connect("pressed", self, "dialog_answered", [true, "subject", "", "", null])
     edit_dialog_cancel.connect("pressed", self, "dialog_answered", [false, "subject", "", "", null])
     yield(self, "dialog_answered")
     if dialog_accepted:
       GlobalDatabase.rename_subject(selected_subject, edit_dialog_text.text)
       list_subjects.set_item_text(list_subjects.get_selected_items()[0], edit_dialog_text.text)
   pass

func dialog_answered(accepted: bool, mode: String, subject: String, topic: String, _term: Term = null):
   if mode == "subject":
     subject = edit_dialog_text.text
   if mode == "topic":
     subject = list_subjects.get_item_text(list_subjects.get_selected_items()[0])
     topic = edit_dialog_text.text
   if edit_dialog_text.text != "" and not GlobalDatabase.exists(mode, subject, topic, ""):
     if accepted:
       dialog_accepted = true
     else:
       dialog_accepted = false
     emit_signal("dialog_answered")
     edit_dialog.hide()
   if not accepted:
     edit_dialog.hide()
   if edit_dialog.visible == false:
     edit_dialog_accept.disconnect("pressed", self, "dialog_answered")
     edit_dialog_cancel.disconnect("pressed", self, "dialog_answered")
   pass


func edit_topic():
   if list_topics.get_selected_items().size() > 0: 
     dialog_accepted = false
     edit_dialog_text.text = ""
     var selected_subject_name = list_subjects.get_item_text(list_subjects.get_selected_items()[0])
     var selected_subject = GlobalDatabase.get_subject_by_name(selected_subject_name)
     var selected_topic = list_topics.get_item_text(list_topics.get_selected_items()[0])
     edit_dialog.popup_centered(Vector2(1000, 500))  #### somewhy the editor settins are twisted in runtime so need to se these from code
     edit_dialog_text.rect_size = Vector2(900, 100)
     edit_dialog_text.rect_position = Vector2(40, 150)
     edit_dialog_accept.rect_size = Vector2(200, 100)
     edit_dialog_accept.rect_position = Vector2(600, 350)
     edit_dialog_cancel.rect_size = Vector2(200, 100)
     edit_dialog_cancel.rect_position = Vector2(200, 350)
     edit_dialog_title.rect_position = Vector2(0, 50)
     edit_dialog_title.rect_size = Vector2(1000, 100)
     edit_dialog_accept.connect("pressed", self, "dialog_answered", [true, "topic", selected_subject_name, edit_dialog_text.text, null])
     edit_dialog_cancel.connect("pressed", self, "dialog_answered", [false, "topic", selected_subject_name, edit_dialog_text.text, null])
     yield(self, "dialog_answered")
     if dialog_accepted:
       GlobalDatabase.rename_topic(selected_subject, selected_topic, edit_dialog_text.text)
       list_topics.set_item_text(list_topics.get_selected_items()[0], edit_dialog_text.text)
   pass


func topic_selected(index: int = -1):
   if index != -1:
      selected_topic = list_topics.get_item_text(index)
      label_topic_terms.text = "Terms:" + "\n" + String(GlobalDatabase.get_terms_by_topic(selected_topic).size())
   else:
      label_topic_terms.text = "Terms:"
   pass
