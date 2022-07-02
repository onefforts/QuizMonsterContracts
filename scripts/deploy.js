const main = async () => {
  const gameContractFactory = await hre.ethers.getContractFactory("SolanoyuGame");
  const gameContract = await gameContractFactory.deploy();
  const nftGame = await gameContract.deployed();
  console.log("Contract deployed to:", nftGame.address);
  let txn;
  txn = await gameContract.mintQuizNFT(2, "hoge_title", "https://i.imgur.com/WVAaMPA.png", 10, 20, 23);
  await txn.wait();
  console.log("Minted NFT #1");

  let returnedTokenUri = await gameContract.tokenURI(1);
  let nftData = await gameContract.getNftData();
  console.log("Token URI:", returnedTokenUri);
  console.log("Contract deployed to:", nftGame.address);
  console.log("This is nftData:", nftData);

  console.log("Done deploying and minting!");
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
