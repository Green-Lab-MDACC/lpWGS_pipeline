import sys
import pandas as pd
import os
import csv

sample_id = sys.argv[1]
wd = os.getcwd()
file_name = str(sample_id) + '.csv'
file_path = os.path.join(str(wd), 'data', sample_id, 'CNAprofiles', file_name)
df = pd.read_csv(file_path)
os.remove(file_path)
df = df.drop(['num.mark'], axis=1)
df = df.rename(columns={'chrom': 'chr'})
df['ID'] = sample_id
df = df.drop(['Unnamed: 0'], axis=1)
file_name = str(sample_id) + '_filtered' + '.csv'
df.to_csv(file_path, index=False, sep='\t')
txt_file_name = str(sample_id) + '.txt'
txt_file = os.path.join(str(wd), 'data', sample_id, 'CNAprofiles', txt_file_name)
with open(txt_file, "w") as my_output_file:
    with open(file_path, "r") as my_input_file:
        [ my_output_file.write(" ".join(row)+'\n') for row in csv.reader(my_input_file)]
    my_output_file.close()