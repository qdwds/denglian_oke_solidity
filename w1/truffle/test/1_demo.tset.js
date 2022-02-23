const Demo = artifacts.require('Demo');

contract('name', _ => {
    it('test name value', async () => {
        const demo = await Demo.deployed();
        const name1 = await demo.name();
        assert.equal(name1,"hello world");
    })

    it('test name value', async () => {
        const demo = await Demo.deployed();
        await demo.setName("hello world !!");
        const name = await demo.name();
        assert.equal(name,"hello world !!");
    })
})


