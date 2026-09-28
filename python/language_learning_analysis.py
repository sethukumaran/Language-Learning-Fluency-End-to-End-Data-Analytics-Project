"""
Language Learning Fluency — End-to-End EDA
"""
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from pathlib import Path

DATA = Path("language_learning_fluency.csv")
FIG = Path("figures")
FIG.mkdir(exist_ok=True)

df = pd.read_csv(DATA)

# 1. Basic EDA
print("Shape:", df.shape)
print("\nData types:\n", df.dtypes)
print("\nMissing values:\n", df.isna().sum())
print("\nDuplicate rows:", df.duplicated().sum())
print("\nDuplicate learner IDs:", df["learner_id"].duplicated().sum())
print("\nDescriptive statistics:\n", df.describe(include="all").T)

# 2. Target KPIs
print("\nFluency rate:", round(df["reached_fluency"].mean()*100, 2), "%")
print("Dropout rate:", round(df["dropped_out"].mean()*100, 2), "%")

# 3. Categorical analysis
print("\nCEFR distribution:\n", df["cefr_level"].value_counts().sort_index())
print("\nFSI performance:\n", df.groupby("fsi_category")[["reached_fluency","dropped_out","total_study_hours"]].mean())

# 4. Correlation analysis
numeric = df.select_dtypes("number")
print("\nCorrelation with fluency:\n", numeric.corr()["reached_fluency"].sort_values(ascending=False))
print("\nCorrelation with dropout:\n", numeric.corr()["dropped_out"].sort_values())

# 5. Visualizations
def bar(data, x, y, title, xlabel, ylabel, filename, rotation=0):
    plt.figure(figsize=(10,6))
    plt.bar(data[x].astype(str), data[y])
    plt.title(title); plt.xlabel(xlabel); plt.ylabel(ylabel)
    plt.xticks(rotation=rotation)
    plt.tight_layout()
    plt.savefig(FIG/filename, dpi=160, bbox_inches="tight")
    plt.close()

cefr = df["cefr_level"].value_counts().reindex(["A0","A1","A2","B1","B2","C1","C2"]).fillna(0).reset_index()
cefr.columns = ["cefr_level","learners"]
bar(cefr,"cefr_level","learners","Learner distribution by CEFR level","CEFR level","Learners","01_cefr_distribution.png")

fsi = df.groupby("fsi_category").agg(fluency_rate=("reached_fluency","mean"),dropout_rate=("dropped_out","mean")).reset_index()
bar(fsi,"fsi_category","fluency_rate","Fluency rate by target-language difficulty","FSI category","Fluency rate","02_fluency_by_fsi.png")

bins=[0,250,500,750,1000,1500,5000]
labels=["<=250","251-500","501-750","751-1000","1001-1500","1501+"]
df["hours_band"]=pd.cut(df["total_study_hours"],bins=bins,labels=labels,include_lowest=True)
hours=df.groupby("hours_band",observed=True).agg(fluency_rate=("reached_fluency","mean"),dropout_rate=("dropped_out","mean")).reset_index()
bar(hours,"hours_band","fluency_rate","Fluency rate by total study hours","Study-hour band","Fluency rate","03_fluency_by_study_hours.png",30)
bar(hours,"hours_band","dropout_rate","Dropout rate by total study hours","Study-hour band","Dropout rate","04_dropout_by_study_hours.png",30)

active_bins=[-.01,.2,.4,.6,.8,1]
active_labels=["0-20%","21-40%","41-60%","61-80%","81-100%"]
df["active_band"]=pd.cut(df["active_use_share"],active_bins,labels=active_labels)
active=df.groupby("active_band",observed=True).agg(fluency_rate=("reached_fluency","mean"),dropout_rate=("dropped_out","mean")).reset_index()
bar(active,"active_band","fluency_rate","Fluency rate by active-use share","Active-use share","Fluency rate","05_fluency_by_active_use.png",20)

q=pd.qcut(df["comprehensible_input_hours"],4,duplicates="drop")
inp=df.assign(q=q).groupby("q",observed=True).agg(fluency_rate=("reached_fluency","mean"),dropout_rate=("dropped_out","mean")).reset_index()
bar(inp,"q","fluency_rate","Fluency rate by comprehensible-input quartile","Input quartile","Fluency rate","06_fluency_by_input.png",30)

df["immersion_band"]=pd.cut(df["immersion_months"],[-.01,0,3,6,12,100],labels=["0",">0-3",">3-6",">6-12","12+"])
imm=df.groupby("immersion_band",observed=True).agg(fluency_rate=("reached_fluency","mean"),dropout_rate=("dropped_out","mean")).reset_index()
bar(imm,"immersion_band","fluency_rate","Fluency rate by immersion exposure","Immersion months","Fluency rate","07_fluency_by_immersion.png",20)

corr=numeric.corr()["reached_fluency"].drop("reached_fluency").sort_values()
plt.figure(figsize=(10,7)); plt.barh(corr.index,corr.values); plt.axvline(0,linewidth=1)
plt.title("Correlation of numeric variables with reaching fluency")
plt.xlabel("Pearson correlation")
plt.tight_layout(); plt.savefig(FIG/"08_fluency_correlations.png",dpi=160,bbox_inches="tight"); plt.close()

sample=df.sample(min(5000,len(df)),random_state=42)
plt.figure(figsize=(10,6)); plt.scatter(sample["total_study_hours"],sample["comprehensible_input_hours"],alpha=.25)
plt.xlabel("Total study hours"); plt.ylabel("Comprehensible input hours")
plt.title("Study volume vs. comprehensible input")
plt.tight_layout(); plt.savefig(FIG/"09_study_vs_input_scatter.png",dpi=160,bbox_inches="tight"); plt.close()

# Export a compact summary
summary = pd.DataFrame({
    "metric": ["learners","fluency_rate_pct","dropout_rate_pct","avg_study_hours","avg_input_hours","avg_active_use_share"],
    "value": [
        len(df), df["reached_fluency"].mean()*100, df["dropped_out"].mean()*100,
        df["total_study_hours"].mean(), df["comprehensible_input_hours"].mean(),
        df["active_use_share"].mean()
    ]
})
summary.to_csv("analysis_summary.csv",index=False)
print("\nAnalysis complete. Figures saved to ./figures/")
