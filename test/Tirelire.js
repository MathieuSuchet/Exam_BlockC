const { expect } = require("chai");

describe.only("Tirelire tests", async() => {

  let contract;
    beforeEach(async() => {
        const cf = await ethers.getContractFactory("Tirelire")
        contract = await cf.deploy();
        await contract.deployed();
        accounts = await ethers.getSigners()
    })


  it("Pay money", async() => {
      await contract.pay({value: 3});
      let balance = await contract.balances(accounts[0].address)
      expect(balance).to.eq(3);
  })

  it("Withdrawing money before 24 hours should withdraw 20% more", async() => {
    await contract.pay({value: 10});
    await contract.withdraw(8);

    let balance = await contract.balances(accounts[0].address);
    expect(balance).to.eq(1);
  });

  it("Withdrawing money without depositing any shouldn't be possible", async() => {
    await expect(contract.withdraw(5)).to.be.reverted;
  })
})