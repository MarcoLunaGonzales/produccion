<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%
out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
int codEstadoCompProd=Integer.valueOf(request.getParameter("codEstadoCompProd"));



String consulta = "select cp.COD_COMPPROD,cp.nombre_prod_semiterminado from COMPONENTES_PROD cp where isnull(cp.COD_TIPO_PRODUCCION,0) in (1,3) " +
        (codEstadoCompProd>0?" and cp.COD_ESTADO_COMPPROD='"+codEstadoCompProd+"'":"")+
        " order by cp.nombre_prod_semiterminado";
System.out.println("consulta productos"+consulta);
Connection con=null;
con=Util.openConnection(con);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet res=st.executeQuery(consulta);
out.println("<select name='codCompProd' class='outputText3' ><option value='0' checked>-TODOS-</option>");
while(res.next()){
    out.println("<option value="+res.getString("COD_COMPPROD")+">"+res.getString("nombre_prod_semiterminado")+"</option>");
}
out.println("</select>");
res.close();
st.close();
con.close();
%>
