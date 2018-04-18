<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Enumeration" %>
<%@page import="java.util.Map" %>
<%@page import="java.util.Date" %>
<%@page import="java.net.URLDecoder" %>
<%
String codProgProd=request.getParameter("codProgProd");
String codAreaEmpresa=request.getParameter("codAreaEmpresa");
String codActividad=request.getParameter("codActividad");
String codPersonal=request.getParameter("codPersonal");
String fechaFinal=request.getParameter("fechaInicio");
String horaFinal=request.getParameter("horaInicio");
String horasHombre=request.getParameter("horasHombre");
Connection con=null;
String mensaje="";
try
{   
     con=Util.openConnection(con);
     con.setAutoCommit(false);
     String consulta="";
     consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO where COD_PROGRAMA_PROD = '"+codProgProd+"'"+
              " and COD_AREA_EMPRESA = '"+codAreaEmpresa+"'"+
              " and COD_ACTIVIDAD = '"+codActividad+"'";
     System.out.println("consulta delete seguimiento programa produccion ind"+consulta);
     PreparedStatement pst=con.prepareStatement(consulta);
     if(pst.executeUpdate()>0)System.out.println("se elimino el seguimiento progrma ind ");
     String[] arrayFecha=fechaFinal.split("/");
     fechaFinal=arrayFecha[2]+"/"+arrayFecha[1]+"/"+arrayFecha[0];
     consulta="UPDATE SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO_PERSONAL SET HORAS_HOMBRE='"+horasHombre+"'," +
             " REGISTRO_CERRADO=1" +
             " ,FECHA_FINAL='"+fechaFinal+" "+horaFinal+"'"+
             " WHERE COD_PROGRAMA_PROD='"+codProgProd+"' AND  COD_ACTVIDAD='"+codActividad+"' AND" +
             " COD_AREA_EMPRESA ='"+codAreaEmpresa+"' AND  COD_PERSONAL='"+codPersonal+"'" +
             " AND FECHA_INICIO>'"+fechaFinal+" 00:00'" +
             " AND REGISTRO_CERRADO=0";
     System.out.println("consulta registrar inicio"+consulta);
     pst=con.prepareStatement(consulta);
     if(pst.executeUpdate()>0)System.out.println("se registro el inicio");
     consulta="insert into SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO "+
             " select s.COD_PROGRAMA_PROD,s.COD_ACTVIDAD,1,sum(s.HORAS_HOMBRE),s.COD_AREA_EMPRESA"+
             " from SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO_PERSONAL s where "+
             " s.COD_ACTVIDAD='"+codActividad+"'"+
             " and s.COD_PROGRAMA_PROD='"+codProgProd+"'"+
             " and s.COD_AREA_EMPRESA='"+codAreaEmpresa+"'"+
             " group by s.COD_PROGRAMA_PROD,s.COD_ACTVIDAD,s.COD_AREA_EMPRESA";
     System.out.println("consulta insert seguimiento programa ind "+consulta);
     pst=con.prepareStatement(consulta);
     if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento");
     con.commit();
     mensaje="1";
     pst.close();
     con.close();
}
catch(SQLException ex)
{
    mensaje="Ocurrio un error a la hora del registro intente de nuevo";
    ex.printStackTrace();
    con.rollback();
    con.close();
}
catch(Exception e)
{
    mensaje="Ocurrio un error a la hora del registro intente de nuevo";
    e.printStackTrace();
    con.rollback();
    con.close();

}
out.clear();

out.println(mensaje);


%>