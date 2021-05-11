import wollok.game.*

class Astronave {
	var position
	var lasersDisparados = []	// Esto lo creo para que los lasers que crean el método disparar no mueran con el metodo. No se si hay alguna otra manera de hacerlo
	
	method lasersDisparados() = lasersDisparados
	
	method positionX() = position.x()
	
	method position(x) { position = game.at(x,0) } 	// Setea la posicion en X manteniendo la posicion en Y siempre en 0
}
class Nave inherits Astronave{
	//var position = game.at(game.center().x(), 0) 	// La nave empieza en el centro y abajo de todo
	var vidas = 3
	
	method position() = position
	
	method vidas() = vidas

	//method image() =//"nave.png"

	method chocar() {
		vidas -= 1
	}
	
	method disparar() {
		// instancio un objeto LaserNave y lo agrego a la lista
		// El laser arranca en la misma posicion que la nave en X y uno mas arriba en Y
		lasersDisparados.add(new LaserNave(position = game.at(nave.positionX(),1))) 	
	}

}	

const nave = new Nave(position = game.at(game.center().x(), 0)) 	

class LaserNave {
	var property position	
	
	method avanzar(){
		// Cada 500 ms la bala avanza hacia arriba una celda
		game.onTick(500, "DISPARO", { position = self.position().up(1) })

	}
}


