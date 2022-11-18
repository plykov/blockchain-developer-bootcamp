// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import 'hardhat/console.sol';
import './Token.sol';

contract Exchange
{
    address public feeAccount;
    uint256 public feePercent;
    mapping(address => mapping(address => uint256)) public tokens;
    mapping(uint256 => _Order) public orders;
    uint256 public orderCount;//0


    event Deposit(
        address token, 
        address user, 
        uint256 amount, 
        uint256 balance
    );
    event Withdraw(
        address token,
        address user,
        uint256 amount,
        uint256 balance
    );
    event Order(
        uint256 id,
        address user,
        address tokenGet,
        uint256 amountGet,
        address tokenGive,
        uint256 amountGive,
        uint256 timestamp
    );

    struct _Order {
        //Attributes of the order
        uint256 id; //unique identifier
        address user; //user who made order
        address tokenGet;
        uint256 amountGet;
        address tokenGive;
        uint256 amountGive;
        uint256 timestamp; //when order was created
    }

    constructor(address _feeAccount, uint256 _feePercent) 
    {
        feeAccount = _feeAccount;
        feePercent = _feePercent;
    }

    // --------------------------
    // DEPOSIT AND WITHDRAW TOKEN
    function depositToken(address _token, uint256 _amount) public 
    {
        //transfer tokens to exchange
        require( Token(_token).transferFrom(msg.sender, address(this), _amount));
        //update balance
        tokens[_token][msg.sender] = tokens[_token][msg.sender] + _amount;
        //emit an event
        emit Deposit(_token, msg.sender, _amount, tokens[_token][msg.sender]);
    }

    function withdrawToken(address _token, uint256 _amount) public 
    {
        //ensure user has enough tokens to withdraw
        require(tokens[_token][msg.sender] >= _amount);
        
        //transfer tokens to the user
        Token(_token).transfer(msg.sender, _amount);
        
        //update user balance
        tokens[_token][msg.sender] = tokens[_token][msg.sender] - _amount;

        //emit event
        emit Withdraw(_token, msg.sender, _amount, tokens[_token][msg.sender]); 
    }

    function balanceOf(address _token, address _user)
    public
    view
    returns (uint256)
    {
        return tokens[_token][_user];
    }
//--------------------
//MAKE & CANCEL ORDERS
    function makeOrder(
        address _tokenGet, 
        uint256 _amountGet, 
        address _tokenGive, 
        uint256 _amountGive) 
        public 
        {
        //require token balance
        require(balanceOf(_tokenGive, msg.sender) >= _amountGive);        
        //create ordeer
        orderCount = orderCount + 1;
        orders[orderCount] = _Order(
            orderCount,
            msg.sender,
            _tokenGet,
            _amountGet,
            _tokenGive,
            _amountGive,
            block.timestamp
            );
        //Emit the event
        emit Order(
            orderCount,
            msg.sender,
            _tokenGet,
            _amountGet,
            _tokenGive,
            _amountGive,
            block.timestamp
            );

        }



}
