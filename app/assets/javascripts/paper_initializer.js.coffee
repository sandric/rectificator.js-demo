paper.install window
$(document).ready () ->
  paper.setup 'canvas'

  tool = new Tool()

  project.currentStyle =
    fillColor: 'black'

  $(document).trigger("paper:onload")
