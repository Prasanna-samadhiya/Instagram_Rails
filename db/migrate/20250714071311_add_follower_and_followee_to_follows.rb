class AddFollowerAndFolloweeToFollows < ActiveRecord::Migration[8.0]
  def change
    add_reference :follows, :follower, null: false, foreign_key: { to_table: :users }
    add_reference :follows, :followee, null: false, foreign_key: { to_table: :users }
  end
end