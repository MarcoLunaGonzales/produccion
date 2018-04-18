<%@page contentType="text/html"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%

String codAreaEmpresa=request.getParameter("codAreaEmpresa");
StringBuilder consulta = new StringBuilder("select DISTINCT pap.COD_PERSONAL,isnull(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL,pt.AP_PATERNO_PERSONAL+' '+pt.AP_MATERNO_PERSONAL+' '+pt.NOMBRES_PERSONAL) as nombrePersonal");
                            consulta.append(" from PERSONAL_AREA_PRODUCCION pap");
                                    consulta.append(" left outer join personal p on p.COD_PERSONAL=pap.COD_PERSONAL");
                                consulta.append(" left outer join PERSONAL_TEMPORAL pt on pt.COD_PERSONAL=pap.COD_PERSONAL");
                            consulta.append(" where pap.COD_ESTADO_PERSONAL_AREA_PRODUCCION=1");
                                    consulta.append(" and pap.COD_AREA_EMPRESA in (").append(codAreaEmpresa).append(")");
                            consulta.append(" order by 2");
Connection con=null;
con=Util.openConnection(con);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet res=st.executeQuery(consulta.toString());
out.println("<select id='codPersonal' size='6' class='inputText' multiple >");
while(res.next()){
    out.println("<option value=\""+res.getString("COD_PERSONAL")+"\">"+res.getString("nombrePersonal")+"</option>");
}
out.println("</select>");
con.close();
%>
