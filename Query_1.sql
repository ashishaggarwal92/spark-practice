CREATE VIEW v_trade_related AS
WITH trade_details AS (
    SELECT td.trade_id, td.grp_flag, td.grp_id, gd.grp_type, gr.grp_name
    FROM trade td
    JOIN grp_detail gd ON td.trade_id = gd.trade_id
    JOIN grp_relation gr ON td.grp_id = gr.grp_id
)
SELECT t.trade_id, t.grp_flag, t.grp_id, gd.grp_type
FROM trade td
JOIN grp_detail gd ON td.trade_id = gd.trade_id
JOIN grp_relation gr ON td.grp_id = gr.grp_id
JOIN trade_details t ON td.grp_id = t.grp_id
WHERE (
    -- For 'one_way' group type logic
    (t.grp_name = 'one_way' AND gd.grp_type = 'Guarantee' AND t.grp_type = 'Guarantor') OR
    (t.grp_name = 'one_way' AND gd.grp_type = 'Guarantor' AND t.grp_type = 'Guarantee') OR
    -- For 'cross_way' group type logic
    (t.grp_name = 'cross_way' AND gd.grp_type = 'XGuarantee' AND gd.grp_type != t.grp_type)
);
