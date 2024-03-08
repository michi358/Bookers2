class Relationship < ApplicationRecord
  belongs_to :follower,class_name: "User"
  belongs_to :followed,class_name: "User"
  # follower =>フォローする人、followed =>フォローされる人
  
end
