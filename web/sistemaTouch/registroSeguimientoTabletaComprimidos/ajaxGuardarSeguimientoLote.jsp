package sistemaTouch.registroSeguimientoTabletaComprimidos;

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
String codPersonal2=(request.getParameter("personal2")==null)||request.getParameter("personal2")==""?"0":request.getParameter("personal2");
String observaciones=(request.getParameter("observaciones")==null)||request.getParameter("observaciones")==""?"":request.getParameter("observaciones");
Connection con=null;
String mensaje="";
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
                " COD_SUB_PROCESO_PRODUCTO, COD_PERSONAL, CONFORME, COD_LOTE,COD_PERSONAL2,OBSERVACIONES)"+
                " VALUES ('"+codProceso+"', '"+codSubProceso+"','"+codPersonal+"',"+
                " '"+conforme+"','"+codLote+"','"+codPersonal2+"','"+observaciones+"')";
System.out.println("consulta insert "+consulta);
pst=con.prepareStatement(consulta);
if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento del proceso para el lote");

con.commit();
mensaje="1";
pst.close();
con.close();
}
catch(SQLException ex)
{
    
    mensaje="Ocurrio un error en el registro,intente de nuevo";

    con.rollback();
    con.close();
}

catch(Exception ex)
{
    
    mensaje="Ocurrio un error en el registro,intente de nuevo";
    
    con.rollback();
    con.close();
}
out.clear();
out.println(mensaje);
%>


