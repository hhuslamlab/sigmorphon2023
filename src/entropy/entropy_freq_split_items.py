"""
Calculates entropy over each frequency category (nonce, low, high) for the items from the experimental data, as given by the item realizations, which are represented as its feature vector.

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
    freq_types = list(set(df['Frequency']))
    freq_types.sort()
    
    for freq in freq_types:
        freq_df = df[df['Frequency'] == freq]
        
        items = list(set(freq_df['Word_romanization']))
        items.sort()
        
        ents[freq] = {}
        
        for item in items:
            subset = freq_df[freq_df['Word_romanization'] == item]
            
            #print(item, subset, len(subset))
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
            ents[freq][item] = entropy_
            #print(entropy_)
    
    # Compute evaluation metris for each frequency class 
    ents['stats'] = {}
    for freq in freq_types:
        vec = list(ents[freq].values())
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
    with open('entropy_exp_items_freqsplit.json', 'w') as f:
        json.dump(ents, f, indent = 2) 
    
    print(f'Completed in {time.time() - start_time} seconds')