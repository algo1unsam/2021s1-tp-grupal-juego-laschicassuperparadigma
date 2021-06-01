import wollok.game.*
import lasers.*
import niveles.*

class Astronave {

	var property position = game.center()
	var property destruido = false // De esto depende la imagen que muestra. Despues se podria cambiar y animarlo bien
	var lasersDisparados = [] // Esto lo creo para que los lasers que crean el método disparar no mueran con el metodo. No se si hay alguna otra manera de hacerlo

	method lasersDisparados() = lasersDisparados

	method posicion(x, y) {
		position = game.at(x, y)
	}

	method recibirDisparo() {
		self.destruirse()
	}

	method destruirse() {
		destruido = true
		game.removeVisual(self)
	//
	}

	method image() // Metodo abstracto, todas las naves tienen que tenerlo

	method retornarNuevoLaser()

	method disparar() {
		// instancio un objeto LaserNave y lo agrego a la lista
		lasersDisparados.add(self.retornarNuevoLaser())
		lasersDisparados.last().serDisparado() // Disparo el que acabo de crear
	}

//	method chocarCon(algo) {
//		nave.destruirse()
//		algo.destruirse()
//	}
}

class Nave inherits Astronave {

	var vidas = 3

	method vidas() = vidas

	override method image() = "Nave.png"

//	override method chocarCon(algo) {
//		vidas -= 1
//		super(algo) // Ejecuta el metodo padfre
//	}

	override method retornarNuevoLaser() = new LaserNave(position = self.position())

}



class Bicho1 inherits Invader {

	// method image() = "naBe.png"
	override method puntosQueDa() = 10

}

class Bicho2 inherits Invader {

	// method image() =  "Bicho1.png"
	override method puntosQueDa() = 20

}

class Dalek inherits Invader {
	const sonidoChoque = new Sound(file = "explosion.wav")
	
	override method image() = "Bicho5.png"
	
	override method puntosQueDa() = 40

	// Pongo esto provisoriamente para probar el sonido en esta nave
	// Todas las naves pueden tener un sonido cuando se destruyen. Habria que agregar eso.
	// Hacer esta parte es bastante clave para entender y juntar todos los temas que vimos.
	// Lo dejo por si alguno quiere pensarlo
	override method destruirse() {
		destruido = true
		game.removeVisual(self)
		sonidoChoque.play()
		//
		juego.quitarInvader(self)
		
	}
	
	// Empieza a tirar a lo loco y despues de 1500 ms para
	method iniciarBerretin() {
		// cambiar imagen
		game.onTick(200,"disparar ametralladora" + self.identity().toString(), { self.disparar() })
		game.schedule(1500,{ game.removeTickEvent("disparar ametralladora" + self.identity().toString()) })
	}
}

class Invader inherits Astronave {

	method puntosQueDa()

	override method retornarNuevoLaser() = new LaserInvader(position = self.position())
	
	override method destruirse() {
		super()
		//juego.quitarInvader(self)
	}
//	method moverse(tiempo) {
//		game.onTick(tiempo,"Moverse a la derecha" + self.identity().toString(), { position = position.right(1) })
//		game.schedule(tiempo/2, { game.onTick(tiempo,"Moverse a la izquierda" + self.identity().toString(), { position = position.left(1) }) })
//	}
		
//	method dejarDeMoverse() {
//		game.removeTickEvent("Moverse a la derecha" + self.identity().toString())
//		game.removeTickEvent("Moverse a la izquierda" + self.identity().toString())
//	}

}
const nave = new Nave(position = game.at(game.center().x(), 0))