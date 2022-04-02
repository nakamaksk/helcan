class AddGoalToPeople < ActiveRecord::Migration[7.0]
  def change
    add_column :people, :goal, :string, null: false, default: ''
  end
end
