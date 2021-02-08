class Tag < ApplicationRecord

    validates :name, length: { in: 3..20 }, uniqueness: true, presence: true

    has_and_belongs_to_many :posts

end
