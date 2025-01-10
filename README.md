# BAIS Alumni Data Analysis

This project provides a comprehensive analysis of BAIS alumni data from May 2014 to December 2020. The analysis includes data cleaning, summarization, and visualization of key insights such as graduation trends, LinkedIn connectivity, geographic distribution, and academic characteristics.

---

## Requirements

To run the code, ensure the following R packages are installed:

- `readxl`
- `dplyr`
- `ggplot2`
- `forcats`

Install any missing packages using `install.packages()`.

---

## Project Workflow

### 1. Data Cleaning and Integration
- Load data from Excel (`readxl`) and CSV files.
- Standardize column names for consistency.
- Combine data from multiple sources using `rbind` after cleaning.
- Save the cleaned dataset as `BAIS_alumni.csv`.

### 2. Summary Statistics
- Calculate the total number of graduates and the percentage with LinkedIn connections.
- Display results using `cat()`.

### 3. Graduation Trends
- Visualize the number of graduates per year using a bar plot with `ggplot2`.

### 4. Geographic Distribution
- Analyze the top 5 states with the highest number of graduates with LinkedIn connections.
- Categorize alumni as "Intl" for those outside U.S. states or Washington, D.C.
- Visualize the distribution with a bar chart.

### 5. Academic Characteristics
- Classify alumni into categories: "Only BAIS" or "Other Major/Minor/Certificate."
- Create a pie chart to compare these groups.

### 6. Top Majors
- Identify and visualize the top 5 non-BAIS majors pursued by graduates.

---

## Key Visualizations

### Graduation Trends
- Bar plot displaying the number of graduates each year.

### Geographic Distribution
- Bar chart showing the distribution of graduates by state and international regions.

### Academic Characteristics
- Pie chart comparing graduates with additional academic credentials to those with only BAIS.

### Top Majors
- Bar plot of the top 5 non-BAIS majors.

---

## How to Use
1. Clone this repository and navigate to the project directory.
2. Place the required data files:
   - `BAIS alumni.xlsx`
   - `BAIS alumni_05-2020.csv`
   - `BAIS alumni_12-2020.csv`
3. Run the R script in your R environment.
4. Outputs include:
   - Cleaned dataset: `BAIS_alumni.csv`
   - Summary statistics in the console.
   - Visualizations displayed in the R plotting window.

