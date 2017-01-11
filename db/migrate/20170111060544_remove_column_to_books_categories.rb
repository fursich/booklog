class RemoveColumnToBooksCategories < ActiveRecord::Migration
  def change
    remove_column :books_categories, :id
  end
end
