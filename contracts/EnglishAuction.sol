// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/access/Ownable.sol";

contract EnglishAuction is Ownable {

    uint constant START_PRICE = 1 ether; // 起拍价
    uint constant DURATION = 60 seconds; // 拍卖持续时间
    uint constant MIN_INCREMENT = 0.1 ether; // 最小竞价幅度

    uint256 public startTime; // 拍卖开始时间
    address public highestBidder; // 当前最高出价者
    uint256 public highestBid; // 当前最高出价

    // 拍卖开始事件
    event AuctionStarted(uint startPrice, uint startTime);
    // 拍卖结束事件
    event AuctionEnded(address winner, uint winningBid);
    // 竞拍事件
    event Bid(address bidder, uint bidAmount);
    // 退款事件
    event Refund(address bidder, uint bidAmount, bool success);
    // 构造函数，设置合约拥有者
    constructor() Ownable(msg.sender) {}

    function startAuction() public onlyOwner {
        // 确保拍卖还未开始
        require(startTime == 0, "auction already started");
        // 记录拍卖开始时间为当前时间戳
        startTime = block.timestamp;
        // 将最高出价者清零
        highestBidder = address(0);
        // 最高出价初始化为起拍价
        highestBid = START_PRICE;
        // 触发拍卖开始事件，传入起拍价和开始时间
        emit AuctionStarted(START_PRICE, startTime);
    }

    // 竞拍出价
    function bid() public payable {
        // 当前竞拍者
        address bidder = msg.sender; 
        // 当前竞拍出价
        uint amount = msg.value;

        // 确保处于拍卖有效期：拍卖已经开始且未结束
        require(startTime > 0 && 
            block.timestamp < startTime + DURATION, 
            "invalid auction time"); 

        // 出价必须高于当前最高出价，且加价不小于最小幅度
        require(amount > highestBid && 
            amount - highestBid >= MIN_INCREMENT, 
            "invalid auction bid");
        
        
       if (highestBidder != address(0)) {
            // 退还之前最高出价者的款项
            bool sent = payable(highestBidder).send(highestBid);
            // 触发 Refund 事件，记录退款是否成功
            emit Refund(highestBidder, highestBid, sent);
        }

        // 更新最高出价者为当前竞拍者
        highestBidder = bidder; 
        // 更新最高出价为竞拍出价
        highestBid = amount;

        // 触发出价事件
        emit Bid(msg.sender, msg.value); 
    }

     // 结束拍卖，仅合约拥有者可调用
    function endAuction() public onlyOwner {
          // 确保超过拍卖有效期
        require(startTime > 0 && 
            block.timestamp >= startTime + DURATION, 
            "invalid auction time"); 

        
        // 触发拍卖结束事件
        emit AuctionEnded(highestBidder, highestBid); 
        // 拍卖开始时间清零
        startTime = 0;
        // 将合约余额转给合约拥有者
        uint amount = address(this).balance;
       if (amount > 0) {
            payable(owner()).transfer(amount); 
        }
        //这里可以加入对竞拍成功者的任意操作
        //.....
    }
}
