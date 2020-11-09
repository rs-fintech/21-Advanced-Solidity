pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// @TODO: Inherit the crowdsale contracts
contract PupperCoinSale is Crowdsale, MintedCrowdsale, CappedCrowdsale , TimedCrowdsale, RefundablePostDeliveryCrowdsale {

    constructor(
        // @TODO: Fill in the constructor parameters!
        uint rate, 
        address payable wallet, 
        PupperCoin token,
        uint cap,
        uint256 openingTime, 
        uint256 closingTime,
        uint256 goal
    )
        // @TODO: Pass the constructor parameters to the crowdsale contracts.
        Crowdsale(rate, wallet, token)
        CappedCrowdsale(cap)
        TimedCrowdsale(openingTime, closingTime) 
        RefundableCrowdsale(goal)
        public
    {
        // constructor can stay empty
    }
}

contract PupperCoinSaleDeployer {

    // goal is 300 Ether
    uint256 constant private GOAL = 300;
    //uint256 private fakenow = now;
    
    address public token_sale_address;
    address public token_address;

    constructor(
        // @TODO: Fill in the constructor parameters!
        string memory name,
        string memory symbol,
        address payable wallet, // this address will receive all Ether raised by the sale
        uint cap
    )
        public
    {
        // @TODO: create the PupperCoin and keep its address handy
        PupperCoin token = new PupperCoin(name, symbol, 0);
        token_address = address(token);
        
        // @TODO: create the PupperCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks.
        PupperCoinSale token_sale = new PupperCoinSale(1, wallet, token, cap, now, (now + 24 weeks), GOAL);
        //PupperCoinSale token_sale = new PupperCoinSale(1, wallet, token, cap, fakenow, (now + 5 minutes), GOAL);
        token_sale_address = address(token_sale);
        
        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
    
    /*
    function setFakeNow(uint256 _date) public returns(uint256) {
        fakenow = _date;
        return fakenow;
    }
    */
}
