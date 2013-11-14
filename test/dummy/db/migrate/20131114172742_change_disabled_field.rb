class ChangeDisabledField < ActiveRecord::Migration
  def change
    remove_column :rest_clients, :disabled
    add_column :rest_clients, :is_disabled, :boolean
  end
end
