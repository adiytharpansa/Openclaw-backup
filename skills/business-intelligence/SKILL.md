# Business-Intelligence Skill

## Deskripsi
Advanced analytics, forecasting, dan decision intelligence untuk analisis pasar, perilaku pelanggan, forecasting revenue, risk assessment, dan strategic business planning dengan predictive analytics dan scenario planning.

## Kapan Digunakan
- Business planning & strategic decision making
- Market trend analysis & competitor intelligence
- Customer behavior analysis & segmentation
- Revenue forecasting & financial modeling
- Investment decisions & risk assessment
- Performance optimization & KPI tracking
- Market expansion analysis
- Pricing strategy optimization
- Customer lifecycle management

## Fitur Utama

### 1. Predictive Analytics
```
├── Time Series Forecasting
├── Regression Analysis
├── Classification Models
├── Clustering & Segmentation
├── Anomaly Detection
├── Recommendation Engines
└── Survival Analysis
```

### 2. Business Intelligence
```
├── KPI Dashboard
├── Performance Metrics
├── Trend Analysis
├── Cohort Analysis
├── Funnel Analysis
├── Attribution Modeling
└── ROI Calculation
```

### 3. Financial Modeling
```
├── Revenue Forecasting
├── Cost Analysis
├── Profit Margins
├── Cash Flow Projection
├── Break-even Analysis
├── NPV & IRR Calculation
└── Budget Planning
```

### 4. Market Intelligence
```
├── Competitor Analysis
├── Market Sizing
├── Trend Detection
├── Sentiment Analysis
├── SWOT Analysis
├── PESTLE Analysis
└── Market Entry Strategy
```

## Architecture

```
┌──────────────────────────────────────────────────────────┐
│                  BUSINESS INTELLIGENCE                   │
├──────────────────────────────────────────────────────────┤
│   Data Warehouse │  ML Models  │  Dashboard  │  Reporting│
└──────────┬───────────────┬───────────────┴──────┬────────┘
           │               │                     │
    ┌──────▼──────┐ ┌─────▼──────┐      ┌──────▼──────┐
    │   PostgreSQL│ |   Scikit   │      │   Tableau   │
    │   Redshift  | |   TensorFlow│     │   Power BI  │
    │   BigQuery  │ |   PyTorch  │      │   Metabase  │
    └─────────────┘ └────────────┘      └─────────────┘
```

## Commands

### Analytics & Forecasting
```bash
# Revenue forecasting
./scripts/bi.sh forecast --metric revenue --horizon 12 months --confidence 95%

# Customer churn prediction
./scripts/bi.sh churn --predict --threshold 0.7 --output customers-at-risk.csv

# Sales trend analysis
./scripts/bi.sh trend --metric sales --period 2026 --granularity monthly

# Demand forecasting
./scripts/bi.sh demand --product all --location warehouse-1 --horizon 90 days
```

### Market Analysis
```bash
# Competitor intelligence
./scripts/bi.sh market competitor --analyze --competitors direct-competitors.json --output report

# Market sizing
./scripts/bi.sh market sizing --industry SaaS --region North America --output market-opportunity.json

# Sentiment analysis
./scripts/bi.sh sentiment --source twitter,reddit,news --brand our-brand --period 30d

# Market entry analysis
./scripts/bi.sh market entry --product mobile-app --target-market SE Asia --factors cost,labor,regulation
```

### Customer Analytics
```bash
# Customer segmentation
./scripts/bi.sh customer segment --algorithm kmeans --clusters 5 --features purchase,engagement,recency

# Cohort analysis
./scripts/bi.sh cohort --metric retention --cohort signup_month --period 12 months

# Customer lifetime value
./scripts/bi.sh clv --calculate --segments premium,standard,free

# Churn analysis
./scripts/bi.sh churn --analyze --factors pricing,support,features --output churn-risks.md
```

### Financial Analysis
```bash
# Revenue projection
./scripts/bi.sh finance revenue --base 2025-data --scenarios base,best,worst --output projections.xlsx

# Cost optimization
./scripts/bi.sh finance costs --analyze --category infrastructure,marketing,salaries

# Break-even analysis
./scripts/bi.sh finance break-even --product product-name --price 99 --fixed-costs 50000 --variable-cost 20

# ROI calculation
./scripts/bi.sh finance roi --campaign marketing-2026 --revenue 500000 --cost 100000 --period 12 months
```

### Strategic Planning
```bash
# SWOT analysis
./scripts/bi.sh strategy swot --company our-company --output swot-analysis.md --team 10

# Scenario planning
./scripts/bi.sh strategy scenarios --base current --pessimistic recession --optimistic growth --timeframe 3 years

# KPI dashboard
./scripts/bi.sh dashboard --kpi revenue,customers,retention,clv --visualize true --export report.html

# Investment analysis
./scripts/bi.sh strategy investment --opportunity new-market --npv-analysis true --irr-threshold 15%
```

## Implementation

### Forecasting Engine
```python
#!/usr/bin/env python3
"""
Business Intelligence - Forecasting Engine
Time series forecasting and predictive analytics
"""

import pandas as pd
import numpy as np
from typing import Dict, List, Optional
from dataclasses import dataclass
from datetime import datetime, timedelta
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error, r2_score
import statsmodels.api as sm
from statsmodels.tsa.holtwinters import ExponentialSmoothing

@dataclass
class ForecastConfig:
    horizon: int  # Number of periods to forecast
    confidence_level: float = 0.95
    seasonality: str = "auto"  # daily, weekly, monthly, quarterly
    model: str = "auto"  # auto, arima, prophet, exponential

class ForecastingEngine:
    def __init__(self, config: ForecastConfig):
        self.config = config
        self.models = {}
        self.history = []
    
    def fit(self, historical_data: pd.Series, freq: str = "D"):
        """Fit forecasting model to historical data"""
        
        # Convert to DataFrame with datetime index
        df = pd.DataFrame({
            'value': historical_data.values
        }, index=pd.date_range(end=datetime.now(), periods=len(historical_data), freq=freq))
        
        # Try multiple models
        models = {
            'arima': self._fit_arima(df),
            'exponential': self._fit_exponential(df),
            'prophet': self._fit_prophet(df),
            'random_forest': self._fit_random_forest(df)
        }
        
        # Select best model
        self.models = models
        best_model = min(models.items(), key=lambda x: x[1]['mae'])
        self.best_model = best_model[0]
        self.best_model_data = best_model[1]
        
        self.history = df
    
    def _fit_arima(self, df: pd.DataFrame) -> dict:
        """Fit ARIMA model"""
        try:
            model = sm.tsa.ARIMA(
                df['value'],
                order=(5, 1, 0)
            )
            results = model.fit()
            
            forecast = results.get_forecast(steps=self.config.horizon)
            conf_int = forecast.conf_int(alpha=1 - self.config.confidence_level)
            
            return {
                'model': results,
                'forecast': forecast.predicted_mean,
                'conf_int_lower': conf_int.iloc[:, 0],
                'conf_int_upper': conf_int.iloc[:, 1],
                'mae': 0  # To be calculated
            }
        except Exception as e:
            return {'error': str(e)}
    
    def _fit_exponential(self, df: pd.DataFrame) -> dict:
        """Fit Exponential Smoothing model"""
        try:
            # Determine seasonality
            seasonality = 12 if self.config.seasonality == "monthly" else 7 if self.config.seasonality == "weekly" else 1
            
            model = ExponentialSmoothing(
                df['value'],
                trend='add',
                seasonal=seasonality if seasonality > 1 else None,
                seasonal_periods=seasonality
            )
            fitted = model.fit()
            
            forecast = fitted.forecast(self.config.horizon)
            
            return {
                'model': fitted,
                'forecast': forecast,
                'conf_int_lower': None,
                'conf_int_upper': None,
                'mae': 0
            }
        except Exception as e:
            return {'error': str(e)}
    
    def _fit_prophet(self, df: pd.DataFrame) -> dict:
        """Fit Prophet model"""
        try:
            from prophet import Prophet
            
            prophet_df = df.reset_index()
            prophet_df.columns = ['ds', 'y']
            
            model = Prophet(
                yearly_seasonality=self.config.seasonality == "yearly",
                weekly_seasonality=self.config.seasonality == "weekly",
                daily_seasonality=self.config.seasonality == "daily"
            )
            model.fit(prophet_df)
            
            future = model.make_future_dataframe(periods=self.config.horizon)
            forecast = model.predict(future)
            
            return {
                'model': model,
                'forecast': forecast[['ds', 'yhat', 'yhat_lower', 'yhat_upper']].tail(self.config.horizon),
                'conf_int_lower': None,
                'conf_int_upper': None,
                'mae': 0
            }
        except Exception as e:
            return {'error': str(e)}
    
    def _fit_random_forest(self, df: pd.DataFrame) -> dict:
        """Fit Random Forest model with lag features"""
        try:
            # Create lag features
            df['lag_1'] = df['value'].shift(1)
            df['lag_7'] = df['value'].shift(7) if self.config.seasonality in ['weekly', 'auto'] else None
            df['lag_30'] = df['value'].shift(30) if self.config.seasonality in ['monthly', 'auto'] else None
            df = df.dropna()
            
            X = df.drop('value', axis=1)
            y = df['value']
            
            model = RandomForestRegressor(n_estimators=100, random_state=42)
            model.fit(X, y)
            
            # Simple backtest for MAE
            y_pred = model.predict(X)
            mae = mean_absolute_error(y, y_pred)
            
            # Forecast future values
            last_values = df['value'].tail(7 if self.config.seasonality == 'weekly' else 30).values
            future_features = pd.DataFrame({
                'lag_1': [last_values[-1]] * self.config.horizon,
                'lag_7': [last_values[-7]] * self.config.horizon if self.config.seasonality == 'weekly' else [0] * self.config.horizon
            })
            
            forecast = model.predict(future_features)
            
            return {
                'model': model,
                'forecast': pd.Series(forecast),
                'conf_int_lower': None,
                'conf_int_upper': None,
                'mae': mae
            }
        except Exception as e:
            return {'error': str(e)}
    
    def forecast(self) -> Dict:
        """Generate forecast"""
        if not self.best_model_data:
            raise ValueError("No model fitted. Call fit() first.")
        
        forecast_data = self.best_model_data['forecast']
        
        # Generate prediction intervals if available
        if self.best_model_data.get('conf_int_lower') is not None:
            prediction_interval = {
                'lower': self.best_model_data['conf_int_lower'].values,
                'upper': self.best_model_data['conf_int_upper'].values
            }
        elif self.best_model == 'prophet':
            forecast_df = self.best_model_data['forecast']
            prediction_interval = {
                'lower': forecast_df['yhat_lower'].values,
                'upper': forecast_df['yhat_upper'].values
            }
        else:
            # Approximate prediction interval using historical variance
            historical_variance = self.history['value'].std()
            z_score = 1.96 if self.config.confidence_level == 0.95 else 2.58
            prediction_interval = {
                'lower': forecast_data - z_score * historical_variance,
                'upper': forecast_data + z_score * historical_variance
            }
        
        return {
            'model': self.best_model,
            'forecast': forecast_data.values,
            'prediction_interval': prediction_interval,
            'confidence_level': self.config.confidence_level,
            'horizon': self.config.horizon,
            'mae': self.best_model_data.get('mae', 0),
            'generated_at': datetime.now().isoformat()
        }

# Example usage
if __name__ == "__main__":
    # Generate historical revenue data
    np.random.seed(42)
    revenue = pd.Series(
        np.cumsum(np.random.randn(365)) + 1000 * np.arange(365) / 365,
        index=pd.date_range(end=datetime.now(), periods=365, freq="D")
    )
    
    config = ForecastConfig(horizon=30, confidence_level=0.95, seasonality="weekly")
    engine = ForecastingEngine(config)
    
    engine.fit(revenue, freq="D")
    forecast = engine.forecast()
    
    print(f"Best model: {forecast['model']}")
    print(f"Forecast horizon: {forecast['horizon']} days")
    print(f"Mean Absolute Error: {forecast['mae']:.2f}")
    print(f"\nNext 30 days forecast:")
    for i, pred in enumerate(forecast['forecast'][:30]):
        lower = forecast['prediction_interval']['lower'][i]
        upper = forecast['prediction_interval']['upper'][i]
        print(f"  Day {i+1}: {pred:.2f} [{lower:.2f} - {upper:.2f}]")
```

### Customer Segmentation
```python
#!/usr/bin/env python3
"""
Business Intelligence - Customer Segmentation
K-means clustering for customer behavior analysis
"""

import pandas as pd
import numpy as np
from typing import Dict, List
from sklearn.cluster import KMeans
from sklearn.preprocessing import StandardScaler
from dataclasses import dataclass

@dataclass
class CustomerSegment:
    id: int
    name: str
    size: int
    avg_value: float
    avg_frequency: float
    avg_recency: int
    characteristics: Dict[str, any]

class CustomerSegmentation:
    def __init__(self, n_clusters: int = 5):
        self.n_clusters = n_clusters
        self.scaler = StandardScaler()
        self.kmeans = None
    
    def fit(self, customer_data: pd.DataFrame, features: List[str]) -> Dict:
        """Segment customers based on features"""
        
        # Prepare features
        X = customer_data[features].values
        
        # Scale features
        X_scaled = self.scaler.fit_transform(X)
        
        # Fit K-means
        self.kmeans = KMeans(n_clusters=self.n_clusters, random_state=42, n_init=10)
        clusters = self.kmeans.fit_predict(X_scaled)
        
        # Assign clusters to customers
        customer_data['cluster'] = clusters
        
        # Analyze each segment
        segments = []
        for cluster_id in range(self.n_clusters):
            cluster_data = customer_data[customer_data['cluster'] == cluster_id]
            
            segment = CustomerSegment(
                id=cluster_id,
                name=self._generate_segment_name(cluster_id, cluster_data),
                size=len(cluster_data),
                avg_value=cluster_data['lifetime_value'].mean(),
                avg_frequency=cluster_data['purchase_frequency'].mean(),
                avg_recency=cluster_data['days_since_last_purchase'].mean(),
                characteristics={
                    'demographics': cluster_data['demographics'].mode().to_dict(),
                    'behavior': cluster_data['behavior'].mode().to_dict(),
                    'engagement': {
                        'avg_sessions': cluster_data['avg_sessions'].mean(),
                        'avg_session_duration': cluster_data['avg_session_duration'].mean()
                    }
                }
            )
            segments.append(segment)
        
        return {
            'segments': segments,
            'cluster_distribution': customer_data['cluster'].value_counts().to_dict(),
            'model_performance': {
                'silhouette_score': self._calculate_silhouette_score(X_scaled),
                'inertia': self.kmeans.inertia_
            },
            'cluster_centers': self.kmeans.cluster_centers_.tolist()
        }
    
    def _generate_segment_name(self, cluster_id: int, data: pd.DataFrame) -> str:
        """Generate descriptive segment name"""
        avg_value = data['lifetime_value'].mean()
        avg_frequency = data['purchase_frequency'].mean()
        avg_recency = data['days_since_last_purchase'].mean()
        
        if avg_value > 1000 and avg_frequency > 10:
            return "VIP High-Value Frequent"
        elif avg_value > 500 and avg_frequency > 5:
            return "Regular High-Value"
        elif avg_frequency > 5:
            return "Frequent Value"
        elif avg_value > 500:
            return "High-Value Occasional"
        elif avg_recency < 30:
            return "Recent New Customer"
        else:
            return "At-Risk"
    
    def _calculate_silhouette_score(self, X: np.ndarray) -> float:
        """Calculate silhouette score for cluster quality"""
        from sklearn.metrics import silhouette_score
        return silhouette_score(X, self.kmeans.labels_)
    
    def get_segment_customers(self, customer_data: pd.DataFrame, segment_id: int) -> pd.DataFrame:
        """Get customers in specific segment"""
        return customer_data[customer_data['cluster'] == segment_id]
```

### Financial Forecasting
```python
#!/usr/bin/env python3
"""
Business Intelligence - Financial Forecasting
Revenue, cost, and profit forecasting
"""

from dataclasses import dataclass
from typing import Dict, List
from datetime import datetime
import pandas as pd
import numpy as np

@dataclass
class FinancialScenario:
    name: str
    revenue: float
    costs: float
    profit: float
    growth_rate: float
    assumptions: Dict[str, any]

class FinancialForecaster:
    def __init__(self, historical_data: pd.DataFrame):
        self.historical = historical_data
        self.scenarios = {}
    
    def create_scenarios(self, base_growth: float = 0.1, 
                        pessimistic_factor: float = 0.7,
                        optimistic_factor: float = 1.3) -> Dict:
        """Create base, pessimistic, and optimistic scenarios"""
        
        # Base scenario
        base_revenue = self._calculate_base_revenue(base_growth)
        base_costs = self._calculate_costs(base_revenue)
        
        self.scenarios['base'] = FinancialScenario(
            name="Base Case",
            revenue=base_revenue,
            costs=base_costs,
            profit=base_revenue - base_costs,
            growth_rate=base_growth,
            assumptions={
                "revenue_growth": f"{base_growth:.1%}",
                "cost_ratio": f"{base_costs/base_revenue:.1%}"
            }
        )
        
        # Pessimistic scenario
        pess_revenue = base_revenue * pessimistic_factor
        pess_costs = base_costs * 1.1  # Costs typically increase in downturn
        
        self.scenarios['pessimistic'] = FinancialScenario(
            name="Pessimistic Case",
            revenue=pess_revenue,
            costs=pess_costs,
            profit=pess_revenue - pess_costs,
            growth_rate=base_growth * pessimistic_factor,
            assumptions={
                "revenue_growth": f"{base_growth * pessimistic_factor:.1%}",
                "cost_ratio": f"{pess_costs/pess_revenue:.1%}",
                "market_condition": "recession"
            }
        )
        
        # Optimistic scenario
        opt_revenue = base_revenue * optimistic_factor
        opt_costs = base_costs * 0.95  # Economies of scale
        
        self.scenarios['optimistic'] = FinancialScenario(
            name="Optimistic Case",
            revenue=opt_revenue,
            costs=opt_costs,
            profit=opt_revenue - opt_costs,
            growth_rate=base_growth * optimistic_factor,
            assumptions={
                "revenue_growth": f"{base_growth * optimistic_factor:.1%}",
                "cost_ratio": f"{opt_costs/opt_revenue:.1%}",
                "market_condition": "growth"
            }
        )
        
        return self.scenarios
    
    def _calculate_base_revenue(self, growth_rate: float) -> float:
        """Calculate base revenue projection"""
        last_year_revenue = self.historical['revenue'].iloc[-1]
        return last_year_revenue * (1 + growth_rate)
    
    def _calculate_costs(self, revenue: float) -> float:
        """Calculate costs as percentage of revenue"""
        # Historical cost ratio
        cost_ratio = self.historical['costs'].mean() / self.historical['revenue'].mean()
        return revenue * cost_ratio
    
    def roi_analysis(self, investment: float, expected_return: float, 
                     period: int = 12) -> Dict:
        """Analyze investment ROI"""
        
        total_return = investment + expected_return
        roi = ((total_return - investment) / investment) * 100
        
        # Payback period
        monthly_return = expected_return / period
        payback_months = investment / monthly_return if monthly_return > 0 else float('inf')
        
        return {
            "investment": investment,
            "expected_return": expected_return,
            "total_return": total_return,
            "roi_percentage": roi,
            "payback_months": payback_months,
            "roi_per_month": roi / period
        }
    
    def generate_financial_report(self) -> Dict:
        """Generate comprehensive financial report"""
        report = {
            "generated_at": datetime.now().isoformat(),
            "scenarios": {
                name: {
                    "revenue": f"${scenario.revenue:,.2f}",
                    "costs": f"${scenario.costs:,.2f}",
                    "profit": f"${scenario.profit:,.2f}",
                    "growth_rate": scenario.assumptions.get("revenue_growth", "N/A"),
                    "cost_ratio": scenario.assumptions.get("cost_ratio", "N/A")
                }
                for name, scenario in self.scenarios.items()
            },
            "summary": {
                "best_case_profit": max(s.profit for s in self.scenarios.values()),
                "worst_case_profit": min(s.profit for s in self.scenarios.values()),
                "base_case_roi": self.roi_analysis(
                    self.historical['investment'].iloc[-1],
                    self.historical['return'].iloc[-1]
                )
            }
        }
        
        return report

# Usage example
if __name__ == "__main__":
    # Generate sample historical data
    np.random.seed(42)
    dates = pd.date_range(start='2025-01-01', periods=12, freq='M')
    historical = pd.DataFrame({
        'date': dates,
        'revenue': 100000 * (1 + np.cumsum(np.random.randn(12) * 0.1)),
        'costs': 60000 * (1 + np.cumsum(np.random.randn(12) * 0.05)),
        'investment': 10000 * np.ones(12),
        'return': 50000 * (1 + np.random.randn(12) * 0.2)
    })
    
    forecaster = FinancialForecaster(historical)
    scenarios = forecaster.create_scenarios(base_growth=0.15)
    
    print("Financial Scenarios:")
    for name, scenario in scenarios.items():
        print(f"\n{name.upper()}:")
        print(f"  Revenue: ${scenario.revenue:,.2f}")
        print(f"  Costs: ${scenario.costs:,.2f}")
        print(f"  Profit: ${scenario.profit:,.2f}")
        print(f"  Growth: {scenario.assumptions.get('revenue_growth', 'N/A')}")
```

## Integration Points

### With BI Tools
```yaml
# Tableau Data Source Configuration
data_source:
  connection:
    type: postgresql
    host: bi-db.internal
    port: 5432
    database: business_intelligence
    schema: analytics
  
  tables:
    - revenue_daily
    - customer_transactions
    - product_performance
    - marketing_campaigns
  
  refresh:
    schedule: "0 6 * * *"  # Daily at 6 AM
    incremental: true
```

### Dashboard Configuration
```python
dashboard_config = {
    "name": "Executive Dashboard",
    "refresh_interval": "5 minutes",
    "widgets": [
        {
            "type": "kpi",
            "title": "Revenue",
            "metric": "total_revenue",
            "trend": "+12% vs last month",
            "color": "green"
        },
        {
            "type": "line_chart",
            "title": "Revenue Trend",
            "metric": "revenue",
            "period": "12 months",
            "comparison": "vs last year"
        },
        {
            "type": "bar_chart",
            "title": "Customer Segments",
            "metric": "segment_distribution",
            "sort": "descending"
        },
        {
            "type": "funnel",
            "title": "Sales Funnel",
            "stages": ["leads", "qualified", "proposal", "closed"],
            "conversion_rate": "23%"
        },
        {
            "type": "scatter",
            "title": "CLV vs Acquisition Cost",
            "x": "acquisition_cost",
            "y": "clv",
            "bubble_size": "customer_count"
        }
    ]
}
```

## Best Practices

### Data Quality
```yaml
data_quality:
  completeness: >95%
  accuracy: >98%
  timeliness: daily
  consistency: validated
  validation_rules:
    - null_check: required
    - range_check: enabled
    - format_check: enabled
    - referential_integrity: enforced
```

### KPI Selection
```yaml
kpis:
  financial:
    - revenue_growth
    - gross_margin
    - net_profit_margin
    - cash_flow
    - roi
  
  customer:
    - customer_acquisition_cost
    - customer_lifetime_value
    - churn_rate
    - net_promoter_score
    - customer_satisfaction
  
  operational:
    - employee_productivity
    - cycle_time
    - quality_score
    - inventory_turnover
    - order_fulfillment_rate
```

---

**Version:** 1.0  
**Created:** 2026-04-10  
**Author:** Oozu for Tuan  
**Status:** Active  
**Priority:** ⭐⭐⭐⭐⭐
