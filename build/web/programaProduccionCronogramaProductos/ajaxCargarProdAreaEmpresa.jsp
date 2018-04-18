<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.sql.Statement"%>
<%@ page import="com.cofar.util.*" %>
<%@ page language="java" import="java.util.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%

try{
    String codAreaEmpresa=request.getParameter("codArea");
    String codProgProd=request.getParameter("codProgProd");

    String consulta=" select cp.nombre_prod_semiterminado,pp.COD_LOTE_PRODUCCION,tpp.NOMBRE_TIPO_PROGRAMA_PROD"+
                                " ,pp.COD_COMPPROD,pp.COD_FORMULA_MAESTRA,pp.COD_LOTE_PRODUCCION,pp.COD_PROGRAMA_PROD,pp.COD_TIPO_PROGRAMA_PROD" +
                                " from PROGRAMA_PRODUCCION pp"+
                                " inner join COMPONENTES_PROD cp on pp.COD_COMPPROD = cp.COD_COMPPROD"+
                                " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD ="+
                                " pp.COD_TIPO_PROGRAMA_PROD "+
                                " where pp.COD_PROGRAMA_PROD = '"+codProgProd+"' " +(codAreaEmpresa.equals("0")?"":" and cp.COD_AREA_EMPRESA='"+codAreaEmpresa+"'")+
                                " and CAST(pp.COD_COMPPROD as varchar)+' '+cast(pp.COD_FORMULA_MAESTRA as varchar)+"+
                                "' '+CAST(pp.COD_LOTE_PRODUCCION as varchar)+' '+cast(pp.COD_PROGRAMA_PROD as varchar)+"+
                                "' '+cast(pp.COD_TIPO_PROGRAMA_PROD as varchar) not IN(select "+
                                "cast(ppcd.COD_COMPPROD as varchar)+' '+cast(ppcd.COD_FORMULA_MAESTRA as varchar)+"+
                                "' '+cast(ppcd.COD_LOTE_PRODUCCION as varchar)+' '+cast(ppcd.COD_PROGRAMA_PROD as varchar)+"+
                                "' '+cast(ppcd.COD_TIPO_PROGRAMA_PROD as varchar)"+
                                " from PROGRAMA_PRODUCCION_CRONOGRAMA_DIAS ppcd )"+
                                "order by cp.nombre_prod_semiterminado";
                System.out.println("consulta cargarProductos "+consulta);
    
out.println("<table id='ProgProdCronograma' border=1 cellspacing=0 cellpadding=2 bordercolor='666633' style='width:100%;' class='border'>");
out.println("<tbody id='tablaProgProdCronograma'>");
Connection con=null;
con=Util.openConnection(con);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet res=st.executeQuery(consulta);
  while(res.next())
                    {
                        out.println("<tr class='outputText2' ><td style='cursor: move' onclick='showModal(this)' class='outputText2'><span>" +
                                res.getString("nombre_prod_semiterminado")+
                                "</span><br>"+res.getString("NOMBRE_TIPO_PROGRAMA_PROD")+
                                "("+res.getString("COD_LOTE_PRODUCCION")+")" +
                                "<input type='hidden' value='"+res.getString("COD_COMPPROD")+"'>"+
                                "<input type='hidden' value='"+res.getString("COD_LOTE_PRODUCCION")+"'>"+
                                "<input type='hidden' value='"+res.getString("COD_PROGRAMA_PROD")+"'>"+
                                "<input type='hidden' value='"+res.getString("COD_TIPO_PROGRAMA_PROD")+"'>"+
                                "<input type='hidden' value='"+res.getString("COD_FORMULA_MAESTRA")+"'>"+

                                "</td>");

                    }
    out.println("</tbody>");
    out.println("</table>");
}
catch(Exception ex)
{
    ex.printStackTrace();
}
                %>
