<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%
out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
String codAreaEmpresa=request.getParameter("areaEmpresa");
String codTiposProduccion=request.getParameter("arrayTipos");
String consulta="SELECT cp.COD_COMPPROD,cp.nombre_prod_semiterminado" +
                " from COMPONENTES_PROD cp where cp.COD_ESTADO_COMPPROD=1"+
                (codAreaEmpresa.equals("")?"":" and  cp.COD_AREA_EMPRESA in ("+codAreaEmpresa+")")+
                (codTiposProduccion.equals("")?"":" and cp.COD_TIPO_PRODUCCION in ("+codTiposProduccion+")")+
                " order by cp.nombre_prod_semiterminado";
System.out.println("consulta productos "+consulta);
Connection con=null;
con=Util.openConnection(con);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet res=st.executeQuery(consulta);
out.println("<select id='selectProducto' multiple size='5' class='inputText'>");
while(res.next())
{
    out.println("<option value='"+res.getInt("COD_COMPPROD")+"'>"+res.getString("nombre_prod_semiterminado")+"</option>");
}


out.println("</select><input type='checkbox' onclick='selecionarTodo(\"selectProducto\",false,this)'>");
%>