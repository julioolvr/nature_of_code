/* exported Mover */
class Mover {
  constructor ({
    mass = 1.0,
    location = createVector(0, 0),
    velocity = createVector(0, 0),
    acceleration = createVector(0, 0),
    size = { width: mass * 16, height: mass * 16 },
    speedLimit
  } = {}) {
    this.location = location
    this.velocity = velocity
    this.acceleration = acceleration
    this.speedLimit = speedLimit
    this.size = size
    this.mass = mass
  }

  update (context) {
    this.velocity.add(this.acceleration)

    if (this.speedLimit) {
      this.velocity.limit(this.speedLimit)
    }

    this.location.add(this.velocity)
    this.acceleration.mult(0)
  }

  display () {
    strokeWeight(2)
    fill('rgba(100, 100, 100, .2)')
    ellipse(this.location.x, this.location.y, this.size.width, this.size.height)
  }

  applyForce (force) {
    this.acceleration.add(p5.Vector.div(force, this.mass))
  }

  checkEdges ({ width, height }) {
    if (this.location.x > width) {
      this.location.x = width
      this.velocity.x *= -1
    } else if (this.location.x < 0) {
      this.location.x = 0
      this.velocity.x *= -1
    }

    if (this.location.y > height) {
      this.location.y = height
      this.velocity.y *= -1
    } else if (this.location.y < 0) {
      this.location.y = 0
      this.velocity.y *= -1
    }
  }
}
