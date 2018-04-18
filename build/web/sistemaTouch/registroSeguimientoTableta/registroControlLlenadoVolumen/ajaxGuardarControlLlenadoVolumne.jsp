package sistemaTouch.registroSeguimientoTableta.registroDespejeLinea_1;

<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Enumeration" %>
<%@page import="java.util.Map" %>
<%
String codLote=request.getParameter("codLote");
String codProgramaProd=request.getParameter("codProgProd");
String fechaVerificacion=request.getParameter("fechaVerificacion");
String codPersonalDespeje=request.getParameter("codPersonalDespeje");
String codPersonalVerificacion=request.getParameter("codPersonalVerificacion");
String observacion=request.getParameter("observacion");
String[] dataDespeje=request.getParameter("dataDespeje").split(",");
String[] dataUtensilios=request.getParameter("dataUtensilios").split(",");
int codSeguimiento=Integer.valueOf(request.getParameter("codSeguimiento"));
Connection con=null;
String mensaje="";
try
{
     con=Util.openConnection(con);
     Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
     ResultSet res=null;
     PreparedStatement pst=null;
     con.setAutoCommit(false);
     String consulta="";
     String[] fecha=fechaVerificacion.split("/");
     if(codSeguimiento==0)
     {
         consulta="select isnull(max(sdll.COD_SEGUIMIENTO_DESPEJE_LINEA_LOTE),0)+1 as codSeguimientoDespeje"+
                  " from SEGUIMIENTO_DESPEJE_LINEA_LOTE sdll";
          res=st.executeQuery(consulta);
          if(res.next())codSeguimiento=res.getInt("codSeguimientoDespeje");
        consulta="INSERT INTO SEGUIMIENTO_DESPEJE_LINEA_LOTE(COD_LOTE, COD_PROGRAMA_PROD,"+
                 " COD_SEGUIMIENTO_DESPEJE_LINEA_LOTE, FECHA_VERIFICACION,"+
                 " COD_PERSONAL_RESP_DESP_LINEA, COD_PERSONAL_RESP_VERIFICACION, OBSERVACIONES)"+
                 " VALUES ('"+codLote+"','"+codProgramaProd+"','"+codSeguimiento+"',"+
                 " '"+fecha[2]+"/"+fecha[1]+"/"+fecha[0]+"','"+codPersonalDespeje+"',"+
                 " '"+codPersonalVerificacion+"','"+observacion+"')";
        System.out.println("consulta insert "+consulta);
        pst=con.prepareStatement(consulta);
        if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento");

     }
     else
     {
         consulta="UPDATE SEGUIMIENTO_DESPEJE_LINEA_LOTE SET"+
                  " COD_PERSONAL_RESP_DESP_LINEA='"+codPersonalDespeje+"',"+
                  " COD_PERSONAL_RESP_VERIFICACION='"+codPersonalVerificacion+"',"+
                  " OBSERVACIONES='"+observacion+"'"+
                  " WHERE COD_SEGUIMIENTO_DESPEJE_LINEA_LOTE='"+codSeguimiento+"'";
         System.out.println("consulta update "+consulta);
         pst=con.prepareStatement(consulta);
         if(pst.executeUpdate()>0)System.out.println("se actualizo el seguimiento");
         
     }
     consulta="DELETE FROM SEGUIMIENTO_DESPEJE_LINEA_LOTE_VERIF_DESP WHERE COD_SEGUIMIENTO_DESPEJE_LINEA_LOTE='"+codSeguimiento+"'";
     System.out.println("consulta delete "+consulta);
     pst=con.prepareStatement(consulta);
     if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
     for(int i=0;i<dataDespeje.length;i+=4)
     {
         consulta="INSERT INTO SEGUIMIENTO_DESPEJE_LINEA_LOTE_VERIF_DESP("+
                  "  COD_SEGUIMIENTO_DESPEJE_LINEA_LOTE, COD_VERIFICACION_DESPEJE_LINEA_AMBIENTE,"+
                  " PESAJE1, PESAJE2, ESCLUSA)"+
                  " VALUES ('"+codSeguimiento+"',"+
                  "'"+dataDespeje[i]+"','"+dataDespeje[i+1]+"','"+dataDespeje[i+2]+"','"+dataDespeje[i+3]+"')";
         System.out.println("consulta insert seguimiento "+consulta);
         pst=con.prepareStatement(consulta);
         if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento de despeje");
     }
     consulta="DELETE FROM SEGUIMIENTO_DESPEJE_LINEA_LOTE_UTENSILIO WHERE COD_SEGUIMIENTO_DESPEJE_LINEA_LOTE='"+codSeguimiento+"'";
     System.out.println("consulta delete "+consulta);
     pst=con.prepareStatement(consulta);
     if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
     for(int j=0;j<dataUtensilios.length;j+=2)
     {
         consulta="INSERT INTO SEGUIMIENTO_DESPEJE_LINEA_LOTE_UTENSILIO("+
                  " COD_SEGUIMIENTO_DESPEJE_LINEA_LOTE, COD_VERIFICACION_LIMPIEZA_LINEA_AMBIENTE,VERIFICACION_CUMPLIDA)"+
                  " VALUES ('"+codSeguimiento+"','"+dataUtensilios[j]+"','"+dataUtensilios[j+1]+"')";
         System.out.println("consulta insert seguimiento despeje "+consulta);
         pst=con.prepareStatement(consulta);
         if(pst.executeUpdate()>0)System.out.println("se inserto el nuevo seguimiento utensilios");
     }
     con.commit();
     mensaje="1";
     if(res!=null)res.close();
     if(st!=null)st.close();
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
