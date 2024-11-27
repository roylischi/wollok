class EspacioUrbano {
  var property valuacion 
  var property superficie
  var property nombre
  var property tieneVallado 
  const property trabajosRealizados = []

  method esGrande() = self.condicionGeneralEsGrande() && self.condicionParticularEsGrande()

  method condicionGeneralEsGrande() = superficie > 50

  method condicionParticularEsGrande() 

  method contieneMasDe(cantidad) = false

  method plazaSinCanchas() = false

  method esDeUsoIntensivo() = self.condicionDeUsoIntensivo().size() > 5

  method condicionDeUsoIntensivo() = trabajosRealizados.filter{trabajo => trabajo.esHeavy(trabajo) && trabajo.esTrabajoReciente()} 
}

class Plaza inherits EspacioUrbano{
  var property esparcimiento
  var property cantidadCanchas

  override method plazaSinCanchas() = cantidadCanchas == 0

  override method condicionParticularEsGrande() = cantidadCanchas > 2
}

const plaza = new Plaza(superficie = 100, nombre = "Plaza de la Paz", tieneVallado = true, valuacion = 1000, esparcimiento = 50, cantidadCanchas = 0, trabajosRealizados = [jardinero])

class Plazoleta inherits EspacioUrbano{
  var property espacio
  var property procer

  override method condicionParticularEsGrande() = procer == "San Martin" && tieneVallado
}

const plazoleta = new Plazoleta(superficie = 100, nombre = "Plazoleta de los Heroes", tieneVallado = true, valuacion = 1000, espacio = 50, procer = "San Martin") 

class Anfiteatro inherits EspacioUrbano{
  var property capacidad

  override method condicionParticularEsGrande() = self.tieneMuchaCapacidad()

  method tieneMuchaCapacidad() = capacidad > 500
}

const anfiteatro = new Anfiteatro(superficie = 100, nombre = "Anfiteatro de la Ciudad", tieneVallado = true, valuacion = 1000, capacidad = 1000)

class Multiespacio inherits EspacioUrbano{
  const property conformadoPor = [plaza, plazoleta]

  override method condicionParticularEsGrande() = conformadoPor.all{espacio => espacio.condicionParticularEsGrande()}

  override method contieneMasDe(cantidad) = conformadoPor.size() > cantidad
}

const multiespacio = new Multiespacio(superficie = 100, nombre = "Multiespacio de la Ciudad", tieneVallado = true, valuacion = 1000, conformadoPor = [plaza, plazoleta, anfiteatro])

class Persona {
  var property trabajo
  var property fechaTrabajo = trabajo.fechaTrabajo()
  var property espacioUrbano
  var property horasTrabajadas
  var property costoDeTrabajo
  
  method registrarTrabajo(nuevoTrabajo, espacio){
    nuevoTrabajo.validarEspacio(espacio)
    nuevoTrabajo.terminarTrabajo(espacio)
    self.trabajo(nuevoTrabajo)
    self.fechaTrabajo(new Date())
    self.espacioUrbano(espacio)
    self.horasTrabajadas(nuevoTrabajo.obtenerHoras(espacio))
    self.costoDeTrabajo(nuevoTrabajo.costoPorTrabajo())
    espacio.trabajosRealizados().add(nuevoTrabajo)
  }
}

object _calendario{
  method hoy() = new Date()
}

const tito = new Persona(trabajo = jardinero, horasTrabajadas = 0, costoDeTrabajo = 0, espacioUrbano = plaza)

class Trabajo {

  var property duracionTrabajo = 0
  var property valorPorHora 
  var property fechaTrabajo = _calendario.hoy()

  method validarEspacio(espacio) 
  method terminarTrabajo(espacio)
  method asignarHoras(espacio)
  method costoPorTrabajo() 

  method esTrabajoReciente() = (new Date() - fechaTrabajo) < 30

}

object cerrajero inherits Trabajo (valorPorHora = 100){

  override method validarEspacio(espacio) {
    if(espacio.tieneVallado()) 
      throw new DomainException (message = "El cerrajero no puede trabajar aca.")
  } 

  override method terminarTrabajo(espacio) {
    espacio.tieneVallado(true)
  }

  override method asignarHoras(espacio) {
    self.obtenerHoras(espacio)
  }

  method obtenerHoras(espacio) = if(espacio.esGrande()) 10 else 5

  override method costoPorTrabajo() = valorPorHora * duracionTrabajo

  method esHeavy(trabajo) = trabajo.duracionTrabajo() > 5 || trabajo.costoPorTrabajo() > 10000  
}

object jardinero inherits Trabajo (valorPorHora = 0){

  override method validarEspacio(espacio) {
    if(!(self.esVerde(espacio))) {
      throw new DomainException (message = "El jardinero no puede trabajar aca.")
    }
  }

  method esVerde(espacio) = espacio.plazaSinCanchas() || espacio.contieneMasDe(3)

  override method terminarTrabajo(espacio) {
    espacio.valuacion(espacio.valuacion()*1.1)
  }

  override method asignarHoras(espacio) {
    self.duracionTrabajo(self.obtenerHoras(espacio))
  }

  method obtenerHoras(espacio) = espacio.superficie() / 10

  override method costoPorTrabajo() = 2500

  method esHeavy(trabajo) = trabajo.costoPorTrabajo() > 10000
}

object encargado inherits Trabajo (valorPorHora = 100){

  override method validarEspacio(espacio) {
    if(!(self.esLimpiable(espacio))) {
      throw new DomainException (message = "El encargado no puede trabajar aca.")
    }
  }

  method esLimpiable(espacio) = espacio.tieneMuchaCapacidad() && espacio.condicionGeneralEsGrande() || espacio.cantidadCanchas()

  override method terminarTrabajo(espacio){
    espacio.valuacion(espacio.valuacion() + 5000)
  }

  override method asignarHoras(espacio) {
    self.obtenerHoras(espacio)
  }

  method obtenerHoras(espacio) = 8

  override method costoPorTrabajo() = valorPorHora * duracionTrabajo

  method esHeavy(trabajo) = trabajo.costoPorTrabajo() > 10000
}