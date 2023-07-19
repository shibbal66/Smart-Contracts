// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract InsuranceClaim {

    struct Claim {
        address policyholder;
        uint claimAmount;
        bool isProcessed;
        bool isApproved;
    }

    mapping (uint => Claim) public claims;
    uint public claimCount;

    event ClaimFiled(uint claimId, address policyholder, uint claimAmount);

    function fileClaim(uint _claimAmount) public {
        require(_claimAmount > 0, "Claim amount must be greater than zero.");
        claims[claimCount] = Claim(msg.sender, _claimAmount, false, false);
        emit ClaimFiled(claimCount, msg.sender, _claimAmount);
        claimCount++;
    }

    function processClaim(uint _claimId, bool _isApproved) public {
        require(claims[_claimId].policyholder == msg.sender, "Only policyholder can process their claim.");
        require(!claims[_claimId].isProcessed, "Claim has already been processed.");
        claims[_claimId].isProcessed = true;
        claims[_claimId].isApproved = _isApproved;
    }
}
// A smart contract that automates the insurance claims process, reducing processing time and increasing transparency.