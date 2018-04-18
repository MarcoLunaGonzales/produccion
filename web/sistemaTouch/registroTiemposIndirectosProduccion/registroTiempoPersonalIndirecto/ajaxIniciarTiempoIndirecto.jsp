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
String fechaInicio=request.getParameter("fechaInicio");
String horaInicio=request.getParameter("horaInicio");
Connection con=null;
String mensaje="";
try
{   
     con=Util.openConnection(con);
     SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
     String consulta="SELECT ap.NOMBRE_ACTIVIDAD FROM SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO_PERSONAL s inner join ACTIVIDADES_PRODUCCION ap on"+
                     " s.COD_ACTVIDAD=ap.COD_ACTIVIDAD"+
                     " where s.FECHA_INICIO>'"+sdf.format(new Date())+" 00:00' and s.COD_PERSONAL='"+codPersonal+"'"+
                     " and (s.REGISTRO_CERRADO is null or s.REGISTRO_CERRADO=0)";
     System.out.println("consulta verificar registro indirecto pendiente "+consulta);
     Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
     ResultSet res=st.executeQuery(consulta);
     if(res.next())
     {
             mensaje="No se puede iniciar la actividad porque existe un registro abierto:<br>" +
                     "<b>Actividad Ind.:</b>"+res.getString("NOMBRE_ACTIVIDAD");
     }
     else
     {
             consulta="select s.COD_LOTE_PRODUCCION,ap.NOMBRE_ACTIVIDAD from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s " +
                         " inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA=s.COD_ACTIVIDAD_PROGRAMA"+
                         " inner join ACTIVIDADES_PRODUCCION ap on ap.COD_ACTIVIDAD=afm.COD_ACTIVIDAD " +
                         " where s.COD_PERSONAL='"+codPersonal+"' and s.FECHA_INICIO>'"+sdf.format(new Date())+" 00:00'" +
                         " and (s.REGISTRO_CERRADO=0 or s.REGISTRO_CERRADO is null)";
             System.out.println("consulta verificar registro pendiente "+consulta);
             res=st.executeQuery(consulta);
             if(res.next())
             {
                    mensaje="No se puede iniciar la actividad, porque existe un registro abierto:<br>" +
                    "<b>Lote:</b>"+res.getString("COD_LOTE_PRODUCCION")+"<br>" +
                    "<b>Actividad:</b>"+res.getString("NOMBRE_ACTIVIDAD");
             }
             else
             {
                     mensaje="";
                     con.setAutoCommit(false);
                     String[] arrayFecha=fechaInicio.split("/");
                     fechaInicio=arrayFecha[2]+"/"+arrayFecha[1]+"/"+arrayFecha[0]+" "+horaInicio;
                     consulta="INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO_PERSONAL(COD_PROGRAMA_PROD"+
                                ", COD_ACTVIDAD, COD_AREA_EMPRESA, COD_PERSONAL, FECHA_INICIO, FECHA_FINAL,HORAS_HOMBRE,REGISTRO_CERRADO)"+
                                " VALUES ('"+codProgProd+"','"+codActividad+"','"+codAreaEmpresa+"','"+codPersonal+"',"+
                                "'"+fechaInicio+"','"+fechaInicio+"',0,0)";
                     System.out.println("consulta registrar inicio"+consulta);
                     PreparedStatement pst=con.prepareStatement(consulta);
                     if(pst.executeUpdate()>0)System.out.println("se registro el inicio");
                     con.commit();
                     mensaje="1";
                     pst.close();
             }
     }
     
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
