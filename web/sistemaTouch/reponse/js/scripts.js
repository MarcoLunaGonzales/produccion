/*
 * general.js
 * Created on 19 de febrero de 2008, 16:50
 *
 */
/*
 *  @author Alejandro Quispe
 *  @company COFAR
 *  @param nametable nombre de la tabla
 */



function nuevoAjax()
{	var xmlhttp=false;
    try {
        xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            xmlhttp = false;
        }
    }
    if (!xmlhttp && typeof XMLHttpRequest!="undefined") {
        xmlhttp = new XMLHttpRequest();
    }

    return xmlhttp;
}
function mostrarProgresoGeneral(mostrarImagen)
{
    document.getElementById('formsuper').style.visibility='visible';
    document.getElementById('divImagen').style.visibility=(mostrarImagen?'visible':'hidden');
}
function iniciarProgresoSistema()
{
    document.getElementById('formsuper').style.visibility='visible';
    document.getElementById('divImagen').style.visibility='visible';
}
function terminarProgresoSistema()
{
    document.getElementById('formsuper').style.visibility='hidden';
    document.getElementById('divImagen').style.visibility='hidden';
}
function getHoraActualString()
{
    var a=new Date();
    var minutos=parseInt(a.getMinutes()/5)*5;
    return ((a.getHours()>9?"":"0")+a.getHours()+":"+(minutos>9?"":"0")+minutos);
}


function calcularHorasGeneral(celdaFin,horaInicio)
{
    celdaFin.className='buttonFinishActive';
    celdaFin.parentNode.getElementsByTagName("span")[0].innerHTML=getHoraActualGeneralString();
    var horasHombre=(parseInt(getHoraActualGeneralString().split(":")[0])+(parseInt(getHoraActualGeneralString().split(":")[1])/60));
    horasHombre-=(parseInt(horaInicio.split(":")[0])+(parseInt(horaInicio.split(":")[1])/60));
    try
    {
        celdaFin.parentNode.parentNode.cells[celdaFin.parentNode.cellIndex+1].getElementsByTagName("span")[0].innerHTML=redondeo2decimales(horasHombre);
    }
    catch(e)
    {
        console.log('No existe el campo');
    }
    return redondeo2decimales(horasHombre);
}

function terminarTiempoDirectoAdmin(celdaFin)
{
    celdaFin.parentNode.getElementsByTagName("input")[0].style.display='inline';
    celdaFin.className='buttonFinishActive';
    celdaFin.parentNode.getElementsByTagName("input")[0].onclick();
}
function terminarTiempoCampaniaPersonal(celdaFin,horaInicio)
{
    window.parent.confirmJs('Esta seguro de terminar la actividad?',function(result)
    {
        if(result)
        {
            guardarTerminarTiempoCampania(calcularHorasGeneral(celdaFin,horaInicio));
        }

    });
}
function guardarTerminarTiempoCampania(horasHombre)
{

    window.parent.iniciarProgresoSistema();
    var peticion="ajaxTerminarTiempoCampania.jsf?codCampania="+window.parent.codCampaniaGeneral+
                 "&codActividad="+window.parent.codActividadGeneral+
                 "&codPersonal="+window.parent.codPersonalGeneral+
                 "&fecha="+this.fechaSistemaGeneral+
                 "&horaFin="+this.getHoraActualGeneralString()+
                 "&horasHombre="+horasHombre+
                 "&data="+(new Date()).getTime().toString();
     ajax=nuevoAjax();
     ajax.open("GET",peticion,true);
     ajax.setRequestHeader('content-type', 'application/x-www-form-urlencoded;charset=UTF-8');
     ajax.onreadystatechange=function(){
        if (ajax.readyState==4) {
            if(ajax.responseText==null || ajax.responseText=='')
            {
                window.parent.alertJs('No se puede conectar con el servidor, verfique su conexión a internet');
                if(confirm("Desea guardar la informacion localmente?\nLa informacion del lote no se perdera pero debe de subirla despues"))
                {
                    sqlConnection.insertarRegistroAuxiliar(codProgramaProd,codLote,2,("../registroRepesada/"+peticion),function(){window.close();});
                }
                window.parent.terminarProgresoSistema();
                return false;
            }
            if(parseInt(ajax.responseText.split("\n").join(""))=='1')
            {
                window.parent.terminarProgresoSistema();
                window.parent.confirmJs("Se registró el termino de la actividad<br>Desea registrar otra actividad?",function(resultado)
                    {
                        if(!resultado)
                        {
                            window.parent.location.href='loginAlmacen.jsf?data='+(new Date()).getTime().toString();
                        }
                        else
                        {
                                  window.location.href="registroCampania/actividadesCampania.jsf?codCampania="+window.parent.codCampaniaGeneral+
                                          "&codPersonal="+window.parent.codPersonalGeneral+
                                          "&admin=0";
                                  window.parent.iniciarProgresoSistema();
                        }
                    }
                );
                return true;
            }
            else
            {
                window.parent.terminarProgresoSistema();
                window.parent.alertJs(ajax.responseText.split("\n").join(""));
                return false;
            }
        }
    }

    ajax.send(null);
}
function terminarTiempoDirectoPersonal(celdaFin,horaInicio)
{
    window.parent.confirmJs('Esta seguro de terminar la actividad?',function(result)
    {
        if(result)
        {
            guardarTerminarTiempoDirecto(calcularHorasGeneral(celdaFin,horaInicio));
        }
        
    });
}
function guardarTerminarTiempoDirecto(horasHombre)
{
    
    window.parent.iniciarProgresoSistema();
    var peticion="ajaxTerminarTiempoIndirecto.jsf?codProgramaProd="+window.parent.codProgramaProdGeneral+
                 "&codLote="+window.parent.codLoteGeneral+
                 "&codFormulaMaestra="+window.parent.codFormulaMaestraGeneral+
                 "&codComprod="+window.parent.codComprodGeneral+
                 "&codTipoProgramaProd="+window.parent.codTipoProgramaProdGeneral+
                 "&codActividad="+window.parent.codActividadGeneral+
                 "&codPersonal="+window.parent.codPersonalGeneral+
                 "&fecha="+this.fechaSistemaGeneral+
                 "&horaFin="+this.getHoraActualGeneralString()+
                 "&horasHombre="+horasHombre+
                 "&data="+(new Date()).getTime().toString();
     ajax=nuevoAjax();
     ajax.open("GET",peticion,true);
     ajax.setRequestHeader('content-type', 'application/x-www-form-urlencoded;charset=UTF-8');
     ajax.onreadystatechange=function(){
        if (ajax.readyState==4) {
            if(ajax.responseText==null || ajax.responseText=='')
            {
                window.parent.alertJs('No se puede conectar con el servidor, verfique su conexión a internet');
                if(confirm("Desea guardar la informacion localmente?\nLa informacion del lote no se perdera pero debe de subirla despues"))
                {
                    sqlConnection.insertarRegistroAuxiliar(codProgramaProd,codLote,2,("../registroRepesada/"+peticion),function(){window.close();});
                }
                window.parent.terminarProgresoSistema();
                return false;
            }
            if(parseInt(ajax.responseText.split("\n").join(""))=='1')
            {
                window.parent.terminarProgresoSistema();
                window.parent.confirmJs("Se registró el termino de la actividad<br>Desea registrar otra actividad?",function(resultado)
                    {
                        if(!resultado)
                        {
                            sqlConnection.terminarSessionUsuario(function(){
                            window.parent.location.href='loginAlmacen.jsf?data='+(new Date()).getTime().toString();});
                        }
                        else
                        {
                                  window.location.href="actividadesProduccion.jsf?codLote="+window.parent.codLoteGeneral+
                                          "&codTipoProgramaProd="+window.parent.codTipoProgramaProdGeneral+
                                          "&codComprod="+window.parent.codComprodGeneral+
                                          "&data="+(new Date()).getTime().toString()+
                                          "&codProgramaProd="+window.parent.codProgramaProdGeneral+
                                          "&codPersonal="+window.parent.codPersonalGeneral+
                                          "&admin=0";
                                window.parent.iniciarProgresoSistema();
                        }
                    }
                );
                return true;
            }
            else
            {
                window.parent.terminarProgresoSistema();
                window.parent.alertJs(ajax.responseText.split("\n").join(""));
                return false;
            }
        }
    }

    ajax.send(null);
}
function terminarTiempoCampania(codCampania,codActividad,fechaInicio)
{
    iniciarProgresoSistema();
    var peticion="registroCampania/registroPersonal/ajaxTerminarTiempoCampania.jsf?"+
                 "codCampania="+codCampania+
                 "&codActividad="+codActividad+
                 "&codPersonal="+codPersonalGeneral+
                 "&fecha="+this.fechaSistemaGeneral+
                 "&horaFin="+this.getHoraActualGeneralString()+
                 "&horasHombre="+(getNumeroDehoras(fechaInicio,(this.fechaSistemaGeneral+' '+this.getHoraActualGeneralString())))+
                 "&data="+(new Date()).getTime().toString();
     ajax=nuevoAjax();
     ajax.open("GET",peticion,true);
     ajax.setRequestHeader('content-type', 'application/x-www-form-urlencoded;charset=UTF-8');
     ajax.onreadystatechange=function(){
        if (ajax.readyState==4) {
            if(ajax.responseText==null || ajax.responseText=='')
            {
                window.parent.alertJs('No se puede conectar con el servidor, verfique su conexión a internet');
                if(confirm("Desea guardar la informacion localmente?\nLa informacion del lote no se perdera pero debe de subirla despues"))
                {
                    sqlConnection.insertarRegistroAuxiliar(codProgramaProd,codLote,2,("../registroRepesada/"+peticion),function(){window.close();});
                }
                window.parent.terminarProgresoSistema();
                return false;
            }
            if(parseInt(ajax.responseText.split("\n").join(""))=='1')
            {
                terminarProgresoSistema();
                confirmJs("Se registró el terminó de la actividad<br>Desea registrar otra actividad?",function(resultado)
                    {
                        if(!resultado)
                        {
                            sqlConnection.terminarSessionUsuario(function(){
                            location.href='loginAlmacen.jsf?data='+(new Date()).getTime().toString();});
                        }

                    }
                );
                return true;
            }
            else
            {
                terminarProgresoSistema();
                alertJs(ajax.responseText.split("\n").join(""));
                return false;
            }
        }
    }

    ajax.send(null);
}
function terminarTiempoIndirecto(codProgramaProd,codAreaEmpresa,codActividad,fechaInicio,codPersonal)
{
    iniciarProgresoSistema();
    var peticion="../registroTiemposIndirectosProduccion/registroTiempoPersonalIndirecto/ajaxTerminarTiempoIndirecto.jsf?codProgProd="+codProgramaProd+
                 "&codAreaEmpresa="+codAreaEmpresa+
                 "&codActividad="+codActividad+
                 "&codPersonal="+codPersonal+
                 "&fechaInicio="+this.fechaSistemaGeneral+
                 "&horaInicio="+this.getHoraActualGeneralString()+
                 "&horasHombre="+(getNumeroDehoras(fechaInicio,(this.fechaSistemaGeneral+' '+this.getHoraActualGeneralString())))+
                 "&data="+(new Date()).getTime().toString();
     ajax=nuevoAjax();
     ajax.open("GET",peticion,true);
     ajax.setRequestHeader('content-type', 'application/x-www-form-urlencoded;charset=UTF-8');
     ajax.onreadystatechange=function(){
        if (ajax.readyState==4) {
            if(ajax.responseText==null || ajax.responseText=='')
            {
                window.parent.alertJs('No se puede conectar con el servidor, verfique su conexión a internet');
                if(confirm("Desea guardar la informacion localmente?\nLa informacion del lote no se perdera pero debe de subirla despues"))
                {
                    sqlConnection.insertarRegistroAuxiliar(codProgramaProd,codLote,2,("../registroRepesada/"+peticion),function(){window.close();});
                }
                window.parent.terminarProgresoSistema();
                return false;
            }
            if(parseInt(ajax.responseText.split("\n").join(""))=='1')
            {
                terminarProgresoSistema();
                confirmJs("Se registró el terminó de la actividad<br>Desea registrar otra actividad?",function(resultado)
                    {
                        if(!resultado)
                        {
                            location.href='loginAlmacen.jsf?data='+(new Date()).getTime().toString();
                        }

                    }
                );
                return true;
            }
            else
            {
                terminarProgresoSistema();
                alertJs(ajax.responseText.split("\n").join(""));
                return false;
            }
        }
    }

    ajax.send(null);
}
function terminarTiempoDirecto(codLote,codProgramaProd,codForm,codComp,codTipoProg,codActividad,fechaInicio)
{
    iniciarProgresoSistema();
    var peticion="ajaxTerminarTiempoIndirecto.jsf?codProgramaProd="+codProgramaProd+
                 "&codLote="+codLote+
                 "&codFormulaMaestra="+codForm+
                 "&codComprod="+codComp+
                 "&codTipoProgramaProd="+codTipoProg+
                 "&codActividad="+codActividad+
                 "&codPersonal="+codPersonalGeneral+
                 "&fecha="+this.fechaSistemaGeneral+
                 "&horaFin="+this.getHoraActualGeneralString()+
                 "&horasHombre="+(getNumeroDehoras(fechaInicio,(this.fechaSistemaGeneral+' '+this.getHoraActualGeneralString())))+
                 "&data="+(new Date()).getTime().toString();
     ajax=nuevoAjax();
     ajax.open("GET",peticion,true);
     ajax.setRequestHeader('content-type', 'application/x-www-form-urlencoded;charset=UTF-8');
     ajax.onreadystatechange=function(){
        if (ajax.readyState==4) {
            if(ajax.responseText==null || ajax.responseText=='')
            {
                window.parent.alertJs('No se puede conectar con el servidor, verfique su conexión a internet');
                if(confirm("Desea guardar la informacion localmente?\nLa informacion del lote no se perdera pero debe de subirla despues"))
                {
                    sqlConnection.insertarRegistroAuxiliar(codProgramaProd,codLote,2,("../registroRepesada/"+peticion),function(){window.close();});
                }
                window.parent.terminarProgresoSistema();
                return false;
            }
            if(parseInt(ajax.responseText.split("\n").join(""))=='1')
            {
                terminarProgresoSistema();
                confirmJs("Se registró el terminó de la actividad<br>Desea registrar otra actividad?",function(resultado)
                    {
                        if(!resultado)
                        {
                            sqlConnection.terminarSessionUsuario(function(){
                            location.href='loginAlmacen.jsf?data='+(new Date()).getTime().toString();});
                        }
                        
                    }
                );
                return true;
            }
            else
            {
                terminarProgresoSistema();
                alertJs(ajax.responseText.split("\n").join(""));
                return false;
            }
        }
    }

    ajax.send(null);
}
function nuevoRegistroTiemposCampania(nombreTabla,botonTerminar)
{
    var ajax=nuevoAjax();
        var peticion="ajaxIniciarTiempoCampania.jsf?codCampania="+window.parent.codCampaniaGeneral+
                     "&codActividad="+window.parent.codActividadGeneral+
                     "&codPersonal="+window.parent.codPersonalGeneral+
                     "&fecha="+fechaSistemaGeneral+
                     "&horaInicio="+getHoraActualGeneralString()+
                     "&data="+(new Date()).getTime().toString();
        ajax=nuevoAjax();
         ajax.open("GET",peticion,true);
         ajax.onreadystatechange=function(){
            if (ajax.readyState==4) {
                if(ajax.responseText==null || ajax.responseText=='')
                {
                    window.parent.alertJs('No se puede conectar con el servidor, verfique su conexión a internet');
                    return false;
                }
                if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                {
                       var table = document.getElementById(nombreTabla);
                       var rowCount = table.rows.length;
                       var row = table.insertRow(rowCount);
                       row.onclick=function(){seleccionarFila(this);};
                       var cellFecha = row.insertCell(0);
                       cellFecha.className="tableCell";
                       cellFecha.align='center';
                       var fechaSpan=document.createElement("span");
                       fechaSpan.className="textHeaderClassBodyNormal";
                       fechaSpan.innerHTML=fechaSistemaGeneral;
                       cellFecha.appendChild(fechaSpan);
                       var celdaHoraInicio = row.insertCell(1);
                       celdaHoraInicio.className="tableCell";
                       celdaHoraInicio.align='center';
                       var horaInicioSpan = document.createElement("span");
                       horaInicioSpan.className="textHeaderClassBodyNormal";
                       horaInicioSpan.innerHTML=getHoraActualGeneralString();
                       celdaHoraInicio.appendChild(horaInicioSpan);
                       var celdaHoraFinal = row.insertCell(2);
                       celdaHoraFinal.className="tableCell";
                       celdaHoraFinal.align='center';
                       var buttonFinish=document.createElement("button");
                       buttonFinish.className='buttonFinish';
                       buttonFinish.innerHTML='Terminar';
                       var horaInicio=getHoraActualGeneralString();
                       buttonFinish.onclick=function(){terminarTiempoDirectoPersonal(this,horaInicio);};
                       var horaFinSpan = document.createElement("span");
                       horaFinSpan.className="textHeaderClassBodyNormal";
                       horaFinSpan.innerHTML=getHoraActualString();
                       celdaHoraFinal.appendChild(buttonFinish);
                       celdaHoraFinal.appendChild(horaFinSpan);
                       botonTerminar.style.visibility='hidden';
                       window.parent.confirmJs("Se registró la actividad<br>Desea realizar otra transacción?",function(result)
                          {
                              if(!result)
                              {
                                    window.parent.location.href='loginAlmacen.jsf?data='+(new Date()).getTime().toString();
                              }
                              else
                              {
                                      window.location.href="registroCampania/actividadesCampania.jsf?codCampania="+window.parent.codCampaniaGeneral+
                                                           "&codPersonal="+window.parent.codPersonalGeneral+
                                                           "&data="+(new Date()).getTime().toString()+
                                                           "&admin=0";
                                    window.parent.iniciarProgresoSistema();
                              }
                          });
                    return true;
                }
                else
                {
                    window.parent.alertJs(ajax.responseText.split("\n").join(""));
                    return false;
                }
            }
        }
        ajax.send(null);
}
function nuevoRegistroTiemposGeneral(nombreTabla,botonTerminar)
{
    var ajax=nuevoAjax();
        var peticion="ajaxIniciarTiempoDirecto.jsf?codProgramaProd="+window.parent.codProgramaProdGeneral+
                    "&codFormulaMaestra="+window.parent.codFormulaMaestraGeneral+
                    "&codComprod="+window.parent.codComprodGeneral+
                    "&codLote="+window.parent.codLoteGeneral+
                    "&codTipoProgramaProd="+window.parent.codTipoProgramaProdGeneral+
                    "&codActividad="+window.parent.codActividadGeneral+
                    "&codPersonal="+window.parent.codPersonalGeneral+
                    "&fecha="+fechaSistemaGeneral+
                    "&horaInicio="+getHoraActualGeneralString()+
                     "&data="+(new Date()).getTime().toString();
        ajax=nuevoAjax();
         ajax.open("GET",peticion,true);
         ajax.onreadystatechange=function(){
            if (ajax.readyState==4) {
                if(ajax.responseText==null || ajax.responseText=='')
                {
                    window.parent.alertJs('No se puede conectar con el servidor, verfique su conexión a internet');
                    return false;
                }
                if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                {
                        
                        var table = document.getElementById(nombreTabla);
                        var rowCount = table.rows.length;
                       var row = table.insertRow(rowCount);
                       row.onclick=function(){seleccionarFila(this);};
                       var cellFecha = row.insertCell(0);
                       cellFecha.className="tableCell";
                       cellFecha.align='center';
                       var fechaSpan=document.createElement("span");
                       fechaSpan.className="textHeaderClassBodyNormal";
                       fechaSpan.innerHTML=fechaSistemaGeneral;
                       cellFecha.appendChild(fechaSpan);
                       var celdaHoraInicio = row.insertCell(1);
                       celdaHoraInicio.className="tableCell";
                       celdaHoraInicio.align='center';
                       var horaInicioSpan = document.createElement("span");
                       horaInicioSpan.className="textHeaderClassBodyNormal";
                       horaInicioSpan.innerHTML=getHoraActualGeneralString();
                       celdaHoraInicio.appendChild(horaInicioSpan);
                       var celdaHoraFinal = row.insertCell(2);
                       celdaHoraFinal.className="tableCell";
                       celdaHoraFinal.align='center';
                       var buttonFinish=document.createElement("button");
                       buttonFinish.className='buttonFinish';
                       buttonFinish.innerHTML='Terminar';
                       var horaInicio=getHoraActualGeneralString();
                       buttonFinish.onclick=function(){terminarTiempoDirectoPersonal(this,horaInicio);};
                       var horaFinSpan = document.createElement("span");
                       horaFinSpan.className="textHeaderClassBodyNormal";
                       horaFinSpan.innerHTML=getHoraActualString();
                       celdaHoraFinal.appendChild(buttonFinish);
                       celdaHoraFinal.appendChild(horaFinSpan);
                       botonTerminar.style.visibility='hidden';
                       window.parent.confirmJs("Se registró la actividad<br>Desea realizar otra transacción?",function(result)
                          {
                              if(!result)
                              {
                                  sqlConnection.terminarSessionUsuario(function(){
                                    window.parent.location.href='loginAlmacen.jsf?data='+(new Date()).getTime().toString();});
                              }
                              else
                              {
                                      window.location.href="actividadesProduccion.jsf?codLote="+window.parent.codLoteGeneral+
                                              "&codTipoProgramaProd="+window.parent.codTipoProgramaProdGeneral+
                                              "&codComprod="+window.parent.codComprodGeneral+
                                              "&data="+(new Date()).getTime().toString()+
                                              "&codProgramaProd="+window.parent.codProgramaProdGeneral+
                                              "&codPersonal="+window.parent.codPersonalGeneral+
                                              "&admin=0";
                                    window.parent.iniciarProgresoSistema();
                              }
                          });
                    return true;
                }
                else
                {
                    window.parent.alertJs(ajax.responseText.split("\n").join(""));
                    return false;
                }
            }
        }

        ajax.send(null);
       
       

}
function nuevoRegistroTiempoCantidadGeneral(nombreTabla)
{
       var table = document.getElementById(nombreTabla);
       var rowCount = table.rows.length;
       var row = table.insertRow(rowCount);
       row.onclick=function(){seleccionarFila(this);};
       var cell1 = row.insertCell(0);
       cell1.className="tableCell";
       var selectNombre = document.createElement("select");
       selectNombre.innerHTML=operariosRegistroGeneral;
       cell1.appendChild(selectNombre);
        var cell2 = row.insertCell(1);
       cell2.className="tableCell";
       cell2.align='center';
       var fechaSelect = document.createElement("input");
       fechaSelect.id="fechaTiempo"+table.rows.length;
       fechaSelect.type = "tel";
       fechaSelect.value=fechaSistemaGeneral;
       fechaSelect.onclick=function(){seleccionarDatePickerJs(this);};
       var fechaSpan=document.createElement("span");
       fechaSpan.className="textHeaderClassBodyNormal";
       fechaSpan.innerHTML=fechaSistemaGeneral;
       cell2.appendChild(codEstadoHojaGeneral==3?fechaSelect:fechaSpan);
       for(var i=0;i<2;i++)
       {
           var cell3 = row.insertCell(i+2);
           cell3.className="tableCell";
           var element3 = document.createElement("input");
           element3.id="fechaRegistro"+i+"t"+contadorRegistros;
           element3.onclick=function(){seleccionarHora(this);};
           element3.type = "tel";
           element3.value=getHoraActualString();
           cell3.align='center';
           element3.style.width='6em';
           element3.onfocus=function(){calcularDiferenciaHoras(this);};
           element3.onkeyup=function(){calcularDiferenciaHoras(this);};
           cell3.appendChild(element3);
       }
        var cell4 = row.insertCell(4);
        cell4.className="tableCell";
        var element4 = document.createElement("span");
        cell4.align='center';
        element4.innerHTML=0;
        element4.className='textHeaderClassBody';
        element4.style.fontWeight='normal';
        cell4.appendChild(element4);
  }
function nuevoRegistroGeneral(nombreTabla)
{
       var table = document.getElementById(nombreTabla);
       var rowCount = table.rows.length;
       var row = table.insertRow(rowCount);
       row.onclick=function(){seleccionarFila(this);};
       var cell1 = row.insertCell(0);
       cell1.className="tableCell";
       var selectNombre = document.createElement("select");
       selectNombre.innerHTML=operariosRegistroGeneral;
       cell1.appendChild(selectNombre);
        var cell2 = row.insertCell(1);
       cell2.className="tableCell";
       cell2.align='center';

//fecha de registro de tiempos
       var fechaSelect = document.createElement("input");
       fechaSelect.id="fechaTiempo"+table.rows.length;
       fechaSelect.type = "tel";
       fechaSelect.value=fechaSistemaGeneral;
       fechaSelect.onclick=function(){seleccionarDatePickerJs(this);};
       var fechaSpan=document.createElement("span");
       fechaSpan.className="textHeaderClassBodyNormal";
       fechaSpan.innerHTML=fechaSistemaGeneral;
       cell2.appendChild(codEstadoHojaGeneral==3?fechaSelect:fechaSpan);
//horas para personal
       if(codEstadoHojaGeneral==3)
       {
               for(var i=0;i<2;i++)
               {
                   var cell3 = row.insertCell(i+2);
                   cell3.className="tableCell";
                   var element3 = document.createElement("input");
                   element3.id="fechaRegistro"+i+"t"+contadorRegistros;
                   element3.onclick=function(){seleccionarHora(this);};
                   element3.type = "tel";
                   element3.value=getHoraActualString();
                   cell3.align='center';
                   element3.style.width='6em';
                   element3.onfocus=function(){calcularDiferenciaHoras(this);};
                   element3.onkeyup=function(){calcularDiferenciaHoras(this);};
                   cell3.appendChild(element3);
               }
       }
       else
       {
                   var celdaHoraInicio = row.insertCell(2);
                   celdaHoraInicio.className="tableCell";
                   celdaHoraInicio.align='center';
                   var horaInicioSpan = document.createElement("span");
                   horaInicioSpan.className="textHeaderClassBodyNormal";
                   horaInicioSpan.innerHTML=getHoraActualGeneralString();
                   celdaHoraInicio.appendChild(horaInicioSpan);
                   var celdaHoraFinal = row.insertCell(3);
                   celdaHoraFinal.className="tableCell";
                   celdaHoraFinal.align='center';
                   var buttonFinish=document.createElement("button");
                   buttonFinish.className='buttonFinish';
                   buttonFinish.innerHTML='Terminar';
                   var horaInicio=getHoraActualGeneralString();
                   buttonFinish.onclick=function(){calcularHorasGeneral(this,horaInicio);};
                   var horaFinSpan = document.createElement("span");
                   horaFinSpan.className="textHeaderClassBodyNormal";
                   horaFinSpan.innerHTML=getHoraActualString();
                   celdaHoraFinal.appendChild(buttonFinish);
                   celdaHoraFinal.appendChild(horaFinSpan);

       }

        var cell4 = row.insertCell(4);
        cell4.className="tableCell";
        var element4 = document.createElement("span");
        cell4.align='center';
        element4.innerHTML=0;
        element4.className='textHeaderClassBody';
        element4.style.fontWeight='normal';
        cell4.appendChild(element4);
  }
function formatArrayGeneral(tabla,nroFilaInicio,conPersonal)
{
    var array=new Array();
    for(var i=nroFilaInicio;i<tabla.rows.length;i++)
    {
        if(conPersonal)array[array.length]=tabla.rows[i].cells[0].getElementsByTagName("select")[0].value;
        array[array.length]=tabla.rows[i].cells[1].getElementsByTagName("span")[0].innerHTML;
        array[array.length]=tabla.rows[i].cells[2].getElementsByTagName("span")[0].innerHTML;
        array[array.length]=tabla.rows[i].cells[3].getElementsByTagName("span")[0].innerHTML;
        array[array.length]=parseFloat(tabla.rows[i].cells[4].getElementsByTagName("span")[0].innerHTML);
        array[array.length]=(tabla.rows[i].cells[3].getElementsByTagName('button')[0].className=="buttonFinishActive"?1:0);
    }
    return array;
}
var admin="";
var codPersonal="";



var Util={
	valueOptionsSelected:"",
        nameOptionsSelected:"",
	getValueOptionsSelected:function(){
		return this.valueOptionsSelected;

	},
	getNameOptionsSelected:function(){
		return this.nameOptionsSelected;
	},
            valuesNamesOptionsSelected:function(obj){
                var names=new Array();
                var values=new Array();
		var j=0;
		for(var i=0;i<=obj.options.length-1;i++)
		{	if(obj.options[i].selected)
			{	values[j]=obj.options[i].value;
                                names[j]=obj.options[i].text;
				j++;
			}
		}
                this.valueOptionsSelected=values;
                this.nameOptionsSelected=names;



	},
        selectedAllOptions:function(objCheckBox,objSelect){
            for(var  i=0;i<objSelect.options.length;i++)
                    objSelect.options[i].selected=objCheckBox.checked;
        },
        createAjaxObject:function(){
            var objetoAjax=false;
             try {
                /*Para navegadores distintos a internet explorer*/
                objetoAjax = new ActiveXObject("Msxml2.XMLHTTP");
                } catch (e) {
                       try {
                            /*Para explorer*/
                                objetoAjax = new ActiveXObject("Microsoft.XMLHTTP");
                            }
                        catch (E) {
                            objetoAjax = false;
                            }
                    }

                    if (!objetoAjax && typeof XMLHttpRequest!='undefined') {
                            objetoAjax = new XMLHttpRequest();
                    }
                return objetoAjax;


        }


};
//functiones ale inicio


function seleccionarFila(row)
  {
      //console.log("selecc"+row.parentNode.parentNode.className);
      var c=parseInt(row.parentNode.parentNode.className);
      if(c>0)
      {
          row.parentNode.parentNode.rows[c].style.backgroundColor='white';
      }
      row.parentNode.parentNode.className=row.rowIndex;
      row.style.backgroundColor='#f9b781';
  }
function eliminarRegistro(rowEliminar)
    {
        rowEliminar.style.backgroundColor='#F08080';
        if(confirm('Esta seguro de eliminar el seguimiento')==true)
        {
            var a =rowEliminar.parentNode;
            a.deleteRow(rowEliminar.rowIndex);

        }
        else
        {
            rowEliminar.style.backgroundColor='';
        }
    }
function transformDate(fecha)
    {
        var fechaTexto=fecha.getFullYear()+"/";
        fechaTexto+=(fecha.getMonth()>=9?"":"0")+(fecha.getMonth()+1)+"/";
        fechaTexto+=(fecha.getDate()>9?"":"0")+fecha.getDate()+" ";
        fechaTexto+=(fecha.getHours()>9?"":"0")+fecha.getHours()+":";
        fechaTexto+=(fecha.getMinutes()>9?"":"0")+fecha.getMinutes();
        return fechaTexto;
    }
function redondeo2decimales(numero)
{
        var original=parseFloat(numero);
        var result=Math.round(original*100)/100 ;
        return result;
}


function valEnteros()
{
  if ((event.keyCode < 48 || event.keyCode > 57) )
     {
        alert('Solo puede registrar numeros enteros');
        event.returnValue = false;
     }
}
function calcularDiferenciaHoras(obj)
{
    var fecha1=obj.parentNode.parentNode.cells[1].getElementsByTagName('input')[0].value+' '+obj.parentNode.parentNode.cells[2].getElementsByTagName('input')[0].value;
    var fecha2=obj.parentNode.parentNode.cells[1].getElementsByTagName('input')[0].value+' '+obj.parentNode.parentNode.cells[3].getElementsByTagName('input')[0].value;
    obj.parentNode.parentNode.cells[4].getElementsByTagName('span')[0].innerHTML=getNumeroDehoras(fecha1,fecha2);
    return true;
}




function validarRegistroNumero(inputNumero){
      inputNumero.style.backgroundColor='#ffffff';
       if (isNaN(inputNumero.value)){
           inputNumero.style.backgroundColor='#F08080';
            inputNumero.focus();
            alert ("Solo se permiten numeros\nNumero no valido: "+inputNumero.value);
            return false;
        }
        else{
           return true;
        }
        alert("Numero invalido")
        inputNumero.style.backgroundColor='#F08080';
        inputNumero.focus();
        return false;
    }


    function validadRegistroMayorACero(input)
    {
        input.style.backgroundColor='#ffffff';
        if(parseFloat(input.value)>0)
        {
            
            return true;
        }
        else
        {
            alert('Debe registrar una cantidad mayor a cero');
            input.style.backgroundColor='#F08080';
            input.focus();
            return false;
        }
        

        return true;
    }
//function ale final

function valMAY()
{

    if ((event.keyCode > 96 && event.keyCode < 123) || event.keyCode > 223 && event.keyCode < 253)
    {   var tecla=parseInt(event.keyCode);
        tecla=tecla-32;
        event.keyCode=tecla;
        event.returnValue=true;

    }
}

function valNum()
{  if ((event.keyCode < 48 || event.keyCode > 57) && event.keyCode!=44 && event.keyCode!=45 && event.keyCode!=46)
     {
        alert('Introduzca solo Números.');
        event.returnValue = false;
     }
}
    function editarItem(nametable){
                   var count=0;

                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;

                    for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                           count++;
                         }

                     }

                   }

                   if(count==1){
                      return true;
                   } else if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                   }
                   else if(count>1){
                       alert('Solo puede escoger un registro');
                       return false;
                   }

                   return false;
                }




function eliminarItem(nametable){

                   var count=0;

                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                           count++;
                         }

                     }

                   }

                    if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                }
    var cantidadeliminar=document.getElementById('form1:cantidadeliminar');
cantidadeliminar.value=count;
   return true;
}

function delItem(nametable){

                   var count=0;

                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                           count++;
                         }

                     }

                   }

                    if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                }
    var a=confirm("Esta seguro de Elimianar los Datos?")
    if(a==1){
        var cantidadeliminar=document.getElementById('form1:cantidadeliminar');
        cantidadeliminar.value=count;
        return true;
     }
    else
        return false;
}
function onrowmouseout(obj){
    obj.style.backgroundColor='#FFFFFF';
}
function onrowmouseover(obj){
    obj.style.backgroundColor='#CCDFFA';
}


/*****************************************/

function carga(id)
{
    //alert('hola');
    posicion=3;

    // IE
    if(navigator.userAgent.indexOf("MSIE")>=0) navegador=0;
    // Otros
    else navegador=1;

}

function evitaEventos(event)
{
    // Funcion que evita que se ejecuten eventos adicionales
    if(navegador==0)
    {
        window.event.cancelBubble=true;
        window.event.returnValue=false;
    }
    if(navegador==1) event.preventDefault();
}
function comienzoMovimiento(event, id)
{

    elMovimiento=document.getElementById(id);

     // Obtengo la posicion del cursor
    if(navegador==0)
     {
        cursorComienzoX=window.event.clientX+document.documentElement.scrollLeft+document.body.scrollLeft;
         cursorComienzoY=window.event.clientY+document.documentElement.scrollTop+document.body.scrollTop;

        document.attachEvent("onmousemove", enMovimiento);
        document.attachEvent("onmouseup", finMovimiento);
    }
    if(navegador==1)
    {
        cursorComienzoX=event.clientX+window.scrollX;
        cursorComienzoY=event.clientY+window.scrollY;

        document.addEventListener("mousemove", enMovimiento, true);
        document.addEventListener("mouseup", finMovimiento, true);
    }
    elComienzoX=parseInt(elMovimiento.style.left);
    elComienzoY=parseInt(elMovimiento.style.top);
    // Actualizo el posicion del elemento
    elMovimiento.style.zIndex=++posicion;
    evitaEventos(event);
}

function enMovimiento(event)
{
    var xActual, yActual;
    if(navegador==0)
    {
        xActual=window.event.clientX+document.documentElement.scrollLeft+document.body.scrollLeft;
        yActual=window.event.clientY+document.documentElement.scrollTop+document.body.scrollTop;
    }
    if(navegador==1)
    {
        xActual=event.clientX+window.scrollX;
        yActual=event.clientY+window.scrollY;
    }
    elMovimiento.style.left=(elComienzoX+xActual-cursorComienzoX)+"px";
    elMovimiento.style.top=(elComienzoY+yActual-cursorComienzoY)+"px";

    evitaEventos(event);
}

function finMovimiento(event)
{
    if(navegador==0)
    {
        document.detachEvent("onmousemove", enMovimiento);
        document.detachEvent("onmouseup", finMovimiento);
    }
    if(navegador==1)
    {
        document.removeEventListener("mousemove", enMovimiento, true);
        document.removeEventListener("mouseup", finMovimiento, true);
    }
}

 function closePanelCalculo(){
                    document.getElementById('form1:panelCalcular').style.visibility='hidden';
                    document.getElementById('panelsuper').style.visibility='hidden';
                }
 function closePanelBuscar(){
                    document.getElementById('form1:panelBuscar').style.visibility='hidden';
                    document.getElementById('panelsuper').style.visibility='hidden';
 }
 function closePanelBuscar1(){
                    document.getElementById('form1:panelBuscar1').style.visibility='hidden';
                    document.getElementById('panelsuper').style.visibility='hidden';
 }
 /* ANULAR ITEM */
function anularItem(nametable,columna,varData,columna2){

                   var count=0;
                   var idIA='0';
                   var idIA2='0';
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                     var celda=cel.getElementsByTagName('input')[0];
                        if(celda!=null){
                                    if(celda.type=='checkbox'){
                                        if(celda.checked){
                                            idIA=cellsElement[columna].getElementsByTagName('SPAN')[0].innerHTML;
                                            idIA2=cellsElement[columna2].getElementsByTagName('SPAN')[0].innerHTML;
                                            count++;
                                          }
                                    }
                            }
                   }
                    /*if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                         if(cel.getElementsByTagName('input')[0].checked){
                           idIA=cellsElement[columna].getElementsByTagName('SPAN')[0].innerHTML;
                           idIA2=cellsElement[columna2].getElementsByTagName('SPAN')[0].innerHTML;
                           count++;
                         }
                     }
                   }*/
                if(count==0){
                    alert('No escogio ningun registro');
                    return false;
                }
                else if(count>1){
                    alert('Solo puede escoger un registro');
                    return false;
                }


    if (idIA=='ANULADA' && varData=='EDITAR'){
        alert("Este Registro NO puede ser Editado");
        return false;
    }
    if (varData=='EDITAR' && idIA=='NORMAL'  && idIA2=='1' ){
        alert("Este Registro NO puede ser Editado");
        return false;
    }
    if (idIA=='NORMAL'  && idIA2=='1' &&  varData=='ANULAR'){
        alert("Este Registro NO puede ser Anulado");
        return false;
    }
    if (idIA=='ANULADA'  && idIA2=='1' &&  varData=='ANULAR'){
        alert("Este Registro ya esta Anulado");
        return false;
    }
    if (idIA=='ANULADA'  && idIA2=='0' &&  varData=='ANULAR'){
        alert("Este Registro ya esta Anulado");
        return false;
    }
    if(varData=='EDITAR'){
        return true;
    }
    var a=confirm("Esta seguro de anular?")
    if(a==1){
        return true;
     }
    else
        return false;
}


function editarItem2(nametable){
                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=2;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                           count++;
                         }

                     }

                   }
                   if(count==1){
                      return true;
                   } else if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                   }
                   else if(count>1){
                       alert('Solo puede escoger un registro');
                       return false;
                   }
                   return false

                }
//window.onload=carga;
var elMovimiento;
var cursorComienzoX;
var cursorComienzoY;
var navegador;
function editarItemUno(nametable){

                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    var celda=cel.getElementsByTagName('input')[0];
                        if(celda!=null){
                                    if(celda.type=='checkbox'){
                                        if(celda.checked)count++;
                                    }
                            }
                   }
                   if(count==1){
                      return true;
                   } else if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                   }
                   else if(count>1){
                       alert('Solo puede escoger un registro');
                       return false;
                   }
return false;
}
function anularItemUno(nametable){
                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    var celda=cel.getElementsByTagName('input')[0];
                        if(celda!=null){
                                    if(celda.type=='checkbox'){
                                        if(celda.checked)count++;
                                    }
                            }
                   }


                    if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                   }
                   var a=confirm("Esta seguro de anular?");
                   if(a==1)
                        return true;
                   else
                        return false;
}
function anularItemCobranza(nametable){
                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    var celda=cel.getElementsByTagName('input')[1];
                        if(celda!=null){
                                    if(celda.type=='checkbox'){
                                        if(celda.checked)count++;
                                    }
                            }
                   }


                    if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                   }
                   var a=confirm("Esta seguro de anular?");
                   if(a==1)
                        return true;
                   else
                        return false;
}
// SCRIPT PARA APROBAR O RECHAZAR PEDIDOS
function AprobarRechazarPedido(nametable,varData){
                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    var celda=cel.getElementsByTagName('input')[0];
                        if(celda!=null){
                                    if(celda.type=='checkbox'){
                                        if(celda.checked)count++;
                                    }
                            }
                   }
                    if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                   }
                   var a=confirm("Esta seguro de "+varData+" el pedido?");
                   if(a==1)
                        return true;
                   else
                   return false;
}
                /****************************************************************/
                /********************** VALIDAR FECHA ***************************/
                function esDigito(sChr){
                    var sCod = sChr.charCodeAt(0);
                    return ((sCod > 47) && (sCod < 58));
                }
                function valSep(oTxt){
                    var bOk = false;
                    bOk = bOk || ((oTxt.value.charAt(2) == "-") && (oTxt.value.charAt(5) == "-"));
                    bOk = bOk || ((oTxt.value.charAt(2) == "/") && (oTxt.value.charAt(5) == "/"));
                    return bOk;
                }
                
                function valDia(oTxt){
                    var bOk = false;
                    var nDia = parseInt(oTxt.value.substr(0, 2), 10);
                    bOk = bOk || ((nDia >= 1) && (nDia <= finMes(oTxt)));
                    return bOk;
                }
                
                function valFecha(oTxt){

                    var bOk = true;
                    if (oTxt.value == ""){
                        alert("Fecha inválida");
                        oTxt.focus();
                    }
                    if (oTxt.value != ""){
                    bOk = bOk && (valAno(oTxt));
                    bOk = bOk && (valMes(oTxt));
                    bOk = bOk && (valDia(oTxt));
                    bOk = bOk && (valSep(oTxt));
                    if (!bOk){
                        alert("Fecha inválida");
                    //oTxt.value = "";
                    oTxt.focus();
                    }
                  }
                }

var colLeft=15;
var colRight=85;

function resizableSplit(){
                    colLeft--;
                    colRight++;
                    var texto='colLeft'+'%,'+colRight+'%';
                    parent.document.getElementById('main').cols=texto;
                    if(colLeft!=10){
                      setTimeout("resizableSplit()",1000);
                    }
                }
function resizableSplitOnclick(){
            var values=parent.document.getElementById('main').cols;
            var cadenas=values.split(",");
            var x1=cadenas[0].split("%")[0];
            var y1=cadenas[1].split("%")[0];
            var obj=document.getElementById('icon');
            if(x1==0){
                obj.src='../img/collapse.gif';
                parent.document.getElementById('main').cols='20%,80%';

            }else{
                obj.src='../img/expand.gif';
                parent.document.getElementById('main').cols='0%,100%';
            }

}

function resizableSplitMove(){
    var icon=document.getElementById('icon');
    icon.style.left=parseInt(window.event.clientX+document.documentElement.scrollLeft+document.body.scrollLeft+10)+'px';
    icon.style.top=parseInt(window.event.clientY+document.documentElement.scrollTop+document.body.scrollTop)+'px';

}

function creaAjax(){
         var objetoAjax=false;
         try {
          /*Para navegadores distintos a internet explorer*/
          objetoAjax = new ActiveXObject("Msxml2.XMLHTTP");
         } catch (e) {
          try {
                   /*Para explorer*/
                   objetoAjax = new ActiveXObject("Microsoft.XMLHTTP");
                   }
                   catch (E) {
                   objetoAjax = false;
          }
         }
         
             if (!objetoAjax && typeof XMLHttpRequest!='undefined') {
              objetoAjax = new XMLHttpRequest();
             }
         
         return objetoAjax;
}
                /**************************************************************************************************/
                /**************************************************************************************************/
                /********************* FORMATO DE NUMERO EN JAVA SCRIPT*******************************/
function formatAsMoney(mnt) {
    mnt -= 0;
    mnt = (Math.round(mnt*100))/100;
    return (mnt == Math.floor(mnt)) ? mnt + '.00' : ( (mnt*10 == Math.floor(mnt*10)) ? mnt + '0' : mnt);
}
function formatCurrency(num) {
    num = num.toString().replace(/$|,/g,'');
    if(isNaN(num))
        num = "0";
        sign = (num == (num = Math.abs(num)));
        num = Math.floor(num*100+0.50000000001);
        cents = num%100;
        num = Math.floor(num/100).toString();
    if(cents<10)
        cents = "0" + cents;
    for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++)
        num = num.substring(0,num.length-(4*i+3))+'.'+
    num.substring(num.length-(4*i+3));
    return (((sign)?'':'-') + 'Bs. ' + num + ',' + cents);
}
function formatCurrency1(num) {
    num = num.toString().replace(/$|,/g,'');
    if(isNaN(num))
        num = "0";
        sign = (num == (num = Math.abs(num)));
        num = Math.floor(num*100+0.50000000001);
        cents = num%100;
        num = Math.floor(num/100).toString();
    if(cents<10)
        cents = "0" + cents;
    for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++)
        num = num.substring(0,num.length-(4*i+3))+','+
    num.substring(num.length-(4*i+3));
    return (((sign)?'':'-')+ num + '.' + cents);
}
function formatCuatroDigitos(num) {
    num = num.toString().replace(/$|,/g,'');
    if(isNaN(num))
        num = "0";
        sign = (num == (num = Math.abs(num)));
        num = Math.floor(num*100+0.50000000001);
        cents = num%100;
        num = Math.floor(num/100).toString();
    if(cents<10)
        cents = "0" + cents;
    for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++)
        num = num.substring(0,num.length-(4*i+3))+'.'+
    num.substring(num.length-(4*i+3));
    return (((sign)?'':'-') + 'Bs. ' + num + ',' + cents);
}
function formatoPresupuesto(num) {
    num = num.toString().replace(/$|,/g,'');
    if(isNaN(num))
        num = "0";
        sign = (num == (num = Math.abs(num)));
        num = Math.floor(num*100+0.50000000001);
        cents = num%100;
        num = Math.floor(num/100).toString();
    if(cents<10)
        cents = "0" + cents;
    for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++)
        num = num.substring(0,num.length-(4*i+3))+','+
    num.substring(num.length-(4*i+3));
    return (((sign)?'':'-')+ num);
}
