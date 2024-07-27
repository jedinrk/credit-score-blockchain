# Credit Score Smart Contract and Backend System
This repository contains a Solidity smart contract for managing credit scores and a Node.js backend system to interact with the smart contract. The project is designed to deploy on the Sepolia test network and includes comprehensive instructions for setting up and running both the smart contract and the backend system.

## Smart Contract
The smart contract, written in Solidity and developed with Hardhat framework, tracks and calculates credit scores based on various attributes such as transaction volume, wallet balance, transaction frequency, transaction mix, and new transactions. The contract provides functionalities to update these attributes and calculate an overall credit score.

## Backend System
The backend system, built with Node.js and Express, provides API endpoints to interact with the smart contract. It uses Passport.js for JWT-based authentication to ensure secure access to the APIs.

## How to Install, Configure, and Run the Hardhat Project

### Installation

1. Clone the repository:
  ```
  git clone https://github.com/yourusername/CreditScoreProject.git
  cd CreditScoreProject
  ```

2. Install dependencies:
  ```
  npm install
  ```

Configuration
Create a .env file in the root directory with the following content:

  ```
  SEPOLIA_URL=https://sepolia.infura.io/v3/YOUR_INFURA_PROJECT_ID
  PRIVATE_KEY=YOUR_PRIVATE_KEY
  ```

Running the Project
1. Compile the smart contract:
  ```
  npx hardhat compile
  ```
2. Deploy the smart contract to the Sepolia test network:
  ```
  npx hardhat ignition deploy ./ignition/modules/CreditScore.ts --network sepolia
  ```
3. Run the tests:
  ```
  npx hardhat test
  ```


