import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const CreditScoreModule = buildModule("CreditScoreModule", (m) => {
  const owner = m.getAccount(0);
  const creditScore = m.contract("CreditScore", [owner]);

  return { creditScore };
});

export default CreditScoreModule;
