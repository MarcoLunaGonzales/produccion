package sistemaTouch.registroSeguimientoTabletaComprimidos;

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
String codPersonal=request.getParameter("codPersonal");
String fecha=request.getParameter("fecha");
String horaInicio=request.getParameter("horaInicio");
Connection con=null;
String mensaje="";
try
{   
     con=Util.openConnection(con);
     con.setAutoCommit(false);
     String[] arrayFecha=fecha.split("/");
     fecha=arrayFecha[2]+"/"+arrayFecha[1]+"/"+arrayFecha[0];
     String consulta="INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL(COD_COMPPROD,"+
                      " COD_PROGRAMA_PROD, COD_LOTE_PRODUCCION, COD_FORMULA_MAESTRA,"+
                      " COD_ACTIVIDAD_PROGRAMA, COD_TIPO_PROGRAMA_PROD, COD_PERSONAL, HORAS_HOMBRE,"+
                      " UNIDADES_PRODUCIDAS, FECHA_REGISTRO, FECHA_INICIO, FECHA_FINAL"+
                      " ,REGISTRO_CERRADO, COD_FRACCION_OM)"+
                      " VALUES ('"+codComprod+"','"+codProgramaProd+"','"+codLote+"','"+codFormulaMaestra+"',"+
                      " '"+codActividad+"','"+codTipoProgramaProd+"','"+codPersonal+"',0,"+
                      " 0,'"+fecha+" "+horaInicio+"','"+fecha+" "+horaInicio+"','"+fecha+" "+horaInicio+"'"+
                      " ,0,0)";
     System.out.println("consulta insertar registro "+consulta);
     PreparedStatement pst=con.prepareStatement(consulta);
     if(pst.executeUpdate()>0)System.out.println("se elimino el seguimiento progrma ind ");
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
