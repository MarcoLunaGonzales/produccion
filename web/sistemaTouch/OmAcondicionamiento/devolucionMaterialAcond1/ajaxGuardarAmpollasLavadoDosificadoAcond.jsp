package sistemaTouch.OmAcondicionamiento.lavadoAmpollasDosificadas_1;

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
String codLote=request.getParameter("codLote")==null?"":request.getParameter("codLote");
String codprogramaProd=request.getParameter("codprogramaProd");
String codFormulaMaestra=request.getParameter("codFormulaMaestra");
String codTipoProgramaProd=request.getParameter("codTipoProgramaProd");
String codCompProd=request.getParameter("codCompProd");
String codActividadLavadoAmpollas=request.getParameter("codActividadLavadoAmpollas");
String observacion=request.getParameter("observacion");
boolean administrador=(Integer.valueOf(request.getParameter("admin"))>0);
String codPersonalUsuario=request.getParameter("codPersonalUsuario");
String[] dataAmpollasLavadas=request.getParameter("dataAmpollasAcond").split(",");
String fechaInicioActividad=request.getParameter("fechaInicio");
String fechaFinalActividad=request.getParameter("fechaFinal");
String horasHombreActividad=request.getParameter("horasHombre");
con=Util.openConnection(con);
con.setAutoCommit(false);
String consulta="select MAX(s.COD_SEGUIMIENTO_LAVADO_LOTE_ACOND) as codSeguimiento"+
             " from SEGUIMIENTO_LAVADO_LOTE_ACOND s where s.COD_LOTE='"+codLote+"' and s.COD_PROGRAMA_PROD='"+codprogramaProd+"'";
System.out.println("consulta buscar codSeguimiento "+consulta);
 PreparedStatement pst=null;
 Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
 ResultSet res=st.executeQuery(consulta);
 if(res.next())
 {
         codSeguimiento=res.getInt("codSeguimiento");
  }
 SimpleDateFormat sdf =new SimpleDateFormat("yyyy/MM/dd HH:mm");
 if(codSeguimiento==0)
 {
    consulta="select isnull(max(s.COD_SEGUIMIENTO_LAVADO_LOTE_ACOND),0)+1 as codSeguimiento from SEGUIMIENTO_LAVADO_LOTE_ACOND s ";
    System.out.println("consulta codSeguimiento "+consulta);
    res=st.executeQuery(consulta);
    if(res.next())codSeguimiento=res.getInt("codSeguimiento");
    consulta="INSERT INTO SEGUIMIENTO_LAVADO_LOTE_ACOND(COD_LOTE,COD_PROGRAMA_PROD,COD_SEGUIMIENTO_LAVADO_LOTE_ACOND," +
            " COD_ESTADO_HOJA" +
            (administrador?",OBSERVACIONES,COD_PERSONAL_SUPERVISOR, FECHA_CIERRE":"")+")"+
           " VALUES ('"+codLote+"','"+codprogramaProd+"','"+codSeguimiento+"',0"+
           (administrador?",'"+observacion+"','"+codPersonalUsuario+"','"+sdf.format(new Date())+"'":"")+")";
        System.out.println("consulta insert "+consulta);
        pst=con.prepareStatement(consulta);
        if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento");
     }
     else
     {
         if(administrador)
         {
             consulta="UPDATE SEGUIMIENTO_LAVADO_LOTE_ACOND"+
                      " SET OBSERVACIONES = '"+observacion+"',"+
                      " COD_PERSONAL_SUPERVISOR = '"+codPersonalUsuario+"',FECHA_CIERRE = '"+sdf.format(new Date())+"',"+
                      " COD_ESTADO_HOJA = 0"+
                      " WHERE COD_SEGUIMIENTO_LAVADO_LOTE_ACOND ='"+codSeguimiento+"'";
             System.out.println("consulta update seguimiento "+consulta);
             pst=con.prepareStatement(consulta);
             if(pst.executeUpdate()>0)System.out.println("se modifico la cabecera de lavado");
         }
         
     }
     consulta="delete SEGUIMIENTO_AMPOLLAS_LAVADO_LOTE_ACOND where COD_SEGUIMIENTO_LAVADO_LOTE_ACOND='"+codSeguimiento+"'"+
              (administrador?"":" and COD_PERSONAL='"+codPersonalUsuario+"'");
     System.out.println("consulta delete anteriores ampollas "+consulta);
     pst=con.prepareStatement(consulta);
     if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros "+consulta);

     consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION where COD_PROGRAMA_PROD='"+codprogramaProd+"'"+
                    " and COD_LOTE_PRODUCCION='"+codLote+"' and COD_COMPPROD='"+codCompProd+"'"+
                    " and COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"' and"+
                    " COD_ACTIVIDAD_PROGRAMA ='"+codActividadLavadoAmpollas+"'";
    System.out.println("consulta delete seguimiento anterior "+consulta);
    pst=con.prepareStatement(consulta);
    if(pst.executeUpdate()>0)System.out.println("se eliminaron registros anteriores de seguimiento programa produccion");
    consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL where COD_PROGRAMA_PROD='"+codprogramaProd+"'"+
            " and COD_LOTE_PRODUCCION='"+codLote+"' and COD_COMPPROD='"+codCompProd+"'"+
            " and COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"' and"+
            " COD_ACTIVIDAD_PROGRAMA ='"+codActividadLavadoAmpollas+"'"+
            (administrador?"":" and COD_PERSONAL='"+codPersonalUsuario+"'");
    System.out.println("consulta delete seguimiento personal "+consulta);
    pst=con.prepareStatement(consulta);
    if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros");
   
     String fechaInicio="";
     String fechaFinal="";
     
     for(int i=0;(i<dataAmpollasLavadas.length&&dataAmpollasLavadas.length>1);i+=7)
     {
         consulta="INSERT INTO SEGUIMIENTO_AMPOLLAS_LAVADO_LOTE_ACOND("+
                 " COD_SEGUIMIENTO_LAVADO_LOTE_ACOND, COD_REGISTRO_ORDEN_MANUFACTURA,"+
                 " CANTIDAD_AMPOLLAS_LAVADAS, CANTIDAD_AMPOLLAS_ROTAS, COD_PERSONAL)"+
                 " VALUES ('"+codSeguimiento+"','"+i+"',"+
                 "'"+dataAmpollasLavadas[i+1]+"','"+dataAmpollasLavadas[i+2]+"','"+dataAmpollasLavadas[i]+"')";
        System.out.println("consulta insert seguimiento ampollas lavado "+consulta);
        pst=con.prepareStatement(consulta);
        if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento de ampollas");
        String[] aux=dataAmpollasLavadas[i+3].split("/");
        fechaInicio=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataAmpollasLavadas[i+4];
        fechaFinal=aux[2]+"/"+aux[1]+"/"+aux[0]+" "+dataAmpollasLavadas[i+5];

            consulta = " INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL( COD_COMPPROD,  COD_PROGRAMA_PROD,  COD_LOTE_PRODUCCION,  COD_FORMULA_MAESTRA," +
                        "  COD_ACTIVIDAD_PROGRAMA,  COD_TIPO_PROGRAMA_PROD,  COD_PERSONAL,  HORAS_HOMBRE,  UNIDADES_PRODUCIDAS,  FECHA_REGISTRO,  FECHA_INICIO," +
                        "  FECHA_FINAL,HORAS_EXTRA,UNIDADES_PRODUCIDAS_EXTRA,COD_REGISTRO_ORDEN_MANUFACTURA) VALUES ( '"+codCompProd+"'," +
                        "'"+codprogramaProd+"','"+codLote+"'," +
                        "'"+codFormulaMaestra+"','"+codActividadLavadoAmpollas+"'," +
                        " '"+codTipoProgramaProd+"'," +
                        " '"+dataAmpollasLavadas[i]+"','"+dataAmpollasLavadas[i+6]+"','"+dataAmpollasLavadas[i+1]+"'" +
                        ",'"+fechaInicio+":00','"+fechaInicio+":00','"+fechaFinal+":00'" +
                        ",'0','0','"+i+"')";
            System.out.println("consulta insert seguimiento programa produccion personal "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento Personal");
     }
     consulta=" INSERT INTO SEGUIMIENTO_PROGRAMA_PRODUCCION( COD_COMPPROD,  COD_PROGRAMA_PROD, " +
            "  COD_LOTE_PRODUCCION, COD_FORMULA_MAESTRA,   COD_ACTIVIDAD_PROGRAMA,   FECHA_INICIO,   FECHA_FINAL,  " +
            "  COD_MAQUINA,  HORAS_MAQUINA,  HORAS_HOMBRE," +
            "  COD_TIPO_PROGRAMA_PROD) " +
            "  VALUES ( '"+codCompProd+"' ,'"+codprogramaProd+"','"+codLote+"',  " +
            " '"+codFormulaMaestra+"' ,'"+codActividadLavadoAmpollas+"' , " +
            "  '"+fechaInicioActividad+":00', " +
            "  '"+fechaFinalActividad+":00',  " +
            "  '0', '0'," +
            "  '"+horasHombreActividad+"', '"+codTipoProgramaProd+"')";
    System.out.println("consulta insert seguimiento programa produccion "+consulta);
    pst=con.prepareStatement(consulta);
    if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento");
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
