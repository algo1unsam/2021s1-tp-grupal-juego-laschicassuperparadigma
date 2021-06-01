import wollok.game.*
import naves.*
import lasers.*

// Agregar un gameover si los invaders llegan al piso
// Remover todos los onTick al pasar de nivel
class Nivel {

	method iniciar() {
		//game.addVisual(nave) // Muestro el objeto en pantalla
		configurar.teclas()
	}

	method finalizarNivel() {
		//game.schedule(1000, { game.clear()}) // Remuevo todos los visual
		game.schedule(2000, { self.siguiente().iniciar()})  // Faltaria poner alguna presentacion del nivel
	}
	
	method siguiente()

}

// Invader en el medio que no hace nada
object nivel1 inherits Nivel {

	override method iniciar() {
		super()
		game.addVisual(nave) // Muestro el objeto en pantalla
		flotaInvader.crearInvaders(1, 0, 11, 18)
		flotaInvader.moverInvaders(1000)
		flotaInvader.dispararLasersInvaders(3000, self)
	}
	
	override method siguiente() = nivel2

}

object nivel2 inherits Nivel {

	override method iniciar() {
		super()
		flotaInvader.crearInvaders(6, 4, 0, 18)
		flotaInvader.moverInvaders(1000)
		flotaInvader.dispararLasersInvaders(3000, self)
	}
	
	override method siguiente() = nivel3

}

object nivel3 inherits Nivel {

	override method iniciar() {
		super()
		flotaInvader.crearInvaders(11, 2, 0, 18)
		flotaInvader.moverInvaders(1000)
		flotaInvader.dispararLasersInvaders(3000, self)
		self.iniciarBerretinesInvaders(10000)
	}

	method iniciarBerretinesInvaders(tiempo) {
		game.onTick(tiempo, "Berretines", { flotaInvader.filaMasBaja().anyOne().iniciarBerretin()})
	}
	
	override method siguiente() = fin

}

object fin inherits Nivel{
	//method ganar()
	
	//method perder()
	
	override method iniciar() {
		
	}
	
	override method siguiente() {}
}

object configurar {

	method teclas() {
		keyboard.left().onPressDo({ nave.position(nave.position().left(1))})
		keyboard.right().onPressDo({ nave.position(nave.position().right(1))})
		keyboard.space().onPressDo({ nave.disparar()})
	}

}

object flotaInvader {

	const property invaders = []

	method agregarInvader(invader) {
		invaders.add(invader)
	}

	method quitarInvader(invader) {
		invaders.remove(invader)
	}

	method posicionYMasBaja() = invaders.map({ invader => invader.position().y() }).min()

	method filaMasBaja() = invaders.filter({ invader => invader.position().y() == self.posicionYMasBaja() })

	method crearInvaders(n, separacion, xPrimerInvader, y) {
		// Daleks. Los mas malos arriba de todo
		(n - 1).times({ i => self.agregarInvader(new Dalek(position = game.at(xPrimerInvader + (i - 1) * separacion + (separacion / 2), y)))})
			// Los del medio. Cambiar el Dalek por el bicho2 ///////
		n.times({ i => self.agregarInvader(new Dalek(position = game.at(xPrimerInvader + (i - 1) * separacion, y - 1)))})
			// Bicho1. Los mas buenitos abajo de todo. Cambiar por Bicho1///////
		(n - 1).times({ i => self.agregarInvader(new Dalek(position = game.at(xPrimerInvader + (i - 1) * separacion + (separacion / 2), y - 2)))})
		self.invaders().forEach({ invader => game.addVisual(invader)})
	}

	method moverInvaders(tiempo) {
		game.onTick(tiempo, "mover invaders", { self.invaders().forEach({ invader => invader.position(invader.position().right(1))})
			game.schedule(tiempo / 2, { self.invaders().forEach({ invader => invader.position(invader.position().left(1))})})
		})
		game.onTick(tiempo * 4, "Bajar invaders", { self.invaders().forEach({ invader => invader.position(invader.position().down(1))})})
	}

	// Dispara si hay invaders. Gano si no
	method dispararLasersInvaders(tiempo, nivel) {
		game.onTick(tiempo, "Disparar invaders", { if (not self.invaders().isEmpty()) {
				self.filaMasBaja().anyOne().disparar() // Disparan unicamente los unvaders que estan abajo de todo
			} else {
				nivel.finalizarNivel() // Si gana pasa al siguiente nivel
			}
		})
	}

}

