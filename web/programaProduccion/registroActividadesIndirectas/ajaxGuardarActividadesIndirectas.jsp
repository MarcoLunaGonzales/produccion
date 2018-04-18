<%@page import="org.apache.logging.log4j.LogManager"%>
<%@page import="org.apache.logging.log4j.Logger"%>
<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Enumeration" %>
<%@page import="java.util.Map" %>
<%
    Logger LOGGER = LogManager.getLogger("RegistroTiempos");
    String codProgramaProd=request.getParameter("codProgramaProd");
    String codActividad=request.getParameter("codActividad");
    String codAreaEmpresa=request.getParameter("codAreaEmpresa");
    String[] dataSeguimiento=request.getParameter("dataSeguimiento").split(",");
    String fechaLimite=request.getParameter("fechaLimite");
    
    Connection con=null;
    String mensaje="";
    try
    {
        con=Util.openConnection(con);
        con.setAutoCommit(false);
        String consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO"+
                        " where COD_PROGRAMA_PROD='"+codProgramaProd+"'" +
                        " and COD_ACTIVIDAD='"+codActividad+"'" +
                        " and COD_AREA_EMPRESA='"+codAreaEmpresa+"'";
        LOGGER.debug("consulta delete seguimiento indirecto "+consulta);
        PreparedStatement pst=con.prepareStatement(consulta);
        if(pst.executeUpdate()>0)LOGGER.info("se elimino el detalle "+consulta);
        String[] arrayFecha=fechaLimite.split("/");
        fechaLimite=arrayFecha[2]+"/"+arrayFecha[1]+"/"+arrayFecha[0];
        consulta="delete SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO_PERSONAL"+
                " where COD_PROGRAMA_PROD='"+codProgramaProd+"'" +
                " and COD_ACTVIDAD='"+codActividad+"'" +
                " and COD_AREA_EMPRESA='"+codAreaEmpresa+"'" +
                " and FECHA_INICIO>'"+fechaLimite+" 00:00'";
        LOGGER.debug("consulta delete seguimiento indirecto personal "+consulta);
        pst=con.prepareStatement(consulta);
        if(pst.executeUpdate()>0)LOGGER.info("se elimino seguimiento personal indirecto");
        for(int i=0;i<dataSeguimiento.length;i+=5)
        {
            arrayFecha=dataSeguimiento[i+1].split("/");
            String fecha=arrayFecha[2]+"/"+arrayFecha[1]+"/"+arrayFecha[0];
            String fechaInicio = "'"+fecha+" "+dataSeguimiento[i+2]+"'";
            String fechaFinal = "'"+fecha+" "+dataSeguimiento[i+3]+"'";
            consulta="INSERT INTO dbo.SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO_PERSONAL("+
                    " COD_PROGRAMA_PROD, COD_ACTVIDAD, COD_AREA_EMPRESA, COD_PERSONAL, FECHA_INICIO,FECHA_FINAL, HORAS_HOMBRE,REGISTRO_CERRADO)"+
                    " VALUES ('"+codProgramaProd+"','"+codActividad+"','"+codAreaEmpresa+"','"+dataSeguimiento[i]+"',"+
                    fechaInicio+", "+fechaFinal+",round(DATEDIFF(MINUTE,"+fechaInicio+", "+fechaFinal+")/60.0,2),'"+dataSeguimiento[i+4]+"')";
            LOGGER.debug("consulta insert indirecto "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)LOGGER.info("se registro el seguimiento personal");
        }
        consulta="EXEC PAA_REGISTRO_SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO "
                +codActividad+","
                +codAreaEmpresa+","
                +codProgramaProd;
        LOGGER.debug("consulta registrar cabecera "+consulta);
        pst=con.prepareStatement(consulta);
        if(pst.executeUpdate()>0)LOGGER.info("se registro la cabecera");

        con.commit();
        mensaje="1";
        pst.close();
   }
   catch(SQLException ex){
       mensaje="Ocurrio un error a la hora del registro intente de nuevo";
       LOGGER.warn(ex);
       con.rollback();

   }
    finally{
        con.close();
    }
   out.clear();

    out.println(mensaje);


%>
