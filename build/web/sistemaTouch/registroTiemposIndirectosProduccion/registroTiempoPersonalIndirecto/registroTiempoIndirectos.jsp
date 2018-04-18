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

<script src="../../reponse/js/utiles.js"></script>
<script src="../../reponse/js/componentesJs.js"></script>
<script src="../../reponse/js/scriptIndirectos.js"></script>
<script src="../../reponse/js/websql.js"></script>


<script type="text/javascript">
   
    function cancelar()
    {
        window.location.href='navegadorActividadesIndirectas.jsf?ca='+(window.parent.codAreaEmpresaIndirecta)+'&p='+(window.parent.codPersonalIndirecta)+'&canace='+(new Date()).getTime().toString();
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
                                   <td class="tableHeaderClass prim"  style="text-align:center;">
                                       <span class="textHeaderClass">Fecha</span>
                                   </td>
                                   <td class="tableHeaderClass" style="text-align:center">
                                       <span class="textHeaderClass">Hora Inicio</span>
                                   </td>
                                   <td class="tableHeaderClass ult" style="text-align:center">
                                       <span class="textHeaderClass ult">Hora Final</span>
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
                                                "</tr>");
                                }
                              
                              %>
                        </table>
                        <div class="row" style="margin-top:0px;">
                            <div class="large-6 small-8 medium-10 large-centered medium-centered columns">
                                <div class="row">
                                    <div class="large-6 medium-6 small-12 columns">
                                        <button class="small button succes radius buttonIniciar" style="visibility:<%=(noMostrarIniciar?"hidden":"visible")%>" onclick="iniciarTiempoIndirectoOperario(this,'dataTiemposIndirectos')" >Iniciar</button>
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
    
       
        <input type="hidden" id="codActividad" value="<%=(codActividad)%>"/>
      
    
     </section>
    
    </body>
    
</html>
