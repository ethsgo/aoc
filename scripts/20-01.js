const hre = require('hardhat')

async function main() {
  const Contract = await hre.ethers.getContractFactory('C20_01')
  const contract = await Contract.deploy()
  await contract.deployed()

  console.log(await contract.p1())
}

main().catch((e) => {
  console.error(e)
  process.exit(1)
})
