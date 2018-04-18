<%@ page contentType="application/vnd.ms-excel"%>

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
<%@ page language="java" import="java.util.*,com.cofar.util.CofarConnection" %>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <style>
            .tablaReporte
            {
                font-family: Verdana, Arial, Helvetica, sans-serif;
                border-left:1px solid #bbbbbb;
                border-top:1px solid #bbbbbb;
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 11px;
            }
            .tablaReporte tr td
            {
                border-bottom:1px solid #bbbbbb;
                border-right:1px solid #bbbbbb;
                padding: 0.6em;
            }
            .tablaReporte thead tr td
            {
                font-weight: bold;
                background-color:#dddddd;
            }
        </style>
        
    </head>
    <body>
        <%

            Connection con = null;
             String codMaquinas=request.getParameter("codMaquinariaArray");
             String codAreaEmpresa=request.getParameter("codAreaArray");
             String codInstalaciones=request.getParameter("codInstalacionArray");
             String nombreMaquinas=request.getParameter("nombreMaquinariaArray");
             String nombreAreasEmpresa=request.getParameter("nombreAreaArray");
             String nombreInstalaciones=request.getParameter("nombreInstalacionArray");
             String fechaInicio=request.getParameter("fecha_inicioSol");
             String fechaFinal=request.getParameter("fecha_finalSol");
             String codEstado=request.getParameter("codEstadoArray");
             String nombreEstado=request.getParameter("nombreEstadoArray");
             boolean todasAreas=(request.getParameter("todoArea").equals("1"));
             boolean todosEstados=(request.getParameter("todoEstado").equals("1"));
             boolean todasMaquinas=(request.getParameter("todoMaquinaria").equals("1"));
             boolean todasInstalaciones=(request.getParameter("todoInstalacion").equals("1"));

             String[] arrayFechaInicio=fechaInicio.split("/");
             String[] arrayfechaFinal=fechaFinal.split("/");
             String fechaInicioformato=arrayFechaInicio[2]+"/"+arrayFechaInicio[1]+"/"+arrayFechaInicio[0]+" 00:00:00";
             String fechaFinalFormato=arrayfechaFinal[2]+"/"+arrayfechaFinal[1]+"/"+arrayfechaFinal[0]+" 23:59:59";
             System.out.println("datos maquina "+codMaquinas+" cod area "+codAreaEmpresa+"codInstalacion"+codInstalaciones+"fecha inicio"+fechaInicioformato+"fecha final"+fechaFinalFormato);
             try
               {
            %>
        <form>

           <center> <b>Reporte Detalle de Ordenes de Trabajo</b></center>

            <table align="center" width="90%" class='outputText0'>
                <tr class="outputText2">
                    <th rowspan="6" width="10%">
                        <img src="../../img/cofar.png">
                    </th>
                    <td valign="top">
                       <b> AreasEmpresa : </b>
                    </td>
                    <td>
                        <%=nombreAreasEmpresa.toLowerCase()%>
                    </td>
                </tr>
                <tr class="outputText2">
                   <td valign="top">
                       <b>Estados Solicitud: </b>
                   </td>
                   <td>
                       <%=nombreEstado %>
                    </td>
                </tr>
                
                <tr class="outputText2">
                   <td valign="top">
                       <b> De fecha de Seguimiento Personal : </b>
                   </td>
                   <td>
                       <%=fechaInicio%>
                    </td>
                </tr>
                <tr class="outputText2">
                   <td>
                        <b>A fecha de Seguimiento Personal : </b>
                   </td>
                   <td>
                       <%=fechaFinal%>
                    </td>
                </tr>
           </table>
            <br>
            <table width="90%" align="center" class="tablaReporte" style="border : solid #000000 1px;" cellpadding="0" cellspacing="0" >

                <tr class="">
                 
                    <td  class="border" style=" border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='20%' align="center"><b>Area</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='20%' align="center"><b>Solicitud</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='20%' align="center"><b>Nro O.T. </b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='15%' align="center" ><b>Maquinaria</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='15%' align="center" ><b>Instalacion</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='15%' align="center" ><b>Ambiente</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='15%' align="center" ><b>Tipo Mantenimiento</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='15%' align="center" ><b>Fecha Solicitud</b></td>
                  
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center"><b>Fecha aprobación</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Estado</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center"><b>Tipo Tarea</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='15%' align="center"><b>Personal</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='15%' align="center"><b>Descripcion</b></td>
                    
                   
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Proovedor</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Fecha Inicio</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Fecha Final</b></td>
					<td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%'  align="center"><b>Tipo <br>Hora</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Horas Hombre</b></td>
                    
					<td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%'  align="center"><b>Horas Extra</b></td>


                </tr>
                <%
                    con=Util.openConnection(con);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy HH:mm");
                    NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                    DecimalFormat format = (DecimalFormat)nf;
                    double sumaTotal=0d;
                    format.applyPattern("#,##0.00");
                    System.out.println("cod area "+codAreaEmpresa+" cod maq "+codMaquinas+" ins "+codInstalaciones+" codestad "+codEstado);
                    String consulta="select ae.NOMBRE_AREA_EMPRESA,sm.COD_SOLICITUD_MANTENIMIENTO,ISNULL(m.NOMBRE_MAQUINA,'')as nombreMaquina,ISNULL(ai.NOMBRE_AREA_INSTALACION+'('+ae.NOMBRE_AREA_EMPRESA+')('+ai.CODIGO+')', '') as nombreAreaInst,"+
                                    " ISNULL(p.COD_PERSONAL,0) as codPersonal,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRE_PILA) as nombrep,smdt.descripcion"+
                                    " ,ISNULL(pv.NOMBRE_PROVEEDOR,'') as nombreProveedor,smdt.FECHA_INICIAL,smdt.FECHA_FINAL" +
                                    " ,smdt.HORAS_HOMBRE,tt.NOMBRE_TIPO_TAREA,esm.NOMBRE_ESTADO_SOLICITUD,sm.FECHA_SOLICITUD_MANTENIMIENTO,sm.FECHA_APROBACION" +
                                    ",sm.NRO_ORDEN_TRABAJO,isnull(aid.NOMBRE_AREA_INSTALACION_DETALLE+'('+ae1.NOMBRE_AREA_EMPRESA+')('+aid.CODIGO+')','') as nombreAreaInstalacionDetalle" +
                                    " ,smdt.REGISTRO_HORAS_EXTRA,smdt.HORAS_EXTRA,tsm.NOMBRE_TIPO_SOLICITUD"+
                                    " from SOLICITUDES_MANTENIMIENTO sm inner join AREAS_EMPRESA ae on"+
                                    " ae.COD_AREA_EMPRESA=sm.COD_AREA_EMPRESA"+
                                    " inner join SOLICITUDES_MANTENIMIENTO_DETALLE_TAREAS smdt on "+
                                    " smdt.COD_SOLICITUD_MANTENIMIENTO=sm.COD_SOLICITUD_MANTENIMIENTO"+
                                    " inner join TIPOS_TAREA tt on tt.COD_TIPO_TAREA=smdt.COD_TIPO_TAREA" +
                                    " inner join ESTADOS_SOLICITUD_MANTENIMIENTO esm on esm.COD_ESTADO_SOLICITUD=sm.COD_ESTADO_SOLICITUD_MANTENIMIENTO"+
                                    " left outer join TIPOS_SOLICITUD_MANTENIMIENTO tsm on tsm.COD_TIPO_SOLICITUD=sm.COD_TIPO_SOLICITUD_MANTENIMIENTO"+
                                    " left outer join personal p on p.COD_PERSONAL=smdt.COD_PERSONAL"+
                                    " left outer join PROVEEDORES pv on pv.COD_PROVEEDOR=smdt.COD_PROVEEDOR"+
                                    " left outer join maquinarias m on m.COD_MAQUINA=sm.COD_MAQUINARIA"+
                                    " left outer join AREAS_INSTALACIONES ai on ai.COD_AREA_INSTALACION=sm.COD_AREA_INSTALACION" +
                                    " left outer join AREAS_INSTALACIONES_DETALLE aid on"+
                                    " aid.COD_AREA_INSTALACION=sm.COD_AREA_INSTALACION and "+
                                    " aid.COD_AREA_INSTALACION_DETALLE=sm.COD_AREA_INSTALACION_DETALLE"+
                                    " left outer join AREAS_EMPRESA ae1 on ae1.COD_AREA_EMPRESA=aid.COD_AREA_EMPRESA"+
                                    " where smdt.FECHA_INICIAL BETWEEN '"+fechaInicioformato+"' and '"+fechaFinalFormato+"'"+
                                    " and smdt.FECHA_FINAL BETWEEN '"+fechaInicioformato+"' and '"+fechaFinalFormato+"'"+
                                    ((!codAreaEmpresa.equals("")&&!todasAreas)?" and sm.COD_AREA_EMPRESA in ("+codAreaEmpresa+")":"") +
                                    (!codMaquinas.equals("")?(!codInstalaciones.equals("")?" and (sm.COD_MAQUINARIA in ("+codMaquinas+") or sm.COD_AREA_INSTALACION in ("+codInstalaciones+"))":
                                     "and sm.COD_MAQUINARIA in ("+codMaquinas+") "):(!codInstalaciones.equals("")?" and sm.COD_AREA_INSTALACION in ("+codInstalaciones+")":""))+
                                    
                                    /*" and (sm.COD_MAQUINARIA in ("++") "+
                                    " or sm.COD_AREA_INSTALACION in ("++"))"+*/
                                    (!codEstado.equals("")?" and sm.COD_ESTADO_SOLICITUD_MANTENIMIENTO in ("+codEstado+")":"")+
                                    " order by ae.NOMBRE_AREA_EMPRESA,sm.COD_SOLICITUD_MANTENIMIENTO,smdt.FECHA_INICIAL,smdt.FECHA_FINAL";
                    System.out.println("consulta reporte "+consulta);
                    ResultSet res=st.executeQuery(consulta);
                    String codSolicitudCabecera="";
                    String nombreMaquina="";
                    String nombreInstalacion="";
                    String nombreAmbiente="";
                    String nombreEstadoSolicitud="";
                    String detalle="";
                    String solicitud="";
                    String area="";
                    String fechaAprobacion="";
                    String fechaSolicitud="";
                    String nroOrdenTrabajo="";
                    String areaCabecera="";
                    int contDetalle=0;
                    int contArea=0;
                    double sumaHoras=0;
                    double sumaHorasExtra=0;
                    double sumaHorasExtraTotal=0;
                    while(res.next())
                    {
                        out.println("<tr>");
                            out.println("<td>"+res.getString("NOMBRE_AREA_EMPRESA")+"</td>");
                            out.println("<td>"+res.getInt("NRO_ORDEN_TRABAJO")+"</td>");
                            out.println("<td>"+res.getInt("COD_SOLICITUD_MANTENIMIENTO")+"</td>");
                            out.println("<td>"+res.getString("nombreMaquina")+"</td>");
                            out.println("<td>"+res.getString("nombreAreaInst")+"</td>");
                            out.println("<td>"+res.getString("nombreAreaInstalacionDetalle")+"</td>");
                            out.println("<td>"+res.getString("NOMBRE_TIPO_SOLICITUD")+"</td>");
                            out.println("<td>"+sdf.format(res.getTimestamp("FECHA_SOLICITUD_MANTENIMIENTO"))+"</td>");
                            out.println("<td>"+(res.getTimestamp("FECHA_APROBACION")==null?"":sdf.format(res.getTimestamp("FECHA_APROBACION")))+"</td>");
                            out.println("<td>"+res.getString("NOMBRE_ESTADO_SOLICITUD")+"&nbsp;</td>");
                            out.println("<td>"+res.getString("NOMBRE_TIPO_TAREA")+"&nbsp;</td>");
                            out.println("<td>"+res.getString("nombrep")+"</td>");
                            out.println("<td>"+res.getString("descripcion")+"</td>");
                            out.println("<td>"+res.getString("nombreProveedor")+"</td>");
                            out.println("<td>"+(res.getTimestamp("FECHA_INICIAL")==null?"":sdf.format(res.getTimestamp("FECHA_INICIAL")))+"</td>");
                            out.println("<td>"+(res.getTimestamp("FECHA_FINAL")==null?"":sdf.format(res.getTimestamp("FECHA_FINAL")))+"</td>");
                            out.println("<td>"+(res.getInt("REGISTRO_HORAS_EXTRA")>0?"HE":"HO")+"</td>");
                            out.println("<td>"+nf.format(res.getDouble("HORAS_HOMBRE"))+"</td>");
                            out.println("<td>"+nf.format(res.getDouble("HORAS_EXTRA"))+"</td>");
                        out.println("</tr>");
                    }
                    res.close();
                    st.close();
                    con.close();
                }
                catch(Exception ex)
                     {
                 ex.printStackTrace();

             }
                %>

               </table>

              
            <br>

            <br>
            <div align="center">
                <%--<INPUT type="button" class="commandButton" name="btn_registrar" value="<-- Atrás" onClick="cancelar();"  >--%>

            </div>
        </form>
    </body>
</html>