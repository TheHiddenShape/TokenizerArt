// ignition/modules/RiddlerNFTModule.ts
import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("RiddlerNFTModule", (m) => {
  const deployer = m.getAccount(0);

  // IPFS URI pointing to your metadata.json
  // Replace with your actual IPFS hash after uploading to Pinata/NFT.Storage
  const metadataURI = "ipfs://Qmbafkreigzf7q3uz77vp2tkz2bebcj3je7ew6rr7krjcg5vsps4t37olozwa/metadata.json";

  const riddlerNFT = m.contract("RiddlerNFT", [metadataURI], {
    from: deployer,
  });

  return { riddlerNFT };
});