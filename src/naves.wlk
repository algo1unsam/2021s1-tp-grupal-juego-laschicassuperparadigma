import wollok.game.*
import lasers.*

class Astronave {

	var property position = game.center()
	var property destruido = false // De esto depende la imagen que muestra. Despues se podria cambiar y animarlo bien
	var lasersDisparados = [] // Esto lo creo para que los lasers que crean el método disparar no mueran con el metodo. No se si hay alguna otra manera de hacerlo

	method lasersDisparados() = lasersDisparados

	method positionX() = position.x()

	method posicion(x, y) {
		position = game.at(x, y)
	}

	method recibirDisparo() {
		self.destruirse()
	}

	method destruirse() {
		destruido = true
	//
	}

	//method image()  Hacer metodo abstracto para que todas las naves tengan que sobreescribirlo?
}

class Nave inherits Astronave {

	var vidas = 3

	method vidas() = vidas

	// method image() =//"nave.png"
	method chocarCon(algo) {
		vidas -= 1
		algo.destruirse()
	}

	method disparar() {
		// instancio un objeto LaserNave y lo agrego a la lista
		// El laser arranca en la misma posicion que la nave en X y uno mas arriba en Y
		lasersDisparados.add(new LaserNave(position = self.position().up(1)))
	}

}

class Invader inherits Astronave {

	method disparar() {
		lasersDisparados.add(new LaserInvader(position = self.position().down(1)))
	}
	
	method puntosQueDa()
	
}

class Sontaran inherits Invader {
	
	// method image() = return "nave.png"
	override method puntosQueDa() = 10
}
class VashtaNerada inherits Invader {
	// method image() = return "nave.png"
	override method puntosQueDa() = 20
}

class Dalek inherits Invader {
	// method image() = return "nave.png"
	override method puntosQueDa() = 40
}
const nave = new Nave(position = game.at(game.center().x(), 0))

