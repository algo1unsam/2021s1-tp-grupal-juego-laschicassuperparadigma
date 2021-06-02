import wollok.game.*
import lasers.*
import niveles.*


class Astronave {

	var property position = game.center()
	var property destruido = false // De esto depende la imagen que muestra. Despues se podria cambiar y animarlo bien
	var lasersDisparados = [] // Esto lo creo para que los lasers que crean el método disparar no mueran con el metodo. No se si hay alguna otra manera de hacerlo

	method lasersDisparados() = lasersDisparados

	method posicion(x, y) {
		position = game.at(x, y)
	}

	method destruirse() {
		destruido = true
		game.removeVisual(self)
	//
	}

	method image() // Metodo abstracto, todas las naves tienen que tenerlo

	method retornarNuevoLaser()

	method disparar() {
		// instancio un objeto LaserNave y lo agrego a la lista
		lasersDisparados.add(self.retornarNuevoLaser())
		lasersDisparados.last().serDisparado() // Disparo el que acabo de crear
	}


}

object nave inherits Astronave {
	
	var vidas = 3

	method vidas() = vidas
	
	method restarVida() {
		vidas -= 1
	}
	
	method irAPosicionInicial() {
		position = game.at(game.center().x(), 0)
	}

	override method image() = "Nave.png"
	
	override method destruirse() {
		super()
		self.restarVida()
		// Aunque no se vea puede seguir disparando. Habria que ver si se soluciona cuando entra la otra vida
	}

	method chocarCon(invader) {
		self.destruirse()
		invader.destruirse()
		
	}
	
	

	override method retornarNuevoLaser() = new LaserNave(position = self.position())

}

class Invader inherits Astronave {
	override method retornarNuevoLaser() = new LaserInvader(position = self.position())
	
	override method destruirse() {
		super()
		flotaInvader.quitarInvader(self)
	}
	
	method estaDentroDeLaPantalla() = position.y()>=0

}

class Bicho1 inherits Invader {

	// method image() = "naBe.png"

}

class Bicho2 inherits Invader {

	override method image() =  "Bicho1.png" 	////////////// Cambiar imagen

}

class Dalek inherits Invader {
	const sonidoChoque = new Sound(file = "explosion.wav")
	
	override method image() = "Bicho5.png"

	override method destruirse() {
		super()
		sonidoChoque.play() // Pasarlo a la super clase despues de agregar el sonido a la carpeta
		
	}
	
	// Empieza a tirar a lo loco y despues de 1500 ms para
	method iniciarBerretin() {
		// cambiar imagen
		game.onTick(200,"disparar ametralladora" + self.identity().toString(), { self.disparar() })
		game.schedule(1500,{ game.removeTickEvent("disparar ametralladora" + self.identity().toString()) })
	}
}





//const nave = new Nave(position = game.at(game.center().x(), 0))