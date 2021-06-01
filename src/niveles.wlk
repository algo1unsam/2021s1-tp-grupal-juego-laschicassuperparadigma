import wollok.game.*
import naves.*
import lasers.*

object nivel1 {
	//Esto seria para probar. Deberia haber un invader en el medio sin hacer nada y la nave que pueda disparar
	method iniciar() {
		const invader1 = new Dalek()
		game.addVisual(nave) 	// Muestro el objeto en pantalla
		game.addVisual(invader1)
		configurar.teclas()
		//configurar.colisiones()
	}
}

object nivel2 {
	const property invaders = []
	
	method crearInvaders(n){ 	
		n.times({ i => invaders.add(new Dalek(position = self.posicionNuevoInvader(i,n))) })
		invaders.forEach({ invader => game.addVisual(invader) })
	}
	
	method posicionNuevoInvader(i,total){
		const separacionEntreInvaders = ((game.width()-2)/total).truncate(0) + 1 // Le resto dos para que no se pongan en el borde. Cambiar el 30 por widht
		const posicionPrimerInvader = ((game.width()-2)-(separacionEntreInvaders -1)*total)/2// Marca los espacios que hay que dejar antes de poner al primer invader
		
		return game.at(posicionPrimerInvader + separacionEntreInvaders*(i-1),20) // El i arranca en 1 en el times. Despues cambiar el 20
	}
	
	method moverInvaders(tiempo) {
		game.onTick(tiempo,"mover invaders",{ 
			invaders.forEach({ invader => invader.position(invader.position().right(1)) })
			game.schedule(tiempo/2,{ invaders.forEach({ invader => invader.position(invader.position().left(1)) }) })
		})
		game.onTick(tiempo*4,"Bajar invaders", { invaders.forEach({ invader => invader.position(invader.position().down(1)) }) })
	}

	method dispararLasersInvaders(tiempo) {
		game.onTick(tiempo,"Disparar invaders",{ invaders.anyOne().disparar() })
	}
	method iniciar() {
		game.addVisual(nave)
		self.crearInvaders(6)
		self.moverInvaders(1000)
		self.dispararLasersInvaders(3000)
		configurar.teclas()
	}

	//Agregar un gameover si los invaders llegan al piso
}

object nivel3 {
	method iniciar() {
		
	}
}

object configurar {
	method teclas(){ 
		keyboard.left().onPressDo({ nave.position(nave.position().left(1)) })
		keyboard.right().onPressDo({ nave.position(nave.position().right(1)) })
		keyboard.space().onPressDo({ nave.disparar() })
	}
//	method colisiones() {
//		game.whenCollideDo(nave, { algo => nave.chocarCon(algo) })
//	}
}