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
String codProgramaProd=request.getParameter("codProgProd");
String codFormulaMaestra=request.getParameter("codFormulaMaestra");
String codCompProd=request.getParameter("codCompProd");
String codTipoProgramaProd=request.getParameter("codTipoProgramaProd");
String fechaInicioActividad=request.getParameter("fechaInicioActividad");
String fechaFinalActividad=request.getParameter("fechaFinalActividad");
String horasActividad=request.getParameter("horasActividad");
String codActividadEnvasado=request.getParameter("codActividadEnvasado");
int codSeguimiento=Integer.valueOf(request.getParameter("codSeguimiento"));
String[] dataControlDosificado=request.getParameter("dataControlDosificado").split(",");
String codPersonalSupervisor=request.getParameter("codPersonalSupervisor");
String observacion=request.getParameter("observacion");
Connection con=null;
String mensaje="";
SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm");
boolean admin=(Integer.valueOf(request.getParameter("admin"))>0);
String codPersonalUsuario=request.getParameter("codPersonalUsuario");
try
{
     con=Util.openConnection(con);
     Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
     ResultSet res=null;
     PreparedStatement pst=null;
     con.setAutoCommit(false);
     String consulta="select s.COD_SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE from SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE s where s.COD_LOTE='"+codLote+"'" +
                     " and s.COD_PROGRAMA_PROD='"+codProgramaProd+"'";
     System.out.println("consulta verificar registro "+consulta);
     res=st.executeQuery(consulta);
     if(res.next())codSeguimiento=res.getInt("COD_SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE");
     if(codSeguimiento==0)
     {
         
         consulta="select isnull(max(s.COD_SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE),0)+1 as codSeguimiento from SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE s";
          res=st.executeQuery(consulta);
          if(res.next())codSeguimiento=res.getInt("codSeguimiento");
        consulta="INSERT INTO SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE(COD_SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE, COD_LOTE, COD_PROGRAMA_PROD"+
                 (admin?",OBSERVACION, COD_PERSONAL_SUPERVISOR":"")+")VALUES ('"+codSeguimiento+"','"+codLote+"','"+codProgramaProd+"'"+
                 (admin?",'"+observacion+"','"+codPersonalSupervisor+"'":"")+")";
        System.out.println("consulta insert "+consulta);
        pst=con.prepareStatement(consulta);
        if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento");

     }
     else
     {
         if(admin)
         {
             consulta="update SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE set OBSERVACION='"+observacion+"'," +
                      "COD_PERSONAL_SUPERVISOR='"+codPersonalUsuario+"',COD_ESTADO_HOJA=0," +
                      " FECHA_CIERRE='"+sdf.format(new Date())+"'"+
                      " where COD_SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE='"+codSeguimiento+"'";
             System.out.println("consulta update "+consulta);
             pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se actualizo el seguimiento");
         }
         
     }
     if(!admin)
     {
                 consulta="delete SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE_PERSONAL " +
                              " where COD_SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE='"+codSeguimiento+"'" +
                              " and COD_PERSONAL='"+codPersonalUsuario+"'";
                     System.out.println("consulta delete "+consulta);
                     pst=con.prepareStatement(consulta);
                     if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
                 consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION where COD_PROGRAMA_PROD='"+codProgramaProd+"'"+
                                " and COD_LOTE_PRODUCCION='"+codLote+"' and COD_COMPPROD='"+codCompProd+"'"+
                                " and COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"' and"+
                                " COD_ACTIVIDAD_PROGRAMA ='"+codActividadEnvasado+"'";
                System.out.println("consulta delete seguimiento anterior "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se eliminaron registros anteriores de seguimiento programa produccion");
                consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL where COD_PROGRAMA_PROD='"+codProgramaProd+"'"+
                        " and COD_LOTE_PRODUCCION='"+codLote+"' and COD_COMPPROD='"+codCompProd+"'"+
                        " and COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"' and"+
                        " COD_ACTIVIDAD_PROGRAMA ='"+codActividadEnvasado+"'"+
                        " and COD_PERSONAL='"+codPersonalUsuario+"'";
                System.out.println("consulta delete seguimiento personal "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
                 int cont=0;
                 String fechaInicio="";
                 String fechaFinal="";
                 for(int i=0;(i<dataControlDosificado.length&&dataControlDosificado.length>1);i+=9)
                 {
                     cont++;
                    consulta="INSERT INTO SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE_PERSONAL("+
                             " COD_SEGUIMIENTO_CONTROL_DOSIFICADO_LOTE, COD_PERSONAL, CANT_AMPOLLAS_ACOND,"+
                             " CANT_AMPOLLAS_CC,CANT_AMPOLLAS_ROTAS,CANT_AMPOLLAS_FALTANTES,COD_REGISTRO_ORDEN_MANUFACTURA)"+
                             " VALUES ('"+codSeguimiento+"','"+dataControlDosificado[i]+"','"+dataControlDosificado[i+1]+"',"+
                             "'"+dataControlDosificado[i+2]+"','"+dataControlDosificado[i+3]+"',"+
                             " '"+dataControlDosificado[i+4]+"','"+cont+"')";
                    System.out.println("consulta insert seguimiento llenado primer turno "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento de control de llenado volumen");
                    String[] aux=dataControlDosificado[i+5].split("/");
                    fechaInicio=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataControlDosificado[i+6];
                    fechaFinal=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataControlDosificado[i+7];

                    consulta = " INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL( COD_COMPPROD,  COD_PROGRAMA_PROD,  COD_LOTE_PRODUCCION,  COD_FORMULA_MAESTRA," +
                                "  COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE,  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,  FECHA_INICIO," +
                                "  FECHA_FINAL,HORAS_EXTRA,UNIDADES_PRODUCIDAS_EXTRA,COD_REGISTRO_ORDEN_MANUFACTURA) VALUES ( '"+codCompProd+"'," +
                                "'"+codProgramaProd+"','"+codLote+"'," +
                                "'"+codFormulaMaestra+"','"+codActividadEnvasado+"'," +
                                " '"+codTipoProgramaProd+"'," +
                                " '"+dataControlDosificado[i]+"','"+dataControlDosificado[i+8]+"','0'" +
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
                      " and spp.COD_ACTIVIDAD_PROGRAMA in ("+codActividadEnvasado+")"+
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
}
catch(Exception ex)
{
    mensaje="Ocurrio un error de informacion al momento de registrar la informacion, comunicar sistemas";
    ex.printStackTrace();
    con.rollback();
}


out.clear();

out.println(mensaje);


%>
