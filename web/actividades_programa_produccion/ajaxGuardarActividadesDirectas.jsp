<%@page import="com.cofar.bean.util.correos.EnvioCorreoFechaPesajeFueraDePrograma"%>
<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Enumeration" %>
<%@page import="java.util.Map" %>
<%
String codProgramaProd=request.getParameter("codProgramaProd");
String codActividad=request.getParameter("codActividad");
String codLote=request.getParameter("codLote");
String codCompProd=request.getParameter("codCompProd");
String codFormulaMaestra=request.getParameter("codFormulaMaestra");
String codTipoProgramaProd=request.getParameter("codTipoProgramaProd");
String codAreaEmpresa=request.getParameter("codAreaEmpresa");
String[] dataSeguimiento=request.getParameter("dataSeguimiento").split(",");
String fechaLimite=request.getParameter("fechaLimite");
Connection con=null;
String mensaje="";
EnvioCorreoFechaPesajeFueraDePrograma envioCorreo=null;
try
{
     con=Util.openConnection(con);
     con.setAutoCommit(false);
     String consulta="delete from SEGUIMIENTO_PROGRAMA_PRODUCCION where "+
                     " COD_LOTE_PRODUCCION='"+codLote+"' and "+
                     " COD_PROGRAMA_PROD='"+codProgramaProd+"' and "+
                     " COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and "+
                     " COD_COMPPROD='"+codCompProd+"' and "+
                     " COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"' and COD_ACTIVIDAD_PROGRAMA='"+codActividad+"'";
     System.out.println("consulta delete seguimiento "+consulta);
     PreparedStatement pst=con.prepareStatement(consulta);
     if(pst.executeUpdate()>0)System.out.println("se elimino el detalle "+consulta);
     String[] arrayFecha=fechaLimite.split("/");
     fechaLimite=arrayFecha[2]+"/"+arrayFecha[1]+"/"+arrayFecha[0];
     consulta="delete from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL where "+
             " COD_LOTE_PRODUCCION='"+codLote+"' and "+
             " COD_PROGRAMA_PROD='"+codProgramaProd+"' and "+
             " COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and "+
             " COD_COMPPROD='"+codCompProd+"' and "+
             " COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"' and COD_ACTIVIDAD_PROGRAMA='"+codActividad+"'" +
             " and FECHA_INICIO>='"+fechaLimite+" 00:00'";
     System.out.println("consulta delete seguimiento personal "+consulta);
     pst=con.prepareStatement(consulta);
     if(pst.executeUpdate()>0)System.out.println("se elimino seguimiento personal");
     SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
     for(int i=0;(i<dataSeguimiento.length&&dataSeguimiento.length>1);i+=8)
     {
         arrayFecha=dataSeguimiento[i+1].split("/");
         String fecha=arrayFecha[2]+"/"+arrayFecha[1]+"/"+arrayFecha[0];
         consulta="INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL(COD_COMPPROD,COD_PROGRAMA_PROD, COD_LOTE_PRODUCCION," +
                    " COD_FORMULA_MAESTRA,  COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE," +
                    "  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,fecha_inicio,fecha_final,HORAS_EXTRA,UNIDADES_PRODUCIDAS_EXTRA,REGISTRO_CERRADO) VALUES (" +
                    "  '"+codCompProd+"','"+codProgramaProd+"','"+codLote+"','"+codFormulaMaestra+"'," +
                    " '"+codActividad+"','"+codTipoProgramaProd+"','"+dataSeguimiento[i]+"'," +
                    " (DATEDIFF(minute,'"+fecha+" "+dataSeguimiento[i+2]+"','"+fecha+" "+dataSeguimiento[i+3]+"')/60.0),"+
                    "'"+dataSeguimiento[i+5]+"','"+sdf.format(new Date())+" "+dataSeguimiento[i+2]+"'," +
                    "'"+fecha+" "+dataSeguimiento[i+2]+"','"+fecha+" "+dataSeguimiento[i+3]+"'," +
                    "'"+dataSeguimiento[i+6]+"','"+dataSeguimiento[i+7]+"',1); ";
         System.out.println("consulta insert directo"+consulta);
         pst=con.prepareStatement(consulta);
         if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento ");
     }
     consulta="INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION( COD_COMPPROD,  COD_PROGRAMA_PROD,COD_LOTE_PRODUCCION,COD_FORMULA_MAESTRA,"+
              " COD_ACTIVIDAD_PROGRAMA,FECHA_INICIO,FECHA_FINAL,COD_MAQUINA,HORAS_MAQUINA,HORAS_HOMBRE,COD_TIPO_PROGRAMA_PROD)"+
              " select spp.COD_COMPPROD,spp.COD_PROGRAMA_PROD,spp.COD_LOTE_PRODUCCION,spp.COD_FORMULA_MAESTRA,"+
              " spp.COD_ACTIVIDAD_PROGRAMA,MIN(spp.FECHA_INICIO),MAX(spp.FECHA_FINAL),0,0,sum(spp.HORAS_HOMBRE),spp.COD_TIPO_PROGRAMA_PROD"+
              " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL spp where spp.COD_PROGRAMA_PROD='"+codProgramaProd+"'"+
              " and spp.COD_FORMULA_MAESTRA in ("+codFormulaMaestra+") and spp.COD_COMPPROD in ("+codCompProd+")"+
              " and spp.COD_TIPO_PROGRAMA_PROD in ("+codTipoProgramaProd+") and spp.COD_LOTE_PRODUCCION='"+codLote+"'"+
              " and spp.COD_ACTIVIDAD_PROGRAMA in ("+codActividad+")"+
              " group by spp.COD_PROGRAMA_PROD,spp.COD_FORMULA_MAESTRA,spp.COD_COMPPROD,spp.COD_TIPO_PROGRAMA_PROD,spp.COD_LOTE_PRODUCCION,spp.COD_ACTIVIDAD_PROGRAMA";
     System.out.println("consulta registrar cabecera "+consulta);
     pst=con.prepareStatement(consulta);
     if(pst.executeUpdate()>0)System.out.println("se registro la cabecera");
     consulta="select top 1 * from ACTIVIDADES_FORMULA_MAESTRA a where a.COD_ACTIVIDAD_FORMULA="+codActividad+
              " and a.COD_FORMULA_MAESTRA="+codFormulaMaestra+
              " and a.COD_ACTIVIDAD in (76,186)";
     System.out.println("consulta verificar si es pesaje "+consulta);
     Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
     ResultSet res=st.executeQuery(consulta);
     if(res.next())
     {
         consulta="select top 1 sppp.COD_LOTE_PRODUCCION"+
                   " from PROGRAMA_PRODUCCION_PERIODO ppp inner join SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp on "+
                   " sppp.COD_PROGRAMA_PROD=ppp.COD_PROGRAMA_PROD"+
                   " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=sppp.COD_COMPPROD"+
                   " where sppp.COD_PROGRAMA_PROD="+codProgramaProd+
                   " and sppp.COD_LOTE_PRODUCCION='"+codLote+"'"+
                   " and sppp.COD_ACTIVIDAD_PROGRAMA="+codActividad+
                   " and cp.COD_FORMA<>2 "+
                   " and (ppp.FECHA_INICIO>sppp.FECHA_FINAL or DATEADD(DAY,1,ppp.FECHA_FINAL)<sppp.FECHA_FINAL)";
         System.out.println("consulta verificar registro pesaje dentro de programa "+consulta);
         res=st.executeQuery(consulta);
         if(res.next())
         {
             envioCorreo=new EnvioCorreoFechaPesajeFueraDePrograma(codLote, codProgramaProd, codActividad);
         }
     }
     con.commit();
     mensaje="1";
     pst.close();
     
}
catch(SQLException ex)
{
    mensaje="Ocurrio un error a la hora del registro intente de nuevo";
    ex.printStackTrace();
    con.rollback();
    
}
catch(Exception e)
{
    mensaje="Ocurrio un error al momento de guardar los registros, verifique los datos introducidos";
    e.printStackTrace();
}
finally
{
    con.close();
}
if(envioCorreo!=null)
{
    envioCorreo.start();
}
out.clear();

out.println(mensaje);


%>
