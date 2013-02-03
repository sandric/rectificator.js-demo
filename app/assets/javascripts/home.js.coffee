# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$(document).ready ->


  rectificators = []


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
    console.log "submitting!"

    #$("#canvas")[0].getContext('2d').clearRect(0, 0, 800, 800)
    #project.activeLayer.removeChildren();

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

    rectificators[0].draw()

    false

  hitOptions =
    segments: true,
    stroke: true,
    fill: true,
    tolerance: 5

  tool.onMouseDrag = (event) ->

    hitResult = project.hitTest(event.point, hitOptions)
    project.activeLayer.selected = false

    window.hit = hitResult

    if hitResult && hitResult.item && hitResult.item['_name']

      console.log hitResult._name

      hitResult.item.selected = true

      $("#canvas")[0].getContext('2d').clearRect(0, 0, 800, 800)
      project.activeLayer.removeChildren()

      createRectificator(

        id: rectificators.length

        rectangle_x: event["event"].offsetX
        rectangle_y: event["event"].offsetY

        rectangle_width: $("#f_rectangle_width").val()
        rectangle_height: $("#f_rectangle_height").val()

        rectange_corner_size_x: $("#f_rectange_corner_size_x").val()
        rectange_corner_size_y: $("#f_rectange_corner_size_y").val()


        start_point_x: $("#f_start_point_x").val()
        start_point_y: $("#f_start_point_y").val()

        start_point_radius: $("#f_start_point_radius").val()

        normal_radius: $("#f_normal_radius").val()

        color: $("#f_color").val()

      ).draw()

  ###
  hitOptions =
    segments: true,
    stroke: true,
    fill: true,
    tolerance: 5

  tool.onMouseMove = (event) ->
    hitResult = project.hitTest(event.point, hitOptions)
    project.activeLayer.selected = false
    if hitResult && hitResult.item
      console.log hitResult.item
      hitResult.item.selected = true
  ###
