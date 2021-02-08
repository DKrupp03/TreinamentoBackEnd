class Post < ApplicationRecord

    belongs_to :user

    validates :title, length: { in: 1..100 }, uniqueness: true, exclusion: {in: %w(god jesus admin)}
    validates :description, length: { minimum: 1 }
    #validates_with Validators::TitleWithPost

    has_many :comments, dependent: :delete_all
    before_destroy { comments.destroy }
    has_and_belongs_to_many :tags, before_add: :check_tag
    before_destroy { tags.clear }

    def check_tag(tag)
        raise ActiveRecord::RecordNotUnique, "Tag #{tag.id} já linkada" if self.tags.include? tag
    end

end
