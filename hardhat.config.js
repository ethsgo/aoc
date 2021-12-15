require('@nomiclabs/hardhat-ethers')
const fs = require('fs')

// https://hardhat.org/guides/create-task.html
task('exec', 'Deploy and run the named contract')
  .addPositionalParam('name', 'Contract name')
  .addFlag('skipGasEstimate', 'Skip the gas estimate')
  .setAction(async (taskArgs, hre) => {
    await hre.run('compile', { quiet: true })

    const ethers = hre.ethers
    const Contract = await ethers.getContractFactory(taskArgs.name)
    const contract = await Contract.deploy()
    await contract.deployed()

    let result, gasEstimate, didEstimateGas
    if (contract.interface.getFunction('main').inputs.length) {
      let input = ''
      try {
        input = fs.readFileSync(process.stdin.fd).toString()
      } catch {
        if (!taskArgs.skipGasEstimate) {
          // Only estimate gas if we're running without stdin input, it
          // takes too long otherwise.
          gasEstimate = await contract.estimateGas.main(input)
          didEstimateGas = true
        }
      }

      result = await contract.callStatic.main(input)
    } else {
      if (!taskArgs.skipGasEstimate) {
        gasEstimate = await contract.estimateGas.main()
        didEstimateGas = true
      }
      result = await contract.callStatic.main()
    }

    if (didEstimateGas) {
      console.log(`[${gasEstimate.toString()}] ${result.toString()}`)
    } else {
      console.log(result.toString())
    }
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
