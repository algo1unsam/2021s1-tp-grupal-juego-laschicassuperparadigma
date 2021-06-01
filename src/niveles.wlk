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

	method crearInvaders(n,separacion,xPrimerInvader,y) { // Esto no me gusta, despues habria que hubicarlos donde van y listo
		// Daleks. Los mas malos arriba de todo
		(n-1).times({ i => flotaInvader.agregarInvader(new Dalek(position = game.at(xPrimerInvader+(i-1)*separacion+(separacion/2),y))) })
		
		// Los del medio. Cambiar el Dalek por el bicho2 ///////
		n.times({ i => flotaInvader.agregarInvader(new Dalek(position = game.at(xPrimerInvader+(i-1)*separacion,y-1))) })
		
		// Bicho1. Los mas buenitos abajo de todo. Cambiar por Bicho1///////
		(n-1).times({ i => flotaInvader.agregarInvader(new Dalek(position = game.at(xPrimerInvader+(i-1)*separacion+(separacion/2),y-2))) })
		
		flotaInvader.invaders().forEach({ invader => game.addVisual(invader)})
	}


	method moverInvaders(tiempo) {
		game.onTick(tiempo, "mover invaders", { flotaInvader.invaders().forEach({ invader => invader.position(invader.position().right(1))})
			game.schedule(tiempo / 2, { flotaInvader.invaders().forEach({ invader => invader.position(invader.position().left(1))})})
		})
		game.onTick(tiempo * 4, "Bajar invaders", { flotaInvader.invaders().forEach({ invader => invader.position(invader.position().down(1))})})
	}

	// Dispara si hay invaders. Gano si no
	method dispararLasersInvaders(tiempo) {
		game.onTick(tiempo, "Disparar invaders", { 
			if(not flotaInvader.invaders().isEmpty()) {
				flotaInvader.filaMasBaja().anyOne().disparar() //Disparan unicamente los unvaders que estan abajo de todo
			}
//			else {
//				// Gano
//			}
		})
	}

	method iniciar() {
		game.addVisual(nave)
		self.crearInvaders(6,4,0,18)
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
		game.onTick(tiempo, "Berretines", { flotaInvader.invaders().anyOne().iniciarBerretin()})
	}

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
	
	method agregarInvader(invader) { invaders.add(invader) }
	
	method quitarInvader(invader) { invaders.remove(invader) }
	
	method posicionYMasBaja() = invaders.map({ invader => invader.position().y()}).min()
	
	method filaMasBaja() = invaders.filter({ invader => invader.position().y() == self.posicionYMasBaja()})
}