<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Enumeration" %>
<%@page import="java.util.Map" %>
<%@page import="java.util.Date" %>
<%

int codSeguimiento=Integer.valueOf(request.getParameter("codSeguimiento"));
String codLote=request.getParameter("codLote");
String codProgramaProd=request.getParameter("codProgramaProd");
String codFormulaMaestra=request.getParameter("codFormulaMaestra");
String codTipoPrograma=request.getParameter("codTipoProgramaProd");
String codActividadCargado=request.getParameter("codActividadCargado");
String codCompProd=request.getParameter("codCompProd");
String[] dataLotesAdjuntos=request.getParameter("dataLotesAdjuntos").split(",");
String[] dataEspecificaciones=request.getParameter("dataEspecificaciones").split(",");
String[] dataAmpollas=request.getParameter("dataAmpollas").split(",");
String observacion=request.getParameter("observacion");
String fechaInicioActividad=request.getParameter("fechaInicioActividad");
String fechaFinalActividad=request.getParameter("fechaFinalActividad");
String horasHombreActividad=request.getParameter("horasHombreActividad");
SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm");
boolean admin=(Integer.valueOf(request.getParameter("admin"))>0);
String codPersonalUsuario=request.getParameter("codPersonalUsuario");
Connection con=null;

String mensaje="";
try
{
     con=Util.openConnection(con);
     con.setAutoCommit(false);
     String consulta="select s.COD_SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE from SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE s" +
                    " where s.COD_LOTE='"+codLote+"' and s.COD_PROGRAMA_PROD='"+codProgramaProd+"'";
     PreparedStatement pst=null;
     Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
     ResultSet res=st.executeQuery(consulta);
     if(res.next())codSeguimiento=res.getInt("COD_SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE");
     if(codSeguimiento==0)
     {
         consulta="select isnull(max(s.COD_SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE),0)+1 as codSegui from SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE s ";
         res=st.executeQuery(consulta);
         if(res.next())
         {
             codSeguimiento=res.getInt("codSegui");
         }
         consulta="INSERT INTO SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE("+
                  " COD_SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE, COD_LOTE, COD_PROGRAMA_PROD,"+
                  (admin?" OBSERVACIONES, FECHA_CIERRE, COD_PERSONAL_SUPERVISOR,COD_ESTADO_HOJA":"")+")"+
                  " VALUES ('"+codSeguimiento+"','"+codLote+"','"+codProgramaProd+"'" +
                  (admin?",?,'"+sdf.format(new Date())+"', '"+codPersonalUsuario+"',0":"")+" )";
         System.out.println("consulta insert seguimiento esterilizacion "+consulta);
         pst=con.prepareStatement(consulta);
         if(admin)pst.setString(1,observacion);
         if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento del lote");
     }
     else
     {
         if(admin)
         {
                consulta="UPDATE SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE"+
                         " SET OBSERVACIONES =?,"+
                         " FECHA_CIERRE =?,"+
                         " COD_PERSONAL_SUPERVISOR = ?" +
                         " ,COD_ESTADO_HOJA=0"+
                         " WHERE COD_SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE =?";
                System.out.println("consulta update "+consulta);
                pst=con.prepareStatement(consulta);
                pst.setString(1,observacion);
                pst.setString(2,sdf.format(new Date()));
                pst.setString(3,codPersonalUsuario);
                pst.setInt(4, codSeguimiento);
                if(pst.executeUpdate()>0)System.out.println("se actualizo la informacion del registro");
         }
        
     }
     if(!admin)
     {
             consulta="DELETE SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTES_ADJUNTOS " +
                     " WHERE COD_SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE ='"+codSeguimiento+"'";
            System.out.println("consulta delete "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
            consulta="DELETE SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE_ESPECIFICACIONES " +
                    " WHERE COD_SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE ='"+codSeguimiento+"'"+
                    (admin?"":" and COD_PERSONAL='"+ codPersonalUsuario+"'");
            System.out.println("consulta delete "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
            consulta="DELETE SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE_AMPOLLAS" +
                    " WHERE COD_SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE ='"+codSeguimiento+"'" +
                    (admin?"":" and COD_PERSONAL_OBRERO='"+codPersonalUsuario+"'");
            System.out.println("consulta delete "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
             for(int i=0;(i<dataLotesAdjuntos.length&&dataLotesAdjuntos.length>1);i+=2)
             {
                 consulta="INSERT INTO SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTES_ADJUNTOS("+
                          " COD_SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE, COD_LOTE,CANTIDAD_BANDEJAS_LOTE)"+
                          " VALUES ('"+codSeguimiento+"','"+dataLotesAdjuntos[i]+"','"+dataLotesAdjuntos[i+1]+"')";
                 System.out.println("consulta insert lote adjunto "+consulta);
                 pst=con.prepareStatement(consulta);
                 if(pst.executeUpdate()>0)System.out.println("se registro el lote adjunto");
             }
             for(int i=0;(i<dataEspecificaciones.length&&dataEspecificaciones.length>1);i+=3)
             {
                 consulta="INSERT INTO SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE_ESPECIFICACIONES("+
                          " COD_SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE, COD_ESPECIFICACION_PROCESO,"+
                          " CONFORME, OBSERVACIONES,COD_PERSONAL)"+
                          " VALUES ('"+codSeguimiento+"','"+dataEspecificaciones[i]+"','"+dataEspecificaciones[i+1]+"'," +
                          "?,'"+codPersonalUsuario+"')";
                 System.out.println("consulta insert seguimiento especificaciones "+consulta);
                 pst=con.prepareStatement(consulta);
                 pst.setString(1,(dataEspecificaciones.length>(i+2)?dataEspecificaciones[i+2].replace("$%",","):""));
                 if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento de especificaciones");
             }
             consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION where COD_PROGRAMA_PROD='"+codProgramaProd+"'"+
                            " and COD_LOTE_PRODUCCION='"+codLote+"' and COD_COMPPROD='"+codCompProd+"'"+
                            " and COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and COD_TIPO_PROGRAMA_PROD='"+codTipoPrograma+"' and"+
                            " COD_ACTIVIDAD_PROGRAMA ='"+codActividadCargado+"'";
            System.out.println("consulta delete seguimiento anterior "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se eliminaron registros anteriores de seguimiento programa produccion");
            consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL where COD_PROGRAMA_PROD='"+codProgramaProd+"'"+
                    " and COD_LOTE_PRODUCCION='"+codLote+"' and COD_COMPPROD='"+codCompProd+"'"+
                    " and COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and COD_TIPO_PROGRAMA_PROD='"+codTipoPrograma+"' and"+
                    " COD_ACTIVIDAD_PROGRAMA  ='"+codActividadCargado+"'"+
                    (admin?"":" and COD_PERSONAL='"+codPersonalUsuario+"'");
            System.out.println("consulta delete seguimiento personal "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
             int cont=0;
             String fechaInicio="";
             String fechaFinal="";
            for(int i=0;(i<dataAmpollas.length&&dataAmpollas.length>1);i+=8)
             {
                cont++;
                 consulta="INSERT INTO SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE_AMPOLLAS("+
                          " COD_SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE, CANT_AMPOLLAS_RECIPIENTE,"+
                          " CANT_RECIPIENTES, INDICADOR, COD_PERSONAL_OBRERO,COD_REGISTRO_ORDEN_MANUFACTURA)"+
                          " VALUES ('"+codSeguimiento+"','"+dataAmpollas[i]+"','"+dataAmpollas[i+1]+"'," +
                          "'"+dataAmpollas[i+2]+"','"+dataAmpollas[i+3]+"','"+cont+"')";
                 System.out.println("consulta insert detalle ampollas "+consulta);
                 pst=con.prepareStatement(consulta);
                 if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento de calor humedo ampollas");
                 String[] aux=dataAmpollas[i+4].split("/");
                 fechaInicio=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataAmpollas[i+5];
                 fechaFinal=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataAmpollas[i+6];
                 consulta = " INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL( COD_COMPPROD,  COD_PROGRAMA_PROD,  COD_LOTE_PRODUCCION,  COD_FORMULA_MAESTRA," +
                                "  COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE,  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,  FECHA_INICIO," +
                                "  FECHA_FINAL,HORAS_EXTRA,UNIDADES_PRODUCIDAS_EXTRA,COD_REGISTRO_ORDEN_MANUFACTURA) VALUES ( '"+codCompProd+"'," +
                                "'"+codProgramaProd+"','"+codLote+"'," +
                                "'"+codFormulaMaestra+"','"+codActividadCargado+"'," +
                                " '"+codTipoPrograma+"'," +
                                " '"+dataAmpollas[i+3]+"','"+dataAmpollas[i+7]+"','0'" +
                                ",'"+fechaInicio+":00','"+fechaInicio+":00','"+fechaFinal+":00'" +
                                ",'0','0','"+cont+"')";
                    System.out.println("consulta insert seguimiento programa produccion personal "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento Personal");
             }
             consulta="INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION( COD_COMPPROD,  COD_PROGRAMA_PROD,COD_LOTE_PRODUCCION,COD_FORMULA_MAESTRA,"+
                      " COD_ACTIVIDAD_PROGRAMA,FECHA_INICIO,FECHA_FINAL,COD_MAQUINA,HORAS_MAQUINA,HORAS_HOMBRE,COD_TIPO_PROGRAMA_PROD)"+
                      " select spp.COD_COMPPROD,spp.COD_PROGRAMA_PROD,spp.COD_LOTE_PRODUCCION,spp.COD_FORMULA_MAESTRA,"+
                      " spp.COD_ACTIVIDAD_PROGRAMA,MIN(spp.FECHA_INICIO),MAX(spp.FECHA_FINAL),0,0,sum(spp.HORAS_HOMBRE),spp.COD_TIPO_PROGRAMA_PROD"+
                      " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL spp where spp.COD_PROGRAMA_PROD='"+codProgramaProd+"'"+
                      " and spp.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and spp.COD_COMPPROD='"+codCompProd+"'"+
                      " and spp.COD_TIPO_PROGRAMA_PROD='"+codTipoPrograma+"' and spp.COD_LOTE_PRODUCCION='"+codLote+"'"+
                      " and spp.COD_ACTIVIDAD_PROGRAMA in ("+codActividadCargado+")"+
                      " group by spp.COD_PROGRAMA_PROD,spp.COD_FORMULA_MAESTRA,spp.COD_COMPPROD,spp.COD_TIPO_PROGRAMA_PROD,spp.COD_LOTE_PRODUCCION,spp.COD_ACTIVIDAD_PROGRAMA";
             System.out.println("consulta insert seguimiento programa prod "+consulta);
             pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento de autoclave");
    }
     con.commit();
      mensaje="1";
      if(st!=null)st.close();
      if(res!=null)res.close();
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
    mensaje="Ocurrio un error de informacion a la hora del registro,verifique la informacion introducida e intente de nuevo";
    e.printStackTrace();
    con.rollback();
    con.close();

}
out.clear();

out.println(mensaje);


%>
