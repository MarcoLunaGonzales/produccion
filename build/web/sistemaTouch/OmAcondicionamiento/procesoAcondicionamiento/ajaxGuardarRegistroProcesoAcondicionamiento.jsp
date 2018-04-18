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
System.out.println("entro");
int codTipoPermiso=Integer.valueOf(request.getParameter("codTipoPermiso"));
int codTipoGuardado=Integer.valueOf(request.getParameter("codTipoGuardado"));
String codPersonalUsuario=request.getParameter("codPersonalUsuario");
System.out.println("entro");
//datos lote
String codLote=request.getParameter("codLote")==null?"":request.getParameter("codLote");
int codTipoProgramaProd=Integer.valueOf(request.getParameter("codTipoProgramaProd"));
int codprogramaProd=Integer.valueOf(request.getParameter("codprogramaProd"));
int codCompProd=Integer.valueOf(request.getParameter("codCompProd"));
int codFormulaMaestra=Integer.valueOf(request.getParameter("codFormulaMaestra"));
System.out.println("entro");
// datos actividad
String[] dataSeguimiento=request.getParameter("dataSeguimiento").split(",");
String[] dataMateriales=request.getParameter("dataMateriales").split(",");
String[] dataComplemento=request.getParameter("dataComplemento").split(",");
String[] dataEmbalado=request.getParameter("dataEmbalado").split(",");
int codActividadAcond=Integer.valueOf(request.getParameter("codActividadAcond"));
int codActividadEmbalado=Integer.valueOf(request.getParameter("codActividadEmbalado"));
System.out.println("entro");
//datos personal
String observacion=request.getParameter("observacion");

try
{
      
        int codSeguimiento=0;
        con=Util.openConnection(con);
        con.setAutoCommit(false);
        StringBuilder consulta=new StringBuilder("select max(s.COD_SEGUIMIENTO_ACONDICIONAMIENTO_LOTE_ACOND) as codSeguimiento");
                        consulta.append(" from SEGUIMIENTO_ACONDICIONAMIENTO_LOTE_ACOND s where s.COD_LOTE='").append(codLote).append("'");
                        consulta.append(" and s.COD_PROGRAMA_PROD=").append(codprogramaProd);
                        consulta.append(" and s.COD_TIPO_PROGRAMA_PROD=").append(codTipoProgramaProd);
                        consulta.append(" and s.COD_COMPPROD=").append(codCompProd);
        System.out.println("consulta buscar codSeguimiento "+consulta.toString());
        PreparedStatement pst=null;
        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        ResultSet res=st.executeQuery(consulta.toString());
        if(res.next())codSeguimiento=res.getInt("codSeguimiento");
        if(codSeguimiento==0)
        {
                consulta=new StringBuilder("INSERT INTO SEGUIMIENTO_ACONDICIONAMIENTO_LOTE_ACOND(COD_LOTE,COD_PROGRAMA_PROD,COD_COMPPROD,COD_TIPO_PROGRAMA_PROD,COD_ESTADO_HOJA");
                        if(codTipoPermiso==12 && codTipoGuardado==2)
                                consulta.append(",OBSERVACIONES,COD_PERSONAL_SUPERVISOR,FECHA_CIERRE");
                        consulta.append(")");
                        consulta.append(" VALUES (");
                                consulta.append("'").append(codLote).append("',");
                                consulta.append(codprogramaProd).append(",");
                                consulta.append(codCompProd).append(",");
                                consulta.append(codTipoProgramaProd).append(",");
                                consulta.append("0");
                                if(codTipoPermiso==12 && codTipoGuardado==2)
                                {
                                    consulta.append(",?,");//obnservcion
                                    consulta.append(codPersonalUsuario).append(",");
                                    consulta.append("GETDATE()");
                                }
                        consulta.append(")");
                System.out.println("consulta insert "+consulta);
                pst=con.prepareStatement(consulta.toString(),PreparedStatement.RETURN_GENERATED_KEYS);
                if(codTipoPermiso==12 && codTipoGuardado==2)pst.setString(1,observacion);
                if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento");
                res=pst.getGeneratedKeys();
                if(res.next())codSeguimiento=res.getInt(1);
        }
        else
        {
                if(codTipoPermiso==12 && codTipoGuardado==2)
                {
                    consulta=new StringBuilder("UPDATE SEGUIMIENTO_ACONDICIONAMIENTO_LOTE_ACOND ");
                            consulta.append(" SET OBSERVACIONES = ?,");
                            consulta.append(" COD_PERSONAL_SUPERVISOR =").append(codPersonalUsuario);
                            consulta.append(" ,FECHA_CIERRE = GETDATE(),");
                            consulta.append(" COD_ESTADO_HOJA='0'");
                            consulta.append(" WHERE COD_SEGUIMIENTO_ACONDICIONAMIENTO_LOTE_ACOND = ").append(codSeguimiento);
                    System.out.println("consulta update seguimiento "+consulta.toString());
                    pst=con.prepareStatement(consulta.toString());
                    pst.setString(1,observacion);System.out.println("p1: "+observacion);
                    if(pst.executeUpdate()>0)System.out.println("se modifico la cabecera de lavado");
                }

        }
         
        consulta=new StringBuilder(" delete SEGUIMIENTO_ACONDICIONAMIENTO_LOTE_ACOND_COMPL");
                    consulta.append(" where COD_SEGUIMIENTO_ACONDICIONAMIENTO_LOTE_ACOND=").append(codSeguimiento);
        System.out.println("consulta delete seguimiento complemento "+consulta.toString());
        pst=con.prepareStatement(consulta.toString());
        if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
        consulta=new StringBuilder("INSERT INTO SEGUIMIENTO_ACONDICIONAMIENTO_LOTE_ACOND_COMPL(COD_SEGUIMIENTO_ACONDICIONAMIENTO_LOTE_ACOND, COD_LOTE_PRODUCCION,CANTIDAD_COMPLEMENTO)");
                consulta.append(" VALUES(");
                        consulta.append(codSeguimiento).append(",");
                        consulta.append("?,");
                        consulta.append("?");
                consulta.append(")");
        pst=con.prepareStatement(consulta.toString());
        for(int i=0;(i<dataComplemento.length&&dataComplemento.length>1);i+=2)
        {
            pst.setString(1,dataComplemento[i]);
            pst.setString(2,dataComplemento[i+1]);
            if(pst.executeUpdate()>0)System.out.println("se registro el complemento");
        }                               

         
        consulta=new StringBuilder("delete SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL ");
                consulta.append(" where COD_PROGRAMA_PROD=").append(codprogramaProd);
                consulta.append(" and COD_LOTE_PRODUCCION='").append(codLote).append("' ");
                consulta.append(" and COD_COMPPROD=").append(codCompProd);
                consulta.append(" and COD_TIPO_PROGRAMA_PROD=").append(codTipoProgramaProd);
                consulta.append(" and COD_FORMULA_MAESTRA=").append(codFormulaMaestra);
                consulta.append(" and COD_ACTIVIDAD_PROGRAMA in (").append(codActividadAcond).append(",").append(codActividadEmbalado).append(")");
                if(codTipoPermiso<=10)
                        consulta.append(" and COD_PERSONAL=").append(codPersonalUsuario);
        System.out.println("consulta delete seguimiento personal "+consulta.toString());
        pst=con.prepareStatement(consulta.toString());
        if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
        
        consulta=new StringBuilder("DELETE FROM  SEGUIMIENTO_ACONDICIONAMIENTO_LOTE_ACOND_MATERIALES");
                    consulta.append(" WHERE COD_SEGUIMIENTO_ACONDICIONAMIENTO_LOTE_ACOND=").append(codSeguimiento);
                            if(codTipoPermiso<=10)
                                consulta.append(" and COD_PERSONAL=").append(codPersonalUsuario);
        System.out.println("consulta delete seguimiento materiales "+consulta.toString());
        pst=con.prepareStatement(consulta.toString());
        if(pst.executeUpdate()>0)System.out.println("se elimino los anteriores registros");
        
        String fechaInicio="";
        String fechaFinal="";

        consulta=new StringBuilder("INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL( COD_COMPPROD,  COD_PROGRAMA_PROD,  COD_LOTE_PRODUCCION,  COD_FORMULA_MAESTRA,");
                           consulta.append("  COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE,  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,  FECHA_INICIO,");
                           consulta.append("  FECHA_FINAL,HORAS_EXTRA,UNIDADES_PRODUCIDAS_EXTRA,COD_REGISTRO_ORDEN_MANUFACTURA)");
                    consulta.append(" values(");
                            consulta.append(codCompProd).append(",");
                            consulta.append(codprogramaProd).append(",");
                            consulta.append("'").append(codLote).append("',");
                            consulta.append(codFormulaMaestra).append(",");
                            consulta.append(codActividadAcond).append(",");
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
        
        consulta=new StringBuilder(" INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL( COD_COMPPROD,  COD_PROGRAMA_PROD,  COD_LOTE_PRODUCCION,  COD_FORMULA_MAESTRA,");
                            consulta.append("  COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE,  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,  FECHA_INICIO,");
                            consulta.append("  FECHA_FINAL,HORAS_EXTRA,UNIDADES_PRODUCIDAS_EXTRA,COD_REGISTRO_ORDEN_MANUFACTURA)");
                    consulta.append(" VALUES (");
                            consulta.append(codCompProd).append(",");
                            consulta.append(codprogramaProd).append(",");
                            consulta.append("'").append(codLote).append("',");
                            consulta.append(codFormulaMaestra).append(",");
                            consulta.append(codActividadEmbalado).append(",");
                            consulta.append(codTipoProgramaProd).append(",");
                            consulta.append("?,");//codPersonal
                            consulta.append("?,");//horas hombre
                            consulta.append("?,");//unidades producidas
                            consulta.append("GETDATE(),");//fecha registro
                            consulta.append("?,");//fecha inicio
                            consulta.append("?,");//fecha final
                            consulta.append("0,");//horas extra
                            consulta.append("0,");//unidades producidas extra
                            consulta.append("0");//cod registro om
                    consulta.append(")");
        System.out.println("consulta registro tiempo embalado"+consulta.toString());
        pst=con.prepareStatement(consulta.toString());
        for(int i=0;(i<dataEmbalado.length&&dataEmbalado.length>1);i+=6)
        {
                String[] aux=dataEmbalado[i+1].split("/");
                fechaInicio=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataEmbalado[i+2];
                fechaFinal=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataEmbalado[i+3];
                pst.setString(1,dataEmbalado[i]);System.out.println("p1:"+dataEmbalado[i]);
                pst.setString(2,dataEmbalado[i+4]);System.out.println("p2:"+dataEmbalado[i+4]);
                pst.setString(3,dataEmbalado[i+5]);System.out.println("p3:"+dataEmbalado[i+5]);
                pst.setString(4,fechaInicio);System.out.println("p4:"+fechaInicio);
                pst.setString(5,fechaFinal);System.out.println("p5:"+fechaFinal);
                if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento Personal");
                        
        }
        System.out.println("lenght"+dataMateriales.length);
        consulta=new StringBuilder("INSERT INTO SEGUIMIENTO_ACONDICIONAMIENTO_LOTE_ACOND_MATERIALES(COD_SEGUIMIENTO_ACONDICIONAMIENTO_LOTE_ACOND,COD_PERSONAL,COD_MATERIAL,COD_REGISTRO_ORDEN_MANUFACTURA,CANTIDAD)");
                            consulta.append(" VALUES(");
                                    consulta.append(codSeguimiento).append(",");
                                    consulta.append("?,");
                                    consulta.append("?,");
                                    consulta.append("?,");
                                    consulta.append("?");
                            consulta.append(")");
        System.out.println("consulta registrar materiales acond "+consulta.toString());
        pst=con.prepareStatement(consulta.toString());
        for(int i=0;(i<dataMateriales.length&&dataMateriales.length>1);i+=4)
        {
                pst.setString(1,dataMateriales[i+1]);System.out.println("p1:"+dataMateriales[i+1]);
                pst.setString(2,dataMateriales[i+2]);System.out.println("p2:"+dataMateriales[i+2]);
                pst.setString(3,dataMateriales[i]);System.out.println("p3:"+dataMateriales[i]);
                pst.setString(4,dataMateriales[i+3]);System.out.println("p4:"+dataMateriales[i+3]);
                if(pst.executeUpdate()>0)System.out.println("se registro el material");
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
                pst.setInt(5,codActividadAcond);System.out.println("p5:"+codActividadAcond);
                if(pst.executeUpdate()>0)System.out.println("se registro la aprobacion");
                pst.setInt(5,codActividadEmbalado);System.out.println("p5:"+codActividadEmbalado);
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
