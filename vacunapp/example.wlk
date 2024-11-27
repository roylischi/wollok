class Persona {
  var property anticuerpos
  var property inmunidad = _calendario.hoy()
  var property edad
  var property nombre
  const property provincia
  const eleccion  
  const property vacunasDisponibles=[paifer, larussa5, larussa2, zeneca, combineta]
  const property historialVacunas = []  

  method eligeVacuna(vacuna, meses) = eleccion.elegir(vacuna, meses)

  method validarVacuna(vacuna) = if(self.eligeVacuna(vacuna, 3)) throw new DomainException(message = "La vacuna solicitada no es aplicable para la persona.")

  method confirmarTurno(vacuna) {
      self.validarVacuna(vacuna)
      vacuna.aplicarVacuna(self)
      historialVacunas.add(vacuna)
  }
}

const persona = new Persona(anticuerpos = 10, edad = 30, nombre = "Juan", provincia = "Tierra del Fuego", eleccion = inmunidosasVariables)

class Vacuna {
  var property costoInicial = 1000

  method aplicarVacuna(persona) {
    self.aplicarAnticuerpos(persona)
    self.aplicarInmunidad(persona)
  }

  method aplicarAnticuerpos(persona)
  method aplicarInmunidad(persona)

  method costoDeVacuna(persona) = self.costoPorEdad(persona) + self.costoPorExtra(persona)

  method costoPorEdad(persona) = if(persona.edad() <= 30) costoInicial else costoInicial + (persona.edad()-30) * 50

  method costoPorExtra(persona)


}

object paifer inherits Vacuna{

  override method aplicarAnticuerpos(persona) {
    persona.anticuerpos(self.obtenerAnticuerpos(persona))
  }

  override method aplicarInmunidad(persona) {
    if(self.esMayor(persona)) {
      self.sumarMeses(6)
    } 
    self.sumarMeses(9)
  }

  method sumarMeses(meses) {
    persona.inmunidad().plusMonths(meses)
  }

  method esMayor(persona) = persona.edad() > 40

  method obtenerAnticuerpos(persona) = persona.anticuerpos()*10

  method obtenerInmunidad(persona) = if(self.esMayor(persona)) self.sumarMeses(6) else self.sumarMeses(9)

  override method costoPorExtra(persona) = if(persona.edad() < 18) 400 else 100
}
object _calendario { // stub
  method hoy() = new Date()
}

class Larussa inherits Vacuna{
  var property multiplicador

  override method aplicarAnticuerpos(persona) {
    persona.anticuerpos(self.obtenerAnticuerpos(persona))
  }

  override method aplicarInmunidad(persona) {
    persona.inmunidad(new Date(day=3, month=3, year=2022))
  }

  method obtenerAnticuerpos(persona) = persona.anticuerpos()*(multiplicador.min(20))

  method obtenerInmunidad(persona) = new Date(day=3, month=3, year=2022)

  override method costoPorExtra(persona) = 100 * multiplicador
}
const larussa2 = new Larussa(multiplicador = 2) 
const larussa5 = new Larussa(multiplicador = 5)

object zeneca inherits Vacuna{

  override method aplicarAnticuerpos(persona) {
    persona.anticuerpos(self.obtenerAnticuerpos(persona))
  }

  override method aplicarInmunidad(persona) {
    if(self.tieneNombrePar(persona)){
      persona.inmunidad().plusMonths(6)
    } else {
      persona.inmunidad().plusMonths(7)
    }
  }

  method tieneNombrePar(persona) = persona.nombre().length().even()

  method obtenerAnticuerpos(persona) = persona.anticuerpos() + 10000

  method obtenerInmunidad(persona) = if(self.tieneNombrePar(persona)) persona.inmunidad().plusMonths(6) else persona.inmunidad().plusMonths(7)

  override method costoPorExtra(persona) = if(self.esEspecial(persona)) 2000 else 0

  method esEspecial(persona) = (#{"Tierra del Fuego", "Santa Cruz", "Neuquen"}).contains(persona.provincia())
}

class Combineta {

  const listaVacunas = []

  method agregarVacuna(vacuna) {
    listaVacunas.add(vacuna)
  }

  method aplicarVacuna(persona) {
    self.aplicarAnticuerpos(persona)
    self.aplicarInmunidad(persona)
  }

  method vacunaConMenorAnticuerpos() = listaVacunas.map{vacuna => vacuna.obtenerAnticuerpos(persona)}.min()

  method vacunaConMayorInmunidad() = listaVacunas.map{vacuna => vacuna.obtenerInmunidad(persona)}.max()

  method aplicarInmunidad(persona) {
    persona.inmunidad(self.vacunaConMayorInmunidad())
  }

  method aplicarAnticuerpos(persona) {
    persona.anticuerpos(self.vacunaConMenorAnticuerpos())
  }

  method obtenerInmunidad(persona) = self.vacunaConMayorInmunidad()

  method costoDeVacuna(persona) = listaVacunas.sum{vacuna => vacuna.costoDeVacuna(persona)} + self.costoPorExtra()

  method costoPorExtra() = listaVacunas.size() * 100
}

const combineta = new Combineta(listaVacunas = [larussa2, paifer])

// Punto 3

object cualquierosas{
  var property listaDeVacunas = [paifer, larussa2, zeneca]
  method elegir(vacuna, meses) = listaDeVacunas.anyOne()
} 

object anticuerposas{
  method elegir(vacuna, meses) = vacuna.obtenerAnticuerpos(persona) > 10000
}

object inmundosasFijas {
  method elegir(vacuna, meses) = vacuna.obtenerInmunidad(persona) >= new Date(day=5, month=3, year=2022)
}

object inmunidosasVariables {
  method elegir(vacuna, meses) = vacuna.obtenerInmunidad(persona) >= persona.inmunidad().plusMonths(meses)
} 

class Plan {
  method vacunasSegunEleccion(persona) = persona.vacunasDisponibles().filter{vacuna => persona.eligeVacuna(vacuna, 5)}

  method vacunaMasBarata() = self.vacunasSegunEleccion(persona).map{vacuna => vacuna.costoDeVacuna(persona)}.min()

  method costoDePlan() = self.vacunaMasBarata()
}

const plan = new Plan()