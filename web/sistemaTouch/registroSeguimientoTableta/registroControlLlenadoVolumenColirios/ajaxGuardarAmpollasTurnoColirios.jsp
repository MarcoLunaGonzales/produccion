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
int codSeguimiento=Integer.valueOf(request.getParameter("codSeguimiento"));
String[] dataAmpollas=request.getParameter("dataAmpollas").split(",");
System.out.println("data "+request.getParameter("dataAmpollas"));
String turno=request.getParameter("turno");
String codPersonalUsuario=request.getParameter("codPersonalUsuario");
boolean administrador=(Integer.valueOf(request.getParameter("admin"))>0);
String[] dataMaquinarias=request.getParameter("dataMaquinarias").split(",");
System.out.println("termino registro");
Connection con=null;
String mensaje="";
try
{
     con=Util.openConnection(con);
     Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
     ResultSet res=null;
     PreparedStatement pst=null;
     con.setAutoCommit(false);
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
     else
     {
         consulta="DELETE SEGUIMIENTO_CONTROL_LLENADO_LOTE_DETALLE  WHERE COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE='"+codSeguimiento+"' AND TURNO='"+turno+"'"+
                 (administrador?"":" and COD_PERSONAL='"+codPersonalUsuario+"'");
         System.out.println("consulta delete "+consulta);
         pst=con.prepareStatement(consulta);
         if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
         consulta="delete SEGUIMIENTO_MAQUINARIAS_CONTROL_LLENADO_VOLUMEN where COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE='"+codSeguimiento+"'" +
                 " and COD_PERSONAL='"+codPersonalUsuario+"'";
         System.out.println("consulta delete "+consulta);
         pst=con.prepareStatement(consulta);
         if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
     }
     for(int i=0;(i<dataAmpollas.length&&dataAmpollas.length>1);i+=6)
     {
        consulta="INSERT INTO SEGUIMIENTO_CONTROL_LLENADO_LOTE_DETALLE(COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE, TURNO, HORA_MUESTRA, VOLUMEN_AMPOLLA1,"+
                 " VOLUMEN_AMPOLLA2, VOLUMEN_AMPOLLA3, VOLUMEN_AMPOLLA4, VOLUMEN_AMPOLLA5,VOLUMEN_AMPOLLA6,COD_PERSONAL)"+
                 " VALUES ('"+codSeguimiento+"','"+turno+"','2012/01/01 "+dataAmpollas[i]+"','"+dataAmpollas[i+1]+"','"+dataAmpollas[i+2]+"','" +
                 dataAmpollas[i+3]+"','"+dataAmpollas[i+4]+"',0,0,'" +
                 dataAmpollas[i+5]+"')";
        System.out.println("consulta insert seguimiento llenado turno "+consulta);
        pst=con.prepareStatement(consulta);
        if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento de control de llenado volumen");
     }
     for(int i=0;(i<dataMaquinarias.length&&dataMaquinarias.length>1);i++)
     {
         if(!dataMaquinarias[i].equals(""))
         {
            consulta="INSERT INTO SEGUIMIENTO_MAQUINARIAS_CONTROL_LLENADO_VOLUMEN("+
                     " COD_SEGUIMIENTO_CONTROL_LLENADO_LOTE, COD_MAQUINA,COD_PERSONAL)"+
                     " VALUES ('"+codSeguimiento+"','"+dataMaquinarias[i]+"','"+codPersonalUsuario+"')";
            System.out.println("consulta insert maquinarias "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento de control de llenado volumen");
         }
     }
     con.commit();
     mensaje=String.valueOf(codSeguimiento);
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
