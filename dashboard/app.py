import duckdb
import streamlit as st
from pathlib import Path

DB_PATH = Path(__file__).parent.parent / "dev.duckdb"

st.set_page_config(page_title="Olist Retail Dashboard", layout="wide")
st.title("Retail & Customer Satisfaction Dashboard")

con = duckdb.connect(str(DB_PATH), read_only=True)

orders = con.execute("select * from fct_orders").df()
reviews = con.execute("select * from fct_order_reviews").df()

col1, col2, col3 = st.columns(3)
col1.metric("Total Orders", len(orders))
col2.metric("Avg Order Value", f"R$ {orders['order_value'].mean():.2f}")
col3.metric("Avg Review Score", f"{reviews['review_score'].mean():.2f} / 5")

st.subheader("Orders Over Time")
orders_by_day = orders.groupby(orders["ordered_at"].dt.date).size()
st.line_chart(orders_by_day)

st.subheader("Review Score Distribution")
st.bar_chart(reviews["review_score"].value_counts().sort_index())

st.subheader("Positive vs Negative Reviews")
st.bar_chart(reviews["is_positive_review"].value_counts())