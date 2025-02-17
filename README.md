# Analysing the Shipping Industry
> Initial analysis and forecasts prepared in November 2024 using the [October IMF World Economic Outlook](https://www.imf.org/en/Publications/WEO/Issues/2024/10/22/world-economic-outlook-october-2024).
## Key Factors in International Trade

### Oil Prices
- Prices stand at $71 US/barrel for Brent crude and $68 for WTI.
- Despite geopolitical concerns, such as tensions in the Middle East, oil prices have dropped by 11% since early October.
  - According to the IMF, increased conflict could lead to a 15% increase in crude oil prices, which would result in a 150% increase in average container prices for 2024-25.
- Fuel prices represent about 30-60% of the total cost of a ship’s operating expenses.
- OPEC recently cut its oil demand forecasts for 2024 and 2025 by 6%, implying a price drop.
### Exchange Rates
| USD-EUR | USD-CNY |
| ------- | ------- |
|The rate had remained stable until November, with a boost after Trump’s election, now at 0.94. | The US dollar appreciated relative to the Yuan, reaching a rate of 7.23. |
|This may be good news for European exporters such as manufacturing and pharmaceuticals | Potentially beneficial to the giant Chinese manufacturing industry, the advantageous rate could help boost the local economy.|
|Trump's planned 10% blanket tariffs would increase the cost of imported goods in the USA, potentially counteracting the increased power from the exchange rate. | Anti-China tariffs can have a significant impact on Chinese exports to the United States.|
### Central Bank Interest Rates
Both the Federal Reserve and the European Central Bank began cutting rates, with the Fed going from 5.5% to 4.75% and the ECB decreasing from 4% to 3.25%. The Fed also provided a long run target of 2.9%, while the ECB anticipated some inflation at the end of 2024 before gradually returning to the target in 2025. In both economies, lower rates should increase trade volumes, ceteris paribus. Companies borrow both to import goods, but also in order to expand their business and develop exports.

## Forecasts

### Trade Volume
- The model specification is that of an ARIMA(2,1,1), including a first difference on the initital series.
- Our simple forecast aligns closely with that of the IMF, but slightly lower in magnitude around a mean of 2.5%.
- Given the dependency of trade on macroeconomic factors, this forecast could be improved using a VAR or ARIMAX model specification.
![export_forecast](https://github.com/user-attachments/assets/622579af-c21d-46a9-8245-c476f8b6e3bd)


### Brent Crude
- Given the lack of granularity in the WEO for Brent crude prices, a very simple model of AR(1) was used to perform the forecast.
- The model also predicts a decrease in the price of Brent crude over the next five years.
- It is important to note the external factors that also play a role in the pricing of oil, typically OPEC's production, trade blockages, and industrial demand.
![brent_forecast](https://github.com/user-attachments/assets/6f78f38b-4529-45d3-96b6-b1d2d4a879a4)
