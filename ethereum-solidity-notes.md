# Ethereum Solidity Notes

## Resources

### NFT Markets

* niftygateway.com
* opensea.io

### Language Docs

* https://learnxinyminutes.com/docs/solidity/

### Video Walkthroughs

* https://www.youtube.com/watch?v=YJ-D1RMI0T0
* https://www.youtube.com/watch?v=xWFba_9QYmc
* https://www.youtube.com/watch?v=XLahq4qyors

### Online IDE

* https://remix.ethereum.org/

## A Basic Smart Contract

```solidity
// SPDX-License-Identifier: GPL-3.0
// This tells the compiler to use 0.7.4 version of Solidity to compile
pragma solidity ^0.7.4;

// `contract` is kind of like `class`
contract Counter {
    // an unsigned integer state variable
    uint count;

    // when you compile (upload the ethereum network) this gets run once
    constructor() {
        count = 0;
    }

    // public makes this method available to people who have access to the contract
    // view means this is read only and doesn't modify any data
    function getCount() public view returns(uint) {
        return count;
    }

    function setCount() public {
        count = count + 1;
    }
}
```

## Authorization

You can get the owner of the contract with

`msg.sender` = the Ethereum address of the user who deployed the smart contract
