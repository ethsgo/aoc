const hre = require('hardhat')

async function main() {
  const HelloWorld = await hre.ethers.getContractFactory('HelloWorld')
  const helloWorld = await HelloWorld.deploy()

  console.log(await helloWorld.helloWorld())
}

main()
  .then(() => process.exit(0))
  .catch((e) => {
    console.error(e)
    process.exit(1)
  })
