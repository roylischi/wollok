// TIPS: 1- Las listas son siempre CONST -> para que no cambie la referencia
//       2- Si hay viñetas (punteo) posiblemente sea Strategy

// Punto 1: un lugar es divertido

// Ciudad es clase ya que tiene estado y comportamiento general

class Lugar {

// Punto 1 
  const nombre
  method esDivertido() = self.cantidadLetras().even() && self.condicionParticular()

  method condicionParticular()

  method cantidadLetras() = nombre.length()

// Punto 2
  method esTranquilo()

  method nombreRaro() = self.cantidadLetras() > 30

}

class Ciudad inherits Lugar{

// Punto 1
  const atracciones=[]
  var property cantidadHabitantes
  const cantidadDecibeles

  // method esDivertido() = nombre.length().even() -> Acceso directo
  // method esDivertido() = self.length().even() -> Acceso indirecto

  override method condicionParticular() = atracciones.length() > 3 && cantidadHabitantes > 10000

// Punto 2
  override method esTranquilo() = cantidadDecibeles < 20
}

class Pueblo inherits Lugar{

// Punto 1
  const provincia 
  const anioFundacion 
  
  override method condicionParticular() = self.esDelLitoral() || self.esAntiguo()

  method esDelLitoral() = ["Corrientes", "Entre Rios", "Misiones"].contains(provincia)

  method esAntiguo() = anioFundacion < 1800

// Punto 2
  override method esTranquilo() = provincia == "La Pampa"
}

class Balneario inherits Lugar{

// Punto 1
  const metros 
  var marEsPeligroso
  const tienePeatonal
  
  override method condicionParticular() = self.tienePlayaGrande() && marEsPeligroso

  method tienePlayaGrande() = metros > 300

// Punto 2
  override method esTranquilo() = !tienePeatonal
}

// Punto 2
class Persona {
  var preferencia 

  method elige(lugar) = preferencia.prefiere(lugar) // preferencia puede ser tranquilidad, diversion, irseLugaresRaros, combinacion

// Punto 3
  var property presupuestoMaximo
  method puedePagar(monto) = monto <= presupuestoMaximo

  
}

object tranquilidad {
  
  method prefiere(lugar) {
    lugar.esTranquilo()
  }
}

object diversion {
  method prefiere(lugar) = lugar.esDivertido()
}

object raro {
  method prefiere(lugar) = lugar.nombreRaro()
}

class CombinacionDePreferencias {
  const preferencias = []

  method prefiere(lugar) = preferencias.any{preferencia => preferencia.prefiere(lugar)}

  method agregar(preferencia) = preferencias.add(preferencia) // Para agregar preferencia a una instancia 

  method eliminar(preferencia) = preferencias.remove(preferencia) // Para eliminar preferencia a una instancia 
}

const combinacion = new CombinacionDePreferencias(preferencias = [raro, diversion])

// Punto 3 

// if(self.puedePagar(persona) && self.sonLugaresAdecuados(persona) && self.hayLugar())
// |-> es poco cohesivo ya que si no funciona no sabes qué falla

// method puedePagar(persona) = montoTour <= persona.presupuestoMaximo() 
// |-> esta forma está bien pero no podes reutilizar el metodo puedePagar
// |-> idem en class Persona: method eligeLugares(lugares) = lugares.all{lugar => self.elige(lugar)}
class Tour{
  const cuposTotales
  const fecha
  const integrantes = []
  const destinos = []
  const listaDeEspera = []

  var property montoTour

  method agregarPersona(persona){
    self.validarPago(persona)
    self.validarPreferencia(persona)
    if(self.estaConfirmado()) listaDeEspera.add(persona) throw new DomainException(message = "El tour está confirmado. Quedas en lista de espera")
    integrantes.add(persona)
  }

  method validarPago(persona) = if(!persona.puedePagar(montoTour)) throw new DomainException(message = "Usted está dispuesto a pagar menos que " +montoTour)

  method validarPreferencia(persona) = if(!self.eligeLugares(persona)) throw new DomainException(message = "Usted tiene destinos no adecuados")

// No lo usamos ya que ademas de validar, debe agregar a la listaDeEspera -> method validarCupos(persona) = if(!self.hayLugar()) throw new DomainException(message = "No hay lugar en el tour")

  method eligeLugares(persona) = destinos.all{lugar => persona.elige(lugar)}

  method estaConfirmado() = integrantes.size() < cuposTotales // = method hayLugar

  method bajarPersona(persona) {
    integrantes.remove(persona)
    self.agregarPersonaEnEspera()
  }

  method agregarPersonaEnEspera(){
    const nuevoIntegrante = listaDeEspera.first()
    listaDeEspera.remove(nuevoIntegrante)
    listaDeEspera.add(nuevoIntegrante)
  }

  method esDeEsteAnio() = fecha.year() == new Date().year()

  method montoTotal() = montoTour * integrantes.size()
}

object reporte {
  const tours = []

  method toursPendientesDeConfirmacion() = tours.filter{tour => tour.estaConfirmado()}

  method montoTotal() = self.toursDeAnioActual().sum{tour => tour.montoTotal()}

  method toursDeAnioActual() = tours.filter{tour => tour.esDeEsteAnio()}

}