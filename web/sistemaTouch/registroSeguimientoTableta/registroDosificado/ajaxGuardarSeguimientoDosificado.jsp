<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Enumeration" %>
<%@page import="java.util.Map" %>
<%@ page import = "java.util.Date"%>
<%

String codLote=request.getParameter("codLote");
System.out.println("dosificado lote :"+codLote);
String codProgProd=request.getParameter("codProgProd");
String codFormulaMaestra=request.getParameter("codFormulaMaestra");
String codTipoPrograma=request.getParameter("codTipoPrograma");
String codCompProd=request.getParameter("codCompProd");
String codResponsable=request.getParameter("codResponsable")==null?"0":request.getParameter("codResponsable");
String codSupervisor=request.getParameter("codSupervisor");
String codPersonalAprueba=request.getParameter("codPersonalAprueba");
int codSeguimiento=Integer.valueOf(request.getParameter("codSeguimiento"));
String observaciones=request.getParameter("observaciones");
String[] especificaciones=(request.getParameter("especificaciones").split(","));
String[] especificacionesPost=(request.getParameter("dataPost").split(","));
String[] especificacionesPre=(request.getParameter("dataPre").split(","));
String[] dataCambioFormato=(request.getParameter("dataCambioFormato").split(","));
String[] dataArmadoFiltro=(request.getParameter("dataArmadoFiltro").split(","));
String[] dataRegulado=(request.getParameter("dataReguladoEquipo").split(","));

String codActividadCambioFormato=request.getParameter("codActividadCambioFormato");
String  codActividadArmadoFiltros=request.getParameter("codActividadArmadoFiltros");
String codActividadReguladoEquipo=request.getParameter("codActividadReguladoEquipo");
String codPersonalUsuario=request.getParameter("codPersonalUsuario");
SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
boolean admin=(Integer.valueOf(request.getParameter("admin"))>0);
boolean permisoCambioFormato=(Integer.valueOf(request.getParameter("permisoCambioFormato"))>0);
boolean permisoEspDespiroge=(Integer.valueOf(request.getParameter("permisoEspDespiroge"))>0);
boolean permisoPorosidad=(Integer.valueOf(request.getParameter("permisoPorosidad"))>0);
boolean permisoVerificacion=(Integer.valueOf(request.getParameter("permisoVerificacion"))>0);
String horaAprobacion=request.getParameter("horaAprobacion");
Connection con=null;
String mensaje="";
System.out.println("11");
try
{
     con=Util.openConnection(con);
     Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
     PreparedStatement pst=null;
     con.setAutoCommit(false);
     String consulta="select isnull(max(s.COD_SEGUIMIENTO_DOSIFICADO_LOTE),0)as codSeguimientp from SEGUIMIENTO_DOSIFICADO_LOTE s where s.COD_PROGRAMA_PROD='"+codProgProd+"' and s.COD_LOTE='"+codLote+"'";
     ResultSet res=st.executeQuery(consulta);
     if(res.next())codSeguimiento=res.getInt("codSeguimientp");
     SimpleDateFormat sdfDias=new SimpleDateFormat("yyyy/MM/dd");
     if(codSeguimiento==0)
     {
         consulta="select isnull(MAX(sdl.COD_SEGUIMIENTO_DOSIFICADO_LOTE),0)+1 as codseguimientodos from SEGUIMIENTO_DOSIFICADO_LOTE sdl";
          res=st.executeQuery(consulta);
          if(res.next())codSeguimiento=res.getInt("codseguimientodos");
          consulta="INSERT INTO SEGUIMIENTO_DOSIFICADO_LOTE(COD_LOTE, COD_PROGRAMA_PROD,"+
                   " COD_SEGUIMIENTO_DOSIFICADO_LOTE, COD_PERSONAL_RESPONSABLE,COD_PERSONAL_APRUEBA_PESO,COD_ESTADO_HOJA"+
                   (admin?",COD_PERSONAL_SUPERVISOR,  OBSERVACIONES, FECHA_CIERRE":"")+")"+
                   "VALUES ('"+codLote+"','"+codProgProd+"','"+codSeguimiento+"',0,"+
                   "'"+codPersonalAprueba+"',0"+
                   (admin?",'"+codPersonalUsuario+"',?,'"+sdf.format(new Date())+"'":"")+")";
        System.out.println("consulta insert "+consulta);
        pst=con.prepareStatement(consulta);
        if(admin)pst.setString(1,observaciones);
        if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento");

     }
     else
     {
         if(admin)
         {
                 consulta="UPDATE SEGUIMIENTO_DOSIFICADO_LOTE SET COD_PERSONAL_SUPERVISOR = '"+codPersonalUsuario+"',"+
                          " COD_PERSONAL_APRUEBA_PESO = '"+codPersonalAprueba+"'," +
                          " OBSERVACIONES=?," +
                          " FECHA_CIERRE='"+sdf.format(new Date())+"'," +
                          " FECHA_APROBACION_SELLADO='"+sdfDias.format(new Date())+" "+horaAprobacion+"'" +
                          " ,COD_ESTADO_HOJA=0"+
                          " WHERE COD_SEGUIMIENTO_DOSIFICADO_LOTE = '"+codSeguimiento+"'";
                 System.out.println("consulta update "+consulta);
                 pst=con.prepareStatement(consulta);
                 pst.setString(1,observaciones);
                 if(pst.executeUpdate()>0)System.out.println("se actualizo el seguimiento");
         }
         
     }
     if(permisoVerificacion)
     {
             consulta="delete SEGUIMIENTO_DOSIFICADO_LOTE_PREFILTRADO where COD_SEGUIMIENTO_DOSIFICADO_LOTE='"+codSeguimiento+"'" +
                      " and COD_PERSONAL='"+codPersonalUsuario+"'";
             System.out.println("consulta delete pre filtrado "+consulta);
             pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se borraron anteriores registros");
             for(int i=0;(i<especificacionesPre.length&&especificacionesPre.length>1);i+=4)
             {
                 consulta="INSERT INTO SEGUIMIENTO_DOSIFICADO_LOTE_PREFILTRADO("+
                        " COD_SEGUIMIENTO_DOSIFICADO_LOTE, COD_ESPECIFICACION_FILTRADO,"+
                        " PRUEBA_DE_INTEGRIDAD_POSITIVO, PRESION_REGISTRADA, NUMERO_FILTROS_UTILIZADOS,COD_PERSONAL)"+
                        " VALUES ('"+codSeguimiento+"','"+especificacionesPre[i]+"',"+
                        "'"+especificacionesPre[i+1]+"','"+(especificacionesPre[i+2].replace("|",","))+"','"+especificacionesPre[i+3]+"'" +
                        ",'"+codPersonalUsuario+"')";
                 System.out.println("consulta insert pre filtrado "+consulta);
                 pst=con.prepareStatement(consulta);
                 if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento pre filtrado lote ");

             }
     }
     if(permisoCambioFormato)
     {
                 consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION where COD_PROGRAMA_PROD='"+codProgProd+"'"+
                            " and COD_LOTE_PRODUCCION='"+codLote+"' and COD_COMPPROD='"+codCompProd+"'"+
                            " and COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and COD_TIPO_PROGRAMA_PROD='"+codTipoPrograma+"' and"+
                            " COD_ACTIVIDAD_PROGRAMA in ('"+codActividadArmadoFiltros+"','"+codActividadCambioFormato+"','"+codActividadReguladoEquipo+"')";
                System.out.println("consulta delete seguimiento anterior "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se eliminaron registros anteriores de seguimiento programa produccion");
                consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL where COD_PROGRAMA_PROD='"+codProgProd+"'"+
                        " and COD_LOTE_PRODUCCION='"+codLote+"' and COD_COMPPROD='"+codCompProd+"'"+
                        " and COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and COD_TIPO_PROGRAMA_PROD='"+codTipoPrograma+"' and"+
                        " COD_ACTIVIDAD_PROGRAMA  in  ('"+codActividadArmadoFiltros+"','"+codActividadCambioFormato+"','"+codActividadReguladoEquipo+"')" +
                        " and COD_PERSONAL='"+codPersonalUsuario+"'";
                System.out.println("consulta delete seguimiento personal "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
                 String fechaInicio="";
                String fechaFinal="";
                for(int i=0;(i<dataCambioFormato.length&&dataCambioFormato.length>1);i+=5)
                {
                    String[] aux=dataCambioFormato[i+1].split("/");
                    fechaInicio=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataCambioFormato[i+2];
                    fechaFinal=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataCambioFormato[i+3];

                        consulta = " INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL( COD_COMPPROD,  COD_PROGRAMA_PROD,  COD_LOTE_PRODUCCION,  COD_FORMULA_MAESTRA," +
                                    "  COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE,  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,  FECHA_INICIO," +
                                    "  FECHA_FINAL,HORAS_EXTRA,UNIDADES_PRODUCIDAS_EXTRA) VALUES ( '"+codCompProd+"'," +
                                    "'"+codProgProd+"','"+codLote+"'," +
                                    "'"+codFormulaMaestra+"','"+codActividadCambioFormato+"'," +
                                    " '"+codTipoPrograma+"'," +
                                    " '"+dataCambioFormato[i]+"','"+dataCambioFormato[i+4]+"','0'" +
                                    ",'"+fechaInicio+":00','"+fechaInicio+":00','"+fechaFinal+":00'" +
                                    ",'0','0')";
                        System.out.println("consulta insert seguimiento cambio formato "+consulta);
                        pst=con.prepareStatement(consulta);
                        if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento Personal");
                }
                for(int i=0;(i<dataArmadoFiltro.length&&dataArmadoFiltro.length>1);i+=5)
                {

                    String[] aux=dataArmadoFiltro[i+1].split("/");
                    fechaInicio=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataArmadoFiltro[i+2];
                    fechaFinal=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataArmadoFiltro[i+3];

                        consulta = " INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL( COD_COMPPROD,  COD_PROGRAMA_PROD,  COD_LOTE_PRODUCCION,  COD_FORMULA_MAESTRA," +
                                    "  COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE,  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,  FECHA_INICIO," +
                                    "  FECHA_FINAL,HORAS_EXTRA,UNIDADES_PRODUCIDAS_EXTRA) VALUES ( '"+codCompProd+"'," +
                                    "'"+codProgProd+"','"+codLote+"'," +
                                    "'"+codFormulaMaestra+"','"+codActividadArmadoFiltros+"'," +
                                    " '"+codTipoPrograma+"'," +
                                    " '"+dataArmadoFiltro[i]+"','"+dataArmadoFiltro[i+4]+"','0'" +
                                    ",'"+fechaInicio+":00','"+fechaInicio+":00','"+fechaFinal+":00'" +
                                    ",'0','0')";
                        System.out.println("consulta insert seguimiento armado filtros "+consulta);
                        pst=con.prepareStatement(consulta);
                        if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento Personal");
                        System.out.println("cdcdcd  temirrr");
                }
                for(int i=0;(i<dataRegulado.length&&dataRegulado.length>1);i+=5)
                {

                    String[] aux=dataRegulado[i+1].split("/");
                    fechaInicio=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataRegulado[i+2];
                    fechaFinal=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataRegulado[i+3];
                    consulta = " INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL( COD_COMPPROD,  COD_PROGRAMA_PROD,  COD_LOTE_PRODUCCION,  COD_FORMULA_MAESTRA," +
                                "  COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE,  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,  FECHA_INICIO," +
                                "  FECHA_FINAL,HORAS_EXTRA,UNIDADES_PRODUCIDAS_EXTRA) VALUES ( '"+codCompProd+"'," +
                                "'"+codProgProd+"','"+codLote+"'," +
                                "'"+codFormulaMaestra+"','"+codActividadReguladoEquipo+"'," +
                                " '"+codTipoPrograma+"'," +
                                " '"+dataRegulado[i]+"','"+dataRegulado[i+4]+"','0'" +
                                ",'"+fechaInicio+":00','"+fechaInicio+":00','"+fechaFinal+":00'" +
                                ",'0','0')";
                    System.out.println("consulta insert seguimiento regulado equipo "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento Personal");
                }
                consulta="INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION( COD_COMPPROD,  COD_PROGRAMA_PROD,COD_LOTE_PRODUCCION,COD_FORMULA_MAESTRA,"+
                      " COD_ACTIVIDAD_PROGRAMA,FECHA_INICIO,FECHA_FINAL,COD_MAQUINA,HORAS_MAQUINA,HORAS_HOMBRE,COD_TIPO_PROGRAMA_PROD)"+
                      " select spp.COD_COMPPROD,spp.COD_PROGRAMA_PROD,spp.COD_LOTE_PRODUCCION,spp.COD_FORMULA_MAESTRA,"+
                      " spp.COD_ACTIVIDAD_PROGRAMA,MIN(spp.FECHA_INICIO),MAX(spp.FECHA_FINAL),0,0,sum(spp.HORAS_HOMBRE),spp.COD_TIPO_PROGRAMA_PROD"+
                      " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL spp where spp.COD_PROGRAMA_PROD='"+codProgProd+"'"+
                      " and spp.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and spp.COD_COMPPROD='"+codCompProd+"'"+
                      " and spp.COD_TIPO_PROGRAMA_PROD='"+codTipoPrograma+"' and spp.COD_LOTE_PRODUCCION='"+codLote+"'"+
                      " and spp.COD_ACTIVIDAD_PROGRAMA in ('"+codActividadArmadoFiltros+"','"+codActividadCambioFormato+"','"+codActividadReguladoEquipo+"')"+
                      " group by spp.COD_PROGRAMA_PROD,spp.COD_FORMULA_MAESTRA,spp.COD_COMPPROD,spp.COD_TIPO_PROGRAMA_PROD,spp.COD_LOTE_PRODUCCION,spp.COD_ACTIVIDAD_PROGRAMA";
             System.out.println("consulta insert seguimiento programa prod "+consulta);
             pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento de autoclave");
         
     }
     if(permisoEspDespiroge)
     {
             consulta="delete SEGUIMIENTO_ESPECIFICACIONES_DOSIFICADO_LOTE where COD_SEGUIMIENTO_DOSIFICADO_LOTE='"+codSeguimiento+"'" +
                      " and cod_personal='"+codPersonalUsuario+"'";
             System.out.println("consulta delete anteriores registros "+consulta);
             pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se borraron anteriores registros");
             for(int i=0;(i<especificaciones.length&&especificaciones.length>1);i+=3)
             {
                 consulta="INSERT INTO SEGUIMIENTO_ESPECIFICACIONES_DOSIFICADO_LOTE("+
                          " COD_SEGUIMIENTO_DOSIFICADO_LOTE, COD_ESPECIFICACION_PROCESO, CONFORME,"+
                          " OBSERVACION,COD_PERSONAL,VALOR_EXACTO)"+
                          " VALUES ('"+codSeguimiento+"','"+especificaciones[i]+"','"+(Double.valueOf(especificaciones[i+1])>0?1:0)+"'" +
                          ",?,'"+codPersonalUsuario+"','"+(Double.valueOf(especificaciones[i+1]))+"')";
                 System.out.println("consulta insert "+consulta);
                 pst=con.prepareStatement(consulta);
                // System.out.println("especificaciones[i+2]"+especificaciones[i+2]);
                 pst.setString(1,(((i+2)>=especificaciones.length)?"":especificaciones[i+2].replace("$%",",")));
                 if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento");
             }
     }
     if(permisoPorosidad)
     {

                 consulta="delete SEGUIMIENTO_DOSIFICADO_LOTE_POSTFILTRADO where COD_SEGUIMIENTO_DOSIFICADO_LOTE='"+codSeguimiento+"'" +
                         " and COD_PERSONAL_OPERARIO='"+codPersonalUsuario+"'";
                 System.out.println("consulta delete especificaciones anteriores "+consulta);
                 pst=con.prepareStatement(consulta);
                 if(pst.executeUpdate()>0)System.out.println("se borraron anteriores registross");
                 for(int i=0;(i<especificacionesPost.length&&especificacionesPost.length>1);i+=5)
                 {
                     consulta="INSERT INTO SEGUIMIENTO_DOSIFICADO_LOTE_POSTFILTRADO("+
                              " COD_SEGUIMIENTO_DOSIFICADO_LOTE, COD_ESPECIFICACION_FILTRADO,"+
                              " PRUEBA_DE_INTEGRIDAD_POSITIVO, PRESION_REGISTRADA, COD_PERSONAL_OPERARIO,"+
                              " OBSERVACIONES)"+
                              " VALUES ('"+codSeguimiento+"','"+especificacionesPost[i]+"',"+
                              " '"+especificacionesPost[i+1]+"',?,'"+especificacionesPost[i+3]+"',"+
                              "?)";
                     System.out.println("consulta insert pos especificaciones "+consulta);
                     pst=con.prepareStatement(consulta);
                     pst.setString(1,(especificacionesPost[i+2].replace("$&",",")));
                     pst.setString(2,(((i+4)>=especificacionesPost.length?"":especificacionesPost[i+4].replace("$%",","))));
                     if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento");
                 }
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

}
out.clear();

out.println(mensaje);


%>
