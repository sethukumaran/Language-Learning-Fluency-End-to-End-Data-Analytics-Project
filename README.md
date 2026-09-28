## Language Learning Fluency — Analytics Project

## 1. Executive Summary
This project analyzes a synthetic dataset of **45,000 language learners** to understand which learning behaviors and learner/context characteristics are associated with reaching **B2-level fluency or above** and with **dropping out before B2**.
The analysis combines:
- Exploratory Data Analysis (EDA)
- Data-quality validation
- SQL business analysis
- Python statistical exploration
- Visualization
- Learner segmentation
- Business recommendations
- Portfolio-ready documentation

### Headline KPIs

| KPI | Result |
|---|---:|
| Learners | 45,000 |
| Fluency rate (B2+) | 35.76% |
| Dropout rate | 37.07% |
| Missing values | 0 |
| Duplicate learner IDs | 0 |
| CEFR levels | A0–C2 |

This dataset is synthetic. Findings should be treated as analytical patterns for portfolio/demo purposes, not causal evidence about real-world language learning.


## 2. Business Problem

A language-learning product needs to understand:

1. What factors are most associated with achieving B2+ fluency?
2. What learner behaviors are associated with dropout?
3. How does target-language difficulty affect outcomes?
4. Does higher study volume translate into better outcomes?
5. How important are active use, comprehensible input, speaking, feedback and immersion?
6. Which learner segments may need additional intervention?

The objective is to translate learner-level data into **actionable product, retention and learning-strategy insights**.


## 3. Dataset

Primary file: `language_learning_fluency.csv`

Supporting metadata: `data_dictionary_language.csv`

### Key fields

| Field | Business meaning |
|---|---|
| `learner_id` | Unique learner |
| `fsi_category` | Target-language difficulty: 1 easy → 4 difficult |
| `related_language` | Whether learner knows a related language |
| `prior_languages` | Number of languages already known |
| `age_started` | Age at which learning started |
| `total_study_hours` | Total study volume |
| `active_use_share` | Share of learning spent in active use/output |
| `immersion_months` | Months of immersive exposure |
| `speaking_practice` | Speaking/output practice score |
| `feedback_quality` | Corrective feedback quality score |
| `comprehensible_input_hours` | Listening/reading input hours |
| `uses_srs` | Whether spaced repetition is used |
| `motivation` | Motivation score |
| `consistency` | Practice consistency score |
| `accent_nativelike` | Accent score; separate from fluency |
| `cefr_level` | Attained CEFR level |
| `reached_fluency` | Target: 1 = B2 or above |
| `dropped_out` | Target: 1 = quit before B2 |


## 4. Data Quality Assessment

The dataset has:

- **45,000 records**
- **18 columns**
- No missing values
- No duplicate learner IDs
- Binary target variables are cleanly separated
- Numeric learning-quality measures are within their documented ranges

This makes the dataset suitable for exploratory analysis without requiring imputation.


## 5. Key Business Insights

### Insight 1 — Study volume is the strongest practical lever

Fluency increases substantially across study-hour bands:

- <=250 hours: **2.5%** fluency
- 251–500: **21.3%**
- 501–750: **47.8%**
- 751–1,000: **63.0%**
- 1,001–1,500: **78.1%**
- 1,501+: **89.9%**

At the same time, dropout declines from **54.0%** in the <=250-hour group to **6.9%** among learners with 1,501+ hours.

**Business interpretation:** The product should focus heavily on getting learners through the early-volume bottleneck rather than only optimizing advanced learners.


### Insight 2 — Comprehensible input has a strong relationship with fluency

The highest input quartile has approximately **72.1%** fluency versus **4.3%** in the lowest quartile.

The correlation between comprehensible-input hours and fluency is approximately **+0.505**.

**Business interpretation:** A product could prioritize personalized reading/listening pathways and track meaningful input volume as an engagement KPI.



### Insight 3 — Active use matters more than passive study composition

Fluency rises from approximately **15.5%** for learners with <=20% active-use share to **60.5%** for learners with >80% active-use share.

Dropout falls from about **50.5%** to **20.4%** across the same groups.

**Business interpretation:** Product design should encourage output: speaking tasks, writing, conversation simulations and real-world production—not only passive review.


### Insight 4 — Target-language difficulty creates a major performance gap

Fluency by FSI category:

| FSI | Fluency | Dropout |
|---:|---:|---:|
| 1 | 54.1% | 23.4% |
| 2 | 42.1% | 31.2% |
| 3 | 27.0% | 42.1% |
| 4 | 9.5% | 59.7% |

Average study hours are very similar across the FSI categories, so the difference is not explained simply by learners in harder categories studying less.

**Business interpretation:** Learning plans should be difficulty-aware. Learners studying harder languages may need longer pathways, more structured milestones and stronger retention support.


### Insight 5 — Immersion is associated with better outcomes

Fluency rises from approximately **31.9%** with no immersion to **62.0%** among the 12+ month group.

Dropout falls from **40.9%** to **9.2%**.

**Business interpretation:** Immersive exposure can be positioned as a high-value learning pathway, but the analysis is observational and does not establish causation.



### Insight 6 — Related-language knowledge provides a modest advantage

Learners with a related language have:

- Fluency: **39.1%**
- Dropout: **33.7%**

Learners without one have:

- Fluency: **34.3%**
- Dropout: **38.5%**

**Business interpretation:** Related-language knowledge appears helpful, but its effect is considerably smaller than study volume, comprehensible input and active-use share.



### Insight 7 — SRS alone shows only a small outcome difference

SRS users have about **36.8%** fluency versus **35.0%** for non-users.

**Business interpretation:** Spaced repetition may be useful for retention of vocabulary, but this dataset does not show a large standalone association with reaching B2+.



### Insight 8 — Motivation and consistency are more closely linked to retention than attainment

Motivation has a near-zero simple correlation with fluency (**~0.004**) but a negative correlation with dropout (**~-0.147**).

Consistency has a near-zero simple correlation with fluency (**~0.002**) but a negative correlation with dropout (**~-0.143**).

**Business interpretation:** These variables may be especially useful for predicting disengagement and triggering retention interventions rather than directly predicting final fluency.


## 6. Priority Learner Segments

### High-risk early-stage segment

Definition:

- <=250 total study hours
- <=20% active-use share

Observed pattern: very low fluency and high dropout.

**Recommended intervention:**

- onboarding reinforcement
- weekly activity goals
- speaking prompts
- personalized reminders
- short achievable milestones
- early progress feedback

### Strong-engagement segment

Definition:

- >=1,000 study hours
- >=60% active-use share

Observed pattern: materially higher fluency and lower dropout.

**Recommended intervention:**

- advanced content
- B2/C1 progression paths
- real-world speaking challenges
- certification preparation
- community/immersion opportunities


## 7. Recommended Business Actions

### Product
1. Track cumulative meaningful learning hours.
2. Increase active-use opportunities.
3. Build comprehensible-input recommendations.
4. Adapt learning plans to language difficulty.
5. Add stronger milestone systems around the first 250–500 hours.

### Retention
1. Detect low-study-volume learners early.
2. Use motivation and consistency signals for churn-risk monitoring.
3. Trigger intervention before prolonged inactivity.
4. Design separate retention journeys for difficult languages.

### Learning Experience
1. Increase speaking/output opportunities.
2. Combine input with active production.
3. Promote immersion-style activities.
4. Use SRS as a supporting mechanism rather than the entire strategy.


## 8. SQL Analysis

The file `sql_analysis.sql` contains MS SQL-compatible queries covering:

- overall KPIs
- CEFR distribution
- FSI performance
- study-hour segmentation
- dropout analysis
- related-language comparison
- SRS comparison
- active-use analysis
- comprehensible-input quartiles
- high-risk segmentation
- strong-engagement segmentation
- FSI × study-volume analysis
- correlations


## 9. Python Analysis

The file `language_learning_analysis.py` performs:

- shape and schema inspection
- missing-value analysis
- duplicate checks
- descriptive statistics
- target KPI analysis
- categorical profiling
- correlation analysis
- segmentation
- chart generation

## 11. Analytical Limitations

This is a synthetic observational dataset. Therefore:
- correlation does not prove causation
- learner self-selection may affect observed relationships
- no longitudinal intervention design is available
- external factors such as instructor quality, socioeconomic context and learning environment are not modeled
- `age_started` should not be interpreted as a direct determinant of attainable fluency based solely on this dataset
- simple correlations do not control for confounding variables
A stronger next step would be a multivariate model such as logistic regression or gradient boosting, followed by calibration, feature importance and out-of-sample validation.

## 12. Key findings
- 45,000 learners, 18 columns, with no missing values or duplicate learner IDs.
- Overall B2+ fluency rate: 35.76%.
- Overall dropout rate: 37.07%.
- Study volume has the strongest practical relationship with fluency: learners with 1,501+ study hours reached ~89.9% fluency, versus only 2.5% at ≤250 hours.
- Comprehensible input shows a strong relationship with attainment: the highest input quartile has about 72.1% fluency versus 4.3% in the lowest.
- Active-use share is also strongly differentiated: fluency rises from 15.5% at 0–20% active use to 60.5% at 81–100%.
- FSI language difficulty creates a major gap: Category 1 has 54.1% fluency, while Category 4 has 9.5%.
- Immersion is associated with higher fluency and lower dropout.
- Motivation and consistency appear more useful as retention/dropout indicators than as direct fluency predictors.
- SRS users show only a relatively small difference in B2+ attainment in this dataset.


## 13. Conclusion

The analysis indicates that **language-learning outcomes are most strongly differentiated by cumulative study volume, comprehensible input, active use and target-language difficulty**. Learners with substantially greater study exposure show much higher B2+ attainment and much lower dropout.
From a business perspective, the largest opportunity is not simply to increase raw engagement. It is to convert early learners into **consistent, high-volume, active learners** while adapting expectations and support to the difficulty of the target language.
The most actionable product strategy is therefore to combine **progressive study-hour milestones + active-use experiences + high-quality comprehensible input + early dropout-risk intervention + difficulty-aware learning plans**.

Because the dataset is synthetic and observational, these findings should be treated as hypotheses for product experimentation rather than causal conclusions.
