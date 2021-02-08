class Comment < ApplicationRecord

    belongs_to :post
    belongs_to :user

    validates :text, length: { minimum: 1 }

end