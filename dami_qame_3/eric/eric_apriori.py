import re
from collections import defaultdict
from itertools import product


class SequentialPattern(object):
    """Represents a sequential pattern."""

    def __init__(self, items, support):
        self.items = items
        self.support = support

    def __repr__(self):
        return "< {} > ({:.3g})".format(", ".join(self.items), self.support)

def read_data_sequences(filename):
    """Read data sequences from a file containing lines of the format:
        { item_id item_id }{ item_id }...{item_id item_id item_id} etc."""
    data_sequences = []
    for f in open(filename, "r"):
        data_sequence = []
        for element in re.findall(r"{[\w\s]+}", f):
            data_sequence.append(re.findall(r"\w+", element))
        data_sequences.append(data_sequence)
    return data_sequences

def apriori(data_sequences, minsup, maxspan=3):
    """Apriori-like algorithm for mining sequential patterns."""
    frequent_seqs = []
    n = len(data_sequences)

    frequent_seqs.append(find_frequent_1_subsequences(data_sequences, minsup))

    while frequent_seqs[-1]:
        frequent_seqs.append([])
        candidates = apriori_gen(frequent_seqs[-2])

        for candidate in candidates:
            support = calculate_support(candidate, data_sequences)
            if support >= minsup:
                pattern = SequentialPattern(candidate, support)
                frequent_seqs[-1].append(pattern)

    return sorted(flatten(frequent_seqs),
            key=lambda x: x.support, reverse=True)



def find_frequent_1_subsequences(data_sequences, minsup):
    """Find all frequent 1-subsequences."""
    support_counts = defaultdict(int)
    n = len(data_sequences)

    # Calculate support counts
    for data_sequence in data_sequences:
        for item in remove_duplicates(flatten(data_sequence)):
            support_counts[item] += 1

    # Filter subsequences above minsup
    frequent_seqs = []
    for k,v in support_counts.items():
        support = v / n
        if support >= minsup:
            frequent_seqs.append(SequentialPattern([k], support))
    return frequent_seqs

def apriori_gen(prev_subsequences):
    """Generate candidate k-subsequences given frequent k-1 subsequences."""
    candidates = []
    prev_subsequences = map(lambda pattern: pattern.items, prev_subsequences)
    for seq1, seq2 in product(prev_subsequences, repeat=2):
        if seq1[1:] == seq2[:-1]:
            candidates.append(seq1 + [seq2[-1]])
    print("Generated {} candidates.".format(len(candidates)))
    return candidates

def calculate_support(candidate, data_sequences):
    """Given a candidate's support given a list of data sequences."""
    support_count = 0
    for data_sequence in data_sequences:
        if occurs(candidate, data_sequence):
            support_count += 1
    return support_count / len(data_sequences)

def occurs(candidate, data_sequence):
    """Check whether given candidate sequence occurs in given data sequence."""
    i = 0
    for item in candidate:
        while True:
            if i == len(data_sequence):
                return False
            elif item in data_sequence[i]:
                i += 1
                break
            else:
                i += 1
    return True


if __name__ == '__main__':
    data_sequences = read_data_sequences("../data/courses_sequences_num.txt")



# ----------------------------------------------------------------------
# Helper method below
# ----------------------------------------------------------------------

def flatten(l):
    """Flattens given list (once)."""
    return [item for sublist in l for item in sublist]

def remove_duplicates(seq):
    """Remove duplicates from a list whilst retaining order."""
    seen = set()
    seen_add = seen.add
    return [ x for x in seq if x not in seen and not seen_add(x)]
