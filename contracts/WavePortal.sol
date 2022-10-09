// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;
    // address[] adrs;

    uint256 private seed; // We will be using this below to help generate a random number

    event NewWave(address indexed from, uint256 timestamp, string message);

    // A struct is basically a custom datatype where we can customize what we want to hold inside it.
    struct Wave {
        address waver; // The address of the user who waved.
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user waved.
    }

    // I declare a variable waves that lets me store an array of structs.
    // This is what lets me hold all the waves anyone ever sends to me!
    Wave[] waves;

    // This is an address => uint mapping, meaning I can associate an address with a number!
    // In this case, I'll be storing the address with the last time the user waved at us.
    mapping(address => uint256) public lastWavedAt;

    constructor() payable {
        console.log("First Time Creating a Contract!");
        seed = (block.timestamp + block.difficulty) % 100; // Set the initial seed
    }

    function wave(string memory _message) public {
        require(lastWavedAt[msg.sender] + 30 seconds < block.timestamp, "Wait 30 seconds before waving again"); // We need to make sure the current timestamp is at least 15-minutes bigger than the last timestamp we stored

        // Update the current timestamp we have for the user
        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        console.log("%s has waved!", msg.sender, _message);

        waves.push(Wave(msg.sender, _message, block.timestamp)); // This is where I actually store the wave data in the array.

        seed = (block.difficulty + block.timestamp + seed) % 100; // Generate a new seed for the next user that sends a wave
        console.log("Random # generated: %d", seed);

        // Give a 50% chance that the user wins the prize.
        if (seed < 50) {
            console.log("%s won!", msg.sender);

            // The same code we had before to send the prize.
            uint256 prizeAmount = 0.0001 ether;
            require(prizeAmount <= address(this).balance,"Trying to withdraw more money than the contract has.");
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }

        emit NewWave(msg.sender, block.timestamp, _message);

        // adrs.push(msg.sender);
        // for (uint256 i = 0; i < 5; i++) {
        //     console.log("%s has waved!", adrs[i]);
        // }
    }

    // a function getAllWaves which will return the struct array, waves, to us.
    // This will make it easy to retrieve the waves from our website!
    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves()  public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }
}