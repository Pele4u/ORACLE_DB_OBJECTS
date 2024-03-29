CREATE OR REPLACE VIEW AASC_INTERNATIONAL_COMM_VIEW
(delivery_id, description, country_of_manufacture, harmonized_code, quantity, quantity_units, unitprice, tariff_code, weight, number_of_pieces)
AS
SELECT
--------------------------------------------------------------------
--  name:              AASC_INTERNATIONAL_COMM_VIEW
--  create by:         
--  Revision:          1.0
--  creation date:     
--------------------------------------------------------------------
--  purpose :          CUST-760  LOG  Shipping  Ship Console Implementation  
--------------------------------------------------------------------
--  ver  date          name              desc
--  1.0  7.11.13       yuval tak         CR-1109 Ship Console- Adjust item description view
--  2.0  29/09/2021    Roman W.          GitHub first change in View
--  2.1  29/09/2021    Roman W.          GitHub first change in View 2
--  2.1  29/09/2021    Roman W.          GitHub first change in View 3
--------------------------------------------------------------------

       wnd.delivery_id delivery_id,
       nvl(substr(cat.description, 0, 35),
           substr((msib.description || ' / ' || msib.segment1), 0, 35)) description, -- Mandatory
       NVL(msib.attribute2,'US') country_of_manufacture,  -- Mandatory
       NULL harmonized_code,                              -- DFF but optional
       wdd.requested_quantity quantity,                   -- Mandatory
       ol.order_quantity_uom quantity_units,              -- Mandatory
       wdd.unit_price unit_price,                         -- Mandatory
       NULL tariff_code,                                  -- DFF and same as Harmonized Code
       nvl(wdd.gross_weight, 0) weight,                   -- Mandatory
       nvl(NULL, 1) number_of_pieces                      -- Mandatory
  FROM mtl_system_items_b       msib,
       wsh_delivery_details     wdd,
       wsh_new_deliveries       wnd,
       wsh_delivery_assignments wda,
       oe_order_lines_all  ol,
     ( SELECT mic.inventory_item_id,mic.category_id, mic.organization_id, mct.description
     FROM mtl_item_categories mic, mtl_categories_tl mct
    WHERE mic.category_set_id =fnd_profile.value('XXINV_SC_CATEGORY_SET_ID')
      AND mic.category_id = mct.category_id
      AND mct.language = userenv('LANG') ) cat

WHERE wda.delivery_detail_id = wdd.delivery_detail_id
   AND wda.delivery_id = wnd.delivery_id
   AND msib.inventory_item_id = wdd.inventory_item_id
   AND msib.organization_id = wdd.organization_id
   AND cat.inventory_item_id(+) =msib.inventory_item_id   
   AND cat.organization_id (+)= msib.organization_id
   AND cat.inventory_item_id(+) = msib.inventory_item_id
   AND wdd.source_line_id = ol.line_id
   AND wnd.delivery_id =  AASC_INTL_SHIPMENT_PKG.AASC_INTL_SHIPMENTS_VW_FUN;









