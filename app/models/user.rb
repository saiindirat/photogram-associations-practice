# == Schema Information
#
# Table name: users
#
#  id             :integer          not null, primary key
#  comments_count :integer
#  likes_count    :integer
#  private        :boolean
#  username       :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class User < ApplicationRecord
  validates :username, presence: true, uniqueness: { case_sensitive: false }

  # Photos the user posted
  has_many :own_photos, class_name: "Photo", foreign_key: "owner_id"

  # Comments the user wrote
  has_many :comments, class_name: "Comment", foreign_key: "author_id"

  # Photos the user commented on
  has_many :commented_photos, through: :comments, source: :photo

  # Likes the user gave
  has_many :likes, class_name: "Like", foreign_key: "fan_id"

  # Photos the user liked
  has_many :liked_photos, through: :likes, source: :photo

  # Follow requests the user sent
  has_many :sent_follow_requests, class_name: "FollowRequest", foreign_key: "sender_id"

  # Follow requests the user received
  has_many :received_follow_requests, class_name: "FollowRequest", foreign_key: "recipient_id"

  # Accepted sent and received requests
  has_many :accepted_sent_follow_requests, -> { where(status: "accepted") }, class_name: "FollowRequest", foreign_key: "sender_id"
  has_many :accepted_received_follow_requests, -> { where(status: "accepted") }, class_name: "FollowRequest", foreign_key: "recipient_id"

  # Followers & Leaders (many-to-many)
  has_many :followers, through: :accepted_received_follow_requests, source: :sender
  has_many :leaders, through: :accepted_sent_follow_requests, source: :recipient

  # Feed & Discover
  has_many :feed, through: :leaders, source: :own_photos
  has_many :discover, through: :leaders, source: :liked_photos
end
