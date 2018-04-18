<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%
try
{
    int codComProd=(Integer.valueOf(request.getParameter("codCompProd")));
    String codLoteProduccion=request.getParameter("codLote");
    String codProgramaProd=request.getParameter("codProgramaProd");
    Connection con=null;
    con=Util.openConnection(con);
    StringBuilder  consulta=new StringBuilder("SELECT pp.COD_LOTE_PRODUCCION,tpp.COD_TIPO_PROGRAMA_PROD,tpp.NOMBRE_TIPO_PROGRAMA_PROD");
                            consulta.append(",cp.COD_COMPPROD,cp.nombre_prod_semiterminado,ppp.COD_PROGRAMA_PROD");
                            
                            consulta.append(" FROM PROGRAMA_PRODUCCION pp inner join COMPONENTES_PROD cp on ");
                            consulta.append(" cp.COD_COMPPROD=pp.COD_COMPPROD");
                            consulta.append(" inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD");
                            consulta.append(" inner join PROGRAMA_PRODUCCION_PERIODO ppp on ppp.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD");
                            consulta.append(" where isnull(cp.COD_TIPO_PRODUCCION,1)=1 and ppp.COD_ESTADO_PROGRAMA<>4");
                            if(codComProd>0)
                                consulta.append(" and cp.COD_COMPPROD=").append(codComProd);
                            if(codLoteProduccion.length()>0)
                                consulta.append(" and pp.COD_LOTE_PRODUCCION like '%").append(codLoteProduccion).append("%'");
                            if(codProgramaProd.length()>0)
                                consulta.append(" and ppp.COD_PROGRAMA_PROD in (").append(codProgramaProd).append(")");
                            consulta.append(" order by cp.nombre_prod_semiterminado,pp.COD_LOTE_PRODUCCION");
    System.out.println("cnsulta productos "+consulta.toString());
    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    ResultSet res=st.executeQuery(consulta.toString());
    out.println("<table class='tablaReporte' id='tablaProductos' cellpadding='0' cellspacing='0'>");
        out.println("<thead>");
            out.println("<tr>");
                out.println("<td><input type='checkbox' onclick='seleccionarTodoProducto(this)'/></td>");
                out.println("<td>Lote</td>");
                out.println("<td>Producto</td>");
                out.println("<td>Tipo Producción</td>");
            out.println("</tr>");
        out.println("</thead><tbody>");
    while(res.next())
    {
        out.println("<tr>");
            out.println("<td><input type='checkbox'/></td>");
            out.println("<td>");
                out.println("<input type='hidden' value='"+res.getInt("COD_PROGRAMA_PROD")+"$"+res.getString("COD_LOTE_PRODUCCION")+"$"+res.getInt("COD_TIPO_PROGRAMA_PROD")+"$"+res.getInt("COD_COMPPROD")+"'/>");
                out.println(res.getString("COD_LOTE_PRODUCCION"));
            out.println("</td>");
            out.println("<td>"+res.getString("nombre_prod_semiterminado") +"</td>");
            out.println("<td>"+res.getString("NOMBRE_TIPO_PROGRAMA_PROD") +"</td>");
        out.println("</tr>");
    }
    out.println("</tbody></table>");
}
catch(SQLException ex)
{
    ex.printStackTrace();
}
catch(Exception e)
{
    e.printStackTrace();
}
%>
