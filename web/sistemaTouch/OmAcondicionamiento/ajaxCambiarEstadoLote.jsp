<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%
String codLote=request.getParameter("codLote");
String codProgramaProd=request.getParameter("codProgramaProd");
String codTipoProgramaProd=request.getParameter("codTipoProgramaProd");
String codCompProd=request.getParameter("codCompProd");
boolean loteHabilitado=(request.getParameter("loteHabilitado").equals("1"));
Connection con=null;
try
{
    con=Util.openConnection(con);
    con.setAutoCommit(false);
    String consulta="delete LOTES_HABILITADOS_ACOND where COD_LOTE_PRODUCCION = '"+codLote+"' and COD_PROGRAMA_PROD='"+codProgramaProd+"'" +
                    " AND COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"' AND COD_COMPPROD='"+codCompProd+"';"+
                    (loteHabilitado?"":" INSERT INTO LOTES_HABILITADOS_ACOND(COD_LOTE_PRODUCCION, COD_PROGRAMA_PROD,COD_TIPO_PROGRAMA_PROD,COD_COMPPROD)"+
                    " VALUES ('"+codLote+"','"+codProgramaProd+"','"+codTipoProgramaProd+"','"+codCompProd+"')");
    System.out.println("consulta habilitar lote "+consulta);
    PreparedStatement pst=con.prepareStatement(consulta);
    if(pst.executeUpdate()>0)System.out.println("se cambio el estado");
    con.commit();
    con.close();
    out.clear();
    out.println("1");
}
catch(SQLException ex)
{
    con.rollback();
    con.close();
    ex.printStackTrace();
    out.println("Ocurrio un error al cambiar el estado, intente de nuevo");
}
%>
