-- Language Learning Fluency Analysis
-- Import language_learning_fluency.csv as table: language_learning_fluency

-- 1. Dataset quality / row count
SELECT COUNT(*) AS learner_count
FROM language_learning_fluency;

-- 2. Overall KPI dashboard
SELECT
    COUNT(*) AS learners,
    ROUND(100.0 * AVG(reached_fluency), 2) AS fluency_rate_pct,
    ROUND(100.0 * AVG(dropped_out), 2) AS dropout_rate_pct,
    ROUND(AVG(total_study_hours), 1) AS avg_study_hours,
    ROUND(AVG(comprehensible_input_hours), 1) AS avg_input_hours,
    ROUND(AVG(active_use_share), 3) AS avg_active_use_share
FROM language_learning_fluency;

-- 3. CEFR distribution
SELECT cefr_level, COUNT(*) AS learners,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS share_pct
FROM language_learning_fluency
GROUP BY cefr_level
ORDER BY CASE cefr_level
    WHEN 'A0' THEN 1 WHEN 'A1' THEN 2 WHEN 'A2' THEN 3
    WHEN 'B1' THEN 4 WHEN 'B2' THEN 5 WHEN 'C1' THEN 6 WHEN 'C2' THEN 7 END;

-- 4. Fluency and dropout by FSI difficulty
SELECT fsi_category,
       COUNT(*) AS learners,
       ROUND(100.0 * AVG(reached_fluency), 2) AS fluency_rate_pct,
       ROUND(100.0 * AVG(dropped_out), 2) AS dropout_rate_pct,
       ROUND(AVG(total_study_hours), 1) AS avg_study_hours
FROM language_learning_fluency
GROUP BY fsi_category
ORDER BY fsi_category;

-- 5. Study-hour bands
WITH banded AS (
    SELECT *,
      CASE
        WHEN total_study_hours <= 250 THEN '<=250'
        WHEN total_study_hours <= 500 THEN '251-500'
        WHEN total_study_hours <= 750 THEN '501-750'
        WHEN total_study_hours <= 1000 THEN '751-1000'
        WHEN total_study_hours <= 1500 THEN '1001-1500'
        ELSE '1501+'
      END AS hours_band
    FROM language_learning_fluency
)
SELECT hours_band, COUNT(*) AS learners,
       ROUND(100.0 * AVG(reached_fluency),2) AS fluency_rate_pct,
       ROUND(100.0 * AVG(dropped_out),2) AS dropout_rate_pct
FROM banded
GROUP BY hours_band
ORDER BY MIN(total_study_hours);

-- 6. Related-language advantage
SELECT related_language, COUNT(*) AS learners,
       ROUND(100.0 * AVG(reached_fluency),2) AS fluency_rate_pct,
       ROUND(100.0 * AVG(dropped_out),2) AS dropout_rate_pct
FROM language_learning_fluency
GROUP BY related_language
ORDER BY related_language;

-- 7. SRS comparison
SELECT uses_srs, COUNT(*) AS learners,
       ROUND(100.0 * AVG(reached_fluency),2) AS fluency_rate_pct,
       ROUND(100.0 * AVG(dropped_out),2) AS dropout_rate_pct
FROM language_learning_fluency
GROUP BY uses_srs
ORDER BY uses_srs;

-- 8. Active-use share bands
WITH banded AS (
    SELECT *,
      CASE
        WHEN active_use_share <= .20 THEN '0-20%'
        WHEN active_use_share <= .40 THEN '21-40%'
        WHEN active_use_share <= .60 THEN '41-60%'
        WHEN active_use_share <= .80 THEN '61-80%'
        ELSE '81-100%'
      END AS active_use_band
    FROM language_learning_fluency
)
SELECT active_use_band, COUNT(*) AS learners,
       ROUND(100.0 * AVG(reached_fluency),2) AS fluency_rate_pct,
       ROUND(100.0 * AVG(dropped_out),2) AS dropout_rate_pct
FROM banded
GROUP BY active_use_band
ORDER BY MIN(active_use_share);

-- 9. Comprehensible-input quartiles
WITH ranked AS (
    SELECT *,
           NTILE(4) OVER (ORDER BY comprehensible_input_hours) AS input_quartile
    FROM language_learning_fluency
)
SELECT input_quartile, COUNT(*) AS learners,
       ROUND(AVG(comprehensible_input_hours),1) AS avg_input_hours,
       ROUND(100.0 * AVG(reached_fluency),2) AS fluency_rate_pct,
       ROUND(100.0 * AVG(dropped_out),2) AS dropout_rate_pct
FROM ranked
GROUP BY input_quartile
ORDER BY input_quartile;

-- 10. High-risk learner segment: low study volume + low active use
SELECT COUNT(*) AS high_risk_learners,
       ROUND(100.0 * AVG(reached_fluency),2) AS fluency_rate_pct,
       ROUND(100.0 * AVG(dropped_out),2) AS dropout_rate_pct
FROM language_learning_fluency
WHERE total_study_hours <= 250
  AND active_use_share <= .20;

-- 11. Strong-engagement segment: high study volume + high active use
SELECT COUNT(*) AS strong_engagement_learners,
       ROUND(100.0 * AVG(reached_fluency),2) AS fluency_rate_pct,
       ROUND(100.0 * AVG(dropped_out),2) AS dropout_rate_pct
FROM language_learning_fluency
WHERE total_study_hours >= 1000
  AND active_use_share >= .60;

-- 12. FSI x study volume: useful for differentiated learner strategy
WITH banded AS (
    SELECT *,
      CASE
        WHEN total_study_hours <= 500 THEN '<=500'
        WHEN total_study_hours <= 1000 THEN '501-1000'
        ELSE '1000+'
      END AS hours_band
    FROM language_learning_fluency
)
SELECT fsi_category, hours_band, COUNT(*) AS learners,
       ROUND(100.0 * AVG(reached_fluency),2) AS fluency_rate_pct,
       ROUND(100.0 * AVG(dropped_out),2) AS dropout_rate_pct
FROM banded
GROUP BY fsi_category, hours_band
ORDER BY fsi_category, MIN(total_study_hours);

-- 13. Numeric correlations (PostgreSQL)
SELECT
    corr(total_study_hours, reached_fluency) AS corr_study_hours,
    corr(comprehensible_input_hours, reached_fluency) AS corr_input,
    corr(active_use_share, reached_fluency) AS corr_active_use,
    corr(immersion_months, reached_fluency) AS corr_immersion,
    corr(fsi_category, reached_fluency) AS corr_fsi
FROM language_learning_fluency;
