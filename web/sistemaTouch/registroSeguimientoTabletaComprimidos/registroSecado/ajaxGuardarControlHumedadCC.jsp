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
String codTipoProgramaProd=request.getParameter("codTipoProgramaProd");
String codCompProd=request.getParameter("codCompProd");
String codLote=request.getParameter("codLote");
String codFormula=request.getParameter("codFormula");
String codProgProd=request.getParameter("codProgProd");
String codFraccionTrabajo=request.getParameter("codFraccionTrabajo");
String[] dataControlCC=request.getParameter("dataControlCC").split(",");
String observaciones=request.getParameter("observacion");
String codActividadVerificacionHumedad=request.getParameter("codActividadVerificacionHumedad");

int codSeguimiento=0;
String codPersonalUsuario=request.getParameter("codPersonalUsuario");
boolean administrador=(Integer.valueOf(request.getParameter("admin"))>0);
Connection con=null;
String mensaje="";
try
{
     con=Util.openConnection(con);
     
     PreparedStatement pst=null;
     con.setAutoCommit(false);
     String consulta="";
     SimpleDateFormat sdf= new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
     consulta="SELECT MAX(S.COD_SEGUIMIENTO_SECADO_LOTE) as codSeguimiento FROM SEGUIMIENTO_SECADO_LOTE S WHERE S.COD_PROGRAMA_PROD='"+codProgProd+"' AND S.COD_LOTE='"+codLote+"'";
     Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
     ResultSet res=st.executeQuery(consulta);
     if(res.next())codSeguimiento=res.getInt("codSeguimiento");
     consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION where COD_PROGRAMA_PROD='"+codProgProd+"'"+
              " and COD_LOTE_PRODUCCION='"+codLote+"' and COD_COMPPROD='"+codCompProd+"'"+
              " and COD_FORMULA_MAESTRA='"+codFormula+"' and COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'" +
              " and  COD_ACTIVIDAD_PROGRAMA in("+codActividadVerificacionHumedad+")";
     System.out.println("consulta delete seguimiento anterior "+consulta);
     pst=con.prepareStatement(consulta);
     if(pst.executeUpdate()>0)System.out.println("se eliminaron registros anteriores de seguimiento programa produccion");
     consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL where COD_PROGRAMA_PROD='"+codProgProd+"'"+
              " and COD_LOTE_PRODUCCION='"+codLote+"' and COD_COMPPROD='"+codCompProd+"'"+
              " and COD_FORMULA_MAESTRA='"+codFormula+"' and COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'" +
              " and COD_FRACCION_OM="+codFraccionTrabajo+" and "+
              " COD_ACTIVIDAD_PROGRAMA in ("+codActividadVerificacionHumedad+")";
     System.out.println("consulta delete seguimiento personal "+consulta);
     pst=con.prepareStatement(consulta);
     if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
     consulta="delete SEGUIMIENTO_SECADO_LOTE_CC  where COD_PERSONAL='"+codPersonalUsuario+"'" +
             " and COD_SEGUIMIENTO_SECADO_LOTE='"+codSeguimiento+"'"+
              " and COD_FRACCION_OM='"+codFraccionTrabajo+"'";
     System.out.println("consulta delete anteriores aprobaciones "+consulta);
     pst=con.prepareStatement(consulta);
     if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
     for(int i=0;(i<dataControlCC.length&&dataControlCC.length>1);i+=7)
     {
        String[] aux=dataControlCC[i].split("/");
        String fechaInicio=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataControlCC[i+1];
        String fechaFinal=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataControlCC[i+2];

        consulta = " INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL( COD_COMPPROD,  COD_PROGRAMA_PROD,  COD_LOTE_PRODUCCION,  COD_FORMULA_MAESTRA," +
                    "  COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE,  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,  FECHA_INICIO," +
                    "  FECHA_FINAL,HORAS_EXTRA,UNIDADES_PRODUCIDAS_EXTRA,COD_REGISTRO_ORDEN_MANUFACTURA,REGISTRO_CERRADO,COD_FRACCION_OM)" +
                    " VALUES ( '"+codCompProd+"'," +
                    "'"+codProgProd+"','"+codLote+"'," +
                    "'"+codFormula+"','"+codActividadVerificacionHumedad+"'," +
                    " '"+codTipoProgramaProd+"'," +
                    " '"+codPersonalUsuario+"','"+dataControlCC[i+3]+"','0'" +
                    ",'"+fechaInicio+":00','"+fechaInicio+":00','"+fechaFinal+":00'" +
                    ",'0','0','"+(i+1)+"','"+dataControlCC[i+4]+"','"+codFraccionTrabajo+"')";
        System.out.println("consulta insert seguimiento programa produccion personal "+consulta);
        pst=con.prepareStatement(consulta);
        if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento Personal");
        consulta="INSERT INTO SEGUIMIENTO_SECADO_LOTE_CC(COD_SEGUIMIENTO_SECADO_LOTE,"+
                 " COD_FRACCION_OM, COD_PERSONAL, COD_REGISTRO_ORDEN_MANUFACTURA, PORCIENTO_HUMEDAD, HUMEDAD_APROBADA)"+
                 " VALUES ('"+codSeguimiento+"','"+codFraccionTrabajo+"','"+codPersonalUsuario+"','"+(i+1)+"'," +
                 "'"+dataControlCC[i+5]+"','"+dataControlCC[i+6]+"')";
        System.out.println("consulta insert secado cc "+consulta);
        pst=con.prepareStatement(consulta);
        if(pst.executeUpdate()>0)System.out.println("se registrp el seguimiento de secado humedad");
     }
            consulta="INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION( COD_COMPPROD,  COD_PROGRAMA_PROD,COD_LOTE_PRODUCCION,COD_FORMULA_MAESTRA,"+
                      " COD_ACTIVIDAD_PROGRAMA,FECHA_INICIO,FECHA_FINAL,COD_MAQUINA,HORAS_MAQUINA,HORAS_HOMBRE,COD_TIPO_PROGRAMA_PROD)"+
                      " select spp.COD_COMPPROD,spp.COD_PROGRAMA_PROD,spp.COD_LOTE_PRODUCCION,spp.COD_FORMULA_MAESTRA,"+
                      " spp.COD_ACTIVIDAD_PROGRAMA,MIN(spp.FECHA_INICIO),MAX(spp.FECHA_FINAL),0,0,sum(spp.HORAS_HOMBRE),spp.COD_TIPO_PROGRAMA_PROD"+
                      " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL spp where spp.COD_PROGRAMA_PROD='"+codProgProd+"'"+
                      " and spp.COD_FORMULA_MAESTRA='"+codFormula+"' and spp.COD_COMPPROD='"+codCompProd+"'"+
                      " and spp.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"' and spp.COD_LOTE_PRODUCCION='"+codLote+"'"+
                      " and spp.COD_ACTIVIDAD_PROGRAMA in ('"+codActividadVerificacionHumedad+"')"+
                      " group by spp.COD_PROGRAMA_PROD,spp.COD_FORMULA_MAESTRA,spp.COD_COMPPROD,spp.COD_TIPO_PROGRAMA_PROD,spp.COD_LOTE_PRODUCCION,spp.COD_ACTIVIDAD_PROGRAMA";
            System.out.println("consulta insert seguimiento programa produccion "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento");
     

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
