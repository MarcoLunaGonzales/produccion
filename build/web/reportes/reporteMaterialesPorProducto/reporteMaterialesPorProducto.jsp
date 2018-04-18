

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
<%@ page errorPage="ExceptionHandler.jsp" %>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Reporte Materiales Por Producto</title>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
    </head>
    <body>
        <form>
            <center>
            
            <table>
                <tr>
                    <td rowspan="3">
                        <img src="../../img/cofar.png"
                    </td>
                    <td colspan="3">
                        <span class="outputTextTituloSistema">Reporte Materiales Por Producto</span>
                    </td>
                </tr>
                <tr>
                    <td>
                        <span class="outputTextBold">Area Producción</span>
                    </td>
                    <td>
                        <span class="outputTextBold">::</span>
                    </td>
                    <td>
                        <span class="outputText2"><%=(request.getParameter("nombreAreaEmpresa").equals("")?"--TODOS--":request.getParameter("nombreAreaEmpresa"))%></span>
                    </td>
                </tr>
                <tr>
                    <td>
                        <span class="outputTextBold">Tipo Producción</span>
                    </td>
                    <td>
                        <span class="outputTextBold">::</span>
                    </td>
                    <td>
                        <span class="outputText2"><%=(request.getParameter("nombreTipoProduccion").equals("")?"--TODOS--":request.getParameter("nombreTipoProduccion"))%></span>
                    </td>
                </tr>
            </table>
                    <br>
                    <%
                        Connection con=null;
                        try
                        {
                            con=Util.openConnection(con);
                            NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                            DecimalFormat format = (DecimalFormat)nf;
                            format.applyPattern("#,##0.00");
                            String codAreaEmpresa=request.getParameter("codAreaEmpresa");
                            String codTipoProduccion=request.getParameter("codTipoProduccion");
                            out.println("<table cellspacing='0' cellpading='0' class='tablaReporte'>");
                                out.println("<thead>"); 
                                    out.println("<tr>");
                                        out.println("<td colspan='5' align='center'>MATERIA PRIMA - MATERIAL REACTIVO</td>");
                                    out.println("</tr>");
                                    out.println("<tr>");
                                        out.println("<td rowspan='2' align='center'>Material</td>");
                                        out.println("<td rowspan='2' align='center'>Unidad de Medida</td>");
                                        out.println("<td colspan='3' align='center'>Productos</td>");
                                    out.println("</tr>");
                                    out.println("<tr>");
                                        out.println("<td align='center'>Producto</td>");
                                        out.println("<td align='center'>Tamaño Lote</td>");
                                        out.println("<td align='center'>Cantidad</td>");
                                    out.println("<tr>");
                                out.println("</thead>"); 
                                out.println("<tbody>");
                                StringBuilder consulta=new StringBuilder("select  m.COD_MATERIAL,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,cp.nombre_prod_semiterminado,fm.CANTIDAD_LOTE,");
                                                        consulta.append(" datosFm.CANTIDAD");
                                                        consulta.append(" from COMPONENTES_PROD cp ");
                                                                consulta.append(" inner join FORMULA_MAESTRA fm on fm.COD_COMPPROD=cp.COD_COMPPROD");
                                                                consulta.append(" inner join (");
                                                                        consulta.append(" select fmd.CANTIDAD,fmd.COD_FORMULA_MAESTRA,fmd.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_MP fmd");
                                                                        consulta.append(" union ");
                                                                        consulta.append(" select fmdr.CANTIDAD,fmdr.COD_FORMULA_MAESTRA,fmdr.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_MR fmdr");
                                                                consulta.append(" ) as datosFm on datosFm.COD_FORMULA_MAESTRA=fm.COD_FORMULA_MAESTRA");
                                                                consulta.append(" INNER JOIN MATERIALES m on m.COD_MATERIAL=datosFm.COD_MATERIAL");
                                                                consulta.append(" INNER JOIN UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA");
                                                        consulta.append(" where cp.COD_ESTADO_COMPPROD=1 and fm.COD_ESTADO_REGISTRO=1 ");
                                                                if(codAreaEmpresa.length()>0)
                                                                    consulta.append(" AND cp.COD_AREA_EMPRESA IN (").append(codAreaEmpresa).append(")");
                                                                if(codTipoProduccion.length()>0)
                                                                    consulta.append(" AND cp.COD_TIPO_PRODUCCION in (").append(codTipoProduccion).append(")");
                                                        consulta.append(" order by m.NOMBRE_MATERIAL,cp.nombre_prod_semiterminado");
                                System.out.println("consulta cargar materiales mp y mr "+consulta.toString());
                                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                ResultSet res=st.executeQuery(consulta.toString());
                                StringBuilder innerHTMLDetalle=new StringBuilder("");
                                int codMaterialCabecera=0;
                                String nombreMaterial="";
                                String unidadMedida="";
                                int cantidadRegistros=0;
                                Double cantidadTotal=0d;
                                while(res.next())
                                {
                                    if(codMaterialCabecera!=res.getInt("COD_MATERIAL"))
                                    {
                                        if(codMaterialCabecera>0)
                                        {
                                            cantidadRegistros++;
                                            out.println("<tr>");
                                                out.println("<td rowspan='"+cantidadRegistros+"' align='left'>"+nombreMaterial+"</td>");
                                                out.println("<td rowspan='"+cantidadRegistros+"' align='left'>"+unidadMedida+"</td>");
                                                out.println(innerHTMLDetalle.toString());
                                            out.println("<tr>");
                                                out.println("<td colspan='2' class='outputTextBold' align='right'>TOTAL</td>");
                                                out.println("<td align='right' class='outputTextBold'>"+format.format(cantidadTotal)+"</td>");
                                            out.println("</tr>");
                                        }
                                        codMaterialCabecera=res.getInt("COD_MATERIAL");
                                        nombreMaterial=res.getString("NOMBRE_MATERIAL");
                                        unidadMedida=res.getString("NOMBRE_UNIDAD_MEDIDA");
                                        cantidadRegistros=0;
                                        cantidadTotal=0d;
                                        innerHTMLDetalle=new StringBuilder("");
                                    }
                                    cantidadRegistros++;
                                    cantidadTotal+=res.getDouble("CANTIDAD");
                                    if(innerHTMLDetalle.length()>0)innerHTMLDetalle.append("<tr>");
                                    innerHTMLDetalle.append("<td align='left'>").append(res.getString("nombre_prod_semiterminado")).append("</td>");
                                    innerHTMLDetalle.append("<td align='right'>").append(format.format(res.getDouble("CANTIDAD_LOTE"))).append("</td>");
                                    innerHTMLDetalle.append("<td align='right'>").append(format.format(res.getDouble("CANTIDAD"))).append("</td>");
                                    innerHTMLDetalle.append("</tr>");
                                }
                                out.println("</tbody>");
                            out.println("</table><br>");
                            out.println("<table cellspacing='0' cellpading='0' class='tablaReporte'>");
                                out.println("<thead>"); 
                                    out.println("<tr>");
                                        out.println("<td colspan='6' align='center'>EMPAQUE PRIMARIO</td>");
                                    out.println("</tr>");
                                    out.println("<tr>");
                                        out.println("<td rowspan='2' align='center'>Material</td>");
                                        out.println("<td rowspan='2' align='center'>Unidad de Medida</td>");
                                        out.println("<td colspan='4' align='center'>Productos</td>");
                                    out.println("</tr>");
                                    out.println("<tr>");
                                        out.println("<td align='center'>Producto</td>");
                                        out.println("<td align='center'>Tipo Producción</td>");
                                        out.println("<td align='center'>Tamaño Lote </td>");
                                        out.println("<td align='center'>Cantidad</td>");
                                    out.println("<tr>");
                                out.println("</thead>"); 
                                out.println("<tbody>");
                                    consulta=new StringBuilder("select m.COD_MATERIAL,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,cp.nombre_prod_semiterminado,fm.CANTIDAD_LOTE,");
                                                        consulta.append(" tpp.NOMBRE_TIPO_PROGRAMA_PROD,fmd.CANTIDAD");
                                                consulta.append(" from COMPONENTES_PROD cp ");
                                                        consulta.append(" inner join FORMULA_MAESTRA fm on fm.COD_COMPPROD=cp.COD_COMPPROD");
                                                        consulta.append(" inner join FORMULA_MAESTRA_DETALLE_EP fmd on fmd.COD_FORMULA_MAESTRA=fm.COD_FORMULA_MAESTRA");
                                                        consulta.append(" inner join PRESENTACIONES_PRIMARIAS pp on pp.COD_PRESENTACION_PRIMARIA=fmd.COD_PRESENTACION_PRIMARIA");
                                                                consulta.append(" and pp.COD_COMPPROD=cp.COD_COMPPROD");
                                                        consulta.append(" inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD    ");
                                                        consulta.append(" INNER JOIN MATERIALES m on m.COD_MATERIAL=fmd.COD_MATERIAL");
                                                        consulta.append(" INNER JOIN UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA");
                                                consulta.append(" where cp.COD_ESTADO_COMPPROD=1 and fm.COD_ESTADO_REGISTRO=1 and pp.COD_ESTADO_REGISTRO=1 ");
                                                        if(codAreaEmpresa.length()>0)
                                                            consulta.append(" AND cp.COD_AREA_EMPRESA IN (").append(codAreaEmpresa).append(")");
                                                        if(codTipoProduccion.length()>0)
                                                            consulta.append(" AND cp.COD_TIPO_PRODUCCION in (").append(codTipoProduccion).append(")");
                                                consulta.append(" order by m.NOMBRE_MATERIAL,cp.nombre_prod_semiterminado,tpp.NOMBRE_TIPO_PROGRAMA_PROD");
                                    System.out.println("consulta cargar ep "+consulta.toString());
                                    res=st.executeQuery(consulta.toString());
                                    codMaterialCabecera=0;
                                    innerHTMLDetalle=new StringBuilder("");
                                    cantidadRegistros=0;
                                    while(res.next())
                                    {
                                        if(codMaterialCabecera!=res.getInt("COD_MATERIAL"))
                                        {
                                            if(codMaterialCabecera>0)
                                            {
                                                cantidadRegistros++;
                                                out.println("<tr>");
                                                    out.println("<td rowspan='"+cantidadRegistros+"' align='left'>"+nombreMaterial+"</td>");
                                                    out.println("<td rowspan='"+cantidadRegistros+"' align='left'>"+unidadMedida+"</td>");
                                                    out.println(innerHTMLDetalle.toString());
                                                out.println("<tr>");
                                                    out.println("<td colspan='3' class='outputTextBold' align='right'>TOTAL</td>");
                                                    out.println("<td align='right' class='outputTextBold'>"+format.format(cantidadTotal)+"</td>");
                                                out.println("</tr>");
                                            }
                                            codMaterialCabecera=res.getInt("COD_MATERIAL");
                                            nombreMaterial=res.getString("NOMBRE_MATERIAL");
                                            unidadMedida=res.getString("NOMBRE_UNIDAD_MEDIDA");
                                            cantidadRegistros=0;
                                            cantidadTotal=0d;
                                            innerHTMLDetalle=new StringBuilder("");
                                        }
                                        cantidadRegistros++;
                                        cantidadTotal+=res.getDouble("CANTIDAD");
                                        if(innerHTMLDetalle.length()>0)innerHTMLDetalle.append("<tr>");
                                        innerHTMLDetalle.append("<td align='left'>").append(res.getString("nombre_prod_semiterminado")).append("</td>");
                                        innerHTMLDetalle.append("<td align='left'>").append(res.getString("NOMBRE_TIPO_PROGRAMA_PROD")).append("</td>");
                                        innerHTMLDetalle.append("<td align='right'>").append(format.format(res.getDouble("CANTIDAD_LOTE"))).append("</td>");
                                        innerHTMLDetalle.append("<td align='right'>").append(format.format(res.getDouble("CANTIDAD"))).append("</td>");
                                        innerHTMLDetalle.append("</tr>");
                                    }
                                out.println("</tbody>");
                            out.println("</table><br>");
                            
                            
                            
                            
                            out.println("<table cellspacing='0' cellpading='0' class='tablaReporte'>");
                                out.println("<thead>"); 
                                    out.println("<tr>");
                                        out.println("<td colspan='7' align='center'>EMPAQUE SECUNDARIO</td>");
                                    out.println("</tr>");
                                    out.println("<tr>");
                                        out.println("<td rowspan='2' align='center'>Material</td>");
                                        out.println("<td rowspan='2' align='center'>Unidad de Medida</td>");
                                        out.println("<td colspan='5' align='center'>Productos</td>");
                                    out.println("</tr>");
                                    out.println("<tr>");
                                        out.println("<td align='center'>Producto</td>");
                                        out.println("<td align='center'>Tipo Producción</td>");
                                        out.println("<td align='center'>Presentación</td>");
                                        out.println("<td align='center'>Tamaño Lote </td>");
                                        out.println("<td align='center'>Cantidad</td>");
                                    out.println("<tr>");
                                out.println("</thead>"); 
                                out.println("<tbody>");
                                    consulta=new StringBuilder("select m.COD_MATERIAL,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,cp.nombre_prod_semiterminado,fm.CANTIDAD_LOTE,");
                                                        consulta.append(" tpp.NOMBRE_TIPO_PROGRAMA_PROD,pp.NOMBRE_PRODUCTO_PRESENTACION,fmd.CANTIDAD");
                                                consulta.append(" from COMPONENTES_PROD cp ");
                                                        consulta.append(" inner join FORMULA_MAESTRA fm on fm.COD_COMPPROD=cp.COD_COMPPROD");
                                                        consulta.append(" inner join COMPONENTES_PRESPROD cpp on cpp.COD_COMPPROD=cp.COD_COMPPROD");
                                                                consulta.append(" and cpp.COD_ESTADO_REGISTRO=1");
                                                        consulta.append(" inner join FORMULA_MAESTRA_DETALLE_ES fmd on fmd.COD_FORMULA_MAESTRA=fm.COD_FORMULA_MAESTRA");
                                                                consulta.append(" and fmd.COD_PRESENTACION_PRODUCTO=cpp.COD_PRESENTACION");
                                                                consulta.append(" and fmd.COD_TIPO_PROGRAMA_PROD=cpp.COD_TIPO_PROGRAMA_PROD");
                                                        consulta.append(" inner join PRESENTACIONES_PRODUCTO pp on pp.cod_presentacion=cpp.COD_PRESENTACION    ");
                                                        consulta.append(" inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=cpp.COD_TIPO_PROGRAMA_PROD    ");
                                                        consulta.append(" INNER JOIN MATERIALES m on m.COD_MATERIAL=fmd.COD_MATERIAL");
                                                        consulta.append(" INNER JOIN UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA");
                                                consulta.append(" where cp.COD_ESTADO_COMPPROD=1 and fm.COD_ESTADO_REGISTRO=1");
                                                        consulta.append(" and pp.cod_estado_registro=1");
                                                        if(codAreaEmpresa.length()>0)
                                                            consulta.append(" AND cp.COD_AREA_EMPRESA IN (").append(codAreaEmpresa).append(")");
                                                        if(codTipoProduccion.length()>0)
                                                            consulta.append(" AND cp.COD_TIPO_PRODUCCION in (").append(codTipoProduccion).append(")");
                                                consulta.append(" order by m.NOMBRE_MATERIAL,cp.nombre_prod_semiterminado,tpp.NOMBRE_TIPO_PROGRAMA_PROD");
                                    System.out.println("consulta cargar ep "+consulta.toString());
                                    res=st.executeQuery(consulta.toString());
                                    codMaterialCabecera=0;
                                    innerHTMLDetalle=new StringBuilder("");
                                    cantidadRegistros=0;
                                    while(res.next())
                                    {
                                        if(codMaterialCabecera!=res.getInt("COD_MATERIAL"))
                                        {
                                            if(codMaterialCabecera>0)
                                            {
                                                cantidadRegistros++;
                                                out.println("<tr>");
                                                    out.println("<td rowspan='"+cantidadRegistros+"' align='left'>"+nombreMaterial+"</td>");
                                                    out.println("<td rowspan='"+cantidadRegistros+"' align='left'>"+unidadMedida+"</td>");
                                                    out.println(innerHTMLDetalle.toString());
                                                out.println("<tr>");
                                                    out.println("<td colspan='4' class='outputTextBold' align='right'>TOTAL</td>");
                                                    out.println("<td align='right' class='outputTextBold'>"+format.format(cantidadTotal)+"</td>");
                                                out.println("</tr>");
                                            }
                                            codMaterialCabecera=res.getInt("COD_MATERIAL");
                                            nombreMaterial=res.getString("NOMBRE_MATERIAL");
                                            unidadMedida=res.getString("NOMBRE_UNIDAD_MEDIDA");
                                            cantidadRegistros=0;
                                            cantidadTotal=0d;
                                            innerHTMLDetalle=new StringBuilder("");
                                        }
                                        cantidadRegistros++;
                                        cantidadTotal+=res.getDouble("CANTIDAD");
                                        if(innerHTMLDetalle.length()>0)innerHTMLDetalle.append("<tr>");
                                        innerHTMLDetalle.append("<td align='left'>").append(res.getString("nombre_prod_semiterminado")).append("</td>");
                                        innerHTMLDetalle.append("<td align='left'>").append(res.getString("NOMBRE_TIPO_PROGRAMA_PROD")).append("</td>");
                                        innerHTMLDetalle.append("<td align='left'>").append(res.getString("NOMBRE_PRODUCTO_PRESENTACION")).append("</td>");
                                        innerHTMLDetalle.append("<td align='right'>").append(format.format(res.getDouble("CANTIDAD_LOTE"))).append("</td>");
                                        innerHTMLDetalle.append("<td align='right'>").append(format.format(res.getDouble("CANTIDAD"))).append("</td>");
                                        innerHTMLDetalle.append("</tr>");
                                    }
                                out.println("</tbody>");
                            out.println("</table>");
                        }
                        catch(SQLException ex)
                        {
                            ex.printStackTrace();
                        }
                        catch(Exception e)
                        {
                            e.printStackTrace();
                        }
                        finally
                        {
                            con.close();
                        }
        

                       %>
        </center>
    </body>
</html>
