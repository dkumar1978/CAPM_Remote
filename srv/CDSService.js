const cds = require('@sap/cds')
const { SELECT } = require('@sap/cds/lib/ql/cds-ql')

module.exports = class CDSService extends cds.ApplicationService {
  init() {

    const { ProductSet, ItemSet } = cds.entities('CDSService')

    this.before(['CREATE', 'UPDATE'], ProductSet, async (req) => {
      console.log('Before CREATE/UPDATE ProductSet', req.data)
    })
    this.after('READ', ProductSet, async (productSet, req) => {

      //step 1: get all the unique product ids
      let ids = productSet.map(p => p.ProductId)

      // CDS query language to go to items data and aggregate the count
      const orderCount = await SELECT.from(ItemSet)
        .columns('ProductId', { func: 'count', as: 'count' })
        .where({ 'ProductId': { in: ids } })
        .groupBy('ProductId');

      for (const [index] of productSet.entries()) {
        const element = productSet[index];
        const foundRecord = orderCount.find(pc => pc.ProductId === element.ProductId);
        element.soldCount = foundRecord ? foundRecord.count : 0;

      }


      //console.log('After READ ProductSet', productSet)
    })
    this.before(['CREATE', 'UPDATE'], ItemSet, async (req) => {
      console.log('Before CREATE/UPDATE ItemSet', req.data)
    })
    this.after('READ', ItemSet, async (itemSet, req) => {
      console.log('After READ ItemSet', itemSet)
    })


    return super.init()
  }
}
