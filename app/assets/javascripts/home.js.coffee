# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$(document).ready ->

  window.rectificators = []

  createRectificator = (params) ->
    new Rectificator( parseInt(params.id),
                      parseInt(params.rectangle_x),
                      parseInt(params.rectangle_y),

                      parseInt(params.rectangle_width),
                      parseInt(params.rectangle_height),

                      parseInt(params.rectange_corner_size_x),
                      parseInt(params.rectange_corner_size_y),


                      parseInt(params.start_point_x),
                      parseInt(params.start_point_y),

                      parseInt(params.start_point_radius),

                      parseInt(params.normal_radius),
                      params.color)

  $(".simple_form").on "submit", () ->

    rectificators.push createRectificator(

      id: rectificators.length,

      rectangle_x: $("#f_rectangle_x").val()
      rectangle_y: $("#f_rectangle_y").val()

      rectangle_width: $("#f_rectangle_width").val()
      rectangle_height: $("#f_rectangle_height").val()

      rectange_corner_size_x: $("#f_rectange_corner_size_x").val()
      rectange_corner_size_y: $("#f_rectange_corner_size_y").val()


      start_point_x: $("#f_start_point_x").val()
      start_point_y: $("#f_start_point_y").val()

      start_point_radius: $("#f_start_point_radius").val()

      normal_radius: $("#f_normal_radius").val()

      color: $("#f_color").val()

    )

    rectificators[rectificators.length - 1].draw()
    false

  hitOptions =
    fill: true

  itemIsRectificator = (hitResult) ->
    if hitResult.item['_type'] == 'rectificator'
      hitResult.item
    else
      undefined

  itemIsRectificatorCircle = (hitResult) ->
    if hitResult.item['_type'] != 'rectificator'
      if hitResult.item['_type'] == 'rectificator_circle'
        hitResult.item
      else if hitResult.item.parent.children
        for item in hitResult.item.parent.children
          if item['_type'] == 'rectificator_circle'
            return item
    else
      undefined

  tool.onMouseDown = (event) ->
    hitResult = project.hitTest(event.point, hitOptions)

    window.selected_item = window.selected_item || itemIsRectificator(hitResult)
    window.selected_item = window.selected_item || itemIsRectificatorCircle(hitResult)

  tool.onMouseUp = (event) ->
    delete window.selected_item

  tool.onMouseMove = (event) ->
    if window.selected_item != undefined
      if window.selected_item['_type'] == 'rectificator'
        rectificators[window.selected_item['_name']].moveRectangleTo(event.delta)
      else if window.selected_item['_type'] == 'rectificator_circle'
        rectificators[window.selected_item['_name']].moveCenterTo(event.delta)
