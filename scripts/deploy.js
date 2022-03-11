const {ethers, upgrades} = require("hardhat");

async function main() {
  console.log("OK")
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
