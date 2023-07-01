extends Control

onready var list_subjects = get_node("SubjectSelector")
onready var list_topics = get_node("TopicSelector")


func refresh_all_data():
   refresh_data()
   refresh_topic_data()
   pass

func refresh_data():
   list_subjects.clear()
   for i in GlobalDatabase.subjects:
      list_subjects.add_item(i.text)
   pass

func refresh_topic_data(selected_subject: int = -1):
   list_topics.clear()
   if selected_subject != -1:
      for i in GlobalDatabase.subjects[selected_subject].topics:
         list_topics.add_item(i)
   pass


func delete_subject():
   GlobalFunctions.show_warning(self, "subject_deletion_accepted", \
   "Do you really want to delete the selected Subject(s)?" + "\n" + \
   "(The connected Topics and Terms are going to be deleted as well.)")
   pass

func subject_deletion_accepted():
   for i in list_subjects.get_selected_items():
      GlobalDatabase.remove_subject(i)
   refresh_all_data()
   pass

func delete_topic():
   GlobalFunctions.show_warning(self, "topic_deletion_accepted", \
   "Do you really want to delete the selected Topic(s)?" + "\n" + \
   "(The connected Terms are going to be deleted as well.)")
   pass

func topic_deletion_accepted():
   for i in list_subjects.get_selected_items():
      for j in list_topics.get_selected_items():
         GlobalDatabase.subjects[i].topics.remove(j)
         list_topics.remove_item(j)
   pass
