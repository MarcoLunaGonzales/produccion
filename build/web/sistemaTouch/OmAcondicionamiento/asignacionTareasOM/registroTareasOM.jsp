<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.Connection"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.sql.Statement"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.text.SimpleDateFormat"%>
<%@ page import = "java.util.ArrayList"%>
<%@ page import = "java.util.Date"%>
<%@ page import = "javax.servlet.http.HttpServletRequest"%>
<%@ page import = "java.text.DecimalFormat"%>
<%@ page import = "java.text.NumberFormat"%>
<%@ page import = "java.util.Locale"%>
<%@ page import="java.lang.Math" %>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.GregorianCalendar"%>
<%@ page language="java" import = "org.joda.time.*"%>
<%@ page language="java" import="java.util.*,com.cofar.util.CofarConnection" %>



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
   <head>
      <style>
          .d{
              cursor:crosshair
          }
      </style>

<script src="../../reponse/js/scripts.js"></script>
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/foundation.css" />
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/AtlasWeb.css" />

<link rel="STYLESHEET" type="text/css" href="../../reponse/css/border-radius.css" />
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/jscal2.css" />
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/gold.css" />
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/timePickerCSs.css" />
<script src="../../reponse/js/jscal2.js"></script>
<script src="../../reponse/js/en.js"></script>
<script src="../../reponse/js/websql.js"></script>
<style>
    .bold
    {
        font-weight:bold;
        font-family: 'Arial';
        font-size:12px;
        font-style:normal;

    }
    .normal
    {
        font-weight:400;
        font-family: 'Arial';
        font-size:12px;
        font-style:normal;

    }
    .tablaBuscar tr td
    {
        text-align:center;
        border-bottom:solid #a80077 1px;
    }
    .tablaBuscar tr:last-child td:first-child
    {
        border-bottom-left-radius:10px;
    }
    .tablaBuscar tr:last-child td:last-child
    {
        border-bottom-right-radius:10px;
    }
    .tablaBuscar tr td:first-child
    {
        border-left:solid #a80077 1px;
    }
    .tablaBuscar tr td:last-child
    {
        border-right:solid #a80077 1px;
    }
    .tablaBuscar tr:hover
    {
        background: #cc18cc; /* Old browsers */
        background: -moz-linear-gradient(top,  #cc18cc 0%, #d383cc 50%, #bc2da9 100%); /* FF3.6+ */
        background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#cc18cc), color-stop(50%,#d383cc), color-stop(100%,#bc2da9)); /* Chrome,Safari4+ */
        background: -webkit-linear-gradient(top,  #cc18cc 0%,#d383cc 50%,#bc2da9 100%); /* Chrome10+,Safari5.1+ */
        background: -o-linear-gradient(top,  #cc18cc 0%,#d383cc 50%,#bc2da9 100%); /* Opera 11.10+ */
        background: -ms-linear-gradient(top,  #cc18cc 0%,#d383cc 50%,#bc2da9 100%); /* IE10+ */
        background: linear-gradient(to bottom,  #cc18cc 0%,#d383cc 50%,#bc2da9 100%); /* W3C */
        filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#cc18cc', endColorstr='#bc2da9',GradientType=0 ); /* IE6-9 */
        color:white;
        cursor:pointer;
    }
    .tablaBuscar tr:hover td span
    {
        color:white;
        font-size:1.2em;
    }
</style>
<script type="text/javascript">
   function personal(idPersonal,nombrePersonal,seleccionado)
   {
       this.nombrePersonal=nombrePersonal;
       this.idPersonal=idPersonal;
       this.seleccionado=seleccionado;
       this.seleccionPersonal=function()
       {
            this.seleccionado=!this.seleccionado;
       }
       this.className=function()
       {
           return (this.seleccionado?"divPersonalSelect":"divPersonalNotSelect");
       }
       this.setSeleccionado=function(estado)
       {
           this.seleccionado=estado;
       }
   }
   function tareaOM(codTareaOM,nombreTareaOM,idModal)
   {
       this.codTareaOM=codTareaOM;
       this.nombreTareaOM=nombreTareaOM;
       this.idModal=idModal;
       this.personal=[];
       this.scriptPersonalSeleccionado=function()
       {
           var script="";
           for(var i=0;i<this.personal.length;i++)
           {
               if(this.personal[i].seleccionado)
               {script+=(script==""?"":",")+this.codTareaOM+","+this.personal[i].idPersonal;}
           }
           return script;
       }
       this.seleccionarTodos=function(estado)
       {
          
           if((this.codTareaOM==3||this.codTareaOM==17)&&estado&&this.personal.length>1)
           {
                alert('No puede seleccionar mas una persona para la recepcion');
           }
           else
           {
               for(var i=0;i<this.personal.length;i++)
               {
                   this.personal[i].setSeleccionado(estado);
                   document.getElementById("personalScript"+i).className=(this.personal[i].className());
               }
           }
       }
       this.seleccionPersonal=function(index)
       {
           if(this.codTareaOM==3||this.codTareaOM==17)
           {
               var cont=0;
               for(var i=0;i<this.personal.length;i++)
               {
                   if(this.personal[i].seleccionado&&i!=index)cont++;
               }
               if(cont>0)
                {
                    alert('No puede seleccionar mas una persona para la recepcion');
                }
                else
                {
                    this.personal[index].seleccionPersonal();
                    document.getElementById("personalScript"+index).className=(this.personal[index].className());
                }
                
           }
           else
           {
                this.personal[index].seleccionPersonal();
                document.getElementById("personalScript"+index).className=(this.personal[index].className());
           }
       }
       this.crearPersonal=function(stringpersonal)
       {
           var arrayPersonal=stringpersonal.split(",");
           for(var i=0;i<arrayPersonal.length;i+=3)
           {
               
                this.personal[this.personal.length]=new personal(arrayPersonal[i],arrayPersonal[i+1],(parseInt(arrayPersonal[i+2])>0));
           }
       }
       this.asociarPersonalScript=function(codPersonal)
       {
            for(var i=0;i<this.personal.length;i++)
            {
                
                if(this.personal[i].idPersonal==codPersonal)
                {
                    this.personal[i].setSeleccionado(true);
                }
            }
       }
       this.asociarPersonal=function()
       {
           document.getElementById(idModal).style.visibility='visible';
           document.getElementById("divPersonal").className="panelRegistroVisible";
           document.getElementById("tareaOmScript").innerHTML=this.nombreTareaOM;
           document.getElementById("todosJsScript").className='divButtonPersonalSelect';
           document.getElementById("ningunoJsScript").className='divButtonPersonalNotSelect';
           document.getElementById("todosJsScript").innerHTML="<img onclick='tarea"+this.codTareaOM.toString()+".seleccionarTodos(true);' style='cursor:pointer;height:1.2em;width:1.2em' src='../../reponse/img/checkbox.png' id='imgTodosPersonal' /><span onclick='tarea"+this.codTareaOM.toString()+".seleccionarTodos(true);' id='spanTodosPersonal' style='cursor:pointer;font-size:0.8em;color:black'>Todos</span>";
           document.getElementById("ningunoJsScript").innerHTML="<img onclick='tarea"+this.codTareaOM.toString()+".seleccionarTodos(false);' style='cursor:pointer;height:1.2em;width:1.2em' src='../../reponse/img/uncheck.png' id='imgNingunoPersonal'/><span onclick='tarea"+this.codTareaOM.toString()+".seleccionarTodos(false);' id='spanNingunoPersonal' style='cursor:pointer;font-size:0.8em;color:black'>Ninguno</span>"
           document.getElementById("buttonRegisterJscript").innerHTML=
           " <button class='small button succes radius buttonAction' onclick='tarea"+this.codTareaOM+".terminarAsociar()'>Aceptar</button>";
           var innerHTMLJscript="<center><table style='width:90%;' cellpadding='0px' cellspacing='0px'>";//<tr><td class='large-12 medium-12 small-12 columns divHeaderClass'><label class='inline'>PERSONAL</span></td></tr>
           for(var i=0;i<this.personal.length;i++)
           {
               innerHTMLJscript+="<tr><td><div onclick='tarea"+this.codTareaOM+".seleccionPersonal("+i+")' id='personalScript"+i+"'"+
                                "class='"+this.personal[i].className()+"'><span>"+this.personal[i].nombrePersonal+"</span></div></td></tr>";
           }
               innerHTMLJscript+="</table></center>";
           document.getElementById("contentPersonaljScript1213").innerHTML=innerHTMLJscript;
           
       }
       this.refrescar=function(hideModal)
       {
           if(hideModal)
           {
               document.getElementById(idModal).style.visibility='hidden';
               document.getElementById("divPersonal").className="panelModalHide";
           }
           var divTabla=document.getElementById("detalleTareaScriptOM"+this.codTareaOM);
           var innerHTMLOM="<center><table style='width:90%;' class='tablaPersonalTarea' cellpadding='0px' cellspacing='0px'>";
           for(var i=0;i<this.personal.length;i++)
           {
               innerHTMLOM+=(this.personal[i].seleccionado?"<tr><td><center><span>"+this.personal[i].nombrePersonal+"</span><center></td></tr>":"");
           }
           innerHTMLOM+="</table></center>";
           divTabla.innerHTML=innerHTMLOM;
       }
       this.terminarAsociar=function()
       {
           this.refrescar(true);
       }
       
   }
   var tareasOMScriptValue="";
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
    function resetearTareasOM()
    {
        var arrayOM=tareasOMScriptValue.split(",");
        for(var i=0;i<arrayOM.length;i++)
        {
            console.log(arrayOM[i]);
            var lista=eval(arrayOM[i]+".personal");
             for(var j=0;j<lista.length;j++)
               {
                   lista[j].setSeleccionado(false);
               }
        }
    }
    function actualizarTareasOM()
    {
        var arrayOM=tareasOMScriptValue.split(",");
        for(var i=0;i<arrayOM.length;i++)
        {
            var lista=eval(arrayOM[i]+".terminarAsociar()");
            
        }
    }
    function guardarTareasOM()
    {
        document.getElementById("formsuper").style.visibility='visible';
        var arrayOM=tareasOMScriptValue.split(",");
        var dataTareas="";
        var aux="";
        for(var i=0;i<arrayOM.length;i++)
        {
            aux=eval(arrayOM[i]+".scriptPersonalSeleccionado()");
            if(aux!='')
            {dataTareas+=(dataTareas==""?"":",")+aux;}
        }
        var peticion="ajaxGuardarTareasOM.jsf?codLote="+document.getElementById("codLoteSeguimiento").value+
            "&codProgramaProd="+document.getElementById("codProgramaProd").value+
            "&codMat="+Math.random()+
            "&personalAsignar="+dataTareas;

        var ajax=nuevoAjax();
         ajax.open("GET",peticion,true);
         ajax.onreadystatechange=function(){
            if (ajax.readyState==4) {
                if(ajax.responseText==null || ajax.responseText=='')
                {
                    alert('No se puede conectar con el servidor, verfique su conexión a internet');
                    /* if(confirm("Desea guardar la informacion localmente?\nLa informacion del lote no se perdera pero debe de subirla despues"))
                    {
                        sqlConnection.insertarRegistroAuxiliar(codProgramaProd,codLote,2,("../registroRepesada/"+peticion),function(){window.close();});
                    }*/
                    document.getElementById('formsuper').style.visibility='hidden';
                    
                    return false;
                }
                if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                {
                    alert('Se registraron las tareas');
                    
                    window.close();
                    return true;
                }
                else
                {
                    document.getElementById("formsuper").style.visibility='hidden';
                    alert(ajax.responseText.split("\n").join(""));
                    return false;
                }
            }
        }

        ajax.send(null);
    }
    function iniciarCopiarTareas()
    {
       document.getElementById("formsuper").style.visibility='visible';
       document.getElementById("divPersonal").className="panelRegistroVisible";
       document.getElementById("tareaOmScript").innerHTML="COPIAR TAREAS OM";
       document.getElementById("todosJsScript").className='';
       document.getElementById("ningunoJsScript").className='';
       document.getElementById("todosJsScript").style.display='table-cell';
       document.getElementById("ningunoJsScript").style.display='table-cell';
       document.getElementById("todosJsScript").innerHTML="<span style='cursor:pointer;font-size:1em;color:white;'>Lote:</span><input value='' style='display:table-cell !important;width:8em;padding:0.2em !important;height:1.8em !important' type='tel' id='codLoteCopia'/>";
       document.getElementById("ningunoJsScript").innerHTML="<button style='width:6em !important;' class='small button succes radius buttonAction' onclick='buscarLoteCopiar()'>BUSCAR</button>"
       document.getElementById("buttonRegisterJscript").innerHTML=
       " <button class='small button succes radius buttonAction' onclick='tarea"+this.codTareaOM+".terminarAsociar()'>Aceptar</button>";
       document.getElementById("contentPersonaljScript1213").innerHTML="<center><table style='width:95%;margin-bottom:0px;' cellpadding='0px' cellspacing='0px'><tr>"+
           "<td class='tableHeaderClass' style='border-top-left-radius: 10px;width:7em !important'><span class='textHeaderClass'>Lote</span></td>"+
           "<td class='tableHeaderClass' style='width:10em !important'><span class='textHeaderClass'>Programa<br>Produccion</span></td>"+
           "<td class='tableHeaderClass' style='border-top-right-radius: 10px;'><span class='textHeaderClass' >Producto</span></td>"+
           "</tr></table><div style='height:20em !important;overflow:auto;width:100%' id='contentLoteBuscar'></div></center>";
       //
    }
    function buscarLoteCopiar()
    {
        var peticion="ajaxBuscarLoteDuplicar.jsf?codLote="+document.getElementById("codLoteCopia").value+
            "&codForma="+document.getElementById("codForma").value+
            "&codMat="+Math.random()+
            "&daT="+(new Date()).getTime.toString();

        var ajax=nuevoAjax();
         ajax.open("GET",peticion,true);
         ajax.onreadystatechange=function(){
            if (ajax.readyState==4) {
                if(ajax.responseText==null || ajax.responseText=='')
                {
                    alert('No se puede conectar con el servidor, verfique su conexión a internet');
                
                }
                else
                {
                    document.getElementById("contentLoteBuscar").innerHTML=ajax.responseText;
                }
                
                
            }
        }

        ajax.send(null);
    }
    function copiarTareasDesde(codLote,codProgramaProd)
    {
        var peticion="ajaxCopiarTareasOM.jsf?codLote="+codLote+"&codProgramaProd="+codProgramaProd+
            "&codMat="+Math.random()+
            "&daT="+(new Date()).getTime.toString();

         var ajax=nuevoAjax();
         ajax.open("GET",peticion,true);
         ajax.onreadystatechange=function(){
            if (ajax.readyState==4) {
                if(ajax.responseText==null || ajax.responseText=='')
                {
                    alert('No se puede conectar con el servidor, verfique su conexión a internet');

                }
                else
                {
                    resetearTareasOM();
                    console.log(ajax.responseText);
                    eval(ajax.responseText);
                    actualizarTareasOM();
                    document.getElementById("formsuper").style.visibility='hidden';
                    document.getElementById("divPersonal").className="panelModalHide";
                }


            }
        }
        ajax.send(null);
        
    }
    function iniciarAsignacion(variables)
    {
        tareasOMScriptValue=variables;
         var divRegistro=document.createElement("div");
         divRegistro.className='panelModalHide';
         divRegistro.id='divPersonal';
         divRegistro.innerHTML="<div class='large-6 medium-8 small-12 large-centered medium-centered small-centered columns'><div class='panelPersonal'><div style='width:100%;text-right;' class='divHeaderRound'>"+
                               "<center><span id='tareaOmScript' style='line-height:1.4em'>Ninguni</span>"+
                               "<div id='todosJsScript' class=''><img style='cursor:pointer;height:1.2em;width:1.2em' src='../../reponse/img/checkbox.png' id='imgTodosPersonal' /><span id='spanTodosPersonal' style='cursor:pointer;font-size:0.8em'>Todos</span></div>"+
                               "<div id='ningunoJsScript' class='' ><img style='height:1.2em;width:1.2em' src='../../reponse/img/uncheck.png' id='imgNingunoPersonal'/><span id='spanNingunoPersonal' style='cursor:pointer;font-size:0.8em'>Ninguno</span></div></center></div>"+
                               "<div id='contentPersonaljScript1213' style='height:24em;overflow:auto;margin-top:1em'></div>"+
                               " <div class='row' style='margin-top:0px;'>"+
                               " <div class='large-6 medium-6 small-12 small-centered medium-centered large-centered columns' style='margin-top:1em;' id='buttonRegisterJscript'>"+
                               " </div></div>"+
                               "</div></div>";
         document.body.appendChild(divRegistro);
         document.getElementById("buttonGuardarTareas").onclick=function(){guardarTareasOM();}
    }
    
</script>


</head>
    <body >
        <div style="margin-top:2%;position:fixed;;width:100%;z-index:5;visibility:hidden" id="divImagen">
         <center><img src="../../reponse/img/load2.gif"  style="z-index:6; "><%--margin-top:2%;position:fixed;--%>
         </center>
         </div>
      
  <%
        String codLote=request.getParameter("codLote");
        out.println("<title>("+codLote+")ASIGNACION DE TAREAS</title>");
        String codprogramaProd=request.getParameter("cod_prog");
        String nombreComponente="as";
        String nombreAreaEmpresa="as";
        String codForma="";
        int codAreaEmpresa=0;
        Date fechaRegistro=new Date();
        String operarios="";
        String conControlLlenadoLote="";
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat format = (DecimalFormat)nf;
        SimpleDateFormat sdfDias=new SimpleDateFormat("dd/MM/yyyy");
        SimpleDateFormat sdfHora=new SimpleDateFormat("HH:mm");
        format.applyPattern("#,##0.00");
        int codActivadEnvasado=0;
        int codSeguimientoControlDosificado=0;
        int codPersonalSupervisor=0;
        String observaciones="";
        int codCompProd=0;
        int codFormulaMaestra=0;
        int codTipoProduccion=0;
        String tareasOM="";
                try
                {
                    Connection con=null;
                    con=Util.openConnection(con);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    String consulta="select pp.COD_TIPO_PROGRAMA_PROD, pp.COD_COMPPROD,cp.COD_FORMA,p.nombre_prod,f.abreviatura_forma,cp.nombre_prod_semiterminado,"+
                                    " cp.NOMBRE_GENERICO,f.nombre_forma,cp.REG_SANITARIO,ep.nombre_envaseprim,cp.VIDA_UTIL,"+
                                    " pp.CANT_LOTE_PRODUCCION,ppp.FECHA_FINAL,pp.COD_FORMULA_MAESTRA,ISNULL(cp.VOLUMEN_ENVASE_PRIMARIO, '') as VOLUMEN_ENVASE_PRIMARIO"+
                                    " ,cp.COD_AREA_EMPRESA"+
                                    " from PROGRAMA_PRODUCCION pp inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = pp.COD_COMPPROD"+
                                    " inner join FORMAS_FARMACEUTICAS f on f.cod_forma = cp.COD_FORMA"+
                                    " inner join productos p on p.cod_prod = cp.COD_PROD"+
                                    " inner join PRESENTACIONES_PRIMARIAS ppm on ppm.COD_COMPPROD ="+
                                    " cp.COD_COMPPROD and ppm.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                                    " inner join ENVASES_PRIMARIOS ep on ep.cod_envaseprim = ppm.COD_ENVASEPRIM"+
                                    " inner join PROGRAMA_PRODUCCION_PERIODO ppp on pp.COD_PROGRAMA_PROD = ppp.COD_PROGRAMA_PROD"+
                                    " where pp.COD_LOTE_PRODUCCION = '"+codLote+"' and pp.COD_PROGRAMA_PROD = '"+codprogramaProd+"'";
                    System.out.println("consulta cargar datos del lote "+consulta);
                    ResultSet res=st.executeQuery(consulta);
                    int cantidadAmpollas=0;
                    String nombreProducto="";
                    String registroSanitario="";
                    String volumen="";
                    
                    
                    
                    char b=13;char c=10;
                    
                    if(res.next())
                    {
                        codAreaEmpresa=res.getInt("COD_AREA_EMPRESA");
                        codCompProd=res.getInt("COD_COMPPROD");
                        codTipoProduccion=res.getInt("COD_TIPO_PROGRAMA_PROD");
                        codFormulaMaestra=res.getInt("COD_FORMULA_MAESTRA");
                        volumen=res.getString("VOLUMEN_ENVASE_PRIMARIO");
                        nombreProducto=res.getString("nombre_prod");
                        codForma=res.getString("COD_FORMA");
                        cantidadAmpollas=res.getInt("CANT_LOTE_PRODUCCION");
                        registroSanitario=res.getString("REG_SANITARIO");
                        %>

<section class="main">
                         <div class="row"  style="margin-top:5px" >
                                <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                                            <div class="row">
                                               <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                                       <label  class="inline">ASIGNACION DE TAREAS</label>
                                                </div>
                                            </div>
                                            <div class="row" >
                                                
                                            <div  class="divContentClass large-12 medium-12 small-12 columns">
                                                  
                                                   <table style="width:96%;margin-top:2%" cellpadding="0px" cellspacing="0px">
                                                       <tr >
                                                           <td class="tableHeaderClass" style="text-align:center">
                                                               <span class="textHeaderClass">Lote</span>
                                                           </td>
                                                           <td class="tableHeaderClass" style="text-align:center;">
                                                               <span class="textHeaderClass">Tam. Lote</span>
                                                           </td>
                                                           <td class="tableHeaderClass" style="text-align:center">
                                                               <span class="textHeaderClass">Producto</span>
                                                           </td>
                                                           <td class="tableHeaderClass" style="text-align:center">
                                                               <span class="textHeaderClass">Forma Farmaceútica</span>
                                                           </td>
                                                           <td class="tableHeaderClass" style="text-align:center">
                                                               <span class="textHeaderClass">Presentación</span>
                                                           </td>
                                                       </tr>
                                                       
                                                       <tr >
                                                           <td class="tableCell" style="text-align:center">
                                                               <span class="textHeaderClassBody"><%=codLote%></span>
                                                           </td>
                                                           <td class="tableCell" style="text-align:center;">
                                                               <span class="textHeaderClassBody"><%=cantidadAmpollas%></span>
                                                           </td>
                                                           <td class="tableCell" style="text-align:center">
                                                               <span class="textHeaderClassBody"><%=res.getString("nombre_prod_semiterminado")%></span>
                                                           </td>
                                                           <td class="tableCell" style="text-align:center">
                                                               <span class="textHeaderClassBody"><%=res.getString("nombre_forma")%></span>
                                                           </td>
                                                           <td class="tableCell" style="text-align:center">
                                                               <span class="textHeaderClassBody"><%=res.getString("nombre_envaseprim")%></span>
                                                           </td>
                                                       </tr>
                                                       </table>
                                                   
                                                    
                                             </div>
                                             </div>
                                         </div>
                            </div>




<div class="row"  style="margin-top:5px" >
            <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                        <div class="row">
                           <div class="large-12 medium-12 small-12 columns divHeaderClass" style="text-align:center;">
                                   <label  class="inline"  style="margin-bottom:0.1em !important;padding:0.5em !important">ASIGNACION DE TAREAS</label>
                                   <button class="small button succes radius buttonAction" onclick="iniciarCopiarTareas();" style="margin-bottom:0.1em;width:11em !important">Copiar Tareas</button>
                            </div>
                            
                        </div>
                        <div class="row" >

                        <div  class="divContentClass large-12 medium-12 small-12 columns" style="padding-top:12px;">
                       
                              <%
                              }
                                
                               
                                      %>
                       
                        <div class="row">
                            <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns">
                                <table style="border:none;width:100%;margin-top:4px;" id="dataControlDosificado" cellpadding="0px" cellspacing="0px">
                                
                                                 
                              <%
                              consulta=" select P.COD_PERSONAL,(P.AP_PATERNO_PERSONAL + ' ' + P.AP_MATERNO_PERSONAL + ' ' +P.NOMBRES_PERSONAL + ' ' + P.nombre2_personal) NOMBRES_PERSONAL"+
                                       " from personal P inner join PERSONAL_AREA_PRODUCCION pa on pa.COD_PERSONAL = p.COD_PERSONAL"+
                                       " where pa.cod_area_empresa in (102) AND p.COD_ESTADO_PERSONA = 1 union"+
                                       " select P.COD_PERSONAL,(P.AP_PATERNO_PERSONAL + ' ' + P.AP_MATERNO_PERSONAL + ' ' +P.NOMBRES_PERSONAL + ' ' + P.nombre2_personal) NOMBRES_PERSONAL"+
                                       " from personal p inner join usuarios_modulos  u on u.cod_personal=p.cod_personal where p.cod_area_empresa in (102) and p.COD_ESTADO_PERSONA = 1 order by NOMBRES_PERSONAL ";
                                       System.out.println("consuta cargar personal area "+consulta);
                                        res=st.executeQuery(consulta);
                                        String personal="";
                                        int sumaCantidad=0;
                                        while(res.next())
                                        {
                                            personal+=(personal.equals("")?"":",")+res.getString("COD_PERSONAL");
                                        }
                                out.println("<script>operariosRegistro=\""+personal+"\";fechaNuevoRegistro='"+sdfDias.format(new Date())+"'</script>");
                                consulta="SELECT tm.COD_TAREA_OM,tm.NOMBRE_TAREA_OM,p.COD_PERSONAL,"+
                                        " (p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal) as nombrePersonal,"+
                                        " isnull(tom.COD_PERSONAL,0) as registrado"+
                                        " FROM TAREAS_OM tm FULL OUTER JOIN PERSONAL p on 1=1"+
                                        " left outer join TAREAS_OM_PERSONAL_LOTE tom on tom.COD_PERSONAL=p.COD_PERSONAL"+
                                        " and tm.COD_TAREA_OM=tom.COD_TAREA_OM "+
                                        " and tom.COD_LOTE='"+codLote+"' and tom.COD_PROGRAMA_PROD='"+codprogramaProd+"'"+
                                        " where tm.COD_FORMA in (0,"+codForma+") and tm.cod_seccion=1 and p.COD_PERSONAL in ("+(personal.equals("")?"-1,-2":personal)+")"+
                                        " and (tm.COD_TIPO_PROGRAMA_PROD=0 or tm.COD_TIPO_PROGRAMA_PROD in ("+
                                        " SELECT pp.COD_TIPO_PROGRAMA_PROD FROM PROGRAMA_PRODUCCION pp  where pp.COD_PROGRAMA_PROD='"+codprogramaProd+"'" +
                                        " and pp.COD_LOTE_PRODUCCION='"+codLote+"'))"+
                                        " order by tm.ORDEN,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL,p.nombre2_personal";
                                System.out.println("consulta cargar areas tareas personal "+consulta);
                                res=st.executeQuery(consulta);
                                int codcabeceraTarea=0;
                                String nombreTarea="";
                                String personaltarea="";
                                String tabla="";
                                while(res.next())
                                {
                                    if(codcabeceraTarea!=res.getInt("COD_TAREA_OM"))
                                    {
                                        if(codcabeceraTarea>0)
                                        {
                                            tareasOM+=(tareasOM.equals("")?"":",")+"tarea"+codcabeceraTarea;
                                            out.println("<script type='text/javascript'>var tarea"+codcabeceraTarea+"=new tareaOM("+codcabeceraTarea+",'"+nombreTarea+"','formsuper');tarea"+codcabeceraTarea+".crearPersonal('"+personaltarea+"');</script>");
                                            out.println("<tr><td><div class='borderPanelRound' onclick='tarea"+
                                                        codcabeceraTarea+".asociarPersonal();'><div class='large-12 medium-12 small-12 columns divHeaderRound' ><span>"+nombreTarea+"<span></div><div id='detalleTareaScriptOM"+codcabeceraTarea+"'>" +
                                                        "<center><table style='width:90%;' class='tablaPersonalTarea' cellpadding='0px' cellspacing='0px'>"+tabla+"</table></center></div></div></td></tr>");
                                        }
                                        codcabeceraTarea=res.getInt("COD_TAREA_OM");
                                        nombreTarea=res.getString("NOMBRE_TAREA_OM");
                                        personaltarea="";
                                        tabla="";
                                    }
                                    if(res.getInt("registrado")>0)
                                    {
                                        tabla+="<tr><td><center><span>"+res.getString("nombrePersonal")+"</span><center></td></tr>";
                                    }
                                    personaltarea+=(personaltarea.equals("")?"":",")+res.getInt("COD_PERSONAL")+","+res.getString("nombrePersonal")+","+res.getInt("registrado");

                                }
                                if(codcabeceraTarea>0)
                                {
                                    tareasOM+=(tareasOM.equals("")?"":",")+"tarea"+codcabeceraTarea;
                                    out.println("<script type='text/javascript'>var tarea"+codcabeceraTarea+"=new tareaOM("+codcabeceraTarea+",'"+nombreTarea+"','formsuper');tarea"+codcabeceraTarea+".crearPersonal('"+personaltarea+"');</script>");
                                    out.println("<tr><td><div class='borderPanelRound' onclick='tarea"+
                                                codcabeceraTarea+".asociarPersonal();'><div class='large-12 medium-12 small-12 columns divHeaderRound' ><span>"+nombreTarea+"<span></div><div id='detalleTareaScriptOM"+codcabeceraTarea+"'>" +
                                                "<center><table style='width:90%;' class='tablaPersonalTarea' cellpadding='0px' cellspacing='0px'>"+tabla+"</table></center></div></div></td></tr>");
                                }
                                %>
                              </table>
                              
                            </div>
                        </div>
                        

                <%
                }
                catch(SQLException ex)
                {
                    ex.printStackTrace();
                }
                %>
                    <div class="row" style="margin-top:0px;">
                            <div class="large-6 small-8 medium-10 large-centered medium-centered columns">
                                <div class="row">
                                    <div class="large-6 medium-6 small-12 columns">
                                        <button class="small button succes radius buttonAction" id="buttonGuardarTareas" >Guardar</button>
                                    </div>
                                        <div class="large-6 medium-6 small-12  columns">
                                            <button class="small button succes radius buttonAction" onclick="window.close();" >Cancelar</button>

                                        </div>
                                </div>
                            </div>
                    </div>

                </div>
            </div>
    </div>
    </div>
    
    <div  id="formsuper"  style="
                padding: 50px;
                background-color: #cccccc;
                position:absolute;
                z-index: 1;
                left:0px;
                top: 0px;
                border :2px solid #3C8BDA;
                width:100%;
                height:100%;
                filter: alpha(opacity=70);
                visibility:hidden;
                opacity: 0.8;" >

          </div>
        <input type="hidden" id="codActivadEnvasado" value="<%=(codActivadEnvasado)%>">
        <input type="hidden" id="codLoteSeguimiento" value="<%=codLote%>">
        <input type="hidden" id="codProgramaProd" value="<%=codprogramaProd%>">
        <input type="hidden" id="codSeguimiento" value="<%=(codSeguimientoControlDosificado)%>">
        <input type="hidden" id="codFormulaMaestra" value="<%=(codFormulaMaestra)%>"/>
        <input type="hidden" id="codCompProd" value="<%=(codCompProd)%>"/>
        <input type="hidden" id="codTipoProduccion" value="<%=(codTipoProduccion)%>"/>
        <input type="hidden" id="codForma" value="<%=(codForma)%>"/>

        </section>
    </body>
    <script type="text/javascript">iniciarAsignacion('<%=(tareasOM)%>');</script>
</html>
