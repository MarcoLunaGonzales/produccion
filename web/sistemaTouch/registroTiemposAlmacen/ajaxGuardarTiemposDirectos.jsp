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
String codFormulaMaestra=request.getParameter("codFormulaMaestra");
String codComprod=request.getParameter("codComprod");
String codLote=request.getParameter("codLote");
String codTipoProgramaProd=request.getParameter("codTipoProgramaProd");
String codActividad=request.getParameter("codActividad");
String[] dataTiempos=request.getParameter("dataTiempos").split(",");
Connection con=null;
String mensaje="";
try
{   
     con=Util.openConnection(con);
     con.setAutoCommit(false);
     String consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION" +
                     " where  COD_COMPPROD='"+codComprod+"' and"+
                     " COD_PROGRAMA_PROD='"+codProgramaProd+"' and" +
                     " COD_LOTE_PRODUCCION='"+codLote+"' and  COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'"+
                     " and COD_ACTIVIDAD_PROGRAMA='"+codActividad+"'" +
                     " and  COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'";
     System.out.println("consulta delete seguimiento programa produccion"+consulta);
     PreparedStatement pst=con.prepareStatement(consulta);
     if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
     consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL" +
                     " where  COD_COMPPROD='"+codComprod+"' and"+
                     " COD_PROGRAMA_PROD='"+codProgramaProd+"' and" +
                     " COD_LOTE_PRODUCCION='"+codLote+"' and  COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'"+
                     " and COD_ACTIVIDAD_PROGRAMA='"+codActividad+"'" +
                     " and  COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'";
     System.out.println("consulta delete seguimiento programa produccion"+consulta);
     pst=con.prepareStatement(consulta);
     if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros personal");
     for(int i=0;(i<dataTiempos.length&&dataTiempos.length>2);i+=6)
     {
         String[] fechaArray=dataTiempos[i+1].split("/");
         String fecha=fechaArray[2]+"/"+fechaArray[1]+"/"+fechaArray[0];
            consulta="INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL(COD_COMPPROD,"+
                      " COD_PROGRAMA_PROD, COD_LOTE_PRODUCCION, COD_FORMULA_MAESTRA,"+
                      " COD_ACTIVIDAD_PROGRAMA, COD_TIPO_PROGRAMA_PROD, COD_PERSONAL, HORAS_HOMBRE,"+
                      " UNIDADES_PRODUCIDAS, FECHA_REGISTRO, FECHA_INICIO, FECHA_FINAL"+
                      " ,REGISTRO_CERRADO, COD_FRACCION_OM)"+
                      " VALUES ('"+codComprod+"','"+codProgramaProd+"','"+codLote+"','"+codFormulaMaestra+"',"+
                      " '"+codActividad+"','"+codTipoProgramaProd+"','"+dataTiempos[i]+"','"+dataTiempos[i+4]+"',"+
                      " 0,'"+fecha+" "+dataTiempos[i+2]+"','"+fecha+" "+dataTiempos[i+2]+"','"+fecha+" "+dataTiempos[i+3]+"'"+
                      " ,'"+dataTiempos[i+5]+"',0)";
             System.out.println("consulta insertar registro "+consulta);
             pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se registro el tiempo de personal");
      }
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
