<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>
<%
String codLote=request.getParameter("codLote");
String codProgramaProd=request.getParameter("codProgramaProd");
String codPersonalUsuario=request.getParameter("codPersonalUsuario");
int codHoja=Integer.valueOf(request.getParameter("codHoja"));

try
{

    Connection con=null;
    con=Util.openConnection(con);
    con.setAutoCommit(false);
    String consulta="";
    System.out.println("COD "+codHoja);
    switch(codHoja)
    {
        case 3:consulta="INSERT INTO SEGUIMIENTO_LAVADO_LOTE(COD_LOTE, COD_PROGRAMA_PROD, COD_SEGUIMIENTO_LAVADO_LOTE,COD_PERSONAL_APRUEBA_DESPEJE)" +
                        "VALUES('"+codLote+"',"+codProgramaProd+",(select isnull(max(COD_SEGUIMIENTO_LAVADO_LOTE),0)+1 from SEGUIMIENTO_LAVADO_LOTE),'"+codPersonalUsuario+"')";
                        break;
        case 5:consulta="INSERT INTO SEGUIMIENTO_PREPARADO_LOTE(COD_LOTE, COD_PROGRAMA_PROD,COD_PERSONAL_APRUEBA_DESPEJE)"+
                        "values('"+codLote+"',"+codProgramaProd+","+codPersonalUsuario+")";
                        break;
        case 6:consulta="INSERT INTO SEGUIMIENTO_DOSIFICADO_LOTE(COD_LOTE, COD_PROGRAMA_PROD,COD_SEGUIMIENTO_DOSIFICADO_LOTE,COD_PERSONAL_APRUEBA_DESPEJE)" +
                        "values('"+codLote+"',"+codProgramaProd+",(select isnull(MAX(COD_SEGUIMIENTO_DOSIFICADO_LOTE),0)+1 from SEGUIMIENTO_DOSIFICADO_LOTE),'"+codPersonalUsuario+"')";
                        break;
        case 10:consulta=" INSERT INTO SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE(COD_LOTE, COD_PROGRAMA_PROD,COD_SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE,COD_PERSONAL_APRUEBA_DESPEJE)" +
                        "  values('"+codLote+"',"+codProgramaProd+",(select isnull(MAX(COD_SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE),0)+1 from SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE),'"+codPersonalUsuario+"')";
                        break;
    }
    System.out.println("consulta solicitar modificacion "+consulta);
    PreparedStatement pst=con.prepareStatement(consulta);
    if(pst.executeUpdate()>0){System.out.println("se solicito la edicion");
    out.clear();
    out.println("1");
    };
    con.commit();
    pst.close();
    con.close();
    
}
catch(SQLException ex)
{
    ex.printStackTrace();
}
%>
