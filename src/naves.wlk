import wollok.game.*
import lasers.*
import niveles.*
import flotaInvader.*

class Astronave {

	var property position = game.center()
	var lasersDisparados = [] // Esto lo creo para que los lasers que crean el método disparar no mueran con el metodo.
	
	method lasersDisparados() = lasersDisparados

	method destruirse() {
		game.removeVisual(self)
	}



	method disparar() {
		lasersDisparados.add(self.retornarNuevoLaser()) // instancio un objeto LaserNave y lo agrego a la lista
		lasersDisparados.last().serDisparado() // Disparo el que acabo de crear
	}
	
	method image()
	
	method retornarNuevoLaser()
	

}

object nave inherits Astronave {
	const sonidosPerderVidas = [new Sound(file = "perder.wav")]
	var cantVidas = 3
	var vidas = []

	method restarVida() {
		
		sonidosPerderVidas.first().play()
		sonidosPerderVidas.remove(sonidosPerderVidas.first())
		sonidosPerderVidas.add(new Sound(file = "perder.wav")) // Agrego un sonido para poder reproducirlo la segunda vez
		cantVidas -= 1
		if (cantVidas == 0) {
			fin.perder()
		}
		if (not vidas.isEmpty()) {
			game.removeVisual(vidas.last())
			vidas.remove(vidas.last())
		}
	}

	method crearVidas() {
		(cantVidas - 1).times({ i => vidas.add(new Vida(position = game.at(i - 1, 20)))})
	}

	method mostrarVidas() {
		vidas.forEach({ vida => game.addVisual(vida)})
	}

	method irAPosicionInicial() {
		position = game.at(game.center().x(), 0)
	}

	override method image() = "Nave.png"

	override method destruirse() {	// No saca el visual porque entra la otra vida
		self.restarVida()
	}

	method chocarCon(invader) {
		self.destruirse()
		invader.destruirse()
	}

	override method retornarNuevoLaser() = new LaserNave(position = self.position())
	
	method moverseDerecha() {
		if( not self.estaEnElBordeDerecho()) {
			position = position.right(1)
		}	
	}
	
	method moverseIzquierda() {
		if( not self.estaEnElBordeIzquierdo()) {
			position = position.left(1)
		}	
	}
	method estaEnElBordeDerecho() = position.x() == game.width() - 1 
	
	method estaEnElBordeIzquierdo() = position.x() == 0

}

class Invader inherits Astronave {

	const sonidoChoque = new Sound(file = "explosion.wav")

	override method retornarNuevoLaser() = new LaserInvader(position = self.position())

	override method destruirse() {
		super()
		sonidoChoque.play() 
		flotaInvader.quitarInvader(self)
	}

	method estaDentroDeLaPantalla() = position.y() >= 0
	
	method iniciarPoder()

}

class Bicho1 inherits Invader {

	override method image() = "Bicho10.png" 	
	override method iniciarPoder() {}	// No tienen poder
}

class Bicho2 inherits Invader {

	override method image() = "Bicho2.png" 
	
	// Empieza a tirar a lo loco y despues de 1500 ms para
	override method iniciarPoder() {
		game.onTick(200, "disparar ametralladora" + self.identity().toString(), { self.disparar()})
		game.schedule(1500, { game.removeTickEvent("disparar ametralladora" + self.identity().toString())})
	}

}

class Dalek inherits Invader {
	var creoInvader = false
	override method image() = "Bicho5.png" 

	override method iniciarPoder() {
		if(not creoInvader) {
			const nuevoInvader = new Bicho2(position = self.position().right(1))
			flotaInvader.agregarInvader(nuevoInvader)
			game.addVisual(nuevoInvader)
			creoInvader = true // Para que no clone de nuevo y mate al que creo
		}
		
	}
	
}



class Vida {

	var property position = game.center()

	method image() = "Nave.png"
	
	method destruirse(){}	// No hace nada cuando le da un laser. Polimorfismo =P

}
