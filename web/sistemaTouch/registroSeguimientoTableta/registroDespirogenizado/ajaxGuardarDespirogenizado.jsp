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

String[] codEspecificacion=request.getParameter("especificaciones").split(",");
String[] dataAmpollas=request.getParameter("dataAmpollasSeguimiento").split(",");
String codLote=request.getParameter("codLote")==null?"":request.getParameter("codLote");
String codCompProd=request.getParameter("codCompProd");
String codFormulaMaestra=request.getParameter("codFormulaMaestra");
String codTipoProgramaProd=request.getParameter("codTipoProgramaProd");
String codProgramaProd=request.getParameter("codProgramaProd");
int codSeguimientoDespiro=Integer.valueOf(request.getParameter("codSeguimientoDespiro"));
String observacion=request.getParameter("observacion");
String fechaInicioDespiro=request.getParameter("fechaInicioDespiro");
String fechaFinalDespiro=request.getParameter("fechaFinalDespiro");
String horasHombreActividad=request.getParameter("horasHombreDespiro");
String codActividadDespirogenizado=request.getParameter("codActividadDespirogenizado");
String codPersonalUsuario=request.getParameter("codPersonalUsuario");
boolean administrador=(Integer.valueOf(request.getParameter("admin"))>0);
Connection con=null;
String mensaje="";

try
{
     con=Util.openConnection(con);
     con.setAutoCommit(false);
     String consulta="SELECT MAX(S.COD_SEGUIMIENTO_DESPIROGENIZADO_LOTE) AS codSeguimiento FROM SEGUIMIENTO_DESPIROGENIZADO_LOTE S" +
                    " WHERE S.COD_LOTE='"+codLote+"' AND S.COD_PROGRAMA_PROD='"+codProgramaProd+"'";
     Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
     ResultSet res=st.executeQuery(consulta);
     if(res.next())
     {
         codSeguimientoDespiro=res.getInt("codSeguimiento");
     }
     PreparedStatement pst=null;
     SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
     if(codSeguimientoDespiro==0)
     {
         consulta="select isnull(MAX(s.COD_SEGUIMIENTO_DESPIROGENIZADO_LOTE),0)+1 as codSeguimiento from SEGUIMIENTO_DESPIROGENIZADO_LOTE s";
         res=st.executeQuery(consulta);
         if(res.next())codSeguimientoDespiro=res.getInt("codSeguimiento");
         consulta="INSERT INTO SEGUIMIENTO_DESPIROGENIZADO_LOTE(COD_LOTE,"+(administrador?"COD_PERSONAL_SUPERVISOR,FECHA_CIERRE, OBSERVACION":"")+
                  " COD_SEGUIMIENTO_DESPIROGENIZADO_LOTE, COD_PROGRAMA_PROD)"+
                  " VALUES ('"+codLote+"'"+(administrador?",'"+codPersonalUsuario+"','"+sdf.format(new Date())+"',?":"")+
                  " ,'"+codSeguimientoDespiro+"','"+codProgramaProd+"')";
         if(administrador)pst.setString(1,observacion);
         System.out.println("consulta insert seguimiento despiro lote "+consulta);
         pst=con.prepareStatement(consulta);
         if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento ");
     }
     else
     {
         if(administrador)
         {
             consulta="UPDATE SEGUIMIENTO_DESPIROGENIZADO_LOTE SET COD_PERSONAL_SUPERVISOR = ?,"+
                      " FECHA_CIERRE ='"+sdf.format(new Date())+"',"+
                      " OBSERVACION = ?,COD_ESTADO_HOJA = 0"+
                      " WHERE COD_SEGUIMIENTO_DESPIROGENIZADO_LOTE =?";
             pst=con.prepareStatement(consulta);
             pst.setString(1,codPersonalUsuario);
             pst.setString(2,observacion);
             pst.setInt(3,codSeguimientoDespiro);
             if(pst.executeUpdate()>0)System.out.println("se actualizo el seguimiento "+consulta);
         }
         
     }
     if(!administrador)
     {
             consulta="delete from SEGUIMIENTO_AMPOLLAS_DESPIROGENIZADO_LOTE where" +
                     " COD_SEGUIMIENTO_DESPIROGENIZADO_LOTE='"+codSeguimientoDespiro+"'"+
                     " and COD_PERSONAL='"+codPersonalUsuario+"'";
             System.out.println("consulta delete anteriores registros de ampollas "+consulta);
             pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
             consulta="delete from SEGUIMIENTO_ESPECIFICACIONES_DESPIROGENIZADO_LOTE" +
                      " where COD_SEGUIMIENTO_DESPIROGENIZADO_LOTE ='"+codSeguimientoDespiro+"'"+
                      " and COD_PERSONAL='"+codPersonalUsuario+"'";
             System.out.println("consulta delete seguimiento despirog "+consulta);
             pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se eliminaro anteriores registros");
                 for(int i=0;i<codEspecificacion.length;i+=3)
                 {
                     consulta="INSERT INTO SEGUIMIENTO_ESPECIFICACIONES_DESPIROGENIZADO_LOTE("+
                              " COD_ESPECIFICACION_PROCESO, CONFORME, OBSERVACION,COD_SEGUIMIENTO_DESPIROGENIZADO_LOTE,COD_PERSONAL,VALOR_EXACTO)"+
                              " VALUES ('"+codEspecificacion[i]+"','"+(Double.valueOf(codEspecificacion[i+1])>0?1:0)+"',?,"+
                                "'"+codSeguimientoDespiro+"','"+codPersonalUsuario+"','"+(Double.valueOf(codEspecificacion[i+1]))+"')";
                     System.out.println("consulta guardar Seguimiento especificaciones"+consulta);
                     pst=con.prepareStatement(consulta);
                     pst.setString(1,((i+2>=codEspecificacion.length)?"":codEspecificacion[i+2].replace("$%", ",")));
                     if(pst.executeUpdate()>0)System.out.println("se registro la especificacion");
                 }

                 consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION where COD_PROGRAMA_PROD='"+codProgramaProd+"'"+
                                " and COD_LOTE_PRODUCCION='"+codLote+"' and COD_COMPPROD='"+codCompProd+"'"+
                                " and COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"' and"+
                                " COD_ACTIVIDAD_PROGRAMA ='"+codActividadDespirogenizado+"'";
                System.out.println("consulta delete seguimiento anterior "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se eliminaron registros anteriores de seguimiento programa produccion");
                consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL where COD_PROGRAMA_PROD='"+codProgramaProd+"'"+
                        " and COD_LOTE_PRODUCCION='"+codLote+"' and COD_COMPPROD='"+codCompProd+"'"+
                        " and COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"' and"+
                        " COD_ACTIVIDAD_PROGRAMA ='"+codActividadDespirogenizado+"'"+
                        (administrador?"":" and COD_PERSONAL='"+codPersonalUsuario+"'");
                System.out.println("consulta delete seguimiento personal "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
                 int cont=0;
                 String fechaInicio="";
                 String fechaFinal="";
                 for(int i=0;(i<dataAmpollas.length&&dataAmpollas.length>1);i+=8)
                 {
                        cont++;
                        consulta="INSERT INTO SEGUIMIENTO_AMPOLLAS_DESPIROGENIZADO_LOTE(CANTIDAD_AMPOLLAS_BANDEJA,"+
                                 " CANTIDAD_BANDEJAS, COD_PERSONAL, COD_SEGUIMIENTO_DESPIROGENIZADO_LOTE,"+
                                 " COD_REGISTRO_ORDEN_MANUFACTURA,CANTIDAD_AMPOLLAS_ROTAS)"+
                                 " VALUES ('"+dataAmpollas[i+1]+"','"+dataAmpollas[i+2]+"','"+dataAmpollas[i]+"',"+
                                 "'"+codSeguimientoDespiro+"','"+cont+"','"+dataAmpollas[i+3]+"')";
                        System.out.println("consulta insert seguimiento ampollas lavado "+consulta);
                        pst=con.prepareStatement(consulta);
                        if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento de ampollas");

                        String[] aux=dataAmpollas[i+4].split("/");
                        fechaInicio=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataAmpollas[i+5];
                        fechaFinal=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataAmpollas[i+6];

                        consulta = " INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL( COD_COMPPROD,  COD_PROGRAMA_PROD,  COD_LOTE_PRODUCCION,  COD_FORMULA_MAESTRA," +
                                    "  COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE,  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,  FECHA_INICIO," +
                                    "  FECHA_FINAL,HORAS_EXTRA,UNIDADES_PRODUCIDAS_EXTRA,COD_REGISTRO_ORDEN_MANUFACTURA) VALUES ( '"+codCompProd+"'," +
                                    "'"+codProgramaProd+"','"+codLote+"'," +
                                    "'"+codFormulaMaestra+"','"+codActividadDespirogenizado+"'," +
                                    " '"+codTipoProgramaProd+"'," +
                                    " '"+dataAmpollas[i]+"','"+dataAmpollas[i+7]+"','0'" +
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
                      " and spp.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"' and spp.COD_LOTE_PRODUCCION='"+codLote+"'"+
                      " and spp.COD_ACTIVIDAD_PROGRAMA in ('"+codActividadDespirogenizado+"')"+
                      " group by spp.COD_PROGRAMA_PROD,spp.COD_FORMULA_MAESTRA,spp.COD_COMPPROD,spp.COD_TIPO_PROGRAMA_PROD,spp.COD_LOTE_PRODUCCION,spp.COD_ACTIVIDAD_PROGRAMA";
             System.out.println("consulta insert seguimiento programa prod "+consulta);
             pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento de despirogenizado");
             System.out.println("acd "+request.getCharacterEncoding());
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
    
}
catch(Exception e)
{
    mensaje="Ocurrio un error de informacion a la hora del registro intente de nuevo";
    e.printStackTrace();
    con.rollback();

}
out.clear();

out.println(mensaje);


%>
