class_name Subject

var text = ""
var topics = []

func add_topic(topic: String):
   topics.append(topic)
   pass


func remove_topic(topic: String):
   topics.remove(topics.find(topic))
   pass
