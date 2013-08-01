class CreateRestAppClient < ActiveRecord::Migration
  def change
    create_table :rest_app_clients do |t|
      t.string :name
      t.text :description
      t.string :api_key
      t.string :secret
      t.boolean :is_master
      t.timestamps
    end
  end
end
