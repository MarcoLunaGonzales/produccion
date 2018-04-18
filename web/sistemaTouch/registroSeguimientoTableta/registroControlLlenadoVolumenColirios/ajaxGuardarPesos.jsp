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
String codProgramaProd=request.getParameter("codProgramaProd");
String[] dataLimites=request.getParameter("datosLimite").split(",");
String codPersonalUsuario=request.getParameter("codPersonalUsuario");
Connection con=null;
String mensaje="";
int codSeguimiento=0;
try
{
     con=Util.openConnection(con);
     Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
     ResultSet res=null;
     PreparedStatement pst=null;
     con.setAutoCommit(false);
     System.out.println("cod "+codLote+" cdcd "+codProgramaProd);
     String consulta="select max(s.COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE) as COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE" +
                    " from SEGUIMIENTO_CONTROL_LLENADO_LOTE s where s.COD_LOTE='"+codLote+"' and s.COD_PROGRAMA_PROD='"+codProgramaProd+"'";
     res=st.executeQuery(consulta);
     if(res.next())
     {
         codSeguimiento=res.getInt("COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE");
     }
     
     if(codSeguimiento==0)
     {
         consulta="select isnull(max(scll.COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE),0)+1 as codRegistro from SEGUIMIENTO_CONTROL_LLENADO_LOTE scll";
          res=st.executeQuery(consulta);
          if(res.next())codSeguimiento=res.getInt("codRegistro");
            consulta="INSERT INTO SEGUIMIENTO_CONTROL_LLENADO_LOTE(COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE, COD_LOTE, COD_PROGRAMA_PROD)"+
                    " VALUES ('"+codSeguimiento+"','"+codLote+"','"+codProgramaProd+"')";
            System.out.println("consulta insert "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento");
     }
     consulta="delete SEGUIMIENTO_CONTROL_LLENADO_LOTE_ESP where COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE='"+codSeguimiento+"'";
     System.out.println("consulta delete anteriores especificaciones "+consulta);
     pst=con.prepareStatement(consulta);
     if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
     for(int i=0;(i<dataLimites.length&&dataLimites.length>1);i+=4)
     {
        consulta="INSERT INTO SEGUIMIENTO_CONTROL_LLENADO_LOTE_ESP("+
                 " COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE, COD_TIPO_PROGRAMA_PROD, LIMITE_TEORICO,LIMITE_INFERIOR, LIMITE_SUPERIOR)"+
                 " VALUES ('"+codSeguimiento+"','"+dataLimites[i]+"',"+
                 "'"+dataLimites[i+1]+"','"+dataLimites[i+2]+"','"+dataLimites[i+3]+"')";
        System.out.println("consulta insert seguimiento esp "+consulta);
        pst=con.prepareStatement(consulta);
        if(pst.executeUpdate()>0)System.out.println("se registro la especificacion");
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
catch(Exception ex)
{
    mensaje="Ocurrio un error de informacion al momento de registrar la informacion, comunicar sistemas";
    ex.printStackTrace();
    con.rollback();
}


out.clear();

out.println(mensaje);


%>
