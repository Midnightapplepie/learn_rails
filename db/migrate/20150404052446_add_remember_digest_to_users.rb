class AddRememberDigestToUsers < ActiveRecord::Migration
  def change
    add_column :users, :remember_digest, :string
  end
  #add function to remember user after them close their browser unless they logout
end
