import wollok.game.*
import naves.*

class Laser {
	var property position
	const sonidoChoque = new Sound(file = "llaser.wav")

	method serDisparado() {
		self.irAPosicionSiguiente() // En la nave es uno mas arriba, en los invaders uno mas abajo
		self.avanzar()
		game.addVisual(self) // Al ser disparado se muestra en pantalla
		self.configurarColicion()
		sonidoChoque.play()
	}

	method avanzar() {
		game.onTick(100, "DISPARO NAVE" + self.identity().toString(), { self.irAPosicionSiguiente()})
	}

	method irAPosicionSiguiente() {
		if(self.estaFueraDeLaPantalla()) {
			self.destruirse()
		}
	}

	method configurarColicion() {
		game.whenCollideDo(self, { algo => self.chocarCon(algo)})
	}

	method chocarCon(algo) {
		self.destruirse()
		algo.destruirse()
	}

	method destruirse() {
		game.removeVisual(self)
		game.removeTickEvent("DISPARO NAVE" + self.identity().toString()) 	// Elimino onTick para este laser en particular
	}
	
	method image() 
	
	method estaFueraDeLaPantalla()

}

class LaserNave inherits Laser {

	
	override method image() = "Rayo.png"

	override method irAPosicionSiguiente() {
		super() // Si está afuera de la pantalla lo destruye
		position = position.up(1)
	}
	
	override method estaFueraDeLaPantalla() = position.y() > game.height()

}

class LaserInvader inherits Laser {
	
	override method image() = "Rayo.png" /////////////////// Cambiar imagen y hacer metodo image abstracto

	override method irAPosicionSiguiente() {
		super() 	// Si está afuera de la pantalla lo destruye
		position = position.down(1)
	}
	
	override method estaFueraDeLaPantalla() = position.y() < 0

}