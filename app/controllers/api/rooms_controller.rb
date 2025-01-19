class Api::RoomsController < ApplicationController


  def index
    return render json: { error: "Hostel does not exist" }, status: :not_found unless Hostel.exists?(params[:hostel_id])
    hostel = Hostel.find_by(id: params[:hostel_id])
    if @current_user.role_resident?
      return render json: { data: hostel.rooms.available.as_json(only: [:id, :room_number, :capacity, :price, :is_occupied]) }, status: :ok
    else
      render json: { data: hostel.rooms.as_json(only: [:id, :room_number, :price, :capacity, :is_occupied]) }, status: :ok
    end
  end

  def create
    return render json: { error: "Hostel does not exist" }, status: :not_found unless Hostel.exists?(params[:hostel_id])
    room = Room.new(room_params)
    if room.save
      render json: { data: room.as_json(only: [:id, :room_number, :capacity, :price, :is_occupied]) }, status: :created
    else
      render json: { errors: room.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    room = Room.find(params[:id])
    if room.update(room_params)
      render json: { data: room.as_json(only: [:id, :room_number, :capacity, :price, :is_occupied]) }, status: :ok
    else
      render json: { errors: room.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActionController::ParameterMissing
    render json: { error: "Room parameters are missing or malformed" }, status: :bad_request
  end

  def destroy
    room = Room.find_by(id: params[:id])
    return render json: { error: "Room does not exist" }, status: :not_found unless room
    return render json: { error: "Room has associated bookings" }, status: :bad_request if room.bookings.exists?

    if room.destroy
      render json: { message: "Room deleted successfully" }, status: :ok
    else
      render json: { error: "Failed to delete room" }, status: :unprocessable_entity
    end
  end

  private

  def room_params
    params.permit(:room_number, :capacity, :hostel_id, :price)
  end
end
