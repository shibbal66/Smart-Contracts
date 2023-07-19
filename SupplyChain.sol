// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
contract SupplyChain {
struct Item {
    uint itemId;
    uint price;
    address seller;
    address buyer;
    string status;
}

mapping (uint => Item) public items;
uint public itemCount;

event ItemAdded(uint itemId, uint price, address seller);
event ItemPurchased(uint itemId, uint price, address seller, address buyer);
event ItemShipped(uint itemId, string status);
event ItemReceived(uint itemId, string status);

function addItem(uint _price) public {
    itemCount++;
    items[itemCount] = Item(itemCount, _price, msg.sender, address(0), "For Sale");
    emit ItemAdded(itemCount, _price, msg.sender);
}

function purchaseItem(uint _itemId) public payable {
    Item storage myItem = items[_itemId];
    require(msg.value == myItem.price);
    require(myItem.buyer == address(0));
    myItem.buyer = msg.sender;
    myItem.status = "Sold";
    emit ItemPurchased(_itemId, myItem.price, myItem.seller, myItem.buyer);
}

function shipItem(uint _itemId) public {
    Item storage myItem = items[_itemId];
    require(msg.sender == myItem.seller);
    require(myItem.buyer != address(0));
    myItem.status = "Shipped";
    emit ItemShipped(_itemId, myItem.status);
}

function receiveItem(uint _itemId) public {
    Item storage myItem = items[_itemId];
    require(msg.sender == myItem.buyer);
    require(keccak256(bytes(myItem.status)) == keccak256(bytes("Shipped")));
    myItem.status = "Received";
    payable(myItem.seller).transfer(myItem.price);
    emit ItemReceived(_itemId, myItem.status);
}
}
// distribution of royalties to multiple parties involved in the creation and distribution of a digital asset, such as a song or a piece of software.