function stats = boxplot_data(name, data, factor)
  h = boxplot(data);
  % Get the data from the boxplot
  lw = get(findobj(h,'tag','Lower Whisker'),'YData') * factor;
  uw = get(findobj(h,'tag','Upper Whisker'),'YData') * factor;
  lav = get(findobj(h,'tag','Lower Adjacent Value'),'YData') * factor;
  uav = get(findobj(h,'tag','Upper Adjacent Value'),'YData') * factor;
  m = get(findobj(h,'tag','Median'),'YData') * factor;
  close(gcf);
  % Prepare the stats structure
  stats.mean = mean(data) * factor;
  stats.median = m(1);
  stats.lower_wisker = lw(2);
  stats.upper_wisker = uw(1);
  stats.lower_adjacent_value = lav(1);
  stats.upper_adjacent_value = uav(1);
