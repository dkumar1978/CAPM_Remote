sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"managepo/ui/managepo/test/integration/pages/PurchaseOrderSetList",
	"managepo/ui/managepo/test/integration/pages/PurchaseOrderSetObjectPage",
	"managepo/ui/managepo/test/integration/pages/PurchaseItemsSetObjectPage"
], function (JourneyRunner, PurchaseOrderSetList, PurchaseOrderSetObjectPage, PurchaseItemsSetObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('managepo/ui/managepo') + '/test/flp.html#app-preview',
        pages: {
			onThePurchaseOrderSetList: PurchaseOrderSetList,
			onThePurchaseOrderSetObjectPage: PurchaseOrderSetObjectPage,
			onThePurchaseItemsSetObjectPage: PurchaseItemsSetObjectPage
        },
        async: true
    });

    return runner;
});

