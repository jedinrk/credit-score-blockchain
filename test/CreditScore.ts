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
    const creditScore = await CreditScore.deploy();

    return { creditScore, owner, addr1 };
  }

  describe("Deployment", function () {
    it("should update and retrieve credit information", async function () {
      const {creditScore, addr1} = await loadFixture(deployCreditScoreFixture);

      await creditScore.updateCreditScore(
        addr1.address,
        500,
        ethers.parseUnits("20", 'ether'),
        20,
        5,
        2
      );
  
      const creditInfo = await creditScore.creditInfo(addr1.address);
      expect(creditInfo.transactionVolume).to.equal(40);
      expect(creditInfo.walletBalance).to.equal(191);
      expect(creditInfo.transactionFrequency).to.equal(10);
      expect(creditInfo.transactionMix).to.equal(444);
      expect(creditInfo.newTransactions).to.equal(111);
  
      const creditScoreValue = await creditScore.getCreditScore(addr1.address);
      expect(creditScoreValue).to.equal(370); // Based on the provided weights
  
      const lastUpdated = await creditScore.getLastUpdated(addr1.address);
      expect(lastUpdated).to.be.above(0); // Timestamp should be set
    });

  });


});
