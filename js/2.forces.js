const WIDTH = 640;
const HEIGHT = 480;

const BALLONS_COUNT = 50;
const FRICTION_C = 0.01;
const NORMAL = 1;

let balloons;

let heliumForce;
let windNoise;

function setup() {
  createCanvas(WIDTH, HEIGHT);

  balloons = [];

  for (let i = 0; i < BALLONS_COUNT; i++) {
    balloons.push(
      new Mover({
        location: createVector(0, 240),
        mass: Math.random() * 5 + 1
      })
    );
  }

  heliumForce = createVector(0, -0.1);
  windNoise = 0;
}

function draw() {
  const wind = createVector((noise(0.06 * windNoise++) - 0.5) * 0.3, 0);
  clear();

  balloons.forEach(balloon => {
    const frictionMagnitude = FRICTION_C * NORMAL;
    const friction = p5.Vector.mult(balloon.velocity, -1);
    friction.normalize();
    friction.mult(frictionMagnitude);

    balloon.applyForce(heliumForce);
    balloon.applyForce(wind);
    balloon.applyForce(friction);
    balloon.update();
    balloon.checkEdges({ width: WIDTH, height: HEIGHT });
    balloon.display();
  });
}

class Mover {
  constructor({
    mass = 1.0,
    location = createVector(0, 0),
    velocity = createVector(0, 0),
    acceleration = createVector(0, 0),
    size = { width: mass * 16, height: mass * 16 },
    speedLimit
  } = {}) {
    this.location = location;
    this.velocity = velocity;
    this.acceleration = acceleration;
    this.speedLimit = speedLimit;
    this.size = size;
    this.mass = mass;
  }

  update(context) {
    this.velocity.add(this.acceleration);

    if (this.speedLimit) {
      this.velocity.limit(this.speedLimit);
    }

    this.location.add(this.velocity);
    this.acceleration.mult(0);
  }

  display() {
    strokeWeight(2);
    fill("rgba(100, 100, 100, .2)");
    ellipse(
      this.location.x,
      this.location.y,
      this.size.width,
      this.size.height
    );
  }

  applyForce(force) {
    this.acceleration.add(p5.Vector.div(force, this.mass));
  }

  checkEdges({ width, height }) {
    if (this.location.x > width) {
      this.location.x = width;
      this.velocity.x *= -1;
    } else if (this.location.x < 0) {
      this.location.x = 0;
      this.velocity.x *= -1;
    }

    if (this.location.y > height) {
      this.location.y = height;
      this.velocity.y *= -1;
    } else if (this.location.y < 0) {
      this.location.y = 0;
      this.velocity.y *= -1;
    }
  }
}
