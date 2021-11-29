require('@nomiclabs/hardhat-ethers')
const fs = require('fs')

// https://hardhat.org/guides/create-task.html
task('solrun', 'Deploy and run the named contract')
  .addPositionalParam('name', 'Contract name')
  .setAction(async (taskArgs, hre) => {
    await hre.run('compile', { quiet: true })

    const ethers = hre.ethers
    const Contract = await ethers.getContractFactory(taskArgs.name)
    const contract = await Contract.deploy()
    await contract.deployed()

    let input = ''
    try {
      input = fs.readFileSync(process.stdin.fd).toString()
    } catch {}

    const result1 = await contract.callStatic.main(input)
    console.log(result1.toString())
  })

/**
 * https://hardhat.org/config/
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: '0.8.4',
}
