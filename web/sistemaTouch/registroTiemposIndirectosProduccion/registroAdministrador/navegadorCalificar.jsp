package sistemaTouch.registroTiemposIndirectosProduccion.registroAdministrador;

<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.sql.Statement"%>
<%@ page import="com.cofar.util.*" %>
<%@ page language="java" import="java.util.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../reponse/css/foundation.css" />
            <link rel="STYLESHEET" type="text/css" href="../../reponse/css/AtlasWeb.css" />
            <style>
                span
                {
                    font-size:1.2em !important;
                }
                span:hover
                {
                    font-size:1.4em;
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
        <body>
            
            <form>
             
                <section class="main" style="margin-top:1em;width:100%;">
                     <div class="large-6 medium-9 small-12 large-centered medium-centered small-centered columns" >

                        <div class="row">
                           <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                   <label  class="inline" style="margin:0px;">Asignacion de Tareas<br>Por Actividad</label>
                                   
                            </div>
                        </div>
                        <div class="row">
                        <div  class="divContentClass large-12 medium-12 small-12 columns ">
                            <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns">
                                <table style="border:none;width:100%;margin-top:4px;" id="dataControlDosificado" cellpadding="0px" cellspacing="0px">


                              <%
                              String codAreaEmpresa="81";
                              try
                              {
                                  Connection con=null;
                                  con=Util.openConnection(con);
                                  Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                  
                                  String consulta="select pap.COD_PERSONAL from PERSONAL_AREA_PRODUCCION pap where pap.COD_AREA_EMPRESA in ("+codAreaEmpresa+")";
                                           System.out.println("consuta cargar personal area "+consulta);
                                  ResultSet res=st.executeQuery(consulta);
                                  String personal="";
                                  while(res.next())
                                  {
                                        personal+=(personal.equals("")?"":",")+res.getString("COD_PERSONAL");
                                  }
                                  consulta="select a.COD_ACTIVIDAD,ap.NOMBRE_ACTIVIDAD,p.COD_PERSONAL,"+
                                            " (p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal) as nombrePersonal,"+
                                            " isnull(tid.COD_PERSONAL,0) as registrado"+
                                           " from ACTIVIDADES_PROGRAMA_PRODUCCION_INDIRECTO a inner join ACTIVIDADES_PRODUCCION ap on"+
                                           " a.COD_ACTIVIDAD=ap.COD_ACTIVIDAD"+
                                           " full outer join PERSONAL p on 1=1"+
                                           " left outer join TAREAS_INDIRECTAS_DIA tid on tid.cod_personal=p.COD_PERSONAL and"+
                                           " tid.cod_actividad=a.COD_ACTIVIDAD"+
                                           " where a.COD_AREA_EMPRESA in ("+codAreaEmpresa+") and p.cod_personal in ("+personal+")"+
                                           " order by p.COD_PERSONAL,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL,p.nombre2_personal,a.ORDEN,a.COD_ACTIVIDAD";
                                    System.out.println("consulta cargar areas tareas personal "+consulta);
                                    res=st.executeQuery(consulta);
                                    int codPersonalCabecera=0;
                                    String nombreActividad="";
                                    String personaltarea="";
                                    String tabla="";
                                    String actividadesIndirectas="";
                                    while(res.next())
                                    {
                                        if(codPersonalCabecera!=res.getInt("COD_PERSONAL"))
                                        {
                                            if(codPersonalCabecera>0)
                                            {
                                                actividadesIndirectas+=(actividadesIndirectas.equals("")?"":",")+"tarea"+codPersonalCabecera;
                                                out.println("<script type='text/javascript'>var tarea"+codPersonalCabecera+"=new tareaOM("+codPersonalCabecera+",'"+nombreActividad+"','formsuper');tarea"+codPersonalCabecera+".crearPersonal('"+personaltarea+"');</script>");
                                                out.println("<tr><td><div class='borderPanelRoundGreen' onclick='tarea"+
                                                            codPersonalCabecera+".asociarPersonal();'><div class='large-12 medium-12 small-12 columns divHeaderRoundGreen' ><span>"+nombreActividad+"<span></div><div id='detalleTareaScriptOM"+codPersonalCabecera+"'>" +
                                                            "<center><table style='width:90%;' class='tablaPersonalTarea' cellpadding='0px' cellspacing='0px'>"+tabla+"</table></center></div></div></td></tr>");
                                            }
                                            codPersonalCabecera=res.getInt("COD_PERSONAL");
                                            nombreActividad=res.getString("NOMBRE_ACTIVIDAD");
                                            personaltarea="";
                                            tabla="";
                                        }
                                        if(res.getInt("registrado")>0)
                                        {
                                            tabla+="<tr><td><center><span>"+res.getString("nombrePersonal")+"</span><center></td></tr>";
                                        }
                                        personaltarea+=(personaltarea.equals("")?"":",")+res.getInt("COD_PERSONAL")+","+res.getString("nombrePersonal")+","+res.getInt("registrado");

                                    }
                                    if(codPersonalCabecera>0)
                                    {
                                        actividadesIndirectas+=(actividadesIndirectas.equals("")?"":",")+"tarea"+codPersonalCabecera;
                                        out.println("<script type='text/javascript'>var tarea"+codPersonalCabecera+"=new tareaOM("+codPersonalCabecera+",'"+nombreActividad+"','formsuper');tarea"+codPersonalCabecera+".crearPersonal('"+personaltarea+"');</script>");
                                        out.println("<tr><td><div class='borderPanelRoundGreen' onclick='tarea"+
                                                    codPersonalCabecera+".asociarPersonal();'><div class='large-12 medium-12 small-12 columns divHeaderRoundGreen' ><span>"+nombreActividad+"<span></div><div id='detalleTareaScriptOM"+codPersonalCabecera+"'>" +
                                                    "<center><table style='width:90%;' class='tablaPersonalTarea' cellpadding='0px' cellspacing='0px'>"+tabla+"</table></center></div></div></td></tr>");
                                    }
                                }
                               catch(SQLException ex)
                               {
                                   ex.printStackTrace();
                               }
                                %>
                              </table>

                            </div>
                         </div>
                     </div>
                 </div>
                </section>
               
            </form>

        </body>
    </html>
</f:view>


