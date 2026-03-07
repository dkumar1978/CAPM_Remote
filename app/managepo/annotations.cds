using CatalogService as service from '../../srv/CatalogService';


/////// PURCHASE ORDER SET ANNOTATION ///////
annotate service.PurchaseOrderSet with @(
    UI.SelectionFields              : [
        PO_ID,
        PARTNER_GUID.COMPANY_NAME,
        PARTNER_GUID.ADDRESS_GUID.COUNTRY,
        GROSS_AMOUNT,
        OVERALL_STATUS

    ],

    UI.LineItem                     : [
        {
            $Type            : 'UI.DataField',
            Value            : PO_ID,
            ![@UI.Importance]: #High
        },
        // {
        //     $Type            : 'UI.DataField',
        //     Value            : NOTE,
        //     ![@UI.Importance]: #High
        // },
        {
            $Type            : 'UI.DataField',
            Value            : PARTNER_GUID.COMPANY_NAME,
            ![@UI.Importance]: #High
        },
        {
            $Type            : 'UI.DataField',
            Value            : PARTNER_GUID.ADDRESS_GUID.COUNTRY,
            ![@UI.Importance]: #High
        },
        {
            $Type: 'UI.DataField',
            Value: GROSS_AMOUNT,
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action: 'CatalogService.boost',
            Label : 'Boost',
            Inline: true,
        },
        {
            $Type            : 'UI.DataField',
            Value            : OVERALL_STATUS,
            ![@UI.Importance]: #High,
            Criticality      : OverallStatusCol,
        }

    ],

    UI.HeaderInfo                   : {
        //title on the first screen
        TypeName      : 'Pruchase Order',
        TypeNamePlural: 'Pruchase Orders',
        //title on the second screen
        Title         : {Value: PO_ID},
        Description   : {Value: PARTNER_GUID.COMPANY_NAME},
        ImageUrl      : 'https://www.shutterstock.com/image-vector/purchase-order-blue-background-260nw-1262289091.jpg'
    },

    UI.Facets                       : [
        {
            $Type : 'UI.CollectionFacet',
            Label : 'General Information',
            Facets: [
                {
                    $Type : 'UI.ReferenceFacet',
                    Target: '@UI.Identification',
                    Label : 'Basic Info',
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Target: '@UI.FieldGroup#PricingDetails',
                    Label : 'Pricing Details',
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Target: '@UI.FieldGroup#AdditionalDetails',
                    Label : 'Additional Details',
                },

            ],
        },

        {
            $Type : 'UI.ReferenceFacet',
            Target: 'Items/@UI.LineItem',
            Label : 'Items',
        },

    ],
    //identification block
    UI.Identification               : [
        {
            $Type: 'UI.DataField',
            Value: PO_ID,
        },
        {
            $Type: 'UI.DataField',
            Value: PARTNER_GUID_NODE_KEY,
        },
        {
            $Type: 'UI.DataField',
            Value: NOTE,
        },
    ],

    UI.FieldGroup #PricingDetails   : {
                                       // Label: 'Pricing Details',
                                      Data: [
        {
            $Type: 'UI.DataField',
            Value: GROSS_AMOUNT,
        },
        {
            $Type: 'UI.DataField',
            Value: NET_AMOUNT,
        },
        {
            $Type: 'UI.DataField',
            Value: TAX_AMOUNT,
        },
    ], },

    UI.FieldGroup #AdditionalDetails: {
                                       // Label: 'Additional Details',
                                      Data: [
        {
            $Type: 'UI.DataField',
            Value: CURRENCY_code,
        },
        {
            $Type: 'UI.DataField',
            Value: OVERALL_STATUS,
        },
        {
            $Type: 'UI.DataField',
            Value: LIFECYCLE_STATUS,
        },
    ], },


);

annotate service.PurchaseOrderSet with {
    @(
        Common.Text: OverallStatus,
        Common.ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'StatusCode',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : OVERALL_STATUS,
                    ValueListProperty : 'code',
                },
            ],
            Label : 'Status',
        },
        Common.ValueListWithFixedValues : true,
    )
    OVERALL_STATUS;
    @Common.Text: NOTE
    PO_ID;
    @Common.Text: PARTNER_GUID.COMPANY_NAME
    @Common     : {TextArrangement: #TextOnly}
    @ValueList.entity : service.BusinessPartnerSet
    PARTNER_GUID;
    @Common.Text: LifeCycleStatus
    LIFECYCLE_STATUS;
};


/////// PURCHASE ITEM SET ANNOTATION ///////
annotate service.PurchaseItemsSet with @(

    UI.HeaderInfo    : {
        TypeName      : 'PO Item',
        TypeNamePlural: 'Purchase Order Items',
        Title         : {Value: PO_ITEM_POS},
        Description   : {Value: PRODUCT_GUID.DESCRIPTION}
    },

    UI.LineItem      : [
        {
            $Type: 'UI.DataField',
            Value: PO_ITEM_POS,
        },
        {
            $Type: 'UI.DataField',
            Value: PRODUCT_GUID_NODE_KEY,
        },
        {
            $Type: 'UI.DataField',
            Value: GROSS_AMOUNT,
        },
        {
            $Type: 'UI.DataField',
            Value: NET_AMOUNT,
        },
        {
            $Type: 'UI.DataField',
            Value: TAX_AMOUNT,
        },
    ],
    UI.Facets        : [{
        $Type : 'UI.ReferenceFacet',
        Label : 'Item Details',
        Target: '@UI.Identification',
    }],
    UI.Identification: [
        {
            $Type: 'UI.DataField',
            Value: PO_ITEM_POS,
        },
        {
            $Type: 'UI.DataField',
            Value: PRODUCT_GUID_NODE_KEY,
        },
        {
            $Type: 'UI.DataField',
            Value: GROSS_AMOUNT,
        },
        {
            $Type: 'UI.DataField',
            Value: NET_AMOUNT,
        },
        {
            $Type: 'UI.DataField',
            Value: TAX_AMOUNT,
        },
        {
            $Type: 'UI.DataField',
            Value: CURRENCY_code,
        },
    ],
);

annotate service.PurchaseItemsSet with {
    @Common.Text: PRODUCT_GUID.DESCRIPTION
    @ValueList.entity : service.ProductSet
    PRODUCT_GUID;
};


// value help for partner and product guid
@cds.odata.valuelist
annotate service.BusinessPartnerSet with @(UI.Identification: [{
    $Type: 'UI.Datafield',
    Value: COMPANY_NAME,
}]);


@cds.odata.valuelist
annotate service.ProductSet with @(UI.Identification: [{
    $Type: 'UI.Datafield',
    Value: DESCRIPTION,
}]);
annotate service.StatusCode with {
    code @Common.Text : value
};

