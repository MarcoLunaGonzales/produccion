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
String codLote=request.getParameter("codLote");
String codProgProd=request.getParameter("codProgProd");
String codFormulaMaestra=request.getParameter("codFormulaMaestra");
String codTipoProgramaProd=request.getParameter("codTipoProgramaProd");
String codCompProd=request.getParameter("codCompProd");
String observaciones=(request.getParameter("observacion")==null?"":request.getParameter("observacion"));
String codActividadTapones=request.getParameter("codActividadTapones");
String codActividadCerrado=request.getParameter("codActividadCerrado");
int codSeguimiento=0;
String[] dataTapones=request.getParameter("dataTapones").split(",");
String[] dataCerrado=request.getParameter("dataCerrado").split(",");
String codPersonalSupervisor=request.getParameter("codPersonalSupervisor");
Connection con=null;
String mensaje="";
boolean admin=(Integer.valueOf(request.getParameter("admin"))>0);
String codPersonalUsuario=request.getParameter("codPersonalUsuario");
SimpleDateFormat sdf= new SimpleDateFormat("yyyy/MM/dd HH:mm");
try
{
     con=Util.openConnection(con);
     Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
     
     PreparedStatement pst=null;
     con.setAutoCommit(false);
     String consulta="select s.COD_SEGUIMIENTO_GRAFADO_LOTE from SEGUIMIENTO_GRAFADO_LOTE s where s.COD_LOTE='"+codLote+"'"+
                     " and s.COD_PROGRAMA_PROD='"+codProgProd+"'";
     System.out.println("consulta verificar codSeguimiento "+consulta);
     ResultSet res=st.executeQuery(consulta);
     if(res.next())
     {
         codSeguimiento=res.getInt("COD_SEGUIMIENTO_GRAFADO_LOTE");
     }
     if(codSeguimiento==0)
     {
         consulta="select isnull(max(s.COD_SEGUIMIENTO_GRAFADO_LOTE),0)+1 as codSeguimiento from SEGUIMIENTO_GRAFADO_LOTE s";
         res=st.executeQuery(consulta);
         if(res.next())
         {
             codSeguimiento=res.getInt("codSeguimiento");
         }
         consulta="INSERT INTO SEGUIMIENTO_GRAFADO_LOTE(COD_SEGUIMIENTO_GRAFADO_LOTE, COD_LOTE, COD_PROGRAMA_PROD" +
                 (admin?",OBSERVACION,COD_PERSONAL_SUPERVISOR":"")+")"+
                 " VALUES ('"+codSeguimiento+"','"+codLote+"','"+codProgProd+"'" +
                 (admin?",'"+observaciones+"','"+codPersonalSupervisor+"'":"")+")";
         System.out.println("consulta guardar "+consulta);
         pst=con.prepareStatement(consulta);
         if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento del rendimiento");
     }
     else
     {
         if(admin)
         {
             consulta="UPDATE SEGUIMIENTO_GRAFADO_LOTE SET OBSERVACION='"+observaciones+"'," +
                      "COD_PERSONAL_SUPERVISOR='"+codPersonalUsuario+"'" +
                      ",cod_estado_hoja=0,FECHA_CIERRE='"+sdf.format(new Date())+"'"+
                      " where COD_SEGUIMIENTO_GRAFADO_LOTE='"+codSeguimiento+"'";
             System.out.println("consulta update rendimiento "+consulta);
             pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento");
         }
     }
     if(!admin)
     {
             consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION where COD_PROGRAMA_PROD='"+codProgProd+"'"+
                            " and COD_LOTE_PRODUCCION='"+codLote+"' and COD_COMPPROD='"+codCompProd+"'"+
                            " and COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"' and"+
                            " COD_ACTIVIDAD_PROGRAMA  in ("+codActividadCerrado+","+codActividadTapones+")";
            System.out.println("consulta delete seguimiento anterior "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se eliminaron registros anteriores de seguimiento programa produccion");
            consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL where COD_PROGRAMA_PROD='"+codProgProd+"'"+
                    " and COD_LOTE_PRODUCCION='"+codLote+"' and COD_COMPPROD='"+codCompProd+"'"+
                    " and COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"' and"+
                    " COD_ACTIVIDAD_PROGRAMA in ("+codActividadCerrado+","+codActividadTapones+")" +
                    (admin?"":" and COD_PERSONAL='"+codPersonalUsuario+"'");
            System.out.println("consulta delete seguimiento personal "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
             String fechaInicio="";
             String fechaFinal="";
             for(int i=0;(i<dataTapones.length&&dataTapones.length>1);i+=6)
             {
                 String[] aux=dataTapones[i+1].split("/");
                fechaInicio=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataTapones[i+2];
                fechaFinal=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataTapones[i+3];

                consulta = " INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL( COD_COMPPROD,  COD_PROGRAMA_PROD,  COD_LOTE_PRODUCCION,  COD_FORMULA_MAESTRA," +
                            "  COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE,  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,  FECHA_INICIO," +
                            "  FECHA_FINAL,HORAS_EXTRA,UNIDADES_PRODUCIDAS_EXTRA,COD_REGISTRO_ORDEN_MANUFACTURA) VALUES ( '"+codCompProd+"'," +
                            "'"+codProgProd+"','"+codLote+"'," +
                            "'"+codFormulaMaestra+"','"+codActividadTapones+"'," +
                            " '"+codTipoProgramaProd+"'," +
                            " '"+dataTapones[i]+"','"+dataTapones[i+4]+"','"+dataTapones[i+5]+"'" +
                            ",'"+fechaInicio+":00','"+fechaInicio+":00','"+fechaFinal+":00'" +
                            ",'0','0','0')";
                System.out.println("consulta insert seguimiento programa produccion personal "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento Personal");
             }
             for(int i=0;(i<dataCerrado.length&&dataCerrado.length>1);i+=6)
             {
                 String[] aux=dataCerrado[i+1].split("/");
                fechaInicio=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataCerrado[i+2];
                fechaFinal=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataCerrado[i+3];

                consulta = " INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL( COD_COMPPROD,  COD_PROGRAMA_PROD,  COD_LOTE_PRODUCCION,  COD_FORMULA_MAESTRA," +
                            "  COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE,  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,  FECHA_INICIO," +
                            "  FECHA_FINAL,HORAS_EXTRA,UNIDADES_PRODUCIDAS_EXTRA,COD_REGISTRO_ORDEN_MANUFACTURA) VALUES ( '"+codCompProd+"'," +
                            "'"+codProgProd+"','"+codLote+"'," +
                            "'"+codFormulaMaestra+"','"+codActividadCerrado+"'," +
                            " '"+codTipoProgramaProd+"'," +
                            " '"+dataCerrado[i]+"','"+dataCerrado[i+4]+"','"+dataCerrado[i+5]+"'" +
                            ",'"+fechaInicio+":00','"+fechaInicio+":00','"+fechaFinal+":00'" +
                            ",'0','0','0')";
                System.out.println("consulta insert seguimiento programa produccion personal "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento Personal");
             }
             consulta="INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION( COD_COMPPROD,  COD_PROGRAMA_PROD,COD_LOTE_PRODUCCION,COD_FORMULA_MAESTRA,"+
                      " COD_ACTIVIDAD_PROGRAMA,FECHA_INICIO,FECHA_FINAL,COD_MAQUINA,HORAS_MAQUINA,HORAS_HOMBRE,COD_TIPO_PROGRAMA_PROD)"+
                      " select spp.COD_COMPPROD,spp.COD_PROGRAMA_PROD,spp.COD_LOTE_PRODUCCION,spp.COD_FORMULA_MAESTRA,"+
                      " spp.COD_ACTIVIDAD_PROGRAMA,MIN(spp.FECHA_INICIO),MAX(spp.FECHA_FINAL),0,0,sum(spp.HORAS_HOMBRE),spp.COD_TIPO_PROGRAMA_PROD"+
                      " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL spp where spp.COD_PROGRAMA_PROD='"+codProgProd+"'"+
                      " and spp.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and spp.COD_COMPPROD='"+codCompProd+"'"+
                      " and spp.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"' and spp.COD_LOTE_PRODUCCION='"+codLote+"'"+
                      " and spp.COD_ACTIVIDAD_PROGRAMA in ('"+codActividadCerrado+"','"+codActividadTapones+"')"+
                      " group by spp.COD_PROGRAMA_PROD,spp.COD_FORMULA_MAESTRA,spp.COD_COMPPROD,spp.COD_TIPO_PROGRAMA_PROD,spp.COD_LOTE_PRODUCCION,spp.COD_ACTIVIDAD_PROGRAMA";
             System.out.println("consulta insert seguimiento programa prod "+consulta);
             pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento de autoclave");
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
