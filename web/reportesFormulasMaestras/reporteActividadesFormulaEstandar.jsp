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
                        <td rowspan="2">Tamaño de Lote</td>
                        <td colspan="5">Detalle De Actividades</td>
                    </tr>
                    <tr class="tdCenter">
                        <td>Area</td>
                        <td>Tipo Programa</td>
                        <td>Presentacion</td>
                        <td>Bloque Actividad</td>
                        <td>Horas Hombre Estandar</td>
                    </tr>
                </thead>
                <%
                    Double sumaCantidadHorasArea= 0d;
                    consulta = new StringBuilder(" select distinct cp.nombre_prod_semiterminado,fm.CANTIDAD_LOTE,ae.NOMBRE_AREA_EMPRESA,")
                                                .append(" afmb.DESCRIPCION,afmb.HORAS_HOMBRE_ESTANDAR,afm.COD_FORMULA_MAESTRA,afm.COD_AREA_EMPRESA,afmb.COD_ACTIVIDAD_FORMULA_MAESTRA_BLOQUE")
                                                .append(" ,isnull(tpp.NOMBRE_TIPO_PROGRAMA_PROD,'') as NOMBRE_TIPO_PROGRAMA_PROD,tpp.COD_TIPO_PROGRAMA_PROD")
                                                .append(" ,isnull(pp.NOMBRE_PRODUCTO_PRESENTACION,'') as NOMBRE_PRODUCTO_PRESENTACION")
                                        .append(" from FORMULA_MAESTRA fm")
                                                .append(" inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = fm.COD_COMPPROD")
                                                        .append(" and cp.TAMANIO_LOTE_PRODUCCION = fm.CANTIDAD_LOTE")
                                                .append(" inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_FORMULA_MAESTRA = fm.COD_FORMULA_MAESTRA")
                                                .append(" inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA = afm.COD_AREA_EMPRESA")
                                                .append(" inner join ACTIVIDAD_FORMULA_MAESTRA_BLOQUE afmb on afmb.COD_ACTIVIDAD_FORMULA_MAESTRA_BLOQUE =afm.COD_ACTIVIDAD_FORMULA_MAESTRA_BLOQUE")
                                                .append(" left outer join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD = afm.COD_TIPO_PROGRAMA_PROD")
                                                .append(" left outer join PRESENTACIONES_PRODUCTO pp on pp.cod_presentacion =afm.COD_PRESENTACION")
                                        .append(" where afm.COD_FORMULA_MAESTRA in (").append(codFormulaMaestra).append(")")
                                                .append(" and afm.COD_AREA_EMPRESA in (").append(codAreasEmpresaActividad).append(")")
                                        .append(" order by cp.nombre_prod_semiterminado,ae.NOMBRE_AREA_EMPRESA,9,afmb.DESCRIPCION");
                    System.out.println("consulta reporte "+ consulta.toString());
                    res = st.executeQuery(consulta.toString());
                    int codFormulaMaestraCabecera=-1;
                    int codAreaEmpresaCabecera=-1;
                    int codActividadFormulaCabecera=-1;
                    int contadorDetalleProducto=0;
                    int contadorAreaEmpresa=0;
                    int contadorActividades=0;
                    StringBuilder detalleActividades=new StringBuilder("");
                    StringBuilder detalleMaquinarias=new StringBuilder("");
                    StringBuilder detalleArea=new StringBuilder("");
                    while (res.next()) {
                            if(codFormulaMaestraCabecera!=res.getInt("COD_FORMULA_MAESTRA"))
                            {
                                if(codFormulaMaestraCabecera>-1)
                                {
                                    res.previous();
                                    detalleActividades.append("<td rowspan='").append(contadorActividades).append("'>").append(res.getString("DESCRIPCION")).append("</td>");
                                    detalleActividades.append(detalleMaquinarias.toString());
                                    detalleArea.append("<td rowspan='").append(contadorAreaEmpresa).append("'>").append(res.getString("NOMBRE_AREA_EMPRESA")).append("</td>");
                                    detalleArea.append(detalleActividades.toString());
                                    out.println("<tr>");
                                    detalleArea.append("<tr><td colspan='4' class='tdRight outputTextBold'>Total Area:</td><td class='tdRight outputTextBold'>").append(formato.format(sumaCantidadHorasArea)).append("</td></tr>");
                                    out.println("<td rowspan='"+contadorDetalleProducto+"'>"+res.getString("nombre_prod_semiterminado")+"</td>");
                                    out.println("<td rowspan='"+contadorDetalleProducto+"' class='tdRight'>"+res.getInt("CANTIDAD_LOTE")+"</td>");
                                    out.println(detalleArea.toString());
                                    res.next();
                                }
                                contadorDetalleProducto=0;
                                codFormulaMaestraCabecera=res.getInt("COD_FORMULA_MAESTRA");
                                codAreaEmpresaCabecera=-1;
                                detalleArea=new StringBuilder("");
                            }
                            if(codAreaEmpresaCabecera!=res.getInt("COD_AREA_EMPRESA"))
                            {
                                if(codAreaEmpresaCabecera>-1)
                                {
                                    res.previous();
                                    detalleActividades.append("<td rowspan='").append(contadorActividades).append("'>").append(res.getString("NOMBRE_TIPO_PROGRAMA_PROD")).append("</td>");
                                    detalleActividades.append(detalleMaquinarias.toString());
                                    detalleArea.append("<td rowspan='").append(contadorAreaEmpresa).append("'>").append(res.getString("NOMBRE_AREA_EMPRESA")).append("</td>");
                                    detalleArea.append(detalleActividades.toString());
                                    detalleArea.append("<tr><td colspan='4' class='tdRight outputTextBold'>Total Area:</td><td class='tdRight outputTextBold'>").append(formato.format(sumaCantidadHorasArea)).append("</td></tr>");
                                    res.next();
                                }
                                sumaCantidadHorasArea = 0d;
                                codAreaEmpresaCabecera=res.getInt("COD_AREA_EMPRESA");
                                detalleActividades=new StringBuilder("");
                                contadorAreaEmpresa=0;
                                codActividadFormulaCabecera=-1;
                                contadorDetalleProducto++;
                            }
                            if(codActividadFormulaCabecera!=res.getInt("COD_TIPO_PROGRAMA_PROD"))
                            {
                                if(codActividadFormulaCabecera>-1)
                                {
                                    res.previous();
                                    detalleActividades.append("<td rowspan='").append(contadorActividades).append("'>").append(res.getString("NOMBRE_TIPO_PROGRAMA_PROD")).append("</td>");
                                    detalleActividades.append(detalleMaquinarias.toString());
                                    res.next();
                                }
                                codActividadFormulaCabecera=res.getInt("COD_TIPO_PROGRAMA_PROD");
                                contadorActividades=0;
                                detalleMaquinarias=new StringBuilder("");
                            }
                            detalleMaquinarias.append("<td>").append(res.getString("NOMBRE_PRODUCTO_PRESENTACION")).append("</td>");
                            detalleMaquinarias.append("<td>").append(res.getString("DESCRIPCION")).append("</td>");
                            detalleMaquinarias.append("<td class='tdRight'>").append(formato.format(res.getDouble("HORAS_HOMBRE_ESTANDAR"))).append("</td>");
                        detalleMaquinarias.append("</tr>");
                        sumaCantidadHorasArea +=res.getDouble("HORAS_HOMBRE_ESTANDAR");
                        contadorDetalleProducto++;
                        contadorAreaEmpresa++;
                        contadorActividades++;
                    }
                    if(codFormulaMaestraCabecera>0)
                    {
                        res.last();
                        detalleActividades.append("<td rowspan='").append(contadorActividades).append("'>").append(res.getString("DESCRIPCION")).append("</td>");
                        detalleActividades.append(detalleMaquinarias.toString());
                        detalleArea.append("<td rowspan='").append(contadorAreaEmpresa).append("'>").append(res.getString("NOMBRE_AREA_EMPRESA")).append("</td>");
                        detalleArea.append(detalleActividades.toString());
                        out.println("<tr>");
                        detalleArea.append("<tr><td colspan='4' class='tdRight outputTextBold'>Total Area:</td><td class='tdRight outputTextBold'>").append(formato.format(sumaCantidadHorasArea)).append("</td></tr>");
                        out.println("<td rowspan='"+contadorDetalleProducto+"'>"+res.getString("nombre_prod_semiterminado")+"</td>");
                        out.println("<td rowspan='"+contadorDetalleProducto+"' class='tdRight'>"+res.getInt("CANTIDAD_LOTE")+"</td>");
                        out.println(detalleArea.toString());
                        
                    }
                }catch (SQLException e) {
                   e.printStackTrace();
               }
               %>
            </table>

    </body>
</html>
