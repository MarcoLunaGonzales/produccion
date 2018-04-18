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
Connection con=null;
String mensaje="";

int codSeguimiento=Integer.valueOf(request.getParameter("codSeguimientoLavadoLote"));
String codLote=request.getParameter("codLote")==null?"":request.getParameter("codLote");
String codprogramaProd=request.getParameter("codprogramaProd");
String codFormulaMaestra=request.getParameter("codFormulaMaestra");
String codTipoProgramaProd=request.getParameter("codTipoProgramaProd");
String codCompProd=request.getParameter("codCompProd");
String codActividadLavado=request.getParameter("codActividadLavado");
String codActividadRecepcion=request.getParameter("codActividadRecepcion");
String codActividadCambioFormato=request.getParameter("codActividadCambioFormato");
String[] codEspecificacion=request.getParameter("especificacionesLavado").split(",");
String[] especificacionesRecepcion=request.getParameter("espRecepcion").split(",");
String[] dataEtapaLavado=request.getParameter("dataEtapaLavado").split(",");
String[] dataCambioFormato=request.getParameter("dataCambioFormato").split(",");
String[] dataAmpollasRecibidas=request.getParameter("dataAmpollasRecibidas").split(",");
String observacion=request.getParameter("observacion");
String codPersonalRecepcion=request.getParameter("codPersonalRecepcion");
String horasHombreRecepcion=request.getParameter("horasHombreRecepcion");
String fechaInicioRecepcion=request.getParameter("fechaInicioRecepcion");
String fechaFinalRecepcion=request.getParameter("fechaFinalRecepcion");
boolean admin=(Integer.valueOf(request.getParameter("admin"))>0);
boolean permisoRecepcion=(Integer.valueOf(request.getParameter("permisoRecepcion"))>0);
boolean permisoLavado=(Integer.valueOf(request.getParameter("permisoLavado"))>0);
String codPersonalUsuario=request.getParameter("codPersonalUsuario");
SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");

try
{
     String codMaquinaLavado=request.getParameter("codMaquinaLavado");
     con=Util.openConnection(con);
     con.setAutoCommit(false);
     String consulta="select s.COD_SEGUIMIENTO_LAVADO_LOTE from SEGUIMIENTO_LAVADO_LOTE s where s.COD_LOTE='"+codLote+"' and s.COD_PROGRAMA_PROD='"+codprogramaProd+"'";
     System.out.println("consulta buscar codSeguimiento "+consulta);
     PreparedStatement pst=null;
     Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
     ResultSet res=st.executeQuery(consulta);
     if(res.next())
     {
         codSeguimiento=res.getInt("COD_SEGUIMIENTO_LAVADO_LOTE");
     }
     if(codSeguimiento==0)
     {
        consulta="select isnull(max(s.COD_SEGUIMIENTO_LAVADO_LOTE),0)+1 as codigo from SEGUIMIENTO_LAVADO_LOTE s ";
        System.out.println("consulta codSeguimiento "+consulta);
        res=st.executeQuery(consulta);
        if(res.next())codSeguimiento=res.getInt("codigo");
        consulta="INSERT INTO SEGUIMIENTO_LAVADO_LOTE(COD_LOTE, COD_PROGRAMA_PROD, COD_SEGUIMIENTO_LAVADO_LOTE"+
                 (admin?",COD_ESTADO_HOJA, FECHA_CIERRE,COD_PERSONAL_SUPERVISOR, OBSERVACIONES":"")+
                 (((!admin)&&permisoRecepcion)?" ,COD_PERSONAL_ENCARGADO_RECEPCION":"")+
                 (((!admin)&&permisoLavado)?",COD_MAQUINA_LAVADO":"")+")"+
                 " VALUES ('"+codLote+"','"+codprogramaProd+"','"+codSeguimiento+"'"+
                 (admin?",0,'"+sdf.format(new Date())+"','"+codPersonalUsuario+"',?":"")+
                 (((!admin)&&permisoRecepcion)?",'"+codPersonalRecepcion+"'":"")+
                 (((!admin)&&permisoLavado)?",'"+codMaquinaLavado+"'":"");
        System.out.println("consulta insert "+consulta+" obs "+URLDecoder.decode(observacion, "UTF-8"));
        pst=con.prepareStatement(consulta);
        if(admin)pst.setString(1,observacion);
        if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento");
     }
     else
     {
         String camposActualizar="";
         if(admin||permisoRecepcion||permisoLavado)
         {
             camposActualizar+=(((!admin)&&permisoRecepcion)?" COD_PERSONAL_ENCARGADO_RECEPCION='"+codPersonalRecepcion+"'":"");
             camposActualizar+=(((!admin)&&permisoLavado)?(camposActualizar.equals("")?"":",")+" COD_MAQUINA_LAVADO='"+codMaquinaLavado+"'":"");
             camposActualizar+=(admin?(camposActualizar.equals("")?"":",")+"COD_ESTADO_HOJA=0, FECHA_CIERRE='"+sdf.format(new Date())+"',COD_PERSONAL_SUPERVISOR='"+codPersonalUsuario+"', OBSERVACIONES=?":"");
             consulta="update SEGUIMIENTO_LAVADO_LOTE set "+camposActualizar+
                      " where  COD_SEGUIMIENTO_LAVADO_LOTE='"+codSeguimiento+"'";
             System.out.println("consulta update seguimiento "+consulta);
             pst=con.prepareStatement(consulta);
             if(admin)pst.setString(1,observacion);
             if(pst.executeUpdate()>0)System.out.println("se actualizo el seguimiento lavado lote");
         }
     }
     if((!admin)&&permisoRecepcion)
     {
             consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION where COD_PROGRAMA_PROD='"+codprogramaProd+"'"+
                    " and COD_LOTE_PRODUCCION='"+codLote+"' and COD_COMPPROD='"+codCompProd+"'"+
                    " and COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"' and"+
                    " COD_ACTIVIDAD_PROGRAMA in ('"+codActividadRecepcion+"')";
            System.out.println("consulta delete seguimiento anterior "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se eliminaron registros anteriores de seguimiento de recepcion");
             consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL where COD_PROGRAMA_PROD='"+codprogramaProd+"'"+
                    " and COD_LOTE_PRODUCCION='"+codLote+"' and COD_COMPPROD='"+codCompProd+"'"+
                    " and COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"' and"+
                    " COD_ACTIVIDAD_PROGRAMA  in  ('"+codActividadRecepcion+"')";
            System.out.println("consulta delete seguimiento personal "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
             consulta="delete SEGUIMIENTO_RECEPCION_LAVADO_LOTE where COD_SEGUIMIENTO_LAVADO_LOTE='"+codSeguimiento+"'";
             System.out.println("consulta delete recepcion "+consulta);
             pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("Se eliminaron las especificaciones de recepcion");
             consulta="delete SEGUIMIENTO_PACKS_AMPOLLAS_RECIBIDAS  where COD_SEGUIMIENTO_LAVADO_LOTE='"+codSeguimiento+"'";
             System.out.println("consulta delete ampollas recibidas "+consulta);
             pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
             for(int i=0;(dataAmpollasRecibidas.length>1&&i<dataAmpollasRecibidas.length);i+=2)
             {
                 consulta="INSERT INTO SEGUIMIENTO_PACKS_AMPOLLAS_RECIBIDAS(COD_SEGUIMIENTO_LAVADO_LOTE,CANTIDAD_PACKS_AMPOLLAS, CANTIDAD_AMPOLLAS_PACK)"+
                          " VALUES ('"+codSeguimiento+"','"+dataAmpollasRecibidas[i]+"','"+dataAmpollasRecibidas[i+1]+"')";
                 System.out.println("consulta insert seguimiento packs "+consulta);
                 pst=con.prepareStatement(consulta);
                 if(pst.executeUpdate()>0)System.out.println("se registro las ampollas recibidas");
             }
             for(int i =0;(especificacionesRecepcion.length>1 && i<especificacionesRecepcion.length);i+=3)
             {
                 consulta="INSERT INTO SEGUIMIENTO_RECEPCION_LAVADO_LOTE(COD_SEGUIMIENTO_LAVADO_LOTE, NRO_SECUENCIA, CONFORME,OBSERVACION)"+
                          " VALUES ('"+codSeguimiento+"','"+especificacionesRecepcion[i]+"','"+especificacionesRecepcion[i+1]+"',?)";
                 System.out.println("consulta insert recepcion "+consulta+((i+2>=especificacionesRecepcion.length)?"":especificacionesRecepcion[i+2].replace("$%",",")));
                 pst=con.prepareStatement(consulta);
                 pst.setString(1,((i+2>=especificacionesRecepcion.length)?"":especificacionesRecepcion[i+2].replace("$%",",")));
                 if(pst.executeUpdate()>0)System.out.println("se registro la recepcion correctamente");
             }
             String[] fecha=fechaInicioRecepcion.split(" ");
            String[] fecha1=fecha[0].split("/");
            fechaInicioRecepcion=fecha1[2]+"/"+fecha1[1]+"/"+fecha1[0]+" "+fecha[1];
            fecha=fechaFinalRecepcion.split(" ");
            fecha1=fecha[0].split("/");
            fechaFinalRecepcion=fecha1[2]+"/"+fecha1[1]+"/"+fecha1[0]+" "+fecha[1];
            consulta = " INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL( COD_COMPPROD,  COD_PROGRAMA_PROD,  COD_LOTE_PRODUCCION,  COD_FORMULA_MAESTRA," +
                                "  COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE,  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,  FECHA_INICIO," +
                                "  FECHA_FINAL,HORAS_EXTRA,UNIDADES_PRODUCIDAS_EXTRA) VALUES ( '"+codCompProd+"'," +
                                "'"+codprogramaProd+"','"+codLote+"'," +
                                "'"+codFormulaMaestra+"','"+codActividadRecepcion+"'," +
                                " '"+codTipoProgramaProd+"'," +
                                " '"+codPersonalRecepcion+"','"+horasHombreRecepcion+"','0'" +
                                ",'"+fechaInicioRecepcion+":00','"+fechaInicioRecepcion+":00','"+fechaFinalRecepcion+":00'" +
                                ",'0','0')";
            System.out.println("consulta insert seguimiento recepcion "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento");

            consulta=" INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION( COD_COMPPROD,  COD_PROGRAMA_PROD, " +
                    "  COD_LOTE_PRODUCCION, COD_FORMULA_MAESTRA,   COD_ACTIVIDAD_PROGRAMA,   FECHA_INICIO,   FECHA_FINAL,  " +
                    "  COD_MAQUINA,  HORAS_MAQUINA,  HORAS_HOMBRE," +
                    "  COD_TIPO_PROGRAMA_PROD) " +
                    "  VALUES ( '"+codCompProd+"' ,'"+codprogramaProd+"','"+codLote+"',  " +
                    " '"+codFormulaMaestra+"' ,'"+codActividadRecepcion+"' , " +
                    "  '"+fechaInicioRecepcion+":00', " +
                    "  '"+fechaFinalRecepcion+":00',  " +
                    "  '0', '0'," +
                    "  '"+horasHombreRecepcion+"', '"+codTipoProgramaProd+"')";
            System.out.println("consulta insert prog recepcion "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento recepcion");
     }
     if((!admin)&&permisoLavado)
     {
             consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION where COD_PROGRAMA_PROD='"+codprogramaProd+"'"+
                    " and COD_LOTE_PRODUCCION='"+codLote+"' and COD_COMPPROD='"+codCompProd+"'"+
                    " and COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"' and"+
                    " COD_ACTIVIDAD_PROGRAMA in ('"+codActividadLavado+"','"+codActividadCambioFormato+"')";
            System.out.println("consulta delete seguimiento anterior "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se eliminaron registros anteriores de seguimiento programa produccion");
            consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL where COD_PROGRAMA_PROD='"+codprogramaProd+"'"+
                    " and COD_LOTE_PRODUCCION='"+codLote+"' and COD_COMPPROD='"+codCompProd+"'"+
                    " and COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"' and"+
                    " COD_ACTIVIDAD_PROGRAMA  in  ('"+codActividadLavado+"','"+codActividadCambioFormato+"')" +
                    " and COD_PERSONAL='"+codPersonalUsuario+"'";
            System.out.println("consulta delete seguimiento personal "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
             consulta="delete SEGUIMIENTO_ESPECIFICACIONES_LAVADO_LOTE where COD_SEGUIMIENTO_LAVADO_LOTE='"+codSeguimiento+"'" +
                      " and cod_personal='"+codPersonalUsuario+"'";
             System.out.println("consulta delete seguimiento especificaciones "+consulta);
             pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se borraron registros anteriores especificaciones");
             consulta="delete SEGUIMIENTO_AMPOLLAS_LAVADO_LOTE  where COD_SEGUIMIENTO_LAVADO_LOTE='"+codSeguimiento+"'" +
                      " and COD_PERSONAL_OBRERO='"+codPersonalUsuario+"'";
             System.out.println("consulta delete ampollas lavadas "+consulta);
             pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se borraron registros anteriores lavados");
             for(int i=0;(codEspecificacion.length>1&&i<codEspecificacion.length);i+=3)
             {
                 System.out.println("cdcd "+codEspecificacion[i+1]);
                 consulta="INSERT INTO SEGUIMIENTO_ESPECIFICACIONES_LAVADO_LOTE(COD_SEGUIMIENTO_LAVADO_LOTE,COD_ESPECIFICACION_PROCESO, CONFORME, OBSERVACION,COD_PERSONAL,VALOR_EXACTO)"+
                          " VALUES ('"+codSeguimiento+"','"+codEspecificacion[i]+"','"+(Double.valueOf(codEspecificacion[i+1])>0?1:0)+"',?,'"+codPersonalUsuario+"','"+(Double.valueOf(codEspecificacion[i+1]))+"')";
                 System.out.println("consulta guardar Seguimiento"+consulta);
                 pst=con.prepareStatement(consulta);
                 pst.setString(1,((i+2>=codEspecificacion.length)?"":codEspecificacion[i+2].replace("$%",",")));
                 if(pst.executeUpdate()>0)System.out.println("se registro la especificacion");
             }
             int cont=0;
             String fechaInicio="";
             String fechaFinal="";
             System.out.println("tam "+dataEtapaLavado.length);
             for(int i=0;(i<dataEtapaLavado.length&&dataEtapaLavado.length>1);i+=8)
             {
                    cont++;
                    consulta="INSERT INTO SEGUIMIENTO_AMPOLLAS_LAVADO_LOTE(COD_SEGUIMIENTO_LAVADO_LOTE,"+
                             " COD_REGISTRO_ORDEN_MANUFACTURA, CANTIDAD_AMPOLLAS_BANDEJAS, CANTIDAD_BANDEJAS,"+
                             " COD_PERSONAL_OBRERO,CANTIDAD_AMPOLLAS_ROTAS)"+
                             " VALUES ('"+codSeguimiento+"','"+cont+"','"+dataEtapaLavado[i+1]+"','"+dataEtapaLavado[i+2]+"'," +
                             "'"+dataEtapaLavado[i]+"','"+dataEtapaLavado[i+3]+"')";
                    System.out.println("consulta insert seguimiento ampollas lavado "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento de ampollas");

                    String[] aux=dataEtapaLavado[i+4].split("/");
                    fechaInicio=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataEtapaLavado[i+5];
                    fechaFinal=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataEtapaLavado[i+6];

                    consulta = " INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL( COD_COMPPROD,  COD_PROGRAMA_PROD,  COD_LOTE_PRODUCCION,  COD_FORMULA_MAESTRA," +
                                "  COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE,  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,  FECHA_INICIO," +
                                "  FECHA_FINAL,HORAS_EXTRA,UNIDADES_PRODUCIDAS_EXTRA,COD_REGISTRO_ORDEN_MANUFACTURA) VALUES ( '"+codCompProd+"'," +
                                "'"+codprogramaProd+"','"+codLote+"'," +
                                "'"+codFormulaMaestra+"','"+codActividadLavado+"'," +
                                " '"+codTipoProgramaProd+"'," +
                                " '"+dataEtapaLavado[i]+"','"+dataEtapaLavado[i+7]+"','0'" +
                                ",'"+fechaInicio+":00','"+fechaInicio+":00','"+fechaFinal+":00'" +
                                ",'0','0','"+cont+"')";
                    System.out.println("consulta insert seguimiento programa produccion personal "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento Personal");
             }

             for(int i=0;(i<dataCambioFormato.length&&dataCambioFormato.length>1);i+=5)
            {
                String[] fechaArray=dataCambioFormato[i+1].split("/");
                String fechaIni1=fechaArray[2]+"/"+fechaArray[1]+"/"+fechaArray[0]+" "+dataCambioFormato[i+2];
                String fechaFin1=fechaArray[2]+"/"+fechaArray[1]+"/"+fechaArray[0]+" "+dataCambioFormato[i+3];
                consulta = " INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL( COD_COMPPROD,  COD_PROGRAMA_PROD,  COD_LOTE_PRODUCCION,  COD_FORMULA_MAESTRA," +
                                    "  COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE,  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,  FECHA_INICIO," +
                                    "  FECHA_FINAL,HORAS_EXTRA,UNIDADES_PRODUCIDAS_EXTRA) VALUES ( '"+codCompProd+"'," +
                                    "'"+codprogramaProd+"','"+codLote+"'," +
                                    "'"+codFormulaMaestra+"','"+codActividadCambioFormato+"'," +
                                    " '"+codTipoProgramaProd+"'," +
                                    " '"+dataCambioFormato[i]+"','"+dataCambioFormato[i+4]+"','0'" +
                                    ",'"+fechaIni1+":00','"+fechaIni1+":00','"+fechaFin1+":00'" +
                                    ",'0','0')";
                System.out.println("consulta insert seguimiento cambio formato "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento cambio formato");
            }
            consulta="INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION( COD_COMPPROD,  COD_PROGRAMA_PROD,COD_LOTE_PRODUCCION,COD_FORMULA_MAESTRA,"+
                      " COD_ACTIVIDAD_PROGRAMA,FECHA_INICIO,FECHA_FINAL,COD_MAQUINA,HORAS_MAQUINA,HORAS_HOMBRE,COD_TIPO_PROGRAMA_PROD)"+
                      " select spp.COD_COMPPROD,spp.COD_PROGRAMA_PROD,spp.COD_LOTE_PRODUCCION,spp.COD_FORMULA_MAESTRA,"+
                      " spp.COD_ACTIVIDAD_PROGRAMA,MIN(spp.FECHA_INICIO),MAX(spp.FECHA_FINAL),0,0,sum(spp.HORAS_HOMBRE),spp.COD_TIPO_PROGRAMA_PROD"+
                      " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL spp where spp.COD_PROGRAMA_PROD='"+codprogramaProd+"'"+
                      " and spp.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and spp.COD_COMPPROD='"+codCompProd+"'"+
                      " and spp.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"' and spp.COD_LOTE_PRODUCCION='"+codLote+"'"+
                      " and spp.COD_ACTIVIDAD_PROGRAMA in ('"+codActividadLavado+"','"+codActividadCambioFormato+"')"+
                      " group by spp.COD_PROGRAMA_PROD,spp.COD_FORMULA_MAESTRA,spp.COD_COMPPROD,spp.COD_TIPO_PROGRAMA_PROD,spp.COD_LOTE_PRODUCCION,spp.COD_ACTIVIDAD_PROGRAMA";
             System.out.println("consulta insert seguimiento programa prod "+consulta);
             pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento de autoclave");
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
