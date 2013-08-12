class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :name
      t.string :email
    end

    add_index :users, :email, unique: true
  end

  def down
    drop_table :users
  end
end
