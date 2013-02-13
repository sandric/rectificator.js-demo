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

    console.log "id: #{@id}"

    @color = color

    @rectangle_x = rectangle_x
    @rectangle_y = rectangle_y
    @rectangle_width = rectangle_width
    @rectangle_height = rectangle_height
    @rectangle_corner_size_x = rectange_corner_size_x
    @rectangle_corner_size_y = rectange_corner_size_y
    @start_point_radius = start_point_radius

    @normal_radius = normal_radius
    @center = new Point(start_point_x, start_point_y)

  draw: ->
    @drawRectangle()
    @drawCenterCircle()
    @drawPointer()

    #@groupify()

    view.draw()

  drawRectangle: ->
    rectangle = new Rectangle(@rectangle_x, @rectangle_y, @rectangle_width, @rectangle_height)
    cornerSize = new Size(@rectangle_corner_size_x, @rectangle_corner_size_y)
    @rectangle = new Path.RoundRectangle(rectangle, cornerSize)
    @rectangle.strokeColor = @color
    @rectangle.fillColor = @color

    @rectangle._name = @id

  drawPointer: ->
    @drawConnection()
    @drawNormalVector()
    @drawNormalVectorConnection()

  drawCenterCircle: ->
    @circle = new Path.Circle(@center, @start_point_radius)
    @circle.fillColor = @color

  drawConnection: ->
    @connection = new Path()
    @connection.strokeColor = "red"
    @connection.add(@center)
    @connection.add(@rectangle.bounds.center)

  drawNormalVector: ->
    normal = @connection.getNormalAt(@connection.length)
    normal.length = @normal_radius
    @normalVector = new Path()
    @normalVector.strokeColor = @color
    @normalVector.fillColor = "red"
    @normalVector.add(new Point(@rectangle.bounds.center.x - normal.x, @rectangle.bounds.center.y - normal.y))
    @normalVector.add(new Point(@rectangle.bounds.center.x + normal.x, @rectangle.bounds.center.y + normal.y))

  drawNormalVectorConnection: ->
    @normalVector.add(@center)
    @normalVector.closed = true
    @connection.remove()

  moveRectangleTo: (delta) ->
    console.log "moving rectagle"
    @rectangle.translate(delta)

    @connection.remove()
    @normalVector.remove()

    @drawPointer()

  groupify: ->
    @group = new Group([@rectangle, @connection, @normalVector, @circle])

  removeGroup: ->
    @group.remove()

