import streamlit as st
import pandas as pd
import numpy as np
import plotly.express as px

st.set_page_config(
    page_title="{{APP_NAME}}",
    page_icon="📊",
    layout="wide"
)

st.title("{{APP_NAME}}")
st.write("Welcome to your new Streamlit application!")

# Sidebar
with st.sidebar:
    st.header("Configuration")
    num_points = st.slider("Number of data points", 10, 1000, 100)
    chart_type = st.selectbox("Chart type", ["scatter", "line", "bar"])

# Main content
st.header("Sample Data Visualization")

# Generate sample data
np.random.seed(42)
data = pd.DataFrame({
    'x': np.random.randn(num_points),
    'y': np.random.randn(num_points),
    'category': np.random.choice(['A', 'B', 'C'], num_points)
})

# Create visualization based on selection
if chart_type == "scatter":
    fig = px.scatter(data, x='x', y='y', color='category', title="Scatter Plot")
elif chart_type == "line":
    fig = px.line(data.sort_values('x'), x='x', y='y', color='category', title="Line Chart")
else:  # bar
    agg_data = data.groupby('category')['y'].mean().reset_index()
    fig = px.bar(agg_data, x='category', y='y', title="Bar Chart")

st.plotly_chart(fig, use_container_width=True)

# Data table
with st.expander("View Raw Data"):
    st.dataframe(data, use_container_width=True)

# Metrics
col1, col2, col3 = st.columns(3)
with col1:
    st.metric("Total Points", len(data))
with col2:
    st.metric("Mean X", f"{data['x'].mean():.2f}")
with col3:
    st.metric("Mean Y", f"{data['y'].mean():.2f}")

st.success("Your app is working! Customize this template to build your application.")