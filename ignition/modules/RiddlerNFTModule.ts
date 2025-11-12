// ignition/modules/RiddlerNFTModule.ts
import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("RiddlerNFTModule", (m) => {
  const deployer = m.getAccount(0);

  // Deploy RiddlerNFT with deployer as initial owner
  // Metadata URIs will be set individually when minting each NFT
  const riddlerNFT = m.contract("RiddlerNFT", [deployer], {
    from: deployer,
  });

  return { riddlerNFT };
});