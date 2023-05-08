"""
Calculates entropy over each participant from the experimental data, as given by its realizations, which are represented as a feature vector.

Usage:
    entropy.py --file=<f> --feat=<t>
    
Options:
   --file=<f>                       Provide file (dev.csv, test.csv, train.csv)
   --feat=<t>                       Provide file (feature_dict.json)
"""
import json
import time
import copy
import statistics
import pandas as pd
from copy import deepcopy
import scipy
from scipy.stats import entropy
from docopt import docopt

def entropy(df, feature_combs):
    """Calculates entropy for a given dataframe.

    Args:
        df (pandas.DataFrame): Dataframe with the column 'Exp_Subject_Id'
    """
    ents = {}
    participants = list(set(df['Exp_Subject_Id']))
    participants.sort()
    
    for participant in participants:
        subset = df[df['Exp_Subject_Id'] == participant]
        #print(participant, subset, len(subset))
        features = copy.deepcopy(feature_combs)
        
        # Compute counts of feature combinations     
        for line in zip(subset['Tensification'], subset['Nasalization'], subset['L_deletion'], subset['C_deletion'], subset['Lateralization']):
            features[str(line)] = features[str(line)] + 1
        #print(features)

        # Turn into proportions
        feat = list(features.values())
        proportions = [n / sum(feat) for n in feat]
        #print(proportions)

        # Compute entropy
        entropy_ = scipy.stats.entropy(proportions) 
        ents[participant] = entropy_
        #print(entropy_)
    
    vec = list(ents.values())
    ents['stats'] = {}
    ents['stats']['sd'] = statistics.stdev(vec)
    ents['stats']['mean'] = statistics.mean(vec)
    ents['stats']['min'] = min(vec)
    ents['stats']['max'] = max(vec)
    return ents        

if __name__ == "__main__":
    args = docopt(__doc__)
    file = args["--file"]
    features = args["--feat"]
    
    start_time = time.time()
    
    print('Reading Data...')
    df = pd.read_csv(file)
    with open(features) as f:
        feat = json.load(f)
    
    print('Calculating...')
    ents = entropy(df = df, feature_combs = feat)   
    with open('entropy_exp_participants.json', 'w') as f:
        json.dump(ents, f, indent = 2) 
    print(f'Completed in {time.time() - start_time} seconds')