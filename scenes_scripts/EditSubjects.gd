extends Control

onready var list_subjects = get_node("SubjectSelector")
onready var list_topics = get_node("TopicSelector")


func refresh_data():
   list_subjects.clear()
   for i in GlobalDatabase.subjects:
      list_subjects.add_item(i.text)
      pass
   pass


func delete_subject():
   GlobalFunctions.show_warning(self, "subject_deletion_accepted", \
   "Do you really want to delete the selected Subject(s)?" + "\n" + \
   "(The connected Topics and Terms are going to be deleted as well.)")
   pass

func subject_deletion_accepted():
   #write the code of subject deletion
   pass
