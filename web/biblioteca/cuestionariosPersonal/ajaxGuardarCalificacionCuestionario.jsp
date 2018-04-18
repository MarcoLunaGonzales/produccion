
<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>
<%
String codCuestionario=request.getParameter("codCuestionario");
String calificacion=request.getParameter("calificacion");
String[] arrayCalificacion=calificacion.split(",");
Connection con=null;
try
{
con=Util.openConnection(con);
con.setAutoCommit(false);
String consulta="delete CALIFICACION_RESPUESTAS_CUESTIONARIO_PERSONAL where COD_CUESTIONARIO='"+codCuestionario+"'";
System.out.println("consulta delete calificacion res "+consulta);
PreparedStatement pst=con.prepareStatement(consulta);
if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores calificaciones");
for(int i=0;i<arrayCalificacion.length;i+=2)
{
    consulta="INSERT INTO CALIFICACION_RESPUESTAS_CUESTIONARIO_PERSONAL(COD_CUESTIONARIO,"+
            " COD_PREGUNTA, CALIFICACION)"+
            " VALUES ('"+codCuestionario+"','"+Integer.valueOf(arrayCalificacion[i])+"','"+Double.valueOf(arrayCalificacion[i+1])+"')";
    System.out.println("consulta insert calificacion "+consulta);
    pst=con.prepareStatement(consulta);
    if(pst.executeUpdate()>0)System.out.println("se registro la calificacion para la respuesta ");
}
SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
consulta="update CUESTIONARIOS_PERSONAL  set FECHA_REVISION='"+sdf.format(new Date())+"'  where COD_CUESTIONARIO_PERSONAL='"+codCuestionario+"'";
System.out.println("consulta actualizar cuestionario "+consulta);
pst=con.prepareStatement(consulta);
if(pst.executeUpdate()>0)System.out.println("se actualizo el cuestionario");
con.commit();
out.println("1");
pst.close();
con.close();
}
catch(Exception ex)
{
    out.clear();
    out.println("Ocurrio un error en el registro,intente de nuevo");
    
    con.rollback();
    ex.printStackTrace();
}
finally
{
    con.close();
}
%>


