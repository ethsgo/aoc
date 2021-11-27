require('@nomiclabs/hardhat-ethers')

// https://hardhat.org/guides/create-task.html
task('solrun', 'Deploy and run the named contract')
  .addPositionalParam('name', 'Contract name')
  .setAction(async (taskArgs, hre) => {
    await hre.run('compile', { quiet: true })

    const ethers = hre.ethers
    const Contract = await ethers.getContractFactory(taskArgs.name)
    const contract = await Contract.deploy()
    await contract.deployed()

    console.log((await contract.p1()).toString())
    if (Contract.interface.functions['p2()']) {
      console.log((await contract.p2()).toString())
    }
  })

/**
 * https://hardhat.org/config/
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: '0.8.4',
}
