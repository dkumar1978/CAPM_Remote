using {
    mycapapp.db.master,
    mycapapp.db.transaction
} from '../db/datamodel';

service CatalogService @(path: 'CatalogService', requires : 'authenticated-user') {

    entity EmployeeSet  @(
        restrict : [
            { grant : ['READ'], to : 'Viewer', where : 'bankName = $user.bankName' },
            { grant : ['WRITE', 'DELETE'], to : 'Editor' },
        ])    
         as projection on master.employee;

            // @Capabilities: {Deletable: false}            
    entity PurchaseOrderSet @(
        restrict : [
            { grant : ['READ'], to : 'Viewer' },
            { grant : ['WRITE', 'DELETE'], to : 'Editor' },
        ],
        odata.draft.enabled         : true,
        Common.DefaultValuesFunction: 'setDefaultStatus'
    )                         as
        projection on transaction.purchaseorder {
            *,
            case
                OVERALL_STATUS
                when 'P'
                     then 'Pending'
                when 'A'
                     then 'Approved'
                when 'X'
                     then 'Rejected'
                when 'D'
                     then 'Delivered'
                else 'Unkown'
            end as OverallStatus    : String(10),

            case
                OVERALL_STATUS
                when 'P'
                     then 2
                when 'A'
                     then 3
                when 'X'
                     then 1
                when 'D'
                     then 3
                else 0
            end as OverallStatusCol : Integer,

            case
                LIFECYCLE_STATUS
                when 'N'
                     then 'New'
                else 'Pending'
            end as LifeCycleStatus  : String(10),

        }
        actions {
            @cds.odata.bindingparameter.name: '_boostGA'
            @Common.SideEffects             : {TargetProperties: ['_boostGA/GROSS_AMOUNT']}
            action boost() returns PurchaseOrderSet;
        };

    function setDefaultStatus() returns PurchaseOrderSet;

    entity PurchaseItemsSet   as projection on transaction.poitems;
    entity ProductSet         as projection on master.product;
    entity BusinessPartnerSet as projection on master.businesspartner;
    entity AddressSet         as projection on master.address;
    @readonly
    entity StatusCode         as projection on master.StatusCode;


}
