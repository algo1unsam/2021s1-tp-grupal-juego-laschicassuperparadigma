import wollok.game.*
import naves.*

class Laser {

	var property position
	var destruido = false

	method serDisparado() {
		self.irAPosicionSiguiente() // En la nave es uno mas arriba, en los invaders uno mas abajo
		self.avanzar()
		game.addVisual(self) // Al ser disparado se muestra en pantalla
		self.configurarColicion()
	}

	method avanzar() {
		game.onTick(200, "DISPARO NAVE", { self.irAPosicionSiguiente()})
	}

	method irAPosicionSiguiente() // Metodo abstracto. Los lasers lo tienen que tener para que funcione avanzar() y serDisparado()

	method configurarColicion() {
		game.whenCollideDo(self, { algo => self.chocarCon(algo)})
	}

	method chocarCon(algo) {
		self.destruirse()
		algo.destruirse()
	}

	method destruirse() {
		destruido = true
		game.removeVisual(self)
		// sacar onTick
	}

}

class LaserNave inherits Laser {

	
	method image() = "Rayo.png"

	override method irAPosicionSiguiente() {
		position = position.up(1)
	}

}

class LaserInvader inherits Laser {

	override method irAPosicionSiguiente() {
		position = position.down(1)
	}

}