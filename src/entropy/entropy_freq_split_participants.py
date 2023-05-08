"""
Calculates entropy over each frequency category (nonce, low, high) for all participants from the experimental data, as given by their item realizations, which are represented as a feature vector of that item. 

Usage:
    entropy.py --file=<f> --feat=<t>
    
Options:
   --file=<f>                       Provide file (dev.csv, test.csv, train.csv)
   --feat=<t>                       Provide file (feature_dict.json)
"""
import json
import time 
import statistics
from docopt import docopt
import pandas as pd
import scipy
from scipy.stats import entropy
import copy
from copy import deepcopy

def entropy(df, feature_combs):
    """Calculates entropy for a given dataframe.

    Args:
        df (pandas.DataFrame): Dataframe with the column 'Word_romanization'
    """
    ents = {}
    participants = list(set(df['Exp_Subject_Id']))
    participants.sort()
    freq_types = list(set(df['Frequency']))
    freq_types.sort()
    
    for participant in participants:
        subset = df[df['Exp_Subject_Id'] == participant]
    
        # freq_types = list(set(subset['Frequency']))
        # freq_types.sort()
        
        ents[participant] = {}
        
        for freq in freq_types:
            freq_df = subset[subset['Frequency'] == freq]
            
            #print(participant, freq, freq_df, len(freq_df))
            features = copy.deepcopy(feature_combs)
            
            # Compute counts of feature combinations     
            for line in zip(freq_df['Tensification'], freq_df['Nasalization'], freq_df['L_deletion'], freq_df['C_deletion'], freq_df['Lateralization']):
                features[str(line)] = features[str(line)] + 1
            #print(features)

            # Turn into proportions
            feat = list(features.values())
            proportions = [n / sum(feat) for n in feat]
            #print(proportions)

            # Compute entropy
            entropy_ = scipy.stats.entropy(proportions) 
            ents[participant][freq] = entropy_
            #print(entropy_)
    
    # Compute evaluation metris for each frequency class     
    ents['stats'] = {}
    for freq in freq_types:
        vec = []
        for participant in participants:
            #vec.append(list(ents[participant][freq].values()))
            vec.append(ents[participant][freq])
        
        ents['stats'][freq] = {}
        ents['stats'][freq]['sd'] = statistics.stdev(vec)
        ents['stats'][freq]['mean'] = statistics.mean(vec)
        ents['stats'][freq]['min'] = min(vec)
        ents['stats'][freq]['max'] = max(vec)
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
    with open('entropy_exp_participants_freqsplit.json', 'w') as f:
        json.dump(ents, f, indent = 2) 
    
    print(f'Completed in {time.time() - start_time} seconds')