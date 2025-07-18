class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :user_id, uniqueness: { scope: :post_id }

  after_create_commit do
    broadcast_replace_later_to "posts",
      target: "post_#{post.id}_likes",
      partial: "posts/likes",
      locals: { post: post }
  end

  after_destroy_commit do
    broadcast_replace_later_to "posts",
      target: "post_#{post.id}_likes",
      partial: "posts/likes",
      locals: { post: post }
  end
end
