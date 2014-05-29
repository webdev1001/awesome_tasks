module TaskHelper
  def link_to_task(task)
    return "[#{_("no task")}]" unless task
    link_to task.name_force, task_path(task), :class => ["task_link", "state_#{task.state}"]
  end
end
