# Credit Score Smart Contract and Backend System
This repository contains a Solidity smart contract for managing credit scores and a Node.js backend system to interact with the smart contract. The project is designed to deploy on the Sepolia test network and includes comprehensive instructions for setting up and running both the smart contract and the backend system.

## Smart Contract
The smart contract, written in Solidity and developed with Hardhat framework, tracks and calculates credit scores based on various attributes such as transaction volume, wallet balance, transaction frequency, transaction mix, and new transactions. The contract provides functionalities to update these attributes and calculate an overall credit score.

## Backend System
The backend system, built with Node.js and Express, provides API endpoints to interact with the smart contract. It uses Passport.js for JWT-based authentication to ensure secure access to the APIs.

