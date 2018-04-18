
function componentesJs()
{
    /**
     * funciones para crear elementos
     */
    this.crearInputFechaDefecto=function()
    {
        
      console.log("nueva fecha  "+new Date());
       return (this.crearInputFecha("fechaJs"+(new Date()).getTime().toString(),fechaSistemaGeneral));
    }
    this.crearInputFechaId=function(idInput)
    {
       return (this.crearInputFecha(idInput,""));
    }
    this.crearInputFechaValor=function(valorFecha)
    {
        console.log("fecha jaime "+valorFecha);
       return (this.crearInputFecha(("fechaJs"+(new Date()).getTime().toString()),valorFecha));
    }
    this.crearInputFecha=function(idInput,valorFecha)
    {
        console.log("valor fecha_ jj: "+valorFecha.toString());
        var inputFecha=document.createElement("input");
        inputFecha.type="tel";
        inputFecha.style.width='7em';
        inputFecha.id=idInput;
        inputFecha.value=valorFecha;
        inputFecha.onclick=function(){seleccionarDatePickerJs(this);};
        return inputFecha;
    }
    this.crearInputHora1=function()
    {
        var inputHora=this.crearInputHora("hora1Js"+(new Date()).getTime().toString());
        inputHora.onfocus=function(){calcularHorasFilaInicio(this);};
        return inputHora;
    }
    this.crearInputHora2=function()
    {
        var inputHora=this.crearInputHora("hora2Js"+(new Date()).getTime().toString());
        inputHora.onfocus=function(){calcularHorasFilaFinal(this);};
        return inputHora;
    }
    this.crearInputHora=function(idInput)
    {
        var inputHora=document.createElement("input");
        inputHora.type="tel";
        inputHora.id=idInput;
        inputHora.value=getHoraActualGeneralString();
        inputHora.style.width='6em';
        inputHora.onclick=function(){seleccionarHora(this);};
        return inputHora;
    }
    this.crearInputCantidad=function(valor)
    {
        var inputCantidad=document.createElement("input");
        inputCantidad.type="tel";
        inputCantidad.style.width="6em";
        inputCantidad.placeholder="cantidad";
        return inputCantidad;
    }
    this.crearSelect=function(opciones)
    {
        var select=document.createElement("select");
        select.innerHTML=opciones;
        return select;
    }
    this.crearCelda=function(fila)
    {
        var celda=fila.insertCell((fila.cells.length!=null?fila.cells.length:1));
        celda.className="tableCell";
        return celda;
    }

    this.crearSpan=function(value,styloClase)
    {
        var span=document.createElement("span");
        span.innerHTML=value;
        span.className=styloClase;
        return span;
    }
    this.crearSpanCantidad=function()
    {
        return (this.crearSpan(0,"textHeaderClassBody"))
    }
    this.crearSpanFecha=function()
    {
        return (this.crearSpan(fechaSistemaGeneral,"textHeaderClassBody"));
    }
    this.crearSpanHoraInicio=function()
    {
        return (this.crearSpan(getHoraActualGeneralString(),"textHeaderClassBody"));
    }

    
    this.crearRegistroTablaFechaHora=function(nombreTabla)
    {
        console.log("fecha jaime "+nombreTabla);
        var tabla=document.getElementById(nombreTabla);
        var fila=tabla.insertRow(tabla.rows.length);
        fila.onclick=function(){seleccionarFila(this);};
        (this.crearCelda(fila)).appendChild(this.crearSelect(operariosRegistroGeneral));
        (this.crearCelda(fila)).appendChild(this.crearInputFechaValor(fechaSistemaGeneral));
        (this.crearCelda(fila)).appendChild(this.crearInputHora1());
        (this.crearCelda(fila)).appendChild(this.crearInputHora2());
        (this.crearCelda(fila)).appendChild(this.crearSpanCantidad());
        (this.crearCelda(fila)).appendChild(this.crearInputCantidad(0));
    }
    this.crearRegistroTablaFecha=function(nombreTabla)
    {
        var tabla=document.getElementById(nombreTabla);
        var fila=tabla.insertRow(tabla.rows.length);
        fila.onclick=function(){seleccionarFila(this);};
       (this.crearCelda(fila)).appendChild(this.crearSelect(operariosRegistroGeneral));
        (this.crearCelda(fila)).appendChild(this.crearInputFechaValor(fechaSistemaGeneral));
        (this.crearCelda(fila)).appendChild(this.crearInputHora1());
        (this.crearCelda(fila)).appendChild(this.crearInputHora2());
        (this.crearCelda(fila)).appendChild(this.crearSpanCantidad());
  }
    
}
var componentesJs=new componentesJs();
