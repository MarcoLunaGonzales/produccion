<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Enumeration" %>
<%@page import="java.util.Map" %>
<%@page import="java.util.Date" %>
<%@page import="java.net.URLDecoder" %>
<%
String codTipoProgramaProd=request.getParameter("codTipoProgramaProd");
String codCompProd=request.getParameter("codCompProd");
String codLote=request.getParameter("codLote");
String codFormula=request.getParameter("codFormula");
String codProgProd=request.getParameter("codProgProd");
String[] dataRepesada=request.getParameter("dataRepesada").split(",");
String codResponsable=request.getParameter("codPersonal");
String fechaSeguimiento=request.getParameter("fechaSeguimiento");
String horaInicio=request.getParameter("horaInicio");
String horaFinal=request.getParameter("horaFinal");
String horasHombreRepesada=request.getParameter("horasHombreRepesada");
String observaciones=request.getParameter("observacion");
String codActividadVerificacionPeso=request.getParameter("codActividadVerificacionPeso");
int codSeguimiento=Integer.valueOf(request.getParameter("codSeguimiento"));
String codPersonalUsuario=request.getParameter("codPersonalUsuario");
boolean administrador=(Integer.valueOf(request.getParameter("admin"))>0);
Connection con=null;
String mensaje="";
try
{
     con=Util.openConnection(con);
     
     PreparedStatement pst=null;
     con.setAutoCommit(false);
     String consulta="";
     String[] fecha=fechaSeguimiento.split("/");
     SimpleDateFormat sdf= new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
     consulta="select max(s.COD_SEGUIMIENTO_REPESADA_LOTE) as COD_SEGUIMIENTO_REPESADA_LOTE from SEGUIMIENTO_REPESADA_LOTE s " +
             " where s.cod_lote='"+codLote+"' and s.COD_PROGRAMA_PROD='"+codProgProd+"'";
     Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
     ResultSet res=st.executeQuery(consulta);
     if(res.next())codSeguimiento=res.getInt("COD_SEGUIMIENTO_REPESADA_LOTE");
     if(codSeguimiento==0)
     {
         consulta="select isnull(max(s.COD_SEGUIMIENTO_REPESADA_LOTE),0)+1 as codSeg from  SEGUIMIENTO_REPESADA_LOTE s";
          res=st.executeQuery(consulta);
          if(res.next())codSeguimiento=res.getInt("codSeg");
        consulta="INSERT INTO SEGUIMIENTO_REPESADA_LOTE(COD_LOTE, COD_PROGRAMA_PROD,"+
                (administrador?" COD_PERSONAL_SUPERVISOR, FECHA_CIERRE, OBSERVACION,COD_ESTADO_HOJA,":"")+
                " COD_SEGUIMIENTO_REPESADA_LOTE)"+
                " VALUES ('"+codLote+"','"+codProgProd+"'," +
                (administrador?("'"+codPersonalUsuario+"','"+sdf.format(new Date()))+"',?,0,":"")+
                "'"+codSeguimiento+"')";
        System.out.println("consulta insert "+consulta);
        pst=con.prepareStatement(consulta);
        if(administrador)pst.setString(1,URLDecoder.decode(observaciones, "UTF-8"));
        
        if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento");

     }
     else
     {
         if(administrador)
         {
             consulta="UPDATE SEGUIMIENTO_REPESADA_LOTE SET COD_PERSONAL_SUPERVISOR =?,"+
                      " FECHA_CIERRE = '"+sdf.format(new Date())+"',OBSERVACION = ?,COD_ESTADO_HOJA = 0"+
                      " WHERE COD_SEGUIMIENTO_REPESADA_LOTE =?";
             System.out.println("consulta update "+consulta+codPersonalUsuario+observaciones+codSeguimiento);
             pst=con.prepareStatement(consulta);
             pst.setString(1,codPersonalUsuario);
             pst.setString(2,URLDecoder.decode(observaciones, "UTF-8"));
             pst.setInt(3,codSeguimiento);
             if(pst.executeUpdate()>0)System.out.println("se actualizo el seguimiento");
         }
        
         
     }
      consulta="delete SEGUIMIENTO_REPESADA_LOTE_DETALLE  where COD_SEGUIMIENTO_REPESADA_LOTE='"+codSeguimiento+"'";
         System.out.println("consulta delete "+consulta);
         pst=con.prepareStatement(consulta);
         if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
     System.out.println(dataRepesada.length);
     for(int i=0;i<dataRepesada.length;i+=3)
     {
         consulta="INSERT INTO SEGUIMIENTO_REPESADA_LOTE_DETALLE(COD_SEGUIMIENTO_REPESADA_LOTE,"+
                " COD_FORMULA_MAESTRA, COD_MATERIAL, COD_FORMULA_MAESTRA_FRACCIONES,"+
                " PESADA_CORRECTAMENTE)"+
                " VALUES ('"+codSeguimiento+"','"+codFormula+"','"+dataRepesada[i+1]+"',"+
                " '"+dataRepesada[i]+"','"+dataRepesada[i+2]+"')";
        System.out.println("consulta insert seguimiento "+consulta);
        pst=con.prepareStatement(consulta);
        if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento");
     }
     consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION where COD_PROGRAMA_PROD='"+codProgProd+"'"+
                    " and COD_LOTE_PRODUCCION='"+codLote+"' and COD_COMPPROD='"+codCompProd+"'"+
                    " and COD_FORMULA_MAESTRA='"+codFormula+"' and COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"' and"+
                    " COD_ACTIVIDAD_PROGRAMA ='"+codActividadVerificacionPeso+"'";
    System.out.println("consulta delete seguimiento anterior "+consulta);
    pst=con.prepareStatement(consulta);
    if(pst.executeUpdate()>0)System.out.println("se eliminaron registros anteriores de seguimiento programa produccion");
    consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL where COD_PROGRAMA_PROD='"+codProgProd+"'"+
            " and COD_LOTE_PRODUCCION='"+codLote+"' and COD_COMPPROD='"+codCompProd+"'"+
            " and COD_FORMULA_MAESTRA='"+codFormula+"' and COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"' and"+
            " COD_ACTIVIDAD_PROGRAMA ='"+codActividadVerificacionPeso+"'";
    System.out.println("consulta delete seguimiento personal "+consulta);
    pst=con.prepareStatement(consulta);
    String fechaInicio=fecha[2]+"/"+fecha[1]+"/"+fecha[0];
    if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
    consulta = " INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL( COD_COMPPROD,  COD_PROGRAMA_PROD,  COD_LOTE_PRODUCCION,  COD_FORMULA_MAESTRA," +
                        "  COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE,  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,  FECHA_INICIO," +
                        "  FECHA_FINAL,HORAS_EXTRA,UNIDADES_PRODUCIDAS_EXTRA,COD_REGISTRO_ORDEN_MANUFACTURA) VALUES ( '"+codCompProd+"'," +
                        "'"+codProgProd+"','"+codLote+"'," +
                        "'"+codFormula+"','"+codActividadVerificacionPeso+"'," +
                        " '"+codTipoProgramaProd+"'," +
                        " '"+codResponsable+"','"+horasHombreRepesada+"','0'" +
                        ",'"+fechaInicio+" "+horaInicio+":00','"+fechaInicio+" "+horaInicio+":00','"+fechaInicio+" "+horaFinal+":00'" +
                        ",'0','0','1')";
            System.out.println("consulta insert seguimiento programa produccion personal "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento Personal");
     
     consulta=" INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION( COD_COMPPROD,  COD_PROGRAMA_PROD, " +
            "  COD_LOTE_PRODUCCION, COD_FORMULA_MAESTRA,   COD_ACTIVIDAD_PROGRAMA,   FECHA_INICIO,   FECHA_FINAL,  " +
            "  COD_MAQUINA,  HORAS_MAQUINA,  HORAS_HOMBRE," +
            "  COD_TIPO_PROGRAMA_PROD) " +
            "  VALUES ( '"+codCompProd+"' ,'"+codProgProd+"','"+codLote+"',  " +
            " '"+codFormula+"' ,'"+codActividadVerificacionPeso+"' , " +
            "  '"+fechaInicio+" "+horaInicio+":00', " +
            "  '"+fechaInicio+" "+horaFinal+":00',  " +
            "  '0', '0'," +
            "  '"+horasHombreRepesada+"', '"+codTipoProgramaProd+"')";
    System.out.println("consulta insert seguimiento programa produccion "+consulta);
    pst=con.prepareStatement(consulta);
    if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento");


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
