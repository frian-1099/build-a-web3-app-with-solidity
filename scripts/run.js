const { getContractFactory } = require("@nomiclabs/hardhat-ethers/types")
const { hexStripZeros } = require("ethers/lib/utils")

const main = async () => {
    const waveContractFactory = await hre.ethers.getContractFactory("WavePortal"); // Compile our contract and generate the necessary files
    const waveContract = await waveContractFactory.deploy({value: hre.ethers.utils.parseEther("0.1")});
    await waveContract.deployed();
    console.log("Contract addy:", waveContract.address);

    // Get Contract balance
    let contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
    console.log("Contract balance:",hre.ethers.utils.formatEther(contractBalance));

    // Send Wave
    let waveTxn = await waveContract.wave("#1 Wave!");
    await waveTxn.wait();
    let waveTxn2 = await waveContract.wave("#2 Wave!");
    await waveTxn2.wait();

    // Get Contract balance to see what happened!
    contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
    console.log("Contract balance:",hre.ethers.utils.formatEther(contractBalance));

    let waveCount = await waveContract.getTotalWaves();
    console.log(waveCount.toNumber());

    // Let's send a few waves!
    // let waveTxn = await waveContract.wave("A message!");
    // await waveTxn.wait(); // Wait for the transaction to be mined

    // const [_, randomPerson] = await hre.ethers.getSigners();
    // waveTxn = await waveContract.connect(randomPerson).wave("Another message!");
    // await waveTxn.wait(); // Wait for the transaction to be mined

    // let allWaves = await waveContract.getAllWaves();
    // console.log(allWaves);
};

const runMain = async () => {
    try {
        await main()
        process.exit(0); // exit Node process without error
    } catch (error) {
        console.log(error);
        process.exit(1); // exit Node process while indicating 'Uncaught Fatal Exception' error
    }
};

runMain();