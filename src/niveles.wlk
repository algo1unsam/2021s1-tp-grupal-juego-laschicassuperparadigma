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
	method iniciar() {
		
	}
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