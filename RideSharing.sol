// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RideSharing {
    struct Ride {
        address driver;
        uint256 availableSeats;
        uint256 price;
         uint256 totalDistance; // Total distance of the ride
        uint256 pricePerKilometer;
        mapping(address => bool) passengers;
    }

    Ride[] public rides;
    uint256 totalRides;
    event RideCreated(uint256 rideId, address driver, uint256 availableSeats, uint256 pricePerKilometer, uint256 totalDistance,uint256 price);
    event RideJoined(uint256 rideId, address passenger);
    event RideCompleted(uint256 rideId);
  function createRide(uint256 _availableSeats, uint256 _lat1, uint256 _lon1, uint256 _lat2, uint256 _lon2)  external returns (uint256) {
       // require(_availableSeats > 0, "Invalid available seats");

        uint256 totalDistance = calculateDistance(_lat1, _lon1, _lat2, _lon2);
        uint256 pricePerKilometer = calculatePricePerKilometer(totalDistance);

        Ride storage newRide = rides.push();

        newRide.driver = msg.sender;
        newRide.availableSeats = _availableSeats;
       
       // newRide.pricePerKilometer = pricePerKilometer;
        //newRide.totalDistance = totalDistance;
        newRide.price = 10000000000000000000;
        totalRides++;

        uint256 rideId = rides.length - 1;

        emit RideCreated(rideId, msg.sender, _availableSeats, pricePerKilometer, totalDistance,5);
        return totalDistance;
    }
    function calculateDistance(uint256 lat1, uint256 lon1, uint256 lat2, uint256 lon2) internal pure returns (uint256) {
        // Earth's radius in kilometers
        uint256 earthRadiusKm = 6371;

        // Convert latitude and longitude from degrees to radians
        uint256 lat1Rad = lat1 * (10**18) / 180;
        uint256 lon1Rad = lon1 * (10**18) / 180;
        uint256 lat2Rad = lat2 * (10**18) / 180;
        uint256 lon2Rad = lon2 * (10**18) / 180;

        // Haversine formula
        uint256 dLat = lat2Rad - lat1Rad;
        uint256 dLon = lon2Rad - lon1Rad;
        uint256 a = (dLat * dLat + dLon * dLon) / 2;

        // Taylor series expansion to approximate arcsine (inverse sine)
        uint256 x = a;
        uint256 result = x;
        for (uint256 i = 1; i < 20; i += 2) {
            x = x * a * a / (2 * i * (i + 1));
            result = result + x / (2 * i + 1);
        }

        result = result * earthRadiusKm;

        // Convert the distance back to uint256 with the desired precision (e.g., 2 decimals)
        uint256 distanceUint = result / (10**16); // Assuming 4 decimals precision

        return distanceUint;
    }



    function calculatePricePerKilometer(uint256 _totalDistance) private pure returns (uint256) {
        // Implement your logic to calculate the price per kilometer based on _totalDistance
        // For the sake of demonstration, we'll assume the price is 0.1 Ether per kilometer
        return _totalDistance * 10**17;
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
    // Function to get the total number of rides
    function getRidesCount() public view returns (uint256) {
        return totalRides;

    } 
    
    
}
