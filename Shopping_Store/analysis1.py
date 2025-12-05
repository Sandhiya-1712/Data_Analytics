import mysql.connector
from sqlalchemy import create_engine
from urllib.parse import quote_plus
import pandas as pd
df = pd.read_csv("customer_shopping_behavior.csv")
print(df.head())
print(df.info())
print(df.describe(include="all"))
print(df.isnull().sum())
df['Review Rating'] = df.groupby('Category')['Review Rating'].transform(lambda x: x.fillna(x.median()))
print(df.isnull().sum())
df.columns = df.columns.str.lower()
df.columns = df.columns.str.replace(' ','_')
print(df.columns)
df = df.rename(columns={'purchase_amount_(usd)':'purchase_amount'})
# create a column named age_group
labels = ['Young-Adult', 'Adult', 'Middle-aged', 'Senior']
df['age_group']=pd.qcut(df['age'],q=4, labels=labels)
print(df[['age','age_group']].head(10))
# create column purchase frequency days
frequency_mapping = {
    'Fortnightly':14,
    'Weekly':7,
    'Monthly':30,
    'Quarterly':90,
    'Bi-Weekly':14,
    'Annually':365,
    'Every 3 Months':90
}
df['purchase_frequency_days'] = df['frequency_of_purchases'].map(frequency_mapping)
print(df[['purchase_frequency_days','frequency_of_purchases']].head(10))
print(df[['discount_applied','promo_code_used']].head(10))
y=(df['discount_applied'] == df['promo_code_used']).all()
print(y)
df = df.drop('promo_code_used', axis=1)
print(df.columns)

## step 1: connect to mysql
#replace placeholders with our actual details

host="localhost"
user="root"
password=quote_plus("Sandhi@17")
database="customer_behaviour"

# Using mysql-connector
#engine = create_engine("mysql+mysqlconnector://root:Sandhi@17@localhost/mydb")
engine = create_engine(f"mysql+mysqlconnector://{user}:{password}@{host}/{database}")



#load dataframe into mysql
table_name = "customer"
df.to_sql(table_name,engine,if_exists="replace",index=False)

print("Data successfully loaded into table '{table_name}' in database '{database}'.")

print(pd.read_sql("SELECT * FROM customer LIMIT 5;", engine))
