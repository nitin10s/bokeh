
MAX_SIZE = 500
setup_interactive = () ->
  data = ({'x' : pt, 'y' : pt} for pt in _.range(MAX_SIZE))
  data_source1 = Bokeh.Collections['ObjectArrayDataSource'].create(
      data : data
    , {'local' : true}
  )
  plot1 = Bokeh.scatter_plot(null, data_source1, 'x', 'y', 'x', 'circle')
  plot1.set('offset', [100, 100])
  scatterrenderer = plot1.resolve_ref(plot1.get('renderers')[0])
  pantool = Bokeh.Collections['PanTool'].create(
     dataranges : [scatterrenderer.get('xdata_range'), scatterrenderer.get('ydata_range')],
     dimensions : ['width', 'height']
  )
  zoomtool = Bokeh.Collections['ZoomTool'].create(
     dataranges : [scatterrenderer.get('xdata_range'), scatterrenderer.get('ydata_range')],
     dimensions : ['width', 'height']
  )
  selecttool = Bokeh.Collections['SelectionTool'].create(
    {'renderers' : [scatterrenderer.ref()]}
  )
  selectoverlay = Bokeh.Collections['ScatterSelectionOverlay'].create(
    {'renderers' : [scatterrenderer.ref()]}
  )
  plot1.set('tools', [pantool.ref(), zoomtool.ref(), selecttool.ref()])
  plot1.set('overlays', [selectoverlay.ref()])
  window.plot1 = plot1
  return plot1

test('test_interactive', ()->
  expect(0)
  plot1 = setup_interactive()
  div = $('<div style="border:1px solid black"></div>')
  $('body').append(div)
  window.myrender = () ->
    view = new plot1.default_view(
      model : plot1,
      render_loop : true)
    div.append(view.$el)
    view.render()
    window.view = view
  _.defer(window.myrender)
)

test('test_pan_tool', ()->
  expect(0)

  """ when this test runs you should see only one line, not an
  artifact from an earlier line """
  plot1 = setup_interactive()
  div = $('<div style="border:1px solid black"></div>')
  $('body').append(div)
  window.myrender = () ->
    view = new plot1.default_view(
      model : plot1,
      render_loop : true,
    )
    div.append(view.$el)
    view.render()
    window.view = view
    window.pantool = plot1.resolve_ref(plot1.get('tools')[0])
    _.defer(() ->
       ptv = _.filter(view.tools, ((v) -> v.model == window.pantool))[0]
       ptv.dragging=true
       ptv._set_base_point({'bokehX' : 0, 'bokehY' : 0})
       ptv._drag({'bokehX' : 30, 'bokehY' : 30})
       window.ptv = ptv
    )
  _.defer(window.myrender)
)


# MAX_SIZE = 500
# test('test_tool_multisource', ()->
#   expect(0)
#   #HUGO - I can't figure out what this test does, commenting it out
#   """ when this test runs you should see only one line, not an
#   artifact from an earlier line """
#   data = ({'x' : pt, 'y' : pt} for pt in _.range(MAX_SIZE))
#   data_source1 = Bokeh.Collections['ObjectArrayDataSource'].create(
#       data : data
#   )
#   data = ({'x2' : 2 * pt, 'y2' : pt} for pt in _.range(MAX_SIZE))
#   data_source2 = Bokeh.Collections['ObjectArrayDataSource'].create(
#       data : data
#   )
#   plot1 = Bokeh.scatter_plot(null, data_source1, 'x', 'y', 'x', 'circle')
#   color_mapper = Bokeh.Collections['DiscreteColorMapper'].create(
#     data_range : Bokeh.Collections['DataFactorRange'].create(
#         data_source : data_source2.ref()
#         columns : ['x2']
#     )
#   )
#   scatterrenderer = plot1.resolve_ref(plot1.get('renderers')[0])
#   xmapper = scatterrenderer.get_ref('xmapper')
#   xdr = plot1.resolve_ref(xmapper.get('data_range'))
#   xdr.get('sources').push(
#     ref : data_source2.ref()
#     columns : ['x2']
#   )
#   ymapper = scatterrenderer.get_ref('ymapper')
#   ydr = plot1.resolve_ref(ymapper.get('data_range'))
#   ydr.get('sources').push(
#     ref : data_source2.ref()
#     columns : ['y2']
#   )


#   scatterrenderer2 = Bokeh.Collections["ScatterRenderer"].create(
#     data_source : data_source2.ref()
#     xfield : 'x2'
#     yfield : 'y2'
#     color_field : 'x2'
#     color_mapper : color_mapper
#     mark : 'circle'
#     xmapper : xmapper.ref()
#     ymapper : ymapper.ref()
#     parent : plot1.ref()
#   )
#   plot1.get('renderers').push(scatterrenderer2)
#   pantool = Bokeh.Collections['PanTool'].create(
#     {'xmappers' : [scatterrenderer.get('xmapper')],
#     'ymappers' : [scatterrenderer.get('ymapper')]}
#     , {'local':true})
#   zoomtool = Bokeh.Collections['ZoomTool'].create(
#     {'xmappers' : [scatterrenderer.get('xmapper')],
#     'ymappers' : [scatterrenderer.get('ymapper')]}
#     , {'local':true})
#   selecttool = Bokeh.Collections['SelectionTool'].create(
#     {'renderers' : [scatterrenderer.ref(), scatterrenderer2.ref()]
#     'data_source_options' : {'local' : true}}
#     , {'local':true})
#   selectoverlay = Bokeh.Collections['ScatterSelectionOverlay'].create(
#     {'renderers' : [scatterrenderer.ref(), scatterrenderer2.ref()]}
#     , {'local':true})
#   plot1.set('tools', [pantool.ref(), zoomtool.ref(), selecttool.ref()])
#   plot1.set('overlays', [selectoverlay.ref()])
#   window.plot1 = plot1
#   div = $('<div style="border:1px solid black"></div>')
#   $('body').append(div)
#   window.myrender = () ->
#     view = new plot1.default_view(
#       model : plot1,
#       render_loop : true,
#     )
#     div.append(view.$el)
#     view.render()
#     window.view = view
#     window.pant = pantool
#   _.defer(window.myrender)
# )
