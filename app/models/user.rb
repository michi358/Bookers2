class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  
  # フォロー機能
  has_many :active_relationships, class_name: "Relationship", foreign_key:"follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key:"followed_id", dependent: :destroy
  has_many :followings, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  

  has_one_attached :profile_image

  validates :name, presence: true, length: { in: 2..20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }

  def get_profile_image(width,height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end
  
  # ユーザーをフォローする
  def follow(user)
    active_relationships.create(followed_id: user.id)
  end
  # ユーザーのフォローを外す
  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end
  # フォロー確認をする
  def following?(user)
    followings.include?(user)
  end
  # 検索機能
  def self.search_for(content, method)
    if method == 'perfect'
      User.where(name: content)
    elsif method == 'forward'
      User.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      User.where('name LIKE ?', '%' + content)
    else
      User.where('name LIKE ?', '%' + content + '%')
    end  
  end
  
end
