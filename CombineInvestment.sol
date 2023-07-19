// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract RoyaltyDistribution {
    address payable public artist;
    address payable[] public contributors;
    mapping (address => uint256) public contributorShares;
    uint256 public totalShares;
    uint256 public totalAmount;

    constructor(address payable _artist, address payable[] memory _contributors, uint256[] memory _shares) {
        require(_artist != address(0), "Invalid artist address");
        require(_contributors.length == _shares.length, "Invalid contributors data");
        
        artist = _artist;
        
        for (uint256 i = 0; i < _contributors.length; i++) {
            require(_contributors[i] != address(0), "Invalid contributor address");
            require(_shares[i] > 0, "Invalid contributor share");
            
            contributorShares[_contributors[i]] = _shares[i];
            contributors.push(_contributors[i]);
            
            totalShares += _shares[i];
        }
    }

    function distributeRoyalties() public payable {
        require(msg.sender == artist, "Only the artist can distribute royalties");
        require(address(this).balance >= totalAmount, "Insufficient contract balance");

        uint256 artistAmount = totalAmount * (100 - totalShares) / 100;
        artist.transfer(artistAmount);

        for (uint256 i = 0; i < contributors.length; i++) {
            address payable contributor = contributors[i];
            uint256 contributorAmount = totalAmount * contributorShares[contributor] / 100;
            contributor.transfer(contributorAmount);
        }
    }

    function addContributor(address payable _contributor, uint256 _share) public {
        require(msg.sender == artist, "Only the artist can add a contributor");
        require(_contributor != address(0), "Invalid contributor address");
        require(_share > 0, "Invalid contributor share");

        contributorShares[_contributor] = _share;
        contributors.push(_contributor);
        
        totalShares += _share;
    }

    function removeContributor(address payable _contributor) public {
        require(msg.sender == artist, "Only the artist can remove a contributor");
        require(contributorShares[_contributor] > 0, "Contributor not found");
        
        totalShares -= contributorShares[_contributor];
        delete contributorShares[_contributor];
        
        for (uint256 i = 0; i < contributors.length; i++) {
            if (contributors[i] == _contributor) {
                contributors[i] = contributors[contributors.length - 1];
                contributors.pop();
                break;
            }
        }
    }

    receive() external payable {
        totalAmount += msg.value;
    }
}
// pool their money together to invest in a rental property, but they need a way to ensure that everyone's investment is accounted for and that they receive their fair share of the profits.