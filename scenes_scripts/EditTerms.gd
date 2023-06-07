extends Control

onready var sort_selector = get_node("OptionButtonSort")
onready var select_subject = get_node("OptionButtonSubject")
onready var select_topic = get_node("OptionButtonTopic")
onready var list_terms = get_node("TermsList")
onready var terms_sorted = []


func _ready():
   GlobalFunctions.set_font(sort_selector, 32)
   GlobalFunctions.set_font(select_subject, 32)
   GlobalFunctions.set_font(select_topic, 32)
   GlobalFunctions.set_font(list_terms, 32)
   pass

func refresh_data():
   if sort_selector.selected == 0:
      refresh_data_alphabetical()
   #and if it's 1 then call the subject based sort
   pass

func refresh_data_alphabetical():
   var tmp_terms = []
   var tmp_terms_sorted = []  
   for i in GlobalDatabase.terms:
      tmp_terms.append([i, GlobalDatabase.terms[i]])
      print(String(i), GlobalDatabase.terms[i].text)
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



func delete_term():
   GlobalFunctions.show_warning(self, "delete_term_accepted", "Are you sure you want to delete the selected Term?")
   pass

func delete_term_accepted():
   if list_terms.get_selected_items().size() > 0:
      for i in list_terms.get_selected_items():
         list_terms.remove_item(i)
         GlobalDatabase.remove_term(terms_sorted[i][0])
         terms_sorted.remove(i)
   pass
