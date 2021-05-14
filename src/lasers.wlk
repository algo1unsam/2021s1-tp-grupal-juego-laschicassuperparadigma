import wollok.game.*
import naves.*

class LaserNave {

	var property position

	method avanzar() {
		// Cada 500 ms la bala avanza hacia arriba una celda
		game.onTick(500, "DISPARO NAVE", { position = self.position().up(1)})
	}

}

class LaserInvader {

	var property position // El laser arranca en la misma posicion que la nave en X y uno mas arriba en Y

	method avanzar() {
		// Cada 500 ms la bala avanza hacia arriba una celda
		game.onTick(500, "DISPARO INVADER", { position = self.position().down(1)})
	}

}

