# Executive Sales Dashboard (Power BI)

A one-page Power BI dashboard that shows where an outdoor-gear business earns its revenue across Europe, and where it loses margin.
![Executive Sales Dashboard](POWER%20BI%20DASHBOARD.png)

---

## 1. Business problem

**Scenario:** A sales head at a European outdoor-gear seller wants one page to review the year, without opening Excel.

I built the dashboard to answer three questions:

1. Which countries, channels and product categories bring the most revenue?
2. How does revenue move month to month, and when does it peak?
3. Are we actually making money on that revenue (gross margin), or is something eating it?

## 2. About this project

I built the base dashboard by following a Power BI tutorial on YouTube by **Satish Dhawale**. The dataset comes from that tutorial. It is a practice dataset, not a real company's data.

What I did on my own, beyond the video:

- Checked every KPI and chart against the raw Excel file using pivot tables and SUM formulas.
- Analysed the data for margin, discount and channel patterns, which the tutorial did not cover. The insights in section 7 are mine.

## 3. Dataset

| Item | Detail |
|---|---|
| Source | Practice dataset from the tutorial above |
| File | `Sales_Data.xlsx` (1 sheet: `Data`) |
| Size | 2,707 rows, 16 columns |
| Period | 1 Jan 2026 to 30 Dec 2026 |
| Coverage | 17 countries, 4 regions, 5 categories, 20 products, 4 sales channels, 3 customer types |

| Column | Meaning |
|---|---|
| ID | Order ID (unique per row) |
| Order Date | Date of order |
| Region, Country | Where the order was sold |
| Sales Channel | Online Store, Corporate, Retail Partners, Marketplace |
| Customer Type | New, Returning, Business |
| Product Category, Product | 5 categories, 20 products |
| Units Sold | Quantity in the order |
| Unit Price | Selling price before discount |
| Discount % | 0%, 5%, 10%, 15% or 20% |
| Unit Cost | Cost per unit |
| Revenue | Units x Unit Price x (1 - Discount) |
| COGS | Units x Unit Cost |
| Gross Profit | Revenue - COGS |
| Gross Margin % | Gross Profit / Revenue |

## 4. Tools and skills

- **Power BI Desktop:** data model, report design, slicers, Top/Bottom N filters, map
- **DAX:** calculated table, calculated columns, measures (`SUM`, `DISTINCTCOUNT`, `DIVIDE`, `FORMAT`, `MONTH`, `YEAR`, `QUARTER`)
- **Data modelling:** `Sales_Data` linked to a `Date Table`
- **Excel:** source data, plus pivot tables to verify the dashboard numbers

## 5. Data checks

The data was already clean. I did not need to fix anything, so I validated it instead.

| Check | Result |
|---|---|
| Missing values | 0 in all 16 columns |
| Duplicate rows | 0 |
| Duplicate order IDs | 0 (2,707 unique IDs) |
| Revenue = Units x Price x (1 - Discount) | Matches on every row |
| COGS = Units x Unit Cost | Matches on every row |
| Gross Profit = Revenue - COGS | Matches on every row |

## 6. How I built it

**Data model:** `Sales_Data[Order Date]` is linked to `Date Table[Date]`.

**Date Table (DAX):**

```dax
Date Table = CALENDAR(MIN(Sales_Data[Order Date]), MAX(Sales_Data[Order Date]))

Day Name     = FORMAT('Date Table'[Date], "DDD")
Month Name   = FORMAT('Date Table'[Date], "MMM")
Month Number = MONTH('Date Table'[Date])
Quarter      = "Q" & QUARTER('Date Table'[Date])
Year         = YEAR('Date Table'[Date])
```

**Measures (kept in a separate `All_Measures` table):**

```dax
Total Revenue      = SUM(Sales_Data[Revenue])
Total Gross Profit = SUM(Sales_Data[Gross Profit])
Total Quantity     = SUM(Sales_Data[Units Sold])
Total Order        = DISTINCTCOUNT(Sales_Data[ID])
Gross Margin       = DIVIDE([Total Gross Profit], [Total Revenue])
```

**Dashboard:**

- 5 KPI cards: revenue, gross profit, margin, quantity, orders
- Line chart: monthly revenue and gross profit
- Top 5 and Bottom 5 countries by revenue
- Pie chart: revenue by sales channel
- Donut chart: product category
- Filled map of Europe
- 4 slicers: Country, Month, Quarter, Product Category

## 7. Key insights

I calculated these from the raw data.

1. **Overall:** Revenue is 645.2K and gross profit is 296.4K. Gross margin is 45.9% across 2,707 orders. Average order value is about 238.
2. **Sales depend on a few countries.** The UK, Germany and France bring 30.9% of revenue. The top 5 countries bring 46.0%. The bottom 5 bring only 17.8%. Ireland is the lowest at 16.6K, about 22% of the UK.
3. **Corporate sells big but earns less.** It gives 27.8% of revenue from just 263 orders (average order about 683, against 180 to 197 in other channels). Its margin is 42.1%, against 47.4% to 47.5% elsewhere. Its average discount is 11.7%, against 4.2% to 4.7% in other channels.
4. **Discounts cut margin.** 63.0% of revenue was sold with some discount. Margin falls from 49.6% at 0% discount to 38.7% at 20%. In total, discounts took away 44.7K, which is 6.5% of list-price value.
5. **The biggest category has the lowest margin.** Camping is 30.8% of revenue but has a 42.8% margin. Fitness is the smallest (8.6% of revenue) but has the best margin at 51.2%. Alpine Tent 4P is the #2 product by revenue (63.7K) and has the lowest margin of all 20 products (37.1%).
6. **Seasonality:** Q1 is the weakest quarter (119.4K). Q2 is the strongest (182.4K). June is the top month (69.5K) and February is the lowest (35.6K). November jumps 33% over October (65.5K vs 49.1K).

## 8. Recommendations

These come from the numbers above. I would check each one with the business before acting.

1. **Set a discount limit for Corporate deals.** Orders at 15% or 20% discount are 322 orders (11.9%) and their margin is under 40%.
2. **Review pricing or cost of Alpine Tent 4P.** It sells well but has the lowest margin.
3. **Plan stock and promotions around Q2 and November.** These are the peaks. Look into why Q1 is slow.
4. **Look at the bottom 5 countries before spending on them.** The data cannot say if they are small markets or under-served ones.
5. **Protect Online Store.** It brings 40.3% of revenue with a healthy 47.4% margin.

## 9. Project structure

```
├── README.md
├── Executive Sales Dashboard.pbix
├── Sales_Data.xlsx
└── POWER BI DASHBOARD.png
```

## 10. How to open it

1. Download `Executive Sales Dashboard.pbix` and `Sales_Data.xlsx` into the same folder.
2. Open the `.pbix` file in Power BI Desktop (free for Windows).
3. If Power BI asks for the data path, click **Transform data > Data source settings** and point it to `Sales_Data.xlsx`.


## 11. About me

I'm Pushp Raj, a BBA (Marketing) student at Amity University Patna, batch 2023-26. I hold the Google Data Analytics certificate and I'm looking for an entry-level data analyst role. 
- GitHub: [Pushp-raj-07](https://github.com/Pushp-raj-07)
- Email: pushprajput223@gmail.com
