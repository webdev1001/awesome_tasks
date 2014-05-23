module TaskHelper
  def link_to_task(task)
    link_to task.name, task_path(task)
  end
end
