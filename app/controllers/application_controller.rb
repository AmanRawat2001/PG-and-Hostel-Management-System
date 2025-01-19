class ApplicationController < ActionController::API
  include JsonWebToken
  before_action :authenticate_request
  before_action :authenticate_admin!, only: [:create, :update, :destroy]

  private

  def authenticate_request
    header = request.headers["Authorization"]
    header = header.split(" ").last if header
    return render json: { data: [], error: "Token is not provided" }, status: :unauthorized unless header
    decoded = jwt_decode(header)
    @current_user = User.find(decoded[:user_id])
    return render json: { data: [], error: "User not found" }, status: :not_found unless @current_user
  end

  def authenticate_admin!
    render json: { data: [], error: "Unauthorized" }, status: :unauthorized unless @current_user.role_admin?
  end
end
