package sistemaTouch.registroTiemposIndirectosProduccion_1.registroTiempoPersonalIndirecto;

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
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/border-radius.css" />

<link rel="STYLESHEET" type="text/css" href="../../reponse/css/jscal2.css" />
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/gold.css" />
<script src="../../reponse/js/scriptIndirectos.js"></script>
<script src="../../reponse/js/jqueryMin.js"></script>
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/foundation.css" />
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/AtlasWeb.css" />
<link rel="STYLESHEET" type="text/css" href="../../reponse/css/timePickerCSs.css" />

<script src="../../reponse/js/websql.js"></script>

<style>
.hint {
            border-radius:0.3em;
            display:none;
            position: absolute;
            border: 1px solid #c93;
            padding: 10px 12px;
            margin-top: -8px;
            width: 200px;
            text-align:center;
             background: #ffc url(pointer.gif) no-repeat -10px 5px;
        }
.hint .hint-pointer
{
    -webkit-transform: rotate(90deg);
	-moz-transform: rotate(90deg);
    position: absolute;
    left:20px;
    top: -14px;
    width: 12px;
    height: 19px;
    background: url(pointer.gif) left top no-repeat;
}
</style>
<script type="text/javascript">
    function guardarRegistroIndirecto()
    {
        window.parent.bloquearIndirectos();
        var tablaIndirectos=document.getElementById("dataTiemposIndirectos");
        var dataIndirectos=new Array();
        if(!admin)
        {
                for(var j=1;j<tablaIndirectos.rows.length;j++)
                {
                    dataIndirectos[dataIndirectos.length]=tablaIndirectos.rows[j].cells[0].getElementsByTagName('span')[0].innerHTML;
                    dataIndirectos[dataIndirectos.length]=tablaIndirectos.rows[j].cells[1].getElementsByTagName('span')[0].innerHTML;
                    dataIndirectos[dataIndirectos.length]=tablaIndirectos.rows[j].cells[2].getElementsByTagName('span')[0].innerHTML;
                    dataIndirectos[dataIndirectos.length]=parseFloat(tablaIndirectos.rows[j].cells[3].getElementsByTagName('span')[0].innerHTML);
                    dataIndirectos[dataIndirectos.length]=(tablaIndirectos.rows[j].cells[2].getElementsByTagName('button')[0].className=='buttonFinishActive'?1:0);
                }
                
        }
        var peticion="ajaxGuardarTiemposIndirectos.jsf?noCache="+ Math.random()+
             "&codProgProd="+window.parent.codProgramaProdIndirecta+
             "&codAreaEmpresa="+window.parent.codAreaEmpresaIndirecta+
             "&codActividad="+document.getElementById("codActividad").value+
             "&codPersonal="+window.parent.codPersonalIndirecta+
             "&dataInd="+dataIndirectos;
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
                            alert('Se registraron los tiempos indirectos');
                            window.onbeforeunload=null;
                            window.parent.desBloquearIndirectos();
                            window.location.href='../navegadorActividadesIndirectas.jsf?ca='+(window.parent.codAreaEmpresaIndirecta)+'&data='+(new Date()).getTime().toString();
                            return true;
                        }
                        else
                        {
                            alert(ajax.responseText.split("\n").join(""));
                            window.parent.desBloquearIndirectos();
                            return false;
                        }
                    }
                }

                ajax.send(null);

    }
    function cancelar()
    {
        window.location.href='../navegadorActividadesIndirectas.jsf?ca='+(this.parent.codAreaEmpresaIndirecta)+'&canace='+(new Date()).getTime().toString();
    }
    onerror=errorMessaje;
    function errorMessaje()
    {
        alert('error de javascript');
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
        SimpleDateFormat sdfHoras=new SimpleDateFormat("HH:mm");
        SimpleDateFormat sdfDias=new SimpleDateFormat("dd/MM/yyyy");
        out.println("<script type='text/javascript'>fechaSistemaGeneral='"+sdfDias.format(new Date())+"'</script>");
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
                                   <td class="tableHeaderClass"  style="text-align:center;">
                                       <span class="textHeaderClass">Fecha</span>
                                   </td>
                                   <td class="tableHeaderClass" style="text-align:center">
                                       <span class="textHeaderClass">Hora Inicio</span>
                                   </td>
                                   <td class="tableHeaderClass" style="text-align:center">
                                       <span class="textHeaderClass">Hora Final</span>
                                   </td>
                                    <td class="tableHeaderClass" style="text-align:center">
                                       <span class="textHeaderClass">Horas Hombre</span>
                                   </td>
                               </tr>
                              <%
                              consulta="select s.COD_PERSONAL,s.FECHA_INICIO,s.FECHA_FINAL,s.HORAS_HOMBRE,s.REGISTRO_CERRADO"+
                                       " from SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO_PERSONAL s where s.COD_PROGRAMA_PROD='"+codProgramaProd+"'"+
                                       " and s.COD_AREA_EMPRESA='"+codAreaEmpresa+"' and s.COD_ACTVIDAD='"+codActividad+"'" +
                                       " and s.COD_PERSONAL='"+codPersonal+"' order by s.FECHA_INICIO";
                              System.out.println("consulta cargar tiempos indirectos "+consulta);
                              res=st.executeQuery(consulta);
                              boolean noMostrarIniciar=false;
                              while(res.next())
                              {
                                    noMostrarIniciar=(noMostrarIniciar||(res.getInt("REGISTRO_CERRADO")==0));
                                    out.println("<tr onclick='seleccionarFila(this)' >"+
                                                "<td class='tableCell' align='center'>" +
                                                "<span class='textHeaderClassBodyNormal'>"+sdfDias.format(res.getTimestamp("FECHA_INICIO"))+"</span></td>" +
                                                " <td class='tableCell'  align='center'>" +
                                                " <span class='textHeaderClassBodyNormal'>"+sdfHoras.format(res.getTimestamp("FECHA_INICIO"))+"</span>"+
                                                " </td>" +
                                                " <td class='tableCell' align='center' >" +
                                                "<button class='"+(res.getInt("REGISTRO_CERRADO")>0?"buttonFinishActive":"buttonFinish")+"' onclick=\"terminarTiempoIndirectos(this,'"+sdfHoras.format(res.getTimestamp("FECHA_INICIO"))+"')\">Terminar</button>"+
                                                "<span class='textHeaderClassBodyNormal'>"+sdfHoras.format(res.getTimestamp("FECHA_FINAL"))+"</span>"+
                                                "</td>" +
                                                " <td class='tableCell' style='text-align:center;' aling='center'><span class='textHeaderClassBody' style='font-weight:normal'>"+res.getDouble("HORAS_HOMBRE")+"</span></td>" +
                                                "</tr>");
                                }
                              
                              %>
                        </table>
                        <div class="row" style="margin-top:0px;">
                            <div class="large-6 small-8 medium-10 large-centered medium-centered columns">
                                <div class="row">
                                    <div class="large-6 medium-6 small-12 columns">
                                        <button class="small button succes radius buttonIniciar" style="visibility:<%=(noMostrarIniciar?"hidden":"visible")%>" onclick="iniciarTiempoOperario('dataTiemposIndirectos')" >Iniciar</button>
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
                    
                    <div class="row" style="margin-top:0px;">
                            <div class="large-6 small-8 medium-10 large-centered medium-centered columns">
                                <div class="row">
                                    <div class="large-6 medium-6 small-12 columns" align="center">
                                        <span class="hint" id="mensajeGuardar">
                                            Para guardar los cambios oprima guardar.
                                            <span class='hint-pointer'>&nbsp;</span>
                                        </span>
                                    </div>
                                        <div class="large-6 medium-6 small-12  columns">
                                            &nbsp;
                                        </div>
                                </div>
                            </div>
                    </div>
                    

                </div>
            </div>
    </div>
    </div>
    
       
        <input type="hidden" id="codActividad" value="<%=(codActividad)%>"/>
      
    
     </section>
    
    </body>
    
</html>
