<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Connection"%>
<%@ page import="com.cofar.util.*"%>
<%@ page import="com.cofar.bean.*"%>
<%@page import="java.text.NumberFormat" %>
<%@page import="java.text.DecimalFormat" %>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>


<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title>SISTEMA</title>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" /> 
        <style>
            .tablaLote{
                border:1px solid black;
            }
            .tablaLote thead tr td
            {
                background-color: #9d5a9e;
                color: white;
                font-weight: bold;
                padding: 1em;
                border-bottom: 1px solid black;
            }
            .tablaLote td
            {
                padding: 0.5em;
            }
        </style>
    </head>
    <body bgcolor="white">
        <center>
        <%
            Connection con=null;
            String codProgramaProd=Util.getParameter("codigo");
            String nombre=Util.getParameter("nombre");
            String codFormula=request.getParameter("codFormula");
            String cantidad=Util.getParameter("cantidad");
            String codCompProd=Util.getParameter("cod_comp_prod");
            String codLote=Util.getParameter("cod_lote");
            String codTipoProgramaProd1 = Util.getParameter("codTipoProgramaProd");
            NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
            DecimalFormat formato = (DecimalFormat)nf;
            formato.applyPattern("#,##0.00");
            try 
            {
            con=Util.openConnection(con);
            out.println("<table style='margin-top:1em' class='outputText2 tablaLote' cellpadding='0' cellspacing='0'><thead><tr><td align='center' colspan='6'>DATOS LOTE PRODUCCION</td></tr></thead>");
            StringBuilder consulta=new StringBuilder("select pp.COD_LOTE_PRODUCCION,pp.CANT_LOTE_PRODUCCION,tpp.NOMBRE_TIPO_PROGRAMA_PROD,cpv.nombre_prod_semiterminado");
                            consulta.append(",pp1.NOMBRE_PRODUCTO_PRESENTACION,ppp.NOMBRE_PROGRAMA_PROD");
                            consulta.append(" from PROGRAMA_PRODUCCION pp inner join TIPOS_PROGRAMA_PRODUCCION tpp on ");
                            consulta.append(" pp.COD_TIPO_PROGRAMA_PROD=tpp.COD_TIPO_PROGRAMA_PROD");
                            consulta.append(" inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_COMPPROD=pp.COD_COMPPROD and pp.COD_COMPPROD_VERSION=cpv.COD_VERSION");
                            consulta.append(" left outer join PRESENTACIONES_PRODUCTO pp1 on pp.COD_PRESENTACION=pp1.cod_presentacion");
                            consulta.append(" inner join PROGRAMA_PRODUCCION_PERIODO ppp on ppp.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD");
                            consulta.append(" where pp.COD_PROGRAMA_PROD=").append(codProgramaProd);
                            consulta.append(" and pp.COD_LOTE_PRODUCCION='").append(codLote).append("'");
                            consulta.append(" and pp.COD_TIPO_PROGRAMA_PROD=").append(codTipoProgramaProd1);
                            consulta.append(" and pp.COD_COMPPROD=").append(codCompProd);
            System.out.println("consula cargar cabecera "+consulta.toString());
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta.toString());
            if(res.next())
            {
                out.println("<tr>");
                out.println("<td style='font-weight:bold'>Programa Producción</td><td style='font-weight:bold'>::</td><td>"+res.getString("NOMBRE_PROGRAMA_PROD")+"</td>");
                out.println("<td style='font-weight:bold'>Lote</td><td style='font-weight:bold'>::</td><td>"+codLote+"</td>");
                out.println("</tr>");
                out.println("<tr>");
                out.println("<td style='font-weight:bold'>Producto</td><td style='font-weight:bold'>::</td><td>"+res.getString("nombre_prod_semiterminado")+"</td>");
                out.println("<td style='font-weight:bold'>Tipo Producción</td><td style='font-weight:bold'>::</td><td>"+res.getString("NOMBRE_TIPO_PROGRAMA_PROD")+"</td>");
                out.println("</tr>");
                out.println("<tr>");
                out.println("<td style='font-weight:bold'>Presentación</td><td style='font-weight:bold'>::</td><td>"+res.getString("NOMBRE_PRODUCTO_PRESENTACION")+"</td>");
                out.println("<td style='font-weight:bold'>Tamaño Lote</td><td style='font-weight:bold'>&nbsp</td><td>"+res.getInt("CANT_LOTE_PRODUCCION")+"</td>");
                out.println("</tr>");
            }
            out.println("</table>");
            consulta=new StringBuilder("select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,ppd.CANTIDAD,um.COD_UNIDAD_MEDIDA");
                        consulta.append(" from PROGRAMA_PRODUCCION_DETALLE ppd inner join materiales m on ppd.COD_MATERIAL=m.COD_MATERIAL");
                        consulta.append(" inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=ppd.COD_UNIDAD_MEDIDA");
                        consulta.append(" where ppd.COD_PROGRAMA_PROD=").append(codProgramaProd);
                        consulta.append(" AND ppd.COD_LOTE_PRODUCCION='").append(codLote).append("'");
                        consulta.append(" and ppd.COD_TIPO_PROGRAMA_PROD=").append(codTipoProgramaProd1);
                        consulta.append(" and ppd.COD_COMPPROD=").append(codCompProd);
                        consulta.append(" and ppd.COD_TIPO_MATERIAL=1");
                        consulta.append(" order by m.NOMBRE_MATERIAL");
            System.out.println(consulta.toString());
             res=st.executeQuery(consulta.toString());
            out.println("<table style='margin-top:1em' class='tablaReporte' cellpadding='0' cellspacing='0'><thead><tr><td align='center' colspan='3'>Materia Prima</td></tr><tr><td>Material</td><td>Cantidad</td><td>Unidad Medida</td></tr></thead>");
            while(res.next())
            {
                out.println("<tr>");
                out.println("<td>"+res.getString("NOMBRE_MATERIAL") +"</td>");
                out.println("<td>"+formato.format(res.getDouble("CANTIDAD"))+"</td>");
                out.println("<td>"+res.getString("NOMBRE_UNIDAD_MEDIDA") +"</td>");
                out.println("</tr>");
            }
            out.println("</table>");
            consulta=new StringBuilder("select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,ppd.CANTIDAD,um.COD_UNIDAD_MEDIDA");
                        consulta.append(" from PROGRAMA_PRODUCCION_DETALLE ppd inner join materiales m on ppd.COD_MATERIAL=m.COD_MATERIAL");
                        consulta.append(" inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=ppd.COD_UNIDAD_MEDIDA");
                        consulta.append(" where ppd.COD_PROGRAMA_PROD=").append(codProgramaProd);
                        consulta.append(" AND ppd.COD_LOTE_PRODUCCION='").append(codLote).append("'");
                        consulta.append(" and ppd.COD_TIPO_PROGRAMA_PROD=").append(codTipoProgramaProd1);
                        consulta.append(" and ppd.COD_COMPPROD=").append(codCompProd);
                        consulta.append(" and ppd.COD_TIPO_MATERIAL=2");
                        consulta.append(" order by m.NOMBRE_MATERIAL");
            System.out.println(consulta.toString());
            res=st.executeQuery(consulta.toString());
            out.println("<table style='margin-top:1em' class='tablaReporte' cellpadding='0' cellspacing='0'><thead><tr><td align='center' colspan='3'>Empaque Primario</td></tr><tr><td>Material</td><td>Cantidad</td><td>Unidad Medida</td></tr></thead>");
            while(res.next())
            {
                out.println("<tr>");
                out.println("<td>"+res.getString("NOMBRE_MATERIAL") +"</td>");
                out.println("<td>"+res.getDouble("CANTIDAD") +"</td>");
                out.println("<td>"+res.getString("NOMBRE_UNIDAD_MEDIDA") +"</td>");
                out.println("</tr>");
            }
            out.println("</table>");
            consulta=new StringBuilder("select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,CEILING(ppd.CANTIDAD) AS CANTIDAD ,um.COD_UNIDAD_MEDIDA");
                        consulta.append(" from PROGRAMA_PRODUCCION_DETALLE ppd inner join materiales m on ppd.COD_MATERIAL=m.COD_MATERIAL");
                        consulta.append(" inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=ppd.COD_UNIDAD_MEDIDA");
                        consulta.append(" where ppd.COD_PROGRAMA_PROD=").append(codProgramaProd);
                        consulta.append(" AND ppd.COD_LOTE_PRODUCCION='").append(codLote).append("'");
                        consulta.append(" and ppd.COD_TIPO_PROGRAMA_PROD=").append(codTipoProgramaProd1);
                        consulta.append(" and ppd.COD_COMPPROD=").append(codCompProd);
                        consulta.append(" and ppd.COD_TIPO_MATERIAL=3");
                        consulta.append(" order by m.NOMBRE_MATERIAL");
            System.out.println(consulta.toString());
            res=st.executeQuery(consulta.toString());
            out.println("<table style='margin-top:1em' class='tablaReporte' cellpadding='0' cellspacing='0'><thead><tr><td align='center' colspan='3'>Empaque Secundario</td></tr><tr><td>Material</td><td>Cantidad</td><td>Unidad Medida</td></tr></thead>");
            while(res.next())
            {
                out.println("<tr>");
                out.println("<td>"+res.getString("NOMBRE_MATERIAL") +"</td>");
                out.println("<td>"+res.getDouble("CANTIDAD") +"</td>");
                out.println("<td>"+res.getString("NOMBRE_UNIDAD_MEDIDA") +"</td>");
                out.println("</tr>");
            }
            out.println("</table>");
            st.close();
            con.close();
        } 
        catch (SQLException ex) 
        {
            ex.printStackTrace();
        }
        %>
        </center>
    </body>
</html>



