module ProjectHelper
  def link_to_project(project)
    link_to project.name, project_path(project)
  end
end
