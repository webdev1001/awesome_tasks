var awesome_tasks_modals = {}

function modal_close(){
	awesome_tasks_modals["closing"] = true;
	$.modal.close();
}

function modal_on_opened(func){
	if (!awesome_tasks_modals["on_opened"]){
		awesome_tasks_modals["on_opened"] = []
	}
	
	awesome_tasks_modals["on_opened"].push(func);
}

function modal(args){
	if (awesome_tasks_modals["closing"]){
		setTimeout(function(){
			modal(args);
		}, 50);
		return null;
	}
	
	if (modal_isopen()){
		modal_close();
		setTimeout(function(){
			modal(args);
		}, 50);
		return null;
	}
	
	if (!args["width"]){
		args["width"] = "640px";
	}
	
	if (!args["height"]){
		args["height"] = "480px";
	}
	
	modal_opts = {
		overlay: 80,
		overlayCss: {backgroundColor: "#000000"},
		containerId: "simplemodal_box",
		onOpen: function(dialog){
			$(".youtube object").hide();
			
			dialog.overlay.fadeIn("fast", function(){
				dialog.container.fadeIn(0, function(){
					dialog.data.fadeIn("fast", function(){
						if (awesome_tasks_modals["on_opened"]){
							$.each(awesome_tasks_modals["on_opened"], function(key, ele){
								awesome_tasks_modals["on_opened"].splice(ele);
								
								if (ele){
                  ele.call();
                }
							});
						}
					});
				});
			});
		},
		onClose: function(dialog){
			dialog.data.fadeOut("fast", function(){
				dialog.container.fadeOut("fast", function(){
					dialog.overlay.fadeOut("fast", function(){
						$.modal.close();
						awesome_tasks_modals["closing"] = false;
						$(".youtube object").show();
					});
				});
			});
		}
	};
	
	if (args["url"]){
		$.ajax({type: "GET", url: args["url"], cache: false, async: false,
			complete: function(data){
				if (data.getResponseHeader("Title")){
					args["title"] = data.getResponseHeader("Title");
				}
				
				args["content"] = data.responseText;
			}
		});
	}
	
	tha_style = "";
	if (args["width"]){
		tha_style += "width: " + args["width"] + ";";
		win_width = $(document).width();
    xpos = (win_width / 2) - (parseInt(args["width"]) / 2);
	}
	
	if (args["height"]){
		tha_style += "height: " + args["height"] + ";";
		win_height = $(window).height();
		ypos = (win_height / 2) - (parseInt(args["height"]) / 2);
		
		modal_opts["position"] = [ypos, xpos];
	}
  
	realcontent = "<div class=\"simplemodal_box\" style=\"" + tha_style + "\">";
	
	if (args["title"]){
		realcontent += "<div class=\"simplemodal_header\">";
		realcontent += "<div style=\"float: right; font-size: 9px; font-weight: normal; padding-top: 5px;\"><a href=\"javascript: modal_close();\">[" + locale_strings["close"] + "]</a></div>";
		realcontent += args["title"] + "</div>";
	}
	
	realcontent += args["content"];
	realcontent += "</div>";
	
	$(realcontent).modal(modal_opts);
}

function modal_isopen(){
	modal_ele = $("div#simplemodal_box");
	if (modal_ele.length > 0){
		return modal_ele;
	}
	
	return false;
}

function modal_setup(args){
	var head = document.getElementsByTagName("head")[0] || document.body;
	
	sh = ""
	sh += ".simplemodal_box{";
	
	for(key in args["css"]){
		sh += key + ": " + args["css"][key] + ";";
	}
	
	sh += "}";
	
	sh += ".simplemodal_header{";
	
	for(key in args["css_header"]){
		sh += key + ":	" + args["css_header"][key] + ";";
	}
	sh += "}";
	
	if (navigator.appName == "Netscape"){
		var divele = document.createElement("div");
		divele.innerHTML = "<style type=\"text/css\">" + sh + "</style>";
		document.body.appendChild(divele);
	}else if(navigator.appName == "Microsoft Internet Explorer"){
		var style = document.createElement("style");
		style.type = "text/css";
		style.styleSheet.cssText = sh;
		head.appendChild(style);
	}else{
		var style = document.createElement("style");
		style.type = "text/css";
		style.innerHTML = sh;
		head.appendChild(style);
	}
}
