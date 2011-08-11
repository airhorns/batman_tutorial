# Boid class for use in the index page. Ported almost directly from http://processingjs.org/learning/topic/flocking,
# thanks to Craig Reynold and Daniel Shiffman
class Harry.Boid
  location: false
  velocity: false
  renderedThisStep: false
  p: false
  r: 3
  maxSpeed: 2
  maxForce: 0.05
  mousePhobic: true
  forceInspection: false
  inspectable: false
  weights:
    separation: 2
    alignment: 1
    cohesion: 1
    gravity: 6
  indicators:
    separation: true
    separationRadius: false
    alignment: true
    alignmentNeighbours: false
    cohesion: true
    cohesionMean: false
    cohesionNeighbours: false
    velocity: true
    neighbours: true
    neighbourRadius: true

  desiredSeparation: 6
  neighbourRadius: 50
  wrapFactor: 1

  mouseRepulsion: 1
  mouseRadius: 5

  _separation: new Harry.Vector
  _alignment: new Harry.Vector
  _cohesion: new Harry.Vector
  _cohesionMean: new Harry.Vector

  constructor: (options = {}) ->
    throw "Boid needs a processing instance to render to! " unless options.processing || options.p
    throw "Boid needs a start velocity! " unless options.velocity
    throw "Boid needs a start position!" unless options.startPosition

    jQuery.extend(this, options)
    @r = options.radius if options.radius
    @p = (options.processing || options.p)
    @location = options.startPosition.copy()

    twor = @r * 2 * @wrapFactor
    @wrapDimensions =
      north:  -twor
      south:  @p.scaledHeight + twor
      west:   -twor
      east:   @p.scaledWidth + twor
      width:  @p.scaledWidth + 2*twor
      height: @p.scaledHeight + 2*twor

    @desiredSeparation = @desiredSeparation * @r

  step: (neighbours) ->
    acceleration = this._flock(neighbours).add(this._gravitate())
    this._move(acceleration)

  _move: (acceleration) ->
    this._wrapIfNeeded()
    @velocity.add(acceleration).limit(@maxSpeed)
    @location.add(@velocity)

  # Wraparound
  _wrapIfNeeded: () ->
    @location.x = @wrapDimensions.east if @location.x < @wrapDimensions.west    # go out west come in east
    @location.y = @wrapDimensions.south if @location.y < @wrapDimensions.north  # go out north come in south
    @location.x = @wrapDimensions.west if @location.x > @wrapDimensions.east    # go out east come in west
    @location.y = @wrapDimensions.north if @location.y > @wrapDimensions.south  # go out south come in north

  _flock: (neighbours) ->
    separation_mean = new Harry.Vector
    alignment_mean = new Harry.Vector
    cohesion_mean = new Harry.Vector

    separation_count = 0
    alignment_count = 0
    cohesion_count = 0

    # Each flocking behaviour did this loop, so lets put them together into one
    for boid in neighbours
      continue if boid == this
      d = @location.eucl_distance(boid.location,@wrapDimensions)
      if d > 0
        if d < @desiredSeparation
          separation_mean.add Harry.Vector.subtract(@location,boid.location).copy().normalize().divide(d) # Normalized,weighted by distance vector pointing away from the neighbour
          separation_count++
        if d < @neighbourRadius
          alignment_mean.add(boid.velocity)
          alignment_count++
          cohesion_mean.add(boid.location.wrapRelativeTo(@location,@wrapDimensions))
          cohesion_count++

    separation_mean.divide(separation_count) if separation_count > 0
    alignment_mean.divide(alignment_count) if alignment_count > 0

    if cohesion_count > 0
      cohesion_mean.divide(cohesion_count)
    else
      cohesion_mean = @location.copy()

    @_cohesionMean = cohesion_mean.copy().subtract(@location)
    cohesion_direction = this.steer_to cohesion_mean
    alignment_mean.limit(@maxForce)

    # Store these as temporary variables for use in the indicators.
    # Only the return value of the function is actually used for calculation
    @_separation = separation_mean.multiply(@weights.separation)
    @_alignment = alignment_mean.multiply(@weights.alignment)
    @_cohesion = cohesion_direction.multiply(@weights.cohesion)
    return @_separation.add(@_alignment).add(@_cohesion)


  # Adds negative gravity from the mouse
  _gravitate: () ->
    gravity = new Harry.Vector

    if @mousePhobic
      mouse = Harry.Vector.subtract(Harry.Mouse, @location)
      d = mouse.magnitude() - @mouseRadius
      d = 0.01 if d < 0
      if d > 0 && d < @neighbourRadius*5
        gravity.add mouse.normalize().divide(d*d).multiply(-1)

    return gravity.multiply(@weights.gravity)


  steer_to: (target) ->
    desired = Harry.Vector.subtract(target, @location) # A vector pointing from the location to the target
    d = desired.magnitude()  # Distance from the target is the magnitude of the vector
    # If the distance is greater than 0, calc steering (otherwise return zero vector)
    if d > 0
      # Normalize desired
      desired.normalize()
      # Two options for desired vector magnitude (1 -- based on distance, 2 -- maxspeed)
      if d < 100.0
        desired.multiply(@maxSpeed*(d/100.0)) # This damping is somewhat arbitrary
      else
        desired.multiply(@maxSpeed)
        # Steering = Desired minus Velocity
      steer = desired.subtract(@velocity)
      steer.limit(@maxForce)  # Limit to maximum steering force
    else
      steer = new Harry.Vector(0,0)
    return steer

  inspecting: () ->
    return true if @forceInspection
    return false unless @inspectable
    d = Harry.Vector.subtract(Harry.Mouse, @location)
    d.magnitude() < @r * 2 # HACKETYHACKHACK


   render: (neighbours) ->
    if this.inspecting()
      @p.pushMatrix()
      @p.translate(@location.x,@location.y)
      # Draw neighbour radius
      if @indicators.neighbourRadius
        @p.fill(100,200,50, 100)
        @p.stroke(100,200,50, 200)
        @p.ellipse(0,0, @neighbourRadius*2, @neighbourRadius*2)

      # Draw separation radius
      if @indicators.separationRadius
        @p.fill(200,10,10,100)
        @p.stroke(200,10,10,200)
        @p.ellipse(0,0, @desiredSeparation*2, @desiredSeparation*2)

      @p.popMatrix()
      this._renderSelfWithIndicators(neighbours)

      # Highlight neighbours
      if @indicators.neighbours
        for boid in neighbours
          continue if boid == this
          d = @location.distance(boid.location,@wrapDimensions)
          if d > 0 && d < @neighbourRadius
            if d < @desiredSeparation && @indicators.separation
              # Highlight other boids which are too close in red
              @p.fill(250,0,0)
              @p.stroke(100,0,0)
            else
              # Highlight other neighbouring boids which affect cohesion and alignment in green
              @p.fill(0,100,0)
              @p.stroke(0,100,0)
            boid._renderSelf(true)

    else
      # Standard Render
      @p.fill(70)
      @p.stroke(0,0,255)
      this._renderSelf()

  # Expects the colour to be set already
  _renderSelf: (rerender = false, translate = true) ->
    @p.strokeWeight(1)
    unless rerender
      return if @renderedThisStep # don't render twice unless forced
    @renderedThisStep = true
    # Draw a triangle rotated in the direction of velocity
    theta = @velocity.heading() + @p.radians(90)
    @p.pushMatrix()
    @p.translate(@location.x,@location.y) if translate
    @p.rotate(theta)
    @p.beginShape(@p.TRIANGLES)
    @p.vertex(0, -1 * @r *2)
    @p.vertex(-1 * @r, @r * 2)
    @p.vertex(@r, @r * 2)
    @p.endShape()
    @p.popMatrix()

  _renderSelfWithIndicators: (neighbours, translate = true) ->
      # Render self
      @p.fill(200,0,200)
      @p.stroke(250,0,250)
      this._renderSelf(true, translate)

      # Draw component vectors
      @p.pushMatrix()
      @p.translate(@location.x,@location.y) if translate

      #Velocity - black
      if @indicators.velocity
        @p.stroke(0,0,0)
        @p.fill(0,0,0)
        this._renderVector(@velocity)

      # Seperation - red
      if @indicators.separation
        @p.stroke(250,0,0)
        @p.fill(250,0,0)
        this._renderVector(@_separation, 100)

      # Alignment - green
      if @indicators.alignment
        @p.stroke(0,250,0)
        @p.fill(0,250,0)
        this._renderVector(@_alignment, 300)

      # Alignment Neighbours - dark green
      if @indicators.alignmentNeighbours
        @p.stroke(0,175,0)
        @p.fill(0,175,0)
        for boid in neighbours
          continue if boid == this
          d = @location.distance(boid.location, @wrapDimensions)
          if d > 0 && d < @neighbourRadius
            @p.pushMatrix()
            spot = boid.location.copy().subtract(@location)
            @p.translate(spot.x, spot.y)
            this._renderVector(boid.velocity.copy().add(boid.velocity.copy().normalize().multiply(1.5)),7)
            @p.popMatrix()

      # Cohesion - blue
      if @indicators.cohesion
        @p.stroke(0,0,250)
        @p.fill(0,0,250)
        this._renderVector(@_cohesion, 300)

      if @indicators.cohesionMean
        # Cohesion mean - blue
        @p.stroke(250,0,250)
        @p.fill(250,0,250)
        this._renderVector(@_cohesionMean, 1)

      if @indicators.cohesionNeighbours
        @p.stroke(100,0,100)
        @p.fill(100,0,100)
        @p.pushMatrix()
        spot = @_cohesionMean.copy().add(@location)
        @p.translate(@_cohesionMean.x, @_cohesionMean.y)
        for boid in neighbours
          continue if boid == this
          d = @location.eucl_distance(boid.location)
          if d > 0 && d < @neighbourRadius
            this._renderVector(boid.location.copy().subtract(spot),1)
        @p.popMatrix()

      @p.popMatrix()

  # Have location and color set by the calling function
  _renderVector: (vector, scale=10) ->
    m = vector.magnitude() * scale
    r = 2
    @p.pushMatrix()
    theta = vector.heading() - @p.radians(90)
    @p.rotate(theta)
    @p.line(0,0,0,m)
    @p.beginShape(@p.TRIANGLES)
    @p.vertex(0,m)
    @p.vertex(0-r, m - r*2)
    @p.vertex(0+r, m - r*2)
    @p.endShape()
    @p.popMatrix()

