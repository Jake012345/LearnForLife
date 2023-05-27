extends Node

var terms = {}
var subjects = []
var next_term_id = 0


func add_term(term: Term):
   terms[next_term_id] = term
   next_term_id += 1
   pass

func add_subject(text: String, topics: Array = []):
   var tmp_subject = Subject.new()
   tmp_subject.text = text
   tmp_subject.topics += topics
   subjects.append(tmp_subject)
   pass

func add_topic(topic: String, subject: Subject):
   subject.add_topic(topic)
   pass

func remove_term(term_id: int):     ###not sure if it works cuz it's not string
   terms[term_id] = null
   pass

func remove_subject(subject: int):
   subjects.remove(subject)
   pass

func remove_topic(topic: String, subject: Subject):
   subject.remove_topic(topic)
   pass

func get_terms_by_subject(subject: Subject):
   var tmp = []
   for i in terms:
      if terms[i].subject == subject:
         tmp.append(terms[i])
   return tmp
   pass

func get_terms_by_topic(topic: String):
   var tmp = []
#####################################
   return tmp
   pass

func get_term_count():
   return terms.size()
   pass

func get_subject(id: int):
   return subjects[id]
   pass

func get_subject_by_name(name: String):
   for i in subjects:
      if i.text == name:
         return i
   pass
