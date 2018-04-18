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
String codPersonal=(request.getParameter("personal")==null)||request.getParameter("personal")==""?"0":request.getParameter("personal");
String conforme=(request.getParameter("conforme")==null)||request.getParameter("conforme")==""?"0":request.getParameter("conforme");
Connection con=null;
try
{
String consulta="delete SEGUIMIENTO_PROCESOS_PREPARADO_LOTE where COD_PROCESO_PRODUCTO='"+codProceso+"' and "+
                " COD_SUB_PROCESO_PRODUCTO='"+codSubProceso+"' and  COD_LOTE='"+codLote+"'";
System.out.println("consulta delete registro anterior "+consulta);
con=Util.openConnection(con);
con.setAutoCommit(false);
PreparedStatement pst=con.prepareStatement(consulta);
if(pst.executeUpdate()>0)System.out.println("se elimino un anterior registro");
        consulta="INSERT INTO SEGUIMIENTO_PROCESOS_PREPARADO_LOTE(COD_PROCESO_PRODUCTO,"+
                " COD_SUB_PROCESO_PRODUCTO, COD_PERSONAL, CONFORME, COD_LOTE)"+
                " VALUES ('"+codProceso+"', '"+codSubProceso+"','"+codPersonal+"',"+
                " '"+conforme+"','"+codLote+"')";
System.out.println("consulta insert "+consulta);
pst=con.prepareStatement(consulta);
if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento del proceso para el lote");
out.clear();
//out.println("1");
con.commit();
pst.close();
con.close();
}
catch(Exception ex)
{
    out.clear();
    out.println("Ocurrio un error en el registro,intente de nuevo");
    //ex.printStackTrace();
    con.rollback();
}
finally
{
    con.close();
}
%>
