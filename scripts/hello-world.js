const hre = require('hardhat')

async function main() {
  const Contract = await hre.ethers.getContractFactory('HelloWorld')
  const contract = await Contract.deploy()
  await contract.deployed()

  console.log(await contract.helloWorld())
}

main().catch((e) => {
  console.error(e)
  process.exit(1)
})
