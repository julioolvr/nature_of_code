/* global Mover, Liquid */
/* exported setup, draw */

const WIDTH = 1080
const HEIGHT = 920

let liquid
let movers

function setup () {
  liquid = new Liquid({
    x: 0,
    y: HEIGHT / 2,
    width: WIDTH,
    height: HEIGHT / 2,
    drag: 0.1
  })

  movers = []
  for (let i = 0; i < 10; i++) {
    movers.push(
      new Mover({
        location: createVector((WIDTH / 11) * (i + 1), 0),
        mass: random(0.5, 5)
      })
    )
  }

  createCanvas(WIDTH, HEIGHT)
}

function draw () {
  background(255)

  liquid.display()

  movers.forEach(mover => {
    if (mover.isInsideRectangle(liquid)) {
      mover.drag(liquid)
    }

    const gravity = createVector(0, 0.1 * mover.mass)
    mover.applyForce(gravity)
    mover.update()
    mover.display()
    mover.checkEdges({ width: WIDTH, height: HEIGHT })
  })
}
