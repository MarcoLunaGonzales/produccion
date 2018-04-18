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
String codActividadAutoclave=request.getParameter("codActividadAutoclave");
String codActividadDosificado=request.getParameter("codActividadDosificado");
String codActividadLavadoAmp=request.getParameter("codActividadLavadoAmp");
String codActividadPreparado=request.getParameter("codActividadPreparado");
String codActividadEstFiltro=request.getParameter("codActividadEstFiltro");
String codActividadEstUtensilios=request.getParameter("codActividadEstUtensilios");
String[] datasecciones=request.getParameter("dataSecciones").split(",");
String[] dataEquipos=request.getParameter("dataLimpiezaEquipos").split(",");
String[] dataUtensilios=request.getParameter("dataUtensilios").split(",");
String[] dataFiltros=request.getParameter("dataFiltros").split(",");
String[] dataSegUtensilios=request.getParameter("dataSegUtensilios").split(",");
String[] dataSegFiltros=request.getParameter("dataSegFiltros").split(",");
int codSeguimiento=Integer.valueOf(request.getParameter("codSeguimiento"));
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
             consulta=" delete SEGUIMIENTO_LIMPIEZA_LOTE_SECCIONES where COD_SEGUIMIENTO_LIMPIEZA_LOTE="+codSeguimiento+
                      " and COD_PERSONAL_LIMPIEZA='"+codPersonalUsuario+"'";
             System.out.println("consulta delete anteriores secciones "+consulta);
             pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
             consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION where COD_PROGRAMA_PROD='"+codProgProd+"'"+
                            " and COD_LOTE_PRODUCCION='"+codLote+"' and COD_COMPPROD='"+codCompProd+"'"+
                            " and COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"' and"+
                            " COD_ACTIVIDAD_PROGRAMA in ('"+codActividadAutoclave+"','"+codActividadDosificado+"','"+
                            codActividadLavadoAmp+"','"+codActividadPreparado+"','"+codActividadEstFiltro+"','"+codActividadEstUtensilios+"')";
            System.out.println("consulta delete seguimiento anterior "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se eliminaron registros anteriores de seguimiento programa produccion");
            consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL where COD_PROGRAMA_PROD='"+codProgProd+"'"+
                    " and COD_LOTE_PRODUCCION='"+codLote+"' and COD_COMPPROD='"+codCompProd+"'"+
                    " and COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"' and"+
                    " COD_ACTIVIDAD_PROGRAMA  in  ('"+codActividadAutoclave+"','"+codActividadDosificado+"','"+
                    codActividadLavadoAmp+"','"+codActividadPreparado+"','"+codActividadEstFiltro+"','"+codActividadEstUtensilios+"')" +
                    " and COD_PERSONAL='"+codPersonalUsuario+"'";
            System.out.println("consulta delete seguimiento personal "+consulta);
            pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
             int contRegistroOrden=0;
             String fechaInicio="";
             String fechaFinal="";
             String codActividad="";
             for(int i=0;(i<datasecciones.length&&datasecciones.length>1);i+=10)
             {
                contRegistroOrden++;
                consulta="INSERT INTO SEGUIMIENTO_LIMPIEZA_LOTE_SECCIONES(COD_SEGUIMIENTO_LIMPIEZA_LOTE,"+
                        "COD_SECCION_ORDEN_MANUFACTURA, COD_PERSONAL_LIMPIEZA,COD_SANITIZANTE_LIMPIEZA,"+
                        "LIMPIEZA_RADICAL, LIMPIEZA_ORDINARIA, COD_REGISTRO_ORDEN_MANUFACTURA,REGISTRO_PRINCIPAL)"+
                        " VALUES ('"+codSeguimiento+"','"+datasecciones[i]+"','"+datasecciones[i+1]+"','"+datasecciones[i+2]+"'," +
                        "'"+datasecciones[i+3]+"','"+datasecciones[i+4]+"','"+contRegistroOrden+"','"+datasecciones[i+9]+"')";
                System.out.println("consulta insert seguimiento limpieza Secciones "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento de limpieza");
                switch(Integer.valueOf(datasecciones[i]))
                {
                    case 1:
                        codActividad=codActividadLavadoAmp;
                        break;
                    case 2:
                        codActividad=codActividadPreparado;
                        break;
                    case 3:
                        codActividad=codActividadDosificado;
                        break;
                    case 4:
                        codActividad=codActividadAutoclave;
                        break;
                    default:
                        codActividad="";
                        break;
                }
                String[] aux=datasecciones[i+5].split("/");
                fechaInicio=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+datasecciones[i+6];
                fechaFinal=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+datasecciones[i+7];
                consulta = " INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL( COD_COMPPROD,  COD_PROGRAMA_PROD,  COD_LOTE_PRODUCCION,  COD_FORMULA_MAESTRA," +
                            "  COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE,  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,  FECHA_INICIO," +
                            "  FECHA_FINAL,HORAS_EXTRA,UNIDADES_PRODUCIDAS_EXTRA,COD_REGISTRO_ORDEN_MANUFACTURA) VALUES ( '"+codCompProd+"'," +
                            "'"+codProgProd+"','"+codLote+"'," +
                            "'"+codFormulaMaestra+"','"+codActividad+"'," +
                            " '"+codTipoProgramaProd+"'," +
                            " '"+datasecciones[i+1]+"','"+datasecciones[i+8]+"','0'" +
                            ",'"+fechaInicio+":00','"+fechaInicio+":00','"+fechaFinal+":00'" +
                            ",'0','0','"+contRegistroOrden+"')";
                    System.out.println("consulta insert seguimiento programa produccion personal "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento Personal");
             }
             consulta=" DELETE SEGUIMIENTO_LIMPIEZA_LOTE_EQUIPOS WHERE COD_SEGUIMIENTO_LIMPIEZA_LOTE="+codSeguimiento+
                      "  and COD_PERSONAL_RESPONSABLE_LIMPIEZA='"+codPersonalUsuario+"'";
             System.out.println("consulta delete limpieza equipos "+consulta);
             pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");

             for(int i=0;(i<dataEquipos.length&&dataEquipos.length>1);i+=11)
             {
                 contRegistroOrden++;
                 consulta="INSERT INTO SEGUIMIENTO_LIMPIEZA_LOTE_EQUIPOS(COD_SEGUIMIENTO_LIMPIEZA_LOTE,COD_MAQUINA, COD_PERSONAL_RESPONSABLE_LIMPIEZA, LIMPIEZA_RADICAL,"+
                          " LIMPIEZA_ORDINARIA, COD_SANITIZANTE_LIMPIEZA, COD_REGISTRO_ORDEN_MANUFACTURA,REGISTRO_PRINCIPAL)"+
                          " VALUES ('"+codSeguimiento+"',"+dataEquipos[i]+",'"+dataEquipos[i+2]+"','"+dataEquipos[i+4]+"','"+dataEquipos[i+5]+"',"+
                          "'"+dataEquipos[i+3]+"','"+contRegistroOrden+"','"+dataEquipos[i+10]+"')";
                 System.out.println("consulta registrar seguimiento limpieza lote "+consulta);
                 pst=con.prepareStatement(consulta);
                 if(pst.executeUpdate()>0)System.out.println("se reigstro el seguimiento de limpieza");
                 switch(Integer.valueOf(dataEquipos[i+1]))
                    {
                        case 1:
                            codActividad=codActividadLavadoAmp;
                            break;
                        case 2:
                            codActividad=codActividadPreparado;
                            break;
                        case 3:
                            codActividad=codActividadDosificado;
                            break;
                        case 4:
                            codActividad=codActividadAutoclave;
                            break;
                        case 5:
                            codActividad=codActividadDosificado;
                            break;
                        default:
                            codActividad="";
                            break;
                    }
                String[] aux=dataEquipos[i+6].split("/");
                fechaInicio=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataEquipos[i+7];
                fechaFinal=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataEquipos[i+8];
                consulta = " INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL( COD_COMPPROD,  COD_PROGRAMA_PROD,  COD_LOTE_PRODUCCION,  COD_FORMULA_MAESTRA," +
                            "  COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE,  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,  FECHA_INICIO," +
                            "  FECHA_FINAL,HORAS_EXTRA,UNIDADES_PRODUCIDAS_EXTRA,COD_REGISTRO_ORDEN_MANUFACTURA) VALUES ( '"+codCompProd+"'," +
                            "'"+codProgProd+"','"+codLote+"'," +
                            "'"+codFormulaMaestra+"','"+codActividad+"'," +
                            " '"+codTipoProgramaProd+"'," +
                            " '"+dataEquipos[i+2]+"','"+dataEquipos[i+9]+"','0'" +
                            ",'"+fechaInicio+":00','"+fechaInicio+":00','"+fechaFinal+":00'" +
                            ",'0','0','"+contRegistroOrden+"')";
                    System.out.println("consulta insert seguimiento programa produccion personal "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento Personal");
             }
             consulta="delete SEGUIMIENTO_LIMPIEZA_LOTE_UTENSILIOS where COD_SEGUIMIENTO_LIMPIEZA_LOTE='"+codSeguimiento+"'" +
                      " and cod_personal='"+codPersonalUsuario+"'";
             System.out.println("consulta delete anteriores registros utensilios "+consulta);
             pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
             for(int i=0;(i<dataUtensilios.length&&!dataUtensilios[0].equals(""));i++)
             {
                 consulta="INSERT INTO SEGUIMIENTO_LIMPIEZA_LOTE_UTENSILIOS(COD_SEGUIMIENTO_LIMPIEZA_LOTE,COD_MAQUINA,COD_PERSONAL)"+
                          " VALUES ('"+codSeguimiento+"','"+dataUtensilios[i]+"','"+codPersonalUsuario+"')";
                 System.out.println("consulta insert seguimiento limpieza lote utensilios "+consulta);
                 pst=con.prepareStatement(consulta);
                 if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento");
             }
             consulta="delete SEGUIMIENTO_LIMPIEZA_LOTE_FILTROS  where COD_SEGUIMIENTO_LIMPIEZA_LOTE='"+codSeguimiento+"'" +
                      " and COD_PERSONAL='"+codPersonalUsuario+"'";
             System.out.println("consulta delete seguimiento limpieza filtros "+consulta);
             pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros de limpieza de filtros");
             for(int i=0;(i<dataFiltros.length&&!dataFiltros[0].equals(""));i++)
             {
                 consulta="INSERT INTO SEGUIMIENTO_LIMPIEZA_LOTE_FILTROS(COD_SEGUIMIENTO_LIMPIEZA_LOTE,COD_FILTRO_PRODUCCION,COD_PERSONAL)"+
                          " VALUES ('"+codSeguimiento+"','"+dataFiltros[i]+"','"+codPersonalUsuario+"')";
                 System.out.println("consulta insert seguimiento limpieza filtros "+consulta);
                 pst=con.prepareStatement(consulta);
                 if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento del filtro");
             }
             for(int i=0;(i<dataSegFiltros.length&&dataSegFiltros.length>1);i+=5)
             {
                 String[] aux=dataSegFiltros[i+1].split("/");
                fechaInicio=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataSegFiltros[i+2];
                fechaFinal=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataSegFiltros[i+3];
                consulta = " INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL( COD_COMPPROD,  COD_PROGRAMA_PROD,  COD_LOTE_PRODUCCION,  COD_FORMULA_MAESTRA," +
                            "  COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE,  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,  FECHA_INICIO," +
                            "  FECHA_FINAL,HORAS_EXTRA,UNIDADES_PRODUCIDAS_EXTRA,COD_REGISTRO_ORDEN_MANUFACTURA) VALUES ( '"+codCompProd+"'," +
                            "'"+codProgProd+"','"+codLote+"'," +
                            "'"+codFormulaMaestra+"','"+codActividadEstFiltro+"'," +
                            " '"+codTipoProgramaProd+"'," +
                            " '"+dataSegFiltros[i]+"','"+dataSegFiltros[i+4]+"','0'" +
                            ",'"+fechaInicio+":00','"+fechaInicio+":00','"+fechaFinal+":00'" +
                            ",'0','0','"+contRegistroOrden+"')";
                    System.out.println("consulta insert seguimiento programa produccion personal "+consulta);
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento Personal");
             }
             for(int i=0;(i<dataSegUtensilios.length&&dataSegUtensilios.length>1);i+=5)
             {
                 String[] aux=dataSegUtensilios[i+1].split("/");
                fechaInicio=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataSegUtensilios[i+2];
                fechaFinal=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataSegUtensilios[i+3];
                consulta = " INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL( COD_COMPPROD,  COD_PROGRAMA_PROD,  COD_LOTE_PRODUCCION,  COD_FORMULA_MAESTRA," +
                            "  COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE,  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,  FECHA_INICIO," +
                            "  FECHA_FINAL,HORAS_EXTRA,UNIDADES_PRODUCIDAS_EXTRA,COD_REGISTRO_ORDEN_MANUFACTURA) VALUES ( '"+codCompProd+"'," +
                            "'"+codProgProd+"','"+codLote+"'," +
                            "'"+codFormulaMaestra+"','"+codActividadEstUtensilios+"'," +
                            " '"+codTipoProgramaProd+"'," +
                            " '"+dataSegUtensilios[i]+"','"+dataSegUtensilios[i+4]+"','0'" +
                            ",'"+fechaInicio+":00','"+fechaInicio+":00','"+fechaFinal+":00'" +
                            ",'0','0','"+contRegistroOrden+"')";
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
                      " and spp.COD_ACTIVIDAD_PROGRAMA in ('"+codActividadAutoclave+"','"+codActividadDosificado+"','"+
                        codActividadLavadoAmp+"','"+codActividadPreparado+"','"+codActividadEstFiltro+"','"+codActividadEstUtensilios+"')"+
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
