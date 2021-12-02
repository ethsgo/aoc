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

    let result
    if (contract.interface.getFunction('main').inputs.length) {
      let input = ''
      try {
        input = fs.readFileSync(process.stdin.fd).toString()
      } catch {}

      result = await contract.callStatic.main(input)
    } else {
      result = await contract.callStatic.main()
    }

    console.log(result.toString())
  })

/**
 * https://hardhat.org/config/
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: '0.8.4',
  networks: {
    hardhat: {
      gas: 100000000000,
    },
  },
}
