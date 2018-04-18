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
<%@page import="java.lang.Math" %>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.GregorianCalendar"%>
<%@ page language="java" import = "org.joda.time.*"%>
<%@ page language="java" import="java.util.*,com.cofar.util.CofarConnection" %>



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
   <head>
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/foundation.css" />
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/AtlasWeb.css" />
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/timePickerCSs.css" />
<script src="../../reponse/js/variables.js"></script>
<script src="../../reponse/js/utiles.js"></script>
<script src="../../reponse/js/componentesJs.js"></script>
<script src="../../reponse/js/scriptIndirectos.js"></script>
<script src="../../reponse/js/websql.js"></script>


<script type="text/javascript">
   
    function cancelar()
    {
        window.location.href='navegadorActividadesIndirectas.jsf?ca='+(this.parent.codAreaEmpresaIndirecta)+'&canace='+(new Date()).getTime().toString();
    }
    onerror=errorMessaje;
    function errorMessaje()
    {
        alert('error de javascript');
    }
    function guardarSeguimientoIndirectoAdmin()
        {
            var tabla=document.getElementById("dataTiemposIndirectos");
            var dataTiempos=new Array()
            for(var i=1;i<tabla.rows.length;i++)
            {
                dataTiempos[dataTiempos.length]=tabla.rows[i].cells[0].getElementsByTagName("select")[0].value;
                dataTiempos[dataTiempos.length]=tabla.rows[i].cells[1].getElementsByTagName("input")[0].value;
                dataTiempos[dataTiempos.length]=tabla.rows[i].cells[2].getElementsByTagName("input")[0].value;
                dataTiempos[dataTiempos.length]=tabla.rows[i].cells[3].getElementsByTagName("input")[0].value;
                dataTiempos[dataTiempos.length]=tabla.rows[i].cells[4].getElementsByTagName("span")[0].innerHTML;
                dataTiempos[dataTiempos.length]=(tabla.rows[i].cells[3].getElementsByTagName("button").length>0?(tabla.rows[i].cells[3].getElementsByTagName("button")[0].className=='buttonFinishActive'?1:0):1);
            }
            window.parent.bloquearIndirectos();
            var peticion="ajaxGuardarTiemposIndirectos.jsf?"+
                         "codProgProd="+window.parent.codProgramaProdIndirecta+
                         "&codAreaEmpresa="+window.parent.codAreaEmpresaIndirecta+
                         "&codActividad="+document.getElementById("codActividad").value+
                         "&dataTiempos="+dataTiempos+
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
                            window.parent.desBloquearIndirectos();
                            return false;
                        }
                        if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                        {
                            window.parent.desBloquearIndirectos();
                            window.parent.mensajeJs("Se registraron los tiempos",function()
                            {
                                cancelar();
                            })
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
    
   
</script>


</head>
    <body  >
        

  <%
        String codProgramaProd=request.getParameter("cp");
        String codPersonal=request.getParameter("p");
        String codAreaEmpresa=request.getParameter("ca");
        String codActividad=request.getParameter("codActividad");
        String nombreActividad="";
        //formato de fecha y hora
        SimpleDateFormat sdfHoras=new SimpleDateFormat("HH:mm");
        SimpleDateFormat sdfDias=new SimpleDateFormat("dd/MM/yyyy");
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat format = (DecimalFormat)nf;
        format.applyPattern("#,##0.00");
        
        try
        {
             Connection con=null;
             con=Util.openConnection(con);
             Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
             String consulta="select  ap.COD_ACTIVIDAD,ap.NOMBRE_ACTIVIDAD from ACTIVIDADES_PRODUCCION ap where ap.COD_ACTIVIDAD='"+codActividad+"'";
             System.out.println("consulta cargar indirecta "+consulta);
             ResultSet res=st.executeQuery(consulta);
             if(res.next())
             {
                  nombreActividad=res.getString("NOMBRE_ACTIVIDAD");
             }
                        %>

<section class="main">
                        




<div class="row"  style="margin-top:5px" >
            <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                        <div class="row">
                           <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                   <label  class="inline"><%=(nombreActividad)%></label>
                                   
                            </div>
                        </div>
                        <div class="row" >

                        <div  class="divContentClass large-12 medium-12 small-12 columns" style="padding-top:12px;">
                       
                        <table style="width:100%;margin-top:8px" id="dataTiemposIndirectos" cellpadding="0px" cellspacing="0px">
                              <tr>
                                   <td class="tableHeaderClass prim"  style="text-align:center;">
                                       <span class="textHeaderClass">Personal</span>
                                   </td>
                                   <td class="tableHeaderClass"  style="text-align:center;">
                                       <span class="textHeaderClass">Fecha</span>
                                   </td>
                                   <td class="tableHeaderClass" style="text-align:center">
                                       <span class="textHeaderClass">Hora Inicio</span>
                                   </td>
                                   <td class="tableHeaderClass" style="text-align:center">
                                       <span class="textHeaderClass ult">Hora Final</span>
                                   </td>
                                   <td class="tableHeaderClass ult" style="text-align:center">
                                       <span class="textHeaderClass ult">Horas Hombre</span>
                                   </td>
                               </tr>
                              <%
                              String personalSelect=UtilidadesTablet.operariosAreaProduccionSelect(st, codAreaEmpresa);
                              out.println("<script type='text/javascript'>" +
                                          "fechaSistemaGeneral='"+sdfDias.format(new Date())+"';" +
                                          "operariosRegistroGeneral=\""+personalSelect+"\";</script>");
                              consulta="select s.COD_PERSONAL,s.FECHA_INICIO,s.FECHA_FINAL,s.HORAS_HOMBRE,s.REGISTRO_CERRADO"+
                                       " from SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO_PERSONAL s where s.COD_PROGRAMA_PROD='"+codProgramaProd+"'"+
                                       " and s.COD_AREA_EMPRESA='"+codAreaEmpresa+"' and s.COD_ACTVIDAD='"+codActividad+"'" +
                                       " order by s.FECHA_INICIO";
                              System.out.println("consulta cargar tiempos indirectos "+consulta);
                              res=st.executeQuery(consulta);
                              boolean noMostrarIniciar=false;
                              while(res.next())
                              {
                                    noMostrarIniciar=(noMostrarIniciar||(res.getInt("REGISTRO_CERRADO")==0));
                                    out.println("<tr onclick='seleccionarFila(this)' >" +
                                                "<td class='tableCell' align='center'>" +
                                                "<select id='personaInd"+res.getRow()+"'>"+personalSelect+"</select>" +
                                                "<script>personaInd"+res.getRow()+".value="+res.getInt("COD_PERSONAL")+";</script>" +
                                                "</td>"+
                                                "<td class='tableCell' align='center'>" +
                                                "<input onclick='seleccionarDatePickerJs(this);' id='fechaReg"+res.getRow()+"' type='tel' value='"+sdfDias.format(res.getTimestamp("FECHA_INICIO"))+"'/></td>" +
                                                " <td class='tableCell'  align='center'>" +
                                                "<input type='tel' onfocus='calcularHorasFilaInicio(this)' style='width:6em;' onclick='seleccionarHora(this);' id='horaInic"+res.getRow()+"' value='"+sdfHoras.format(res.getTimestamp("FECHA_INICIO"))+"'/>"+
                                                " </td>" +
                                                "<td class='tableCell' align='center' >" +
                                                "<input onfocus='calcularHorasFilaFinal(this)' onclick='seleccionarHora(this);'  id='horaFin"+res.getRow()+"' style='width:6em;display:"+(res.getInt("REGISTRO_CERRADO")>0?"table-cell":"none")+"' type='tel' value='"+sdfHoras.format(res.getTimestamp("FECHA_FINAL"))+"'/>"+
                                                "<button class='"+(res.getInt("REGISTRO_CERRADO")>0?"buttonFinishActive":"buttonFinish")+"' onclick=\"terminarTiempoIndirectoAdmin(this,'"+sdfHoras.format(res.getTimestamp("FECHA_INICIO"))+"')\">Terminar</button>"+
                                                
                                                "</td>" +
                                                "<td class='tableCell' align='center' >" +
                                                "<span class='textHeaderClassBody' style='font-weight:normal'>"+nf.format(res.getDouble("HORAS_HOMBRE"))+"</span>"+
                                                "</td>" +
                                                "</tr>");
                                }
                              
                              %>
                        </table>
                        <div class="row" style="margin-top:0px;">
                            <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                              <div class="large-1 medium-1 small-2 columns">
                                  <button  class="small button succes radius buttonMas" onclick="componentesJs.crearRegistroTablaFecha('dataTiemposIndirectos')">+</button>
                              </div>
                              <div class="large-1 medium-1 small-2 columns">
                                    <button  class="small button succes radius buttonMenos" onclick="eliminarRegistroTabla('dataTiemposIndirectos');">-</button>
                              </div>
                              <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                        </div>
                        <div class="row" style="margin-top:0px;">
                            <div class="large-6 small-8 medium-10 large-centered medium-centered columns">
                                <div class="row">
                                     <div class="large-6 medium-6 small-12 columns">
                                        <button class="small button succes radius buttonAction"  onclick="guardarSeguimientoIndirectoAdmin()" >Guardar</button>
                                    </div>
                                    <div class="large-6 medium-6 small-12  columns">
                                        <button class="small button succes radius buttonAction" onclick="cancelar()" >Cancelar</button>

                                    </div>
                                </div>
                            </div>
                    </div>
                <%
                    
                }
                catch(SQLException ex)
                {
                    ex.printStackTrace();
                }
                
                %>
                    
                    
                    

                </div>
            </div>
    </div>
    </div>
        <script src="../../reponse/js/timePickerJs.js"></script>
        <script src="../../reponse/js/dataPickerJs.js"></script>
        <script>iniciarDatePicker('<%=(sdfDias.format(new Date()))%>');</script>
       
        <input type="hidden" id="codActividad" value="<%=(codActividad)%>"/>
      
    
     </section>
    
    </body>
    
</html>
