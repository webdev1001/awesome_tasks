module TaskHelper
  def link_to_task(task, args = {})
    return "[#{helper_t(".no_task")}]" unless task

    if args[:url]
      url = task_url(task)
    else
      url = task_path(task)
    end

    if can? :show, task
      link_to task.name_force, url, class: ["task_link", "state_#{task.state}"]
    else
      task.name_force
    end
  end
end
