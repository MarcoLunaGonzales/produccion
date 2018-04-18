<%@page import="javax.faces.context.FacesContext"%>
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
            .max{
                background-color:blue;
            }
        </style>
    </head>

    <body>
        <table cellpadding="0" cellspacing="0" class="tablaReporte">
            <thead>
                <tr>
                    <td>Lote</td>
                    <td>Nombre Producto</td>
                    <td>Maquinaria</td>
                    <td>Hora Inicio</td>
                    <td>Hora Final</td>
                </tr>
            </thead>
            
        <%
            Connection con=null;
            String codMaquinaria=request.getParameter("codMaquinaria");
            try
            {
                System.out.println("codMaquinaria");
                SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy HH:mm");
                StringBuilder consulta=new StringBuilder("select mp.COD_LOTE_PRODUCCION,datosLote.nombre_prod,m.NOMBRE_MAQUINA,mp.HORA_INICIO,mp.HORA_FINAL,mre.HORA_REGISTRO,mrp.HORAS_PRODUCIDAS,mrp.HORAS_DETENIDAS");
                                        consulta.append(" from MYSQL_PRODUCCION mp");
                                                consulta.append(" inner join MYSQL_REGISTRO_PRODUCCION mrp on mp.COD_LOTE_PRODUCCION=mp.COD_LOTE_PRODUCCION");
                                                consulta.append(" inner join MYSQL_REGISTRO_EVENTOS mre on  mre.ID_PRODUCCION=mp.ID_PRODUCCION");
                                                consulta.append(" inner join MYSQL_INSTALACION mi on mi.ID_CONTADOR=mre.ID_CONTADOR");
                                                consulta.append(" inner join MAQUINARIAS m on m.COD_MAQUINA=mi.COD_MAQUINA");
                                                consulta.append(" outer APPLY");
                                                consulta.append(" (");
                                                        consulta.append(" select top 1 p.nombre_prod,pp.COD_LOTE_PRODUCCION");
                                                        consulta.append(" from PROGRAMA_PRODUCCION pp");
                                                        consulta.append(" inner join COMPONENTES_PROD_VERSION cpv on cpv.COD_VERSION=pp.COD_COMPPROD_VERSION");
                                                        consulta.append(" inner join PRODUCTOS p on p.cod_prod=cpv.COD_PROD");
                                                        consulta.append(" where pp.COD_LOTE_PRODUCCION=mp.COD_LOTE_PRODUCCION");
                                                consulta.append(" ) as datosLote ");
                                        consulta.append(" where mp.ELIMINADO=0 and m.COD_MAQUINA=").append(codMaquinaria);
                                                consulta.append(" and mp.HORA_INICIO between dateadd(day,-1,getdate()) and getdate()");
                                        consulta.append(" order by mp.COD_LOTE_PRODUCCION,datosLote.nombre_prod");
                System.out.println("consulta "+consulta.toString());
                con=Util.openConnection(con);
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet res=st.executeQuery(consulta.toString());
                while(res.next())
                {
                    out.println("<tr>");
                            out.println("<td>"+res.getString("COD_LOTE_PRODUCCION")+"</td>");
                            out.println("<td>"+res.getString("nombre_prod")+"</td>");
                            out.println("<td>"+res.getString("NOMBRE_MAQUINA")+"</td>");
                    out.println("</tr>");
                }
            }
            catch(SQLException ex)
            {
                ex.printStackTrace();
            }
        %>
        </table>
            
        
    </body>
</html>