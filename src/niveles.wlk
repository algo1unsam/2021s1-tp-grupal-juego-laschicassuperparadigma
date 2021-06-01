import wollok.game.*
import naves.*
import lasers.*

// Invader en el medio que no hace nada
object nivel1 {

	method iniciar() {
		const invader1 = new Dalek()
		game.addVisual(nave) // Muestro el objeto en pantalla
		game.addVisual(invader1)
		configurar.teclas()
	}

}

object nivel2 {

	method crearInvaders(n) { // Esto no me gusta, despues habria que hubicarlos donde van y listo
		n.times({ i => juego.agregarInvader(new Dalek(position = self.posicionNuevoInvader(i, n)))})
		juego.invaders().forEach({ invader => game.addVisual(invader)})
	}

	method posicionNuevoInvader(i, total) {
		const separacionEntreInvaders = ((game.width() - 2) / total).truncate(0) + 1 // Le resto dos para que no se pongan en el borde.
		const posicionPrimerInvader = ((game.width() - 2) - (separacionEntreInvaders - 1) * total) / 2 // Marca los espacios que hay que dejar antes de poner al primer invader
		return game.at(posicionPrimerInvader + separacionEntreInvaders * (i - 1), 18) // El i arranca en 1 en el times. Despues cambiar el 20
	}

	method moverInvaders(tiempo) {
		game.onTick(tiempo, "mover invaders", { juego.invaders().forEach({ invader => invader.position(invader.position().right(1))})
			game.schedule(tiempo / 2, { juego.invaders().forEach({ invader => invader.position(invader.position().left(1))})})
		})
		game.onTick(tiempo * 4, "Bajar invaders", { juego.invaders().forEach({ invader => invader.position(invader.position().down(1))})})
	}

	// Dispara si hay invaders. Game Over si no
	method dispararLasersInvaders(tiempo) {
		game.onTick(tiempo, "Disparar invaders", { 
			if(not juego.invaders().isEmpty()) {
				juego.invaders().anyOne().disparar()
			}
//			else {
//				// Game Over
//			}
		})
	}

	method iniciar() {
		game.addVisual(nave)
		self.crearInvaders(6)
		self.moverInvaders(1000)
		self.dispararLasersInvaders(3000)
		configurar.teclas()
	}

// Agregar un gameover si los invaders llegan al piso
// Remover todos los onTick al pasar de nivel
}

object nivel3 {


	method iniciar() {
		self.iniciarBerretinesInvaders(8000)
	}

	method iniciarBerretinesInvaders(tiempo) {
		game.onTick(tiempo, "Berretines", { juego.invaders().anyOne().iniciarBerretin()})
	}

}

object configurar {

	method teclas() {
		keyboard.left().onPressDo({ nave.position(nave.position().left(1))})
		keyboard.right().onPressDo({ nave.position(nave.position().right(1))})
		keyboard.space().onPressDo({ nave.disparar()})
	}

}

object juego {
	const property invaders = []
	
	method agregarInvader(invader) { invaders.add(invader) }
	
	method quitarInvader(invader) { invaders.remove(invader) }
}