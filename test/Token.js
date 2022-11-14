const { expect } = require('chai')
const { ethers } = require('hardhat')

describe('Token', ()=> {
    let token

    beforeEach(async() => {
        const Token = await ethers.getContractFactory('Token')
        token = await Token.deploy()
    })

    it('has correct name', async ()=> {
        //Fetch token from blockchain

        //Read token name
        const name = await token.name() 
        //Check that name is correct
        expect(name).to.equal("Pavel's Token")
    })
    it('has correct symbol', async ()=> {
        //Fetch token from blockchain

        //Read token symbol
        const symbol = await token.symbol() 
        //Check that symbol is correct
        expect(symbol).to.equal("PLT")
    })
})