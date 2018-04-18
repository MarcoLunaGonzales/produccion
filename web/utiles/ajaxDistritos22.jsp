<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%
out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
String codAreaEmpresa=request.getParameter("codAreaEmpresa");
String sql="select d.cod_distrito,d.nombre_DISTRITO";
sql+=" from areas_empresa ae, territorios t,filiales f,distritos d";
sql+=" where t.cod_territorio=f.cod_territorio and";
sql+=" d.cod_territorio=t.cod_territorio AND d.cod_estado_registro=1 and";
sql+=" ae.COD_FILIAL=f.COD_FILIAL AND ae.COD_AREA_EMPRESA='"+codAreaEmpresa+"' ";
sql+=" order by d.nombre_DISTRITO";
System.out.println("sqlDistrito:"+sql);
Connection con=null;
con=Util.openConnection(con);
//Connection con =CofarConnection.getConnectionJsp();
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=st.executeQuery(sql);
out.println("<select id='coddistrito' size='3' name='coddistrito' onchange='desabilitarDistrito(form1);' class=\"outputText3\" onchange='ajaxZonas(this.form)' multiple>");
while(rs.next()){
    out.println("<option value=\" "+rs.getString(1)+" \">"+rs.getString(2)+"</option>");
}
out.println("</select>");
out.println("<input type='checkbox' value='0' onclick='sel_todoDistrito(form1)' name='chk_todoDistrito'>Todo");
%>