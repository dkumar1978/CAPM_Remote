const cds = require('@sap/cds')

module.exports = class CatalogService extends cds.ApplicationService {
  init() {

    const { EmployeeSet, PurchaseOrderSet, BusinessPartnerSet, AddressSet, PurchaseItemsSet, ProductSet } = cds.entities('CatalogService')

    this.before(['CREATE', 'UPDATE'], EmployeeSet, async (req) => {
      console.log('Before CREATE/UPDATE EmployeeSet', req.data)
      // get the employee salary info
      let salaryAmount = parseFloat(req.data.salaryAmount);
      if (salaryAmount > 10000) {
        req.error(500, "Check the salary, no one gets more than $1000");
      }
    })
    this.after('READ', EmployeeSet, async (employeeSet, req) => {
      console.log('After READ EmployeeSet', employeeSet)
    })
    this.before(['CREATE', 'UPDATE'], PurchaseOrderSet, async (req) => {
      console.log('Before CREATE/UPDATE PurchaseOrderSet', req.data)
    })
    this.after('READ', PurchaseOrderSet, async (purchaseOrderSet, req) => {
      console.log('After READ PurchaseOrderSet', purchaseOrderSet)
      for (const po of purchaseOrderSet) {
        if (!po.NOTE) { }
        po.NOTE = 'Not Found'
      }
    })
    this.before(['CREATE', 'UPDATE'], BusinessPartnerSet, async (req) => {
      console.log('Before CREATE/UPDATE BusinessPartnerSet', req.data)
    })
    this.after('READ', BusinessPartnerSet, async (businessPartnerSet, req) => {
      console.log('After READ BusinessPartnerSet', businessPartnerSet)
    })
    this.before(['CREATE', 'UPDATE'], AddressSet, async (req) => {
      console.log('Before CREATE/UPDATE AddressSet', req.data)
    })
    this.after('READ', AddressSet, async (addressSet, req) => {
      console.log('After READ AddressSet', addressSet)
    })
    this.before(['CREATE', 'UPDATE'], PurchaseItemsSet, async (req) => {
      console.log('Before CREATE/UPDATE PurchaseItemsSet', req.data)
    })
    this.after('READ', PurchaseItemsSet, async (purchaseItemsSet, req) => {
      console.log('After READ PurchaseItemsSet', purchaseItemsSet)
    })
    this.before(['CREATE', 'UPDATE'], ProductSet, async (req) => {
      console.log('Before CREATE/UPDATE ProductSet', req.data)
    })
    this.after('READ', ProductSet, async (productSet, req) => {
      console.log('After READ ProductSet', productSet)
    })

    //Implementation for order defaults
    this.on('getDefaultValue', async (req) => {
      return {
        OVERALL_STATUS: 'N',
        LIFECYCLE_STATUS: 'N'
      }
    });

    // implementation of boost action
    this.on('boost', async (req) => {

      //debugger;

      try {
        const PRIMARYKEY = req.params[0];
        const tx = cds.tx(req);
        //CDS query language to update your gross amount
        await tx.update(PurchaseOrderSet).with({
          GROSS_AMOUNT: { '+=': 20000 },
          NOTE: "PO Boosted!!!"
        }).where(PRIMARYKEY);
        // read the record and send in out
        return await tx.read(PurchaseOrderSet).where(PRIMARYKEY);

      } catch (error) {
      }
    });

    //set new order status defaults
    this.on('setDefaultStatus', async (req, res) => {
      return {
        OVERALL_STATUS: 'N',
        LIFECYCLE_STATUS: 'N'
      }
    });

    return super.init()
  }
}
