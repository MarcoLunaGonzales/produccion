<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Enumeration" %>
<%@page import="java.util.Map" %>
<%
String codCompProd=request.getParameter("codComprod");
String codForm=request.getParameter("codForm");
String codLote=request.getParameter("codLote");
String codtipoPP=request.getParameter("codTipoProd");
String codProgProd=request.getParameter("codProgProd");
String codPersonal=request.getParameter("codPersonal");
String[] defectos=request.getParameter("defectos").split(",");
System.out.println(request.getParameter("defectos"));
Connection con=null;
String mensaje="";
try
{
     con=Util.openConnection(con);
     con.setAutoCommit(false);
     String consulta="DELETE DEFECTOS_ENVASE_PROGRAMA_PRODUCCION WHERE "+
                    " COD_PERSONAL = '"+codPersonal+"' and "+
                    " COD_TIPO_PROGRAMA_PROD = '"+codtipoPP+"' and "+
                    " COD_PROGRAMA_PROD = '"+codProgProd+"' and "+
                    " COD_FORMULA_MAESTRA = '"+codForm+"' and "+
                    " COD_LOTE_PRODUCCION = '"+codLote+"' and "+
                    " COD_COMPPROD = '"+codCompProd+"'";
     System.out.println("consulta delete anteriores "+consulta);
     PreparedStatement pst=con.prepareStatement(consulta);
     if(pst.executeUpdate()>0)System.out.println("Se borraron anteriores defectos registrados");
     System.out.println(defectos.length);
     for(int i=0;i<defectos.length && defectos.length>1 ;i+=3)//
     {
         
         consulta="INSERT INTO DEFECTOS_ENVASE_PROGRAMA_PRODUCCION(COD_DEFECTO_ENVASE, COD_PERSONAL"+
                  " , COD_TIPO_PROGRAMA_PROD, COD_PROGRAMA_PROD, COD_FORMULA_MAESTRA,"+
                  " COD_LOTE_PRODUCCION, COD_COMPPROD,"+
                  " CANTIDAD_DEFECTOS_ENCONTRADOS, COD_PERSONAL_OPERARIO)"+
                  " VALUES ('"+defectos[i+1]+"','"+codPersonal+"', '"+codtipoPP+"',"+
                  "'"+codProgProd+"','"+codForm+"','"+codLote+"','"+codCompProd+"',"+
                  "'"+defectos[i+2]+"','"+defectos[i]+"')";
         System.out.println("consulta guardar defectos "+consulta);
         pst=con.prepareStatement(consulta);
         if(pst.executeUpdate()>0)System.out.println("se registro el defecto");
     }
     con.commit();
     mensaje="1";
     pst.close();
     con.close();
}
catch(SQLException ex)
{
    mensaje="Ocurrio un error a la hora del registro,intente de nuevo";
    ex.printStackTrace();
    con.rollback();
    con.close();
}
catch(Exception ex)
{
    mensaje="Ocurrio un error de sistema,intente de nuevo";
    ex.printStackTrace();
    con.rollback();
    con.close();
}

out.clear();

out.println(mensaje);


%>
