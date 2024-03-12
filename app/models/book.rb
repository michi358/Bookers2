class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  # いいね順に並び替えるため
  has_many :favorited_users, through: :favorites, source: :user
  has_many :book_comments, dependent: :destroy
  
  validates :title, presence: true
  validates :body, presence: true, length: {maximum: 200 }

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
  # 検索機能
  def self.search_for(content, method)
    if method == 'perfect'
      Book.where(title: content)
    elsif method == 'forward'
      Book.where('title LIKE ?', content + '%')
    elsif method == 'backward'
      Book.where('title LIKE ?', '%' + content)
    else
      Book.where('title LIKE ?', '%' + content + '%')
    end  
  end
  
  # indexの並び替え
  scope :latest, -> {order(created_at: :desc )}
  scope :old, -> {order(created_at: :asc )}
  scope :star_count, -> {order(star: :desc )}
  
  # タグ付け
  has_many :tag_maps, dependent: :destroy
  has_many :tags, through: :tag_maps
  # タグ付けの新規投稿用メソッド
  def save_tag(sent_tags)
    current_tags =self.tags.pluck(:tag_name) unless self.tags.nil?
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags

    old_tags.each do |old|
      self.tags.delete Tag.find_by(tag_name: old)
    end

    new_tags.each do |new|
      new_book_tag = Tag.find_or_create_by(tag_name: new)
      self.tags << new_book_tag
    end
  end
  
end
