<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.Connection"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.sql.Statement"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.text.SimpleDateFormat"%>
<%@ page import = "java.util.ArrayList"%>
<%@ page import = "java.util.Date"%>
<%@ page import = "javax.servlet.http.HttpServletRequest"%>
<%@ page import = "java.text.DecimalFormat"%>
<%@ page import = "java.text.NumberFormat"%>
<%@ page import = "java.util.Locale"%>
<%@ page language="java" import="java.util.*,com.cofar.util.CofarConnection" %>

<%!

public double enviadosAcond(String codLote,String codCompProd){
    double enviadosAcond=0;
    try{
        String consulta = " select sum(i.CANT_INGRESO_PRODUCCION) enviados_acond from PROGRAMA_PRODUCCION ppr inner join " +
                " PROGRAMA_PRODUCCION_INGRESOS_ACOND ppria on ppr.COD_PROGRAMA_PROD = ppria.COD_PROGRAMA_PROD and ppr.COD_LOTE_PRODUCCION = ppria.COD_LOTE_PRODUCCION" +
                " and ppr.COD_COMPPROD = ppria.COD_COMPPROD and ppr.COD_FORMULA_MAESTRA = ppria.COD_FORMULA_MAESTRA" +
                " and ppr.COD_TIPO_PROGRAMA_PROD = ppria.COD_TIPO_PROGRAMA_PROD " +
                " inner join INGRESOS_ACOND ia on ia.COD_INGRESO_ACOND = ppria.COD_INGRESO_ACOND" +
                " inner join INGRESOS_DETALLEACOND i on ia.COD_INGRESO_ACOND = i.COD_INGRESO_ACOND and ppria.COD_LOTE_PRODUCCION = i.COD_LOTE_PRODUCCION and i.COD_COMPPROD = ppria.COD_COMPPROD" +
                " where ppria.COD_LOTE_PRODUCCION = '"+codLote+"' and ppria.COD_COMPPROD = '"+codCompProd+"' " +
                " and ia.COD_ESTADO_INGRESOACOND <> 2 ";
        System.out.println("consulta "  + consulta);
        Connection con = null;
        con = Util.openConnection(con);
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(consulta);
        if(rs.next()){
            enviadosAcond = rs.getFloat("enviados_acond");
        }
    }catch(Exception e){
        e.printStackTrace();
    }
    return enviadosAcond;
}
public double enviadosAPT(String codLote,String codCompProd){
    double enviadosAPT=0;
    try{
        String consulta = " select SUM(sd.CANT_TOTAL_SALIDADETALLEACOND) as cantidadEnviadaAPT"+
                          " from SALIDAS_ACOND sa inner join SALIDAS_DETALLEACOND sd on"+
                          " sa.COD_SALIDA_ACOND=sd.COD_SALIDA_ACOND"+
                          " where sa.COD_ALMACEN_VENTA in (select av.COD_ALMACEN_VENTA from ALMACENES_VENTAS av where av.COD_AREA_EMPRESA=1)"+
                          " and sd.COD_LOTE_PRODUCCION='"+codLote+"' and sd.COD_COMPPROD='"+codCompProd+"' and "+
                          " sa.COD_ESTADO_SALIDAACOND not in (2)";
        System.out.println("consulta "  + consulta);
        Connection con = null;
        con = Util.openConnection(con);
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery(consulta);
        if(rs.next()){
            enviadosAPT = rs.getDouble("cantidadEnviadaAPT");
        }
    }catch(Exception e){
        e.printStackTrace();
    }
    return enviadosAPT;
}

public String generarCeldaPersonal(String fechaIni,String horaIni,String fechaFin,String horaFin,String nombrePer,
           String horasPer,String cantPer,String produc,String hExtra,String cantExtra)
{
       return
      "<th class='outputTextNormal' style='border : solid #D8D8D8 1px'>"+fechaIni+"<br>"+horaIni+"</br></th>"+
      " <th class='outputTextNormal' style='border : solid #D8D8D8 1px'>"+fechaFin+"<br>"+horaFin+"</br></th>" +
      " <th class='outputTextNormal' style='border : solid #D8D8D8 1px'>"+nombrePer+"</th>" +
      " <th class='outputTextNormal' style='border : solid #D8D8D8 1px' align='right'>"+horasPer+"</th>" +
      " <th class='outputTextNormal' style='border : solid #D8D8D8 1px' align='right'>"+cantPer+"</th>" +
      " <th class='outputTextNormal' style='border : solid #D8D8D8 1px' align='right' ><span>"+produc+"</span></th>" +//id='"+idRend+"'
      " <th class='outputTextNormal' style='border : solid #D8D8D8 1px' align='right'>"+hExtra+"</th>" +
      " <th class='outputTextNormal' style='border : solid #D8D8D8 1px' align='right'>"+cantExtra+"</th>";

}

public String generarCeldaActividad(int cont,String nombreAct,String primFila,String hhAct,String maq,String hmAct,
        String hhStand,String hmStand,String demasCeldas)
{
    return
    "<th class='outputTextNormal' style='border : solid #D8D8D8 1px' rowspan='"+cont+"'>"+nombreAct+"</th>"+primFila+
    "<th class='outputTextNormal' style='border : solid #D8D8D8 1px' rowspan='"+cont+"'>"+hhAct+"</th>"+
    "<th class='outputTextNormal' style='border : solid #D8D8D8 1px' rowspan='"+cont+"'>"+maq+"</th>"+
    "<th class='outputTextNormal' style='border : solid #D8D8D8 1px' rowspan='"+cont+"'>"+hmAct+"</th>"+
    "<th class='outputTextNormal' style='border : solid #D8D8D8 1px' rowspan='"+cont+"'>"+hhStand+"</th>"+
    "<th class='outputTextNormal' style='border : solid #D8D8D8 1px' rowspan='"+cont+"'>"+hmStand+"</th></tr>"+demasCeldas;
}

public String generarCeldaAreaProceso(int cont,String proceso,String actividades,String ultimaAct,
   String codCompProd,String sumaCantidadProceso,String sumaHorasProceso1,String rendimiento1,String hhextra,
   String cantidadExtraProceso,String sopap,String sopam,String soct,String soctm)
{
    
     
      String resultado= "<th class='outputTextNormal' style='border : solid #D8D8D8 1px' rowspan='"+cont+"'>"+proceso+"</th>"+actividades+
         (actividades.equals("")?"":"<tr class='outputTextNormal'>")+ultimaAct+//formato.format(sumaCantidadProceso/sumaHorasProceso),formato.format(sumaHorasExtraProceso),entero.format(sumaCantidadExtraProceso),formato.format(sumahorasProcesoActividadPersonal),formato.format(sumahorasProcesoActividadMaquina),formato.format(sumahorasProcesoActividadStandardHombre),formato.format(sumahorasProcesoActividadStandardMaquina)
        "<tr class='outputTextNormal' bgcolor='#f2f2f2'>"+
        "<th class='outputTextNormal' style='border : solid #D8D8D8 1px' colspan='5' align='right'><b>Subtotal:</b></th>"+
        "<th class='outputTextNormal' style='border : solid #D8D8D8 1px' align='right'><b>"+sumaHorasProceso1+"</b></th>"+
        "<th class='outputTextNormal' style='border : solid #D8D8D8 1px' align='right'><b>"+sumaCantidadProceso+"</b></th>"+
        "<th class='outputTextNormal' style='border : solid #D8D8D8 1px' align='right'><b>"+rendimiento1+"</b></th>"+
        "<th class='outputTextNormal' style='border : solid #D8D8D8 1px' align='right'><b>"+hhextra+"</b></th>"+
        "<th class='outputTextNormal' style='border : solid #D8D8D8 1px' align='right'><b>"+cantidadExtraProceso+"</b></th>"+
        "<th class='outputTextNormal' style='border : solid #D8D8D8 1px' align='right'><b>"+sopap+"</b></th>"+
        "<th class='outputTextNormal' style='border : solid #D8D8D8 1px' >&nbsp;</th>" +
        "<th class='outputTextNormal' style='border : solid #D8D8D8 1px' align='right'><b>"+sopam+"</b></th>"+
        "<th class='outputTextNormal' style='border : solid #D8D8D8 1px' align='right'><b>"+soct+"</b></th>"+
        "<th class='outputTextNormal' style='border : solid #D8D8D8 1px' align='right'><b>"+soctm+"</b></th>"+
        "</tr>";
      
      return resultado;
}
public String generarCeldaLote(String codCompProd,int cont,String datosLote,String datosProceso,String ultProces,
        String sumaHlote,String enviados,String prod,String sumaHexLote,String sumaCanExLote,String sum3,String sum4,String sum5,String sum6)
{
    /*formato.format(sumaLoteHorasPer),entero.format(enviadosAPT),formato.format(enviadosAPT/sumaLoteHorasPer),formato.format(sumaLoteHorasExtraPer),
    entero.format(sumaLoteCanExtraPer),formato.format(sumaLoteHorHomAct),formato.format(sumaLoteHorMaqAct),formato.format(sumaLoteHorHomStand),formato.format(sumaLoteHorMaqStand)*/
     String[] datos=datosLote.split("<br></br>");
     String resultado= "<tr class='outputTextNormal'>" +
        "<th class='outputTextNormal' style='border : solid #D8D8D8 1px' rowspan='"+cont+"'><b>"+datosLote+"</b></th>"+datosProceso+
        "<tr class='outputTextNormal'>"+ultProces+
        "<tr class='outputTextNormal' bgcolor='#FF8C00'>"+
        "<th class='outputTextNormal' style='border : solid #D8D8D8 1px' ><b>"+datos[1].split(": ")[1]+"</b></th>"+
        "<th class='outputTextNormal' style='border : solid #D8D8D8 1px' ><b>"+datos[0]+"</b></th>"+
        "<th class='outputTextNormal' style='border : solid #D8D8D8 1px' ><b>"+datos[2]+"</b></th>"+
        "<th class='outputTextNormal' style='border : solid #D8D8D8 1px' align='right' colspan='3'><b>TOTAL LOTE:</b></th>"+
        "<th class='outputTextNormal' style='border : solid #D8D8D8 1px' align='right'><b>"+sumaHlote+"</b></th>"+
        "<th class='outputTextNormal' style='border : solid #D8D8D8 1px' align='right'><b>"+enviados+"</b></th>"+
        "<th class='outputTextNormal' style='border : solid #D8D8D8 1px' align='right'><b>"+prod+"</b></th>"+
        "<th class='outputTextNormal' style='border : solid #D8D8D8 1px' align='right'><b>"+sumaHexLote+"</b></th>"+
        "<th class='outputTextNormal' style='border : solid #D8D8D8 1px' align='right'><b>"+sumaCanExLote+"</b></th>"+
        "<th class='outputTextNormal' style='border : solid #D8D8D8 1px' align='right'><b>"+sum3+"</b></th>"+
        "<th class='outputTextNormal' style='border : solid #D8D8D8 1px' >&nbsp;</th>" +
        "<th class='outputTextNormal' style='border : solid #D8D8D8 1px' align='right'><b>"+sum4+"</b></th>"+
        "<th class='outputTextNormal' style='border : solid #D8D8D8 1px' align='right'><b>"+sum5+"</b></th>"+
        "<th class='outputTextNormal' style='border : solid #D8D8D8 1px' align='right'><b>"+sum6+"</b></th>"+
        "</tr>";
    
    return resultado;
}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
        <style>
            .outputTextNormal{
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 9px;
                font-weight: normal;
            }
            .max{
                background-color:blue;
            }
        </style>
    </head>

    <body>
        <%
        try{
            Connection con = null;
            DecimalFormat formato=null;
            DecimalFormat entero =null;
            double sumahorasProcesoActividadPersonal=0d;
            double sumahorasProcesoActividadMaquina=0d;
            double sumahorasProcesoActividadStandardHombre=0d;
            double sumahorasProcesoActividadStandardMaquina=0d;
            double sumaHorasProceso=0d;
            double sumaHorasExtraProceso=0d;
            double sumaCantidadProceso=0d;
            double sumaCantidadExtraProceso=0d;
            double sumaLoteHorasPer=0d;
            double sumaLoteHorasExtraPer=0d;
            double sumaLoteCanExtraPer=0d;
            double sumaLoteHorHomAct=0d;
            double sumaLoteHorMaqAct=0d;
            double sumaLoteHorHomStand=0d;
            double sumaLoteHorMaqStand=0d;
            //int idRend=0;
            String arrayMayores="";
            String arrayMenores="";

              NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
                        formato = (DecimalFormat) numeroformato;
                        formato.applyPattern("###0.00;(###0.00)");
                        NumberFormat enteroformat = NumberFormat.getNumberInstance(Locale.ENGLISH);
                        entero = (DecimalFormat) enteroformat;
                        entero.applyPattern("####;(####)");
                        String codProgramaProdPeriodo=request.getParameter("codProgramaProduccionPeriodo")==null?"''":request.getParameter("codProgramaProduccionPeriodo");
                        String arrayCodCompProd =request.getParameter("codCompProdArray")==null?"''":request.getParameter("codCompProdArray");
                        String nombreProgramaProduccionPeriodo = request.getParameter("nombreProgramaProduccionPeriodo")==null?"''":request.getParameter("nombreProgramaProduccionPeriodo");
                        arrayCodCompProd = arrayCodCompProd + (arrayCodCompProd.length()==0?"' '":"");
                        String[] valores=arrayCodCompProd.split(",");
                        System.out.println(arrayCodCompProd);
                        System.out.println("los datos de peticion para el reporte : "+request.getParameter("codAreaEmpresaP"));
                        System.out.println(request.getParameter("nombreAreaEmpresaP"));
                        System.out.println(request.getParameter("desdeFechaP"));
                        System.out.println(request.getParameter("hastaFechaP"));
                        System.out.println("lotes "+arrayCodCompProd);
                        String arrayCodAreaEmpresa= request.getParameter("codAreaEmpresaP");
                        String arrayNombreAreaEmpresa= request.getParameter("nombreAreaEmpresaP");
                        String codAreaEmpresaAct=request.getParameter("codAreaEmpresaActividad");
                        System.out.println("cod area formulas "+codAreaEmpresaAct);
                        String codEstadoProgramaProduccion=request.getParameter("codEstadoPrograma");
                        String nombreEstadoPrograma=request.getParameter("nombreEstado");
                        String nombreTipoActividad=request.getParameter("nombreTipoActividad");
                    String arrayProgram=request.getParameter("codProgramaProdArray");
                    String arrayNombres=request.getParameter("nombreProgramaProd");
                    String fechaInicio=request.getParameter("desdeFechaP");
                    String fechaFinal=request.getParameter("hastaFechaP");
                    String fechaInicioPer=request.getParameter("desdeFechaPers");
                    String fechaFinalper=request.getParameter("hastaFechaPers");
                    SimpleDateFormat format=new SimpleDateFormat("dd/MM/yyyy");
                    SimpleDateFormat horas=new SimpleDateFormat("HH:mm");
                    System.out.println("codProd "+arrayProgram);
                    System.out.println("nombreProd "+arrayNombres);
                    System.out.println("fecha inicio "+fechaInicio);
                    System.out.println("fecha final "+fechaFinal);

                    String[] fecha1=fechaInicio.split("/");
                    String[] fecha2=fechaFinal.split("/");
                    String[] fecha3=fechaInicioPer.split("/");
                    String[] fecha4=fechaFinalper.split("/");
                    boolean reportAcond=(request.getParameter("reporteconfechas").equals("1"));
                    boolean reportPers=(request.getParameter("reporteconfechasPer").equals("1"));
        %>
        <form>
            
            <h4 align="center" class="outputText5"><b>Reporte de Tiempos Producción Detallado</b></h4>
            

            <br>
                <center>
                    <table align="center" width="70%" class='outputText0'>
                <tr>
                    <td width="10%">
                        <img src="../../img/cofar.png">
                    </td>
                    <td align="center" width="80%">
                        <table class="outputTextNormal">
                            <tr>
                                <td align="left"><b>Programa Producción:</b></td>
                                <td align="left"><%=arrayNombres%></td>
                            </tr>
                            <tr>
                                <td align="left"><b>Area Empresa:</b></td>
                                <td align="left"><%=arrayNombreAreaEmpresa%></td>
                            </tr>
                            <tr>
                                <td align="left"><b>Estado Programa Producción:</b></td>
                                <td align="left"><%=nombreEstadoPrograma%></td>
                            </tr>
                             <tr>
                                <td align="left"><b>Tipo de Actividad:</b></td>
                                <td align="left"><%=nombreTipoActividad%></td>
                            </tr>
                            <%
                            if(reportPers)
                            {
                                out.println("<tr>"+
                                "<td align='left' colspan='2'><b>Reporte con fechas de personal</b></td></tr>"+
                                "<tr><td align='left'>Fecha de Ingreso Personal:</td><td align='left'>"+fechaInicioPer+"</td></tr>"+
                                "<tr><td align='left'>Fecha de Salida Personal:</td><td align='left'>"+fechaFinalper+"</td></tr>"+
                                "</tr>");
                            }
                            if(reportAcond)
                            {
                                out.println("<tr>"+
                                "<td align='left' colspan='2'><b>Reporte con Lotes que tienes ingresos a acondicionamiento</b></td></tr>"+
                                "<tr><td align='left'>De fecha :</td><td align='left'>"+fechaInicio+"</td></tr>"+
                                "<tr><td align='left'>A fecha </td><td align='left'>"+fechaFinal+"</td></tr>"+
                                "</tr>");
                            }
                            %>
                        </table>
                    </td>
                <td align="center" >
                </td>
                </tr>
            </table>
            <br/>
                <table class="outputTextNormal">
                    <tr>
                        <td ><b>Menor Productividad por personal</b></td><td style="width:40px;height:10px" bgcolor="#FFB6C1"></td>
                    
                        <td ><b>Mayor Productividad por personal</b></td><td style="width:40px;height:10px" bgcolor="#90EE90"></td>
                    </tr>
                </table>
                </center>
                <br></br>
            <table id="tablaReporte" width="70%" align="center" class="outputTextNormal" style="border : solid #000000 1px;" cellpadding="0" cellspacing="0" >

                <tr class="">
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='20%' align="center"><b>Lote</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='20%' align="center"><b>Area Proceso</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='20%' align="center"><b>Actividad</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='15%' align="center" ><b>Fecha Inicio</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='15%' align="center" ><b>Fecha Final</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='15%' align="center" ><b>Operario</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center"><b>Horas Hombre Personal</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Cantidad Producida Personal</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center"><b>Productividad Personal</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center"><b>Horas Extra Personal</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center"><b>Unidades Producidas Horas Extra</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center"><b>Horas Hombre Actividad</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Máquina Actividad</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Horas Máquina Actividad</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Standar Horas Hombre </b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Standar Horas Máquina </b></td>


                </tr>
                    <%
                    
                    String fechaInicioFormato=fecha1[2]+"/"+fecha1[1]+"/"+fecha1[0];
                    String fechaFinalFormato=fecha2[2]+"/"+fecha2[1]+"/"+fecha2[0];
                    String fechaInicioFormatoPer=fecha3[2]+"/"+fecha3[1]+"/"+fecha3[0];
                    String fechaFinalFormatoPer=fecha4[2]+"/"+fecha4[1]+"/"+fecha4[0];
                    double horasExtra=0d;
                    double unidadesExtra=0d;
                    
                    if(reportPers)
                    {
                        System.out.println("reporte con fechas de ingreso");
                    }
                    try{
                      con=Util.openConnection(con);
                      Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                      String consulta="select pp.COD_LOTE_PRODUCCION,pp.COD_COMPPROD,ae.COD_AREA_EMPRESA,"+
                                    " ISNULL(cp.nombre_prod_semiterminado,'') AS nombreProducto,"+
                                    " ISNULL(tpp.NOMBRE_TIPO_PROGRAMA_PROD,'') as nombreTipoProgramaProd,"+
                                    " ISNULL(ppp.NOMBRE_PROGRAMA_PROD,'') as  nombreProgramaProd,"+
                                    " ae.NOMBRE_AREA_EMPRESA,ap.NOMBRE_ACTIVIDAD,spp.HORAS_HOMBRE AS HORAS_HOMBRE_ACTIVIDAD," +
                                    " spp.HORAS_MAQUINA AS HORAS_MAQUINA_ACTIVIDAD,"+
                                    " ISNULL(m.NOMBRE_MAQUINA, ' ') as NOMBRE_MAQUINA,isnull(maf.HORAS_HOMBRE,0) as horHOmbre,"+
                                    " ISNULL(maf.HORAS_MAQUINA,0) as horMaq,sppp.FECHA_INICIO,sppp.FECHA_FINAL,"+
                                    " (p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL) as nombre,"+
                                    " (DATEDIFF(second, sppp.FECHA_INICIO, sppp.FECHA_FINAL) / 60.0 / 60.0) HORAS_HOMBRE, sppp.UNIDADES_PRODUCIDAS, ISNULL(sppp.HORAS_EXTRA, 0) AS HORAS_EXTRA,"+
                                    " ISNULL(sppp.UNIDADES_PRODUCIDAS_EXTRA, 0) AS UNIDADES_PRODUCIDAS_EXTRA"+
                                    " from PROGRAMA_PRODUCCION pp inner join COMPONENTES_PROD cp"+
                                    " on pp.COD_COMPPROD=cp.COD_COMPPROD"+
                                    " left outer join TIPOS_PROGRAMA_PRODUCCION tpp"+
                                    " on pp.COD_TIPO_PROGRAMA_PROD=tpp.COD_TIPO_PROGRAMA_PROD"+
                                    " left outer join PROGRAMA_PRODUCCION_PERIODO ppp on"+
                                    " pp.COD_PROGRAMA_PROD=ppp.COD_PROGRAMA_PROD"+
                                    " inner join SEGUIMIENTO_PROGRAMA_PRODUCCION spp on"+
                                    " spp.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD and spp.COD_COMPPROD=pp.COD_COMPPROD"+
                                    " and spp.COD_FORMULA_MAESTRA=pp.COD_FORMULA_MAESTRA and spp.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION"+
                                    " and spp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                                    " inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA=spp.COD_ACTIVIDAD_PROGRAMA"+
                                    " left outer join maquinarias m on m.COD_MAQUINA=spp.COD_MAQUINA"+
                                    " left outer join MAQUINARIA_ACTIVIDADES_FORMULA maf on"+
                                    " maf.COD_ACTIVIDAD_FORMULA = afm.COD_ACTIVIDAD_FORMULA and maf.COD_MAQUINA ="+
                                    " m.COD_MAQUINA inner join ACTIVIDADES_PRODUCCION ap on ap.COD_ACTIVIDAD=afm.COD_ACTIVIDAD"+
                                    " left outer join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=afm.COD_AREA_EMPRESA"+
                                    " inner join SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp on"+
                                    " sppp.COD_ACTIVIDAD_PROGRAMA=spp.COD_ACTIVIDAD_PROGRAMA and sppp.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD"+
                                    " and sppp.COD_COMPPROD=pp.COD_COMPPROD and sppp.COD_FORMULA_MAESTRA=pp.COD_FORMULA_MAESTRA"+
                                    " and sppp.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION and sppp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                                    " inner join personal p on p.COD_PERSONAL=sppp.COD_PERSONAL"+
                                    " where pp.COD_PROGRAMA_PROD IN ("+arrayProgram+") AND"+
                                    " pp.COD_LOTE_PRODUCCION + '' + CAST (pp.COD_COMPPROD AS VARCHAR (20)) + ''"+
                                    " + cast (pp.COD_TIPO_PROGRAMA_PROD as varchar (20)) IN ("+arrayCodCompProd+") AND"+
                                    " cp.COD_AREA_EMPRESA IN ("+arrayCodAreaEmpresa+")";
                                    if(reportPers)
                                    {
                                         consulta+=" and sppp.FECHA_INICIO BETWEEN '"+fechaInicioFormatoPer+" 00:00:00' and '"+fechaFinalFormatoPer+" 23:59:59'";
                                         consulta+=" and sppp.FECHA_FINAL BETWEEN '"+fechaInicioFormatoPer+" 00:00:00' and '"+fechaFinalFormatoPer+" 23:59:59'";
                                    }
                                    if(!codAreaEmpresaAct.equals("0"))
                                    {
                                        consulta+=" and afm.COD_AREA_EMPRESA in ("+codAreaEmpresaAct+") ";
                                    }
                                    if(reportAcond)
                                    {
                                       consulta+= " and cast(pp.COD_COMPPROD as varchar) + '' +cast(pp.COD_FORMULA_MAESTRA as varchar)+ '' +cast(pp.COD_LOTE_PRODUCCION as varchar)+ '' +cast(pp.COD_PROGRAMA_PROD as varchar)+ '' +cast(pp.COD_TIPO_PROGRAMA_PROD as varchar)";
                                       consulta+="in( select cast(pria.COD_COMPPROD as varchar)+ '' +cast(pria.COD_FORMULA_MAESTRA as varchar)+ '' +cast(pria.COD_LOTE_PRODUCCION as varchar)+ '' +cast(pria.COD_PROGRAMA_PROD as varchar)+ '' +cast(pria.COD_TIPO_PROGRAMA_PROD as varchar)";
                                       consulta+=" from PROGRAMA_PRODUCCION_INGRESOS_ACOND pria inner join INGRESOS_ACOND ia on ia.COD_INGRESO_ACOND=pria.COD_INGRESO_ACOND where ia.fecha_ingresoacond BETWEEN '"+fechaInicioFormato+" 00:00:00'and '"+fechaFinalFormato+" 23:59:59')";
                                    }
                                    consulta+=" order by pp.COD_LOTE_PRODUCCION,pp.COD_COMPPROD,pp.COD_TIPO_PROGRAMA_PROD,case when afm.COD_AREA_EMPRESA =76 then 1 when afm.COD_AREA_EMPRESA =97 then 2"+
                                    " when afm.COD_AREA_EMPRESA =96 then 3 when afm.COD_AREA_EMPRESA =82 then 4 when afm.COD_AREA_EMPRESA =75 then 5"+
                                    " when afm.COD_AREA_EMPRESA =40 then 6 when afm.COD_AREA_EMPRESA =1001 then 7 when afm.COD_AREA_EMPRESA =84 then 8"+
                                    " when afm.COD_AREA_EMPRESA =102 then 9 else 10 END,afm.ORDEN_ACTIVIDAD,sppp.FECHA_INICIO,spp.FECHA_FINAL,p.AP_MATERNO_PERSONAL,p.AP_PATERNO_PERSONAL,p.NOMBRES_PERSONAL";
                      System.out.println("consulta reporte  "+consulta);
                      String resultadoFinal="";
                      String celdaProceso="";
                      String celdaActividad="";
                      String primeraCeldaActividad="";
                      String cabeceraLote="";
                      String cabeceraAux="";
                      String cabeceraProceso="";
                      String cabeceraActividad="";
                      String celdaPersonal="";
                      String primeraCeldaPersonal="";
                      Date fechaIni;
                      Date fechaFin;
                      String nombrePersonal="";
                      int contLote=0;
                      int contActividad=0;
                      int contProceso=0;
                      double horasPersonal=0d;
                      double horasExtraPersonal=0d;
                      double cantidadPersonal=0d;
                      double cantidadExtraPersonal=0d;
                      double rendimiento=0d;
                      String areaProceso="";
                      String nombreActividad="";
                      ResultSet res=st.executeQuery(consulta);
                      String nombreMaquina="";
                      double horasHombreActividad=0d;
                      double horasMaquinaActividad=0d;
                      double horasHombreStandard=0d;
                      double horasMaquinaStandard=0d;
                      String codCompProd="";
                      boolean uno=true;
                     // double cantidadMenor=0d;
                     // double cantidadMayor=0d;
                     // int idMenor=0;
                     // int idmayor=0;
                      int codAreaEmpresaProceso=0;
                      while(res.next())
                      {
                      /*if(res.getDate("FECHA_INICIO")!=null)
                          {*/
                         // idRend++;
                          horasPersonal=res.getDouble("HORAS_HOMBRE");
                          horasExtraPersonal=res.getDouble("HORAS_EXTRA");
                          cantidadPersonal=res.getInt("UNIDADES_PRODUCIDAS");
                          cantidadExtraPersonal=res.getInt("UNIDADES_PRODUCIDAS_EXTRA");
                          areaProceso=res.getString("NOMBRE_AREA_EMPRESA");
                          nombreActividad=res.getString("NOMBRE_ACTIVIDAD");
                          fechaIni=res.getTimestamp("FECHA_INICIO");
                          fechaFin=res.getTimestamp("FECHA_FINAL");
                          nombrePersonal=res.getString("nombre");
                          rendimiento=(horasPersonal!=0?(cantidadPersonal/horasPersonal):0);
                          cabeceraAux=res.getString("nombreProgramaProd")+"<br></br>Lote: "+res.getString("COD_LOTE_PRODUCCION")+"<br></br>"+res.getString("nombreProducto")+"<br>("+res.getString("nombreTipoProgramaProd")+")";
                           if(!cabeceraLote.equals(cabeceraAux))
                           {
                               if(uno)contLote++;
                               String[] datos=cabeceraLote.split("<br></br>");
                               double cantidadAPT=0;
                               if(datos.length>1)
                                   {
                               cantidadAPT=this.enviadosAPT(datos[1].split(": ")[1], codCompProd);
                                if(codAreaEmpresaProceso==84){sumaCantidadProceso=cantidadAPT;}
                                if(codAreaEmpresaProceso==96){sumaCantidadProceso=this.enviadosAcond(datos[1].split(": ")[1], codCompProd);}
                               }
                               resultadoFinal+=cabeceraLote.equals("")?"":generarCeldaLote(codCompProd,contLote,cabeceraLote,celdaProceso,
                                      generarCeldaAreaProceso(contProceso,cabeceraProceso,celdaActividad,
                                            generarCeldaActividad(contActividad,cabeceraActividad,primeraCeldaPersonal,formato.format(horasHombreActividad),nombreMaquina,
                                            formato.format(horasMaquinaActividad),formato.format(horasHombreStandard),formato.format(horasMaquinaStandard),celdaPersonal),codCompProd,entero.format(sumaCantidadProceso)
                                            ,formato.format(sumaHorasProceso),formato.format(sumaCantidadProceso/sumaHorasProceso),formato.format(sumaHorasExtraProceso),entero.format(sumaCantidadExtraProceso),
                                            formato.format(sumahorasProcesoActividadPersonal),formato.format(sumahorasProcesoActividadMaquina),formato.format(sumahorasProcesoActividadStandardHombre),formato.format(sumahorasProcesoActividadStandardMaquina)),
                                            formato.format(sumaLoteHorasPer),entero.format(cantidadAPT),formato.format(cantidadAPT/sumaLoteHorasPer),formato.format(sumaLoteHorasExtraPer),
                                            entero.format(sumaLoteCanExtraPer),formato.format(sumaLoteHorHomAct),formato.format(sumaLoteHorMaqAct),formato.format(sumaLoteHorHomStand),formato.format(sumaLoteHorMaqStand));
                                out.println(resultadoFinal);
                                resultadoFinal="";
                                sumaLoteHorasPer=0d;
                                sumaLoteHorasExtraPer=0d;
                                sumaLoteCanExtraPer=0d;
                                sumaLoteHorHomAct=0d;
                                sumaLoteHorMaqAct=0d;
                                sumaLoteHorHomStand=0d;
                                sumaLoteHorMaqStand=0d;
                                sumaHorasExtraProceso=0d;
                                  sumaHorasProceso=0d;
                                  sumaCantidadExtraProceso=0d;
                                  sumaCantidadProceso=0d;
                                  sumahorasProcesoActividadMaquina=0d;
                                  sumahorasProcesoActividadPersonal=0d;
                                  sumahorasProcesoActividadStandardHombre=0d;
                                  sumahorasProcesoActividadStandardMaquina=0d;
                               cabeceraLote=cabeceraAux;
                               cabeceraProceso="";
                               celdaProceso="";
                               contLote=0;
                               contActividad=0;
                               contProceso=0;
                               codCompProd=res.getString("COD_COMPPROD");
                               codAreaEmpresaProceso=res.getInt("COD_AREA_EMPRESA");
                          }
                          if(!cabeceraProceso.equals(areaProceso))
                          {

                             if(!cabeceraProceso.equals(""))
                              {
                                    String[] datos=cabeceraLote.split("<br></br>");
                                    if(codAreaEmpresaProceso==84){sumaCantidadProceso=this.enviadosAPT(datos[1].split(": ")[1], codCompProd);}
                                    if(codAreaEmpresaProceso==96){sumaCantidadProceso=this.enviadosAcond(datos[1].split(": ")[1], codCompProd);}
                                    celdaProceso+=((celdaProceso.equals("")?"":"<tr class='outputTextNormal'>")+generarCeldaAreaProceso(contProceso,cabeceraProceso,celdaActividad,
                                            generarCeldaActividad(contActividad,cabeceraActividad,primeraCeldaPersonal,formato.format(horasHombreActividad),nombreMaquina,
                                            formato.format(horasMaquinaActividad),formato.format(horasHombreStandard),formato.format(horasMaquinaStandard),celdaPersonal)
                                            ,codCompProd,entero.format(sumaCantidadProceso),
                                            formato.format(sumaHorasProceso),formato.format(sumaCantidadProceso/sumaHorasProceso),formato.format(sumaHorasExtraProceso),entero.format(sumaCantidadExtraProceso),formato.format(sumahorasProcesoActividadPersonal),formato.format(sumahorasProcesoActividadMaquina),formato.format(sumahorasProcesoActividadStandardHombre),formato.format(sumahorasProcesoActividadStandardMaquina)));
                                    sumaHorasExtraProceso=0d;
                                      sumaHorasProceso=0d;
                                      sumaCantidadExtraProceso=0d;
                                      sumaCantidadProceso=0d;
                                      sumahorasProcesoActividadMaquina=0d;
                                      sumahorasProcesoActividadPersonal=0d;
                                      sumahorasProcesoActividadStandardHombre=0d;
                                      sumahorasProcesoActividadStandardMaquina=0d;
                                        
                              }
                             codAreaEmpresaProceso=res.getInt("cod_area_empresa");
                              uno=cabeceraProceso.equals("");
                              celdaActividad="";
                              primeraCeldaPersonal="";
                              celdaPersonal="";
                              cabeceraProceso=areaProceso;
                              cabeceraActividad="";
                              contProceso=0;
                              contLote++;
                          }
                          if(!cabeceraActividad.equals(nombreActividad))
                          {
                                celdaActividad+=cabeceraActividad.equals("")?"":((celdaActividad.equals("")?"":"<tr class='outputTextNormal'>") +
                                             generarCeldaActividad(contActividad,cabeceraActividad,primeraCeldaPersonal,formato.format(horasHombreActividad),nombreMaquina,
                                             formato.format(horasMaquinaActividad),formato.format(horasHombreStandard),formato.format(horasMaquinaStandard),celdaPersonal));
                                nombreMaquina=res.getString("NOMBRE_MAQUINA");
                                horasHombreActividad=res.getDouble("HORAS_HOMBRE_ACTIVIDAD");
                                horasMaquinaActividad=res.getDouble("HORAS_MAQUINA_ACTIVIDAD");
                                horasHombreStandard=res.getDouble("horHOmbre");
                                horasMaquinaStandard=res.getDouble("horMaq");
                                primeraCeldaPersonal="";
                                celdaPersonal="";
                                contActividad=0;
                                cabeceraActividad=nombreActividad;
                                sumahorasProcesoActividadPersonal+=horasHombreActividad;
                                sumahorasProcesoActividadMaquina+=horasMaquinaActividad;
                                sumahorasProcesoActividadStandardHombre+=horasHombreStandard;
                                sumahorasProcesoActividadStandardMaquina+=horasMaquinaStandard;
                                sumaLoteHorHomAct+=horasHombreActividad;
                                sumaLoteHorMaqAct+=horasMaquinaActividad;
                                sumaLoteHorHomStand+=horasHombreStandard;
                                sumaLoteHorMaqStand+=horasMaquinaStandard;
                                /*if(!cabeceraActividad.equals(""))
                                {
                                    if(cantidadMayor>0){arrayMayores+=(arrayMayores.equals("")?"":",")+idmayor;}
                                    if(cantidadMenor>0){arrayMenores+=(arrayMenores.equals("")?"":",")+idMenor;}
                                }*/
                          }
                          sumaHorasProceso+=horasPersonal;
                          sumaCantidadProceso+=cantidadPersonal;
                          sumaHorasExtraProceso+=horasExtraPersonal;
                          sumaCantidadExtraProceso+=cantidadExtraPersonal;
                          sumaLoteHorasPer+=horasPersonal;
                          sumaLoteCanExtraPer+=cantidadExtraPersonal;
                          sumaLoteHorasExtraPer+=horasExtraPersonal;
                          if(primeraCeldaPersonal.equals(""))
                          {
                                      /*cantidadMenor=rendimiento;
                                      cantidadMayor=rendimiento;
                                      idMenor=idRend;
                                      idmayor=idRend;*/
                                      primeraCeldaPersonal=generarCeldaPersonal((fechaIni==null?"":format.format(fechaIni)),(fechaIni==null?"":horas.format(fechaIni)),(fechaFin==null?"":format.format(fechaFin)),
                                              (fechaFin==null?"":horas.format(fechaFin)),nombrePersonal,
                                              formato.format(horasPersonal),entero.format(cantidadPersonal),formato.format(rendimiento),formato.format(horasExtraPersonal),entero.format(cantidadExtraPersonal));
                                      
                          }
                          else
                          {
                                   /* if(cantidadMayor<rendimiento){cantidadMayor=rendimiento;idmayor=idRend;}
                                    if(cantidadMenor>0){
                                        if(cantidadMenor>rendimiento){cantidadMenor=rendimiento;idMenor=idRend;}
                                        
                                    }
                                    else
                                        {
                                            cantidadMenor=rendimiento;idMenor=idRend;
                                         }*/
                                      celdaPersonal+="<tr class='outputTextNormal'>" +generarCeldaPersonal((fechaIni==null?"":format.format(fechaIni)),(fechaIni==null?"":horas.format(fechaIni)),
                                              (fechaFin==null?"":format.format(fechaFin)),(fechaFin==null?"":horas.format(fechaFin)),nombrePersonal,
                                              formato.format(horasPersonal),entero.format(cantidadPersonal),formato.format(horasPersonal!=0?(cantidadPersonal/horasPersonal):0),formato.format(horasExtraPersonal),entero.format(cantidadExtraPersonal))+
                                              "</tr>";
                           
                          }
                          
                          contActividad++;
                          contProceso++;
                          contLote++;
                         // }
                      }
                      if(uno)contLote++;
                      /*arrayMayores+=(arrayMayores.equals("")?"":",")+idmayor;
                      arrayMenores+=(arrayMenores.equals("")?"":",")+idMenor;
                      */
                      String[] datos=cabeceraLote.split("<br></br>");
                      double cantidadApt=0;
                      if(datos.length>1)
                          {
                            cantidadApt=this.enviadosAPT(datos[1].split(": ")[1], codCompProd);
                                if(codAreaEmpresaProceso==84){sumaCantidadProceso=cantidadApt;}
                                if(codAreaEmpresaProceso==96){sumaCantidadProceso=this.enviadosAcond(datos[1].split(": ")[1], codCompProd);}
                      }
                       resultadoFinal+=cabeceraLote.equals("")?"":generarCeldaLote(codCompProd,contLote,cabeceraLote,celdaProceso,
                                      generarCeldaAreaProceso(contProceso,cabeceraProceso,celdaActividad,
                                            generarCeldaActividad(contActividad,cabeceraActividad,primeraCeldaPersonal,formato.format(horasHombreActividad),nombreMaquina,
                                            formato.format(horasMaquinaActividad),formato.format(horasHombreStandard),formato.format(horasMaquinaStandard),celdaPersonal)
                                            ,codCompProd,entero.format(sumaCantidadProceso),
                                            formato.format(sumaHorasProceso),formato.format(sumaCantidadProceso/sumaHorasProceso),formato.format(sumaHorasExtraProceso),entero.format(sumaCantidadExtraProceso),
                                            formato.format(sumahorasProcesoActividadPersonal),formato.format(sumahorasProcesoActividadMaquina),formato.format(sumahorasProcesoActividadStandardHombre),formato.format(sumahorasProcesoActividadStandardMaquina)),
                                            formato.format(sumaLoteHorasPer),entero.format(cantidadApt),formato.format(cantidadApt/sumaLoteHorasPer),formato.format(sumaLoteHorasExtraPer),
    entero.format(sumaLoteCanExtraPer),formato.format(sumaLoteHorHomAct),formato.format(sumaLoteHorMaqAct),formato.format(sumaLoteHorHomStand),formato.format(sumaLoteHorMaqStand));
                      out.println(resultadoFinal);
                      sumaHorasExtraProceso=0d;
                      sumaHorasProceso=0d;
                      sumaCantidadExtraProceso=0d;
                      sumaCantidadProceso=0d;
                      sumahorasProcesoActividadMaquina=0d;
                      sumahorasProcesoActividadPersonal=0d;
                      sumahorasProcesoActividadStandardHombre=0d;
                      sumahorasProcesoActividadStandardMaquina=0d;
                      
                      res.close();
                      st.close();
                      con.close();
                    }
                    catch(SQLException ex)
                    {
                        ex.printStackTrace();
                    }
                   
                    }
                    catch(ArrayIndexOutOfBoundsException e)
                    {
                        e.printStackTrace();
                    }
                    catch(Exception es)
                    {
                        es.printStackTrace();
                    }
                    
                    %>
               </table>
            <script>
                /*
                var cadenaMenores='<%--=arrayMenores--%>';
                var menores=cadenaMenores.split(',');
                for(var i=0;i<menores.length;i++)
                {
                    if(parseInt(menores[i])>0){
                        while(document.getElementById(menores[i])==null)
                        {
                        }
                        
                      
                            document.getElementById(menores[i]).bgColor='#FFB6C1';
                      
                    }
                }
                var cadena='<%--=arrayMayores--%>';
                var mayores=cadena.split(',');
                for(var index=0;index<mayores.length;index++)
                {
                    if(parseInt(mayores[index])>0){
                        
                            document.getElementById(mayores[index]).bgColor='#90EE90';
                       
                    }
                }
               cadenaMenores=null;
               mayores=null;*/
            </script>
            <br>
            <br>
            <div align="center">
            </div>
        </form>
    </body>
</html>