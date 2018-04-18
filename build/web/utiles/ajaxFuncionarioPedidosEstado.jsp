<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%
out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
String codEstadoRegistro=request.getParameter("codEstadoRegistro");
String codAreaEmpresa=request.getParameter("codAreaEmpresa");
String sql="select p.cod_personal,p.ap_paterno_personal+' '+ p.ap_materno_personal+' '+p.nombres_personal  from personal p";
sql+=" where p.cod_area_empresa in("+codAreaEmpresa+")";
if(!codEstadoRegistro.equals("0")){
    sql+=" and p.cod_estado_persona="+codEstadoRegistro;
}
sql+="  order by p.ap_paterno_personal asc";
System.out.println("sqlPersonal::::::::::::::::::::"+sql);
try{
    Connection con=null;
    con=Util.openConnection(con);
    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    ResultSet rs=st.executeQuery(sql);
    out.println("<select id='codfuncionario' name='codfuncionario' size='9' class=\"inputText3\" multiple >");
    while(rs.next()){
        out.println("<option value=\" "+rs.getString(1)+" \">"+rs.getString(2)+"&nbsp;&nbsp;</option>");
    }
    
}catch(SQLException e){
    e.printStackTrace();
}
out.println("</select>");
out.println("<input type='checkbox' value='0' onclick=\"sel_todoLineaMkt(form1)\" name='chk_todoFuncionario'>Todo");
%>