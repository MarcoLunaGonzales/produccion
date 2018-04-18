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
try
{
        int codSeguimiento=0;
        int codTipoPermiso=Integer.valueOf(request.getParameter("codTipoPermiso"));
        String codLote=request.getParameter("codLote")==null?"":request.getParameter("codLote");
        int codprogramaProd=Integer.valueOf(request.getParameter("codprogramaProd"));
        int codFormulaMaestra=Integer.valueOf(request.getParameter("codFormulaMaestra"));
        int codTipoProgramaProd=Integer.valueOf(request.getParameter("codTipoProgramaProd"));
        int codCompProd=Integer.valueOf(request.getParameter("codCompProd"));
        int codActividadLavadoAmpollas=Integer.valueOf(request.getParameter("codActividadLavadoAmpollas"));
        System.out.println("entro");
        String observacion=request.getParameter("observacion");
        String[] dataAmpollasLavadas=request.getParameter("dataAmpollasAcond").split(",");
        String codPersonalUsuario=request.getParameter("codPersonalUsuario");
        int codTipoGuardado=Integer.valueOf(request.getParameter("codTipoGuardado"));
        con=Util.openConnection(con);
        con.setAutoCommit(false);
        StringBuilder consulta=new StringBuilder("select MAX(s.COD_SEGUIMIENTO_LAVADO_LOTE_ACOND) as codSeguimiento");
                            consulta.append(" from SEGUIMIENTO_LAVADO_LOTE_ACOND s");
                            consulta.append(" where s.COD_LOTE='").append(codLote).append("'");
                                    consulta.append(" and s.COD_PROGRAMA_PROD='").append(codprogramaProd).append("'");
                                    consulta.append(" and s.COD_COMPPROD='").append(codCompProd).append("'");
                                    consulta.append(" AND s.COD_TIPO_PROGRAMA_PROD='").append(codTipoProgramaProd).append("'");
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
                consulta=new StringBuilder("INSERT INTO SEGUIMIENTO_LAVADO_LOTE_ACOND(COD_LOTE,COD_PROGRAMA_PROD,COD_ESTADO_HOJA, COD_COMPPROD, COD_TIPO_PROGRAMA_PROD");
                        if(codTipoPermiso==12&&codTipoGuardado==2)
                            consulta.append(",OBSERVACIONES,COD_PERSONAL_SUPERVISOR, FECHA_CIERRE");
                        consulta.append(")");
                        consulta.append(" VALUES (");
                                consulta.append("'").append(codLote).append("',");
                                consulta.append(codprogramaProd).append(",");
                                consulta.append("0,");
                                consulta.append(codCompProd).append(",");
                                consulta.append(codTipoProgramaProd);
                                if(codTipoPermiso==12&&codTipoGuardado==2)
                                {
                                    consulta.append("?,");
                                    consulta.append(codPersonalUsuario).append(",");
                                    consulta.append("GETDATE()");
                                }
                        consulta.append(")");
            System.out.println("consulta REGISTRAR SEGUIMIENTO LAVADO LOTE ACOND "+consulta.toString());
            pst=con.prepareStatement(consulta.toString());
            if(codTipoPermiso==12&&codTipoGuardado==2)
            {
                pst.setString(1,observacion);
                System.out.println("p1:"+observacion);
            }
            if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento");
         }
         else
         {
             if(codTipoPermiso==12&&codTipoGuardado==2)
             {
                 consulta=new StringBuilder(" UPDATE SEGUIMIENTO_LAVADO_LOTE_ACOND");
                          consulta.append(" SET OBSERVACIONES = ?,");
                          consulta.append(" FECHA_CIERRE = GETDATE(),");
                          consulta.append(" COD_ESTADO_HOJA = 0");
                          consulta.append(" ,COD_PERSONAL_SUPERVISOR=").append(codPersonalUsuario);
                          consulta.append(" WHERE COD_SEGUIMIENTO_LAVADO_LOTE_ACOND =").append(codSeguimiento);
                 System.out.println("consulta update seguimiento "+consulta.toString());
                 pst=con.prepareStatement(consulta.toString());
                 pst.setString(1,observacion);System.out.println("p1:"+observacion);
                 if(pst.executeUpdate()>0)System.out.println("se modifico la cabecera de lavado");
             }
        }
        consulta=new StringBuilder("delete SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL ");
                    consulta.append(" where COD_PROGRAMA_PROD=").append(codprogramaProd);
                            consulta.append(" and COD_LOTE_PRODUCCION='").append(codLote).append("'");
                            consulta.append(" and COD_COMPPROD=").append(codCompProd);
                            consulta.append(" and COD_FORMULA_MAESTRA=").append(codFormulaMaestra);
                            consulta.append(" and COD_TIPO_PROGRAMA_PROD=").append(codTipoProgramaProd);
                            consulta.append(" and COD_ACTIVIDAD_PROGRAMA =").append(codActividadLavadoAmpollas);
                            if(codTipoPermiso<=10)
                                    consulta.append(" and COD_PERSONAL=").append(codPersonalUsuario);
        System.out.println("consulta delete seguimiento personal "+consulta.toString());
        pst=con.prepareStatement(consulta.toString());
        if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
        //REGISTRANDO SEGUIMIENTO PERSONAL
        String fechaInicio="";
        String fechaFinal="";
        consulta=new StringBuilder("INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL(COD_COMPPROD,COD_PROGRAMA_PROD,COD_LOTE_PRODUCCION,COD_FORMULA_MAESTRA,");
                                    consulta.append(" COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE,  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,  FECHA_INICIO,");
                                    consulta.append(" FECHA_FINAL,HORAS_EXTRA,UNIDADES_PRODUCIDAS_EXTRA,COD_REGISTRO_ORDEN_MANUFACTURA,UNIDADES_FRV)");
                            consulta.append(" VALUES (");
                                    consulta.append(codCompProd).append(",");
                                    consulta.append(codprogramaProd).append(",");
                                    consulta.append("'").append(codLote).append("',");
                                    consulta.append(codFormulaMaestra).append(",");
                                    consulta.append(codActividadLavadoAmpollas).append(",");
                                    consulta.append(codTipoProgramaProd).append(",");
                                    consulta.append("?,");//codPersonal
                                    consulta.append("?,");//horas hombre
                                    consulta.append("0,");//unidades producidas
                                    consulta.append("GETDATE(),");//fecha registro
                                    consulta.append("?,");//fecha inicio
                                    consulta.append("?,");//fecha final
                                    consulta.append("0,");//horas extra
                                    consulta.append("0,");//unidades producidas extra
                                    consulta.append("?,");//cod registro om
                                    consulta.append("?");//unidades frv
                            consulta.append(")");
        System.out.println("consulta registro tiempo "+consulta.toString());
        pst=con.prepareStatement(consulta.toString());
        for(int i=0;(i<dataAmpollasLavadas.length&&dataAmpollasLavadas.length>1);i+=6)
        {
                String[] aux=dataAmpollasLavadas[i+1].split("/");
                fechaInicio=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataAmpollasLavadas[i+2];
                fechaFinal=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataAmpollasLavadas[i+3];
                pst.setString(1,dataAmpollasLavadas[i]);System.out.println("p1:"+dataAmpollasLavadas[i]);
                pst.setString(2,dataAmpollasLavadas[i+4]);System.out.println("p2:"+dataAmpollasLavadas[i+4]);
                pst.setString(3,fechaInicio);System.out.println("p3:"+fechaInicio);
                pst.setString(4,fechaFinal);System.out.println("p4:"+fechaFinal);
                pst.setInt(5,i);System.out.println("p5:"+i);
                pst.setString(6,dataAmpollasLavadas[i+5]);System.out.println("p6:"+dataAmpollasLavadas[i+5]);
                if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento Personal");
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
                pst.setInt(5,codActividadLavadoAmpollas);System.out.println("p5:"+codActividadLavadoAmpollas);
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
}
finally
{
        con.close();
}
out.clear();

out.println(mensaje);


%>
