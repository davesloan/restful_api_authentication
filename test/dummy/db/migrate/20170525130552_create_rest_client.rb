class CreateRestClient < ActiveRecord::Migration[5.1]
  def change
    create_table :rest_clients do |t|
      t.string :name
      t.text :description
      t.string :api_key
      t.string :secret
      t.boolean :is_master
      t.boolean :is_disabled
      t.timestamps
    end
  end
end
