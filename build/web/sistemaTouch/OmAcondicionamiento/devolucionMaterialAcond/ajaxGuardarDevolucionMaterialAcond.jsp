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
Connection con=null;
String mensaje="";
try
{
int codSeguimiento=0;
String codLote=request.getParameter("codLote")==null?"":request.getParameter("codLote");
String codprogramaProd=request.getParameter("codprogramaProd");
String codFormulaMaestra=request.getParameter("codFormulaMaestra");
String codTipoProgramaProd=request.getParameter("codTipoProgramaProd");
String codCompProd=request.getParameter("codCompProd");
String observacion=request.getParameter("observacion");
boolean administrador=(Integer.valueOf(request.getParameter("admin"))>0);
String codPersonalUsuario=request.getParameter("codPersonalUsuario");
String[] dataDevolucion=request.getParameter("dataDevolucion").split(",");
con=Util.openConnection(con);
con.setAutoCommit(false);
String consulta=" select max(s.COD_SEGUIMIENTO_DEVOLUCION_ES_LOTE_ACOND) as codSeguimiento"+
                " from SEGUIMIENTO_DEVOLUCION_ES_LOTE_ACOND s" +
                " where s.COD_PROGRAMA_PROD='"+codprogramaProd+"' and s.COD_LOTE='"+codLote+"'" +
                " and COD_COMPPROD='"+codCompProd+"' and COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'";
System.out.println("consulta buscar codSeguimiento "+consulta);
 PreparedStatement pst=null;
 Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
 ResultSet res=st.executeQuery(consulta);
 if(res.next())
 {
         codSeguimiento=res.getInt("codSeguimiento");
  }
 SimpleDateFormat sdf =new SimpleDateFormat("yyyy/MM/dd HH:mm");
 if(codSeguimiento==0)
 {
    consulta="select isnull(max(s.COD_SEGUIMIENTO_DEVOLUCION_ES_LOTE_ACOND),0)+1 as codSeguimiento from SEGUIMIENTO_DEVOLUCION_ES_LOTE_ACOND s";
    System.out.println("consulta codSeguimiento "+consulta);
    res=st.executeQuery(consulta);
    if(res.next())codSeguimiento=res.getInt("codSeguimiento");

    consulta="INSERT INTO SEGUIMIENTO_DEVOLUCION_ES_LOTE_ACOND(COD_LOTE,COD_PROGRAMA_PROD,COD_COMPPROD,COD_TIPO_PROGRAMA_PROD" +
            ",COD_SEGUIMIENTO_DEVOLUCION_ES_LOTE_ACOND," +
            " COD_ESTADO_HOJA"+
            (administrador?", OBSERVACIONES,COD_PERSONAL_SUPERVISOR, FECHA_CIERRE":"")+" )"+
             " VALUES ('"+codLote+"','"+codprogramaProd+"','"+codCompProd+"','"+codTipoProgramaProd+"','"+codSeguimiento+"',0"+
            (administrador?",?,'"+codPersonalUsuario+"','"+sdf.format(new Date())+"'":"")+")";
        System.out.println("consulta insert "+consulta);
        pst=con.prepareStatement(consulta);
        if(administrador)pst.setString(1,observacion);
        if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento");
     }
     else
     {
         if(administrador)
         {
             consulta="UPDATE SEGUIMIENTO_DEVOLUCION_ES_LOTE_ACOND"+
                      " SET OBSERVACIONES = ?,"+
                      "FECHA_CIERRE = '"+sdf.format(new Date())+"',"+
                      " COD_ESTADO_HOJA = 0"+
                      " ,COD_PERSONAL_SUPERVISOR='"+codPersonalUsuario+"'"+
                      " WHERE COD_SEGUIMIENTO_DEVOLUCION_ES_LOTE_ACOND ='"+codSeguimiento+"'";
             System.out.println("consulta update seguimiento "+consulta);
             pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se modifico la cabecera de devolucion");
         }
         
     }
    if(!administrador)
    {
         consulta="delete SEGUIMIENTO_DEVOLUCION_ES_LOTE_ACOND_MATERIALES  where COD_SEGUIMIENTO_DEVOLUCION_ES_LOTE_ACOND='"+codSeguimiento+"'"+
                  " and COD_PERSONAL='"+codPersonalUsuario+"'";

         System.out.println("consulta delete anteriores devoluciones "+consulta);
         pst=con.prepareStatement(consulta);
         if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros "+consulta);
         for(int i=0;(i<dataDevolucion.length&&dataDevolucion.length>1);i+=5)
         {
             consulta="INSERT INTO SEGUIMIENTO_DEVOLUCION_ES_LOTE_ACOND_MATERIALES("+
                      " COD_SEGUIMIENTO_DEVOLUCION_ES_LOTE_ACOND, CANTIDAD_DEVUELTA, CANTIDAD_FRV,CANTIDAD_FRV_PROVEEDOR,"+
                      " COD_PERSONAL, OBSERVACIONES, COD_MATERIAL)"+
                      " VALUES ('"+codSeguimiento+"','"+dataDevolucion[i]+"',"+
                      " '"+dataDevolucion[i+1]+"','"+dataDevolucion[i+2]+"','"+codPersonalUsuario+"',?, '"+dataDevolucion[i+4]+"');";
            System.out.println("consulta insert seguimiento ampollas lavado "+consulta);
            pst=con.prepareStatement(consulta);
            pst.setString(1,dataDevolucion[i+3]);
            if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento de ampollas");
            
         }
       
    }
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
