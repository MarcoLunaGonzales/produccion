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
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style type="text/css">
            body{
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size:12px;
            }
            .tablaReporte{
                border-collapse: collapse;
            }
            .tablaReporte tr td{
                border: 1px solid #ccc;
            }
            .tablaReporte thead tr td{
                font-weight: bold;
                background-color: #ddd;
                text-align: center;
            }
        </style>
    </head>
    <body>
        <h4 align="center">Reporte Actividades Segun Formula Maestra</h4>
            <%
                String codAreasEmpresaActividad=request.getParameter("codigosArea")==null?"''":request.getParameter("codigosArea");
                String codFormulaMaestra = request.getParameter("codFormulaMaestraP")==null?"''":request.getParameter("codFormulaMaestraP");

                Connection con=null;
                try {
                        con=Util.openConnection(con);
                        NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
                        DecimalFormat formato = (DecimalFormat) numeroformato;
                        formato.applyPattern("#,###.##;(#,###.##)");

                        
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
                        <td>Actividad</td>
                        <td>Maquina</td>
                        <td>Horas Hombre Estandar</td>
                        <td>Horas Maquina Estandar</td>
                    </tr>
                </thead>
                <%

                    consulta = new StringBuilder(" select cp.nombre_prod_semiterminado,isnull(ap.NOMBRE_ACTIVIDAD,'') as NOMBRE_ACTIVIDAD,isnull(m.NOMBRE_MAQUINA,'') as NOMBRE_MAQUINA,isnull(ae.NOMBRE_AREA_EMPRESA,'') as NOMBRE_AREA_EMPRESA");
                                        consulta.append(" ,afm.COD_ACTIVIDAD_FORMULA,afm.COD_AREA_EMPRESA,fm.COD_FORMULA_MAESTRA,maf.HORAS_HOMBRE_ESTANDAR,maf.HORAS_MAQUINA_ESTANDAR,fm.CANTIDAD_LOTE");
                                consulta.append(" from FORMULA_MAESTRA fm");
                                        consulta.append(" inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=fm.COD_COMPPROD");
                                        consulta.append(" left outer join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_FORMULA_MAESTRA=fm.COD_FORMULA_MAESTRA");
                                                consulta.append(" and afm.COD_AREA_EMPRESA in (").append(codAreasEmpresaActividad).append(")");
                                                consulta.append(" and afm.COD_ESTADO_REGISTRO=1");
                                                consulta.append(" and isnull(afm.COD_PRESENTACION,0)=0");
                                        consulta.append(" left outer join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=afm.COD_AREA_EMPRESA");
                                        consulta.append(" left outer join ACTIVIDADES_PRODUCCION ap on ap.COD_ACTIVIDAD=afm.COD_ACTIVIDAD");
                                        consulta.append(" left outer join ACTIVIDADES_FORMULA_MAESTRA_HORAS_ESTANDAR_MAQUINARIA maf on maf.COD_ACTIVIDAD_FORMULA=afm.COD_ACTIVIDAD_FORMULA");
                                        consulta.append(" left outer join MAQUINARIAS m on m.COD_MAQUINA=maf.COD_MAQUINA");
                                consulta.append(" where fm.COD_FORMULA_MAESTRA in (").append(codFormulaMaestra).append(")");
                                consulta.append(" order by cp.nombre_prod_semiterminado,fm.COD_FORMULA_MAESTRA,ae.NOMBRE_AREA_EMPRESA,afm.ORDEN_ACTIVIDAD,ap.NOMBRE_ACTIVIDAD");
                    System.out.println("consulta reporte "+ consulta.toString());
                    res = st.executeQuery(consulta.toString());
                    while (res.next()) {
                        out.println("<tr>");
                            out.println("<td>"+res.getString("nombre_prod_semiterminado")+"</td>");
                            out.println("<td>"+res.getInt("CANTIDAD_LOTE")+"</td>");
                            out.println("<td>"+res.getString("NOMBRE_AREA_EMPRESA")+"</td>");
                            out.println("<td>"+res.getString("NOMBRE_ACTIVIDAD")+"</td>");
                            out.println("<td>"+res.getString("NOMBRE_MAQUINA")+"</td>");
                            out.println("<td>"+formato.format(res.getDouble("HORAS_HOMBRE_ESTANDAR"))+"</td>");
                            out.println("<td>"+formato.format(res.getDouble("HORAS_MAQUINA_ESTANDAR"))+"</td>");
                        out.println("</tr>");
                            
                    }
                }catch (SQLException e) {
                   e.printStackTrace();
                }finally{
                    con.close();
                }
               %>
            </table>

    </body>
</html>
