module ProjectHelper
  def link_to_project(project)
    return "[#{_("no project")}]" unless project
    link_to project.name, project_path(project)
  end
end
