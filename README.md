# Economic Outlook Exploration

This is a reworked version of an assignment submission as part of **UNSW's ZZSC5836 Data Mining and Machine Learning** course. This research project aims to identify trends and patterns in various measures of economic productivity and education, and understand the relationships that exist between them.

**Tech stack:** Python, MySQL, statsmodels, scikit-learn, XGBoost

View the notebook with data analysis and visualisations here: https://github.com/joshuatxl/economic-and-education-outlook-exploration/blob/main/Economic%20and%20Education%20Outlook%20Notebook.ipynb

## Data

| Source | Content |
|---|---|
| [IMF World Economic Outlook, April 2025](https://www.imf.org/en/publications/weo/weo-database/2025/april) | GDP, GDP per capita and population, 1980–2025 |
| [World Bank Education Statistics](https://databank.worldbank.org/source/education-statistics-%5E-all-indicators) | Tertiary enrolment and graduation ratios |
| [QS World University Rankings 2025](https://www.topuniversities.com/world-university-rankings/2025) | University rankings by country |

Data is initially inspected using Python, preprocessind, transformed, and stored in MySQL, and ingested back to Python for analysis and visualisation.  

## Questions and observations

| Question | Observation |
|---|---|
|How did GDP grow across regions from 2000 to 2025, and what is the relationship between GDP growth and population growth over the same period?| OVerall, both GDP and population increased together in every region, with Asia Pacific showing the highest correlation both measures.|
|How much did the top five GDP contributors in each region contribute in total from 2000 to 2025, and how did their contributions change over this period?| China overtook Japan around 2010 as the leader in Asia Pacific. The United States leads Canada by a large, sustained margin in North America.|
|What is the relationship between GDP and GDP per capita across countries within each region in the year 2025?| Asia Pacific varies the most. Europe has high GDP per capita regardless of GDP level. Africa has comparatively lower GDP per capita compared to other regions|
|How many of the top 300 universities does each country and region have in 2025?| Europe has 124 top 300 universities. Asia Pacific has 91 and North America has 62.|
|Based on data from 2000 to 2025, how well do Gross Enrolment Ratio, Gross Graduation Ratio, and Population predict GDP for countries?| An Ordinary Least Squares (OLS) regression model on logarithmi-transformed GDP gives an Adjusted R-squared of 0.70. XGBoost reaches an R-squared of 0.67, basically on par with the OLS model.|
|How is GDP in AUS expected to grow after 2024?| An ARIMA time-series model forecasts ~USD 2.7 trillion by 2030.|




## Limitations

- 2025 figures are projections from the IMF.
- Data on education indicators is mostly incomplete.
