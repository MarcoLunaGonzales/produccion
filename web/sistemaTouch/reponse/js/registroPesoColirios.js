function registroEspecificacion(codTipoProgramaProd,nombreTipoProgramaProd,limiteTeorico,limiteInferior,limiteSuperior)
{
    this.nombreTipoProgramaProd=nombreTipoProgramaProd;
    this.codTipoProgramaProd=codTipoProgramaProd;
    this.limiteTeorico=limiteTeorico;
    this.limiteInferior=limiteInferior;
    this.limiteSuperior=limiteSuperior;
    
}
var registroPesoMCMM=new function()
{
    this.panelRegistroPesoMinimo,this.divRegistroDespejeDespeje,this.admin=false,
    this.codProgramaProd,this.codLote,this.codPersonalUsuario;
    this.especificacionesRegistro=new Array();
    
    this.agregarRegistroEspecificacion=function(registroEspecificacion)
    {
        this.especificacionesRegistro[this.especificacionesRegistro.length]=registroEspecificacion;
    }
    this.verificarRegistroLlenadoVolumen=function(admin,codProgramaProd,codLote,codPersonalUsuario)
    {
        
        this.codPersonalUsuario=codPersonalUsuario;
        this.codProgramaProd=document.getElementById(codProgramaProd).value;
        this.codLote=document.getElementById(codLote).value;
        this.admin=admin;
        for(var j=0;j<this.especificacionesRegistro.length;j++)
        {
            if(this.especificacionesRegistro[j].limiteTeorico<=0)
            {
                this.crearLogin();
                this.mostrarLogin();
            }
        }
        
        
    }
    this.mostrarLogin=function()
    {
        this.divRegistroDespeje.className='panelRegistroVisible';
        this.panelRegistroPesoMinimo.className='panelModalVisible';
    }
    this.guardarDatos=function()
    {
        var datosGuardar=new Array();
        for(var j=0;j<this.especificacionesRegistro.length;j++)
        {
            if(parseFloat(document.getElementById("jsLimitTeorico"+this.especificacionesRegistro[j].codTipoProgramaProd).value)<=0||
               parseFloat(document.getElementById("jsLimitMax"+this.especificacionesRegistro[j].codTipoProgramaProd).value)<=0||
               parseFloat(document.getElementById("jsLimitMin"+this.especificacionesRegistro[j].codTipoProgramaProd).value)<=0)
               {
                    alert('No puede registrar una cantidad menor o igual a cero');
                    return false;
               }
               else
               {
                    datosGuardar[datosGuardar.length]=this.especificacionesRegistro[j].codTipoProgramaProd;
                    datosGuardar[datosGuardar.length]=document.getElementById("jsLimitTeorico"+this.especificacionesRegistro[j].codTipoProgramaProd).value;
                    datosGuardar[datosGuardar.length]=document.getElementById("jsLimitMax"+this.especificacionesRegistro[j].codTipoProgramaProd).value;
                    datosGuardar[datosGuardar.length]=document.getElementById("jsLimitMin"+this.especificacionesRegistro[j].codTipoProgramaProd).value;
               }
        }
        var ajax=nuevoAjax();
        var peticion="ajaxGuardarPesos.jsf?codLote="+this.codLote+"&codProgramaProd="+this.codProgramaProd+
            "&datosLimite="+datosGuardar+
            "&codPersonalUsuario="+this.codPersonalUsuario+
            "&data="+(new Date()).getTime().toString();
        ajax=nuevoAjax();
         ajax.open("GET",peticion,true);
                 ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        if(ajax.responseText==null || ajax.responseText=='')
                        {
                            alert('No se puede conectar con el servidor, verfique su conexión a internet');
                            return false;
                        }
                        if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                        {
                            alert('Se guardaron los limites de aceptación');
                            window.close();
                            return true;
                        }
                        else
                        {
                            alert(ajax.responseText.split("\n").join(""));
                            return false;
                        }
                    }
                }

                ajax.send(null);
    }
    
    this.crearLogin=function()
    {
         this.panelRegistroPesoMinimo=document.createElement("div");
         this.panelRegistroPesoMinimo.className='panelModalHide';
         this.panelRegistroPesoMinimo.id='panelRegistroPesoMinimoDespeje';
         this.divRegistroDespeje=document.createElement("div");
         this.divRegistroDespeje.className='panelModalHide';
         this.divRegistroDespeje.id='divLogin';
         var tabla="<center>"+
                   " <table   class='tablaRegistro' style='border-color:#a80077;background-color:white;width:80%' cellpadding='0' cellspacing='0'>";
         for(var j=0;(j<this.especificacionesRegistro.length&&this.admin);j++)
         {
            tabla+="<tr><td class='celdaCabeceraTime' colspan='6' ><span style='width:1.5em' >"+this.especificacionesRegistro[j].nombreTipoProgramaProd+"</span></td></tr>"+
                   "<tr>"+
                   "<td class='tableCell'><span class='textHeaderClassBody' style='font-weight:normal'>Limites de aceptacion teorico en gramos </span></td>"+
                   "<td class='tableCell'><input style='width:4em !important' type='tel' id='jsLimitTeorico"+this.especificacionesRegistro[j].codTipoProgramaProd+"' value='"+this.especificacionesRegistro[j].limiteTeorico+"'></td>"+
                   "<td class='tableCell'><span class='textHeaderClassBody' style='font-weight:normal'>Limites de aceptacion maximo en gramos </span></td>"+
                   "<td class='tableCell'><input style='width:4em !important' type='tel' id='jsLimitMax"+this.especificacionesRegistro[j].codTipoProgramaProd+"' value='"+this.especificacionesRegistro[j].limiteSuperior+"'></td>"+
                   "<td class='tableCell'><span class='textHeaderClassBody' style='font-weight:normal'>Limites de aceptacion minimo en gramos </span></td>"+
                   "<td class='tableCell'><input style='width:4em !important' type='tel' id='jsLimitMin"+this.especificacionesRegistro[j].codTipoProgramaProd+"' value='"+this.especificacionesRegistro[j].limiteInferior+"'></td>"+
                   " </tr>";
         }
         if(!this.admin)
         {
            tabla+="<tr><td class='celdaCabeceraTime' colspan='6' ><span style='width:1.5em' >LIMITES DE ACEPTACION</span></td></tr>"+
                   "<tr><td><span class='textHeaderClassBody' >Solicite los limites de aceptacion al jefe de area.</span></td></tr>";
         }
                   
          tabla+="<tr><td bgColor='white' style='border-radius: 15px;' align='center' colspan='6'>"+(this.admin?"<button  class='buttonHIde'    style='width:40%;' onclick='registroPesoMCMM.guardarDatos();' >Guardar</button>":"")+
                   "<button  class='buttonHIde'  style='border-radius: 15px;width:40%;' onclick='window.close()' >Cancelar</button></td>"+
                   "</tr>"+
                   "</table>"+
                   "<center>";
         this.divRegistroDespeje.innerHTML=tabla;



         document.body.appendChild(this.divRegistroDespeje);
         document.body.appendChild(this.panelRegistroPesoMinimo);
         
    }
}