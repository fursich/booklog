class RemoveColumnToBooks < ActiveRecord::Migration
  def change
    remove_column :books, :category_id
  end
end
