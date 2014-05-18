module CustomerHelper
  def link_to_customer(customer)
    link_to customer.name, customer_path(customer)
  end
end
