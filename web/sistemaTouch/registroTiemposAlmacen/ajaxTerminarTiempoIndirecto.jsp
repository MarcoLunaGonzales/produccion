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
String codProgramaProd=request.getParameter("codProgramaProd");
String codLote=request.getParameter("codLote");
String codFormulaMaestra=request.getParameter("codFormulaMaestra");
String codComprod=request.getParameter("codComprod");
String codTipoProgramaProd=request.getParameter("codTipoProgramaProd");
String codActividad=request.getParameter("codActividad");
String codPersonal=request.getParameter("codPersonal");
String fecha=request.getParameter("fecha");
String horaFin=request.getParameter("horaFin");
String horasHombre=request.getParameter("horasHombre");
Connection con=null;
String mensaje="";
try
{   
     con=Util.openConnection(con);
     con.setAutoCommit(false);
     String consulta="";
     consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION" +
             " where  COD_COMPPROD='"+codComprod+"' and"+
             " COD_PROGRAMA_PROD='"+codProgramaProd+"' and" +
             " COD_LOTE_PRODUCCION='"+codLote+"' and  COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'"+
             " and COD_ACTIVIDAD_PROGRAMA='"+codActividad+"'" +
             " and  COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'";
     System.out.println("consulta delete seguimiento programa produccion"+consulta);
     PreparedStatement pst=con.prepareStatement(consulta);
     if(pst.executeUpdate()>0)System.out.println("se elimino el seguimiento progrma ind ");
     String[] arrayFecha=fecha.split("/");
     fecha=arrayFecha[2]+"/"+arrayFecha[1]+"/"+arrayFecha[0];
     consulta="UPDATE SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL SET HORAS_HOMBRE='"+horasHombre+"'," +
             " REGISTRO_CERRADO=1" +
             " ,FECHA_FINAL='"+fecha+" "+horaFin+"'"+
             " WHERE COD_COMPPROD='"+codComprod+"' and"+
             " COD_PROGRAMA_PROD='"+codProgramaProd+"' and" +
             " COD_LOTE_PRODUCCION='"+codLote+"' and  COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'"+
             " and COD_ACTIVIDAD_PROGRAMA='"+codActividad+"'" +
             " and  COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'"+
             " AND  COD_PERSONAL='"+codPersonal+"'" +
             " AND FECHA_INICIO>'"+fecha+" 00:00'" +
             " AND REGISTRO_CERRADO=0";
     System.out.println("consulta registrar inicio"+consulta);
     pst=con.prepareStatement(consulta);
     if(pst.executeUpdate()>0)System.out.println("se registro el inicio");
     consulta="INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION( COD_COMPPROD,  COD_PROGRAMA_PROD,COD_LOTE_PRODUCCION,COD_FORMULA_MAESTRA,"+
              " COD_ACTIVIDAD_PROGRAMA,FECHA_INICIO,FECHA_FINAL,COD_MAQUINA,HORAS_MAQUINA,HORAS_HOMBRE,COD_TIPO_PROGRAMA_PROD)"+
              " select spp.COD_COMPPROD,spp.COD_PROGRAMA_PROD,spp.COD_LOTE_PRODUCCION,spp.COD_FORMULA_MAESTRA,"+
              " spp.COD_ACTIVIDAD_PROGRAMA,MIN(spp.FECHA_INICIO),MAX(spp.FECHA_FINAL),0,0,sum(spp.HORAS_HOMBRE),spp.COD_TIPO_PROGRAMA_PROD"+
              " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL spp where spp.COD_PROGRAMA_PROD='"+codProgramaProd+"'"+
              " and spp.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and spp.COD_COMPPROD='"+codActividad+"'"+
              " and spp.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"' and spp.COD_LOTE_PRODUCCION='"+codLote+"'"+
              " and spp.COD_ACTIVIDAD_PROGRAMA in ("+codActividad+")"+
              " group by spp.COD_PROGRAMA_PROD,spp.COD_FORMULA_MAESTRA,spp.COD_COMPPROD,spp.COD_TIPO_PROGRAMA_PROD,spp.COD_LOTE_PRODUCCION,spp.COD_ACTIVIDAD_PROGRAMA";
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
