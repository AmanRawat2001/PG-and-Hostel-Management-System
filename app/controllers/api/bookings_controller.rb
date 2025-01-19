class Api::BookingsController < ApplicationController
  skip_before_action :authenticate_admin!, on: :create
  before_action :authenticate_admin!, only: [:approve, :reject]

  def index
    if @current_user.role_resident?
      render json: { data: @current_user.bookings.as_json(only: [:id, :room_id, :resident_id, :start_date, :end_date, :status]) }, status: :ok
    else
      render json: { data: Booking.all.as_json(only: [:id, :room_id, :resident_id, :start_date, :end_date, :status]) }, status: :ok
    end
  end

  def create
    return render json: { error: "Room does not exist" }, status: :not_found unless Room.exists?(params[:room_id])
    return render json: { error: "Room is occupied" }, status: :bad_request if Room.find_by(id: params[:room_id]).is_occupied

    booking = Booking.new(booking_params)
    booking.user = @current_user
    if booking.save
      render json: { data: booking.as_json(only: [:id, :room_id, :resident_id, :start_date, :end_date]) }, status: :created
    else
      render json: { errors: booking.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
  end

  def approve
    booking = Booking.find_by(id: params[:id])
    return render json: { error: "Booking does not exist" }, status: :not_found if booking.nil?
    return render json: { error: "Booking is already approved" }, status: :bad_request if booking.status == "approved"
    return render json: { error: "Booking is already rejected" }, status: :bad_request if booking.status == "rejected"

    booking.approved!
    render json: { data: booking.as_json(only: [:id, :room_id, :resident_id, :start_date, :end_date]) }, status: :ok
  end

  def reject
    booking = Booking.find_by(id: params[:id])
    return render json: { error: "Booking does not exist" }, status: :not_found if booking.nil?
    return render json: { error: "Booking is already rejected" }, status: :bad_request if booking.status == "rejected"
    return render json: { error: "Booking is already approved" }, status: :bad_request if booking.status == "approved"

    booking.rejected!
    render json: { data: booking.as_json(only: [:id, :room_id, :resident_id, :start_date, :end_date]) }, status: :ok
  end

  def destroy
  end

  private

  def booking_params
    params.permit(:room_id, :user_id, :start_date, :end_date)
  end
end
