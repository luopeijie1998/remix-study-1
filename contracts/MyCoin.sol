// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MyCoin {
    string public constant name = "LPJ Coin"; // 代币名称
    string public constant symbol = "BC"; // 代币符号
    uint8 public constant decimals = 18; // 小数位数，也称为精度
    uint256 _totalSupply = uint256(100*10**18); // 发行总量 100 个

    // 存放持币地址对应的持币数量
    mapping(address => uint256) private balances;  

    // 存放特定地址对应的授权地址和授权数量
    mapping(address => mapping(address => uint256)) private allowances; 

    // 转账事件
    event Transfer(address indexed from, address indexed to, uint256 value);  

    // 授权事件
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // 构造函数，部署时铸造全部代币
    constructor() {
      // 部署时，发行所有代币，并归属于合约部署者
      balances[msg.sender] = _totalSupply;
    }

    // 查询所有代币总供应量
    function totalSupply() public view returns (uint256) {
        return _totalSupply;   // 返回发行总量
    }
    
    // 获取特定地址 account 的余额
    function balanceOf(address account) external view returns (uint256) {
        // 余额记录全部存放在映射 balances 中，balances 就是一个内部账本
        // 从映射 balances 中取得地址 account 的余额
        return balances[account];
    }

    // 调用者 msg.sender 转给接收者 recipient ，共 amount 个代币   
    function transfer(address recipient,uint256 amount) external returns (bool){
        // 检查接收者地址是否为空地址
        require(recipient != address(0), "ERC20: transfer to the zero address");
        // 检查调用者（发送者）的余额是否足够进行转移
        require(balances[msg.sender] >= amount, 
           "ERC20: transfer amount exceeds balance");
         // 扣除调用者的代币数量
        balances[msg.sender] -= amount;
        // 增加接收者的代币数量
        balances[recipient] += amount;
         // 触发 Transfer 事件，通知其他应用程序转移发生了
        emit Transfer(msg.sender, recipient, amount);
        // 返回转移是否成功
        return true;
    }
    // 获取地址 owner 授权给地址 spender 能够转移的代币数量
    function allowance(address owner, address spender) external view returns (uint256) {
        return allowances[owner][spender];   // 返回授权余额
    }

    // 调用者 msg.sender 授权给地址 spender ，共可转移 amount 个代币
    function approve(address spender, uint256 amount) external returns (bool){
        // 更新调用者（代币所有者）授权给 spender 的代币数量
        allowances[msg.sender][spender] = amount;
        // 触发 Approval 事件，通知其他应用程序授权发生了变化
        emit Approval(msg.sender, spender, amount);
        // 返回授权是否成功
        return true;
    }
    // 调用者 msg.sender 将发送者 sender 的 amount 个代币转给接收者 recipient
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool)  {
        // 检查接收者地址是否为空地址
        require(recipient != address(0),
          "ERC20: transfer to the zero address");
        // 检查发送者的余额是否足够进行转移
        require(balances[sender] >= amount, 
          "ERC20: transferFrom amount exceeds balance");

        // 获取发送者授权给接收者的代币数量
        uint256 senderAllowance = allowances[sender][msg.sender];

         // 检查授权数量是否足够进行转移
        require(senderAllowance >= amount, "ERC20: insufficient allowance");

        // 扣除发送者的代币数量
        balances[sender] -= amount;
        // 增加接收者的代币数量
        balances[recipient] += amount;
        if (senderAllowance != type(uint256).max) {
          // 如果不是无限授权，就更新授权余额
          uint256 newAllowance = senderAllowance - amount;
          allowances[sender][msg.sender] = newAllowance;
          // 触发 Approval 事件，通知其它应用程序授权发生了变化
          emit Approval(sender, msg.sender, newAllowance);
        }

        // 返回转移是否成功
        return true;
    }


}