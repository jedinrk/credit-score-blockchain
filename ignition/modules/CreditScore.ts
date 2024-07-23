import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const CreditScoreModule = buildModule("CreditScoreModule", (m) => {
  const creditScore = m.contract("CreditScore", [], {});

  return { creditScore };
});

export default CreditScoreModule;
