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
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
    </head>
    <body>
        <h4 align="center">Reporte Horas Hombre Estandar</h4>
            <%
                String codAreasEmpresaActividad=request.getParameter("codigosArea")==null?"''":request.getParameter("codigosArea");
                String codFormulaMaestra = request.getParameter("codFormulaMaestraP")==null?"''":request.getParameter("codFormulaMaestraP");

                Connection con=null;
                try {
                        con=Util.openConnection(con);
                        NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
                        DecimalFormat formato = (DecimalFormat) numeroformato;
                        formato.applyPattern("#,##0.00;(#,##0.00)");

                        
                    %>
            <center>
                <table style="width:70%">
                    <tr>
                        <td class="outputTextBold">Productos</td>
                        <td class="outputTextBold">::</td>
                        <td class="outputText2">
                            <%
                                StringBuilder consulta=new StringBuilder("select cp.nombre_prod_semiterminado");
                                                        consulta.append(" from FORMULA_MAESTRA fm ");
                                                                consulta.append(" inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=fm.COD_COMPPROD");
                                                        consulta.append(" where fm.COD_FORMULA_MAESTRA in (").append(codFormulaMaestra).append(")");
                                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                ResultSet res=st.executeQuery(consulta.toString());
                                while(res.next())
                                {
                                    if(res.getRow()>1)out.println(",");
                                    out.println(res.getString("nombre_prod_semiterminado"));
                                }
                            %>
                        </td>
                    </tr>
                    <tr>
                        <td class="outputTextBold">Tipo Actividad</td>
                        <td class="outputTextBold">::</td>
                        <td class="outputText2">
                            <%
                                consulta=new StringBuilder("select ae.NOMBRE_AREA_EMPRESA ");
                                            consulta.append(" from AREAS_EMPRESA ae");
                                            consulta.append(" where ae.COD_AREA_EMPRESA in (").append(codAreasEmpresaActividad).append(")");
                                            consulta.append(" order by ae.NOMBRE_AREA_EMPRESA");
                                res=st.executeQuery(consulta.toString());
                                while(res.next())
                                {
                                    if(res.getRow()>1)out.println(",");
                                    out.println(res.getString("NOMBRE_AREA_EMPRESA"));
                                }
                            %>
                        </td>
                    </tr>
                </table>
            </center>
            <br>
            <table width="90%" align="center" class="tablaReporte" cellpadding="0" cellspacing="0" >
                <thead >
                    <tr class="tdCenter">
                        <td rowspan="2">Producto</td>
                        <td rowspan="2">Presentación</td>
                        <td rowspan="2">Tipo Producción</td>
                        <td rowspan="2">Tamaño de Lote</td>
                        <td colspan="8">Tiempos Por Area</td>
                    </tr>
                    <tr class="tdCenter">
                        <td>Almacen</td>
                        <td>Pesaje</td>
                        <td>Producción</td>
                        <td>Acondicionamiento</td>
                        <td>Control de Calidad</td>
                        <td>Soporte</td>
                        <td>Microbiologia</td>
                        <td>Total</td>
                    </tr>
                </thead>
                <%
                    Double sumaCantidadHorasArea= 0d;
                    consulta = new StringBuilder(" select datos.nombre_prod_semiterminado,datos.CANTIDAD_LOTE,datos.NOMBRE_PRODUCTO_PRESENTACION,datos.NOMBRE_TIPO_PROGRAMA_PROD")
                                                .append(" ,sum(case when datos.COD_AREA_EMPRESA = 97 then datos.HORAS_HOMBRE_ESTANDAR else 0 end) as sumaPesaje")
                                                .append(" ,sum(case when datos.COD_AREA_EMPRESA = 96 and (datos.COD_TIPO_PROGRAMA_PRODpp = 0 or datos.COD_TIPO_PROGRAMA_PRODpp=datos.COD_TIPO_PROGRAMA_PROD) then datos.HORAS_HOMBRE_ESTANDAR else 0 end) as sumaProduccion")
                                                .append(" ,sum(case when datos.COD_AREA_EMPRESA = 40 then datos.HORAS_HOMBRE_ESTANDAR else 0 end) as sumaControlCalidad")
                                                .append(" ,sum(case when datos.COD_AREA_EMPRESA = 76 then datos.HORAS_HOMBRE_ESTANDAR else 0 end) as sumaAlmacen")
                                                .append(" ,sum(case when datos.COD_AREA_EMPRESA = 1010 then datos.HORAS_HOMBRE_ESTANDAR else 0 end) as sumaSoporte")
                                                .append(" ,sum(case when datos.COD_AREA_EMPRESA = 75 then datos.HORAS_HOMBRE_ESTANDAR else 0 end) as sumaMicrobiologia")
                                                .append(" ,sum(case when datos.COD_AREA_EMPRESA = 84  AND  datos.COD_PRESENTACION = DATOS.COD_PRESENTACIONpp then datos.HORAS_HOMBRE_ESTANDAR else 0 end) as sumaAcondicionamiento")
                                        .append(" from ( select distinct cp.nombre_prod_semiterminado,fm.CANTIDAD_LOTE,ae.NOMBRE_AREA_EMPRESA,")
                                                        .append(" afmb.DESCRIPCION,afmb.HORAS_HOMBRE_ESTANDAR,afm.COD_FORMULA_MAESTRA,afm.COD_AREA_EMPRESA,afmb.COD_ACTIVIDAD_FORMULA_MAESTRA_BLOQUE")
                                                        .append(" ,pp.NOMBRE_PRODUCTO_PRESENTACION,tpp.NOMBRE_TIPO_PROGRAMA_PROD")
                                                        .append(" ,CPP.COD_PRESENTACION,afm.COD_PRESENTACION as COD_PRESENTACIONpp")
                                                        .append(" ,cpp.COD_TIPO_PROGRAMA_PROD,afm.COD_TIPO_PROGRAMA_PROD as COD_TIPO_PROGRAMA_PRODpp")
                                                .append(" from FORMULA_MAESTRA fm")
                                                        .append(" inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = fm.COD_COMPPROD")
                                                                .append(" and cp.TAMANIO_LOTE_PRODUCCION = fm.CANTIDAD_LOTE")
                                                        .append(" inner join COMPONENTES_PRESPROD cpp on cpp.COD_COMPPROD= cp.COD_COMPPROD")
                                                            .append(" and cpp.COD_ESTADO_REGISTRO=1")
                                                        .append(" inner join presentaciones_producto pp on pp.cod_presentacion = cpp.COD_PRESENTACION")
                                                        .append(" inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD = cpp.COD_TIPO_PROGRAMA_PROD")
                                                        .append(" inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_FORMULA_MAESTRA = fm.COD_FORMULA_MAESTRA")
                                                        .append(" inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA = afm.COD_AREA_EMPRESA")
                                                        .append(" inner join ACTIVIDAD_FORMULA_MAESTRA_BLOQUE afmb on afmb.COD_ACTIVIDAD_FORMULA_MAESTRA_BLOQUE =afm.COD_ACTIVIDAD_FORMULA_MAESTRA_BLOQUE")
                                                .append(" where afm.COD_FORMULA_MAESTRA in (").append(codFormulaMaestra).append(")")
                                                        .append(" and afm.COD_AREA_EMPRESA in (").append(codAreasEmpresaActividad).append(")")
                                        .append(" )as datos")
                                        .append(" group by datos.nombre_prod_semiterminado,datos.CANTIDAD_LOTE,datos.NOMBRE_PRODUCTO_PRESENTACION,datos.NOMBRE_TIPO_PROGRAMA_PROD")
                                        .append(" order by datos.nombre_prod_semiterminado,datos.CANTIDAD_LOTE");
                    System.out.println("consulta reporte "+ consulta.toString());
                    res = st.executeQuery(consulta.toString());
                    while (res.next()) {
                        out.println("<tr>");
                            out.println("<td>"+res.getString("nombre_prod_semiterminado")+"</td>");
                            out.println("<td>"+res.getString("NOMBRE_PRODUCTO_PRESENTACION")+"</td>");
                            out.println("<td>"+res.getString("NOMBRE_TIPO_PROGRAMA_PROD")+"</td>");
                            out.println("<td class='tdRight'>"+formato.format(res.getDouble("CANTIDAD_LOTE"))+"</td>");
                            out.println("<td class='tdRight'>"+formato.format(res.getDouble("sumaAlmacen"))+"</td>");
                            out.println("<td class='tdRight'>"+formato.format(res.getDouble("sumaPesaje"))+"</td>");
                            out.println("<td class='tdRight'>"+formato.format(res.getDouble("sumaProduccion"))+"</td>");
                            out.println("<td class='tdRight'>"+formato.format(res.getDouble("sumaAcondicionamiento"))+"</td>");
                            out.println("<td class='tdRight'>"+formato.format(res.getDouble("sumaControlCalidad"))+"</td>");
                            out.println("<td class='tdRight'>"+formato.format(res.getDouble("sumaSoporte"))+"</td>");
                            out.println("<td class='tdRight'>"+formato.format(res.getDouble("sumaMicrobiologia"))+"</td>");
                            out.println("<td class='tdRight'>"+formato.format(res.getDouble("sumaAlmacen")+res.getDouble("sumaPesaje")+res.getDouble("sumaProduccion")+res.getDouble("sumaAcondicionamiento")+res.getDouble("sumaControlCalidad")+res.getDouble("sumaSoporte")+res.getDouble("sumaMicrobiologia"))+"</td>");
                        out.println("</tr>");
                    }
                            
                }catch (SQLException e) {
                   e.printStackTrace();
               }
               %>
            </table>

    </body>
</html>
