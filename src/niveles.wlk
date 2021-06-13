import wollok.game.*
import naves.*
import lasers.*

// Instancio un objeto para la musica de fondo
const sonidoMusica = new Sound(file = "aroundTheWorld.mp3")

// Esto se ejecuta antes del game.start() entonces, al no haber arrancado
// el juego, la musica no se puede empezar a reproducir.
// Intente poner el sonidoMusica.play() dentro de un schedule pero no funciono
object inicio {	
	var property image = "spaceInvaders.png"
	method iniciar() {
		game.addVisualIn(self, game.at(0, 0)) // Muestra la imagen en la posicion 0,0
		game.schedule(500, {  pantallaInicial.iniciar() })
	}
	
}
object pantallaInicial {

	var property image = "spaceInvaders.png"

	method iniciar() {
		game.addVisualIn(self, game.at(0, 0)) // Muestra la imagen en la posicion 0,0
		sonidoMusica.play() // Inicia la musica de fondo
		configurar.musicaOnOff() // Pausa la musica apretando la "M"
		game.schedule(10000, { image = "instrucciones.png" // Cambia la imagen y pasa al nivel cuando se aprieta enter
			configurar.enterParaJugar()
		})
	}

	method finalizar() {
		game.clear() // Remuevo todos los visual
		self.siguiente().iniciar()
	}

	method siguiente() = nivel1

}

class Nivel {

	method iniciar() {
		game.addVisualIn(self, game.at(0, 0)) // Muestra la imagen en la posicion 0,0
		game.schedule(1000, { game.clear()
			self.iniciarNivel()
		})
	}

	method iniciarNivel() {
		game.addVisual(nave) // Muestro el objeto en pantalla
		nave.irAPosicionInicial() // centro
		configurar.teclas()
		configurar.musicaOnOff()
		configurar.configurarColisiones()
	}

	method finalizarNivel() {
		game.clear() // Remuevo todos los visual
		game.schedule(500, { self.siguiente().iniciar()})
	}

	method siguiente()

	method image()

}

object nivel1 inherits Nivel {

	override method iniciarNivel() {
		super()
		flotaInvader.crearInvaders(1, 0, game.center().y(), 18)
		flotaInvader.moverInvaders(1000, self)
		flotaInvader.dispararLasersInvaders(3000, self)
		nave.crearVidas()
		nave.mostrarVidas()
	}

	override method siguiente() = nivel2

	override method image() = "nivel1.png"

}

object nivel2 inherits Nivel {

	override method iniciarNivel() {
		super()
		flotaInvader.crearInvaders(6, 4, 0, 18)
		flotaInvader.moverInvaders(1000, self)
		flotaInvader.dispararLasersInvaders(3000, self)
		nave.mostrarVidas()
	}

	override method siguiente() = nivel3

	override method image() = "nivel2.png"

}

object nivel3 inherits Nivel {

	override method iniciarNivel() {
		super()
		flotaInvader.crearInvaders(11, 2, 0, 18)
		flotaInvader.moverInvaders(1000, self)
		flotaInvader.dispararLasersInvaders(3000, self)
		flotaInvader.iniciarPoderes(10000)
		nave.mostrarVidas()
	}

	override method siguiente() = fin

	override method image() = "nivel3.png"

}

object fin {

	var property image // / Cambia segun gane o pierda
	// const sonidoPerder = new Sound(file = "perder.wav")

	method ganar() {
		image = "ganaste.png"
		self.final()
	}

	method perder() {
		image = "gameOver.png"
			// sonidoPerder.play()
		self.final()
	}

	method final() {
		game.clear()
		game.addVisualIn(self, game.at(0, 0))
		configurar.enterParaFin() // Al presionar enterfinaliza
	}

}

object configurar {

	method teclas() {
		keyboard.left().onPressDo({ nave.position(nave.position().left(1))})
		keyboard.right().onPressDo({ nave.position(nave.position().right(1))})
		keyboard.space().onPressDo({ nave.disparar()})
	}

	method enterParaJugar() {
		keyboard.enter().onPressDo({ pantallaInicial.finalizar()})
	}

	method enterParaFin() {
		keyboard.enter().onPressDo({ game.stop()})
	}

	method musicaOnOff() {
		keyboard.m().onPressDo({ if (sonidoMusica.paused()) {
				sonidoMusica.resume()
			}
			else {
				sonidoMusica.pause()
			}
		})
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

