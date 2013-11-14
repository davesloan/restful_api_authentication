class AddDisabledField < ActiveRecord::Migration
  def change
    add_column :rest_clients, :disabled, :boolean
  end
end
