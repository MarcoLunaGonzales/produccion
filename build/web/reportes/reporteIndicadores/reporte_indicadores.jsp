<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import = "java.util.Date"%> 
<%@ page import="com.cofar.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.List" %>
<%@ page import="org.joda.time.Duration" %>
<%@ page import="org.joda.time.Interval" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="org.joda.time.DateTime" %>
<%@ page import="javax.faces.model.SelectItem" %>
<%@ page import="com.cofar.bean.util.Personal" %>
<%@ page import="com.cofar.bean.util.DetallePermiso" %>
<%@ page import="com.cofar.service.impl.EmpresaServiceImpl" %>
<%@ page import="com.cofar.service.impl.EmpleadoServiceImpl" %>


<%--<%@ page contentType="application/vnd.ms-excel" %>--%>
<%--%@ page contentType="application/vnd.ms-excel" --%>


<%! Connection con = null;
    String CadenaAreas = "";
    String areasDependientes = "";
    String sw = "0";
%>
<%        con = CofarConnection.getConnectionJsp();
%>

<%!
%>
<%!
public double horasProduccion (Personal personal,Date fechaInicio,Date fechaFinal,String nombreColumna){
    double horasProduccion = 0;
    try{
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        Connection con = null;
        con = Util.openConnection(con);
        Statement st = con.createStatement();
        String consulta = " select sum(s."+nombreColumna+") horas_hombre" +
                 " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s where s.FECHA_INICIO>='"+sdf.format(fechaInicio)+" 00:00:00' and s.FECHA_FINAL<='"+sdf.format(fechaFinal)+" 23:59:59'" +
                 " and s.COD_PERSONAL = '"+personal.getCodigo()+"' ";
        ResultSet rs = st.executeQuery(consulta);
        if(rs.next()){
            horasProduccion =rs.getDouble("horas_hombre");
        }
    }catch(Exception e){e.printStackTrace();}
    return horasProduccion;
}
%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../../js/general.js"></script>
    </head>
    <body >
        <form>
            <%
        int area = Integer.valueOf(request.getParameter("area"));
        String fecha1 = request.getParameter("fecha1");
        String fecha2 = request.getParameter("fecha2");
        String nombre_area = "";
        switch (area) {
            case 1:
                nombre_area = "ADMINISTRATIVA";
                break;
            case 2:
                nombre_area = "COMERCIAL";
                break;
            default:
                nombre_area = "INDUSTRIAL";
        }
            %>
            <h5 align="center">REPORTE DE INDICADORES DE TRABAJO Y TIEMPOS DE PRODUCCION</h5>
            <h4 align="center">DIVISION <%=nombre_area%></h4>
            <h5 align="center">del <%=fecha1%> al <%=fecha2%></h5>
            <table frame="void" rules="all" class="outputText2 panelgrid" width="100%" cellpadding="4" align="left" border="1" style="border-collapsed: collapsed; empty-cells: show; border:solid gainsboro 1px;">
                <%
        EmpresaServiceImpl empresaService = new EmpresaServiceImpl();
        EmpleadoServiceImpl empleadoService = new EmpleadoServiceImpl();
        List areas = empresaService.listaAreasEmpresaMarcaDivision(area);
        DateTime base_inicio = new DateTime(TimeFunction.convertirCadenaDate4(fecha1));
        DateTime base_fin = new DateTime(TimeFunction.convertirCadenaDate4(fecha2)).plusDays(1);
        String fondo = "#FFFFFF";
        NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat formato = (DecimalFormat) numeroformato;
        formato.applyPattern("#,###.##;(#,###.##)");
        if (areas != null) {
            for (int i = 0; i < areas.size(); i++) {
                SelectItem item = (SelectItem) areas.get(i);
                %>
                <tr style="border-collapsed: collapsed;">
                    <%
                        DateTime inicio = base_inicio;
                        DateTime fin = base_fin;
                        inicio = inicio.plusDays(1);
                    %>
                    <th nowrap align="left" bgcolor="#B0C4DE">
                        <font style="font-weight: normal;">
                            <%=item.getLabel()%>
                        </font>
                    </th>
                    <%
                    while (inicio.toDate().compareTo(fin.toDate())<=0) {
                    %>
                    <th bgcolor="#B0C4DE" align="center">
                        <font style="font-weight: normal;">
                            <%=inicio.getDayOfMonth()%>
                        </font>
                    </th>
                    <%
                            inicio = inicio.plusDays(1);
                        }%>
                    <th nowrap align="center" nowrap bgcolor="#B0C4DE">
                        <font style="font-weight: normal; font-size:9px;">
                            HORAS TRABAJADAS HH:MM
                        </font>
                    </th>
                    <th nowrap align="center" nowrap bgcolor="#B0C4DE">
                        <font style="font-weight: normal; font-size:9px;">
                            HORAS TRABAJADAS
                        </font>
                    </th>
                    <th nowrap align="center" nowrap bgcolor="#B0C4DE">
                        <font style="font-weight: normal; font-size:9px;">
                            HORAS TRABAJADAS <BR/> PRODUCCION
                        </font>
                    </th>
                    <th nowrap align="center" nowrap bgcolor="#B0C4DE">
                        <font style="font-weight: normal; font-size:9px;">
                            HORAS EXTRA <BR/> PRODUCCION
                        </font>
                    </th>
                    <%--th nowrap align="center" bgcolor="#B0C4DE">
                        <font style="font-weight: normal; font-size:9px;">
                            DIAS EN PLANILLA
                        </font>
                    </th>
                    <th nowrap align="center" bgcolor="#B0C4DE">
                        <font style="font-weight: normal; font-size:9px;">
                            DIAS VACACION
                        </font>
                    </th>
                    <th nowrap align="center" bgcolor="#B0C4DE">
                        <font style="font-weight: normal; font-size:9px;">
                            DIAS PERMISO
                        </font>
                    </th>
                    <th nowrap align="center" bgcolor="#B0C4DE">
                        <font style="font-weight: normal; font-size:9px;">
                            DIAS DESCUENTO
                        </font>
                    </th>
                    <th nowrap align="center" bgcolor="#B0C4DE">
                        <font style="font-weight: normal; font-size:9px;">
                            DIAS SUSPENSIÓN
                        </font>
                    </th>
                    <th nowrap align="center" bgcolor="#B0C4DE">
                        <font style="font-weight: normal; font-size:9px;">
                            OTROS
                        </font>
                    </th>
                    <th nowrap align="center" bgcolor="#B0C4DE">
                        <font style="font-weight: normal; font-size:9px;">
                            TOTAL DIAS
                        </font>
                    </th>
                </tr--%>
                <%
                        List<Personal> empleados = empleadoService.listaEmpleadosArea(Integer.valueOf(item.getValue().toString()));
                        for (Personal personal : empleados) {
                            int m_trabajado = 0;
                            int dias_trabajados = 0;
                            int m_feriados = 0;
                            if (personal.isMarca() && !personal.isConfianza()) {
                %>
                <tr>
                    <td style="height:19px;">
                        <%=personal.getNombreCompleto()%>
                    </td>
                    <%
                        inicio = base_inicio;
                        fin = base_fin;
                        String query = "SELECT FECHA, EXTRA, TRABAJADO FROM CONTROL_ASISTENCIA_DETALLE WHERE COD_PERSONAL=" + personal.getCodigo() + " AND FECHA>'" + TimeFunction.formatearFecha(inicio.minusDays(1).toDate()) + "' AND FECHA<'" + TimeFunction.formatearFecha(fin.toDate()) + "' AND TRABAJADO>0 ORDER BY FECHA";
                        System.out.println("query:"+query);
                        Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                        ResultSet rs = st.executeQuery(query);
                        while (rs.next()) {
                            String hora_final = "00:00";
                            while (inicio.isBefore(new DateTime(rs.getDate("FECHA")))) {
                                fondo = "#FFFFFF";
                                if (inicio.getDayOfWeek() == 6) {
                                    fondo = "#F5F5F5";
                                }
                                if (inicio.getDayOfWeek() == 7) {
                                    fondo = "#DCDCDC";
                                }%>
                    <td align="center" bgcolor="<%=fondo%>"><pre>     </pre></td>
                    <%
                            inicio = inicio.plusDays(1);
                        }
                        fondo = "#FFFFFF";
                        if (inicio.getDayOfWeek() == 6) {
                            fondo = "#F5F5F5";
                        }
                        if (inicio.getDayOfWeek() == 7) {
                            fondo = "#DCDCDC";
                        }
                        int valor = rs.getInt("TRABAJADO");
                        m_trabajado += valor;
                        if (empleadoService.isFeriado(inicio.toDate())) {
                            m_feriados += valor;
                    %>
                    <td align="center" bgcolor="<%=fondo%>">FERIADO</td>
                    <%
                } else {
                    if (inicio.getDayOfWeek() == 7) {
                        fondo = "#FFDEAD";
                    }
                    %>
                    <td align="center" bgcolor="<%=fondo%>"><%=(TimeFunction.convierteHorasMinutos(valor))%></td>
                    <%
                        }
                        dias_trabajados++;
                        if (valor > 0) {
                            fondo = "#D8E2E3";
                        }
                    %>

                    <%
                            inicio = inicio.plusDays(1);
                        }
                        while (inicio.isBefore(fin)) {
                            fondo = "#FFFFFF";
                            if (inicio.getDayOfWeek() == 6) {
                                fondo = "#F5F5F5";
                            }
                            if (inicio.getDayOfWeek() == 7) {
                                fondo = "#DCDCDC";
                            }%>
                    <td align="center" bgcolor="<%=fondo%>"><pre>     </pre></td>
                    <%
                            inicio = inicio.plusDays(1);
                        }
                        DetallePermiso detalles = empleadoService.totalTiempoPermisosFecha(personal, base_inicio.toDate(), base_fin.minusDays(1).toDate());
                        double total_vacaciones = empleadoService.totalTiempoVacacionFechaMejorado(personal, base_inicio.toDate(), base_fin.minusDays(1).toDate());
                        double horasProduccion = this.horasProduccion(personal, base_inicio.toDate(), base_fin.minusDays(1).toDate(),"horas_hombre");
                        double horasExtra = this.horasProduccion(personal, base_inicio.toDate(), base_fin.minusDays(1).toDate(),"horas_extra");
                    %>
                    <td align="center" bgcolor="#DFE7E8"><%=(TimeFunction.convierteHorasMinutos(m_trabajado))%></td>
                    <td align="center" bgcolor="#DFE7E8"><%=(TimeFunction.convierteHoras(m_trabajado))%></td>
                    <td align="center" bgcolor="#B3C4C7"><%= formato.format(horasProduccion)%></td>
                    <td align="center" bgcolor="#B3C4C7"><%= formato.format(horasExtra)%></td>
                    <%--td align="center" bgcolor="#D3DCDE"><%=dias_trabajados%></td>
                    <td align="center" bgcolor="#C5D1D4"><%=total_vacaciones%></td>
                    <td align="center" bgcolor="#B3C4C7"><%=detalles.getReemplazable()%></td>
                    <td align="center" bgcolor="#B3C4C7"><%=detalles.getDescuento()%></td>
                    <td align="center" bgcolor="#B3C4C7"><%=detalles.getSuspension()%></td>
                    <td align="center" bgcolor="#B3C4C7"><%=detalles.getComision()%></td>                    
                    <td align="center" bgcolor="#B3C4C7"><%=(dias_trabajados + total_vacaciones + detalles.getReemplazable() + detalles.getDescuento() + detalles.getComision())%></td--%>
                    <% }
                        }%>

                </tr>
                <% }
        }%>
            </table>
        </form>
    </body>
</html>

