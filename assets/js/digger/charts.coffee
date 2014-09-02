app = app or {}
app.extends = app.extends or {}
app.extends.charts = {}
charts = app.extends.charts

generateFilter = ((svg)->
  defs = svg.append('defs')
  filter = defs.append('filter').attr('id', 'drop-shadow')
  filter.append('feGaussianBlur').attr('in', 'SourceAlpha').attr('stdDeviation', 1)
  filter.append('feOffset').attr('dx', 1).attr('dy', 1)
  filter.append('feComponentTransfer').append('feFuncA').attr({type: 'linear', slope: '1'})
  feMerge = filter.append('feMerge')
  feMerge.append('feMergeNode')
  feMerge.append('feMergeNode').attr('in', 'SourceGraphic')
)

generateChartYears = ((data)->
  margin = {top: 60, right: 70, bottom: 70, left: 80}
  width = 500 - margin.left - margin.right
  height = 500 - margin.top - margin.bottom

  svg = d3.select('#charts').append('div').attr({id: 'chart-years'})
    .append('svg').attr('width', width + margin.left + margin.right)
    .attr('height', height + margin.top + margin.bottom)
    .append('g').attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')

  x = d3.scale.linear().domain([0, data.length - 1]).range([0, width])
  y = d3.scale.linear().domain(d3.extent(data, (d)-> d.year)).range([height, 0])

  xAxis = d3.svg.axis().scale(x).orient('bottom')
  yAxis = d3.svg.axis().scale(y).orient('left').tickFormat(d3.format('d'))

  svg.append('g').attr('class', 'axis axis--x').attr('transform', 'translate(0,' + height + ')')
    .call( xAxis )

  svg.append('g').attr('class', 'axis axis--y').call( yAxis )
    .append('text').attr('x', 20).attr('dy', '.32em')
    .style('font-weight', 'bold').text('Years')

  line = d3.svg.line().x((d,i)-> x(i)).y((d)-> y(d.year) )

  svg.append('g').append('path').datum(data).attr('d', line).attr('class', 'line')

)

class charts.ChartYears extends Backbone.View
  render: ->
    @collection.comparator = 'year'
    data = @collection.sort()

    modelsToRemove = []
    data.each((item)->
      item.set('year', +item.get('year'))
      if not item.get('year') then modelsToRemove.push item
    )
    data.remove modelsToRemove

    generateChartYears(data.toJSON())
