class AddUserIdToCommunities < ActiveRecord::Migration[6.1]
  def change
    add_reference :communities, :user, null: false, foreign_key: true
  end
end
