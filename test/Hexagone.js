const { expect } = require("chai");

describe("Exam tests", async() => {

    let contract;
    beforeEach(async() => {
        const accounts = await ethers.getSigners();

        const Lock = await ethers.getContractFactory("Hexagone");
        contract = await Lock.deploy();
    })

    it("Squared numbers should return the squared number", async() => {
        let value = 3;
        let squared = await contract.squareOf(value);
        expect(squared).to.eq(Math.pow(3,2));
    })
})