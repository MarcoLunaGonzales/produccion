
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
<%@ page language="java" import="java.util.*,com.cofar.util.CofarConnection" %>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../js/general.js"></script>
        <style>
            .outputTextNormal{
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 9px;
                font-weight: normal;
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
                <%--tr class="outputText2">
                   <td valign="top">
                       <b>Maquinarias : </b>
                   </td>
                   <td>
                       <%=nombreMaquinas.toLowerCase()%>
                    </td>
                </tr>
                <tr class="outputText2">
                   <td valign="top">
                       <b> Instalaciones : </b>
                   </td>
                   <td>
                       <%=nombreInstalaciones.toLowerCase()%>
                    </td>
                </tr--%>
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
            <table width="90%" align="center" class="outputTextNormal" style="border : solid #000000 1px;" cellpadding="0" cellspacing="0" >

                <tr class="">
                 
                    <td  class="border" style=" border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='20%' align="center"><b>Area</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='20%' align="center"><b>Solicitud</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='20%' align="center"><b>Nro O.T. </b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='15%' align="center" ><b>Maquinaria</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='15%' align="center" ><b>Instalacion</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='15%' align="center" ><b>Ambiente</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='15%' align="center" ><b>Tipo Solicitud Mantenimiento</b></td>
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
                    
					<td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%'  align="center"><b>Tipo <br>Hora</b></td>


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
                    String consulta="select ae.NOMBRE_AREA_EMPRESA,sm.COD_SOLICITUD_MANTENIMIENTO,ISNULL(m.NOMBRE_MAQUINA,'')as nombreMaquina,ISNULL(ai.NOMBRE_AREA_INSTALACION+'('+ae.NOMBRE_AREA_EMPRESA+')('+ai.CODIGO+')', '') as nombreAreaInst," +
                                    " ISNULL(p.COD_PERSONAL,0) as codPersonal,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRE_PILA) as nombrep,smdt.descripcion"+
                                    " ,ISNULL(pv.NOMBRE_PROVEEDOR,'') as nombreProveedor,smdt.FECHA_INICIAL,smdt.FECHA_FINAL" +
                                    " ,smdt.HORAS_HOMBRE,tt.NOMBRE_TIPO_TAREA,esm.NOMBRE_ESTADO_SOLICITUD,sm.FECHA_SOLICITUD_MANTENIMIENTO,sm.FECHA_APROBACION" +
                                    ",sm.NRO_ORDEN_TRABAJO,isnull(aid.NOMBRE_AREA_INSTALACION_DETALLE+'('+ae1.NOMBRE_AREA_EMPRESA+')('+aid.CODIGO+')','') as nombreAreaInstalacionDetalle" +
                                    " ,smdt.REGISTRO_HORAS_EXTRA,smdt.HORAS_EXTRA,tsm.NOMBRE_TIPO_SOLICITUD"+
                                    " from SOLICITUDES_MANTENIMIENTO sm inner join AREAS_EMPRESA ae on"+
                                    " ae.COD_AREA_EMPRESA=sm.COD_AREA_EMPRESA"+
                                    " left outer join TIPOS_SOLICITUD_MANTENIMIENTO tsm on tsm.COD_TIPO_SOLICITUD=sm.COD_TIPO_SOLICITUD_MANTENIMIENTO"+
                                    " inner join SOLICITUDES_MANTENIMIENTO_DETALLE_TAREAS smdt on "+
                                    " smdt.COD_SOLICITUD_MANTENIMIENTO=sm.COD_SOLICITUD_MANTENIMIENTO"+
                                    " inner join TIPOS_TAREA tt on tt.COD_TIPO_TAREA=smdt.COD_TIPO_TAREA" +
                                    " inner join ESTADOS_SOLICITUD_MANTENIMIENTO esm on esm.COD_ESTADO_SOLICITUD=sm.COD_ESTADO_SOLICITUD_MANTENIMIENTO"+
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
                    String tipoSolicitudManteniento="";
                    int contDetalle=0;
                    int contArea=0;
                    double sumaHoras=0;
                    double sumaHorasExtra=0;
                    double sumaHorasExtraTotal=0;
                    while(res.next())
                    {
                        if(!areaCabecera.equals(res.getString("NOMBRE_AREA_EMPRESA")))
                        {
                            if(!areaCabecera.equals(""))
                            {
                                if(!codSolicitudCabecera.equals(""))
                                    {
                                solicitud+="<tr>" +
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal' bgcolor='#FAFAD2' rowspan='"+contDetalle+"'>&nbsp;"+codSolicitudCabecera+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal' bgcolor='#90EE90' rowspan='"+contDetalle+"'>&nbsp;"+nroOrdenTrabajo+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal'rowspan='"+contDetalle+"'>&nbsp;"+nombreMaquina+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal' rowspan='"+contDetalle+"'>&nbsp;"+nombreInstalacion+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal' rowspan='"+contDetalle+"'>&nbsp;"+nombreAmbiente+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal' rowspan='"+contDetalle+"'>&nbsp;"+tipoSolicitudManteniento+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal' rowspan='"+contDetalle+"'>&nbsp;"+fechaSolicitud+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal' rowspan='"+contDetalle+"'>&nbsp;"+fechaAprobacion+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal' rowspan='"+contDetalle+"'>&nbsp;"+nombreEstadoSolicitud+"</th>";
                                     }
                               area+="<tr><th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal' rowspan='"+contArea+"'>&nbsp;"+areaCabecera+"</th>"+solicitud+(contArea>0?detalle:"");
                               area+="<tr bgcolor='#f2f2f2'><th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal' colspan='17' align='right'><b>Sub Total:   </b></th>" +
                                     "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal'  align='right'><b>"+nf.format(sumaHoras)+"</b></th>" +
                                     "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal'  align='right'><b>"+nf.format(sumaHorasExtra)+"</b></th></tr>";
                               sumaTotal+=sumaHoras;
                               sumaHorasExtraTotal+=sumaHorasExtra;
                               sumaHoras=0;
                               sumaHorasExtra=0;
                            }
                            solicitud="";
                           detalle="<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal'>&nbsp;"+res.getString("NOMBRE_TIPO_TAREA")+"</th>" +
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal'>&nbsp;"+(res.getInt("codPersonal")>0?res.getString("nombrep"):"")+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal'>&nbsp;"+(res.getString("descripcion"))+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal'>&nbsp;"+res.getString("nombreProveedor")+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal'>&nbsp;"+sdf.format(res.getTimestamp("FECHA_INICIAL"))+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal'>&nbsp;"+sdf.format(res.getTimestamp("FECHA_FINAL"))+"</th>"+
											"<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal'>&nbsp;"+(res.getInt("REGISTRO_HORAS_EXTRA")>0?"HE":"HO")+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal'>&nbsp;"+nf.format(res.getDouble("HORAS_HOMBRE"))+"</th>"+
                                            
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal'>&nbsp;"+nf.format(res.getDouble("HORAS_EXTRA"))+"</th>"+
                                            "</tr>";
                                    sumaHoras+=res.getDouble("HORAS_HOMBRE");
                                    sumaHorasExtra+=res.getDouble("HORAS_EXTRA");
                                    contDetalle=1;
                                    codSolicitudCabecera=res.getString("COD_SOLICITUD_MANTENIMIENTO");
                                    tipoSolicitudManteniento=res.getString("NOMBRE_TIPO_SOLICITUD");
                                    nombreInstalacion=res.getString("nombreAreaInst");
                                    nombreAmbiente=res.getString("nombreAreaInstalacionDetalle");
                                    nombreMaquina=res.getString("nombreMaquina");
                                    nombreEstadoSolicitud=res.getString("NOMBRE_ESTADO_SOLICITUD");
                                    fechaSolicitud=sdf.format(res.getTimestamp("FECHA_SOLICITUD_MANTENIMIENTO"));
                                    fechaAprobacion=res.getTimestamp("FECHA_APROBACION")!=null?sdf.format(res.getTimestamp("FECHA_APROBACION")):"";
                                    nroOrdenTrabajo=res.getInt("NRO_ORDEN_TRABAJO")>0?res.getString("NRO_ORDEN_TRABAJO"):"";
                            areaCabecera=res.getString("NOMBRE_AREA_EMPRESA");
                            contArea=2;
                            codSolicitudCabecera=res.getString("COD_SOLICITUD_MANTENIMIENTO");
                        }
                        else
                        {
                            
                            if(!codSolicitudCabecera.equals(res.getString("COD_SOLICITUD_MANTENIMIENTO")))
                            {
                                
                                    if(!codSolicitudCabecera.equals(""))
                                    {
                                        solicitud+="<tr>" +
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal' bgcolor='#FAFAD2' rowspan='"+contDetalle+"'>&nbsp;"+codSolicitudCabecera+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal' bgcolor='#90EE90' rowspan='"+contDetalle+"'>&nbsp;"+nroOrdenTrabajo+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal'rowspan='"+contDetalle+"'>&nbsp;"+nombreMaquina+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal' rowspan='"+contDetalle+"'>&nbsp;"+nombreInstalacion+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal' rowspan='"+contDetalle+"'>&nbsp;"+nombreAmbiente+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal' rowspan='"+contDetalle+"'>&nbsp;"+tipoSolicitudManteniento+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal' rowspan='"+contDetalle+"'>&nbsp;"+fechaSolicitud+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal' rowspan='"+contDetalle+"'>&nbsp;"+fechaAprobacion+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal' rowspan='"+contDetalle+"'>&nbsp;"+nombreEstadoSolicitud+"</th>"+detalle;
                                            
                                    }
                                    detalle="<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal'>&nbsp;"+res.getString("NOMBRE_TIPO_TAREA")+"</th>" +
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal'>&nbsp;"+(res.getInt("codPersonal")>0?res.getString("nombrep"):"")+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal'>&nbsp;"+(res.getString("descripcion"))+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal'>&nbsp;"+res.getString("nombreProveedor")+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal'>&nbsp;"+sdf.format(res.getTimestamp("FECHA_INICIAL"))+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal'>&nbsp;"+sdf.format(res.getTimestamp("FECHA_FINAL"))+"</th>"+
											"<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal'>&nbsp;"+(res.getInt("REGISTRO_HORAS_EXTRA")>0?"HE":"HO")+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal'>&nbsp;"+nf.format(res.getDouble("HORAS_HOMBRE"))+"</th>"+
                                            
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal'>&nbsp;"+nf.format(res.getDouble("HORAS_EXTRA"))+"</th>"+
                                            "</tr>";
                                    sumaHoras+=res.getDouble("HORAS_HOMBRE");
                                    sumaHorasExtra+=res.getDouble("HORAS_EXTRA");
                                    contDetalle=1;
                                    tipoSolicitudManteniento=res.getString("NOMBRE_TIPO_SOLICITUD");
                                    codSolicitudCabecera=res.getString("COD_SOLICITUD_MANTENIMIENTO");
                                    nombreInstalacion=res.getString("nombreAreaInst");
                                    nombreAmbiente=res.getString("nombreAreaInstalacionDetalle");
                                    nombreMaquina=res.getString("nombreMaquina");
                                    nombreEstadoSolicitud=res.getString("NOMBRE_ESTADO_SOLICITUD");
                                    fechaSolicitud=sdf.format(res.getTimestamp("FECHA_SOLICITUD_MANTENIMIENTO"));
                                    fechaAprobacion=res.getTimestamp("FECHA_APROBACION")!=null?sdf.format(res.getTimestamp("FECHA_APROBACION")):"";
                                    nroOrdenTrabajo=res.getInt("NRO_ORDEN_TRABAJO")>0?res.getString("NRO_ORDEN_TRABAJO"):"";
                            }
                            else
                            {
                                detalle+="<tr><th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal'>&nbsp;"+res.getString("NOMBRE_TIPO_TAREA")+"</th>" +
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal'>&nbsp;"+(res.getInt("codPersonal")>0?res.getString("nombrep"):"")+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal'>&nbsp;"+(res.getString("descripcion"))+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal'>&nbsp;"+res.getString("nombreProveedor")+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal'>&nbsp;"+sdf.format(res.getTimestamp("FECHA_INICIAL"))+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal'>&nbsp;"+sdf.format(res.getTimestamp("FECHA_FINAL"))+"</th>"+
											"<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal'>&nbsp;"+(res.getInt("REGISTRO_HORAS_EXTRA")>0?"HE":"HO")+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal'>&nbsp;"+nf.format(res.getDouble("HORAS_HOMBRE"))+"</th>"+
                                            
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal'>&nbsp;"+nf.format(res.getDouble("HORAS_EXTRA"))+"</th>"+
                                            "</tr>";
                                sumaHoras+=res.getDouble("HORAS_HOMBRE");
                                sumaHorasExtra+=res.getDouble("HORAS_EXTRA");
                                contDetalle++;
                            }
                            contArea++;
                        }
                     }
                     if(!areaCabecera.equals(""))
                            {
                                if(!codSolicitudCabecera.equals(""))
                                    {
                                solicitud+="<tr>" +
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal' bgcolor='#FAFAD2' rowspan='"+contDetalle+"'>"+codSolicitudCabecera+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal' bgcolor='#90EE90' rowspan='"+contDetalle+"'>"+nroOrdenTrabajo+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal'rowspan='"+contDetalle+"'>"+nombreMaquina+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal' rowspan='"+contDetalle+"'>"+nombreInstalacion+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal' rowspan='"+contDetalle+"'>"+nombreAmbiente+"</th>"+
                                        "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal' rowspan='"+contDetalle+"'>&nbsp;"+tipoSolicitudManteniento+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal' rowspan='"+contDetalle+"'>"+fechaSolicitud+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal' rowspan='"+contDetalle+"'>"+fechaAprobacion+"</th>"+
                                            "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal' rowspan='"+contDetalle+"'>"+nombreEstadoSolicitud+"</th>";
                                     }
                               area+="<tr><th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal' rowspan='"+contArea+"'>"+areaCabecera+"</th>"+solicitud+(contArea>0?detalle:"");
                               area+="<tr bgcolor='#f2f2f2'><th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal' colspan='17' align='right'><b>Sub Total:   </b></th>" +
                                     "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal'  align='right'><b>"+nf.format(sumaHoras)+"</b></th>" +
                                     "<th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal'  align='right'><b>"+nf.format(sumaHorasExtra)+"</b></th></tr>";
                               }
                    sumaTotal+=sumaHoras;
                    sumaHorasExtraTotal+=sumaHorasExtra;
                    area+="<tr bgcolor='#f2f2f2'><th class='outputText2' style='border : solid #D8D8D8 1px;font-weight:normal' colspan='17' align='right'><b>Total: </b></th>" +
                                     "<th class='outputText2' style='padding:0.2em; border : solid #D8D8D8 1px;font-weight:normal' align='right'><b>"+nf.format(sumaTotal)+"</b></th>" +
                                     "<th class='outputText2' style='padding:0.2em;border : solid #D8D8D8 1px;font-weight:normal' align='right'><b>"+nf.format(sumaHorasExtraTotal)+"</b></th></tr>";
                    out.println(area);
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