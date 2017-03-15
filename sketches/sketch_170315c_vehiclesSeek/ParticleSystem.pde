
class ParticleSystem {

  ArrayList<Particle> particles;
  PVector             origin;
  PVector             deviate;

  PImage[]            pTextures;
  int                 pType;
  int                 pTexIndex;

  boolean             willReplaceExpired = true;

  ParticleSystem(int numOfParticles_, PVector origin_, PImage[] pTextures_, int pTexIndex_, int pType_) {

    particles    = new ArrayList<Particle>();    // initialize ArrayList of particles
    origin       = origin_.get();                // get() makes a copy, pass by reference?
    deviate      = new PVector();

    pTextures    = pTextures_;
    pType        = pType_;
    pTexIndex    = pTexIndex_;

    init(numOfParticles_);                    // initialize the System
  }

  void init(int numOfParticles) {
    for (int i = 0; i < numOfParticles; i ++) {
      addNewParticleToSystem();
    }
  }

  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {  
      Particle p = particles.get(i);

      p.run();

      removeReplaceParticleIfExpired(p, i);
    }
  }

  void removeReplaceParticleIfExpired(Particle p, int index) {
    if (p.isDead()) {
      particles.remove(index);                 // remove i, not p? p is a copy of i

      if (willReplaceExpired) addNewParticleToSystem();
    }
  }

  void seek(PVector target) {
    for (Particle p : particles) {
      p.seek(target);
    }
  }

  void applyForce(PVector dir) {
    for (Particle p : particles) {
      p.applyForce(dir);
    }
  }
  void addNewParticleToSystem() {
    deviate.x = origin.x + random(-40, 40);
    deviate.y = origin.y + random(-40, 40); 

    // PolyMorphism --> Particles AND Vehicles added to the ArrayList of Particles
    // since pType is constant within each ps, all particles within a ps have same texture
    if (pType == 0) particles.add(new Particle(deviate, pTextures[pTexIndex]));
    if (pType == 1) particles.add(new Vehicle(deviate, pTextures[pTexIndex], random(3, 9), random(.05, .1)));
  }

  // test whether the system is empty
  boolean isEmpty() {
    if (particles.size() <= 0) {
      return true;
    } else {
      return false;
    }
  }

  // are we a ps of with reynolds behavior? or just a bunch of lifeless particles?
  boolean canSeek() {
    if (pType == 1) {
      return true;
    } else {
      return false;
    }
  }
}