Flocks =
  prettyDemo:
    width: 855
    height: 500
    boids: 120
    boid:
      radius: 4
    inspectOne: true
    legend: true
    startOnPageLoad: true
    controls: false

  cohesionDemo:
    width: 300
    height: 300
    startOnPageLoad: false
    inspectOne: true
    boids: 15
    scale: 2.5
    boid:
      neighbourRadius: 35
      desiredSeparation: 5
      maxSpeed: 1
      wrapFactor: 0.5
      indicators:
        alignment: false
        separation: false
        neighbourRadius: true
        neighbours: true
        cohesion: true
        cohesionMean: true
        cohesionNeighbours: true

  alignmentDemo:
    width: 300
    height: 300
    startOnPageLoad: false
    inspectOne: true
    boids: 15
    scale: 2.5
    boid:
      neighbourRadius: 35
      desiredSeparation: 5
      maxSpeed: 1
      wrapFactor: 0.5
      indicators:
        alignment: true
        alignmentNeighbours: true
        velocity: true
        separation: false
        neighbourRadius: true
        neighbours: true
        cohesion: false

  separationDemo:
    width: 300
    height: 300
    startOnPageLoad: false
    inspectOne: true
    boids: 15
    scale: 2.5
    boid:
      neighbourRadius: 35
      desiredSeparation: 5
      maxSpeed: 1
      wrapFactor: 0.5
      indicators:
        alignment: false
        velocity: false
        separation: true
        separationRadius: true
        neighbourRadius: true
        neighbours: true

jQuery ->
  for name, options of Flocks
    div = $("##{name}")
    canvas = $('<canvas></canvas>').attr('width', options.width).attr('height', options.height).appendTo(div)[0]
    options.flock = flock = new Harry.Flock(canvas, options)

    do (flock) ->
      if flock.options.controls
        start = $('<button></button').addClass('awesome').html('Start')

        flock.clicked = (timeRunning) ->
          start.html if timeRunning then "Stop" else "Start"
          
        start.appendTo(div).click(flock.processing.mouseClicked)

        for s in [10, 50, 100, 200]
          do (s) ->
            btn = $('<button></button>').addClass('awesome').appendTo(div).html("#{s}%").click ->
              #flock.processing.frameRate(s/100*20)
              for boid in flock.boids
                boid.maxSpeed = s/100 * 2

  options = Flocks.prettyDemo.flock.options
  decorations = true
  $('#decorateDemo').click((e) ->
    if decorations
      e.target.innerHTML = "Decorate"
    else
      e.target.innerHTML = "Undecorate"

    decorations = !decorations

    for name in ['legend', 'inspectOne', 'inspectOneMagnification']
      options[name] = decorations

  ).trigger('click')
