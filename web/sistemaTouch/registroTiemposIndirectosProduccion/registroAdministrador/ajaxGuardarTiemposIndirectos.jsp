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
String[] dataTiempos=request.getParameter("dataTiempos").split(",");
Connection con=null;
String mensaje="";
try
{   
     con=Util.openConnection(con);
     
     con.setAutoCommit(false);
     String consulta="";
     SimpleDateFormat sdf= new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
     consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO where COD_PROGRAMA_PROD = '"+codProgProd+"'"+
              " and COD_AREA_EMPRESA = '"+codAreaEmpresa+"'"+
              " and COD_ACTIVIDAD = '"+codActividad+"'";
     System.out.println("consulta delete seguimiento programa produccion ind"+consulta);
     PreparedStatement pst=con.prepareStatement(consulta);
     if(pst.executeUpdate()>0)System.out.println("se elimino el seguimiento progrma ind ");

     consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO_PERSONAL where COD_PROGRAMA_PROD = '"+codProgProd+"'"+
              " and COD_AREA_EMPRESA = '"+codAreaEmpresa+"'"+
              " and COD_ACTVIDAD = '"+codActividad+"'";
     System.out.println("consulta delete seguimiento programa produccion  per ind"+consulta);
     pst=con.prepareStatement(consulta);
     if(pst.executeUpdate()>0)System.out.println("se elimino el seguimiento progrma per ind ");
     for(int i=0;(i<dataTiempos.length&&dataTiempos.length>1);i+=6)
     {
        String[] aux=dataTiempos[i+1].split("/");
        String fechaInicio=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataTiempos[i+2];
        String fechaFinal=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataTiempos[i+3];
        consulta="INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO_PERSONAL(COD_PROGRAMA_PROD"+
                ", COD_ACTVIDAD, COD_AREA_EMPRESA, COD_PERSONAL, FECHA_INICIO, FECHA_FINAL,HORAS_HOMBRE,REGISTRO_CERRADO)"+
                " VALUES ('"+codProgProd+"','"+codActividad+"','"+codAreaEmpresa+"','"+dataTiempos[i]+"',"+
                "'"+fechaInicio+"','"+fechaFinal+"','"+dataTiempos[i+4]+"','"+dataTiempos[i+5]+"')";
        System.out.println("consulta insert seguimiento indirecto "+consulta);
        pst=con.prepareStatement(consulta);
        if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento ind personal");
     }
     
            consulta="insert into SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO "+
                     " select s.COD_PROGRAMA_PROD,s.COD_ACTVIDAD,1,sum(s.HORAS_HOMBRE),s.COD_AREA_EMPRESA"+
                     " from SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO_PERSONAL s where "+
                     " s.COD_ACTVIDAD='"+codActividad+"'"+
                     " and s.COD_PROGRAMA_PROD='"+codProgProd+"'"+
                     " and s.COD_AREA_EMPRESA='"+codAreaEmpresa+"'"+
                     " group by s.COD_PROGRAMA_PROD,s.COD_ACTVIDAD,s.COD_AREA_EMPRESA";
            System.out.println("consulta insert seguimiento programa ind "+consulta);
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
