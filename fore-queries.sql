-- Business Overview
SELECT
  COUNT(DISTINCT transaction_id)  AS total_transaksi,
  COUNT(DISTINCT outlet_id)       AS total_outlet_aktif,
  SUM(total_amount)               AS total_revenue,
  ROUND(AVG(total_amount), 0)     AS avg_order_value,
  MIN(date)                       AS tanggal_mulai,
  MAX(date)                       AS tanggal_akhir
FROM `fore_coffee.transaksi`
WHERE date BETWEEN '2025-01-01' AND '2026-03-31';


-- Monthly Revenue
SELECT
  FORMAT_DATE('%Y-%m', DATE(date))  AS bulan,
  COUNT(transaction_id)             AS jumlah_transaksi,
  SUM(total_amount)                 AS revenue,
  ROUND(AVG(total_amount), 0)       AS avg_order_value
FROM `fore_coffee.transaksi`
WHERE date BETWEEN '2025-01-01' AND '2026-03-31'
GROUP BY bulan
ORDER BY bulan;


-- Sales Channel Performance
SELECT
  channel,
  COUNT(transaction_id)                                           AS jumlah_transaksi,
  SUM(total_amount)                                               AS revenue,
  ROUND(AVG(total_amount), 0)                                     AS avg_order_value,
  ROUND(SUM(total_amount) * 100.0 / SUM(SUM(total_amount)) OVER (), 1) AS revenue_share_pct
FROM `fore_coffee.transaksi`
WHERE date BETWEEN '2025-01-01' AND '2026-03-31'
GROUP BY channel
ORDER BY revenue DESC;

-- Menu Category Performance
SELECT
  category,
  COUNT(transaction_id)                                           AS jumlah_transaksi,
  SUM(quantity)                                                   AS total_qty,
  SUM(total_amount)                                               AS revenue,
  ROUND(SUM(total_amount) * 100.0 / SUM(SUM(total_amount)) OVER (), 1) AS revenue_share_pct
FROM `fore_coffee.transaksi`
WHERE date BETWEEN '2025-01-01' AND '2026-03-31'
GROUP BY category
ORDER BY revenue DESC;


-- Top 10 Menu
SELECT
  menu_id,
  menu_name,
  category,
  SUM(quantity)     AS total_qty_terjual,
  SUM(total_amount) AS revenue,
  RANK() OVER (ORDER BY SUM(total_amount) DESC) AS revenue_rank
FROM `fore_coffee.transaksi`
WHERE date BETWEEN '2025-01-01' AND '2026-03-31'
GROUP BY menu_id, menu_name, category
ORDER BY revenue DESC
LIMIT 10;


-- Peak Hours
SELECT
  CAST(SPLIT(time, ':')[OFFSET(0)] AS INT64)  AS jam,
  COUNT(transaction_id)                        AS jumlah_transaksi,
  SUM(total_amount)                            AS revenue,
  ROUND(AVG(total_amount), 0)                  AS avg_order_value
FROM `fore_coffee.transaksi`
WHERE date BETWEEN '2025-01-01' AND '2026-03-31'
GROUP BY jam
ORDER BY jam;


-- Revenue by Province
SELECT
  province                    AS region,
  COUNT(DISTINCT outlet_id)   AS jumlah_outlet,
  COUNT(transaction_id)       AS jumlah_transaksi,
  SUM(total_amount)           AS revenue,
  ROUND(SUM(total_amount) / COUNT(DISTINCT outlet_id), 0) AS revenue_per_outlet
FROM `fore_coffee.transaksi`
WHERE date BETWEEN '2025-01-01' AND '2026-03-31'
GROUP BY region
ORDER BY revenue DESC;


-- Top 10 Outlet
SELECT
  outlet_id,
  outlet_name,
  city,
  province               AS region,
  COUNT(transaction_id)  AS jumlah_transaksi,
  SUM(total_amount)      AS revenue,
  RANK() OVER (ORDER BY SUM(total_amount) DESC) AS rank_outlet
FROM `fore_coffee.transaksi`
WHERE date BETWEEN '2025-01-01' AND '2026-03-31'
GROUP BY outlet_id, outlet_name, city, province
ORDER BY revenue DESC
LIMIT 10;