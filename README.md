# PG and Hostel Management System (API-Based)

## Core Features

### User Management API
#### User Types:
1. **Admin**: Manages properties, rooms, and bookings.
2. **Resident**: Searches for rooms and makes bookings.

#### Authentication
- Implement authentication using JWT (`devise-jwt` or a similar gem).

#### Endpoints:
- **POST /users/signup**: User registration.
- **POST /users/login**: User login to get a JWT token.

---

### Hostel Management API
#### Admin Functionalities:
- Manage PG/Hostel details.

#### Endpoints:
- **GET /hostels**: Fetch a list of all hostels.
- **POST /hostels**: Add a new hostel (Admin only).
- **PUT /hostels/:id**: Update hostel details (Admin only).
- **DELETE /hostels/:id**: Delete a hostel (Admin only).

---

### Room Management API
#### Functionalities:
- Admin can manage rooms within a hostel.
- Residents can view available rooms.

#### Endpoints:
- **GET /hostels/:hostel_id/rooms**: List rooms in a hostel.
- **POST /hostels/:hostel_id/rooms**: Add a new room (Admin only).
- **PUT /rooms/:id**: Update room details (Admin only).
- **DELETE /rooms/:id**: Delete a room (Admin only).

---

### Booking Management API
#### Functionalities:
- Residents can book rooms.
- Admin can approve/reject bookings.

#### Endpoints:
- **POST /rooms/:room_id/bookings**: Create a booking.
- **GET /bookings**: List all bookings (Admin: all bookings, Resident: personal bookings).
- **PUT /bookings/:id/approve**: Approve a booking (Admin only).
- **PUT /bookings/:id/reject**: Reject a booking (Admin only).
- **DELETE /bookings/:id**: Cancel a booking (Resident/Admin).

---

### Search and Filters (Optional)
#### Functionalities:
- Residents can filter rooms based on price, capacity, and availability.

#### Endpoint:
- **GET /rooms/search**: Search rooms with query parameters like capacity, rent, and availability.