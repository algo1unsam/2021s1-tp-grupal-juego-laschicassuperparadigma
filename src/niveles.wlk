import wollok.game.*
import naves.*
import lasers.*

class Nivel {

	method iniciar() {
		game.addVisual(nave) // Muestro el objeto en pantalla
		nave.irAPosicionInicial() // centro
		configurar.teclas()
		configurar.configurarColisiones()
	}

	method finalizarNivel() {
		game.clear() // Remuevo todos los visual
		game.schedule(500, { self.siguiente().iniciar()})
	}

	method siguiente()

}

object pantallaInicial inherits Nivel {
		//////////

	override method iniciar() {
		super()
		configurar.enterParaJugar()
	}
	
	method image() = "space.jpg"
	

	override method siguiente() = nivel1

}

object nivel1 inherits Nivel {
	
	override method iniciar() {
		super()
		flotaInvader.crearInvaders(1, 0, game.center().y(), 18)
		flotaInvader.moverInvaders(1000, self)
		flotaInvader.dispararLasersInvaders(3000, self)
		nave.crearVidas()
		nave.mostrarVidas()
	}

	override method siguiente() = nivel2

}

object nivel2 inherits Nivel {

	override method iniciar() {
		super()
		flotaInvader.crearInvaders(6, 4, 0, 18)
		flotaInvader.moverInvaders(1000, self)
		flotaInvader.dispararLasersInvaders(3000, self)
		nave.mostrarVidas()
	}

	override method siguiente() = nivel3

}

object nivel3 inherits Nivel {

	override method iniciar() {
		super()
		flotaInvader.crearInvaders(11, 2, 0, 18)
		flotaInvader.moverInvaders(1000, self)
		flotaInvader.dispararLasersInvaders(3000, self)
		flotaInvader.iniciarPoderes(10000)
		nave.mostrarVidas()
	}

	override method siguiente() = fin

}

object fin inherits Nivel {

	// method ganar()
	method perder() {
		game.stop()
	}
	override method iniciar() {
	}

	override method siguiente() {
		game.stop()
	}

}

object configurar {
	method teclas() {
		keyboard.left().onPressDo({ nave.position(nave.position().left(1)) })
		keyboard.right().onPressDo({ nave.position(nave.position().right(1)) })
		keyboard.space().onPressDo({ nave.disparar() })
	}

	method enterParaJugar() {
		keyboard.enter().onPressDo({ pantallaInicial.finalizarNivel()})
	}

	method configurarColisiones() {
		game.whenCollideDo(nave, { invader => nave.chocarCon(invader)})
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
		n.times({ i => self.agregarInvader(new Bicho2(position = game.at(xPrimerInvader + (i - 1) * separacion, y - 1)))})
			// Bicho1. Los mas buenitos abajo de todo. Cambiar por Bicho1///////
		(n - 1).times({ i => self.agregarInvader(new Bicho1(position = game.at(xPrimerInvader + (i - 1) * separacion + (separacion / 2), y - 2)))})
		self.invaders().forEach({ invader => game.addVisual(invader)})
	}

	method moverInvaders(tiempo, nivel) {
		game.onTick(tiempo, "mover invaders", { self.invaders().forEach({ invader => invader.position(invader.position().right(1))})
			game.schedule(tiempo / 2, { self.invaders().forEach({ invader => invader.position(invader.position().left(1))})})
		})
		game.onTick(tiempo * 4, "Bajar invaders", { self.invaders().forEach({ invader => invader.position(invader.position().down(1))}) // Baja de posicion
			if (invaders.any({ invader => not invader.estaDentroDeLaPantalla() })) { // Si al bajar quedo fuera de la pantalla lo destruye
				self.ganoLaInvasion(nivel)
			}
		})
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

	// Si un invader pasa, resta una vida y empieza de nuevo
	method ganoLaInvasion(nivel) {
		nave.destruirse()
		invaders.forEach({ invader => invaders.remove(invader)})
		game.clear() // Remuevo todos los visual
		game.schedule(3000, { nivel.iniciar()}) // Faltaria poner alguna presentacion del nivel
	}

	method iniciarPoderes(tiempo) {
		game.onTick(tiempo, "Berretines", { self.filaMasBaja().anyOne().iniciarPoder()})
	}

}

