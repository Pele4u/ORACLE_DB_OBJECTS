CREATE OR REPLACE VIEW PO_LINE_LOCATIONS_XML AS
SELECT
--------------------------------------------------------------------
--  name:            PO_LINE_LOCATIONS_XML
--  create by:       XXX
--  Revision:        1.0
--  creation date:   XX/XX/2009 3:29:44 PM
--------------------------------------------------------------------
--  purpose :        REP001 - PO Document
--------------------------------------------------------------------
--  ver  date        name            desc
--  1.0  XX/XX/2009  XXX             initial build
--  1.1  28/02/2010  Vitaly K.       add fields
--  1.2  23/05/2010  Dalit A. Raviv  add condition to first select
--                                   not to show cancel line locations.
--  1.3  18.10.20    yuval tal       add logic to linkage  PRICE_OVERRIDE / amount
--  1.4  21.05.13    Vitaly          cr763 -- need_by_date_jpn, promised_date_jpn, ship_to_postal_code, ship_to_city added
--  1.5  11.06.13    yuval tal       bugfix 821 add logic to linkage  add release num parameter
--------------------------------------------------------------------
 pll.shipment_num,
 to_char(nvl(pll.need_by_date, pll.promised_date), 'DD-MON-YYYY HH24:MI:SS') due_date,
 pll.quantity,
 --  1 /*PLL.*/PRICE_OVERRIDE,   -- yuval 18.11.10
 xxpo_communication_report_pkg.get_converted_amount(pll.price_override,
                                                    po_communication_pvt.getsegmentnum(pll.po_header_id),0) PRICE_OVERRIDE, -- yuval 18.11.10
 pll.quantity_cancelled,
 pll.cancel_flag,
 to_char(pll.cancel_date, 'DD-MON-YYYY HH24:MI:SS') cancel_date,
 pll.cancel_reason,
 pll.taxable_flag,
 to_char(pll.start_date, 'DD-MON-YYYY HH24:MI:SS') start_date,
 to_char(pll.end_date, 'DD-MON-YYYY HH24:MI:SS') end_date,
 pll.attribute_category,
 pll.attribute1,
 pll.attribute2,
 pll.attribute3,
 pll.attribute4,
 pll.attribute5,
 pll.attribute6,
 pll.attribute7,
 pll.attribute8,
 pll.attribute9,
 pll.attribute10,
 pll.attribute11,
 pll.attribute12,
 pll.attribute13,
 pll.attribute14,
 pll.attribute15,
 pll.po_header_id,
 pl.po_line_id,
 pll.line_location_id,
 decode(nvl(pll.shipment_type, 'PRICE BREAK'),
        'PRICE BREAK',
        'BLANKET',
        'SCHEDULED',
        'RELEASE',
        'BLANKET',
        'RELEASE',
        'STANDARD',
        'STANDARD',
        'PLANNED',
        'PLANNED',
        'PREPAYMENT',
        'PREPAYMENT') shipment_type,
 pll.po_release_id,
 pll.consigned_flag,
 pll.ussgl_transaction_code,
 pll.government_context,
 pll.receiving_routing_id,
 pll.accrue_on_receipt_flag,
 pll.closed_reason,
 to_char(pll.closed_date, 'DD-MON-YYYY HH24:MI:SS') closed_date,
 pll.closed_by,
 pll.org_id,
 pll.unit_of_measure_class,
 pll.encumber_now,
 pll.inspection_required_flag,
 pll.receipt_required_flag,
 pll.qty_rcv_tolerance,
 pll.qty_rcv_exception_code,
 pll.enforce_ship_to_location_code,
 pll.allow_substitute_receipts_flag,
 pll.days_early_receipt_allowed,
 pll.days_late_receipt_allowed,
 pll.receipt_days_exception_code,
 pll.invoice_close_tolerance,
 pll.receive_close_tolerance,
 pll.ship_to_organization_id,
 pll.source_shipment_id,
 pll.closed_code,
 pll.request_id,
 pll.program_application_id,
 pll.program_id,
 pll.program_update_date,
 to_char(pll.last_accept_date, 'DD-MON-YYYY HH24:MI:SS') last_accept_date,
 pll.encumbered_flag,
 to_char(pll.encumbered_date, 'DD-MON-YYYY HH24:MI:SS') encumbered_date,
 pll.unencumbered_quantity,
 pll.fob_lookup_code,
 pll.freight_terms_lookup_code,
 to_char(pll.estimated_tax_amount, pgt.format_mask) estimated_tax_amount,
 pll.from_header_id,
 pll.from_line_id,
 pll.from_line_location_id,
 pll.lead_time,
 pll.lead_time_unit,
 pll.price_discount,
 pll.terms_id,
 pll.approved_flag,
 to_char(pll.approved_date, 'DD-MON-YYYY HH24:MI:SS') approved_date,
 pll.closed_flag,
 pll.cancelled_by,
 pll.firm_status_lookup_code,
 to_char(pll.firm_date, 'DD-MON-YYYY HH24:MI:SS') firm_date,
 to_char(pll.last_update_date, 'DD-MON-YYYY HH24:MI:SS') last_update_date,
 pll.last_updated_by,
 pll.last_update_login,
 to_char(pll.creation_date, 'DD-MON-YYYY HH24:MI:SS') creation_date,
 pll.created_by,
 pll.quantity_received,
 pll.quantity_accepted,
 pll.quantity_rejected,
 pll.quantity_billed,
 nvl(mum.unit_of_measure_tl, pll.unit_meas_lookup_code) unit_meas_lookup_code,
 xxpo_communication_report_pkg.get_uom_tl(pl.item_id,
                                          pll.ship_to_organization_id,
                                          nvl(mum.unit_of_measure_tl, pll.unit_meas_lookup_code))    uom_tl,
 pll.ship_via_lookup_code,
 pll.global_attribute_category,
 pll.global_attribute1,
 pll.global_attribute2,
 pll.global_attribute3,
 pll.global_attribute4,
 pll.global_attribute5,
 pll.global_attribute6,
 pll.global_attribute7,
 pll.global_attribute8,
 pll.global_attribute9,
 pll.global_attribute10,
 pll.global_attribute11,
 pll.global_attribute12,
 pll.global_attribute13,
 pll.global_attribute14,
 pll.global_attribute15,
 pll.global_attribute16,
 pll.global_attribute17,
 pll.global_attribute18,
 pll.global_attribute19,
 pll.global_attribute20,
 pll.quantity_shipped,
 pll.country_of_origin_code,
 pll.tax_user_override_flag,
 pll.match_option,
 pll.tax_code_id,
 pll.calculate_tax_flag,
 pll.change_promised_date_reason,
 pll.note_to_receiver,
 pll.secondary_unit_of_measure,
 pll.secondary_quantity,
 pll.preferred_grade,
 pll.secondary_quantity_received,
 pll.secondary_quantity_accepted,
 pll.secondary_quantity_rejected,
 pll.secondary_quantity_cancelled,
 pll.vmi_flag,
 to_char(pll.retroactive_date, 'DD-MON-YYYY HH24:MI:SS') retroactive_date,
 pll.supplier_order_line_number,
 to_char(po_core_s.get_total('S', pll.line_location_id), pgt.format_mask) amount,
 to_char(pll.amount_received, pgt.format_mask) amount_received,
 to_char(pll.amount_billed, pgt.format_mask) amount_billed,
 to_char(pll.amount_cancelled, pgt.format_mask) amount_cancelled,
 to_char(pll.amount_accepted, pgt.format_mask) amount_accepted,
 to_char(pll.amount_rejected, pgt.format_mask) amount_rejected,
 pll.drop_ship_flag,
 to_char(pll.sales_order_update_date, 'DD-MON-YYYY HH24:MI:SS') sales_order_update_date,
 decode(nvl(pll.ship_to_location_id, -1),
        -1,
        NULL,
        po_communication_pvt.getlocationinfo(pll.ship_to_location_id)) ship_to_location_id,
 decode(nvl(pll.ship_to_location_id, -1),
        -1,
        NULL,
        po_communication_pvt.getlocationname()) ship_to_location_name,
 decode(nvl(pll.ship_to_location_id, -1),
        -1,
        NULL,
        po_communication_pvt.getaddressline1()) ship_to_address_line1,
 decode(nvl(pll.ship_to_location_id, -1),
        -1,
        NULL,
        po_communication_pvt.getaddressline2()) ship_to_address_line2,
 decode(nvl(pll.ship_to_location_id, -1),
        -1,
        NULL,
        po_communication_pvt.getaddressline3()) ship_to_address_line3,
 decode(nvl(pll.ship_to_location_id, -1),
        -1,
        NULL,
        po_communication_pvt.getaddressline4()) ship_to_address_line4,
 decode(nvl(pll.ship_to_location_id, -1),
        -1,
        NULL,
        po_communication_pvt.getaddressinfo()) ship_to_address_info,
 decode(nvl(pll.ship_to_location_id, -1),
        -1,
        NULL,
        po_communication_pvt.getterritoryshortname()) ship_to_country,
 decode(nvl(pll.ship_to_location_id, -1),
        -1,
        NULL,
        po_communication_pvt.getPostalCode()) ship_to_postal_code,
 decode(nvl(pll.ship_to_location_id, -1),
        -1,
        NULL,
        po_communication_pvt.getTownOrCity()) ship_to_city,
 decode(nvl(pll.ship_to_location_id, -1),
        -1,
        NULL,
        po_communication_pvt.get_onetime_loc(pll.ship_to_location_id)) is_shipment_one_time_loc,
 decode(nvl(pll.ship_to_location_id, -1),
        -1,
        NULL,
        po_communication_pvt.get_onetime_address(pll.line_location_id)) one_time_address_details,
 decode(pll.drop_ship_flag,
        'Y',
        po_communication_pvt.get_drop_ship_details(pll.line_location_id),
        NULL) details,
 decode(pll.drop_ship_flag,
        'Y',
        po_communication_pvt.getshipcontphone(),
        NULL) ship_cont_phone,
 decode(pll.drop_ship_flag,
        'Y',
        po_communication_pvt.getshipcontemail(),
        NULL) ship_cont_email,
 decode(pll.drop_ship_flag,
        'Y',
        po_communication_pvt.getdelivercontphone(),
        NULL) ultimate_deliver_cont_phone,
 decode(pll.drop_ship_flag,
        'Y',
        po_communication_pvt.getdelivercontemail(),
        NULL) ultimate_deliver_cont_email,
 decode(pll.drop_ship_flag,
        'Y',
        po_communication_pvt.getshipcontname(),
        NULL) ship_cont_name,
 decode(pll.drop_ship_flag,
        'Y',
        po_communication_pvt.getdelivercontname(),
        NULL) ultimate_deliver_cont_name,
 decode(pll.drop_ship_flag,
        'Y',
        po_communication_pvt.getshipcustname(),
        NULL) ship_cust_name,
 decode(pll.drop_ship_flag,
        'Y',
        po_communication_pvt.getshipcustlocation(),
        NULL) ship_cust_location,
 decode(pll.drop_ship_flag,
        'Y',
        po_communication_pvt.getdelivercustname(),
        NULL) ultimate_deliver_cust_name,
 decode(pll.drop_ship_flag,
        'Y',
        po_communication_pvt.getdelivercustlocation(),
        NULL) ultimate_deliver_cust_location,
 decode(pll.drop_ship_flag,
        'Y',
        po_communication_pvt.getshipcontactfax(),
        NULL) ship_to_contact_fax,
 decode(pll.drop_ship_flag,
        'Y',
        po_communication_pvt.getdelivercontactname(),
        NULL) ultimate_deliver_to_cont_name,
 decode(pll.drop_ship_flag,
        'Y',
        po_communication_pvt.getdelivercontactfax(),
        NULL) ultimate_deliver_to_cont_fax,
 decode(pll.drop_ship_flag,
        'Y',
        po_communication_pvt.getshippingmethod(),
        NULL) shipping_method,
 decode(pll.drop_ship_flag,
        'Y',
        po_communication_pvt.getshippinginstructions(),
        NULL) shipping_instructions,
 decode(pll.drop_ship_flag,
        'Y',
        po_communication_pvt.getpackinginstructions(),
        NULL) packing_instructions,
 decode(pll.drop_ship_flag,
        'Y',
        po_communication_pvt.getcustomerproductdesc(),
        NULL) customer_product_desc,
 decode(pll.drop_ship_flag,
        'Y',
        po_communication_pvt.getcustomerponumber(),
        NULL) customer_po_num,
 decode(pll.drop_ship_flag,
        'Y',
        po_communication_pvt.getcustomerpolinenum(),
        NULL) customer_po_line_num,
 decode(pll.drop_ship_flag,
        'Y',
        po_communication_pvt.getcustomerposhipmentnum(),
        NULL) customer_po_shipment_num,
 --       TO_CHAR(PLL.NEED_BY_DATE, 'DD-MON-YYYY HH24:MI:SS') NEED_BY_DATE, -- Gabriel 210609
 to_char(pll.need_by_date, 'DD-MON-YYYY') need_by_date,
 to_char(pll.need_by_date, 'YYYY/MM/DD')  need_by_date_jpn,
 --       TO_CHAR(PLL.PROMISED_DATE, 'DD-MON-YYYY HH24:MI:SS') PROMISED_DATE, -- Gabriel 210609
 --TO_CHAR(PLL.PROMISED_DATE, 'DD-MON-YYYY') PROMISED_DATE,
 -- Vitaly 28/02/2010
 decode(pll.need_by_date, NULL, 'N', 'Y') need_by_date_exists,
 decode(pll.promised_date, NULL, 'N', 'Y') promised_date_exists,
 to_char(nvl(pll.promised_date, pll.need_by_date))              promised_date,
 to_char(nvl(pll.promised_date, pll.need_by_date),'YYYY/MM/DD') promised_date_jpn,
 -- TO_CHAR(PLL.AMOUNT, PGT.FORMAT_MASK) TOTAL_SHIPMENT_AMOUNT,    -- yuval 18.11.10
 to_char((xxpo_communication_report_pkg.get_converted_amount(nvl(pll.amount,
                                                                 0),
                                                             po_communication_pvt.getsegmentnum(pll.po_header_id),0)),
         po_communication_pvt.getformatmask) total_shipment_amount, -- yuval 18.11.10
 pll.final_match_flag,
 pll.manual_price_change_flag,
 pll.tax_name,
 pll.transaction_flow_header_id,
 pll.value_basis,
 pll.matching_basis,
 pll.payment_type,
 pll.description,
 pll.quantity_financed,
 to_char(pll.amount_financed, pgt.format_mask) amount_financed,
 pll.quantity_recouped,
 to_char(pll.amount_recouped, pgt.format_mask) amount_recouped,
 to_char(pll.retainage_withheld_amount, pgt.format_mask) retainage_withheld_amount,
 to_char(pll.retainage_released_amount, pgt.format_mask) retainage_released_amount,
 pll.work_approver_id,
 pll.bid_payment_id,
 to_char(pll.amount_shipped, pgt.format_mask) amount_shipped,
 -- Vitaly 28/02/2010
 xxpo_communication_report_pkg.get_rel_balance_quantity(pll.line_location_id) rel_bal_qty,
 xxpo_communication_report_pkg.is_promised_date_changed(pll.line_location_id) is_promised_date_changed,
 xxpo_communication_report_pkg.is_need_by_date_changed(pll.line_location_id) is_need_by_date_changed,
 xxpo_communication_report_pkg.get_release_remain_quantity(pll.line_location_id) quantity_rel_remain
  FROM po_line_locations_all   pll,
       po_lines_all            pl,
       po_communication_gt     pgt,
       mtl_units_of_measure_tl mum
 WHERE pll.po_line_id(+) = pl.po_line_id
   AND (pll.shipment_type(+) <> 'BLANKET' AND pgt.po_release_id IS NULL)
      -- 1.2 Dalit A. Raviv 23/05/2010
   AND nvl(pll.cancel_flag, 'N') = 'N'
      -- end 1.2
   AND pll.unit_meas_lookup_code = mum.unit_of_measure(+)
   AND mum.LANGUAGE(+) = userenv('LANG')
UNION
SELECT pll.shipment_num,
       to_char(nvl(pll.need_by_date, pll.promised_date),
               'DD-MON-YYYY HH24:MI:SS') due_date,
       pll.quantity,
       -- pll.price_override, yuval tal 18.11.10
        xxpo_communication_report_pkg.get_converted_amount(pll.price_override,
                                                    po_communication_pvt.getsegmentnum(pll.po_header_id),rel.release_num) , --yuval tal 18.11.10
       pll.quantity_cancelled,
       pll.cancel_flag,
       to_char(pll.cancel_date, 'DD-MON-YYYY HH24:MI:SS') cancel_date,
       pll.cancel_reason,
       pll.taxable_flag,
       to_char(pll.start_date, 'DD-MON-YYYY HH24:MI:SS') start_date,
       to_char(pll.end_date, 'DD-MON-YYYY HH24:MI:SS') end_date,
       pll.attribute_category,
       pll.attribute1,
       pll.attribute2,
       pll.attribute3,
       pll.attribute4,
       pll.attribute5,
       pll.attribute6,
       pll.attribute7,
       pll.attribute8,
       pll.attribute9,
       pll.attribute10,
       pll.attribute11,
       pll.attribute12,
       pll.attribute13,
       pll.attribute14,
       pll.attribute15,
       pll.po_header_id,
       pl.po_line_id,
       pll.line_location_id,
       decode(pll.shipment_type,
              'PRICE BREAK',
              'BLANKET',
              'SCHEDULED',
              'RELEASE',
              'BLANKET',
              'RELEASE',
              'STANDARD',
              'STANDARD',
              'PLANNED',
              'PLANNED',
              'PREPAYMENT',
              'PREPAYMENT') shipment_type,
       pll.po_release_id,
       pll.consigned_flag,
       pll.ussgl_transaction_code,
       pll.government_context,
       pll.receiving_routing_id,
       pll.accrue_on_receipt_flag,
       pll.closed_reason,
       to_char(pll.closed_date, 'DD-MON-YYYY HH24:MI:SS') closed_date,
       pll.closed_by,
       pll.org_id,
       pll.unit_of_measure_class,
       pll.encumber_now,
       pll.inspection_required_flag,
       pll.receipt_required_flag,
       pll.qty_rcv_tolerance,
       pll.qty_rcv_exception_code,
       pll.enforce_ship_to_location_code,
       pll.allow_substitute_receipts_flag,
       pll.days_early_receipt_allowed,
       pll.days_late_receipt_allowed,
       pll.receipt_days_exception_code,
       pll.invoice_close_tolerance,
       pll.receive_close_tolerance,
       pll.ship_to_organization_id,
       pll.source_shipment_id,
       pll.closed_code,
       pll.request_id,
       pll.program_application_id,
       pll.program_id,
       pll.program_update_date,
       to_char(pll.last_accept_date, 'DD-MON-YYYY HH24:MI:SS') last_accept_date,
       pll.encumbered_flag,
       to_char(pll.encumbered_date, 'DD-MON-YYYY HH24:MI:SS') encumbered_date,
       pll.unencumbered_quantity,
       pll.fob_lookup_code,
       pll.freight_terms_lookup_code,
       to_char(pll.estimated_tax_amount, pgt.format_mask) estimated_tax_amount,
       pll.from_header_id,
       pll.from_line_id,
       pll.from_line_location_id,
       pll.lead_time,
       pll.lead_time_unit,
       pll.price_discount,
       pll.terms_id,
       pll.approved_flag,
       to_char(pll.approved_date, 'DD-MON-YYYY HH24:MI:SS') approved_date,
       pll.closed_flag,
       pll.cancelled_by,
       pll.firm_status_lookup_code,
       to_char(pll.firm_date, 'DD-MON-YYYY HH24:MI:SS') firm_date,
       to_char(pll.last_update_date, 'DD-MON-YYYY HH24:MI:SS') last_update_date,
       pll.last_updated_by,
       pll.last_update_login,
       to_char(pll.creation_date, 'DD-MON-YYYY HH24:MI:SS') creation_date,
       pll.created_by,
       pll.quantity_received,
       pll.quantity_accepted,
       pll.quantity_rejected,
       pll.quantity_billed,
       nvl(mum.unit_of_measure_tl, pll.unit_meas_lookup_code) unit_meas_lookup_code,
       xxpo_communication_report_pkg.get_uom_tl(pl.item_id,
                                          pll.ship_to_organization_id,
                                          nvl(mum.unit_of_measure_tl, pll.unit_meas_lookup_code))    uom_tl,
       pll.ship_via_lookup_code,
       pll.global_attribute_category,
       pll.global_attribute1,
       pll.global_attribute2,
       pll.global_attribute3,
       pll.global_attribute4,
       pll.global_attribute5,
       pll.global_attribute6,
       pll.global_attribute7,
       pll.global_attribute8,
       pll.global_attribute9,
       pll.global_attribute10,
       pll.global_attribute11,
       pll.global_attribute12,
       pll.global_attribute13,
       pll.global_attribute14,
       pll.global_attribute15,
       pll.global_attribute16,
       pll.global_attribute17,
       pll.global_attribute18,
       pll.global_attribute19,
       pll.global_attribute20,
       pll.quantity_shipped,
       pll.country_of_origin_code,
       pll.tax_user_override_flag,
       pll.match_option,
       pll.tax_code_id,
       pll.calculate_tax_flag,
       pll.change_promised_date_reason,
       pll.note_to_receiver,
       pll.secondary_unit_of_measure,
       pll.secondary_quantity,
       pll.preferred_grade,
       pll.secondary_quantity_received,
       pll.secondary_quantity_accepted,
       pll.secondary_quantity_rejected,
       pll.secondary_quantity_cancelled,
       pll.vmi_flag,
       to_char(pll.retroactive_date, 'DD-MON-YYYY HH24:MI:SS') retroactive_date,
       pll.supplier_order_line_number,
       to_char(po_core_s.get_total('S', pll.line_location_id),
               pgt.format_mask) amount,
       to_char(pll.amount_received, pgt.format_mask) amount_received,
       to_char(pll.amount_billed, pgt.format_mask) amount_billed,
       to_char(pll.amount_cancelled, pgt.format_mask) amount_cancelled,
       to_char(pll.amount_accepted, pgt.format_mask) amount_accepted,
       to_char(pll.amount_rejected, pgt.format_mask) amount_rejected,
       pll.drop_ship_flag,
       to_char(pll.sales_order_update_date, 'DD-MON-YYYY HH24:MI:SS') sales_order_update_date,
       decode(nvl(pll.ship_to_location_id, -1),
              -1,
              NULL,
              po_communication_pvt.getlocationinfo(pll.ship_to_location_id)) ship_to_location_id,
       decode(nvl(pll.ship_to_location_id, -1),
              -1,
              NULL,
              po_communication_pvt.getlocationname()) ship_to_location_name,
       decode(nvl(pll.ship_to_location_id, -1),
              -1,
              NULL,
              po_communication_pvt.getaddressline1()) ship_to_address_line1,
       decode(nvl(pll.ship_to_location_id, -1),
              -1,
              NULL,
              po_communication_pvt.getaddressline2()) ship_to_address_line2,
       decode(nvl(pll.ship_to_location_id, -1),
              -1,
              NULL,
              po_communication_pvt.getaddressline3()) ship_to_address_line3,
       decode(nvl(pll.ship_to_location_id, -1),
              -1,
              NULL,
              po_communication_pvt.getaddressline4()) ship_to_address_line4,
       decode(nvl(pll.ship_to_location_id, -1),
              -1,
              NULL,
              po_communication_pvt.getaddressinfo()) ship_to_address_info,
       decode(nvl(pll.ship_to_location_id, -1),
              -1,
              NULL,
              po_communication_pvt.getterritoryshortname()) ship_to_country,
       decode(nvl(pll.ship_to_location_id, -1),
        -1,
        NULL,
        po_communication_pvt.getPostalCode()) ship_to_postal_code,
       decode(nvl(pll.ship_to_location_id, -1),
        -1,
        NULL,
        po_communication_pvt.getTownOrCity()) ship_to_city,
       decode(nvl(pll.ship_to_location_id, -1),
              -1,
              NULL,
              po_communication_pvt.get_onetime_loc(pll.ship_to_location_id)) is_shipment_one_time_loc,
       decode(nvl(pll.ship_to_location_id, -1),
              -1,
              NULL,
              po_communication_pvt.get_onetime_address(pll.line_location_id)) one_time_address_details,
       decode(pll.drop_ship_flag,
              'Y',
              po_communication_pvt.get_drop_ship_details(pll.line_location_id),
              NULL) details,
       decode(pll.drop_ship_flag,
              'Y',
              po_communication_pvt.getshipcontphone(),
              NULL) ship_cont_phone,
       decode(pll.drop_ship_flag,
              'Y',
              po_communication_pvt.getshipcontemail(),
              NULL) ship_cont_email,
       decode(pll.drop_ship_flag,
              'Y',
              po_communication_pvt.getdelivercontphone(),
              NULL) ultimate_deliver_cont_phone,
       decode(pll.drop_ship_flag,
              'Y',
              po_communication_pvt.getdelivercontemail(),
              NULL) ultimate_deliver_cont_email,
       decode(pll.drop_ship_flag,
              'Y',
              po_communication_pvt.getshipcontname(),
              NULL) ship_cont_name,
       decode(pll.drop_ship_flag,
              'Y',
              po_communication_pvt.getdelivercontname(),
              NULL) ultimate_deliver_cont_name,
       decode(pll.drop_ship_flag,
              'Y',
              po_communication_pvt.getshipcustname(),
              NULL) ship_cust_name,
       decode(pll.drop_ship_flag,
              'Y',
              po_communication_pvt.getshipcustlocation(),
              NULL) ship_cust_location,
       decode(pll.drop_ship_flag,
              'Y',
              po_communication_pvt.getdelivercustname(),
              NULL) ultimate_deliver_cust_name,
       decode(pll.drop_ship_flag,
              'Y',
              po_communication_pvt.getdelivercustlocation(),
              NULL) ultimate_deliver_cust_location,
       decode(pll.drop_ship_flag,
              'Y',
              po_communication_pvt.getshipcontactfax(),
              NULL) ship_to_contact_fax,
       decode(pll.drop_ship_flag,
              'Y',
              po_communication_pvt.getdelivercontactname(),
              NULL) ultimate_deliver_to_cont_name,
       decode(pll.drop_ship_flag,
              'Y',
              po_communication_pvt.getdelivercontactfax(),
              NULL) ultimate_deliver_to_cont_fax,
       decode(pll.drop_ship_flag,
              'Y',
              po_communication_pvt.getshippingmethod(),
              NULL) shipping_method,
       decode(pll.drop_ship_flag,
              'Y',
              po_communication_pvt.getshippinginstructions(),
              NULL) shipping_instructions,
       decode(pll.drop_ship_flag,
              'Y',
              po_communication_pvt.getpackinginstructions(),
              NULL) packing_instructions,
       decode(pll.drop_ship_flag,
              'Y',
              po_communication_pvt.getcustomerproductdesc(),
              NULL) customer_product_desc,
       decode(pll.drop_ship_flag,
              'Y',
              po_communication_pvt.getcustomerponumber(),
              NULL) customer_po_num,
       decode(pll.drop_ship_flag,
              'Y',
              po_communication_pvt.getcustomerpolinenum(),
              NULL) customer_po_line_num,
       decode(pll.drop_ship_flag,
              'Y',
              po_communication_pvt.getcustomerposhipmentnum(),
              NULL) customer_po_shipment_num,
       --       TO_CHAR(PLL.NEED_BY_DATE, 'DD-MON-YYYY HH24:MI:SS') NEED_BY_DATE, -- Gabriel 210609
       to_char(pll.need_by_date, 'DD-MON-YYYY') need_by_date,
       to_char(pll.need_by_date, 'YYYY/MM/DD')  need_by_date_jpn,
       --       TO_CHAR(PLL.PROMISED_DATE, 'DD-MON-YYYY HH24:MI:SS') PROMISED_DATE, -- Gabriel 210609
       --  TO_CHAR(PLL.PROMISED_DATE, 'DD-MON-YYYY') PROMISED_DATE,
       -- Vitaly 28/02/2010
       decode(pll.need_by_date, NULL, 'N', 'Y') need_by_date_exists,
       decode(pll.promised_date, NULL, 'N', 'Y') promised_date_exists,
       to_char(nvl(pll.promised_date, pll.need_by_date))              promised_date,
       to_char(nvl(pll.promised_date, pll.need_by_date),'YYYY/MM/DD') promised_date_jpn,
       to_char(pll.amount, pgt.format_mask) total_shipment_amount,
       pll.final_match_flag,
       pll.manual_price_change_flag,
       pll.tax_name,
       pll.transaction_flow_header_id,
       pll.value_basis,
       pll.matching_basis,
       pll.payment_type,
       pll.description,
       pll.quantity_financed,
       to_char(pll.amount_financed, pgt.format_mask) amount_financed,
       pll.quantity_recouped,
       to_char(pll.amount_recouped, pgt.format_mask) amount_recouped,
       to_char(pll.retainage_withheld_amount, pgt.format_mask) retainage_withheld_amount,
       to_char(pll.retainage_released_amount, pgt.format_mask) retainage_released_amount,
       pll.work_approver_id,
       pll.bid_payment_id,
       to_char(pll.amount_shipped, pgt.format_mask) amount_shipped,
       -- Vitaly 28/02/2010
       xxpo_communication_report_pkg.get_rel_balance_quantity(pll.line_location_id) rel_bal_qty,
       xxpo_communication_report_pkg.is_promised_date_changed(pll.line_location_id) is_promised_date_changed,
       xxpo_communication_report_pkg.is_need_by_date_changed(pll.line_location_id) is_need_by_date_changed,
       xxpo_communication_report_pkg.get_release_remain_quantity(pll.line_location_id) quantity_rel_remain
  FROM po_line_locations_all   pll,
       po_lines_all            pl,
       po_communication_gt     pgt,
       mtl_units_of_measure_tl mum,
       po_releases_all rel
 WHERE rel.po_release_id=pll.po_release_id and
       pll.po_line_id(+) = pl.po_line_id
   AND nvl(pll.cancel_flag, 'N') = 'N'
   AND (pll.shipment_type(+) = 'BLANKET' AND pgt.po_release_id IS NOT NULL)
   AND pll.unit_meas_lookup_code = mum.unit_of_measure(+)
   AND mum.LANGUAGE(+) = userenv('LANG');