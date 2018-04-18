
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
String codProgProd=request.getParameter("codProgProd");
String codFormulaMaestra=request.getParameter("codFormulaMaestra");
String codTipoProgramaProd=request.getParameter("codTipoProgramaProd");
String codCompProd=request.getParameter("codCompProd");
String observaciones=(request.getParameter("observacion")==null?"":request.getParameter("observacion"));
String codActividadDocumentacion=request.getParameter("codActividadDocumentacion");
String codActividadTransporte=request.getParameter("codActividadTransporte");
int codSeguimiento=Integer.valueOf(request.getParameter("codSeguimiento"));
String[] dataDocumentacion=request.getParameter("dataDocumentacion").split(",");
String[] dataTransporte=request.getParameter("dataTransporte").split(",");
String fechaInicioDoc=request.getParameter("fechaInicioDoc");
String fechaFinalDoc=request.getParameter("fechaFinalDoc");
String sumaHorasDocumentacion=request.getParameter("sumaHorasDocumentacion");
String fechaInicioTransporte=request.getParameter("fechaInicioTransporte");
String fechaFinalTransporte=request.getParameter("fechaFinalTransporte");
String horasHombreTransporte=request.getParameter("horasHombreTransporte");
String codPersonalSupervisor=request.getParameter("codPersonalSupervisor");
System.out.println("cod "+codActividadDocumentacion+ "  ccp "+codCompProd);
Connection con=null;
String mensaje="";
boolean admin=(Integer.valueOf(request.getParameter("admin"))>0);
String codPersonalUsuario=request.getParameter("codPersonalUsuario");
SimpleDateFormat sdf= new SimpleDateFormat("yyyy/MM/dd HH:mm");
try
{
     con=Util.openConnection(con);
     Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
     
     PreparedStatement pst=null;
     con.setAutoCommit(false);
     String consulta="select s.COD_SEGUIMIENTO_RENDIMIENTO_LOTE from SEGUIMIENTO_RENDIMIENTO_DOSIFICADO_LOTE s where s.COD_LOTE='"+codLote+"'"+
                     " and s.COD_PROGRAMA_PROD='"+codProgProd+"'";
     System.out.println("consulta verificar codSeguimiento "+consulta);
     ResultSet res=st.executeQuery(consulta);
     if(res.next())
     {
         codSeguimiento=res.getInt("COD_SEGUIMIENTO_RENDIMIENTO_LOTE");
     }
     if(codSeguimiento==0)
     {
         consulta="select isnull(max(s.COD_SEGUIMIENTO_RENDIMIENTO_LOTE),0)+1 as codSeguimiento from SEGUIMIENTO_RENDIMIENTO_DOSIFICADO_LOTE s";
         res=st.executeQuery(consulta);
         if(res.next())
         {
             codSeguimiento=res.getInt("codSeguimiento");
         }
         consulta="INSERT INTO SEGUIMIENTO_RENDIMIENTO_DOSIFICADO_LOTE(COD_SEGUIMIENTO_RENDIMIENTO_LOTE, COD_LOTE, COD_PROGRAMA_PROD" +
                 (admin?",OBSERVACION,COD_PERSONAL_SUPERVISOR":"")+")"+
                 " VALUES ('"+codSeguimiento+"','"+codLote+"','"+codProgProd+"'" +
                 (admin?",'"+observaciones+"','"+codPersonalSupervisor+"'":"")+")";
         System.out.println("consulta guardar "+consulta);
         pst=con.prepareStatement(consulta);
         if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento del rendimiento");
     }
     else
     {
         if(admin)
         {
             consulta="UPDATE SEGUIMIENTO_RENDIMIENTO_DOSIFICADO_LOTE SET OBSERVACION='"+observaciones+"'," +
                      "COD_PERSONAL_SUPERVISOR='"+codPersonalUsuario+"'" +
                      ",cod_estado_hoja=0,FECHA_CIERRE='"+sdf.format(new Date())+"'"+
                      " where COD_SEGUIMIENTO_RENDIMIENTO_LOTE='"+codSeguimiento+"'";
             System.out.println("consulta update rendimiento "+consulta);
             pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento");
         }
     }
      consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION where COD_PROGRAMA_PROD='"+codProgProd+"'"+
                    " and COD_LOTE_PRODUCCION='"+codLote+"' and COD_COMPPROD='"+codCompProd+"'"+
                    " and COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"' and"+
                    " COD_ACTIVIDAD_PROGRAMA  in ("+codActividadDocumentacion+","+codActividadTransporte+")";
    System.out.println("consulta delete seguimiento anterior "+consulta);
    pst=con.prepareStatement(consulta);
    if(pst.executeUpdate()>0)System.out.println("se eliminaron registros anteriores de seguimiento programa produccion");
    consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL where COD_PROGRAMA_PROD='"+codProgProd+"'"+
            " and COD_LOTE_PRODUCCION='"+codLote+"' and COD_COMPPROD='"+codCompProd+"'"+
            " and COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"' and"+
            " COD_ACTIVIDAD_PROGRAMA in ("+codActividadDocumentacion+","+codActividadTransporte+")" +
            (admin?"":" and COD_PERSONAL='"+codPersonalUsuario+"'");
    System.out.println("consulta delete seguimiento personal "+consulta);
    pst=con.prepareStatement(consulta);
    if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
     String fechaInicio="";
     String fechaFinal="";
     for(int i=0;(i<dataDocumentacion.length&&dataDocumentacion.length>1);i+=5)
     {
         String[] aux=dataDocumentacion[i+1].split("/");
        fechaInicio=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataDocumentacion[i+2];
        fechaFinal=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataDocumentacion[i+3];

        consulta = " INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL( COD_COMPPROD,  COD_PROGRAMA_PROD,  COD_LOTE_PRODUCCION,  COD_FORMULA_MAESTRA," +
                    "  COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE,  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,  FECHA_INICIO," +
                    "  FECHA_FINAL,HORAS_EXTRA,UNIDADES_PRODUCIDAS_EXTRA,COD_REGISTRO_ORDEN_MANUFACTURA) VALUES ( '"+codCompProd+"'," +
                    "'"+codProgProd+"','"+codLote+"'," +
                    "'"+codFormulaMaestra+"','"+codActividadDocumentacion+"'," +
                    " '"+codTipoProgramaProd+"'," +
                    " '"+dataDocumentacion[i]+"','"+dataDocumentacion[i+4]+"','0'" +
                    ",'"+fechaInicio+":00','"+fechaInicio+":00','"+fechaFinal+":00'" +
                    ",'0','0','0')";
        System.out.println("consulta insert seguimiento programa produccion personal "+consulta);
        pst=con.prepareStatement(consulta);
        if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento Personal");
     }
     consulta=" INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION( COD_COMPPROD,  COD_PROGRAMA_PROD, " +
            "  COD_LOTE_PRODUCCION, COD_FORMULA_MAESTRA,   COD_ACTIVIDAD_PROGRAMA,   FECHA_INICIO,   FECHA_FINAL,  " +
            "  COD_MAQUINA,  HORAS_MAQUINA,  HORAS_HOMBRE," +
            "  COD_TIPO_PROGRAMA_PROD) " +
            "  VALUES ( '"+codCompProd+"' ,'"+codProgProd+"','"+codLote+"',  " +
            " '"+codFormulaMaestra+"' ,'"+codActividadDocumentacion+"' , " +
            "  '"+fechaInicioDoc+":00', " +
            "  '"+fechaFinalDoc+":00',  " +
            "  '0', '0'," +
            "  '"+sumaHorasDocumentacion+"', '"+codTipoProgramaProd+"')";
    System.out.println("consulta insert seguimiento programa produccion "+consulta);
    pst=con.prepareStatement(consulta);
    if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento de documentacion");

      for(int i=0;(i<dataTransporte.length&&dataTransporte.length>1);i+=5)
     {
         String[] aux=dataTransporte[i+1].split("/");
        fechaInicio=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataTransporte[i+2];
        fechaFinal=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataTransporte[i+3];

        consulta = " INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL( COD_COMPPROD,  COD_PROGRAMA_PROD,  COD_LOTE_PRODUCCION,  COD_FORMULA_MAESTRA," +
                    "  COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE,  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,  FECHA_INICIO," +
                    "  FECHA_FINAL,HORAS_EXTRA,UNIDADES_PRODUCIDAS_EXTRA,COD_REGISTRO_ORDEN_MANUFACTURA) VALUES ( '"+codCompProd+"'," +
                    "'"+codProgProd+"','"+codLote+"'," +
                    "'"+codFormulaMaestra+"','"+codActividadTransporte+"'," +
                    " '"+codTipoProgramaProd+"'," +
                    " '"+dataTransporte[i]+"','"+dataTransporte[i+4]+"','0'" +
                    ",'"+fechaInicio+":00','"+fechaInicio+":00','"+fechaFinal+":00'" +
                    ",'0','0','0')";
        System.out.println("consulta insert seguimiento programa produccion personal "+consulta);
        pst=con.prepareStatement(consulta);
        if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento Personal");
     }

    consulta=" INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION( COD_COMPPROD,  COD_PROGRAMA_PROD, " +
            "  COD_LOTE_PRODUCCION, COD_FORMULA_MAESTRA,   COD_ACTIVIDAD_PROGRAMA,   FECHA_INICIO,   FECHA_FINAL,  " +
            "  COD_MAQUINA,  HORAS_MAQUINA,  HORAS_HOMBRE," +
            "  COD_TIPO_PROGRAMA_PROD) " +
            "  VALUES ( '"+codCompProd+"' ,'"+codProgProd+"','"+codLote+"',  " +
            " '"+codFormulaMaestra+"' ,'"+codActividadTransporte+"' , " +
            "  '"+fechaInicioTransporte+":00', " +
            "  '"+fechaFinalTransporte+":00',  " +
            "  '0', '0'," +
            "  '"+horasHombreTransporte+"', '"+codTipoProgramaProd+"')";
    System.out.println("consulta insert seguimiento programa produccion "+consulta);
    pst=con.prepareStatement(consulta);
    if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento de documentacion");


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
