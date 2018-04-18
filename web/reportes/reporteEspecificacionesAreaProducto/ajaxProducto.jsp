


<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%

String codAreaEmpresa = request.getParameter("codArea");


String consulta = " select cp.COD_COMPPROD,cp.nombre_prod_semiterminado from COMPONENTES_PROD cp where cp.COD_AREA_EMPRESA in ( "+(codAreaEmpresa.equals("")?"-1":codAreaEmpresa)+")" +
        " order by cp.nombre_prod_semiterminado";
System.out.println("consulta Productos"+consulta);
Connection con=null;
con=Util.openConnection(con);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=st.executeQuery(consulta);
out.println("<select class='inputText' id='codCompProd'>");
out.println("<option value='0' >-TODOS-</option>");
while(rs.next()){
     out.println("<option value='"+rs.getString("COD_COMPPROD")+"'>"+rs.getString("nombre_prod_semiterminado")+"</option>");
    
}
out.println("</select>");
st.close();
con.close();
%>
