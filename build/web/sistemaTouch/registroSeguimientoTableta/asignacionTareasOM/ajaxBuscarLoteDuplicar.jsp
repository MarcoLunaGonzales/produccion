<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Enumeration" %>
<%@page import="java.util.Map" %>
<%@page import="java.util.Date" %>
<%
String codLote=request.getParameter("codLote");
String codForma=request.getParameter("codForma");
Connection con=null;
try
{
     con=Util.openConnection(con);
     Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
     String consulta="select ppp.COD_PROGRAMA_PROD,pp.COD_LOTE_PRODUCCION,ppp.NOMBRE_PROGRAMA_PROD,"+
                     " p.nombre_prod"+
                     " from PROGRAMA_PRODUCCION pp inner join PROGRAMA_PRODUCCION_PERIODO ppp"+
                     " on pp.COD_PROGRAMA_PROD=ppp.COD_PROGRAMA_PROD and ppp.COD_TIPO_PRODUCCION=1"+
                     " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=pp.COD_COMPPROD"+
                     " inner join PRODUCTOS p on p.cod_prod=cp.COD_PROD" +
                     " inner join TAREAS_OM_PERSONAL_LOTE tom on tom.COD_LOTE=pp.COD_LOTE_PRODUCCION and tom.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD" +
                     " where cp.cod_forma in ("+codForma+")"+
                     (codLote.equals("")?"":" and  pp.COD_LOTE_PRODUCCION='"+codLote+"'")+
                     " group by ppp.COD_PROGRAMA_PROD ,pp.COD_LOTE_PRODUCCION,ppp.NOMBRE_PROGRAMA_PROD,p.nombre_prod"+
                     " order by ppp.COD_PROGRAMA_PROD,p.nombre_prod";
     System.out.println("consulta buscar lote "+consulta);
     ResultSet res=st.executeQuery(consulta);
     out.clear();
     out.println("<table style='width:95%;' class='tablaBuscar' cellpadding='0px' cellspacing='0px'>");
     while(res.next())
     {
         out.println("<tr onclick=\"copiarTareasDesde('"+res.getString("COD_LOTE_PRODUCCION")+"',"+res.getInt("COD_PROGRAMA_PROD")+")\"><td style='width:7em !important'><span class='textHeaderClassBody' >"+res.getString("COD_LOTE_PRODUCCION")+"</td>" +
                    "<td style='width:10em !important'><span class='textHeaderClassBody' >"+res.getString("NOMBRE_PROGRAMA_PROD")+"</td>" +
                    "<td><span class='textHeaderClassBody'>"+res.getString("nombre_prod")+"</td></tr>");
     }
     out.println("</table>");
     con.close();
}
catch(SQLException ex)
{
    ex.printStackTrace();
    con.rollback();
}
catch(Exception ex)
{
    ex.printStackTrace();
    con.rollback();
}




%>
