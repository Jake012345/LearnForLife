extends Button

onready var edit_term = get_parent().get_node("TextEditTerm")
onready var edit_definition = get_parent().get_node("TextEditDefinition")
onready var edit_subject = get_parent().get_node("OptionButtonSubject")
onready var edit_topic = get_parent().get_node("OptionButtonTopic")
onready var popup = get_node("ConfirmationDialog")
onready var popup_label = get_node("ConfirmationDialog/Label")
onready var popup_subject = get_node("PopupCreateSubject")
onready var popup_topic = get_node("PopupCreateTopic")

func _ready():
   var tmp_font = Theme.new()
   tmp_font.default_font = DynamicFont.new()
   tmp_font.default_font.font_data = load(GlobalDatabase.font)
   tmp_font.default_font.size = 50
   edit_subject.theme = tmp_font
   edit_topic.theme = tmp_font
   pass

func on_press():
   var term_filled
   var definition_filled
   var subject_filled
   var topic_filled
   
   if edit_term.text.strip_edges(true, true) != "":
      term_filled = true
   if edit_definition.text.strip_edges(true, true) != "":
      definition_filled = true
   if edit_subject.selected != -1:
      subject_filled = true
   if edit_topic.selected != -1:
      topic_filled = true

   if term_filled and definition_filled and subject_filled and topic_filled:
      create_term()
   else:
      popup_label.text += "You are missing the following data: \n"
      if not term_filled:
         popup_label.text += "- Term \n"
      if not definition_filled:
         popup_label.text += "- Definition \n"
      if not subject_filled:
         popup_label.text += "- Subject \n"
      if not topic_filled:
         popup_label.text += "- Topic \n"
      popup_label.text += "They are mandatory to be given to create a proper data card."
      popup.popup_centered()
   pass


func confirmation_accepted():
   popup.hide()
   popup_label.text = ""
   pass


func refresh_subjects_and_topics():
   edit_subject.clear()
   edit_topic.clear()
   for i in GlobalDatabase.subjects:
      edit_subject.add_item(i)
   for i in GlobalDatabase.topics:
      edit_topic.add_item(i)
   pass

func create_subject():
   popup_subject.popup_centered()
   pass

func subject_created():
   if popup_subject.get_node("Text").text.strip_edges() != "":
      GlobalDatabase.add_subject(popup_subject.get_node("Text").text.strip_edges())
      popup_subject.get_node("Text").text = ""
      popup_subject.hide()
      refresh_subjects_and_topics()
   pass
   
func subject_creation_cancelled():
   popup_subject.hide()
   popup_subject.get_node("Text").text = ""
   pass

func create_topic():
   popup_topic.popup_centered()
   pass

func topic_created():
   if popup_topic.get_node("Text").text.strip_edges() != "":
      GlobalDatabase.add_topic(popup_topic.get_node("Text").text.strip_edges())
      popup_topic.hide()
      popup_topic.get_node("Text").text = ""
      refresh_subjects_and_topics()
   pass

func topic_creation_cacelled():
   popup_topic.hide()
   popup_topic.get_node("Text").text = ""
   pass

func create_term():
   var tmp = Term.new()
   tmp.text = edit_term.text
   tmp.definition = edit_definition.text
   tmp.subject = edit_subject.text
   tmp.topic = edit_topic.text
   tmp.creation_day = OS.get_datetime()
   GlobalDatabase.add_term(tmp)
   pass
