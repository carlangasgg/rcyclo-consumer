class CreateCurrentUsers < ActiveRecord::Migration
  def change
    create_table :current_users do |t|
      t.string :email
      t.string :uid
      t.string :client
      t.string :access_token

      t.timestamps null: false
    end
  end
end
