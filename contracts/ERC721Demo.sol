// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// 引入 openzeppelin ERC721 合约
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// 引入权限控制合约
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC721Demo is ERC721, Ownable {
    // NFT 编号，从1开始，自动累加
    uint256 public tokenId; 
    // tokenId 到对应 tokenURI 的映射
    mapping(uint256 => string) tokenURIs; 

    // 构造函数
    constructor() ERC721("BinSchool NFT", "BSNFT") Ownable(msg.sender) {
      // NFT名称为"BinSchool NFT"，符号为"BSNFT"
      // 将合约部署者设为合约所有者
    }

    /**
     * @dev 铸造新的NFT并将其分配给指定地址。
     * @param _to 接收新NFT的地址。
     * @param _tokenURI 代表新NFT元数据的URI。
     */
    function mint(address _to, string memory _tokenURI) external onlyOwner {
      // 铸造新的NFT并分配给指定地址
      // 新NFT编号为上一个的编号加1
      _mint(_to, ++tokenId); 
      // 关联tokenURI 到 tokenId
      tokenURIs[tokenId] = _tokenURI;  
    }

    /**
     * @dev 获取给定 tokenId 的 tokenURI。
     * @param _tokenId 要获取URI的token的ID。
     */
    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
      // 返回指定 tokenId 的 tokenURI
      return tokenURIs[_tokenId]; 
    }
}