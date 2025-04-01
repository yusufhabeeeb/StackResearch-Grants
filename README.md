# Stacks-Research - Research Funding Smart Contract

## Overview
The Research Funding Smart Contract is a Clarity-based decentralized application that allows researchers to propose research projects, receive funding, and mark projects as completed once they reach their funding goal. This contract ensures transparency, security, and immutability in research funding on the Stacks blockchain.

## Features
- **Project Proposal**: Researchers can submit new project proposals, specifying title, description, and required funding amount.
- **Project Funding**: Supporters can fund proposed projects by transferring STX tokens.
- **Project Completion**: Researchers can mark fully funded projects as completed.
- **Access Control**: Only the project creator can complete their respective projects.
- **State Management**: Projects transition through distinct states (Proposed → Funded → Completed).

## Smart Contract Details
### Constants
- `CONTRACT-OWNER`: Defines the contract deployer.
- `ERR-UNAUTHORIZED`: Error for unauthorized access.
- `ERR-INSUFFICIENT-FUNDS`: Error when funding exceeds the required amount.
- `ERR-PROJECT-NOT-FOUND`: Error when querying a non-existent project.
- `ERR-INVALID-INPUT`: Error for invalid function input.

### Project Status Enum
- `PROJECT-STATUS-PROPOSED (0)`: The project is open for funding.
- `PROJECT-STATUS-FUNDED (1)`: The project has received full funding.
- `PROJECT-STATUS-COMPLETED (2)`: The project has been completed.

### Data Structures
- `projects` (Map): Stores project details, indexed by project ID.
- `next-project-id` (Variable): Keeps track of the next project ID.

## Functions
### 1. `propose-project`
**Description**: Allows a researcher to submit a new project proposal.
**Inputs**:
- `title` (string, max 100 characters)
- `description` (string, max 500 characters)
- `total-funding-required` (uint)
**Returns**: The unique project ID.

### 2. `fund-project`
**Description**: Allows users to fund a research project.
**Inputs**:
- `project-id` (uint)
- `funding-amount` (uint)
**Returns**: `true` if successful.

### 3. `complete-project`
**Description**: Allows the researcher to mark their funded project as completed.
**Inputs**:
- `project-id` (uint)
**Returns**: `true` if successful.

## Deployment Instructions
1. Install [Clarinet](https://github.com/hirosystems/clarinet) to test and deploy the contract.
2. Clone the repository and navigate to the contract directory.
3. Deploy the contract using Clarinet:
   ```sh
   clarinet test
   clarinet check
   clarinet deploy
   ```

## Usage
1. Call `propose-project` to create a research project.
2. Call `fund-project` with a valid `project-id` and `funding-amount` to contribute to a project.
3. Once fully funded, the researcher calls `complete-project` to mark the project as completed.

## Potential Improvements
- Implement a refund mechanism for failed projects.
- Introduce milestones and partial fund releases.
- Enable governance-based approval for projects.
- Develop a front-end UI for easy interaction.

## Name Suggestions
1. **DecentraFund Research**
2. **StackResearch Grants**
3. **OpenSource Science Fund**
4. **Clarity Research DAO**
5. **SmartFund Science**

---

This contract provides a transparent and immutable way to fund research, ensuring integrity and proper fund allocation.

