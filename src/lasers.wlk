import wollok.game.*
import naves.*

class LaserNave {

	var property position
     
     
     //prueba!!!!!!!!
     
     
	method image() = "Rayo.png"

	method avanzar() {
		// Cada 500 ms la bala avanza hacia arriba una celda
		game.onTick(500, "DISPARO NAVE", { self.tiro()})
	}

	method tiro() {
		 position = position.up(1)
	}

}

class LaserInvader {

	var property position // El laser arranca en la misma posicion que la nave en X y uno mas arriba en Y

	method avanzar() {
		// Cada 500 ms la bala avanza hacia arriba una celda
		game.onTick(500, "DISPARO INVADER", { position = self.position().down(1)})
	}

}

