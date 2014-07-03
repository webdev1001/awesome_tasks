module OrganizationHelper
  def link_to_organization(organization)
    return "[#{_("no organization")}]" unless organization
    link_to organization.name, organization_path(organization)
  end
end
