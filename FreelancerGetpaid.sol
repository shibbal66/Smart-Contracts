// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract FreelanceWritingProject {

    address public client; // The address of the client who's hiring the writer
    address public writer; // The address of the writer who's being hired
    uint public articlePrice; // The price of each article, in ether
    uint public numArticles; // The total number of articles to be written
    uint public totalPayment; // The total payment for the project, in ether
    uint public numArticlesWritten; // The number of articles that have been written so far
    mapping(uint => bool) public articlesCompleted; // Mapping of completed articles
    
    event PaymentSent(address to, uint amount); // Event for when payment is sent
    
    constructor(address _client, address _writer, uint _articlePrice, uint _numArticles) {
        client = _client;
        writer = _writer;
        articlePrice = _articlePrice;
        numArticles = _numArticles;
        totalPayment = articlePrice * numArticles;
        numArticlesWritten = 0;
    }
    
    function writeArticle(uint articleNumber) public {
        require(msg.sender == writer, "Only the writer can write an article.");
        require(articleNumber < numArticles, "Invalid article number.");
        require(!articlesCompleted[articleNumber], "Article has already been written.");
        articlesCompleted[articleNumber] = true;
        numArticlesWritten++;
        if (numArticlesWritten == numArticles) {
            payWriter();
        }
    }
    
    function payWriter() private {
        require(address(this).balance >= totalPayment, "Insufficient funds to pay writer.");
        payable(writer).transfer(totalPayment);
        emit PaymentSent(writer, totalPayment);
    }
    
    function getClient() public view returns (address) {
        return client;
    }
    
    function getWriter() public view returns (address) {
        return writer;
    }
    
    function getArticlePrice() public view returns (uint) {
        return articlePrice;
    }
    
    function getNumArticles() public view returns (uint) {
        return numArticles;
    }
    
    function getTotalPayment() public view returns (uint) {
        return totalPayment;
    }
    
    function getNumArticlesWritten() public view returns (uint) {
        return numArticlesWritten;
    }
    
    function getArticleStatus(uint articleNumber) public view returns (bool) {
        return articlesCompleted[articleNumber];
    }
}
//You and the client have agreed on a price of $100 per article, with a total of 10 articles to be written. You want to ensure that you get paid for your work, but you also want to ensure that the client isn't overcharged or undercharged.