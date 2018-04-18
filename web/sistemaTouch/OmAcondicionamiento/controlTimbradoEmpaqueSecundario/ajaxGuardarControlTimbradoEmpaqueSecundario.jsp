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
int codSeguimiento=0;
//datos lote
String codLote=request.getParameter("codLote")==null?"":request.getParameter("codLote");
int codprogramaProd=Integer.valueOf(request.getParameter("codprogramaProd"));
int codFormulaMaestra=Integer.valueOf(request.getParameter("codFormulaMaestra"));
int codTipoProgramaProd=Integer.valueOf(request.getParameter("codTipoProgramaProd"));
int codCompProd=Integer.valueOf(request.getParameter("codCompProd"));
//datos actividad
int codActividadTimbrado=Integer.valueOf(request.getParameter("codActividadTimbrado"));
int codActividadDoblado=Integer.valueOf(request.getParameter("codActividadDoblado"));
String[] dataMateriales=request.getParameter("dataMateriales").split(",");
String[] dataDoblado=request.getParameter("dataDoblado").split(",");
//datos administrador
String observacion=request.getParameter("observacion");
int codTipoPermiso=Integer.valueOf(request.getParameter("codTipoPermiso"));
int codTipoGuardado=Integer.valueOf(request.getParameter("codTipoGuardado"));
String codPersonalUsuario=request.getParameter("codPersonalUsuario");
try
{
        con=Util.openConnection(con);
        con.setAutoCommit(false);
        StringBuilder consulta=new StringBuilder("select max(s.COD_SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND) AS codSeguimiento");
                                consulta.append(" from SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND s");
                                consulta.append(" where s.cod_lote='").append(codLote).append("'");
                                consulta.append(" and s.cod_programa_prod=").append(codprogramaProd);
                                consulta.append(" and s.cod_compprod=").append(codCompProd);
                                consulta.append(" and s.cod_tipo_programa_prod=").append(codTipoProgramaProd);
        System.out.println("consulta buscar codSeguimiento "+consulta.toString());
        PreparedStatement pst=null;
        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        ResultSet res=st.executeQuery(consulta.toString());
        if(res.next())codSeguimiento=res.getInt("codSeguimiento");
        if(codSeguimiento==0)
        {
                consulta=new StringBuilder("INSERT INTO SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND(COD_LOTE, COD_PROGRAMA_PROD,COD_COMPPROD,COD_TIPO_PROGRAMA_PROD,  COD_ESTADO_HOJA");
                            if(codTipoPermiso==12&&codTipoGuardado==2)
                                    consulta.append(", OBSERVACIONES,COD_PERSONAL_SUPERVISOR, FECHA_CIERRE");
                            consulta.append(")");
                            consulta.append(" VALUES (");
                                    consulta.append("'").append(codLote).append("',");
                                    consulta.append(codprogramaProd).append(",");
                                    consulta.append(codCompProd).append(",");
                                    consulta.append(codTipoProgramaProd).append(",");
                                    consulta.append("0");
                                    if(codTipoPermiso==12&&codTipoGuardado==2)
                                    {
                                        consulta.append(",?,");
                                        consulta.append(codPersonalUsuario).append(",");
                                        consulta.append("GETDATE()");
                                    }
                            consulta.append(")");
                System.out.println("consulta insert "+consulta.toString());
                pst=con.prepareStatement(consulta.toString(),PreparedStatement.RETURN_GENERATED_KEYS);
                if(codTipoPermiso==12&&codTipoGuardado==2)pst.setString(1,observacion);
                if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento");
                res=pst.getGeneratedKeys();
                if(res.next())codSeguimiento=res.getInt(1);
        }
        else
        {
                if(codTipoPermiso==12&&codTipoGuardado==2)
                {
                    consulta=new StringBuilder("UPDATE SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND ");
                                consulta.append(" set OBSERVACIONES = ?,");
                                consulta.append(" COD_PERSONAL_SUPERVISOR =").append(codPersonalUsuario).append(",");
                                consulta.append(" FECHA_CIERRE = GETDATE(),");
                                consulta.append(" COD_ESTADO_HOJA = 0 " );
                                consulta.append(" WHERE COD_SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND = ").append(codSeguimiento);
                    System.out.println("consulta update seguimiento "+consulta.toString());
                    pst=con.prepareStatement(consulta.toString());
                    pst.setString(1,observacion);System.out.println("p1:"+observacion);
                    if(pst.executeUpdate()>0)System.out.println("se modifico la cabecera de lavado");
                }
        }
        consulta=new StringBuilder("delete SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND_MATERIALES ");
                consulta.append(" where COD_SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND=").append(codSeguimiento);
                        if(codTipoPermiso<=10)
                                    consulta.append(" and COD_PERSONAL=").append(codPersonalUsuario);
        System.out.println("consulta delete anteriores ampollas "+consulta.toString());
        pst=con.prepareStatement(consulta.toString());
        if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros ");

        consulta=new StringBuilder("delete SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL");
                consulta.append(" where COD_PROGRAMA_PROD=").append(codprogramaProd);
                            consulta.append(" and COD_LOTE_PRODUCCION='").append(codLote).append("'");
                            consulta.append(" and COD_COMPPROD=").append(codCompProd);
                            consulta.append(" and COD_FORMULA_MAESTRA=").append(codFormulaMaestra);
                            consulta.append(" and COD_TIPO_PROGRAMA_PROD=").append(codTipoProgramaProd);
                            consulta.append(" and COD_ACTIVIDAD_PROGRAMA in (").append(codActividadTimbrado).append(",").append(codActividadDoblado).append(")");
                            if(codTipoPermiso<=10)
                                    consulta.append(" and COD_PERSONAL=").append(codPersonalUsuario);
        System.out.println("consulta delete seguimiento personal "+consulta.toString());
        pst=con.prepareStatement(consulta.toString());
        if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");

        String fechaInicio="";
        String fechaFinal="";
        
        consulta=new StringBuilder("INSERT INTO SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND_MATERIALES(COD_SEGUIMIENTO_TIMBRADO_ES_LOTE_ACOND, COD_PERSONAL,COD_REGISTRO_ORDEN_MANUFACTURA, COD_MATERIAL, CANTIDAD_TIMBRADA)");
                    consulta.append("VALUES (");
                            consulta.append(codSeguimiento).append(",");
                            consulta.append("?,");//codPersonal
                            consulta.append("?,");//codRegistro om
                            consulta.append("?,");//cod material
                            consulta.append("?");//cantoidad material
                    consulta.append(")");
        System.out.println("consulta registrar timbrado es "+consulta.toString());
        pst=con.prepareStatement(consulta.toString());
        consulta=new StringBuilder("INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL( COD_COMPPROD,  COD_PROGRAMA_PROD,  COD_LOTE_PRODUCCION,  COD_FORMULA_MAESTRA,");
                            consulta.append("  COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE,  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,  FECHA_INICIO,");
                            consulta.append("  FECHA_FINAL,HORAS_EXTRA,UNIDADES_PRODUCIDAS_EXTRA,COD_REGISTRO_ORDEN_MANUFACTURA)");
                    consulta.append("VALUES (");
                            consulta.append(codCompProd).append(",");
                            consulta.append(codprogramaProd).append(",");
                            consulta.append("'").append(codLote).append("',");
                            consulta.append(codFormulaMaestra).append(",");
                            consulta.append(codActividadTimbrado).append(",");
                            consulta.append(codTipoProgramaProd).append(",");
                            consulta.append("?,");//cod personal
                            consulta.append("?,");//horas hombre
                            consulta.append("?,");//unidades producidas
                            consulta.append("getdate(),");//fecha registro
                            consulta.append("?,");//fecha inicio
                            consulta.append("?,");//fecha final
                            consulta.append("0,");
                            consulta.append("0,");
                            consulta.append("?");//cod registro om
                    consulta.append(")");
        System.out.println("consulta registrar tiempo "+consulta.toString());
        PreparedStatement pstTiempo=con.prepareStatement(consulta.toString());
        for(int i=0;(i<dataMateriales.length&&dataMateriales.length>1);i+=7)
        {
                pst.setString(1,dataMateriales[i]);System.out.println("p1:"+dataMateriales[i]);
                pst.setInt(2,(i+1));System.out.println("p2:"+(i+1));
                pst.setString(3,dataMateriales[i+5]);System.out.println("p3:"+dataMateriales[i+5]);
                pst.setString(4,dataMateriales[i+6]);System.out.println("p4:"+dataMateriales[i+6]);
                if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento de ampollas");

                String[] aux=dataMateriales[i+1].split("/");
                fechaInicio=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataMateriales[i+2];
                fechaFinal=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataMateriales[i+3];

                pstTiempo.setString(1,dataMateriales[i]);System.out.println("p1:"+dataMateriales[i]);
                pstTiempo.setString(2,dataMateriales[i+4]);System.out.println("p2:"+dataMateriales[i+4]);
                pstTiempo.setString(3,dataMateriales[i+6]);System.out.println("p3:"+dataMateriales[i+6]);
                pstTiempo.setString(4,fechaInicio);System.out.println("p4:"+fechaInicio);
                pstTiempo.setString(5,fechaFinal);System.out.println("p5:"+fechaFinal);
                pstTiempo.setInt(6,(i+1));System.out.println("p6:"+(i+1));
                if(pstTiempo.executeUpdate()>0)System.out.println("se registro el seguimiento Personal");
        }
        
        consulta=new StringBuilder("INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL( COD_COMPPROD,  COD_PROGRAMA_PROD,  COD_LOTE_PRODUCCION,  COD_FORMULA_MAESTRA,");
                            consulta.append("  COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE,  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,  FECHA_INICIO,");
                            consulta.append("  FECHA_FINAL,HORAS_EXTRA,UNIDADES_PRODUCIDAS_EXTRA,COD_REGISTRO_ORDEN_MANUFACTURA)");
                    consulta.append("VALUES (");
                            consulta.append(codCompProd).append(",");
                            consulta.append(codprogramaProd).append(",");
                            consulta.append("'").append(codLote).append("',");
                            consulta.append(codFormulaMaestra).append(",");
                            consulta.append(codActividadDoblado).append(",");
                            consulta.append(codTipoProgramaProd).append(",");
                            consulta.append("?,");//cod personal
                            consulta.append("?,");//horas hombre
                            consulta.append("?,");//unidades producidas
                            consulta.append("getdate(),");//fecha registro
                            consulta.append("?,");//fecha inicio
                            consulta.append("?,");//fecha final
                            consulta.append("0,");
                            consulta.append("0,");
                            consulta.append("?");//cod registro om
                    consulta.append(")");
        System.out.println("consulta registrar tiempo "+consulta.toString());
        pstTiempo=con.prepareStatement(consulta.toString());
        for(int i=0;(i<dataDoblado.length&&dataDoblado.length>1);i+=6)
        {
                String[] aux=dataDoblado[i+1].split("/");
                fechaInicio=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataDoblado[i+2];
                fechaFinal=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataDoblado[i+3];
                
                pstTiempo.setString(1,dataDoblado[i]);System.out.println("p1:"+dataDoblado[i]);
                pstTiempo.setString(2,dataDoblado[i+4]);System.out.println("p2:"+dataDoblado[i+4]);
                pstTiempo.setString(3,dataDoblado[i+5]);System.out.println("p3:"+dataDoblado[i+5]);
                pstTiempo.setString(4,fechaInicio);System.out.println("p4:"+fechaInicio);
                pstTiempo.setString(5,fechaFinal);System.out.println("p5:"+fechaFinal);
                pstTiempo.setInt(6,(i+1));System.out.println("p6:"+(i+1));
                if(pstTiempo.executeUpdate()>0)System.out.println("se registro el seguimiento Personal");
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
                pst.setInt(5,codActividadDoblado);System.out.println("p5:"+codActividadDoblado);
                if(pst.executeUpdate()>0)System.out.println("se registro la aprobacion");
                pst.setInt(5,codActividadTimbrado);System.out.println("p5:"+codActividadTimbrado);
                if(pst.executeUpdate()>0)System.out.println("se registro la aprobacion");
        
        con.commit();
        mensaje="1";
    
}
catch(SQLException ex)
{
    mensaje="Ocurrio un error a la hora del registro intente de nuevo";
    ex.printStackTrace();
    con.rollback();
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
