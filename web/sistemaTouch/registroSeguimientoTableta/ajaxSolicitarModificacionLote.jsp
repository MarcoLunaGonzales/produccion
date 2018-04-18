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
        case 1:consulta="update SEGUIMIENTO_LIMPIEZA_LOTE set COD_ESTADO_HOJA=1" +
                        " where COD_LOTE='"+codLote+"' and COD_PROGRAMA_PROD='"+codProgramaProd+"'";
               break;
        case 2:consulta="update SEGUIMIENTO_REPESADA_LOTE set COD_ESTADO_HOJA=1"+
                        " WHERE COD_LOTE='"+codLote+"' AND COD_PROGRAMA_PROD='"+codProgramaProd+"'";
                        break;
        case 3:consulta="update SEGUIMIENTO_LAVADO_LOTE set COD_ESTADO_HOJA=1"+
                        " WHERE COD_LOTE='"+codLote+"' AND COD_PROGRAMA_PROD='"+codProgramaProd+"'";
                        break;
        case 4:consulta="update SEGUIMIENTO_DESPIROGENIZADO_LOTE set COD_ESTADO_HOJA=1"+
                        " WHERE COD_LOTE='"+codLote+"' AND COD_PROGRAMA_PROD='"+codProgramaProd+"'";
                        break;
        case 5:consulta="update SEGUIMIENTO_PREPARADO_LOTE set COD_ESTADO_HOJA=1"+
                        " WHERE COD_LOTE='"+codLote+"' AND COD_PROGRAMA_PROD='"+codProgramaProd+"'";
                        break;
        case 6:consulta="update SEGUIMIENTO_DOSIFICADO_LOTE set COD_ESTADO_HOJA=1"+
                        " WHERE COD_LOTE='"+codLote+"' AND COD_PROGRAMA_PROD='"+codProgramaProd+"'";
                        break;
        case 7:consulta="update SEGUIMIENTO_CONTROL_LLENADO_LOTE set COD_ESTADO_HOJA=1"+
                        " WHERE COD_LOTE='"+codLote+"' AND COD_PROGRAMA_PROD='"+codProgramaProd+"'";
                        break;
        case 8:consulta="UPDATE SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE  SET COD_ESTADO_HOJA=1 " +
                        " WHERE COD_LOTE='"+codLote+"' AND COD_PROGRAMA_PROD='"+codProgramaProd+"'";
                        break;
        case 9:consulta="UPDATE SEGUIMIENTO_RENDIMIENTO_DOSIFICADO_LOTE set COD_ESTADO_HOJA=1"+
                        " where COD_LOTE='"+codLote+"' AND COD_PROGRAMA_PROD='"+codProgramaProd+"'";
                        break;
        case 10:consulta="UPDATE SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE set COD_ESTADO_HOJA=1"+
                        " where COD_LOTE='"+codLote+"' AND COD_PROGRAMA_PROD='"+codProgramaProd+"'";
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
