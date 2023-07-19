// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

address public company;
address public contractor;
uint public projectCompletionDate;
uint public projectCost;
bool public companyApproved;
bool public contractorApproved;
bool public projectCompleted;

constructor(address _company, address _contractor, uint _completionDate, uint _cost) {
    company = _company;
    contractor = _contractor;
    projectCompletionDate = _completionDate;
    projectCost = _cost;
}

function approveContractor() public {
    require(msg.sender == company);
    contractorApproved = true;
}

function approveCompany() public {
    require(msg.sender == contractor);
    companyApproved = true;
}

function completeProject() public {
    require(msg.sender == contractor && contractorApproved == true && companyApproved == true);
    require(block.timestamp <= projectCompletionDate);
    payable(contractor).transfer(projectCost);
    projectCompleted = true;
}

function refundProject() public {
    require(msg.sender == company && contractorApproved == false && companyApproved == false);
    payable(company).transfer(projectCost);
}