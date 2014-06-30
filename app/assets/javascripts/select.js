function select_values(args){
	val = ""
	
	findstr = "option"
	
	if (args["selected"]){
		findstr += ":selected"
	}
	
	first = true
	$(args["sel"]).find(findstr).each(function(){
		if (first){
			first = false
		}else{
			val += args["expl"]
		}
		
		val += $(this).val()
	})
	
	return val
}
