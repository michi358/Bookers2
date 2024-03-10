class Message < ApplicationRecord
  
  # メッセージが空白の場合、保存されないようにバリデーションをかけている
  validates :content, presence: true
  belongs_to :user
  belongs_to :room
  
  validates :message, precence: true, length: {maximum: 140 }

end
