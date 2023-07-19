// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract SupplyChain {

    struct Order {
        uint256 orderID;
        address supplier;
        uint256 quantity;
        uint256 deliveryDeadline;
        bool isDelivered;
        bool isVerified;
    }

    mapping (uint256 => Order) public orders;

    uint256 public orderCounter;

    function createOrder(address _supplier, uint256 _quantity, uint256 _deliveryDeadline) public returns (uint256) {
        orderCounter++;
        orders[orderCounter] = Order(orderCounter, _supplier, _quantity, _deliveryDeadline, false, false);
        return orderCounter;
    }

    function verifyDelivery(uint256 _orderID) public {
        require(orders[_orderID].isDelivered == true, "Order not yet delivered");
        orders[_orderID].isVerified = true;
    }

    function markDelivery(uint256 _orderID) public {
        require(msg.sender == orders[_orderID].supplier, "Only supplier can mark delivery");
        require(orders[_orderID].deliveryDeadline > block.timestamp, "Delivery deadline passed");
        orders[_orderID].isDelivered = true;
    }

    function getOrderDetails(uint256 _orderID) public view returns (uint256, address, uint256, uint256, bool, bool) {
        return (orders[_orderID].orderID, orders[_orderID].supplier, orders[_orderID].quantity, orders[_orderID].deliveryDeadline, orders[_orderID].isDelivered, orders[_orderID].isVerified);
    }
}