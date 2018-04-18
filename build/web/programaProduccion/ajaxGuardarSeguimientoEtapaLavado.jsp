package programaProduccion;

<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Enumeration" %>
<%@page import="java.util.Map" %>
<%

String[] codEspecificacion=request.getParameter("especificacionesLavado").split(",");
String[] especificacionesRecepcion=request.getParameter("espRecepcion").split(",");
String codLote=request.getParameter("codLote")==null?"":request.getParameter("codLote");
String fechaRegistro=request.getParameter("fechaRegistro");
String observacion=request.getParameter("observacion");
String codpersonaljefe=request.getParameter("codPersonalJefe");
String codPersonalRecepcion=request.getParameter("codPersonalRecepcion");
Connection con=null;
String mensaje="";
try
{
     con=Util.openConnection(con);
     con.setAutoCommit(false);
     String consulta="delete SEGUIMIENTO_ESPECIFICACIONES_LAVADO_LOTE where COD_LOTE='"+codLote+"'";
     System.out.println("consulta delete anteriores "+consulta);
     PreparedStatement pst=con.prepareStatement(consulta);
     if(pst.executeUpdate()>0)System.out.println("Se borraron anteriores especificaciones");
     for(int i=0;i<codEspecificacion.length;i+=3)
     {
         consulta="INSERT INTO SEGUIMIENTO_ESPECIFICACIONES_LAVADO_LOTE(COD_LOTE,COD_ESPECIFICACION_PROCESO, CONFORME, OBSERVACION)"+
                  " VALUES ('"+codLote+"','"+codEspecificacion[i]+"','"+codEspecificacion[i+1]+"','"+((i+2>=codEspecificacion.length)?"":codEspecificacion[i+2])+"')";
         System.out.println("consulta guardar Seguimiento"+consulta);
         pst=con.prepareStatement(consulta);
         if(pst.executeUpdate()>0)System.out.println("se registro la especificacion");
     }
     consulta="delete SEGUIMIENTO_RECEPCION_LAVADO_LOTE where cod_lote='"+codLote+"'";
     System.out.println("consulta delete recepcion aterior "+consulta);
     pst=con.prepareStatement(consulta);
     if(pst.executeUpdate()>0)System.out.println("se eliminaron registros anteriores");
     for(int i =0;i<especificacionesRecepcion.length;i+=3)
     {
         consulta="INSERT INTO SEGUIMIENTO_RECEPCION_LAVADO_LOTE(COD_LOTE, NRO_SECUENCIA, CONFORME,OBSERVACION)"+
                  " VALUES ('"+codLote+"','"+especificacionesRecepcion[i]+"','"+especificacionesRecepcion[i+1]+"','"+((i+2>=especificacionesRecepcion.length)?"":especificacionesRecepcion[i+2])+"')";
         System.out.println("consulta insert recepcion "+consulta);
         pst=con.prepareStatement(consulta);
         if(pst.executeUpdate()>0)System.out.println("se registro la recepcion correctamente");
     }
     String[] fecha=fechaRegistro.split("/");
     consulta="delete SEGUIMIENTO_LAVADO_LOTE where cod_lote='"+codLote+"';" +
             " INSERT INTO SEGUIMIENTO_LAVADO_LOTE(COD_LOTE, COD_PERSONAL_ENCARGADO_RECEPCION,"+
             " OBSERVACIONES, COD_PERSONAL_JEFE_PRODUCCION, FECHA)"+
             " VALUES ('"+codLote+"', '"+codPersonalRecepcion+"', '"+observacion+"',"+
             " '"+codpersonaljefe+"', '"+fecha[2]+"/"+fecha[1]+"/"+fecha[0]+" 00:00:00')";
     System.out.println("consulta registrar seguimiento "+consulta);
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
    
}
out.clear();

out.println(mensaje);


%>
