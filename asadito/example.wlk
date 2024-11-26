class Persona {
  var criterioElemento
  var property posicion 
  const property elementosCerca = []

  var property criterioComida 
  const property comidasConsumidas = [] 
  var property caloriasTotales = 0

  method lePide(otraPersona, elemento) {
    self.validarElemento(otraPersona, elemento)
    criterioElemento.pasarElemento(self, otraPersona, elemento)
    }

  method validarElemento(otraPersona, elemento) = if(!otraPersona.elementosCerca().contains(elemento)) throw new DomainException(message = "El elemento no está en la mesa") 
  
  method comer(comida) {
    self.validarComida(comida) // si no cumple el criterio, termina el flujo del metodo comer por la excepción
    self.sumarCalorias(comida)
    self.agregarComida(comida) 
    } 
  
  method agregarComida(comida) {
    comidasConsumidas.add(comida)
  } 

  method sumarCalorias(comida){
    caloriasTotales += comida.calorias()
  }

  method validarComida(comida){
    if (!criterioComida.agarrarComida(comida)){
      throw new DomainException(message = "La persona no comió.")
    }
  }

  method esPipon() = comidasConsumidas.any{comida => comida.calorias() > 500}

  method laPasaBien() =  self.comioAlgo() && self.condicionParaPasarlaBien()

  method condicionParaPasarlaBien() 

  method comioAlgo() = comidasConsumidas.size() > 0
}

object osky inherits Persona (criterioElemento = sordo, criterioComida = vegetariano, posicion = 'a') {
  override method condicionParaPasarlaBien() = true
  
}

object mony inherits Persona (criterioElemento = sordo, criterioComida = vegetariano, posicion = '11') {
  override method condicionParaPasarlaBien() = posicion == '11'
}

object facu inherits Persona (criterioElemento = generoso, criterioComida = dietetico, posicion = 'b') {
  override method condicionParaPasarlaBien() = comidasConsumidas.any{comida => comida.esCarne()}
}

object vero inherits Persona (criterioElemento = intercambio, criterioComida = combinacion, posicion = 'c', elementosCerca = ["sal", "azucar"]) {
  override method condicionParaPasarlaBien() = !(elementosCerca.size() > 3)
}

// le pasan el primer elemento que tienen a mano
object sordo {
  method pasarElemento(persona, otraPersona, elemento) { 
    persona.elementosCerca().add(otraPersona.primerElemento())
    self.eliminarElemento(otraPersona)
    }

  method primerElemento(persona) = persona.elementosCerca().first()

  method eliminarElemento(otraPersona) {
    otraPersona.elementosCerca().remove(otraPersona.primerElemento())
    }
}

// le pasan todos los elementos
object generoso {
  method pasarElemento(persona, otraPersona, elemento) { 
    otraPersona.elementosCerca().forEach { elemento => persona.elementosCerca().add(elemento)}
    self.eliminarElementos(otraPersona)
    }

  method eliminarElementos(otraPersona) {
    otraPersona.elementosCerca().clear()
    }
}

// le piden que cambien la posición en la mesa
object intercambio {
  var posicionIntermedia = '?'
  const listaIntermedia=[]

  method pasarElemento(persona, otraPersona, elemento) { 
      self.intercambiarPosicion(persona, otraPersona)
      self.intercambiarListas(persona, otraPersona)
    }

  method intercambiarPosicion(persona, otraPersona) {
      posicionIntermedia = persona.posicion()
      persona.posicion(otraPersona.posicion())
      otraPersona.posicion(posicionIntermedia)
    }
  
  method obtenerElementos(otraPersona){
    otraPersona.elementosCerca().forEach({elemento=>listaIntermedia.add(elemento)})
    }

  method intercambiarListas(persona,otraPersona){
    self.obtenerElementos(otraPersona)
    self.intercambiarElementos(persona.elementosCerca(), otraPersona.elementosCerca())
    self.intercambiarElementos(listaIntermedia, persona.elementosCerca())
  }

  method intercambiarElementos(unaLista,otraLista){
    otraLista.clear()
    unaLista.forEach({elemento=>otraLista.add(elemento)})
  }
}

// le pasan el bendito elemento al otro comensal
object bendicion {
  method pasarElemento(persona, otraPersona, elemento) { 
    persona.elementosCerca().add(elemento)
    self.eliminarElemento(otraPersona, elemento)
    }

  method eliminarElemento(otraPersona, elemento) {
    otraPersona.elementosCerca().remove(elemento)
    }
}

//const persona = new Persona(criterioComida = vegetariano, criterioElemento = bendicion, elementosCerca = ["sal", "azucar"], posicion = 'a')
//const otraPersona = new Persona(criterioComida = null, criterioElemento = bendicion, elementosCerca = ["pimienta", "vinagre"], posicion = 'b')

const pechitoDeCerdo = new Comida(esCarne = true, calorias = 100)
const ensalada = new Comida(esCarne = false, calorias = 400)
const verduras = new Comida(esCarne = false, calorias = 300)

class Comida {
  var property esCarne
  var property calorias
}

object vegetariano {

  method esCarne(bandeja) = bandeja.esCarne() // el segundo esCarne referencia al var property de la clase

  method agarrarComida(comida) = !self.esCarne(comida)
}


object dietetico {
  var property caloriasRecomendadasPorOms = 500

  method esRecomendado(comida) = comida.calorias() < caloriasRecomendadasPorOms

  method agarrarComida(comida) = self.esRecomendado(comida)
}

object alternado {
  var property estadoComidaAnterior = true

  method agarrarComida(comida) {
    self.alternar()
    return self.estadoComidaAnterior()
  }

  method alternar() {
    self.estadoComidaAnterior(!self.estadoComidaAnterior())
  }
}

object combinacion {
  const listaDeCriterios = [vegetariano, dietetico]

  method agarrarComida(comida) = listaDeCriterios.all{criterio => criterio.agarrarComida(comida)}
}

/*
por que herencia? porque podes reutilizar codigo sin repetir 
ventaja: sobreescribir metodos 

por que composicion? te permite relacionar dos objetos. Pj: en la clase Persona con criterioComida
ventaja: 
*/