class PostsController < ApplicationController

    before_action :set_post, only: [:show, :update, :destroy, :link_tag, :unlink_tag]
    before_action :set_tag, only: [:link_tag, :unlink_tag]
    before_action :authorized, except: [:index, :show]
    before_action :is_user_author, only: [:update, :destroy, :link_tag, :unlink_tag]
    
    def index
        @posts = Post.all()
        @users = User.all()
    end

    def create
        @post = @user.posts.new(post_params)
        if @post.save
            render json: @post, status: :created
        else
            render json: @post.errors, status: :unprocessable_entity
        end
    end

    def show
        @comments = Comment.where(post: @post.id).order(updated_at: :desc)
        @tags = @post.tags.order(:name)
        @author = User.find(@post.user_id)
    end


    def update
        if defined?(@author)
            if @post.update(post_params)
                render json: @post, status: :ok
            else
                render json: @post.errors, status: :unprocessable_entity
            end
        end
    end

    def destroy
        if defined?(@author)
            @post.destroy
            render json: @post, status: :ok
        end
    end

    def link_tag
        if defined?(@author)
            @post.tags.push(@tag)
            render json: @post.tags, status: :ok
        end
    end

    def unlink_tag
        if defined?(@author)
            @post.tags.delete(@tag)
            render json: @post.tags, status: :ok
        end
    end

    private

    def is_user_author
        if @user.id == @post.user_id
            @author = @user
        else
            render json: {message: "You aren't the author :/"}
        end
    end

    def post_params
        params.require(:post).permit(:title, :description)
    end

    def set_post
        @post = Post.find(params[:id])
    end

    def set_tag
        @tag = Tag.find(params[:post][:tag_id])
    end

end
