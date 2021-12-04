require('@nomiclabs/hardhat-ethers')
const fs = require('fs')

// https://hardhat.org/guides/create-task.html
task('exec', 'Deploy and run the named contract')
  .addPositionalParam('name', 'Contract name')
  .setAction(async (taskArgs, hre) => {
    await hre.run('compile', { quiet: true })

    const ethers = hre.ethers
    const Contract = await ethers.getContractFactory(taskArgs.name)
    const contract = await Contract.deploy()
    await contract.deployed()

    let result, gasEstimate
    if (contract.interface.getFunction('main').inputs.length) {
      let input = ''
      try {
        input = fs.readFileSync(process.stdin.fd).toString()
      } catch {}

      gasEstimate = await contract.estimateGas.main(input)
      result = await contract.callStatic.main(input)
    } else {
      gasEstimate = await contract.estimateGas.main()
      result = await contract.callStatic.main()
    }

    console.log(`[${gasEstimate.toString()}] ${result.toString()}`)
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
