class AddLineUserIdToPeople < ActiveRecord::Migration[7.0]
  def change
    add_column :people, :line_user_id, :string
  end
end
