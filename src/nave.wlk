import wollok.game.*

object nave {
	var position = game.at(game.center().x(), 0) 	// La nave empieza en el centro y abajo de todo
	var vidas = 3
	var lasersDisparados = []	// Esto lo creo para que los lasers que crean el método disparar no mueran con el metodo. No se si hay alguna otra manera de hacerlo
	
	method position() = position
	
	method lasersDisparados() = lasersDisparados
	
	method position(x) { position = game.at(x,0) } 	// Setea la posicion en X manteniendo la posicion en Y siempre en 0
	
	method vidas() = vidas

	//method image() =//"nave.png"

	method chocar() {
		vidas -= 1
	}
	
	method positionX() = position.x()
	
	method disparar() {
		// instancio un objeto LaserNave y lo agrego a la lista
		lasersDisparados.add(new LaserNave())
		
	}

}	

class LaserNave {
	var property position = game.at(nave.positionX(),1)	// El laser arranca en la misma posicion que la nave en X y uno mas arriba en Y
	
	method avanzar(){
		// Cada 500 ms la bala avanza hacia arriba una celda
		game.onTick(500, "DISPARO", { position = self.position().up(1) })

	}
}


