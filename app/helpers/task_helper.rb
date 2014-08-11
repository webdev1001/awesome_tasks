module TaskHelper
  def link_to_task task, args = {}
    return "[#{_("no task")}]" unless task

    if args[:url]
      url = task_url(task)
    else
      url = task_path(task)
    end

    link_to task.name_force, url, class: ["task_link", "state_#{task.state}"]
  end
end
