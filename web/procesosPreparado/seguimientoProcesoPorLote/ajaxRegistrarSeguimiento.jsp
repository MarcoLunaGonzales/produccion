<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%
String codProceso= (request.getParameter("codProceso")==null)||request.getParameter("codProceso")==""?"0":request.getParameter("codProceso");
String codSubProceso=(request.getParameter("codSubProceso")==null)||request.getParameter("codSubProceso")==""?"0":request.getParameter("codSubProceso");
String codLote=(request.getParameter("codLote")==null)||request.getParameter("codLote")==""?"0":request.getParameter("codLote");
String personal=(request.getParameter("personal")==null)||request.getParameter("personal")==""?"0":request.getParameter("personal");
String conforme="1";
String[] operarios=personal.split(",");
String codPersonal="0";
System.out.println("personala "+personal);

out.println("<table><tr><td class='outputText2'>" +
        "<input type='checkbox' id='conforme' "+(conforme.equals("1")?"checked":"")+" onclick='cambiarValor1()'> </td>"+
"<td align='left'><span class='outputText2' >Conforme</span> </td><tr></tr>"+
"<td><input type='checkbox' id='noconforme' "+(!conforme.equals("1")?"checked":"")+" onclick='cambiarValor2()'> </td>"+
"<td align='left'><span class='outputText2'>No Conforme</span> </td>"+
"</tr><tr><td ><span class='outputText2'>Responsable Preparado</span> </td>"+
"<td><select id='codResponsable' class='inputText'>"+
"<option value='0'>-Ninguno-</option>");
for(int i=0;i<operarios.length;i+=2)
{
    out.println("<option value='"+operarios[i]+"' "+(codPersonal.equals(operarios[i])?"selected":"")+">"+operarios[i+1]+"</option>");
}

out.println("</select></td></tr></table>");

%>
