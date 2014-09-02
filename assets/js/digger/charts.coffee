app = app or {}
app.extends = app.extends or {}
app.extends.charts = {}
charts = app.extends.charts

generateFilter = ((svg, slope, deviation, dx, dy)->
  defs = svg.append('defs')
  filter = defs.append('filter').attr('id', 'drop-shadow')
  filter.append('feGaussianBlur').attr('in', 'SourceAlpha').attr('stdDeviation', deviation)
  filter.append('feOffset').attr('dx', dx).attr('dy', dy)
  filter.append('feComponentTransfer').append('feFuncA').attr({type: 'linear', slope: slope})
  feMerge = filter.append('feMerge')
  feMerge.append('feMergeNode')
  feMerge.append('feMergeNode').attr('in', 'SourceGraphic')
)

generateChartYears = ((data)->
  margin = {top: 30, right: 70, bottom: 70, left: 80}
  width = 800 - margin.left - margin.right
  height = 500 - margin.top - margin.bottom

  svg = d3.select('#charts').append('div').attr({id: 'chart-years'})
    .append('svg').attr('width', width + margin.left + margin.right)
    .attr('height', height + margin.top + margin.bottom)
    .append('g').attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')

  x = d3.scale.linear().domain([-0.5,data.length - .5]).range([0, width])
  y = d3.scale.linear().domain([0,d3.max(data, (d)-> d.count) + 5]).range([height, 0])

  console.log data
  xAxis = d3.svg.axis().scale(x).orient('bottom').ticks(data.length - 1 )
    .tickFormat((i)-> if i < data.length then return data[i].year else return ''  )
  yAxis = d3.svg.axis().scale(y).orient('left').tickFormat(d3.format('d'))

  svg.append('g').attr('class', 'axis axis--x').attr('transform', 'translate(0,' + height + ')')
    .call( xAxis ).selectAll('text').attr({
      dx: '-.8em', dy: '.15em', 'transform': 'rotate(-65)'
    }).style({'text-anchor': 'end'})

  svg.append('g').attr('class', 'axis axis--y').call( yAxis )
    .append('text')
    .attr('x', 20).attr('dy', '.32em')
    .style('font-weight', 'bold').text('Number of albums per year')

  barWidth = width / data.length
  barYFn = ((d)-> y(d.count))
  barHeightFn = ((d)-> height - y(d.count))

  colorsScheme = ['#7C7CC9','#72B66C','#429742','#323247']
  colorScale = d3.scale.linear().domain([0, data.length - 1]).range([0,1])
  colorScaleConversion = d3.scale.linear()
    .domain(d3.range(0, 1, 1.0 / (colorsScheme.length))).range(colorsScheme)
  colorFn = (d)-> colorScaleConversion(colorScale(d.count))
  generateFilter(svg, .2, 3, 1, -1)

  mouseTransition = 500
  mouseover = ->
    d3.select(this).transition().duration(mouseTransition).style({fill: 'rgb(250, 203, 15)'})

  mouseleave = -> d3.select(this).transition().duration(mouseTransition).style({fill: colorFn})

  svg.selectAll('rect').data(data).enter().append('rect').attr('x', (d, i)-> barWidth * i)
    .attr({y: barYFn, width: barWidth, height: barHeightFn})
    .style({fill: colorFn, stroke: 'white', filter: 'url(#drop-shadow)'})
    .on('mouseover', mouseover).on('mouseleave', mouseleave)
    .append('title').text((d)-> d.count)

)

class charts.ChartYears extends Backbone.View
  render: ->
    data = @collection.groupBy('year')
    data = _.keys(data).map((key, index)-> {
      year: (-> if key is 'undefined' then return 'None' else return key)()
      count: data[key].length
    })
    generateChartYears(data)
