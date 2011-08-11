font = false
class Harry.Flock
  @defaults:
    boids: 100 # How many or function to return boids
    boid: # Options to pass to boid constructor
      maxSpeed: 2
      maxForce: 0.05
      radius: 3
      mousePhobic: false
    clickToStop: true
    startPosition: new Harry.Vector(0.5,0.5)
    frameRate: 20
    inspectOne: false
    inspectOneMagnification: false
    legend: false
    startOnPageLoad: false
    antiFlicker: true
    scale: 1
    startNotification: false
    controls: true
    border: true

  everStarted = false

  constructor: (canvas, options) ->
    @options = jQuery.extend {}, Flock.defaults, options
    @processing = new Processing(canvas, this.run)

  run: (processing) =>
    processing.frameRate(@options.frameRate)
    processing.scaledHeight = processing.height/@options.scale
    processing.scaledWidth = processing.width/@options.scale
    timeRunning = @options.startOnPageLoad # closed over variable for tracking if "time" is paused or running

    @boids = boids = this._getBoids(processing)

    # inspectOne option allows to force one boid to always show its component vectors.
    # Pick the last one so it always renders on top
    inspectorGadget = boids[boids.length-1]

    processing.draw = =>
      processing.pushMatrix()
      processing.scale(@options.scale)
      # Update mouse location for the boids to look at
      Harry.Mouse = new Harry.Vector(processing.mouseX/@options.scale, processing.mouseY/@options.scale)

      processing.background(255)

      # Reset the rendered flag for all boids for this frame. Some boids will force
      # rendering of other ones to show the indications in different colors, so this
      # flag is set to true and they don't re-render themselves using the normal colors
      for boid in boids
        boid.renderedThisStep = false
      # Step each boid
      if timeRunning
        this.everStarted = true

        for boid in boids
          boid.step(boids)
      # Render each boid
      for boid in boids
        boid.render(boids)

      processing.popMatrix()

      # Other stuff
      inspectorGadget.forceInspection = @options.inspectOne
      this._drawInspector(inspectorGadget,processing) if @options.inspectOneMagnification and @options.inspectOne
      this._drawStartNotification(processing) if @options.startNotification && !@everStarted
      if @options.legend
        font ||= processing.loadFont('/fonts/aller_rg-webfont')
        this._drawLegend(processing)

      if @options.border
        processing.stroke(0)
        processing.noFill()
        processing.rect(0,0,processing.width-1, processing.height-1)

      return true

    if @options.clickToStop
      processing.mouseClicked = =>
        boid.inspectable = timeRunning for boid in boids
        timeRunning = !timeRunning
        this.clicked.call(this, timeRunning) if this.clicked?

  _getBoids: (processing) ->
    if @options.boids.call?
      @options.boids(processing)
    else
    # Figure out the initial position
    start = new Harry.Vector(processing.scaledWidth,processing.scaledHeight)
    start.x = start.x * @options.startPosition.x
    start.y = start.y * @options.startPosition.y
    # Fill an array with all the boid instances
    options = jQuery.extend(true, {processing: processing}, @options.boid)
    for i in [1..@options.boids]
      velocity = new Harry.Vector(Math.random()*2-1,Math.random()*2-1)
      startPosition = start
      #startPosition.x += Math.random() * 10 - 5
      #startPosition.y += Math.random() * 10 - 5
      new Harry.Boid(jQuery.extend(options, {velocity: velocity, startPosition: startPosition}))

  _drawLegend: (processing) ->
    # Draw legend
    processing.fill(230)
    processing.stroke(0)
    processing.strokeWeight(1)
    processing.pushMatrix()
    processing.translate(0,processing.height-101)
    processing.rect(0,0, 100, 100)
    processing.textFont(font, 14)
    processing.fill(0)
    processing.text("Legend",24,15)

    processing.translate(10,16)

    demo = new Harry.Vector(0,-12)
    ctx = {p:processing}
    legends = [
      {name:"Velocity", r:0,g:0,b:0}
      {name:"Separation", r:250,g:0,b:0}
      {name:"Alignment", r:0,g:250,b:0}
      {name:"Cohesion", r:0,g:0,b:250}
    ]

    processing.pushMatrix()
    processing.strokeWeight(2)
    processing.textFont(font, 12)

    for l in legends
      processing.translate(0,20)

      #Velocity - black
      processing.stroke(l.r,l.g,l.b)
      processing.fill(l.r,l.g,l.b)
      Harry.Boid::_renderVector.call(ctx, demo,1)
      processing.text(l.name,8,-2)

    processing.popMatrix()
    processing.popMatrix()

  _drawAntiFlicker: (processing) ->
    # Draw lines to prevent flickering at the edges when wrapping
    processing.stroke(255)
    processing.strokeWeight(@options.radius+1)
    processing.noFill()
    processing.rect(@options.radius/2-1,@options.radius/2-1, processing.width-@options.radius+1,processing.height-@options.radius+1)

  _drawInspector: (boid, processing) ->
    # Draw our friend the inspected boid
    processing.stroke(0)
    processing.strokeWeight(1)
    processing.fill(230)
    processing.rect(0,0, 100, 100)
    processing.pushMatrix()
    processing.translate(50,50)
    processing.scale(2)
    boid._renderSelfWithIndicators([], false) # dont let it translate itself to its location
    processing.popMatrix()

  _drawStartNotification: (processing) ->
    processing.fill(0)
    processing.textFont(font, 12)
    processing.text("click me to start", processing.width/2-35, processing.height - 10)
