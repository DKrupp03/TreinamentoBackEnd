class User < ApplicationRecord

    has_secure_password

    has_many :posts, dependent: :delete_all
    has_many :comments, dependent: :delete_all
    before_destroy { self.comments.delete_all }
    before_destroy { self.posts.delete_all }

    #validates :name, length: { in: 1..50 }, presence: true
    #validates :email, length: { in: 1..50 }, presence: true, uniqueness: true
    #validates :password, length: { in: 1..50 }, presence: true

end
