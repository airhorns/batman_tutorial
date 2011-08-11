  options =
    width: 900
    height: 600
    boids: 80
    boid:
      radius: 3
      mousePhobic: true
      maxSpeed: 3
      maxForce: 0.06
      desiredSeparation: 5
    inspectOne: true
    legend: true
    startOnPageLoad: true
    controls: false
    scale: 2

  div = $("#flock")
  canvas = $('<canvas></canvas>').attr('width', options.width).attr('height', options.height).appendTo(div)[0]
  window.Flock = flock = new Harry.Flock(canvas, options)
