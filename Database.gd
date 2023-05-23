extends Node

var terms = {}
var subjects = []
var topics = []
var font = "res://lib/Courier_Prime/CourierPrime-Regular.ttf"


func add_term(term: Term):
   terms[terms.size()] = term
   pass

func add_subject(subject: String):
   subjects.append(subject)
   pass

func add_topic(topic: String):
   topics.append(topic)
   pass

func remove(term_id: int):     ###not sure if it works cuz it's not string
   terms[term_id] = null
   pass

func remove_subject(subject: String):
   subject.remove(subject.find(subject))
   pass

func remove_topic(topic: String):
   topics.remove(topics.find(topic))
   pass

func get_terms_by_subject(subject: String):
   var tmp = []
   for i in terms:
      if terms[i].subject == subject:
         tmp.append(terms[i])
   return tmp
   pass

func get_terms_by_topic(topic: String):
   var tmp = []
   for i in terms:
      if terms[i].topic == topic:
         tmp.append(terms[i])
   return tmp
   pass

func get_term_count():
   return terms.size()
   pass



