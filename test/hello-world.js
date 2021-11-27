const { expect } = require('chai')
const { ethers } = require('hardhat')

describe('HelloWorld', function () {
  it('Say hello', async () => {
    const HelloWorld = await ethers.getContractFactory('HelloWorld')
    const helloWorld = await HelloWorld.deploy()
    await helloWorld.deployed()

    expect(await helloWorld.helloWorld()).to.equal('Hello, World!')
  })
})
