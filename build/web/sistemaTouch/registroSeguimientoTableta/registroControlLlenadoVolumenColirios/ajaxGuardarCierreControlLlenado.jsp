package sistemaTouch.registroSeguimientoTableta.registroControlLlenadoVolumen_1;

<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Enumeration" %>
<%@page import="java.util.Map" %>
<%@page import="java.util.Date" %>
<%
String codLote=request.getParameter("codLote");
String codProgramaProd=request.getParameter("codProgProd");
int codSeguimiento=Integer.valueOf(request.getParameter("codSeguimiento"));
String codPersonalSupervisor=request.getParameter("codPersonalSupervisor");
String observaciones=request.getParameter("observaciones");
Connection con=null;
String mensaje="";
try
{
     con=Util.openConnection(con);
     Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
     ResultSet res=null;
     PreparedStatement pst=null;
     con.setAutoCommit(false);
     String consulta="select max(s.COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE) as codSeguimiento from SEGUIMIENTO_CONTROL_LLENADO_LOTE s" +
                    " where s.cod_lote='"+codLote+"' and s.COD_PROGRAMA_PROD='"+codProgramaProd+"'";
     res=st.executeQuery(consulta);
     SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
     if(res.next())
     {
         codSeguimiento=res.getInt("codSeguimiento");
     }
     if(codSeguimiento==0)
     {

         consulta="select isnull(max(scll.COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE),0)+1 as codRegistro from SEGUIMIENTO_CONTROL_LLENADO_LOTE scll";
          res=st.executeQuery(consulta);
          if(res.next())codSeguimiento=res.getInt("codRegistro");
            consulta="INSERT INTO SEGUIMIENTO_CONTROL_LLENADO_LOTE(COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE, COD_LOTE, COD_PROGRAMA_PROD,COD_PERSONAL_SUPERVISOR,OBSERVACION," +
                    "COD_ESTADO_HOJA,FECHA_CIERRE)"+
                    " VALUES (?,?,?,?,?,?,?)";
            pst=con.prepareStatement(consulta);
            pst.setInt(1, codSeguimiento);
            pst.setString(2,codLote);
            pst.setString(3,codProgramaProd);
            pst.setString(4,codPersonalSupervisor);
            pst.setString(5,observaciones);
            pst.setInt(6,0);
            pst.setString(7,sdf.format(new Date()));
            if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento");
     }
     else
     {
         consulta="UPDATE SEGUIMIENTO_CONTROL_LLENADO_LOTE"+
                  " SET COD_PERSONAL_SUPERVISOR =?,"+
                  " OBSERVACION = ?"+
                  ",COD_ESTADO_HOJA=0"+
                  ",FECHA_CIERRE='"+sdf.format(new Date())+"'"+
                  " WHERE COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE =?";
         pst=con.prepareStatement(consulta);
         pst.setString(1,codPersonalSupervisor);
         pst.setString(2,observaciones);
         pst.setInt(3,codSeguimiento);
         if(pst.executeUpdate()>0)System.out.println("se cerro la hoja");
     }
     con.commit();
     mensaje=String.valueOf(codSeguimiento);
     if(res!=null)res.close();
     if(st!=null)st.close();
     if(pst!=null)pst.close();
     con.close();
}
catch(SQLException ex)
{
    mensaje="Ocurrio un error a la hora del registro intente de nuevo";
    ex.printStackTrace();
    con.rollback();
}
catch(Exception ex)
{
    mensaje="Ocurrio un error de informacion al momento de registrar la informacion, comunicar sistemas";
    ex.printStackTrace();
    con.rollback();
}


out.clear();

out.println(mensaje);


%>
