module ProjectHelper
  def link_to_project(project)
    return "[#{_("no project")}]" unless project

    if can? :show, project
      link_to project.name, project_path(project)
    else
      project.name
    end
  end
end
