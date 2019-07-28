/* global Mover */
/* exported setup, draw */

const WIDTH = 1080
const HEIGHT = 920

const BALLONS_COUNT = 50
const FRICTION_C = 0.01
const NORMAL = 1

let balloons

let heliumForce
let windNoise

function setup () {
  createCanvas(WIDTH, HEIGHT)

  balloons = []

  for (let i = 0; i < BALLONS_COUNT; i++) {
    balloons.push(
      new Mover({
        location: createVector(0, 240),
        mass: Math.random() * 5 + 1
      })
    )
  }

  heliumForce = createVector(0, -0.1)
  windNoise = 0
}

function draw () {
  const wind = createVector((noise(0.06 * windNoise++) - 0.5) * 0.3, 0)
  clear()

  balloons.forEach(balloon => {
    const frictionMagnitude = FRICTION_C * NORMAL
    const friction = p5.Vector.mult(balloon.velocity, -1)
    friction.normalize()
    friction.mult(frictionMagnitude)

    balloon.applyForce(heliumForce)
    balloon.applyForce(wind)
    balloon.applyForce(friction)
    balloon.update()
    balloon.checkEdges({ width: WIDTH, height: HEIGHT })
    balloon.display()
  })
}
