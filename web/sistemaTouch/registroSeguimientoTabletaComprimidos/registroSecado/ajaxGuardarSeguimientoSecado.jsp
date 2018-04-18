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
String[] dataTiempoCargado=request.getParameter("dataTiempoCargado").split(",");
String[] dataTiempoDescarga=request.getParameter("dataTiempoDescarga").split(",");
String[] dataEspecificaciones=request.getParameter("dataEspecificaciones").split(",");
String observaciones=request.getParameter("observacion");
String codActividadCargaSecado=request.getParameter("codActividadCargaSecado");
String codActividadDecargaSecado=request.getParameter("codActividadDecargaSecado");
System.out.println("da "+dataTiempoDescarga.length);
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
     if(codSeguimiento==0)
     {
         consulta="select isnull(max(s.COD_SEGUIMIENTO_SECADO_LOTE),0)+1 as codSeg from  SEGUIMIENTO_SECADO_LOTE s";
          res=st.executeQuery(consulta);
          if(res.next())codSeguimiento=res.getInt("codSeg");
          consulta="INSERT INTO SEGUIMIENTO_SECADO_LOTE(COD_SEGUIMIENTO_SECADO_LOTE, COD_LOTE,COD_PROGRAMA_PROD,COD_ESTADO_HOJA"+
                    (administrador?", OBSERVACION, COD_PERSONAL_SUPERVISOR,FECHA_CIERRE":"")+")"+
                    " VALUES ('"+codSeguimiento+"','"+codLote+"','"+codProgProd+"',0"+
                    (administrador?"?,'"+codPersonalUsuario+"','"+sdf.format(new Date())+"'":"")+")";
          System.out.println("consulta insert "+consulta);
             pst=con.prepareStatement(consulta);
          if(administrador)pst.setString(1,URLDecoder.decode(observaciones, "UTF-8"));
        
        if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento");

     }
     else
     {
         if(administrador)
         {
             consulta="UPDATE SEGUIMIENTO_GRANULADO_LOTE SET COD_PERSONAL_SUPERVISOR =?,"+
                      " FECHA_CIERRE = '"+sdf.format(new Date())+"',OBSERVACION = ?,COD_ESTADO_HOJA = 0"+
                      " WHERE COD_SEGUIMIENTO_GRANULADO_LOTE =?";
             System.out.println("consulta update "+consulta+codPersonalUsuario+observaciones+codSeguimiento);
             pst=con.prepareStatement(consulta);
             pst.setString(1,codPersonalUsuario);
             pst.setString(2,URLDecoder.decode(observaciones, "UTF-8"));
             pst.setInt(3,codSeguimiento);
             if(pst.executeUpdate()>0)System.out.println("se actualizo el seguimiento");
         }
        
         
     }
     if(!administrador)
    {
             consulta="delete SEGUIMIENTO_ESPECIFICACIONES_SECADO_LOTE  where COD_SEGUIMIENTO_SECADO_LOTE='"+codSeguimiento+"'"+
                      " and COD_FRACCION_OM='"+codFraccionTrabajo+"'";
             System.out.println("consulta delete "+consulta);
             pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
             for(int i=0;(i<dataEspecificaciones.length&&dataEspecificaciones.length>1);i+=4)
             {
                 consulta="INSERT INTO SEGUIMIENTO_ESPECIFICACIONES_SECADO_LOTE(COD_SEGUIMIENTO_SECADO_LOTE"+
                         " , COD_PERSONAL, COD_ESPECIFICACION_PROCESO, COD_MAQUINA, CONFORME, OBSERVACION,"+
                         " VALOR_EXACTO, COD_FRACCION_OM)"+
                         " VALUES ('"+codSeguimiento+"','"+codPersonalUsuario+"','"+dataEspecificaciones[i+3]+"'"+
                         " ,'"+dataEspecificaciones[i]+"','"+(Double.valueOf(dataEspecificaciones[i+1])>0?1:0)+"'," +
                         "?,'"+dataEspecificaciones[i+1]+"','"+codFraccionTrabajo+"')";
                System.out.println("consulta insert seguimiento "+consulta);
                pst=con.prepareStatement(consulta);
                pst.setString(1,dataEspecificaciones[i+2]);
                if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento");
             }
             consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION where COD_PROGRAMA_PROD='"+codProgProd+"'"+
                            " and COD_LOTE_PRODUCCION='"+codLote+"' and COD_COMPPROD='"+codCompProd+"'"+
                            " and COD_FORMULA_MAESTRA='"+codFormula+"' and COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'" +
                            " and  COD_ACTIVIDAD_PROGRAMA in("+codActividadCargaSecado+","+codActividadDecargaSecado+")";
            System.out.println("consulta delete seguimiento anterior "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se eliminaron registros anteriores de seguimiento programa produccion");
            consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL where COD_PROGRAMA_PROD='"+codProgProd+"'"+
                    " and COD_LOTE_PRODUCCION='"+codLote+"' and COD_COMPPROD='"+codCompProd+"'"+
                    " and COD_FORMULA_MAESTRA='"+codFormula+"' and COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'" +
                    " and COD_FRACCION_OM="+codFraccionTrabajo+" and "+
                    " COD_ACTIVIDAD_PROGRAMA in ("+codActividadCargaSecado+","+codActividadDecargaSecado+")";
            System.out.println("consulta delete seguimiento personal "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
            for(int i=0;(i<dataTiempoCargado.length&&dataTiempoCargado.length>1);i+=5)
             {
                String[] aux=dataTiempoCargado[i].split("/");
                String fechaInicio=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataTiempoCargado[i+1];
                String fechaFinal=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataTiempoCargado[i+2];

                consulta = " INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL( COD_COMPPROD,  COD_PROGRAMA_PROD,  COD_LOTE_PRODUCCION,  COD_FORMULA_MAESTRA," +
                            "  COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE,  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,  FECHA_INICIO," +
                            "  FECHA_FINAL,HORAS_EXTRA,UNIDADES_PRODUCIDAS_EXTRA,COD_REGISTRO_ORDEN_MANUFACTURA,REGISTRO_CERRADO,COD_FRACCION_OM)" +
                            " VALUES ( '"+codCompProd+"'," +
                            "'"+codProgProd+"','"+codLote+"'," +
                            "'"+codFormula+"','"+codActividadCargaSecado+"'," +
                            " '"+codTipoProgramaProd+"'," +
                            " '"+codPersonalUsuario+"','"+dataTiempoCargado[i+3]+"','0'" +
                            ",'"+fechaInicio+":00','"+fechaInicio+":00','"+fechaFinal+":00'" +
                            ",'0','0','0','"+dataTiempoCargado[i+4]+"','"+codFraccionTrabajo+"')";
                System.out.println("consulta insert seguimiento programa produccion personal "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento Personal");
             }
            for(int i=0;(i<dataTiempoDescarga.length&&dataTiempoDescarga.length>1);i+=5)
             {
                String[] aux=dataTiempoDescarga[i].split("/");
                String fechaInicio=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataTiempoDescarga[i+1];
                String fechaFinal=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataTiempoDescarga[i+2];

                consulta = " INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL( COD_COMPPROD,  COD_PROGRAMA_PROD,  COD_LOTE_PRODUCCION,  COD_FORMULA_MAESTRA," +
                            "  COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE,  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,  FECHA_INICIO," +
                            "  FECHA_FINAL,HORAS_EXTRA,UNIDADES_PRODUCIDAS_EXTRA,COD_REGISTRO_ORDEN_MANUFACTURA,REGISTRO_CERRADO,COD_FRACCION_OM)" +
                            " VALUES ( '"+codCompProd+"'," +
                            "'"+codProgProd+"','"+codLote+"'," +
                            "'"+codFormula+"','"+codActividadDecargaSecado+"'," +
                            " '"+codTipoProgramaProd+"'," +
                            " '"+codPersonalUsuario+"','"+dataTiempoDescarga[i+3]+"','0'" +
                            ",'"+fechaInicio+":00','"+fechaInicio+":00','"+fechaFinal+":00'" +
                            ",'0','0','0','"+dataTiempoDescarga[i+4]+"','"+codFraccionTrabajo+"')";
                System.out.println("consulta insert seguimiento programa produccion personal "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento Personal");
             }
            consulta="INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION( COD_COMPPROD,  COD_PROGRAMA_PROD,COD_LOTE_PRODUCCION,COD_FORMULA_MAESTRA,"+
                              " COD_ACTIVIDAD_PROGRAMA,FECHA_INICIO,FECHA_FINAL,COD_MAQUINA,HORAS_MAQUINA,HORAS_HOMBRE,COD_TIPO_PROGRAMA_PROD)"+
                              " select spp.COD_COMPPROD,spp.COD_PROGRAMA_PROD,spp.COD_LOTE_PRODUCCION,spp.COD_FORMULA_MAESTRA,"+
                              " spp.COD_ACTIVIDAD_PROGRAMA,MIN(spp.FECHA_INICIO),MAX(spp.FECHA_FINAL),0,0,sum(spp.HORAS_HOMBRE),spp.COD_TIPO_PROGRAMA_PROD"+
                              " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL spp where spp.COD_PROGRAMA_PROD='"+codProgProd+"'"+
                              " and spp.COD_FORMULA_MAESTRA='"+codFormula+"' and spp.COD_COMPPROD='"+codCompProd+"'"+
                              " and spp.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"' and spp.COD_LOTE_PRODUCCION='"+codLote+"'"+
                              " and spp.COD_ACTIVIDAD_PROGRAMA in ('"+codActividadCargaSecado+"','"+codActividadDecargaSecado+"')"+
                              " group by spp.COD_PROGRAMA_PROD,spp.COD_FORMULA_MAESTRA,spp.COD_COMPPROD,spp.COD_TIPO_PROGRAMA_PROD,spp.COD_LOTE_PRODUCCION,spp.COD_ACTIVIDAD_PROGRAMA";
            System.out.println("consulta insert seguimiento programa produccion "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento");
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
