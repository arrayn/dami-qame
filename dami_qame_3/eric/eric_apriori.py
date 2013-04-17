import re
from collections import defaultdict
from functools import lru_cache
from itertools import product
from math import floor

class DataSequence(object):
    """Represents a data sequence."""
    def __init__(self, elements):
        self.elements = elements
        self.items = set(flatten(elements))

    def __repr__(self):
        return repr(self.elements)

class SequentialPattern(object):
    """Represents a sequential pattern."""

    def __init__(self, items, support):
        self.items = items
        self.support = support

    def __repr__(self):
        return "< {} > ({:.3g})".format(", ".join(self.items), self.support)

class ResultSet(object):
    """The results of a run of the apriori algorithm."""
    def __init__(self, frequent_sequences):
        self.frequent_sequences = frequent_sequences
        self.max_len = len(frequent_sequences)
        self.num_of_sequences = len(flatten(self.frequent_sequences))

    def all(self):
        return ResultSet.__sort(flatten(self.frequent_sequences))

    def __getitem__(self, i):
        return ResultSet.__sort(self.frequent_sequences[i])

    @staticmethod
    def __sort(sequences):
        return sorted(sequences, key=lambda x: x.support, reverse=True)

    def __repr__(self):
        s = ""
        for pattern in self.all():
            s += repr(pattern) + "\n"
        s += "Number of patterns {}\n".format(self.num_of_sequences)
        s += "Largest pattern is of size {}\n".format(self.max_len)
        return s


def read_data_sequences(filename):
    """Read data sequences from a file containing lines of the format:
        { item_id item_id }{ item_id }...{item_id item_id item_id} etc."""
    data_sequences = []
    for f in open(filename, "r"):
        elements = []
        for element in re.findall(r"{[\w\s]+}", f):
            elements.append(set(re.findall(r"\w+", element)))
        data_sequences.append(DataSequence(elements))
    return data_sequences

def apriori(data_sequences, minsup, maxgap=999, mingap=1):
    """Apriori-like algorithm for mining sequential patterns."""
    frequent_seqs = []
    n = len(data_sequences)
    min_support_count = floor(minsup * n)

    frequent_seqs.append(find_frequent_1_subsequences(data_sequences,
        min_support_count))

    k = 2
    while frequent_seqs[-1]:
        frequent_seqs.append([])
        candidates = apriori_gen(frequent_seqs[-2])

        for candidate in candidates:
            support_count = calculate_support(candidate, data_sequences,
                    maxgap, mingap)
            if support_count >= min_support_count:
                pattern = SequentialPattern(candidate, support_count / n)
                frequent_seqs[-1].append(pattern)
        print("... of which {} are {}-patterns.\n".format(len(frequent_seqs[-1]), k))
        k += 1

    return ResultSet(frequent_seqs)


def find_frequent_1_subsequences(data_sequences, min_support_count):
    """Find all frequent 1-subsequences."""
    support_counts = defaultdict(int)
    n = len(data_sequences)

    # Calculate support counts
    for data_sequence in data_sequences:
        for item in data_sequence.items:
            support_counts[item] += 1

    # Filter subsequences above minsup
    frequent_seqs = []
    for k,v in support_counts.items():
        if v >= min_support_count:
            frequent_seqs.append(SequentialPattern([k], v / n))
    print("Generated {} frequent 1-patterns.\n".format(len(frequent_seqs)))
    return frequent_seqs

def apriori_gen(prev_subsequences):
    """Generate candidate k-subsequences given frequent k-1 subsequences."""
    candidates = []
    prev_subsequences = map(lambda pattern: pattern.items, prev_subsequences)
    for seq1, seq2 in product(prev_subsequences, repeat=2):
        if seq1[1:] == seq2[:-1]:
            candidates.append(seq1 + [seq2[-1]])
    print("Generated {} candidates...".format(len(candidates)))
    return candidates

def calculate_support(candidate, data_sequences, maxgap, mingap):
    """Calculate a candidate's support given a list of data sequences."""
    support_count = 0
    for data_sequence in data_sequences:
        if occurs(candidate, data_sequence, maxgap, mingap):
            support_count += 1
    return support_count

def occurs(candidate, data_sequence, maxgap, mingap):
    """Check whether given candidate sequence occurs in given data sequence."""
    matchings = list_matchings(candidate, data_sequence)
    if matchings:
        return find_occurrence(candidate, matchings, maxgap, mingap)
    else:
        return False


def list_matchings(candidate, data_sequence):
    """Find all matchings of candidate events in data sequence."""

    for item in candidate:
        if item not in data_sequence.items:
            return False

    matchings = []
    last_min = 0
    for item in candidate:
        matching = []
        for j in range(last_min, len(data_sequence.elements)):
            if item in data_sequence.elements[j]:
                matching.append(j)
        if matching:
            matchings.append(matching)
            last_min = matching[0] + 1
        else:
            return False
    return matchings

def find_occurrence(candidate, matchings, maxgap, mingap):
    """Find an occurrence of a candidate pattern against given matchings, also
    satisfying maxgap and mingap constraints."""
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

# ----------------------------------------------------------------------
# Helper method below
# ----------------------------------------------------------------------

def flatten(l):
    """Flattens given list (once)."""
    return [item for sublist in l for item in sublist]

if __name__ == '__main__':
    id_sequences = read_data_sequences("../data/courses_sequences_num.txt")
    name_sequences = read_data_sequences("../data/courses_sequences_text.txt")



