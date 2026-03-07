const cds = require('@sap/cds')

module.exports = class MyService extends cds.ApplicationService { init() {



  this.on ('mysrv', async (req) => {
    console.log('On mysrv', req.data)
    let myName = req.data.name;
    return `Hello ${myName}, Welcome to CAP server!!`
  })

  return super.init()
}}
