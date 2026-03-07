namespace mycapapp.db.commons;

using {Currency} from '@sap/cds/common';

type Guid        : String(32);

type Gender      : String(1) enum {
    male = 'M';
    female = 'F';
    diverse = 'D';
};

type PhoneNumber : String(30) @assert.format: '/^[6-9]\d{9}$/';
type Email       : String(355); // @assert.format: '/^\\S+@\\S+\\.\\S+$/';
type AmounT      : Decimal(10, 2) @(Semantic.amount.currencyCode: 'CURRENCY_CODE');

aspect Amount {
    CURRENCY     : Currency @title: '{i18n>CURRENCY}';
    GROSS_AMOUNT : AmounT   @title: '{i18n>GROSS_AMOUNT}';
    NET_AMOUNT   : AmounT   @title: '{i18n>NET_AMOUNT}';
    TAX_AMOUNT   : AmounT   @title: '{i18n>TAX_AMOUNT}';
}
