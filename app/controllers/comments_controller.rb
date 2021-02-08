class CommentsController < ApplicationController

    before_action :set_post, only: [:create, :is_user_author?]
    before_action :set_comment, only: [:show, :update, :destroy, :is_user_author?]
    before_action :authorized, except: [:index, :show]

    def index
        @comments = Comment.where(post: params[:post_id]).order(updated_at: :desc)
        
    end

    def show
        render json: @comment
    end

    def create
        @comment = @post.comments.new(com_params)
        @comment.user_id = @user.id
        if @comment.save
            render json: @comment, status: :created
        else
            render json: @comment.errors, status: :unprocessable_entity
        end
    end

    def update
        if @comment.user_id == @user.id
            if @comment.update(com_params)
                render json: @comment, status: :ok
            else
                render json: @comment.errors, status: :unprocessable_entity
            end
        else
            render json: {message: "You aren't the author :/"}
        end
    end

    def destroy
        post = @comment.post
        if post.user_id == @user.id || @comment.user_id == @user.id
            @comment.destroy
            head :no_content
        else
            render json: {message: "You aren't permited to do this action :/"}
        end
    end

    private 

    def is_owner?
        @comment.user_id = @user.id
    end

    def is_post_owner?
        post = @comment.post
        post.user_id == @user.id
    end

    def com_params
        params.require(:comment).permit(:text)
    end

    def set_post
        @post = Post.find(params[:post_id])
    end

    def set_comment
        @comment = Comment.find(params[:id])
    end

    def is_user_author?
        if @user.id == @comment.user_id
            @author = @user
        else
            render json: "You aren't the author :/"
        end
    end

end