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
Connection con=null;
String mensaje="";
//datos lote

String codLote=request.getParameter("codLote")==null?"":request.getParameter("codLote");
int codprogramaProd=Integer.valueOf(request.getParameter("codprogramaProd"));
int codFormulaMaestra=Integer.valueOf(request.getParameter("codFormulaMaestra"));
int codTipoProgramaProd=Integer.valueOf(request.getParameter("codTipoProgramaProd"));
int codCompProd=Integer.valueOf(request.getParameter("codCompProd"));
//datos actividades

int codActividadInspeccion=Integer.valueOf(request.getParameter("codActividadInspeccion"));
String observacion=request.getParameter("observacion");
int codTipoPermiso=Integer.valueOf(request.getParameter("codTipoPermiso"));
int codTipoGuardado=Integer.valueOf(request.getParameter("codTipoGuardado"));//Integer.valueOf(request.getParameter("codTipoGuardado"));
String codPersonalUsuario=request.getParameter("codPersonalUsuario");
String[] dataSeguimiento=request.getParameter("dataSeguimiento").split(",");
String[] dataDefectosEncontrados=request.getParameter("dataDefectosEncontrados").split(",");
try
{
        int codSeguimiento=0;


        con=Util.openConnection(con);
        con.setAutoCommit(false);
        StringBuilder consulta=new StringBuilder("select max(sila.COD_SEGUIMIENTO_INSPECCION_LOTE_ACOND) as codSeguimiento");
                                consulta.append(" from SEGUIMIENTO_INSPECCION_LOTE_ACOND sila ");
                                consulta.append(" where sila.COD_LOTE='").append(codLote).append("'");
                                        consulta.append(" and sila.COD_PROGRAMA_PROD=").append(codprogramaProd);
                                        consulta.append(" and sila.COD_TIPO_PROGRAMA_PROD=").append(codTipoProgramaProd);
        System.out.println("consulta buscar codSeguimiento "+consulta.toString());
        PreparedStatement pst=null;
        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        ResultSet res=st.executeQuery(consulta.toString());
        if(res.next())
        {
                codSeguimiento=res.getInt("codSeguimiento");
         }
        SimpleDateFormat sdf =new SimpleDateFormat("yyyy/MM/dd HH:mm");
        if(codSeguimiento==0)
        {
                consulta=new StringBuilder(" INSERT INTO SEGUIMIENTO_INSPECCION_LOTE_ACOND(COD_LOTE,COD_PROGRAMA_PROD,COD_COMPPROD,COD_TIPO_PROGRAMA_PROD, COD_ESTADO_HOJA");
                                if(codTipoPermiso==12&&codTipoGuardado==2)
                                    consulta.append(",OBSERVACIONES,COD_PERSONAL_SUPERVISOR, FECHA_CIERRE");
                                consulta.append(")");
                                consulta.append(" VALUES (");
                                        consulta.append("'").append(codLote).append("',");
                                        consulta.append(codprogramaProd).append(",");
                                        consulta.append(codCompProd).append(",");
                                        consulta.append(codTipoProgramaProd).append(",");
                                        consulta.append("0");
                                        if(codTipoPermiso==12&&codTipoGuardado==2)
                                        {
                                            consulta.append("?,");
                                            consulta.append(codPersonalUsuario).append(",");
                                            consulta.append("GETDATE()");
                                        }
                                consulta.append(")");
                System.out.println("consulta insert "+consulta.toString());
                pst=con.prepareStatement(consulta.toString(),PreparedStatement.RETURN_GENERATED_KEYS);
                if(codTipoPermiso==12&&codTipoGuardado==2)
                    pst.setString(1,observacion);
                if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento");
                res=pst.getGeneratedKeys();
                if(res.next())codSeguimiento=res.getInt(1);
        }
        else
        {
                if(codTipoPermiso==12&&codTipoGuardado==2)
                {
                        consulta=new StringBuilder("UPDATE SEGUIMIENTO_INSPECCION_LOTE_ACOND");
                                    consulta.append(" set OBSERVACIONES = ?,");
                                    consulta.append(" COD_PERSONAL_SUPERVISOR =").append(codPersonalUsuario);
                                    consulta.append(" ,FECHA_CIERRE = GETDATE(),");
                                    consulta.append(" COD_ESTADO_HOJA = 0");
                                    consulta.append(" WHERE COD_SEGUIMIENTO_INSPECCION_LOTE_ACOND =").append(codSeguimiento);
                        System.out.println("consulta update seguimiento "+consulta.toString());
                        pst=con.prepareStatement(consulta.toString());
                        pst.setString(1,observacion);System.out.println("p1:"+observacion);
                        if(pst.executeUpdate()>0)System.out.println("se modifico la cabecera de lavado");
                }

        }
        consulta=new StringBuilder("DELETE DEFECTOS_ENVASE_PROGRAMA_PRODUCCION");
                    consulta.append(" WHERE COD_SEGUIMIENTO_INSPECCION_LOTE_ACOND=").append(codSeguimiento);
                            if(codTipoPermiso<=10)
                                    consulta.append(" AND COD_PERSONAL=").append(codPersonalUsuario);

        System.out.println("consulta delete anteriores ampollas "+consulta.toString());
        pst=con.prepareStatement(consulta.toString());
        if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros ");

        consulta=new StringBuilder("delete SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL");
                    consulta.append(" where COD_PROGRAMA_PROD=").append(codprogramaProd);
                            consulta.append(" and COD_LOTE_PRODUCCION='").append(codLote).append("'");
                            consulta.append(" and COD_COMPPROD=").append(codCompProd);
                            consulta.append(" and COD_FORMULA_MAESTRA=").append(codFormulaMaestra);
                            consulta.append(" and COD_TIPO_PROGRAMA_PROD=").append(codTipoProgramaProd);
                            consulta.append(" and COD_ACTIVIDAD_PROGRAMA =").append(codActividadInspeccion);
                                    if(codTipoPermiso<=10)
                                            consulta.append(" AND COD_PERSONAL=").append(codPersonalUsuario);
        System.out.println("consulta delete seguimiento personal "+consulta.toString());
        pst=con.prepareStatement(consulta.toString());
        if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
        String fechaInicio="";
        String fechaFinal="";
        consulta=new StringBuilder("INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL( COD_COMPPROD,  COD_PROGRAMA_PROD,  COD_LOTE_PRODUCCION,  COD_FORMULA_MAESTRA,");
                            consulta.append(" COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE,  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,  FECHA_INICIO,");
                            consulta.append(" FECHA_FINAL,HORAS_EXTRA,UNIDADES_PRODUCIDAS_EXTRA,COD_REGISTRO_ORDEN_MANUFACTURA)");
                    consulta.append(" VALUES (");
                            consulta.append(codCompProd).append(",");
                            consulta.append(codprogramaProd).append(",");
                            consulta.append("'").append(codLote).append("',");
                            consulta.append(codFormulaMaestra).append(",");
                            consulta.append(codActividadInspeccion).append(",");
                            consulta.append(codTipoProgramaProd).append(",");
                            consulta.append("?,");//codPersonal
                            consulta.append("?,");//horas hombre
                            consulta.append("?,");//unidades producidas
                            consulta.append("GETDATE(),");//fecha registro
                            consulta.append("?,");//fecha inicio
                            consulta.append("?,");//fecha final
                            consulta.append("0,");//horas extra
                            consulta.append("0,");//unidades producidas extra
                            consulta.append("?");//cod registro om
                    consulta.append(")");
        System.out.println("consulta registro tiempo "+consulta.toString());
        pst=con.prepareStatement(consulta.toString());
        for(int i=0;(i<dataSeguimiento.length&&dataSeguimiento.length>1);i+=7)
        {
                    String[] aux=dataSeguimiento[i+2].split("/");
                    fechaInicio=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataSeguimiento[i+3];
                    fechaFinal=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataSeguimiento[i+4];

                    pst.setString(1,dataSeguimiento[i+1]);System.out.println("p1:"+dataSeguimiento[i+1]);
                    pst.setString(2,dataSeguimiento[i+6]);System.out.println("p2:"+dataSeguimiento[i+6]);
                    pst.setString(3,dataSeguimiento[i+5]);System.out.println("p3:"+dataSeguimiento[i+5]);
                    pst.setString(4,fechaInicio);System.out.println("p4:"+fechaInicio);
                    pst.setString(5,fechaFinal);System.out.println("p5:"+fechaFinal);
                    pst.setString(6,dataSeguimiento[i]);System.out.println("p6:"+dataSeguimiento[i]);
                    if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento Personal");
        }
        consulta=new StringBuilder("INSERT INTO DEFECTOS_ENVASE_PROGRAMA_PRODUCCION(COD_DEFECTO_ENVASE, COD_PERSONAL");
                            consulta.append(",CANTIDAD_DEFECTOS_ENCONTRADOS, COD_PERSONAL_OPERARIO,COD_SEGUIMIENTO_INSPECCION_LOTE_ACOND, COD_REGISTRO_ORDEN_MANUFACTURA)");
                     consulta.append(" VALUES(");
                            consulta.append("?,");//cod defecto envase
                            consulta.append("?,");//cod personal envase
                            consulta.append("?,");//cantidad defectos encontrados
                            consulta.append("?,");//cod personal envasador
                            consulta.append(codSeguimiento).append(",");
                            consulta.append("?");//cod registro om
                     consulta.append(")");
        System.out.println("consulta registrar defectos "+consulta.toString());
        pst=con.prepareStatement(consulta.toString());
        for(int i=0;(i<dataDefectosEncontrados.length&&dataDefectosEncontrados.length>1);i+=5)
        {
            pst.setString(1,dataDefectosEncontrados[i+3]);System.out.println("p1:"+dataDefectosEncontrados[i+3]);
            pst.setString(2,dataDefectosEncontrados[i]);System.out.println("p2:"+dataDefectosEncontrados[i]);
            pst.setString(3,dataDefectosEncontrados[i+4]);System.out.println("p3:"+dataDefectosEncontrados[i+4]);
            pst.setString(4,dataDefectosEncontrados[i+1]);System.out.println("p4:"+dataDefectosEncontrados[i+1]);
            pst.setString(5,dataDefectosEncontrados[i+2]);System.out.println("p5:"+dataDefectosEncontrados[i+2]);
            if(pst.executeUpdate()>0)System.out.println("se registro el defecto");
        }

                consulta=new StringBuilder(" exec PAA_REGISTRO_SEGUIMIENTO_PROGRAMA_PRODUCCION ");
                                        consulta.append("?,");//cod lote produccion
                                        consulta.append("?,");//cod programa prod
                                        consulta.append("?,");//cod compprod
                                        consulta.append("?,");//cod tipo programa prod
                                        consulta.append("?");//cod actividad formula
                System.out.println("consulta aprobar tiempo "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                pst.setString(1,codLote);System.out.println("p1:"+codLote);
                pst.setInt(2,codprogramaProd);System.out.println("p2:"+codprogramaProd);
                pst.setInt(3,codCompProd);System.out.println("p3:"+codCompProd);
                pst.setInt(4,codTipoProgramaProd);System.out.println("p4:"+codTipoProgramaProd);
                pst.setInt(5,codActividadInspeccion);System.out.println("p5:"+codActividadInspeccion);
                if(pst.executeUpdate()>0)System.out.println("se registro la aprobacion");
     
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
