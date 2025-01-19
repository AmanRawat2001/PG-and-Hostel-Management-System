class Api::AuthenticationController < ApplicationController
  skip_before_action :authenticate_request, :authenticate_admin!

  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = jwt_encode(user_id: user.id)
      render json: { data: { users: user.as_json(only: [:id, :name, :email, :role]), token: token } }, status: :ok
    else
      render json: { error: "User is not Created yet" }, status: :unauthorized
    end
  end

  def signup
    user = User.new(user_params)
    if user.save
      render json: { user: user.as_json(only: [:id, :name, :email, :role]), token: jwt_encode(user_id: user.id) }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password, :role)
  end
end
