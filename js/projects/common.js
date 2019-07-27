/* exported Mover, Liquid, Attractor */
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

  update () {
    this.velocity.add(this.acceleration)

    if (this.speedLimit) {
      this.velocity.limit(this.speedLimit)
    }

    this.location.add(this.velocity)
    this.acceleration.mult(0)
  }

  display () {
    strokeWeight(2)
    stroke(10)
    fill('rgba(100, 100, 100, .8)')
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

  isInsideRectangle (rectangle) {
    return (
      this.location.x >= rectangle.x &&
      this.location.x <= rectangle.x + rectangle.width &&
      this.location.y >= rectangle.y &&
      this.location.y <= rectangle.y + rectangle.height
    )
  }

  drag (liquid) {
    const speedSq = this.velocity.magSq()
    const dragMagnitude = speedSq * liquid.drag
    const dragVector = p5.Vector.mult(this.velocity, -1)
    dragVector.normalize()
    dragVector.mult(dragMagnitude)
    this.applyForce(dragVector)
  }
}

class Liquid {
  constructor ({ x, y, width, height, drag }) {
    this.x = x
    this.y = y
    this.width = width
    this.height = height
    this.drag = drag
  }

  display () {
    noStroke()
    fill(50)
    rect(this.x, this.y, this.width, this.height)
  }
}

class Attractor {
  constructor ({ mass = 1.0, location = createVector(0, 0), G = 1 } = {}) {
    this.location = location
    this.mass = mass
    this.G = G
  }

  display () {
    stroke(0)
    fill(175, 200)
    ellipse(this.location.x, this.location.y, this.mass * 10, this.mass * 10)
  }

  attract (other) {
    const force = p5.Vector.sub(this.location, other.location)
    const distanceSq = constrain(force.magSq(), 5, 25)
    force.normalize()
    const strength = (this.G * this.mass * other.mass) / distanceSq
    force.mult(strength)

    return force
  }
}
