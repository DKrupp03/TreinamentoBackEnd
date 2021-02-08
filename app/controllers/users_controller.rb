class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit]
  before_action :authorized, except: [:create, :login]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
    render json: { user: @users }
  end

  # GET /users/1
  # GET /users/1.json
  def show
    render json: { user: @user, token: @token }
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
      if @user.save && @user.valid?
        token = encode_token({user_id: @user.id})
        render json: { user: @user, token: token }
      else
        render json: { error: @user.errors, status: :unprocessable_entity }
      end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.json { render :show, status: :ok, location: @user, token: @token }
      else
        render json: { error: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  ##################################

  def login
    @user = User.find_by(email: params[:email])

    if @user && @user.authenticate(params[:password])
      token = encode_token({user_id: @user.id})
      render json: {user: @user, token: token}
    else
      render json: {error: "Invalid username or password"}
    end
  end


  ##################################

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
end
