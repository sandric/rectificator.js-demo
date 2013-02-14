#= require paper_initializer

class @Rectificator

  constructor: (id = 0,
                rectangle_x = 50,
                rectangle_y = 50,
                rectangle_width = 100,
                rectangle_height = 50,
                rectange_corner_size_x = 20,
                rectange_corner_size_y = 20,
                start_point_x = 400,
                start_point_y = 150,
                start_point_radius = 5,
                normal_radius = 10,
                color = 'black') ->

    @id = id

    @color = color

    @rectangle_x = rectangle_x
    @rectangle_y = rectangle_y
    @rectangle_width = rectangle_width
    @rectangle_height = rectangle_height
    @rectangle_corner_size_x = rectange_corner_size_x
    @rectangle_corner_size_y = rectange_corner_size_y
    @start_point_radius = start_point_radius
    @start_point_x = start_point_x
    @start_point_y = start_point_y

    @normal_radius = normal_radius

  draw: ->
    @drawRectangle()
    @drawCenterCircle()
    @drawPointer()

    view.draw()

  drawRectangle: ->
    rectangle = new Rectangle(@rectangle_x, @rectangle_y, @rectangle_width, @rectangle_height)
    cornerSize = new Size(@rectangle_corner_size_x, @rectangle_corner_size_y)
    @rectangle = new Path.RoundRectangle(rectangle, cornerSize)
    @rectangle.strokeColor = "black"
    @rectangle.fillColor = @color

    @rectangle._name = @id
    @rectangle._type = "rectificator"

  drawCenterCircle: ->
    @center = new Point(@start_point_x, @start_point_y)
    @circle = new Path.Circle(@center, @start_point_radius)
    @circle.fillColor = @color
    @circle.strokeColor = "red"

    @circle._name = @id
    @circle._type = "rectificator_circle"

  drawPointer: ->
    @drawConnection()
    @drawNormalVector()
    @drawNormalVectorConnection()

  drawConnection: ->
    @connection = new Path()
    @connection.add(@center)
    @connection.add(@rectangle.bounds.center)

  drawNormalVector: ->
    normal = @connection.getNormalAt(@connection.length)
    normal.length = @normal_radius
    @normalVector = new Path()
    @normalVector.add(new Point(@rectangle.bounds.center.x - normal.x, @rectangle.bounds.center.y - normal.y))
    @normalVector.add(new Point(@rectangle.bounds.center.x + normal.x, @rectangle.bounds.center.y + normal.y))

  drawNormalVectorConnection: ->
    @normalVector.add(@center)
    @normalVector.closed = true

    normal_vector_line_one = new Line(@normalVector.segments[0].point, @center, false)
    normal_vector_line_two = new Line(@normalVector.segments[1].point, @center, false)

    @normalVector.remove()
    @connection.remove()

    # pixel offset for adding more segments to rectangle
    # for more accurance of determining intersection of rectangle with pointer - set less value
    @rectangle.flatten(5)

    intersections = []
    for i in [0..@rectangle.segments.length - 2]
      rectangle_line = new Line(@rectangle.segments[i].point, @rectangle.segments[i + 1].point, false)
      intersections[0] ||= normal_vector_line_one.intersect(rectangle_line)
      intersections[1] ||= normal_vector_line_two.intersect(rectangle_line)

      if intersections[0] && !segmentIndexOne
        segmentIndexOne = i
      if intersections[1] && !segmentIndexTwo
        segmentIndexTwo = i

    if segmentIndexTwo - segmentIndexOne > 0
      @rectangle.removeSegments(segmentIndexOne, segmentIndexTwo)

    @rectangle.insert(segmentIndexOne, intersections[0])
    @rectangle.insert(segmentIndexOne + 1, @center)
    @rectangle.insert(segmentIndexOne + 2, intersections[1])

  moveRectangleTo: (delta) ->
    @rectangle.remove()
    @circle.remove()

    @rectangle_x += delta.x
    @rectangle_y += delta.y

    @draw()

  moveCenterTo: (delta) ->
    @rectangle.remove()
    @circle.remove()

    @start_point_x += delta.x
    @start_point_y += delta.y

    @draw()
