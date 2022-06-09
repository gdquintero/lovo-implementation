import pandas as pd

weeks = 4
days = weeks * 7
predictedDays = 10
testDays = 100 # First 100 days of 2021
outliers = weeks

file = 'data.xlsx'
df = pd.read_excel(file)

with open('output/days.txt','w') as f:
	f.write('%i\n' % days)
	f.write('%i\n' % outliers)
	f.write('%i\n' % predictedDays)
	f.write('%i\n' % testDays)

with open('output/data.txt','w') as f:
	for i in range(len(df)):
		f.write('%f\n' % df.values[i])

file = 'data2.xlsx'
df = pd.read_excel(file)

with open('output/data2.txt','w') as f:
	for i in range(len(df)):
		f.write('%f\n' % df.values[i])