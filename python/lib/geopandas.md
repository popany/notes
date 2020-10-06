# [geopandas](https://geopandas.org/index.html)

- [geopandas](#geopandas)
  - [reference](#reference)
    - [`GeoDataFrame.plot(self, *args, **kwargs)`](#geodataframeplotself-args-kwargs)
      - [Parameters](#parameters)
      - [Returns](#returns)
  - [Q&A](#qa)

## [reference](https://geopandas.org/reference.html)

### `GeoDataFrame.plot(self, *args, **kwargs)`

Plot a GeoDataFrame.

Generate a plot of a GeoDataFrame with matplotlib. If a column is specified, the plot coloring will be based on values in that column.

#### Parameters

- df: `GeoDataFrame`

  The GeoDataFrame to be plotted. Currently Polygon, MultiPolygon, LineString, MultiLineString and Point geometries can be plotted.

- column: `str`, `np.array`, `pd.Series` (default None)

  The name of the dataframe column, np.array, or pd.Series to be plotted. If np.array or pd.Series are used then it must have same length as dataframe. Values are used to color the plot. **Ignored if color is also set**.

- cmap: `str` (default None)

  The name of a colormap recognized by matplotlib.

- color: `str` (default None)

  If specified, all objects will be colored **uniformly**.

- ax: `matplotlib.pyplot.Artist` (default None)

  axes on which to draw the plot

- cax: `matplotlib.pyplot.Artist` (default None)

  axes on which to draw the legend in case of color map.

- categorical: `bool` (default False)

  If `False`, cmap will reflect numerical values of the column being plotted. For non-numerical columns, this will be set to `True`.

- legend: `bool` (default False)

  Plot a legend. Ignored if no column is given, or if color is given.

- scheme: `str` (default None)

  Name of a choropleth classification scheme (requires mapclassify). A `mapclassify.MapClassifier` object will be used under the hood. Supported are all schemes provided by mapclassify (e.g. ‘BoxPlot’, ‘EqualInterval’, ‘FisherJenks’, ‘FisherJenksSampled’, ‘HeadTailBreaks’, ‘JenksCaspall’, ‘JenksCaspallForced’, ‘JenksCaspallSampled’, ‘MaxP’, ‘MaximumBreaks’, ‘NaturalBreaks’, ‘Quantiles’, ‘Percentiles’, ‘StdMean’, ‘UserDefined’). Arguments can be passed in `classification_kwds`.

- k: `int` (default 5)

  Number of classes (ignored if scheme is None)

- vmin: `None` or `float` (default None)

  Minimum value of `cmap`. If None, the minimum data value in the column to be plotted is used.

- vmax: `None` or `float` (default None)

- Maximum value of `cmap`. If None, the maximum data value in the column to be plotted is used.

- markersize: `str` or `float` or `sequence` (default None)

  Only applies to point geometries within a frame. If a `str`, will use the values in the column of the frame specified by markersize to set the size of markers. Otherwise can be a value to apply to all points, or a sequence of the same length as the number of points.

- figsize: tuple of integers (default None)

  Size of the resulting `matplotlib.figure.Figure`. If the argument axes is given explicitly, `figsize` is ignored.

- legend_kwds: `dict` (default None)

  Keyword arguments to pass to `matplotlib.pyplot.legend()` or `matplotlib.pyplot.colorbar()`. Additional accepted keywords when scheme is specified:

    - fmt: string

      A formatting specification for the bin edges of the classes in the legend. For example, to have no decimals: {"fmt": "{:.0f}"}.

    - labels: list-like

      A list of legend labels to override the auto-generated labels. Needs to have the same number of elements as the number of classes (k).

- categories: list-like

  Ordered list-like object of categories to be used for categorical plot.

- classification_kwds: `dict` (default None)

  Keyword arguments to pass to mapclassify

- missing_kwds: `dict` (default None)

  Keyword arguments specifying color options (as style_kwds) to be passed on to geometries with missing values in addition to or overwriting other style kwds. If None, geometries with missing values are not plotted.

- aspect: ‘auto’, ‘equal’ or float (default ‘auto’)

  Set aspect of axis. If ‘auto’, the default aspect for map plots is ‘equal’; if however data are not projected (coordinates are long/lat), the aspect is by default set to 1/cos(df_y * pi/180) with df_y the y coordinate of the middle of the GeoDataFrame (the mean of the y range of bounding box) so that a long/lat square appears square in the middle of the plot. This implies an Equirectangular projection. It can also be set manually (float) as the ratio of y-unit to x-unit.

- **style_kwds: `dict`

  Style options to be passed on to the actual `plot` function, such as `edgecolor`, `facecolor`, `linewidth`, `markersize`, `alpha`.

#### Returns

  ax: matplotlib axes instance

## Q&A

[Customize Map Legends and Colors in Python using Matplotlib: GIS in Python](https://www.earthdatascience.org/courses/scientists-guide-to-plotting-data-in-python/plot-spatial-data/customize-vector-plots/python-customize-map-legends-geopandas/)

