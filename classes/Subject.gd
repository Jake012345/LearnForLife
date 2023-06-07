class_name Subject

var text = ""
var topics = []

func add_topic(topic: String):
   topics.append(topic)
   pass

func remove_topic(topic: String):
   remove_topic_by_id(topics.find(topic))
   pass

func remove_topic_by_id(id):
   topics.remove(id)
   pass

func get_topics():
   return topics

func as_list():
   return [text, topics]

func from_list(subject_as_list: Array):
   text = subject_as_list[0]
   topics = subject_as_list[1]
   pass
