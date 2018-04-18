<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>
<%
String codLote=request.getParameter("codLote");
String codProgramaProd=request.getParameter("codProgramaProd");
String codTipoProduccion=request.getParameter("codTipoProduccion");
String codActividadPrograma=request.getParameter("codActividadPrograma");
String codFormula=request.getParameter("codFormula");
String codCompProd=request.getParameter("codCompProd");
String codMaquina=request.getParameter("codMaquina");
String horasMaquina=request.getParameter("horasMaquina");
String[] dataSeguimientoPersonal=request.getParameter("dataSeguimientoPersonal").split(",");
boolean admin=(Integer.valueOf(request.getParameter("admin"))>0);
String codPersonalRegistro=request.getParameter("codPersonalRegistro");
String observacion=request.getParameter("observacionLote");
Connection con=null;
String mensaje="";
try
{
    con=Util.openConnection(con);
    con.setAutoCommit(false);
    
    String consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION where COD_PROGRAMA_PROD='"+codProgramaProd+"'"+
                    " and COD_LOTE_PRODUCCION='"+codLote+"' and COD_COMPPROD='"+codCompProd+"'"+
                    " and COD_FORMULA_MAESTRA='"+codFormula+"' and COD_TIPO_PROGRAMA_PROD='"+codTipoProduccion+"' and"+
                    " COD_ACTIVIDAD_PROGRAMA='"+codActividadPrograma+"'";
    System.out.println("consulta delete seguimiento anterior "+consulta);
    PreparedStatement pst=con.prepareStatement(consulta);
    if(pst.executeUpdate()>0)System.out.println("se eliminaron registros anteriores de seguimiento programa produccion");
    consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL where COD_PROGRAMA_PROD='"+codProgramaProd+"'"+
            " and COD_LOTE_PRODUCCION='"+codLote+"' and COD_COMPPROD='"+codCompProd+"'"+
            " and COD_FORMULA_MAESTRA='"+codFormula+"' and COD_TIPO_PROGRAMA_PROD='"+codTipoProduccion+"' and"+
            " COD_ACTIVIDAD_PROGRAMA='"+codActividadPrograma+"'" +
            (admin?"":" and COD_PERSONAL='"+codPersonalRegistro+"'");
    System.out.println("consulta delete seguimiento personal "+consulta);
    pst=con.prepareStatement(consulta);
    if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
    String fechaInicio="";
    String fechaFinal="";
    for(int i=0;(i<dataSeguimientoPersonal.length&&dataSeguimientoPersonal.length>1);i+=6)
    {
        String[] aux=dataSeguimientoPersonal[i+1].split("/");
        fechaInicio=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataSeguimientoPersonal[i+2];
        fechaFinal=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataSeguimientoPersonal[i+3];

            consulta = " INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL( COD_COMPPROD,  COD_PROGRAMA_PROD,  COD_LOTE_PRODUCCION,  COD_FORMULA_MAESTRA," +
                        "  COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE,  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,  FECHA_INICIO," +
                        "  FECHA_FINAL,HORAS_EXTRA,UNIDADES_PRODUCIDAS_EXTRA,REGISTRO_CERRADO) VALUES ( '"+codCompProd+"'," +
                        "'"+codProgramaProd+"','"+codLote+"'," +
                        "'"+codFormula+"','"+codActividadPrograma+"'," +
                        " '"+codTipoProduccion+"'," +
                        " '"+dataSeguimientoPersonal[i]+"','"+dataSeguimientoPersonal[i+4]+"','0'" +
                        ",'"+fechaInicio+":00','"+fechaInicio+":00','"+fechaFinal+":00'" +
                        ",'0','0','"+dataSeguimientoPersonal[i+5]+"')";
            System.out.println("consulta insert seguimiento programa produccion personal "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento Personal");
    }
    consulta="INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION( COD_COMPPROD,  COD_PROGRAMA_PROD,COD_LOTE_PRODUCCION,COD_FORMULA_MAESTRA,"+
                      " COD_ACTIVIDAD_PROGRAMA,FECHA_INICIO,FECHA_FINAL,COD_MAQUINA,HORAS_MAQUINA,HORAS_HOMBRE,COD_TIPO_PROGRAMA_PROD)"+
                      " select spp.COD_COMPPROD,spp.COD_PROGRAMA_PROD,spp.COD_LOTE_PRODUCCION,spp.COD_FORMULA_MAESTRA,"+
                      " spp.COD_ACTIVIDAD_PROGRAMA,MIN(spp.FECHA_INICIO),MAX(spp.FECHA_FINAL),0,0,sum(spp.HORAS_HOMBRE),spp.COD_TIPO_PROGRAMA_PROD"+
                      " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL spp where spp.COD_PROGRAMA_PROD='"+codProgramaProd+"'"+
                      " and spp.COD_FORMULA_MAESTRA='"+codFormula+"' and spp.COD_COMPPROD='"+codCompProd+"'"+
                      " and spp.COD_TIPO_PROGRAMA_PROD='"+codTipoProduccion+"' and spp.COD_LOTE_PRODUCCION='"+codLote+"'"+
                      " and spp.COD_ACTIVIDAD_PROGRAMA in ('"+codActividadPrograma+"')"+
                      " group by spp.COD_PROGRAMA_PROD,spp.COD_FORMULA_MAESTRA,spp.COD_COMPPROD,spp.COD_TIPO_PROGRAMA_PROD,spp.COD_LOTE_PRODUCCION,spp.COD_ACTIVIDAD_PROGRAMA";
    System.out.println("consulta insert seguimiento programa produccion "+consulta);
    pst=con.prepareStatement(consulta);
    if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento");
    if(admin)
    {
        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        consulta="select top 1 * from SEGUIMIENTO_PREPARADO_LOTE S WHERE S.COD_LOTE='"+codLote+"' AND s.COD_PROGRAMA_PROD='"+codProgramaProd+"'";
        System.out.println("consulta verificar registro anteior");
        ResultSet res=st.executeQuery(consulta);
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm");
        if(res.next())
        {
            consulta="update SEGUIMIENTO_PREPARADO_LOTE set FECHA_CIERRE=?"+
                    ",COD_PERSONAL_SUPERVISOR=?"+
                    ",OBSERVACION=?"+
                    ",COD_ESTADO_HOJA=?"+
                    " WHERE COD_LOTE=? and COD_PROGRAMA_PROD=?";
            pst=con.prepareStatement(consulta);
            pst.setString(1,sdf.format(new Date()));
            pst.setString(2,codPersonalRegistro);
            pst.setString(3,observacion);
            pst.setInt(4, 0);
            pst.setString(5,codLote);
            pst.setString(6,codProgramaProd);
            if(pst.executeUpdate()>0)System.out.println("se actualizo la cabecera "+observacion);
        }
        else{
            consulta="INSERT INTO SEGUIMIENTO_PREPARADO_LOTE(COD_LOTE, COD_PROGRAMA_PROD,"+
                     " COD_PERSONAL_SUPERVISOR, COD_ESTADO_HOJA, FECHA_CIERRE, OBSERVACION)"+
                     " VALUES ('"+codLote+"','"+codProgramaProd+"','"+codPersonalRegistro+"',"+
                     " 0, '"+sdf.format(new Date())+"','"+observacion+"')";
            System.out.println("consulta cerrar hoja "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se cerro la hoja");
            }

    }
con.commit();
mensaje="1";
con.close();
}
catch(SQLException ex)
{
    ex.printStackTrace();
    mensaje="Ocurrio un error en el registro,intente de nuevo";
    con.rollback();
    con.close();
}

catch(Exception ex)
{
    
    mensaje="Ocurrio un error en el registro,intente de nuevo";
    con.rollback();
    con.close();
}
out.clear();
out.println(mensaje);
%>


