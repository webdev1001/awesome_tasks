class AddStateToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :state, :string, after: :name, default: "active"
    add_index :projects, :state
  end
end
