import re
from collections import defaultdict
from itertools import product
from math import floor


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

def apriori(data_sequences, minsup, maxspan=999, maxgap=999, mingap=1):
    """Apriori-like algorithm for mining sequential patterns."""
    frequent_seqs = []
    n = len(data_sequences)
    min_support_count = floor(minsup * n)

    frequent_seqs.append(find_frequent_1_subsequences(data_sequences, min_support_count))

    while frequent_seqs[-1]:
        frequent_seqs.append([])
        candidates = apriori_gen(frequent_seqs[-2])

        for candidate in candidates:
            support_count = calculate_support(candidate, data_sequences, maxspan, maxgap, mingap)
            if support_count >= min_support_count:
                pattern = SequentialPattern(candidate, support_count / n)
                frequent_seqs[-1].append(pattern)

    return sorted(flatten(frequent_seqs),
            key=lambda x: x.support, reverse=True)



def find_frequent_1_subsequences(data_sequences, min_support_count):
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
        if v >= min_support_count:
            frequent_seqs.append(SequentialPattern([k], v / n))
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

def calculate_support(candidate, data_sequences, maxspan, maxgap, mingap):
    """Calculate a candidate's support given a list of data sequences."""
    support_count = 0
    for data_sequence in data_sequences:
        if occurs(candidate, data_sequence, maxspan, maxgap, mingap):
            support_count += 1
    return support_count

def occurs(candidate, data_sequence, maxspan, maxgap, mingap):
    """Check whether given candidate sequence occurs in given data sequence."""
    matchings = []
    last_min = 0
    for item in candidate:
        matching = []
        for j in range(last_min, len(data_sequence)):
            if item in data_sequence[j]:
                matching.append(j)
        if matching:
            matchings.append(matching)
            last_min = matching[0] + 1
        else:
            return False

    stack = []
    level = 0
    index = 0
    while len(stack) != len(candidate):
        if level == 0:
            if index == len(matchings[0]):
                return False
            stack.append(index)
            level += 1
            index = 0
        elif index == len(matchings[level]):
            level -= 1
            index = stack.pop() + 1
        elif matchings[level][index] > matchings[level-1][stack[-1]]:
            diff = matchings[level][index] - matchings[level-1][stack[-1]]
            if diff > maxgap: # Max gap
                level -= 1
                index = stack.pop() + 1
            elif diff < mingap: # Min gap
                index += 1
            else:
                stack.append(index)
                level += 1
                index = 0
        else:
            index += 1
    return stack



def satisfies_maxspan(match_points, maxspan):
    """Check that given matching of pattern on data sequence satisfies the max
    gap constraint."""
    return (match_points[-1] - match_points[0]) <= maxspan

def satisfies_maxgap_and_mingap(match_points, maxgap, mingap):
    """Check that given matching of pattern on data sequence satisfies the max
    and min gap constraint."""
    for i in range(len(match_points)-1):
        diff = match_points[i+1] - match_points[i]
        if diff > maxgap or diff < mingap:
            return False
    return True



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


if __name__ == '__main__':
    data_sequences = read_data_sequences("../data/courses_sequences_num.txt")
    rs = apriori(data_sequences, 0.25)
    print(rs)
    print(len(rs))



