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
int codTipoGuardado=Integer.valueOf(request.getParameter("codTipoGuardado"));
//datos lote
int codSeguimiento=0;
String codLote=request.getParameter("codLote")==null?"":request.getParameter("codLote");
int codprogramaProd=Integer.valueOf(request.getParameter("codprogramaProd"));
int codFormulaMaestra=Integer.valueOf(request.getParameter("codFormulaMaestra"));
int codTipoProgramaProd=Integer.valueOf(request.getParameter("codTipoProgramaProd"));
int codCompProd=Integer.valueOf(request.getParameter("codCompProd"));
//datos actividad
int codActividadEncunado=Integer.valueOf(request.getParameter("codActividadEncunado"));
int codActividadDesencunado=Integer.valueOf(request.getParameter("codActividadDesencunado"));
//datos personal
String observacion=request.getParameter("observacion");
int codTipoPermiso=Integer.valueOf(request.getParameter("codTipoPermiso"));
String codPersonalUsuario=request.getParameter("codPersonalUsuario");
String[] dataEncunado=request.getParameter("dataEncunado").split(",");
String[] dataDesencunado=request.getParameter("dataDesencunado").split(",");
try
{
        con=Util.openConnection(con);
        con.setAutoCommit(false);
        StringBuilder consulta=new StringBuilder("select MAX(s.COD_SEGUIMIENTO_ENCUNADO_DESENCUNADO_ACOND) as codSeguimiento");
                                consulta.append(" from SEGUIMIENTO_ENCUNADO_DESENCUNADO_ACOND s ");
                                consulta.append(" where s.COD_LOTE='").append(codLote).append("'");
                                            consulta.append(" and s.COD_PROGRAMA_PROD=").append(codprogramaProd);
                                            consulta.append(" and s.COD_COMPPROD=").append(codCompProd);
                                            consulta.append(" AND s.COD_TIPO_PROGRAMA_PROD=").append(codTipoProgramaProd);
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
            consulta=new StringBuilder("INSERT INTO SEGUIMIENTO_ENCUNADO_DESENCUNADO_ACOND(COD_LOTE,COD_PROGRAMA_PROD,  COD_ESTADO_HOJA , COD_COMPPROD, COD_TIPO_PROGRAMA_PROD");
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
                                        consulta.append(",?");
                                        consulta.append(",").append(codPersonalUsuario);
                                        consulta.append(",GETDATE()");
                                        
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
                    consulta=new StringBuilder("UPDATE SEGUIMIENTO_ENCUNADO_DESENCUNADO_ACOND");
                            consulta.append(" SET OBSERVACIONES = ?,");
                                    consulta.append("FECHA_CIERRE = GETDATE(),");
                                    consulta.append(" COD_ESTADO_HOJA = 0");
                                    consulta.append(" ,COD_PERSONAL_SUPERVISOR=").append(codPersonalUsuario);
                            consulta.append(" WHERE COD_SEGUIMIENTO_ENCUNADO_DESENCUNADO_ACOND =").append(codSeguimiento);
                    System.out.println("consulta update seguimiento "+consulta.toString());
                    pst=con.prepareStatement(consulta.toString());
                    pst.setString(1,observacion);System.out.println("p1:"+observacion);
                    if(pst.executeUpdate()>0)System.out.println("se modifico la cabecera de lavado");
                }

        }
        consulta=new StringBuilder("delete SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL");
                    consulta.append(" where COD_PROGRAMA_PROD=").append(codprogramaProd);
                            consulta.append(" and COD_LOTE_PRODUCCION='").append(codLote).append("'");
                            consulta.append(" and COD_COMPPROD=").append(codCompProd);
                            consulta.append(" and COD_FORMULA_MAESTRA=").append(codFormulaMaestra);
                            consulta.append(" and COD_TIPO_PROGRAMA_PROD=").append(codTipoProgramaProd);
                            consulta.append(" and COD_ACTIVIDAD_PROGRAMA in (").append(codActividadEncunado).append(",").append(codActividadDesencunado).append(")");
                            if(codTipoPermiso<=10)
                                consulta.append(" and COD_PERSONAL=").append(codPersonalUsuario);
        System.out.println("consulta delete seguimiento personal "+consulta.toString());
        pst=con.prepareStatement(consulta.toString());
        if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");

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
                                consulta.append(codActividadEncunado).append(",");
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
                                consulta.append("?");//cod registro om
                        consulta.append(")");
        System.out.println("consulta registro tiempo "+consulta.toString());
        pst=con.prepareStatement(consulta.toString());

        for(int i=0;(i<dataEncunado.length&&dataEncunado.length>1);i+=6)
        {
                String[] aux=dataEncunado[i+1].split("/");
                fechaInicio=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataEncunado[i+2];
                fechaFinal=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataEncunado[i+3];

                pst.setString(1,dataEncunado[i]);System.out.println("p1:"+dataEncunado[i]);
                pst.setString(2,dataEncunado[i+4]);System.out.println("p2:"+dataEncunado[i+4]);
                pst.setString(3,fechaInicio);System.out.println("p3:"+fechaInicio);
                pst.setString(4,fechaFinal);System.out.println("p4:"+fechaFinal);
                pst.setInt(5,i);System.out.println("p5:"+i);
                pst.setString(6,dataEncunado[i+5]);System.out.println("p6:"+dataEncunado[i+5]);
                if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento Personal");
        }
        
        consulta=new StringBuilder("INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL(COD_COMPPROD,COD_PROGRAMA_PROD,COD_LOTE_PRODUCCION,COD_FORMULA_MAESTRA,");
                                consulta.append(" COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE,  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,  FECHA_INICIO,");
                                consulta.append(" FECHA_FINAL,HORAS_EXTRA,UNIDADES_PRODUCIDAS_EXTRA,COD_REGISTRO_ORDEN_MANUFACTURA,UNIDADES_FRV)");
                        consulta.append(" VALUES (");
                                consulta.append(codCompProd).append(",");
                                consulta.append(codprogramaProd).append(",");
                                consulta.append("'").append(codLote).append("',");
                                consulta.append(codFormulaMaestra).append(",");
                                consulta.append(codActividadDesencunado).append(",");
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
                                consulta.append("?");//cod registro om
                        consulta.append(")");
        System.out.println("consulta registro tiempo "+consulta.toString());
        pst=con.prepareStatement(consulta.toString());
        for(int i=0;(i<dataDesencunado.length&&dataDesencunado.length>1);i+=6)
        {
                String[] aux=dataDesencunado[i+1].split("/");
                fechaInicio=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataDesencunado[i+2];
                fechaFinal=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataDesencunado[i+3];

                pst.setString(1,dataDesencunado[i]);System.out.println("p1:"+dataDesencunado[i]);
                pst.setString(2,dataDesencunado[i+4]);System.out.println("p2:"+dataDesencunado[i+4]);
                pst.setString(3,fechaInicio);System.out.println("p3:"+fechaInicio);
                pst.setString(4,fechaFinal);System.out.println("p4:"+fechaFinal);
                pst.setInt(5,i);System.out.println("p5:"+i);
                pst.setString(6,dataDesencunado[i+5]);System.out.println("p6:"+dataDesencunado[i+5]);
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
            pst.setInt(5,codActividadEncunado);System.out.println("p5:"+codActividadEncunado);
            if(pst.executeUpdate()>0)System.out.println("se registro la aprobacion");
            pst.setInt(5,codActividadDesencunado);
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
