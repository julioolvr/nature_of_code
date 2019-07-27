/* global Mover, Attractor */
/* exported setup, draw */

const WIDTH = 640
const HEIGHT = 480

let mover
let attractor

function setup () {
  mover = new Mover({
    location: createVector(WIDTH / 2, 20)
  })

  attractor = new Attractor({
    location: createVector(WIDTH / 2, HEIGHT / 2),
    mass: 5
  })

  // Apply an initial "kick" to make it more interesting
  mover.applyForce(createVector(5, 0))

  createCanvas(WIDTH, HEIGHT)
}

function draw () {
  background(255)
  attractor.display()

  const gravity = attractor.attract(mover)
  mover.applyForce(gravity)

  mover.update()
  mover.display()
}
