class User < ApplicationRecord
  include Rails.application.routes.url_helpers

  # 画像
  has_one_attached :image
  def image_url
    url_for(image) if image.attached?
  end

  # メモ
  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy

  # 質問
  has_many :topic_comments, dependent: :destroy
  has_many :topics, dependent: :destroy

  # 目標
  has_many :goals, dependent: :destroy
  has_many :goal_comments, dependent: :destroy

  # コミュニティ
  has_many :belongings, dependent: :destroy
  has_many :communities, through: :belongings, foreign_key: 'user_id'
  has_many :messages, dependent: :destroy

  # お知らせ
  has_many :news, dependent: :destroy

  # バリデーション
  validates :uid, presence: true
  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 100 }, uniqueness: true
  validates :profile, length: { maximum: 50 }

  has_many :active_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  # # フォローユーザーも含めたフィード
  # def feed
  #   following_ids = 'SELECT followed_id FROM relationships WHERE follower_id = :user_id'
  #   Post.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
  # end

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end
end
