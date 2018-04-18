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
int codSeguimiento=0;
//datos lote
String codLote=request.getParameter("codLote")==null?"":request.getParameter("codLote");
String codprogramaProd=request.getParameter("codProgramaProd");
String codFormulaMaestra=request.getParameter("codFormulaMaestra");
String codTipoProgramaProd=request.getParameter("codTipoProgramaProd");
String codCompProd=request.getParameter("codCompProd");
//datos materiales
String[] dataMateriales=request.getParameter("dataMateriales").split(",");
try
{

con=Util.openConnection(con);
con.setAutoCommit(false);
String consulta="select max(s.COD_SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND) AS codSeguimiento"+
                " from SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND s where s.cod_lote='"+codLote+"'" +
                " and s.cod_programa_prod='"+codprogramaProd+"'" +
                " and s.COD_COMPPROD='"+codCompProd+"' and s.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'";
System.out.println("consulta buscar codSeguimiento "+consulta);
 PreparedStatement pst=null;
 Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
 ResultSet res=st.executeQuery(consulta);
 if(res.next())codSeguimiento=res.getInt("codSeguimiento");
 SimpleDateFormat sdf =new SimpleDateFormat("yyyy/MM/dd HH:mm");
 if(codSeguimiento==0)
 {
    consulta="select isnull(max(s.COD_SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND),0)+1  as codSeguimiento from SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND s ";
    System.out.println("consulta codSeguimiento "+consulta);
    res=st.executeQuery(consulta);
    if(res.next())codSeguimiento=res.getInt("codSeguimiento");
    consulta="INSERT INTO SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND(COD_LOTE, COD_PROGRAMA_PROD,COD_COMPPROD,COD_TIPO_PROGRAMA_PROD,"+
             " COD_SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND, COD_ESTADO_HOJA)"+
             " VALUES ('"+codLote+"','"+codprogramaProd+"','"+codCompProd+"','"+codTipoProgramaProd+"','"+codSeguimiento+"',0)";
        System.out.println("consulta insert "+consulta);
        pst=con.prepareStatement(consulta);
        if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento");
  }
 consulta="delete SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND_MAT_TIM where COD_SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND='"+codSeguimiento+"'";
 System.out.println("consulta registrar materiales habilitados "+consulta);
 pst=con.prepareStatement(consulta);
 if(pst.executeUpdate()>0)System.out.println("se eliminaron los registros");
 for(int i=0;i<dataMateriales.length;i++)
 {
     if(!dataMateriales[i].equals(""))
     {
         consulta="INSERT INTO SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND_MAT_TIM("+
                  " COD_SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND, COD_MATERIAL)"+
                  " VALUES ('"+codSeguimiento+"','"+dataMateriales[i]+"')";
         System.out.println("consulta insert permiso "+consulta);
         pst=con.prepareStatement(consulta);
         if(pst.executeUpdate()>0)System.out.println("se registro el timbrado");
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
