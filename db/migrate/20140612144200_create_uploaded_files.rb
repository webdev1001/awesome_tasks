class CreateUploadedFiles < ActiveRecord::Migration
  def change
    create_table :uploaded_files do |t|
      t.string :title
      t.string :resource_type
      t.integer :resource_id
      t.integer :user_id
      t.timestamps
    end
    
    add_attachment :uploaded_files, :file
    add_index :uploaded_files, :user_id
    add_index :uploaded_files, [:resource_type, :resource_id]
  end
end
