import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { expect } from "chai";
import hre, { ethers } from "hardhat";

describe("CreditScore", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployCreditScoreFixture() {
   
    // Contracts are deployed using the first signer/account by default
    const [owner, addr1] = await hre.ethers.getSigners();

    const CreditScore = await hre.ethers.getContractFactory("CreditScore");
    const creditScore = await CreditScore.deploy(owner);

    return { creditScore, owner, addr1 };
  }

  async function updateCreditScoreElements(creditScore: any, addr1: any) {

    await creditScore.updateTransactionVolume(addr1.address, 5000);
    await creditScore.updateWalletBalance(addr1.address, ethers.parseEther("50"));
    await creditScore.updateTransactionFrequency(addr1.address, 500);
    await creditScore.updateTransactionMix(addr1.address, 5);
    await creditScore.updateNewTransactions(addr1.address, 5);
  }

  describe("Deployment", function () {

    it("Should deploy the contract and set the correct owner", async function () {
      const {creditScore, owner} = await loadFixture(deployCreditScoreFixture);

      expect(await creditScore.owner()).to.equal(owner.address);
    });
    
  });

  describe("Credit score element configurations", function () {

    it("Should allow the owner to update transaction volume configuration", async function () {
      const {creditScore, owner} = await loadFixture(deployCreditScoreFixture);

      await creditScore.updateTransactionVolumeConfig(200, 20000);
      const config = await creditScore.transactionVolumeConfig();
      expect(config.minValue).to.equal(200);
      expect(config.maxValue).to.equal(20000);
    });
  
    it("Should revert if non-owner tries to update transaction volume configuration", async function () {
      const {creditScore, addr1} = await loadFixture(deployCreditScoreFixture);

      await expect(
        creditScore.connect(addr1).updateTransactionVolumeConfig(200, 20000)
      ).to.be.revertedWithCustomError(creditScore, 'OwnableUnauthorizedAccount');
    });
  
    
  });

  describe("Credit Score Calculations", function () {
    
    it("Should correctly update the credit score", async function () {
      const {creditScore, addr1} = await loadFixture(deployCreditScoreFixture);

      await updateCreditScoreElements(creditScore, addr1);

      const info = await creditScore.creditInfo(addr1.address);
      
      expect(info.creditScore).to.be.within(300, 850);
      expect(info.lastUpdated).to.be.gt(0);
    });
    
    it("Should correctly update the credit score", async function () {
      const {creditScore, addr1} = await loadFixture(deployCreditScoreFixture);

      await updateCreditScoreElements(creditScore, addr1);

      const info = await creditScore.creditInfo(addr1.address);
      
      expect(info.creditScore).to.be.within(300, 850);
      expect(info.lastUpdated).to.be.gt(0);
    });
  
    it("Should emit UpdatedCreditScore event", async function () {
      const {creditScore, addr1} = await loadFixture(deployCreditScoreFixture);

      await updateCreditScoreElements(creditScore, addr1);

      await expect(creditScore.updateCreditScore(addr1.address))
        .to.emit(creditScore, "UpdatedCreditScore")
        .withArgs(addr1.address, await creditScore.getCreditScore(addr1.address));
    });
  });


});
