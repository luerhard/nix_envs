import pandas as pd


def sample_data():
    data = {"col1": [1, 2, 3, 4], "col2": ["a", "b", "c", "d"]}
    return pd.DataFrame(data)
