class CreateRestClient < ActiveRecord::Migration
  def change
    create_table :rest_clients do |t|
      t.string :name
      t.text :description
      t.string :api_key
      t.string :secret
      t.boolean :is_master
      t.timestamps
    end
  end
end
