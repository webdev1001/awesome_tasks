module OrganizationHelper
  def link_to_organization(organization)
    return "[#{helper_t(".no_organization")}]" unless organization

    if can? :show, organization
      link_to organization.name, organization_path(organization)
    else
      organization.name
    end
  end
end
