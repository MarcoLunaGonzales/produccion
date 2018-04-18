<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Enumeration" %>
<%@page import="java.util.Map" %>
<%@page import="java.net.URLDecoder" %>
<%@page import="java.util.Date" %>
<%
String codFormulaMaestra=request.getParameter("codFormulaMaestra");
String codCompProd=request.getParameter("codCompProd");
String codTipoProgramaProd=request.getParameter("codTipoProgramaProd");
String codProgProd=request.getParameter("codProgProd");
String codLote=request.getParameter("codLote");
String[] dataSecciones=request.getParameter("dataSecciones").split(",");
String[] dataEsterilizacion=request.getParameter("dataEsterilizacion").split(",");
String codActividadBlisteado=request.getParameter("codActividadBlisteado");
String codActividadGranulado=request.getParameter("codActividadGranulado");
String codActividadPreparado=request.getParameter("codActividadPreparado");
String codActividadRecubrimiento=request.getParameter("codActividadRecubrimiento");
String codActividadSecado=request.getParameter("codActividadSecado");
String codActividadTableteado=request.getParameter("codActividadTableteado");
String codActividadTamizado=request.getParameter("codActividadTamizado");
String codActividadEsterilizacion=request.getParameter("codActividadEsterilizacion");
boolean registroManual=(request.getParameter("registroManual").equals("1"));
int codSeguimiento=0;
Connection con=null;
String mensaje="";
boolean admin=(Integer.valueOf(request.getParameter("admin"))>0);
String codPersonalUsuario=request.getParameter("codPersonalUsuario");
String observacion=request.getParameter("observacion");
SimpleDateFormat sdf= new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
try
{
     con=Util.openConnection(con);
     con.setAutoCommit(false);
     Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
     String consulta="select s.COD_SEGUIMIENTO_LIMPIEZA_LOTE as codSeguimiento"+
                     " from SEGUIMIENTO_LIMPIEZA_LOTE s where s.COD_LOTE='"+codLote+"' and s.COD_PROGRAMA_PROD='"+codProgProd+"'";
     System.out.println("consulta buscar codigo "+consulta);
     ResultSet res=st.executeQuery(consulta);
     if(res.next())codSeguimiento=res.getInt("codSeguimiento");
     PreparedStatement pst=null;
     if(codSeguimiento<=0)
     {
            consulta="select isnull(max(sll.COD_SEGUIMIENTO_LIMPIEZA_LOTE),0)+1 as codSeguimiento  from SEGUIMIENTO_LIMPIEZA_LOTE sll";
            res=st.executeQuery(consulta);
            if(res.next())codSeguimiento=res.getInt("codSeguimiento");
            consulta="INSERT INTO SEGUIMIENTO_LIMPIEZA_LOTE(COD_LOTE, COD_PROGRAMA_PROD,COD_SEGUIMIENTO_LIMPIEZA_LOTE"+
                    (admin?", COD_PERSONAL_SUPERVISOR, FECHA_CIERRE,OBSERVACIONES":"")+")"+
                    " VALUES ('"+codLote+"','"+codProgProd+"','"+codSeguimiento+"'"+
                    (admin?",'"+codPersonalUsuario+"','"+sdf.format(new Date())+"',?":"")+")";
            System.out.println("consulta insert seguimiento cabecera "+consulta+"?"+observacion);
             pst=con.prepareStatement(consulta);
             if(admin)pst.setString(1,URLDecoder.decode(observacion, "UTF-8"));
             if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento");
     }
     else
     {
         if(admin)
         {
             consulta="UPDATE SEGUIMIENTO_LIMPIEZA_LOTE SET COD_PERSONAL_SUPERVISOR = '"+codPersonalUsuario+"',"+
                      " FECHA_CIERRE = '"+sdf.format(new Date())+"',"+
                      " OBSERVACIONES = ?,COD_ESTADO_HOJA = 0"+
                      " WHERE COD_SEGUIMIENTO_LIMPIEZA_LOTE ='"+codSeguimiento+"'";
             System.out.println("consulta update "+consulta+"?"+URLDecoder.decode(observacion, "UTF-8"));
             pst=con.prepareStatement(consulta);
             pst.setString(1,URLDecoder.decode(observacion, "UTF-8"));
             if(pst.executeUpdate()>0)System.out.println("se actualizo la informacion");
         }
     }
     if(!admin)
     {
             consulta=" delete SEGUIMIENTO_LIMPIEZA_LOTE_SECCIONES_MAQUINARIAS where COD_SEGUIMIENTO_LIMPIEZA_LOTE="+codSeguimiento+
                      " and COD_PERSONAL='"+codPersonalUsuario+"'";
             System.out.println("consulta delete anteriores secciones "+consulta);
             pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
             consulta="DELETE FROM SEGUIMIENTO_LIMPIEZA_LOTE_ESTERILIZACION WHERE COD_SEGUIMIENTO_LIMPIEZA_LOTE="+codSeguimiento+" AND COD_PERSONAL="+codPersonalUsuario;
             System.out.println("consulta delete esterilizacion"+consulta);
             pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
             consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION where COD_PROGRAMA_PROD='"+codProgProd+"'"+
                            " and COD_LOTE_PRODUCCION='"+codLote+"' and COD_COMPPROD='"+codCompProd+"'"+
                            " and COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"' and"+
                            " COD_ACTIVIDAD_PROGRAMA in ('"+codActividadBlisteado+"','"+codActividadGranulado+"','"+
                            codActividadPreparado+"','"+codActividadRecubrimiento+"','"+codActividadSecado+"','"+codActividadTableteado+"'" +
                            ",'"+codActividadTamizado+"','"+codActividadEsterilizacion+"')";
            System.out.println("consulta delete seguimiento anterior "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se eliminaron registros anteriores de seguimiento programa produccion");
            consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL where COD_PROGRAMA_PROD='"+codProgProd+"'"+
                    " and COD_LOTE_PRODUCCION='"+codLote+"' and COD_COMPPROD='"+codCompProd+"'"+
                    " and COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"' and"+
                    " COD_ACTIVIDAD_PROGRAMA  in  ('"+codActividadBlisteado+"','"+codActividadGranulado+"','"+
                    codActividadPreparado+"','"+codActividadRecubrimiento+"','"+codActividadSecado+"','"+codActividadTableteado+"'" +
                    ",'"+codActividadTamizado+"','"+codActividadEsterilizacion+"')" +
                    " and COD_PERSONAL='"+codPersonalUsuario+"'";
            System.out.println("consulta delete seguimiento personal "+consulta);
            pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
             int contRegistroOrden=0;
             String fechaInicio="";
             String fechaFinal="";
             String codActividad="";
             for(int i=0;(i<dataSecciones.length&&dataSecciones.length>1);i+=9+(registroManual?0:1))
             {
                contRegistroOrden++;
                consulta="INSERT INTO SEGUIMIENTO_LIMPIEZA_LOTE_SECCIONES_MAQUINARIAS("+
                        " COD_SEGUIMIENTO_LIMPIEZA_LOTE, COD_SECCION_ORDEN_MANUFACTURA, COD_PERSONAL,"+
                        " COD_MAQUINA, LIMPIEZA_RADICAL, LIMPIEZA_ORDINARIA,"+
                        " COD_SANITIZANTE_LIMPIEZA, COD_REGISTRO_ORDEN_MANUFACTURA)"+
                        " VALUES ('"+codSeguimiento+"','"+dataSecciones[i]+"',"+
                        "'"+codPersonalUsuario+"','"+dataSecciones[i+1]+"','"+dataSecciones[i+3]+"','"+dataSecciones[i+4]+"',"+
                        " '"+dataSecciones[i+2]+"','"+contRegistroOrden+"')";
                System.out.println("consulta insert seguimiento limpieza Secciones "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento de limpieza");
                switch(Integer.valueOf(dataSecciones[i]))
                {
                    case 2:
                        codActividad=codActividadPreparado;
                        break;
                    case 6:
                        codActividad=codActividadGranulado;
                        break;
                    case 7:
                        codActividad=codActividadSecado;
                        break;
                    case 8:
                        codActividad=codActividadTamizado;
                        break;
                    case 9:
                        codActividad=codActividadTableteado;
                        break;
                    case 10:
                        codActividad=codActividadRecubrimiento;
                        break;
                    case 11:
                        codActividad=codActividadBlisteado;
                        break;
                    default:
                        codActividad="";
                        break;
                }
                String[] aux=dataSecciones[i+5].split("/");
                fechaInicio=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataSecciones[i+6];
                fechaFinal=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataSecciones[i+7];
                consulta = " INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL( COD_COMPPROD,  COD_PROGRAMA_PROD,  COD_LOTE_PRODUCCION,  COD_FORMULA_MAESTRA," +
                            "  COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE,  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,  FECHA_INICIO," +
                            "  FECHA_FINAL,HORAS_EXTRA,UNIDADES_PRODUCIDAS_EXTRA,COD_REGISTRO_ORDEN_MANUFACTURA" +
                            " ,REGISTRO_CERRADO) VALUES ( '"+codCompProd+"'," +
                            "'"+codProgProd+"','"+codLote+"'," +
                            "'"+codFormulaMaestra+"','"+codActividad+"'," +
                            " '"+codTipoProgramaProd+"'," +
                            " '"+codPersonalUsuario+"','"+dataSecciones[i+8]+"','0'" +
                            ",'"+fechaInicio+":00','"+fechaInicio+":00','"+fechaFinal+":00'" +
                            ",'0','0','"+contRegistroOrden+"','"+(registroManual?1:dataSecciones[i+9])+"')";
                    System.out.println("consulta insert seguimiento programa produccion personal "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento Personal");
             }
             for(int i=0;(i<dataEsterilizacion.length&&dataEsterilizacion.length>1);i+=7+(registroManual?0:1))
             {
                contRegistroOrden++;
                consulta="INSERT INTO SEGUIMIENTO_LIMPIEZA_LOTE_ESTERILIZACION("+
                        " COD_SEGUIMIENTO_LIMPIEZA_LOTE, COD_PERSONAL, LIMPIEZA_RADICAL,"+
                        " LIMPIEZA_ORDINARIA, COD_SANITIZANTE_LIMPIEZA, COD_REGISTRO_ORDEN_MANUFACTURA)"+
                        " VALUES ('"+codSeguimiento+"','"+codPersonalUsuario+"','"+dataEsterilizacion[i+1]+"',"+
                        "'"+dataEsterilizacion[i+2]+"', '"+dataEsterilizacion[i]+"','"+contRegistroOrden+"')";
                System.out.println("consulta insert seguimiento limpieza Secciones "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento de limpieza");
                
                String[] aux=dataEsterilizacion[i+3].split("/");
                fechaInicio=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataEsterilizacion[i+4];
                fechaFinal=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataEsterilizacion[i+5];
                consulta = " INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL( COD_COMPPROD,  COD_PROGRAMA_PROD,  COD_LOTE_PRODUCCION,  COD_FORMULA_MAESTRA," +
                            "  COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE,  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,  FECHA_INICIO," +
                            "  FECHA_FINAL,HORAS_EXTRA,UNIDADES_PRODUCIDAS_EXTRA,COD_REGISTRO_ORDEN_MANUFACTURA,REGISTRO_CERRADO) VALUES ( '"+codCompProd+"'," +
                            "'"+codProgProd+"','"+codLote+"'," +
                            "'"+codFormulaMaestra+"','"+codActividadEsterilizacion+"'," +
                            " '"+codTipoProgramaProd+"'," +
                            " '"+codPersonalUsuario+"','"+dataEsterilizacion[i+6]+"','0'" +
                            ",'"+fechaInicio+":00','"+fechaInicio+":00','"+fechaFinal+":00'" +
                            ",'0','0','"+contRegistroOrden+"','"+(registroManual?1:dataEsterilizacion[i+7])+"')";
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
                      " and spp.COD_ACTIVIDAD_PROGRAMA in ('"+codActividadBlisteado+"','"+codActividadGranulado+"','"+
                        codActividadPreparado+"','"+codActividadRecubrimiento+"','"+codActividadSecado+"','"+codActividadTableteado+"'" +
                        ",'"+codActividadTamizado+"','"+codActividadEsterilizacion+"')"+
                      " group by spp.COD_PROGRAMA_PROD,spp.COD_FORMULA_MAESTRA,spp.COD_COMPPROD,spp.COD_TIPO_PROGRAMA_PROD,spp.COD_LOTE_PRODUCCION,spp.COD_ACTIVIDAD_PROGRAMA";
             System.out.println("consulta insert seguimiento programa prod "+consulta);
             pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento de autoclave");


      }
     con.commit();
     mensaje="1";
     if(st!=null){st.close();}
     if(res!=null){res.close();}
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
    e.printStackTrace();
    mensaje="Ocurrio un error de envio de informacion fisica del registro intente de nuevo";
    con.rollback();
    con.close();
}
out.clear();

out.println(mensaje);


%>
