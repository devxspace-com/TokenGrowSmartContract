import fs from "fs";
const bytecode = fs.readFileSync("binaries/src_TokenGrow_sol_TokenGrow.bin");

import { ContractCreateFlow, Client} from '@hashgraph/sdk';
 
/*
* Stores the bytecode and deploys the contract to the Hedera network.
* Returns an array with the contractId and contract solidity address.
*
* Note: This single call handles what FileCreateTransaction(), FileAppendTransaction() and
* ContractCreateTransaction() classes do.
*/

const gasLimit = 1000000;
const deployContract = async (client: Client, bytecode: string | Uint8Array, gasLimit: number) => {
 const contractCreateFlowTxn = new ContractCreateFlow()
   .setBytecode(bytecode)
   .setGas(gasLimit);
 
 console.log(`- Deploying smart contract to Hedera network`)
 const txnResponse = await contractCreateFlowTxn.execute(client);
 
 const txnReceipt = await txnResponse.getReceipt(client);
 const contractId = txnReceipt.contractId;
 if (contractId === null ) { throw new Error("Somehow contractId is null.");}
 
 const contractSolidityAddress = contractId.toSolidityAddress();
 
 console.log(`- The smart contract Id is ${contractId}`);
 console.log(`- The smart contract Id in Solidity format is ${contractSolidityAddress}\n`);
 
 return [contractId, contractSolidityAddress];
}

// deployContract(bytecode, gasLimit, client )

const hederaFoundryExample = async () => {
    // read the bytecode
    const bytecode = fs.readFileSync("binaries/src_TokenGrow_sol_TokenGrow.bin");
   
    // Deploy contract
    const gasLimit = 1000000;
    const [contractId, contractSolidityAddress] = await deployContract(client, bytecode, gasLimit);
 }
 hederaFoundryExample();
