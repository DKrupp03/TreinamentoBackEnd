class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActionController::ParameterMissing, with: :render_parameter_missing
  rescue_from ActiveRecord::RecordNotUnique, with: :render_not_unique

  private

  def render_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def render_parameter_missing(exception)
    render json: { error: exception.message }, status: :expectation_failed
  end

  def render_not_unique(exception)
    render json: { error: exception.message }, status: :conflict
  end

  ##############################################

  before_action :authorized
  
  def encode_token(payload)
    JWT.encode(payload, 's3cr3t')
  end

  def auth_header
    # { Authorization: 'Bearer <token>' }
    request.headers['Authorization']
  end

  def decoded_token
    if auth_header
      @token = auth_header
      # header: { 'Authorization': 'Bearer <token>' }
      begin
        JWT.decode(@token, 's3cr3t', true, algorithm: 'HS256')
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def logged_in_user
    if decoded_token
      user_id = decoded_token[0]['user_id']
      @user = User.find_by(id: user_id)
    end
  end

  def logged_in?
    !!logged_in_user
  end

  def authorized
    render json: { message: 'Please log in' } unless logged_in?
  end


end
