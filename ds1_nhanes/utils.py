import plotly.express as px
import plotly.graph_objects as go

def graph_plotly(df, labels, title=None, *args, **kwargs):
    fig = go.Figure()
    fig.add_trace(go.Scatter3d(
        x=df[:, 0],
        y=df[:, 1],
        z=df[:, 2],
        mode='markers',
        marker=dict(
            size=5,
            color=labels,
            colorscale='Viridis',
            opacity=0.5
        ),
        *args,
        **kwargs
    ))
    fig.update_layout(
        scene=dict(
            xaxis_title='PC1',
            yaxis_title='PC2',
            zaxis_title='PC3'
        ),
        title=title
    )
    return fig


import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.neighbors import NearestNeighbors
from sklearn.metrics import adjusted_rand_score
from sklearn.cluster import KMeans

def split_half_val(df, k=3, random_state=None):
    # Split data in half
    train, test = train_test_split(df, test_size=0.5, random_state=random_state)

    # Cluster training half
    km_train = KMeans(n_clusters=k, random_state=random_state).fit(train)
    train_labels = km_train.labels_

    # NN to pair each training point with a test point
    nn = NearestNeighbors(n_neighbors=1).fit(train)
    distances, indices = nn.kneighbors(test)
    nn_labels = train_labels[indices.flatten()]

    # Cluster test set
    km_test = KMeans(n_clusters=k, random_state=random_state).fit(test)
    test_labels = km_test.labels_

    # Get Adjusted Rand Scores that compare test labels to nn labels
    ari = adjusted_rand_score(test_labels, nn_labels)
    return ari

# Second function just makes iterations easier
def iterate_val(df, k=3, n_iter=10, random_state=42):
    aris = []
    for i in range(n_iter):
        ari = split_half_val(df, k=k, random_state=random_state + i)
        aris.append(ari)
    return aris