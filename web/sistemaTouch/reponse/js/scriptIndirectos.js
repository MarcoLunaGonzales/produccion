
function iniciarTiempoIndirectoOperario(botonIniciar,nombreTabla)
{
    window.parent.bloquearIndirectos();
    var peticion="ajaxIniciarTiempoIndirecto.jsf?noCache="+ Math.random()+
                 "&codProgProd="+window.parent.codProgramaProdIndirecta+
                 "&codAreaEmpresa="+window.parent.codAreaEmpresaIndirecta+
                 "&codActividad="+document.getElementById("codActividad").value+
                 "&fechaInicio="+fechaSistemaGeneral+
                 "&horaInicio="+this.getHoraActualGeneralString()+
                 "&codPersonal="+window.parent.codPersonalIndirecta;
     ajax=nuevoAjax();
     ajax.open("GET",peticion,true);
     ajax.setRequestHeader('content-type', 'application/x-www-form-urlencoded;charset=UTF-8');
             ajax.onreadystatechange=function(){
                if (ajax.readyState==4) {
                    if(ajax.responseText==null || ajax.responseText=='')
                    {
                        window.parent.alert('No se puede conectar con el servidor, verfique su conexión a internet');
                        if(confirm("Desea guardar la informacion localmente?\nLa informacion del lote no se perdera pero debe de subirla despues"))
                        {
                            sqlConnection.insertarRegistroAuxiliar(codProgramaProd,codLote,2,("../registroRepesada/"+peticion),function(){window.close();});
                        }
                        window.parent.desBloquearIndirectos();
                        return false;
                    }
                    if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                    {
                         var tabla=document.getElementById(nombreTabla);
                        var fila=tabla.insertRow(tabla.rows.length);
                        (componentesJs.crearCelda(fila)).appendChild(componentesJs.crearSpanFecha());
                        (componentesJs.crearCelda(fila)).appendChild(componentesJs.crearSpanHoraInicio());
                        window.parent.desBloquearIndirectos();
                        window.parent.confirmJs("Se registro el inicio de la actividad<br>Desea registrar otra actividad?",function(resultado)
                            {
                                window.parent.bloquearIndirectos();
                                botonIniciar.style.display='none';
                                if(resultado)
                                {
                                    window.location.href='navegadorActividadesIndirectas.jsf?ca='+(window.parent.codAreaEmpresaIndirecta)+'&p='+window.parent.codPersonalIndirecta+'&data='+(new Date()).getTime().toString();
                                    window.parent.desBloquearIndirectos();
                                }
                                else
                                {
                                    sqlConnection.terminarSessionUsuario(function(){
                                    window.parent.location.href='../loginIndirectos.jsf?data='+(new Date()).getTime().toString();});
                                    window.parent.desBloquearIndirectos();
                                }
                            }
                        );
                        return true;
                    }
                    else
                    {
                        window.parent.desBloquearIndirectos();
                        window.parent.alertJs(ajax.responseText.split("\n").join(""));
                        return false;
                    }
                }
            }

            ajax.send(null);
   
}
function terminarTiempoIndirectos(celdaFin,horaInicio)
{
    window.parent.confirmJs('Esta seguro de terminar su registro?',function(resultado)
    {
        if(resultado)
        {
            window.parent.bloquearIndirectos();
            var horasHombre=(parseInt(getHoraActualGeneralString().split(":")[0])+(parseInt(getHoraActualGeneralString().split(":")[1])/60));
                horasHombre-=(parseInt(horaInicio.split(":")[0])+(parseInt(horaInicio.split(":")[1])/60));
            var peticion="ajaxTerminarTiempoIndirecto.jsf?noCache="+ Math.random()+
                         "&codProgProd="+window.parent.codProgramaProdIndirecta+
                         "&codAreaEmpresa="+window.parent.codAreaEmpresaIndirecta+
                         "&codActividad="+document.getElementById("codActividad").value+
                         "&fechaInicio="+fechaSistemaGeneral+
                         "&horaInicio="+getHoraActualGeneralString()+
                         "&horasHombre="+horasHombre+
                         "&codPersonal="+window.parent.codPersonalIndirecta;
             ajax=nuevoAjax();
             ajax.open("GET",peticion,true);
             ajax.setRequestHeader('content-type', 'application/x-www-form-urlencoded;charset=UTF-8');
                     ajax.onreadystatechange=function(){
                        if (ajax.readyState==4) {
                            if(ajax.responseText==null || ajax.responseText=='')
                            {
                                alert('No se puede conectar con el servidor, verfique su conexión a internet');
                                if(confirm("Desea guardar la informacion localmente?\nLa informacion del lote no se perdera pero debe de subirla despues"))
                                {
                                    sqlConnection.insertarRegistroAuxiliar(codProgramaProd,codLote,2,("../registroRepesada/"+peticion),function(){window.close();});
                                }
                                window.parent.desBloquearIndirectos();
                                return false;
                            }
                            if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                            {
                                window.parent.desBloquearIndirectos();
                                window.parent.confirmJs("Se registro la finalizacion de la actividad<br>Desea registrar otra actividad?",function(resultado)
                                    {
                                        celdaFin.style.display='none';
                                        if(resultado)
                                        {
                                            window.location.href='navegadorActividadesIndirectas.jsf?ca='+(window.parent.codAreaEmpresaIndirecta)+'&p='+window.parent.codPersonalIndirecta+'&data='+(new Date()).getTime().toString();
                                        }
                                        else
                                        {
                                            sqlConnection.terminarSessionUsuario(function(){
                                            window.parent.location.href='../loginIndirectos.jsf?data='+(new Date()).getTime().toString();});
                                        }
                                    }
                                );
                                return true;
                            }
                            else
                            {
                                window.parent.desBloquearIndirectos();
                                window.parent.alertJs(ajax.responseText.split("\n").join(""));
                                return false;
                            }
                        }
                    }

                    ajax.send(null);
            }
    });
}
function terminarTiempoIndirectoAdmin(celdaFin)
{
    celdaFin.parentNode.getElementsByTagName("input")[0].style.display='inline';
    celdaFin.className='buttonFinishActive';
    celdaFin.parentNode.getElementsByTagName("input")[0].onclick();
}
//para cerrar tiempos directos
function terminarTiempoDirecto(codLote,codProgramaProd,codForm,codComp,codTipoProg,codActividad,fechaInicio)
{
    bloquearIndirectos();
    var peticion="../../registroTiemposAlmacen/ajaxTerminarTiempoIndirecto.jsf?codProgramaProd="+codProgramaProd+
                 "&codLote="+codLote+
                 "&codFormulaMaestra="+codForm+
                 "&codComprod="+codComp+
                 "&codTipoProgramaProd="+codTipoProg+
                 "&codActividad="+codActividad+
                 "&codPersonal="+codPersonalIndirecta+
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
                            location.href='../loginIndirectos.jsf?data='+(new Date()).getTime().toString();});
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


function terminarTiempoIndirectoPendiente(codProgramaProd,codAreaEmpresa,codActividad,fechaInicio,codPersonal)
{
    iniciarProgresoSistema();
    var peticion="ajaxTerminarTiempoIndirecto.jsf?codProgProd="+codProgramaProd+
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
                            sqlConnection.terminarSessionUsuario(function(){
                            location.href='../loginIndirectos.jsf?data='+(new Date()).getTime().toString();});
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
