function Events(){
  this.events = {}
  this.connects = {}
}

Events.prototype.add_event = function(data){
  if (!this.events[data["name"]]){
    this.events[data["name"]] = [];
  }
  
  this.events[data["name"]] = data;
}

Events.prototype.call = function(name, args){
  if (!args){
    args = []
  }
  
  if (this.connects[name]){
    for(key in this.connects[name]){
      this.connects[name][key].apply(null, args);
    }
  }
}

Events.prototype.connect = function(name, callback){
  if (!this.connects[name]){
    this.connects[name] = [];
  }
  
  this.connects[name].push(callback);
}