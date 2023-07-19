// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RideSharing {
    struct Ride {
        address driver;
        uint256 availableSeats;
        uint256 price;
        mapping(address => bool) passengers;
    }

    Ride[] public rides;

    event RideCreated(uint256 rideId, address driver, uint256 availableSeats, uint256 price);
    event RideJoined(uint256 rideId, address passenger);
    event RideCompleted(uint256 rideId);

    function createRide(uint256 _availableSeats, uint256 _price) external {
        require(_availableSeats > 0, "Invalid available seats");
        require(_price > 0, "Invalid price");

        Ride storage newRide = rides.push();

        newRide.driver = msg.sender;
        newRide.availableSeats = _availableSeats;
        newRide.price = _price;

        uint256 rideId = rides.length - 1;

        emit RideCreated(rideId, msg.sender, _availableSeats, _price);
    }

    function joinRide(uint256 _rideId) external payable {
        require(_rideId < rides.length, "Invalid ride ID");
        Ride storage ride = rides[_rideId];
        require(ride.driver != address(0), "Ride does not exist");
        require(msg.sender != ride.driver, "Driver cannot join their own ride");
        require(!ride.passengers[msg.sender], "Passenger already joined");
        require(msg.value >= ride.price, "Insufficient payment");

        ride.passengers[msg.sender] = true;
        ride.availableSeats--;

        emit RideJoined(_rideId, msg.sender);
    }

    function completeRide(uint256 _rideId) external {
        require(_rideId < rides.length, "Invalid ride ID");
        Ride storage ride = rides[_rideId];
        require(ride.driver == msg.sender, "Only driver can complete the ride");

        payable(ride.driver).transfer(ride.price * ride.availableSeats);

        // Reset ride data
        delete rides[_rideId];

        emit RideCompleted(_rideId);
    }

    function getRide(uint256 _rideId) external view returns (
        address driver,
        uint256 availableSeats,
        uint256 price,
        uint256 passengerCount
    ) {
        require(_rideId < rides.length, "Invalid ride ID");
        Ride storage ride = rides[_rideId];

        driver = ride.driver;
        availableSeats = ride.availableSeats;
        price = ride.price;
        passengerCount = countPassengers(ride);
    }

    function countPassengers(Ride storage _ride) private view returns (uint256) {
        uint256 count = 0;
        address[] memory passengers = new address[](rides.length);
        for (uint256 i = 0; i < rides.length; i++) {
            if (_ride.passengers[passengers[i]]) {
                count++;
            }
        }
        return count;
    }
}
