class Api::HostelsController < ApplicationController
  
  def index
    render json: { data: Hostel.all.as_json(only: [:id, :name, :address, :phone]) }, status: :ok
  end

  def create
    hostel = Hostel.new(hostel_params)
    if hostel.save
      render json: {data: hostel.as_json(only: [:id, :name, :address, :phone])}, status: :created
    else
      render json: { errors: hostel.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    hostel = Hostel.find(params[:id])
    if hostel.update(hostel_params)
      render json: {data: hostel.as_json(only: [:id, :name, :address, :phone])}, status: :ok
    else
      render json: { errors: hostel.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    hostel = Hostel.find_by(id: params[:id])
    return render json: { error: "Hostel does not exist" }, status: :not_found unless hostel
    return render json: { error: "Hostel has associated rooms" }, status: :bad_request if hostel.rooms.exists?

    if hostel.destroy
      render json: { message: "Hostel deleted successfully" }, status: :ok
    else
      render json: { error: "Failed to delete hostel" }, status: :unprocessable_entity
    end
  end

  private

  def hostel_params
    params.permit(:name, :address, :phone)
  end
end
