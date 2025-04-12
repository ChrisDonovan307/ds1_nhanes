import plotly.express as px
import plotly.graph_objects as go

# def hello_world():
#     '''
#     do some stuff
#     '''
#     print('Hello, world')

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
