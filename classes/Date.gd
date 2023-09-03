class_name Date

var year = 0
var month = 0
var day = 0
var weekday = 0
var unix = 0


func set_today():
   var today = Time.get_date_dict_from_system()
   year = today["year"]
   month = today["month"]
   day = today["day"]
   weekday = today["weekday"]
   unix = Time.get_unix_time_from_system()
   pass

func as_dict():
   return {"year": year, "month": month, "day": day, "weekday": weekday}
   pass

func unix_date_after_days(days: int):
   return unix + (86400 * days)
   pass

func date_after_days(days: int):
   return Time.get_date_dict_from_unix_time(unix_date_after_days(days))
   pass
