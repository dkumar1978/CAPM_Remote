namespace views.cds;

using {
    mycapapp.db.master,
    mycapapp.db.transaction
} from './datamodel';

context CDSViews {
    define view ![POWorkList] as
        select from transaction.purchaseorder {
            key purchaseorder.PO_ID               as ![PurchaseOrderId],
            key Items.PO_ITEM_POS                 as ![POrderItemId],
                PARTNER_GUID.BP_ID                as ![PartnerBusinessPartnerId],
                PARTNER_GUID.COMPANY_NAME         as ![PartnerCompanyName],
                GROSS_AMOUNT                      as ![GrossAmount],
                NET_AMOUNT                        as ![NetAmount],
                TAX_AMOUNT                        as ![TaxAmount],
                CURRENCY                          as ![Currency],
                OVERALL_STATUS                    as ![OverallStatus],
                Items.PRODUCT_GUID.PRODUCT_ID     as ![ProductId],
                Items.PRODUCT_GUID.DESCRIPTION    as ![ProductDescription],
                PARTNER_GUID.ADDRESS_GUID.CITY    as ![PartnerCity],
                PARTNER_GUID.ADDRESS_GUID.COUNTRY as ![PartnerCountry]
        };

    define view ![ProductValueHelp] as
        select from master.product {
            @enduserText.label: [
                {
                    language: 'EN',
                    Text    : 'Product Id'
                },
                {
                    language: 'GE',
                    Text    : 'GE Product Id'
                },
                {
                    language: 'ES',
                    Text    : 'ES Product Id'
                }

            ] PRODUCT_ID as ![ProductId],
            @EndUserText.label: [
                {
                    language: 'EN',
                    Text    : 'Product Description'
                },
                {
                    language: 'GE',
                    Text    : 'GE Product Description'
                },
                {
                    language: 'ES',
                    Text    : 'ES Product Description'
                }
            ]
            DESCRIPTION  as ![Description]

        };


    define view ![ItemView] as
        select from transaction.poitems {
            key PARENT_KEY.PARTNER_GUID.NODE_KEY as ![CustomerId],
                PRODUCT_GUID.NODE_KEY            as ![ProductId],
                CURRENCY                         as ![CurrencyCode],
                GROSS_AMOUNT                     as ![GrossAmount],
                NET_AMOUNT                       as ![NetAmount],
                TAX_AMOUNT                       as ![TaxAmount],
                PARENT_KEY.OVERALL_STATUS        as ![OverallStatus]
        };

    define view ![ProductView] as
        select from master.product
        mixin {
            PO_ORDER : Association to many ItemView
                           on PO_ORDER.ProductId = $projection.ProductId
        }
        into {
            NODE_KEY                           as ![ProductId],
            DESCRIPTION                        as ![Description],
            CATEGORY                           as ![Category],
            PRICE                              as ![Price],
            SUPPLIER_GUID.BP_ID                as ![SupplierId],
            SUPPLIER_GUID.COMPANY_NAME         as ![CompanyName],
            SUPPLIER_GUID.ADDRESS_GUID.COUNTRY as ![Country],
            PO_ORDER                           as ![To_Items]
        };

    define view CProductValueView as
        select from ProductView {
            ProductId,
            Country,
            round(
                sum(To_Items.GrossAmount), 2
            )                     as ![TotalAmount],
            To_Items.CurrencyCode as ![CurrencyCode]
        }
        group by
            ProductId,
            Country,
            To_Items.CurrencyCode

}
