/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
 function loginHoja()
{
    this.panelRegistro,this.divRegistro,this.numeroUno,this.numeroDos,this.contIntentos=0,this.admin=false,
    this.codProgramaProd,this.codLote,this.codHoja,this.codEstadoHoja;
    this.generarNumero=function(rangoInferior,rangoSuperior)
    {
        return Math.floor(Math.random()*(rangoSuperior-rangoInferior+1))+rangoInferior;
    }
    this.verificarHojaCerradaAcond=function(codPersonal,admin,codHoja,codEstadoHoja)
    {
        this.codEstadoHoja=codEstadoHoja;
        this.codProgramaProd=codProgramaProdGeneral;
        this.codLote=codLoteGeneral;
        this.codHoja=codHoja;
        this.admin=admin;
        console.log(document.getElementById(codPersonal).value+" :: "+this.codEstadoHoja+" :: "+admin+" ::  "+codPersonal+" :: "+codEstadoHoja);
        if(parseInt(document.getElementById(codPersonal).value)>0&&(this.codEstadoHoja!=2))
        {
            //document.getElementById(nombrePanel).style.visibility='visible';
            console.log("ingresa");
            this.numeroUno=this.generarNumero(1000,9999);
            this.numeroDos=this.generarNumero(1000,9999);
            this.crearLogin();
            this.mostrarLogin();

        }

    }
    this.verificarHojaCerrada=function(codPersonal,admin,codProgramaProd,codLote,codHoja,codEstadoHoja)
    {console.log("verificar hoja cerrada "+admin);
        this.codEstadoHoja=codEstadoHoja;
        this.codProgramaProd=document.getElementById(codProgramaProd).value;
        this.codLote=document.getElementById(codLote).value;
        this.codHoja=codHoja;
        this.admin=admin;
        if(parseInt(document.getElementById(codPersonal).value)>0&&(this.codEstadoHoja!=2))
        {
            //document.getElementById(nombrePanel).style.visibility='visible';
            this.numeroUno=this.generarNumero(1000,9999);
            this.numeroDos=this.generarNumero(1000,9999);
            this.crearLogin();
            this.mostrarLogin();

        }

    }
    this.mostrarLogin=function()
    {
        if(this.admin)this.divRegistro.className='panelRegistroVisible';
        this.divRegistro.className='panelRegistroVisible';
        this.panelRegistro.className='panelModalVisible';
    }
    this.solicitarModificacion=function()
    {
        var ajax=nuevoAjax();
        var peticion=(this.codHoja==5?"":"../")+"ajaxSolicitarModificacionLote.jsf?codLote="+this.codLote+"&codProgramaProd="+this.codProgramaProd+"&codHoja="+this.codHoja;
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
                            alert('Se realizo la solicitud de edicion de datos');
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
    this.verificarLogin=function()
    {
        var password="";
        password+=(parseInt(this.numeroUno.toString()[0])+parseInt(this.numeroDos.toString()[3]));
        password+=(parseInt(this.numeroDos.toString()[0])+parseInt(this.numeroUno.toString()[3])+1);
        password+=this.numeroUno.toString()[1];
        password+=(parseInt(this.numeroDos.toString()[2])+1);
        if(parseInt(document.getElementById("loginAutorizacion").value)==parseInt(password))
        {
            this.panelRegistro.className='panelModalHide';
            this.divRegistro.className='panelModalHide';
        }
        else
        {
            alert('Autorizacion invalida');
            this.contIntentos++;
        }
        if(this.contIntentos>2)
        {
            this.numeroUno=this.generarNumero(1000,9999);
            this.numeroDos=this.generarNumero(1000,9999);
            document.getElementById("login:numeroDos").innerHTML=this.numeroDos;
            document.getElementById("login:numeroUno").innerHTML=this.numeroUno;
            this.contIntentos=0;
        }
    }
    this.crearLogin=function()
    {
       console.log("inicio login ");
         this.panelRegistro=document.createElement("div");
         this.panelRegistro.className='panelModalHide';
         this.panelRegistro.id='panelLogin';
         this.divRegistro=document.createElement("div");
         this.divRegistro.className='panelModalHide';
         this.divRegistro.id='divLogin';
         var tabla="<center>"+
                            " <table   class='tablaRegistro' style='border-color:#a80077;background-color:white;' cellpadding='0' cellspacing='0'>"+
                               "<tr><td class='celdaCabeceraTime' colspan='3' ><span style='width:1.5em'>AUTORIZACION</span></td></tr>"+
                               "<tr><td colspan='3' bgColor='white' >No se pueden modificar los datos,introduzca la autorizacion.</td></tr>"+
                               "<tr><td colspan='3' bgColor='white' align='center'><span style='font-size:2em;font-weight:bold' id='login:numeroUno'>"+this.numeroUno+"</span></td></tr>"+
                               "<tr><td colspan='3' bgColor='white' align='center'><span style='font-size:2em;font-weight:bold' id='login:numeroDos'>"+this.numeroDos+"</span></td></tr>"+
                               "<tr><td colspan='3' bgColor='white' align='center'><input type='tel' value='' id='loginAutorizacion' style='width:7em !important;'/></tr>"+
                               "<tr><td colspan='3' bgColor='white' style='border-radius: 15px;' align='center'><button  class='buttonHIde' style='width:70%'  onclick='loginHoja.verificarLogin();' >Aceptar</button></td>"+
                               "</tr></table><center>";
                           tabla="<center>"+
                            " <table   class='tablaRegistro' style='border-color:#a80077;background-color:white;' cellpadding='0' cellspacing='0'>"+
                               "<tr><td class='celdaCabeceraTime' colspan='3' ><span style='width:1.5em'>Solicitar Autorizacion</span></td></tr>"+
                               "<tr><td colspan='3' bgColor='white' >"+(this.codEstadoHoja==1?"Ya se ha solicitado la edicion de datos":"No se pueden modificar los datos,desea solicitar autorizacion?")+"</td></tr>"+
                               "<tr><td bgColor='white' style='border-radius: 15px;' align='center'><button  class='buttonHIde'"+(this.codEstadoHoja==1?" disabled='true'":"")+"   onclick='loginHoja.solicitarModificacion();' >Solicitar</button></td>"+
                               "<td></td><td bgColor='white' style='border-radius: 15px;' align='center'><button  class='buttonHIde'   onclick='window.close()' >Cancelar</button></td>"+
                               "</tr>"+
                               "</table><center>";
         this.divRegistro.innerHTML=tabla;
console.log("login tabla "+tabla);


         document.body.appendChild(this.divRegistro);
         document.body.appendChild(this.panelRegistro);
         console.log("login creado");
    }
}
var loginHoja=new loginHoja();
function getNumeroDehoras(fechaIni,fechaFin)
{
    if(fechaIni.length==16&&fechaFin.length==16)
    {
        var fec=fechaIni.split(" ");
        var d1=fec[0].split("/");
        var h1=fec[1].split(":");
        var dat1 = new Date(d1[2], parseFloat(d1[1]), parseFloat(d1[0]),parseFloat(h1[0]),parseFloat(h1[1]),0);

         var de2 = fechaFin.split(" ");

         var d2=de2[0].split("/");
         var h2=de2[1].split(":");

         var dat2 = new Date(d2[2], parseFloat(d2[1]), parseFloat(d2[0]),parseFloat(h2[0]),parseFloat(h2[1]),0);
         var fin = dat2.getTime() - dat1.getTime();
         var dias=0;
         if(dat1!='NaN'&& dat2!='Nan')
         {
            dias =redondeo2decimales(fin / (1000 * 60 * 60));
         }
       return dias;
    }
    return 0;
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
function getHoraActualGeneralString()
{
    var a=new Date();
    return ((a.getHours()>9?"":"0")+a.getHours()+":"+(a.getMinutes()>9?"":"0")+a.getMinutes());
}
function seleccionarFila(row)
{
      var c=parseInt(row.parentNode.parentNode.className);
      if(c>0)
      {
          row.parentNode.parentNode.rows[c].style.backgroundColor='white';
      }
      row.parentNode.parentNode.className=row.rowIndex;
      row.style.backgroundColor='#f9b781';
}
function eliminarRegistroTabla(tabla)
  {
      var table=document.getElementById(tabla);
      if(parseInt(table.className)>0)
      {
          if(confirm('Esta seguro de eliminar el registro?'))
          {
               table.deleteRow(parseInt(table.className));
               table.className=0;
          }
      }
      else
      {
        alert('No selecciono ningun registro');
      }

  }


function redondeo2decimales(numero)
{
        var original=parseFloat(numero);
        var result=Math.round(original*100)/100 ;
        return result;
}
function calcularHorasFilaInicio(input)
{
    calcularHorasFila(input,true);
}
function calcularHorasFilaFinal(input)
{
    calcularHorasFila(input,false);
}
function calcularHorasFila(input,horaInicio)
{
    var index=input.parentNode.cellIndex-(horaInicio?0:1);
     var fecha1=input.parentNode.parentNode.cells[index-1].getElementsByTagName('input')[0].value+' '+
                input.parentNode.parentNode.cells[index].getElementsByTagName('input')[0].value;
    var fecha2=input.parentNode.parentNode.cells[index-1].getElementsByTagName('input')[0].value+' '+
               input.parentNode.parentNode.cells[index+1].getElementsByTagName('input')[0].value;
    try
    {
          input.parentNode.parentNode.cells[index+2].getElementsByTagName('span')[0].innerHTML=getNumeroDehoras(fecha1,fecha2);
    }
    catch(e)
    {
        console.log('No existe el campo');
    }
}

function crearArrayTablaFechaHora(nombreTabla,indiceInicio)
{
    var data=new Array();
    var tabla=document.getElementById(nombreTabla);
    for(var i=indiceInicio;i<tabla.rows.length;i++)
    {
        if(validarSeleccionRegistro(tabla.rows[i].cells[0].getElementsByTagName("select")[0])&&
        validarFechaRegistro(tabla.rows[i].cells[1].getElementsByTagName("input")[0])&&
        validarHoraRegistro(tabla.rows[i].cells[2].getElementsByTagName("input")[0])&&
        validarHoraRegistro(tabla.rows[i].cells[3].getElementsByTagName("input")[0])&&
        validarRegistrosHorasNoNegativas(tabla.rows[i].cells[2].getElementsByTagName("input")[0], tabla.rows[i].cells[3].getElementsByTagName("input")[0])&&
        validarRegistroEntero(tabla.rows[i].cells[5].getElementsByTagName("input")[0]))
        {
            data[data.length]=tabla.rows[i].cells[0].getElementsByTagName("select")[0].value;
            data[data.length]=tabla.rows[i].cells[1].getElementsByTagName("input")[0].value;
            data[data.length]=tabla.rows[i].cells[2].getElementsByTagName("input")[0].value;
            data[data.length]=tabla.rows[i].cells[3].getElementsByTagName("input")[0].value;
            data[data.length]=parseFloat(tabla.rows[i].cells[4].getElementsByTagName("span")[0].innerHTML);
            data[data.length]=tabla.rows[i].cells[5].getElementsByTagName("input")[0].value;
        }
        else
        {
            return null;
        }
    }
    return data;
}
