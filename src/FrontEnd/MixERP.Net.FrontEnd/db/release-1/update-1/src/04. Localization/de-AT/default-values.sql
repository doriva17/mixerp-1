﻿DO
$$
BEGIN
    IF(core.get_locale() = 'de-AT') THEN
        ALTER TABLE core.accounts
        ALTER column currency_code DROP NOT NULL;

        ALTER TABLE transactions.transaction_master DISABLE TRIGGER verification_update_trigger;
        ALTER TABLE transactions.transaction_master DISABLE TRIGGER verification_delete_trigger;
        ALTER TABLE transactions.transaction_details DISABLE TRIGGER restrict_delete_trigger;
        ALTER TABLE transactions.stock_master DISABLE TRIGGER restrict_delete_trigger;
        ALTER TABLE transactions.stock_details DISABLE TRIGGER restrict_delete_trigger;
        
        DELETE FROM transactions.customer_receipts;
        DELETE FROM transactions.transaction_details;
        DELETE FROM transactions.non_gl_stock_tax_details;
        DELETE FROM transactions.non_gl_stock_details;
        DELETE FROM transactions.non_gl_stock_master;
        DELETE FROM transactions.stock_tax_details;
        DELETE FROM transactions.stock_details;
        DELETE FROM transactions.stock_master;
        DELETE FROM transactions.stock_tax_details;
        DELETE FROM transactions.transaction_master;
        DELETE FROM core.flags;
        DELETE FROM audit.logins;

        ALTER TABLE transactions.transaction_master ENABLE TRIGGER verification_update_trigger;
        ALTER TABLE transactions.transaction_master ENABLE TRIGGER verification_delete_trigger;
        ALTER TABLE transactions.transaction_details ENABLE TRIGGER restrict_delete_trigger;
        ALTER TABLE transactions.stock_master ENABLE TRIGGER restrict_delete_trigger;
        ALTER TABLE transactions.stock_details ENABLE TRIGGER restrict_delete_trigger;
        
        DELETE FROM core.payment_terms;
        DELETE FROM core.late_fee;
        DELETE FROM office.cost_centers;
        DELETE FROM core.cash_flow_setup;
        DELETE FROM core.cash_flow_headings;
        DELETE FROM core.entities;
        DELETE FROM core.industries;
        DELETE FROM core.entities;
        DELETE FROM office.stores;
        DELETE FROM core.items;
        DELETE FROM core.item_groups;
        DELETE FROM core.brands;
        DELETE FROM core.item_types;
        DELETE FROM core.shipping_mail_types;
        DELETE FROM core.shipping_package_shapes;
        DELETE FROM core.shipping_package_shapes;
        DELETE FROM core.sales_tax_details;
        DELETE FROM core.sales_taxes;
        DELETE FROM core.county_sales_taxes;
        DELETE FROM core.state_sales_taxes;
        DELETE FROM core.tax_authorities;
        DELETE FROM core.tax_exempt_types;
        DELETE FROM core.tax_master;
        DELETE FROM core.sales_tax_types;
        DELETE FROM core.parties;
        DELETE FROM core.party_types;
        DELETE FROM core.salespersons;
        DELETE FROM core.shippers;
        DELETE FROM core.accounts;
        DELETE FROM core.account_masters;
        DELETE FROM office.cash_repositories;

        ALTER SEQUENCE transactions.customer_receipts_receipt_id_seq RESTART WITH 1;
        ALTER SEQUENCE transactions.transaction_details_transaction_detail_id_seq RESTART WITH 1;
        ALTER SEQUENCE transactions.non_gl_stock_details_non_gl_stock_detail_id_seq RESTART WITH 1;
        ALTER SEQUENCE transactions.non_gl_stock_master_non_gl_stock_master_id_seq RESTART WITH 1;
        ALTER SEQUENCE transactions.stock_details_stock_detail_id_seq RESTART WITH 1;
        ALTER SEQUENCE transactions.stock_master_stock_master_id_seq RESTART WITH 1;
        ALTER SEQUENCE transactions.transaction_master_transaction_master_id_seq RESTART WITH 1;
        ALTER SEQUENCE core.flags_flag_id_seq RESTART WITH 1;
        ALTER SEQUENCE audit.logins_login_id_seq RESTART WITH 1;
        
        ALTER SEQUENCE core.payment_terms_payment_term_id_seq RESTART WITH 1;
        ALTER SEQUENCE core.parties_party_id_seq RESTART WITH 1;
        ALTER SEQUENCE core.party_types_party_type_id_seq RESTART WITH 1;
        ALTER SEQUENCE core.salespersons_salesperson_id_seq RESTART WITH 1;
        ALTER SEQUENCE core.shippers_shipper_id_seq RESTART WITH 1;
        ALTER SEQUENCE core.accounts_account_id_seq RESTART WITH 1;
        ALTER SEQUENCE core.late_fee_late_fee_id_seq RESTART WITH 1;
        ALTER SEQUENCE office.cost_centers_cost_center_id_seq RESTART WITH 1;
        ALTER SEQUENCE core.cash_flow_setup_cash_flow_setup_id_seq RESTART WITH 1;
        ALTER SEQUENCE core.industries_industry_id_seq RESTART WITH 1;
        ALTER SEQUENCE core.brands_brand_id_seq RESTART WITH 1;
        ALTER SEQUENCE core.item_types_item_type_id_seq RESTART WITH 1;
        ALTER SEQUENCE core.sales_taxes_sales_tax_id_seq RESTART WITH 1;
        ALTER SEQUENCE core.sales_tax_details_sales_tax_detail_id_seq RESTART WITH 1;
        ALTER SEQUENCE office.stores_store_id_seq RESTART WITH 1;
        ALTER SEQUENCE core.items_item_id_seq RESTART WITH 1;
        ALTER SEQUENCE core.item_groups_item_group_id_seq RESTART WITH 1;
        ALTER SEQUENCE core.shipping_mail_types_shipping_mail_type_id_seq RESTART WITH 1;
        ALTER SEQUENCE core.shipping_package_shapes_shipping_package_shape_id_seq RESTART WITH 1;
        ALTER SEQUENCE core.county_sales_taxes_county_sales_tax_id_seq RESTART WITH 1;
        ALTER SEQUENCE core.state_sales_taxes_state_sales_tax_id_seq RESTART WITH 1;
        ALTER SEQUENCE core.tax_authorities_tax_authority_id_seq RESTART WITH 1;
        ALTER SEQUENCE core.tax_exempt_types_tax_exempt_type_id_seq RESTART WITH 1;
        ALTER SEQUENCE core.tax_master_tax_master_id_seq RESTART WITH 1;
        ALTER SEQUENCE core.sales_tax_types_sales_tax_type_id_seq RESTART WITH 1;
        ALTER SEQUENCE office.cash_repositories_cash_repository_id_seq RESTART WITH 1;

        --The meaning of the following should never change.
        UPDATE core.frequencies SET frequency_code = 'EOM', frequency_name = 'End of Month' WHERE frequency_id = 2;
        UPDATE core.frequencies SET frequency_code = 'EOQ', frequency_name = 'End of Quarter' WHERE frequency_id = 3;
        UPDATE core.frequencies SET frequency_code = 'EOH', frequency_name = 'End of Half' WHERE frequency_id = 4;
        UPDATE core.frequencies SET frequency_code = 'EOY', frequency_name = 'End of Year' WHERE frequency_id = 5;
        
        INSERT INTO core.account_masters(account_master_id, account_master_code, account_master_name)
        SELECT 1, 'BSA', 'Balance Sheet A/C' UNION ALL
        SELECT 2, 'PLA', 'Profit & Loss A/C' UNION ALL
        SELECT 3, 'OBS', 'Off Balance Sheet A/C';

        INSERT INTO core.account_masters(account_master_id, account_master_code, account_master_name, parent_account_master_id, normally_debit)
        SELECT 10100, 'CRA', 'Current Assets',                      1,      true    UNION ALL
        SELECT 10101, 'CAS', 'Cash A/C',                            10100,  true    UNION ALL
        SELECT 10102, 'CAB', 'Bank A/C',                            10100,  true    UNION ALL
        SELECT 10110, 'ACR', 'Accounts Receivable',                 10100,  true    UNION ALL
        SELECT 10200, 'FIA', 'Fixed Assets',                        1,      true    UNION ALL
        SELECT 10201, 'PPE', 'Property, Plants, and Equipments',    1,      true    UNION ALL
        SELECT 10300, 'OTA', 'Other Assets',                        1,      true    UNION ALL
        SELECT 15000, 'CRL', 'Current Liabilities',                 1,      false   UNION ALL
        SELECT 15010, 'ACP', 'Accounts Payable',                    15000,  false   UNION ALL
        SELECT 15011, 'SAP', 'Salary Payable',                      15000,  false   UNION ALL
        SELECT 15100, 'LTL', 'Long-Term Liabilities',               1,      false   UNION ALL
        SELECT 15200, 'SHE', 'Shareholders'' Equity',               1,      false   UNION ALL
        SELECT 15300, 'RET', 'Retained Earnings',                   15200,  false   UNION ALL
        SELECT 15400, 'DIP', 'Dividends Paid',                      15300,  false;


        INSERT INTO core.account_masters(account_master_id, account_master_code, account_master_name, parent_account_master_id, normally_debit)
        SELECT 20100, 'REV', 'Revenue',                           2,        false   UNION ALL
        SELECT 20200, 'NOI', 'Non Operating Income',              2,        false   UNION ALL
        SELECT 20300, 'FII', 'Financial Incomes',                 2,        false   UNION ALL
        SELECT 20301, 'DIR', 'Dividends Received',                20300,    false   UNION ALL
        SELECT 20400, 'COS', 'Cost of Sales',                     2,        true    UNION ALL
        SELECT 20500, 'DRC', 'Direct Costs',                      2,        true    UNION ALL
        SELECT 20600, 'ORX', 'Operating Expenses',                2,        true    UNION ALL
        SELECT 20700, 'FIX', 'Financial Expenses',                2,        true    UNION ALL
        SELECT 20701, 'INT', 'Interest Expenses',                 20700,    true    UNION ALL
        SELECT 20800, 'ITX', 'Income Tax Expenses',               2,        true;

        INSERT INTO core.cash_flow_headings(cash_flow_heading_id, cash_flow_heading_code, cash_flow_heading_name, cash_flow_heading_type, is_debit)
        SELECT 20001, 'CRC',    'Cash Receipts from Customers',                 'O',   true    UNION ALL
        SELECT 20002, 'CPS',    'Cash Paid to Suppliers',                       'O',   false   UNION ALL
        SELECT 20003, 'CPE',    'Cash Paid to Employees',                       'O',   false   UNION ALL
        SELECT 20004, 'IP',     'Interest Paid',                                'O',   false   UNION ALL
        SELECT 20005, 'ITP',    'Income Taxes Paid',                            'O',   false   UNION ALL
        SELECT 20006, 'SUS',    'Against Suspense Accounts',                    'O',   true   UNION ALL
        SELECT 30001, 'PSE',    'Proceeds from the Sale of Equipment',          'I',   true    UNION ALL
        SELECT 30002, 'DR',     'Dividends Received',                           'I',   true    UNION ALL
        SELECT 40001, 'DP',     'Dividends Paid',                               'F',   false;

        UPDATE core.cash_flow_headings SET is_sales=true WHERE cash_flow_heading_code='CRC';
        UPDATE core.cash_flow_headings SET is_purchase=true WHERE cash_flow_heading_code='CPS';

        INSERT INTO core.cash_flow_setup(cash_flow_heading_id, account_master_id)
        SELECT core.get_cash_flow_heading_id_by_cash_flow_heading_code('CRC'), core.get_account_master_id_by_account_master_code('ACR') UNION ALL --Cash Receipts from Customers/Accounts Receivable
        SELECT core.get_cash_flow_heading_id_by_cash_flow_heading_code('CPS'), core.get_account_master_id_by_account_master_code('ACP') UNION ALL --Cash Paid to Suppliers/Accounts Payable
        SELECT core.get_cash_flow_heading_id_by_cash_flow_heading_code('CPE'), core.get_account_master_id_by_account_master_code('SAP') UNION ALL --Cash Paid to Employees/Salary Payable
        SELECT core.get_cash_flow_heading_id_by_cash_flow_heading_code('IP'),  core.get_account_master_id_by_account_master_code('INT') UNION ALL --Interest Paid/Interest Expenses
        SELECT core.get_cash_flow_heading_id_by_cash_flow_heading_code('ITP'), core.get_account_master_id_by_account_master_code('ITX') UNION ALL --Income Taxes Paid/Income Tax Expenses
        SELECT core.get_cash_flow_heading_id_by_cash_flow_heading_code('PSE'), core.get_account_master_id_by_account_master_code('PPE') UNION ALL --Proceeds from the Sale of Equipment/Property, Plants, and Equipments
        SELECT core.get_cash_flow_heading_id_by_cash_flow_heading_code('DR'),  core.get_account_master_id_by_account_master_code('DIR') UNION ALL --Dividends Received/Dividends Received
        SELECT core.get_cash_flow_heading_id_by_cash_flow_heading_code('DP'),  core.get_account_master_id_by_account_master_code('DIP') UNION ALL --Dividends Paid/Dividends Paid

        --We cannot guarantee that every transactions posted is 100% correct and falls under the above-mentioned categories.
        --The following is the list of suspense accounts, cash entries posted directly against all other account masters.
        SELECT core.get_cash_flow_heading_id_by_cash_flow_heading_code('SUS'), core.get_account_master_id_by_account_master_code('BSA') UNION ALL --Against Suspense Accounts/Balance Sheet A/C
        SELECT core.get_cash_flow_heading_id_by_cash_flow_heading_code('SUS'), core.get_account_master_id_by_account_master_code('PLA') UNION ALL --Against Suspense Accounts/Profit & Loss A/C
        SELECT core.get_cash_flow_heading_id_by_cash_flow_heading_code('SUS'), core.get_account_master_id_by_account_master_code('CRA') UNION ALL --Against Suspense Accounts/Current Assets
        SELECT core.get_cash_flow_heading_id_by_cash_flow_heading_code('SUS'), core.get_account_master_id_by_account_master_code('FIA') UNION ALL --Against Suspense Accounts/Fixed Assets
        SELECT core.get_cash_flow_heading_id_by_cash_flow_heading_code('SUS'), core.get_account_master_id_by_account_master_code('OTA') UNION ALL --Against Suspense Accounts/Other Assets
        SELECT core.get_cash_flow_heading_id_by_cash_flow_heading_code('SUS'), core.get_account_master_id_by_account_master_code('CRL') UNION ALL --Against Suspense Accounts/Current Liabilities
        SELECT core.get_cash_flow_heading_id_by_cash_flow_heading_code('SUS'), core.get_account_master_id_by_account_master_code('LTL') UNION ALL --Against Suspense Accounts/Long-Term Liabilities
        SELECT core.get_cash_flow_heading_id_by_cash_flow_heading_code('SUS'), core.get_account_master_id_by_account_master_code('SHE') UNION ALL --Against Suspense Accounts/Shareholders' Equity
        SELECT core.get_cash_flow_heading_id_by_cash_flow_heading_code('SUS'), core.get_account_master_id_by_account_master_code('RET') UNION ALL --Against Suspense Accounts/Retained Earning
        SELECT core.get_cash_flow_heading_id_by_cash_flow_heading_code('SUS'), core.get_account_master_id_by_account_master_code('REV') UNION ALL --Against Suspense Accounts/Revenue
        SELECT core.get_cash_flow_heading_id_by_cash_flow_heading_code('SUS'), core.get_account_master_id_by_account_master_code('NOI') UNION ALL --Against Suspense Accounts/Non Operating Income
        SELECT core.get_cash_flow_heading_id_by_cash_flow_heading_code('SUS'), core.get_account_master_id_by_account_master_code('FII') UNION ALL --Against Suspense Accounts/Financial Incomes
        SELECT core.get_cash_flow_heading_id_by_cash_flow_heading_code('SUS'), core.get_account_master_id_by_account_master_code('COS') UNION ALL --Against Suspense Accounts/Cost of Sales
        SELECT core.get_cash_flow_heading_id_by_cash_flow_heading_code('SUS'), core.get_account_master_id_by_account_master_code('DRC') UNION ALL --Against Suspense Accounts/Direct Costs
        SELECT core.get_cash_flow_heading_id_by_cash_flow_heading_code('SUS'), core.get_account_master_id_by_account_master_code('ORX') UNION ALL --Against Suspense Accounts/Operating Expenses
        SELECT core.get_cash_flow_heading_id_by_cash_flow_heading_code('SUS'), core.get_account_master_id_by_account_master_code('FIX');          --Against Suspense Accounts/Financial Expenses


        INSERT INTO core.accounts(account_master_id,account_number,account_name, sys_type, parent_account_id) 
                  SELECT 1,     '10000', 'Assets',                                                      TRUE,  core.get_account_id_by_account_name('Balance Sheet A/C')
        UNION ALL SELECT 10100, '10001', 'Current Assets',                                              TRUE,  core.get_account_id_by_account_name('Assets')
        UNION ALL SELECT 10102, '10100', 'Cash at Bank A/C',                                            TRUE,  core.get_account_id_by_account_name('Current Assets')
        UNION ALL SELECT 10102, '10110', 'Regular Checking Account',                                    FALSE, core.get_account_id_by_account_name('Cash at Bank A/C')
        UNION ALL SELECT 10102, '10120', 'Payroll Checking Account',                                    FALSE, core.get_account_id_by_account_name('Cash at Bank A/C')
        UNION ALL SELECT 10102, '10130', 'Savings Account',                                             FALSE, core.get_account_id_by_account_name('Cash at Bank A/C')
        UNION ALL SELECT 10102, '10140', 'Special Account',                                             FALSE, core.get_account_id_by_account_name('Cash at Bank A/C')
        UNION ALL SELECT 10101, '10200', 'Cash in Hand A/C',                                            TRUE,  core.get_account_id_by_account_name('Current Assets')
        UNION ALL SELECT 10100, '10300', 'Investments',                                                 FALSE, core.get_account_id_by_account_name('Current Assets')
        UNION ALL SELECT 10100, '10310', 'Short Term Investment',                                       FALSE, core.get_account_id_by_account_name('Investments')
        UNION ALL SELECT 10100, '10320', 'Other Investments',                                           FALSE, core.get_account_id_by_account_name('Investments')
        UNION ALL SELECT 10100, '10321', 'Investments-Money Market',                                    FALSE, core.get_account_id_by_account_name('Other Investments')
        UNION ALL SELECT 10100, '10322', 'Bank Deposit Contract (Fixed Deposit)',                       FALSE, core.get_account_id_by_account_name('Other Investments')
        UNION ALL SELECT 10100, '10323', 'Investments-Certificates of Deposit',                         FALSE, core.get_account_id_by_account_name('Other Investments')
        UNION ALL SELECT 10110, '10400', 'Accounts Receivable',                                         FALSE, core.get_account_id_by_account_name('Current Assets')
        UNION ALL SELECT 10100, '10500', 'Other Receivables',                                           FALSE, core.get_account_id_by_account_name('Current Assets')
        UNION ALL SELECT 10100, '10501', 'Purchase Return (Receivables)',                               FALSE, core.get_account_id_by_account_name('Other Receivables')
        UNION ALL SELECT 10100, '10600', 'Allowance for Doubtful Accounts',                             FALSE, core.get_account_id_by_account_name('Current Assets')
        UNION ALL SELECT 10100, '10700', 'Inventory',                                                   TRUE,  core.get_account_id_by_account_name('Current Assets')
        UNION ALL SELECT 10100, '10720', 'Raw Materials Inventory',                                     TRUE,  core.get_account_id_by_account_name('Inventory')
        UNION ALL SELECT 10100, '10730', 'Supplies Inventory',                                          TRUE,  core.get_account_id_by_account_name('Inventory')
        UNION ALL SELECT 10100, '10740', 'Work in Progress Inventory',                                  TRUE,  core.get_account_id_by_account_name('Inventory')
        UNION ALL SELECT 10100, '10750', 'Finished Goods Inventory',                                    TRUE,  core.get_account_id_by_account_name('Inventory')
        UNION ALL SELECT 10100, '10800', 'Prepaid Expenses',                                            FALSE, core.get_account_id_by_account_name('Current Assets')
        UNION ALL SELECT 10100, '10900', 'Employee Advances',                                           FALSE, core.get_account_id_by_account_name('Current Assets')
        UNION ALL SELECT 10100, '11000', 'Notes Receivable-Current',                                    FALSE, core.get_account_id_by_account_name('Current Assets')
        UNION ALL SELECT 10100, '11100', 'Prepaid Interest',                                            FALSE, core.get_account_id_by_account_name('Current Assets')
        UNION ALL SELECT 10100, '11200', 'Accrued Incomes (Assets)',                                    FALSE, core.get_account_id_by_account_name('Current Assets')
        UNION ALL SELECT 10100, '11300', 'Other Debtors',                                               FALSE, core.get_account_id_by_account_name('Current Assets')
        UNION ALL SELECT 10100, '11400', 'Other Current Assets',                                        FALSE, core.get_account_id_by_account_name('Current Assets')
        UNION ALL SELECT 10200, '12001', 'Noncurrent Assets',                                           TRUE,  core.get_account_id_by_account_name('Assets')
        UNION ALL SELECT 10200, '12100', 'Furniture and Fixtures',                                      FALSE, core.get_account_id_by_account_name('Noncurrent Assets')
        UNION ALL SELECT 10201, '12200', 'Plants & Equipments',                                         FALSE, core.get_account_id_by_account_name('Noncurrent Assets')
        UNION ALL SELECT 10200, '12300', 'Rental Property',                                             FALSE, core.get_account_id_by_account_name('Noncurrent Assets')
        UNION ALL SELECT 10200, '12400', 'Vehicles',                                                    FALSE, core.get_account_id_by_account_name('Noncurrent Assets')
        UNION ALL SELECT 10200, '12500', 'Intangibles',                                                 FALSE, core.get_account_id_by_account_name('Noncurrent Assets')
        UNION ALL SELECT 10200, '12600', 'Other Depreciable Properties',                                FALSE, core.get_account_id_by_account_name('Noncurrent Assets')
        UNION ALL SELECT 10200, '12700', 'Leasehold Improvements',                                      FALSE, core.get_account_id_by_account_name('Noncurrent Assets')
        UNION ALL SELECT 10200, '12800', 'Buildings',                                                   FALSE, core.get_account_id_by_account_name('Noncurrent Assets')
        UNION ALL SELECT 10200, '12900', 'Building Improvements',                                       FALSE, core.get_account_id_by_account_name('Noncurrent Assets')
        UNION ALL SELECT 10200, '13000', 'Interior Decorations',                                        FALSE, core.get_account_id_by_account_name('Noncurrent Assets')
        UNION ALL SELECT 10200, '13100', 'Land',                                                        FALSE, core.get_account_id_by_account_name('Noncurrent Assets')
        UNION ALL SELECT 10200, '13200', 'Long Term Investments',                                       FALSE, core.get_account_id_by_account_name('Noncurrent Assets')
        UNION ALL SELECT 10200, '13300', 'Trade Debtors',                                               FALSE, core.get_account_id_by_account_name('Noncurrent Assets')
        UNION ALL SELECT 10200, '13400', 'Rental Debtors',                                              FALSE, core.get_account_id_by_account_name('Noncurrent Assets')
        UNION ALL SELECT 10200, '13500', 'Staff Debtors',                                               FALSE, core.get_account_id_by_account_name('Noncurrent Assets')
        UNION ALL SELECT 10200, '13600', 'Other Noncurrent Debtors',                                    FALSE, core.get_account_id_by_account_name('Noncurrent Assets')
        UNION ALL SELECT 10200, '13700', 'Other Financial Assets',                                      FALSE, core.get_account_id_by_account_name('Noncurrent Assets')
        UNION ALL SELECT 10200, '13710', 'Deposits Held',                                               FALSE, core.get_account_id_by_account_name('Other Financial Assets')
        UNION ALL SELECT 10200, '13800', 'Accumulated Depreciations',                                   FALSE, core.get_account_id_by_account_name('Noncurrent Assets')
        UNION ALL SELECT 10200, '13810', 'Accumulated Depreciation-Furniture and Fixtures',             FALSE, core.get_account_id_by_account_name('Accumulated Depreciations')
        UNION ALL SELECT 10200, '13820', 'Accumulated Depreciation-Equipment',                          FALSE, core.get_account_id_by_account_name('Accumulated Depreciations')
        UNION ALL SELECT 10200, '13830', 'Accumulated Depreciation-Vehicles',                           FALSE, core.get_account_id_by_account_name('Accumulated Depreciations')
        UNION ALL SELECT 10200, '13840', 'Accumulated Depreciation-Other Depreciable Properties',       FALSE, core.get_account_id_by_account_name('Accumulated Depreciations')
        UNION ALL SELECT 10200, '13850', 'Accumulated Depreciation-Leasehold',                          FALSE, core.get_account_id_by_account_name('Accumulated Depreciations')
        UNION ALL SELECT 10200, '13860', 'Accumulated Depreciation-Buildings',                          FALSE, core.get_account_id_by_account_name('Accumulated Depreciations')
        UNION ALL SELECT 10200, '13870', 'Accumulated Depreciation-Building Improvements',              FALSE, core.get_account_id_by_account_name('Accumulated Depreciations')
        UNION ALL SELECT 10200, '13880', 'Accumulated Depreciation-Interior Decorations',               FALSE, core.get_account_id_by_account_name('Accumulated Depreciations')
        UNION ALL SELECT 10300, '14001', 'Other Assets',                                                TRUE,  core.get_account_id_by_account_name('Assets')
        UNION ALL SELECT 10300, '14100', 'Other Assets-Deposits',                                       FALSE, core.get_account_id_by_account_name('Other Assets')
        UNION ALL SELECT 10300, '14200', 'Other Assets-Organization Costs',                             FALSE, core.get_account_id_by_account_name('Other Assets')
        UNION ALL SELECT 10300, '14300', 'Other Assets-Accumulated Amortization-Organization Costs',    FALSE, core.get_account_id_by_account_name('Other Assets')
        UNION ALL SELECT 10300, '14400', 'Notes Receivable-Non-current',                                FALSE, core.get_account_id_by_account_name('Other Assets')
        UNION ALL SELECT 10300, '14500', 'Other Non-current Assets',                                    FALSE, core.get_account_id_by_account_name('Other Assets')
        UNION ALL SELECT 10300, '14600', 'Non-financial Assets',                                        FALSE, core.get_account_id_by_account_name('Other Assets')
        UNION ALL SELECT 1,     '20000', 'Liabilities',                                                 TRUE,  core.get_account_id_by_account_name('Balance Sheet A/C')
        UNION ALL SELECT 15000, '20001', 'Current Liabilities',                                         TRUE,  core.get_account_id_by_account_name('Liabilities')
        UNION ALL SELECT 15010, '20100', 'Accounts Payable',                                            FALSE, core.get_account_id_by_account_name('Current Liabilities')
        UNION ALL SELECT 15000, '20110', 'Shipping Charge Payable',                                     FALSE, core.get_account_id_by_account_name('Current Liabilities')
        UNION ALL SELECT 15000, '20200', 'Accrued Expenses',                                            FALSE, core.get_account_id_by_account_name('Current Liabilities')
        UNION ALL SELECT 15000, '20300', 'Wages Payable',                                               FALSE, core.get_account_id_by_account_name('Current Liabilities')
        UNION ALL SELECT 15000, '20400', 'Deductions Payable',                                          FALSE, core.get_account_id_by_account_name('Current Liabilities')
        UNION ALL SELECT 15000, '20500', 'Health Insurance Payable',                                    FALSE, core.get_account_id_by_account_name('Current Liabilities')
        UNION ALL SELECT 15000, '20600', 'Superannuation Payable',                                      FALSE, core.get_account_id_by_account_name('Current Liabilities')
        UNION ALL SELECT 15000, '20700', 'Tax Payables',                                                FALSE, core.get_account_id_by_account_name('Current Liabilities')
        UNION ALL SELECT 15000, '20701', 'Sales Return (Payables)',                                     FALSE, core.get_account_id_by_account_name('Current Liabilities')
        UNION ALL SELECT 15000, '20710', 'Sales Tax Payable',                                           FALSE, core.get_account_id_by_account_name('Tax Payables')
        UNION ALL SELECT 15000, '20720', 'Federal Payroll Taxes Payable',                               FALSE, core.get_account_id_by_account_name('Tax Payables')
        UNION ALL SELECT 15000, '20730', 'FUTA Tax Payable',                                            FALSE, core.get_account_id_by_account_name('Tax Payables')
        UNION ALL SELECT 15000, '20740', 'State Payroll Taxes Payable',                                 FALSE, core.get_account_id_by_account_name('Tax Payables')
        UNION ALL SELECT 15000, '20750', 'SUTA Payable',                                                FALSE, core.get_account_id_by_account_name('Tax Payables')
        UNION ALL SELECT 15000, '20760', 'Local Payroll Taxes Payable',                                 FALSE, core.get_account_id_by_account_name('Tax Payables')
        UNION ALL SELECT 15000, '20770', 'Income Taxes Payable',                                        FALSE, core.get_account_id_by_account_name('Tax Payables')
        UNION ALL SELECT 15000, '20780', 'Other Taxes Payable',                                         FALSE, core.get_account_id_by_account_name('Tax Payables')
        UNION ALL SELECT 15000, '20800', 'Employee Benefits Payable',                                   FALSE, core.get_account_id_by_account_name('Current Liabilities')
        UNION ALL SELECT 15000, '20810', 'Provision for Annual Leave',                                  FALSE, core.get_account_id_by_account_name('Employee Benefits Payable')
        UNION ALL SELECT 15000, '20820', 'Provision for Long Service Leave',                            FALSE, core.get_account_id_by_account_name('Employee Benefits Payable')
        UNION ALL SELECT 15000, '20830', 'Provision for Personal Leave',                                FALSE, core.get_account_id_by_account_name('Employee Benefits Payable')
        UNION ALL SELECT 15000, '20840', 'Provision for Health Leave',                                  FALSE, core.get_account_id_by_account_name('Employee Benefits Payable')
        UNION ALL SELECT 15000, '20900', 'Current Portion of Long-term Debt',                           FALSE, core.get_account_id_by_account_name('Current Liabilities')
        UNION ALL SELECT 15000, '21000', 'Advance Incomes',                                             FALSE, core.get_account_id_by_account_name('Current Liabilities')
        UNION ALL SELECT 15000, '21010', 'Advance Sales Income',                                        FALSE, core.get_account_id_by_account_name('Advance Incomes')
        UNION ALL SELECT 15000, '21020', 'Grant Received in Advance',                                   FALSE, core.get_account_id_by_account_name('Advance Incomes')
        UNION ALL SELECT 15000, '21100', 'Deposits from Customers',                                     FALSE, core.get_account_id_by_account_name('Current Liabilities')
        UNION ALL SELECT 15000, '21200', 'Other Current Liabilities',                                   FALSE, core.get_account_id_by_account_name('Current Liabilities')
        UNION ALL SELECT 15000, '21210', 'Short Term Loan Payables',                                    FALSE, core.get_account_id_by_account_name('Other Current Liabilities')
        UNION ALL SELECT 15000, '21220', 'Short Term Hire-purchase Payables',                           FALSE, core.get_account_id_by_account_name('Other Current Liabilities')
        UNION ALL SELECT 15000, '21230', 'Short Term Lease Liability',                                  FALSE, core.get_account_id_by_account_name('Other Current Liabilities')
        UNION ALL SELECT 15000, '21240', 'Grants Repayable',                                            FALSE, core.get_account_id_by_account_name('Other Current Liabilities')
        UNION ALL SELECT 15100, '24001', 'Noncurrent Liabilities',                                      TRUE,  core.get_account_id_by_account_name('Liabilities')
        UNION ALL SELECT 15100, '24100', 'Notes Payable',                                               FALSE, core.get_account_id_by_account_name('Noncurrent Liabilities')
        UNION ALL SELECT 15100, '24200', 'Land Payable',                                                FALSE, core.get_account_id_by_account_name('Noncurrent Liabilities')
        UNION ALL SELECT 15100, '24300', 'Equipment Payable',                                           FALSE, core.get_account_id_by_account_name('Noncurrent Liabilities')
        UNION ALL SELECT 15100, '24400', 'Vehicles Payable',                                            FALSE, core.get_account_id_by_account_name('Noncurrent Liabilities')
        UNION ALL SELECT 15100, '24500', 'Lease Liability',                                             FALSE, core.get_account_id_by_account_name('Noncurrent Liabilities')
        UNION ALL SELECT 15100, '24600', 'Loan Payable',                                                FALSE, core.get_account_id_by_account_name('Noncurrent Liabilities')
        UNION ALL SELECT 15100, '24700', 'Hire-purchase Payable',                                       FALSE, core.get_account_id_by_account_name('Noncurrent Liabilities')
        UNION ALL SELECT 15100, '24800', 'Bank Loans Payable',                                          FALSE, core.get_account_id_by_account_name('Noncurrent Liabilities')
        UNION ALL SELECT 15100, '24900', 'Deferred Revenue',                                            FALSE, core.get_account_id_by_account_name('Noncurrent Liabilities')
        UNION ALL SELECT 15100, '25000', 'Other Long-term Liabilities',                                 FALSE, core.get_account_id_by_account_name('Noncurrent Liabilities')
        UNION ALL SELECT 15100, '25010', 'Long Term Employee Benefit Provision',                        FALSE, core.get_account_id_by_account_name('Other Long-term Liabilities')
        UNION ALL SELECT 15200, '28001', 'Equity',                                                      TRUE,  core.get_account_id_by_account_name('Liabilities')
        UNION ALL SELECT 15200, '28100', 'Stated Capital',                                              FALSE, core.get_account_id_by_account_name('Equity')
        UNION ALL SELECT 15200, '28110', 'Founder Capital',                                             FALSE, core.get_account_id_by_account_name('Stated Capital')
        UNION ALL SELECT 15200, '28120', 'Promoter Capital',                                            FALSE, core.get_account_id_by_account_name('Stated Capital')
        UNION ALL SELECT 15200, '28130', 'Member Capital',                                              FALSE, core.get_account_id_by_account_name('Stated Capital')
        UNION ALL SELECT 15200, '28200', 'Capital Surplus',                                             FALSE, core.get_account_id_by_account_name('Equity')
        UNION ALL SELECT 15200, '28210', 'Share Premium',                                               FALSE, core.get_account_id_by_account_name('Capital Surplus')
        UNION ALL SELECT 15200, '28220', 'Capital Redemption Reserves',                                 FALSE, core.get_account_id_by_account_name('Capital Surplus')
        UNION ALL SELECT 15200, '28230', 'Statutory Reserves',                                          FALSE, core.get_account_id_by_account_name('Capital Surplus')
        UNION ALL SELECT 15200, '28240', 'Asset Revaluation Reserves',                                  FALSE, core.get_account_id_by_account_name('Capital Surplus')
        UNION ALL SELECT 15200, '28250', 'Exchange Rate Fluctuation Reserves',                          FALSE, core.get_account_id_by_account_name('Capital Surplus')
        UNION ALL SELECT 15200, '28260', 'Capital Reserves Arising From Merger',                        FALSE, core.get_account_id_by_account_name('Capital Surplus')
        UNION ALL SELECT 15200, '28270', 'Capital Reserves Arising From Acuisition',                    FALSE, core.get_account_id_by_account_name('Capital Surplus')
        UNION ALL SELECT 15300, '28300', 'Retained Surplus',                                            TRUE,  core.get_account_id_by_account_name('Equity')
        UNION ALL SELECT 15300, '28310', 'Accumulated Profits',                                         FALSE, core.get_account_id_by_account_name('Retained Surplus')
        UNION ALL SELECT 15300, '28320', 'Accumulated Losses',                                          FALSE, core.get_account_id_by_account_name('Retained Surplus')
        UNION ALL SELECT 15400, '28330', 'Dividends Declared (Common Stock)',                           FALSE, core.get_account_id_by_account_name('Retained Surplus')
        UNION ALL SELECT 15400, '28340', 'Dividends Declared (Preferred Stock)',                        FALSE, core.get_account_id_by_account_name('Retained Surplus')
        UNION ALL SELECT 15200, '28400', 'Treasury Stock',                                              FALSE, core.get_account_id_by_account_name('Equity')
        UNION ALL SELECT 15200, '28500', 'Current Year Surplus',                                        FALSE, core.get_account_id_by_account_name('Equity')
        UNION ALL SELECT 15200, '28600', 'General Reserves',                                            FALSE, core.get_account_id_by_account_name('Equity')
        UNION ALL SELECT 15200, '28700', 'Other Reserves',                                              FALSE, core.get_account_id_by_account_name('Equity')
        UNION ALL SELECT 15200, '28800', 'Dividends Payable (Common Stock)',                            FALSE, core.get_account_id_by_account_name('Equity')
        UNION ALL SELECT 15200, '28900', 'Dividends Payable (Preferred Stock)',                         FALSE, core.get_account_id_by_account_name('Equity')
        UNION ALL SELECT 2,     '30000', 'Revenues',                                                    TRUE,  core.get_account_id_by_account_name('Profit and Loss A/C')
        UNION ALL SELECT 20100,  '30100', 'Sales A/C',                                                  FALSE, core.get_account_id_by_account_name('Revenues')
        UNION ALL SELECT 20100,  '30200', 'Interest Income',                                            FALSE, core.get_account_id_by_account_name('Revenues')
        UNION ALL SELECT 20100,  '30300', 'Other Income',                                               FALSE, core.get_account_id_by_account_name('Revenues')
        UNION ALL SELECT 20100,  '30400', 'Finance Charge Income',                                      FALSE, core.get_account_id_by_account_name('Revenues')
        UNION ALL SELECT 20100,  '30500', 'Shipping Charges Reimbursed',                                FALSE, core.get_account_id_by_account_name('Revenues')
        UNION ALL SELECT 20100,  '30600', 'Sales Returns and Allowances',                               FALSE, core.get_account_id_by_account_name('Revenues')
        UNION ALL SELECT 20100,  '30700', 'Purchase Discounts',                                         FALSE, core.get_account_id_by_account_name('Revenues')
        UNION ALL SELECT 2,     '40000', 'Expenses',                                                    TRUE,  core.get_account_id_by_account_name('Profit and Loss A/C')
        UNION ALL SELECT 2,     '40100', 'Purchase A/C',                                                FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20400,  '40200', 'Cost of Goods Sold',                                         FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20500,  '40205', 'Product Cost',                                               FALSE, core.get_account_id_by_account_name('Cost of Goods Sold')
        UNION ALL SELECT 20500,  '40210', 'Raw Material Purchases',                                     FALSE, core.get_account_id_by_account_name('Cost of Goods Sold')
        UNION ALL SELECT 20500,  '40215', 'Direct Labor Costs',                                         FALSE, core.get_account_id_by_account_name('Cost of Goods Sold')
        UNION ALL SELECT 20500,  '40220', 'Indirect Labor Costs',                                       FALSE, core.get_account_id_by_account_name('Cost of Goods Sold')
        UNION ALL SELECT 20500,  '40225', 'Heat and Power',                                             FALSE, core.get_account_id_by_account_name('Cost of Goods Sold')
        UNION ALL SELECT 20500,  '40230', 'Commissions',                                                FALSE, core.get_account_id_by_account_name('Cost of Goods Sold')
        UNION ALL SELECT 20500,  '40235', 'Miscellaneous Factory Costs',                                FALSE, core.get_account_id_by_account_name('Cost of Goods Sold')
        UNION ALL SELECT 20500,  '40240', 'Cost of Goods Sold-Salaries and Wages',                      FALSE, core.get_account_id_by_account_name('Cost of Goods Sold')
        UNION ALL SELECT 20500,  '40245', 'Cost of Goods Sold-Contract Labor',                          FALSE, core.get_account_id_by_account_name('Cost of Goods Sold')
        UNION ALL SELECT 20500,  '40250', 'Cost of Goods Sold-Freight',                                 FALSE, core.get_account_id_by_account_name('Cost of Goods Sold')
        UNION ALL SELECT 20500,  '40255', 'Cost of Goods Sold-Other',                                   FALSE, core.get_account_id_by_account_name('Cost of Goods Sold')
        UNION ALL SELECT 20500,  '40260', 'Inventory Adjustments',                                      FALSE, core.get_account_id_by_account_name('Cost of Goods Sold')
        UNION ALL SELECT 20500,  '40265', 'Purchase Returns and Allowances',                            FALSE, core.get_account_id_by_account_name('Cost of Goods Sold')
        UNION ALL SELECT 20500,  '40270', 'Sales Discounts',                                            FALSE, core.get_account_id_by_account_name('Cost of Goods Sold')
        UNION ALL SELECT 20600,  '40300', 'General Purchase Expenses',                                  FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20600,  '40400', 'Advertising Expenses',                                       FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20600,  '40500', 'Amortization Expenses',                                      FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20600,  '40600', 'Auto Expenses',                                              FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20600,  '40700', 'Bad Debt Expenses',                                          FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20700,  '40800', 'Bank Fees',                                                  FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20600,  '40900', 'Cash Over and Short',                                        FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20600,  '41000', 'Charitable Contributions Expenses',                          FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20700,  '41100', 'Commissions and Fees Expenses',                              FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20600,  '41200', 'Depreciation Expenses',                                      FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20600,  '41300', 'Dues and Subscriptions Expenses',                            FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20600,  '41400', 'Employee Benefit Expenses',                                  FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20600,  '41410', 'Employee Benefit Expenses-Health Insurance',                 FALSE, core.get_account_id_by_account_name('Employee Benefit Expenses')
        UNION ALL SELECT 20600,  '41420', 'Employee Benefit Expenses-Pension Plans',                    FALSE, core.get_account_id_by_account_name('Employee Benefit Expenses')
        UNION ALL SELECT 20600,  '41430', 'Employee Benefit Expenses-Profit Sharing Plan',              FALSE, core.get_account_id_by_account_name('Employee Benefit Expenses')
        UNION ALL SELECT 20600,  '41440', 'Employee Benefit Expenses-Other',                            FALSE, core.get_account_id_by_account_name('Employee Benefit Expenses')
        UNION ALL SELECT 20600,  '41500', 'Freight Expenses',                                           FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20600,  '41600', 'Gifts Expenses',                                             FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20800,  '41700', 'Income Tax Expenses',                                        FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20800,  '41710', 'Income Tax Expenses-Federal',                                FALSE, core.get_account_id_by_account_name('Income Tax Expenses')
        UNION ALL SELECT 20800,  '41720', 'Income Tax Expenses-State',                                  FALSE, core.get_account_id_by_account_name('Income Tax Expenses')
        UNION ALL SELECT 20800,  '41730', 'Income Tax Expenses-Local',                                  FALSE, core.get_account_id_by_account_name('Income Tax Expenses')
        UNION ALL SELECT 20600,  '41800', 'Insurance Expenses',                                         FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20600,  '41810', 'Insurance Expenses-Product Liability',                       FALSE, core.get_account_id_by_account_name('Insurance Expenses')
        UNION ALL SELECT 20600,  '41820', 'Insurance Expenses-Vehicle',                                 FALSE, core.get_account_id_by_account_name('Insurance Expenses')
        UNION ALL SELECT 20701,  '41900', 'Interest Expenses',                                          FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20600,  '42000', 'Laundry and Dry Cleaning Expenses',                          FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20600,  '42100', 'Legal and Professional Expenses',                            FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20600,  '42200', 'Licenses Expenses',                                          FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20600,  '42300', 'Loss on NSF Checks',                                         FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20600,  '42400', 'Maintenance Expenses',                                       FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20600,  '42500', 'Meals and Entertainment Expenses',                           FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20600,  '42600', 'Office Expenses',                                            FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20600,  '42700', 'Payroll Tax Expenses',                                       FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20700,  '42800', 'Penalties and Fines Expenses',                               FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20600,  '42900', 'Other Taxe Expenses',                                        FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20600,  '43000', 'Postage Expenses',                                           FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20600,  '43100', 'Rent or Lease Expenses',                                     FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20600,  '43200', 'Repair and Maintenance Expenses',                            FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20600,  '43210', 'Repair and Maintenance Expenses-Office',                     FALSE, core.get_account_id_by_account_name('Repair and Maintenance Expenses')
        UNION ALL SELECT 20600,  '43220', 'Repair and Maintenance Expenses-Vehicle',                    FALSE, core.get_account_id_by_account_name('Repair and Maintenance Expenses')
        UNION ALL SELECT 20600,  '43300', 'Supplies Expenses-Office',                                   FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20600,  '43400', 'Telephone Expenses',                                         FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20600,  '43500', 'Training Expenses',                                          FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20600,  '43600', 'Travel Expenses',                                            FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20600,  '43700', 'Salary Expenses',                                            FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20600,  '43800', 'Wages Expenses',                                             FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20600,  '43900', 'Utilities Expenses',                                         FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20600,  '44000', 'Other Expenses',                                             FALSE, core.get_account_id_by_account_name('Expenses')
        UNION ALL SELECT 20600,  '44100', 'Gain/Loss on Sale of Assets',                                FALSE, core.get_account_id_by_account_name('Expenses');


        UPDATE core.accounts
        SET currency_code='USD';


        ALTER TABLE core.accounts
        ALTER column currency_code SET NOT NULL;

        INSERT INTO office.cost_centers(cost_center_code, cost_center_name)
        SELECT 'DEF', 'Default'                             UNION ALL
        SELECT 'GEN', 'General Administration'              UNION ALL
        SELECT 'HUM', 'Human Resources'                     UNION ALL
        SELECT 'SCC', 'Support & Customer Care'             UNION ALL
        SELECT 'GAE', 'Guest Accomodation & Entertainment'  UNION ALL
        SELECT 'MKT', 'Marketing & Promotion'               UNION ALL
        SELECT 'SAL', 'Sales & Billing'                     UNION ALL
        SELECT 'FIN', 'Finance & Accounting';

        INSERT INTO core.entities(entity_name)
        SELECT 'Federal Government'                         UNION
        SELECT 'Sole Proprietorship'                        UNION
        SELECT 'General Partnership'                        UNION
        SELECT 'Limited Partnership'                        UNION
        SELECT 'Limited Liability Partnership'              UNION
        SELECT 'Limited Liability Limited Partnership'      UNION
        SELECT 'Limited Liability Company'                  UNION
        SELECT 'Professional Limited Liability Company'     UNION
        SELECT 'Benefit Corporation'                        UNION
        SELECT 'C Corporation'                              UNION
        SELECT 'Series Limited Liability Company'           UNION
        SELECT 'S Corporation'                              UNION
        SELECT 'Delaware Corporation'                       UNION
        SELECT 'Delaware Statutory Trust'                   UNION
        SELECT 'Massachusetts Business Trust'               UNION
        SELECT 'Nevada Corporation';

        INSERT INTO core.industries(industry_name)
        SELECT 'Accounting'                                 UNION
        SELECT 'Advertising'                                UNION
        SELECT 'Aerospace'                                  UNION
        SELECT 'Aircraft'                                   UNION
        SELECT 'Airline'                                    UNION
        SELECT 'Apparel & Accessories'                      UNION
        SELECT 'Automotive'                                 UNION
        SELECT 'Banking'                                    UNION
        SELECT 'Broadcasting'                               UNION
        SELECT 'Brokerage'                                  UNION
        SELECT 'Biotechnology'                              UNION
        SELECT 'Call Centers'                               UNION
        SELECT 'Cargo Handling'                             UNION
        SELECT 'Chemical'                                   UNION
        SELECT 'Computer'                                   UNION
        SELECT 'Consulting'                                 UNION
        SELECT 'Consumer Products'                          UNION
        SELECT 'Cosmetics'                                  UNION
        SELECT 'Defence'                                    UNION
        SELECT 'Department Stores'                          UNION
        SELECT 'Education'                                  UNION
        SELECT 'Electronics'                                UNION
        SELECT 'Energy'                                     UNION
        SELECT 'Entertainment & Leisure'                    UNION
        SELECT 'Executive Search'                           UNION
        SELECT 'Financial Services'                         UNION
        SELECT 'Food, Beverage & Tobacco'                   UNION
        SELECT 'Grocery'                                    UNION
        SELECT 'Health Care'                                UNION
        SELECT 'Internet Publishing'                        UNION
        SELECT 'Investment Banking'                         UNION
        SELECT 'Legal'                                      UNION
        SELECT 'Manufacturing'                              UNION
        SELECT 'Motion Picture & Video'                     UNION
        SELECT 'Music'                                      UNION
        SELECT 'Newspaper Publishers'                       UNION
        SELECT 'On-line Auctions'                           UNION
        SELECT 'Pension Funds'                              UNION
        SELECT 'Pharmaceuticals'                            UNION
        SELECT 'Private Equity'                             UNION
        SELECT 'Publishing'                                 UNION
        SELECT 'Real Estate'                                UNION
        SELECT 'Retail & Wholesale'                         UNION
        SELECT 'Securities & Commodity Exchanges'           UNION
        SELECT 'Service'                                    UNION
        SELECT 'Soap & Detergent'                           UNION
        SELECT 'Software'                                   UNION
        SELECT 'Sports'                                     UNION
        SELECT 'Technology'                                 UNION
        SELECT 'Telecommunications'                         UNION
        SELECT 'Television'                                 UNION
        SELECT 'Transportation'                             UNION
        SELECT 'Trucking'                                   UNION
        SELECT 'Venture Capital';


        INSERT INTO core.sales_tax_types(sales_tax_type_code, sales_tax_type_name, is_vat)
        SELECT 'SAT',   'Sales Tax',            false   UNION ALL
        SELECT 'VAT',   'Value Added Tax',      true;

        INSERT INTO core.tax_exempt_types(tax_exempt_type_code, tax_exempt_type_name)
        SELECT 'EXI', 'Exempt (Item)' UNION ALL
        SELECT 'EXP', 'Exempt (Party)' UNION ALL
        SELECT 'EXS', 'Exempt (Industry)' UNION ALL
        SELECT 'EXE', 'Exempt (Entity)';    

        INSERT INTO core.state_sales_taxes(state_sales_tax_code, state_sales_tax_name, state_id, rate) VALUES
        ('AL-STT', 'Alabama State Tax',             core.get_state_id_by_state_name('Alabama'),                 4), 
        ('AZ-STT', 'Arizona State Tax',             core.get_state_id_by_state_name('Arizona'),                 5.6), 
        ('AR-STT', 'Arkansas State Tax',            core.get_state_id_by_state_name('Arkansas'),                6.5), 
        ('CA-STT', 'California State Tax',          core.get_state_id_by_state_name('California'),              7.5), 
        ('CO-STT', 'Colorado State Tax',            core.get_state_id_by_state_name('Colorado'),                2.9), 
        ('CT-STT', 'Connecticut State Tax',         core.get_state_id_by_state_name('Connecticut'),             6.35), 
        ('DE-STT', 'Delaware State Tax',            core.get_state_id_by_state_name('Delaware'),                0), 
        ('DC-TAX', 'District of Columbia Tax',      core.get_state_id_by_state_name('District of Columbia'),    5.75), 
        ('FL-STT', 'Florida State Tax',             core.get_state_id_by_state_name('Florida'),                 6), 
        ('GA-STT', 'Georgia State Tax',             core.get_state_id_by_state_name('Georgia'),                 4), 
        ('HI-STT', 'Hawaii State Tax',              core.get_state_id_by_state_name('Hawaii'),                  4), 
        ('ID-STT', 'Idaho State Tax',               core.get_state_id_by_state_name('Idaho'),                   6), 
        ('IL-STT', 'Illinois State Tax',            core.get_state_id_by_state_name('Illinois'),                6.25), 
        ('IN-STT', 'Indiana State Tax',             core.get_state_id_by_state_name('Indiana'),                 7), 
        ('IA-STT', 'Iowa State Tax',                core.get_state_id_by_state_name('Iowa'),                    6), 
        ('KS-STT', 'Kansas State Tax',              core.get_state_id_by_state_name('Kansas'),                  6.15), 
        ('KY-STT', 'Kentucky State Tax',            core.get_state_id_by_state_name('Kentucky'),                6), 
        ('LA-STT', 'Louisiana State Tax',           core.get_state_id_by_state_name('Louisiana'),               4), 
        ('ME-STT', 'Maine State Tax',               core.get_state_id_by_state_name('Maine'),                   5.5), 
        ('MD-STT', 'Maryland State Tax',            core.get_state_id_by_state_name('Maryland'),                6), 
        ('MA-STT', 'Massachusetts State Tax',       core.get_state_id_by_state_name('Massachusetts'),           6.25), 
        ('MI-STT', 'Michigan State Tax',            core.get_state_id_by_state_name('Michigan'),                6), 
        ('MN-STT', 'Minnesota State Tax',           core.get_state_id_by_state_name('Minnesota'),               6.875), 
        ('MS-STT', 'Mississippi State Tax',         core.get_state_id_by_state_name('Mississippi'),             7), 
        ('MO-STT', 'Missouri State Tax',            core.get_state_id_by_state_name('Missouri'),                4.225), 
        ('NE-STT', 'Nebraska State Tax',            core.get_state_id_by_state_name('Nebraska'),                5.5), 
        ('NV-STT', 'Nevada State Tax',              core.get_state_id_by_state_name('Nevada'),                  6.85), 
        ('NJ-STT', 'New Jersey State Tax',          core.get_state_id_by_state_name('New Jersey'),              7), 
        ('NM-STT', 'New Mexico State Tax',          core.get_state_id_by_state_name('New Mexico'),              5.125), 
        ('NY-STT', 'New York State Tax',            core.get_state_id_by_state_name('New York'),                4), 
        ('NC-STT', 'North Carolina State Tax',      core.get_state_id_by_state_name('North Carolina'),          4.75), 
        ('ND-STT', 'North Dakota State Tax',        core.get_state_id_by_state_name('North Dakota'),            5), 
        ('OH-STT', 'Ohio State Tax',                core.get_state_id_by_state_name('Ohio'),                    5.75), 
        ('OK-STT', 'Oklahoma State Tax',            core.get_state_id_by_state_name('Oklahoma'),                4.5), 
        ('PA-STT', 'Pennsylvania State Tax',        core.get_state_id_by_state_name('Pennsylvania'),            6), 
        ('RI-STT', 'Rhode Island State Tax',        core.get_state_id_by_state_name('Rhode Island'),            7), 
        ('SC-STT', 'South Carolina State Tax',      core.get_state_id_by_state_name('South Carolina'),          6), 
        ('SD-STT', 'South Dakota State Tax',        core.get_state_id_by_state_name('South Dakota'),            4), 
        ('TN-STT', 'Tennessee State Tax',           core.get_state_id_by_state_name('Tennessee'),               7), 
        ('TX-STT', 'Texas State Tax',               core.get_state_id_by_state_name('Texas'),                   6.25), 
        ('UT-STT', 'Utah State Tax',                core.get_state_id_by_state_name('Utah'),                    4.7), 
        ('VT-STT', 'Vermont State Tax',             core.get_state_id_by_state_name('Vermont'),                 6), 
        ('VA-STT', 'Virginia State Tax',            core.get_state_id_by_state_name('Virginia'),                4.3), 
        ('WA-STT', 'Washington State Tax',          core.get_state_id_by_state_name('Washington'),              6.5), 
        ('WV-STT', 'West Virginia State Tax',       core.get_state_id_by_state_name('West Virginia'),           6), 
        ('WI-STT', 'Wisconsin State Tax',           core.get_state_id_by_state_name('Wisconsin'),               5), 
        ('WY-STT', 'Wyoming State Tax',             core.get_state_id_by_state_name('Wyoming'),                 4);

        INSERT INTO core.county_sales_taxes(county_id, county_sales_tax_code, county_sales_tax_name, rate)
        SELECT core.get_county_id_by_county_code('36047'), '36047-STX', 'Kings County Sales Tax', 4.875 UNION ALL
        SELECT core.get_county_id_by_county_code('6095'), '6095-STX', 'Solano County Sales Tax', 0.125;

        INSERT INTO core.brands(brand_code, brand_name)
        SELECT 'DEF', 'Default';

        INSERT INTO core.item_types(item_type_code, item_type_name)
        SELECT 'GEN', 'General'         UNION ALL
        SELECT 'COM', 'Component'       UNION ALL
        SELECT 'MAF', 'Manufacturing';

        INSERT INTO core.shipping_mail_types(shipping_mail_type_code, shipping_mail_type_name)
        SELECT 'FCM',   'First Class Mail'      UNION ALL
        SELECT 'PM',    'Priority Mail'         UNION ALL
        SELECT 'PP',    'Parcel Post'           UNION ALL
        SELECT 'EM',    'Express Mail'          UNION ALL
        SELECT 'MM',    'Media Mail';

        INSERT INTO core.shipping_package_shapes(shipping_package_shape_code, is_rectangular, shipping_package_shape_name)
        SELECT 'REC',   true,   'Rectangular Box Packaging'         UNION ALL
        SELECT 'IRR',   false,  'Irregular Packaging';
        
        INSERT INTO core.party_types(party_type_code, party_type_name, account_id) SELECT 'A', 'Agent', core.get_account_id_by_account_number('20100');
        INSERT INTO core.party_types(party_type_code, party_type_name, account_id) SELECT 'C', 'Customer', core.get_account_id_by_account_number('10400');
        INSERT INTO core.party_types(party_type_code, party_type_name, account_id) SELECT 'D', 'Dealer', core.get_account_id_by_account_number('10400');
        INSERT INTO core.party_types(party_type_code, party_type_name, is_supplier, account_id) SELECT 'S', 'Supplier', true, core.get_account_id_by_account_number('20100');

        INSERT INTO core.shippers(company_name, account_id)
        SELECT 'Default', core.get_account_id_by_account_number('20110');
    END IF;
END
$$
LANGUAGE plpgsql;