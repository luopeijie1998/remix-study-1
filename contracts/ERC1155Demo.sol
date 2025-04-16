// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract ERC1155Demo is ERC1155, Ownable {
    // 引入用于处理字符串的库
    using Strings for uint256;

    // 代币名称
    string constant _name = "BinSchool NFT"; 
    // 代币符号
    string constant _symbol = "BSNFT"; 
   // 用于拼接URI的基础部分
    string constant _baseURI = "https://binschool.org/";

    // 构造函数，初始化ERC1155和Ownable合约
    constructor() ERC1155("") Ownable(msg.sender) {
    }
    // 返回代币名称
    function name() public pure returns (string memory) {
        return _name;
    }
    // 返回代币符号
    function symbol() public pure returns (string memory) {
        return _symbol;
    }
    // 铸造新的代币并将其分发到指定账户，只允许合约所有者调用
    function mint(address to, uint256 id, uint256 value) 
      external onlyOwner {
        _mint(to, id, value, "");
    }
    // 获取特定ID的代币的元数据URI
    function uri(uint256 id) public pure override 
      returns (string memory) {
        return string(abi.encodePacked(_baseURI, id.toString(), ".json"));
    }
}