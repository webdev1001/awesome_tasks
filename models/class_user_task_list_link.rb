class Knjtasks::User_task_list_link < Knj::Datarow
  has_one [
    :Task,
    :User
  ]
  
  def self.add(d)
    task = d.ob.get(:Task, d.data[:task_id])
    user = d.ob.get(:User, d.data[:user_id])
    
    link = d.ob.get_by(:User_task_list_link, {
      "task" => task,
      "user" => user
    })
    raise _("That user has already listed that task.") if link
  end
end