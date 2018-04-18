<%--@page contentType="text/html"--%>
<%@ page contentType="application/vnd.ms-excel"%>
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
%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <%--meta http-equiv="Content-Type" content="text/html; charset=UTF-8"--%>
        <style>
            .cellHeader{
                background-color:#dddddd;
                color:black;
                font-family:Arial;
                font-size:12px;
                font-weight:bold;
                text-align:center;
                border-bottom:1px solid black;
                border-right:1px solid black;
            }
            .cellNormal{
                
                color:black;
                font-family:Arial;
                font-size:10px;
                text-align:center;
                border-bottom:1px solid black;
                border-right:1px solid black;
            }
            .cellArea{

                background-color:#90EE90;
                color:black;
                font-family:Arial;
                font-size:12px;
                text-align:center;
                font-weight:bold;
                border-bottom:1px solid black;
                border-right:1px solid black;
            }
            .cellLote{

                background-color:#FF4500;
                color:black;
                font-family:Arial;
                font-size:13px;
                text-align:center;
                font-weight:bold;
                border-bottom:1px solid black;
                border-right:1px solid black;
            }
            .textoNormal{
                font-weight:normal;
                font-family:Arial;
                font-size:12px;
            }
        </style>
    </head>

    <body>
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
                   Connection con=null;
                   con=Util.openConnection(con);
                    Statement st = con.createStatement();
                    ResultSet rs = st.executeQuery(consulta);
                    if(rs.next()){
                        enviadosAcond = rs.getFloat("enviados_acond");
                    }
                    con.close();
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
                    Connection con=null;
                    con=Util.openConnection(con);
                    Statement st = con.createStatement();
                    ResultSet rs = st.executeQuery(consulta);
                    if(rs.next()){
                        enviadosAPT = rs.getDouble("cantidadEnviadaAPT");
                    }
                    con.close();
                }catch(Exception e){
                    e.printStackTrace();
                }
                return enviadosAPT;
            }
        %>
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
            int idRend=0;
            String arrayMayores="";
            String arrayMenores="";
              NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
                        formato = (DecimalFormat) numeroformato;
                        formato.applyPattern("###0.00;(###0.00)");
                        NumberFormat enteroformat = NumberFormat.getNumberInstance(Locale.ENGLISH);
                        entero = (DecimalFormat) enteroformat;
                        entero.applyPattern("####;(####)");
                        String codCompProdP=request.getParameter("codCompProdP");
                        String nombreCompProd=request.getParameter("nombreCompProdP");
                        String codProgramaProdPeriodo=request.getParameter("codProgramaProduccionPeriodo")==null?"''":request.getParameter("codProgramaProduccionPeriodo");
                        String arrayCodCompProd =request.getParameter("codCompProdArray")==null?"''":request.getParameter("codCompProdArray");
                        String nombreProgramaProduccionPeriodo = request.getParameter("nombreProgramaProduccionPeriodo")==null?"''":request.getParameter("nombreProgramaProduccionPeriodo");
                        arrayCodCompProd = arrayCodCompProd + (arrayCodCompProd.length()==0?"' '":"");
                        String[] valores=arrayCodCompProd.split(",");
                        String arrayCodAreaEmpresa= request.getParameter("codAreaEmpresaP");
                        String arrayNombreAreaEmpresa= request.getParameter("nombreAreaEmpresaP");
                        String codAreaEmpresaAct=request.getParameter("codAreaEmpresaActividad");
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
                    System.out.println("ccdcd "+request.getParameter("reporteLotes"));
                    boolean reporteLotes=(request.getParameter("reporteLotes").equals("1"));
        %>
        <form>
            
            <h4 align="center" class="outputText5"><b>Reporte de Tiempos Producción Detallado Excel</b></h4>
            

            <br>
                <center>
                    <table align="center" width="70%" class='textoNormal'>
                <tr>
                    <td width="10%">
                        <img src="../../img/cofar.png">
                    </td>
                    <td align="center" width="80%">
                        
                        <table class="textoNormal">
                            <tr>
                                <td align="left" style="font-weight:bold"><b>Programa Producción:</b></td>
                                <td align="left"><%=arrayNombres%></td>
                            </tr>
                            <tr>
                                <td align="left" style="font-weight:bold"><b>Area Empresa:</b></td>
                                <td align="left"><%=arrayNombreAreaEmpresa%></td>
                            </tr>
                            <tr>
                                <td align="left" style="font-weight:bold"><b>Estado Programa Producción:</b></td>
                                <td align="left"><%=nombreEstadoPrograma%></td>
                            </tr>
                             <tr>
                                <td align="left" style="font-weight:bold"><b>Tipo de Actividad:</b></td>
                                <td align="left"><%=nombreTipoActividad%></td>
                            </tr>
                            <%
                            if(reportPers)
                            {
                                out.println("<tr>"+
                                "<td align='left' style='font-weight:bold' ><b>Reporte con fechas de personal</b></td></tr>"+
                                "<tr><td align='left'>Fecha de Ingreso Personal:</td><td align='left'>"+fechaInicioPer+"</td></tr>"+
                                "<tr><td align='left'>Fecha de Salida Personal:</td><td align='left'>"+fechaFinalper+"</td></tr>"+
                                "</tr>");
                            }
                            if(reportAcond)
                            {
                                out.println("<tr>"+
                                "<td align='left' style='font-weight:bold'><b>Reporte con Lotes que tienes ingresos a acondicionamiento</b></td></tr>"+
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
               
                </center>
                <br></br>
            <table id="tablaReporte" width="70%" align="center" class="textoNormal" style="border : solid #000000 1px;" cellpadding="0" cellspacing="0" >

                <tr class="">
                    <td  class="cellHeader"   width='20%' align="center"><b>Lote</b></td>
                    <td  class="cellHeader"   width='20%' align="center"><b>Codigo<br>Producto</b></td>
                    <td  class="cellHeader"   width='20%' align="center"><b>Producto</b></td>
                    <td  class="cellHeader"   width='5%' align="center"><b>Tipo Prod.</b></td>
                    <td  class="cellHeader"   width='20%' align="center"><b>Area Proceso</b></td>
                    <td  class="cellHeader"  width='20%' align="center"><b>Actividad</b></td>
                    <td  class="cellHeader"   width='15%' align="center" ><b>Fecha Inicio</b></td>
                    <td  class="cellHeader"   width='15%' align="center" ><b>Fecha Final</b></td>
                    <td  class="cellHeader"   width='15%' align="center" ><b>Operario</b></td>
                    <td  class="cellHeader"   width='5%' align="center"><b>Horas Hombre Personal</b></td>
                    <td align="center"  class="cellHeader"   width='5%' align="center"><b>Cantidad Producida Personal</b></td>
                    <td  class="cellHeader"   width='5%' align="center"><b>Productividad Personal</b></td>
                    <td  class="cellHeader"   width='5%' align="center"><b>Horas Extra Personal</b></td>
                    <td  class="cellHeader"   width='5%' align="center"><b>Unidades Producidas Horas Extra</b></td>
                    <td  class="cellHeader"   width='5%' align="center"><b>Horas Hombre Actividad</b></td>
                    <td align="center"  class="cellHeader"   width='5%' align="center"><b>Máquina Actividad</b></td>
                    <td align="center"  class="cellHeader"   width='5%' align="center"><b>Horas Máquina Actividad</b></td>
                    <td align="center"  class="cellHeader"   width='5%' align="center"><b>Standar Horas Hombre </b></td>
                    <td align="center"  class="cellHeader"   width='5%' align="center"><b>Standar Horas Máquina </b></td>


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
                      StringBuilder consulta=new StringBuilder("select pp.COD_LOTE_PRODUCCION,pp.COD_COMPPROD,ae.COD_AREA_EMPRESA,");
                                                    consulta.append(" ISNULL(cp.nombre_prod_semiterminado,'') AS nombreProducto, ISNULL(tpp.NOMBRE_TIPO_PROGRAMA_PROD,'') as nombreTipoProgramaProd,");
                                                    consulta.append(" ISNULL(ppp.NOMBRE_PROGRAMA_PROD,'') as  nombreProgramaProd,");
                                                    consulta.append(" ae.NOMBRE_AREA_EMPRESA,ap.NOMBRE_ACTIVIDAD,spp.HORAS_HOMBRE AS HORAS_HOMBRE_ACTIVIDAD," );
                                                    consulta.append(" spp.HORAS_MAQUINA AS HORAS_MAQUINA_ACTIVIDAD,");
                                                    consulta.append(" ISNULL(m.NOMBRE_MAQUINA, ' ') as NOMBRE_MAQUINA,isnull(maf.HORAS_HOMBRE,0) as horHOmbre,");
                                                    consulta.append(" ISNULL(maf.HORAS_MAQUINA,0) as horMaq,sppp.FECHA_INICIO,sppp.FECHA_FINAL,");
                                                    consulta.append(" isnull((p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL),'')+' '+isnull((pt.AP_PATERNO_PERSONAL+' '+pt.AP_MATERNO_PERSONAL+' '+pt.NOMBRES_PERSONAL),'') as nombre,");
                                                    consulta.append(" (DATEDIFF(second, sppp.FECHA_INICIO, sppp.FECHA_FINAL) / 60.0 / 60.0) HORAS_HOMBRE, sppp.UNIDADES_PRODUCIDAS, ISNULL(sppp.HORAS_EXTRA, 0) AS HORAS_EXTRA,");
                                                    consulta.append(" ISNULL(sppp.UNIDADES_PRODUCIDAS_EXTRA, 0) AS UNIDADES_PRODUCIDAS_EXTRA,");
                                                    consulta.append(" ISNULL(tpp.ABREVIATURA,'') as ABREVIATURA");
                                                consulta.append(" from PROGRAMA_PRODUCCION pp");
                                                    consulta.append(" inner join COMPONENTES_PROD cp on pp.COD_COMPPROD=cp.COD_COMPPROD");
                                                    consulta.append(" left outer join TIPOS_PROGRAMA_PRODUCCION tpp on pp.COD_TIPO_PROGRAMA_PROD=tpp.COD_TIPO_PROGRAMA_PROD");
                                                    consulta.append(" left outer join PROGRAMA_PRODUCCION_PERIODO ppp on pp.COD_PROGRAMA_PROD=ppp.COD_PROGRAMA_PROD");
                                                    consulta.append(" inner join SEGUIMIENTO_PROGRAMA_PRODUCCION spp on spp.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD and spp.COD_COMPPROD=pp.COD_COMPPROD");
                                                        consulta.append(" and spp.COD_FORMULA_MAESTRA=pp.COD_FORMULA_MAESTRA and spp.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION");
                                                        consulta.append(" and spp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD");
                                                    consulta.append(" inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA=spp.COD_ACTIVIDAD_PROGRAMA");
                                                    consulta.append(" left outer join maquinarias m on m.COD_MAQUINA=spp.COD_MAQUINA");
                                                    consulta.append(" left outer join MAQUINARIA_ACTIVIDADES_FORMULA maf on maf.COD_ACTIVIDAD_FORMULA = afm.COD_ACTIVIDAD_FORMULA");
                                                        consulta.append(" and maf.COD_MAQUINA = m.COD_MAQUINA inner join ACTIVIDADES_PRODUCCION ap on ap.COD_ACTIVIDAD=afm.COD_ACTIVIDAD");
                                                    consulta.append(" left outer join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=afm.COD_AREA_EMPRESA");
                                                    consulta.append(" inner join SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp on");
                                                        consulta.append(" sppp.COD_ACTIVIDAD_PROGRAMA=spp.COD_ACTIVIDAD_PROGRAMA and sppp.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD");
                                                        consulta.append(" and sppp.COD_COMPPROD=pp.COD_COMPPROD and sppp.COD_FORMULA_MAESTRA=pp.COD_FORMULA_MAESTRA");
                                                        consulta.append(" and sppp.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION and sppp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD");
                                                    consulta.append(" left outer join personal p on p.COD_PERSONAL=sppp.COD_PERSONAL " );
                                                    consulta.append(" left outer join personal_temporal pt on pt.cod_personal = sppp.cod_personal ");
                                                consulta.append(" where pp.COD_PROGRAMA_PROD IN (").append(arrayProgram).append(")");
                                                    if(codEstadoProgramaProduccion.equals("0"))
                                                        consulta.append(" and pp.COD_ESTADO_PROGRAMA in (").append(codEstadoProgramaProduccion).append(")");
                                                    if(reporteLotes)
                                                    {
                                                        consulta.append(" AND pp.COD_LOTE_PRODUCCION + '' + CAST (pp.COD_COMPPROD AS VARCHAR (20)) + ''");
                                                        consulta.append(" + cast (pp.COD_TIPO_PROGRAMA_PROD as varchar (20)) IN (").append(arrayCodCompProd).append(")");
                                                    }
                                                    consulta.append(" AND  cp.COD_AREA_EMPRESA IN ("+arrayCodAreaEmpresa+")");
                                                    if(codCompProdP.length()>0)
                                                        consulta.append(" and cp.COD_COMPPROD IN ("+codCompProdP+")");
                                                    if(reportPers)
                                                    {
                                                        consulta.append(" and sppp.FECHA_INICIO BETWEEN '").append(fechaInicioFormatoPer).append(" 00:00:00' and '").append(fechaFinalFormatoPer).append(" 23:59:59'");
                                                        consulta.append(" and sppp.FECHA_FINAL BETWEEN '").append(fechaInicioFormatoPer).append(" 00:00:00' and '").append(fechaFinalFormatoPer).append(" 23:59:59'");
                                                    }
                                                    if(!codAreaEmpresaAct.equals("0"))  
                                                    {
                                                        consulta.append(" and afm.COD_AREA_EMPRESA in (").append(codAreaEmpresaAct).append(") ");
                                                    }
                                                    if(reportAcond)
                                                    {
                                                       consulta.append(" and cast(pp.COD_COMPPROD as varchar) + '' +cast(pp.COD_FORMULA_MAESTRA as varchar)+ '' +cast(pp.COD_LOTE_PRODUCCION as varchar)+ '' +cast(pp.COD_PROGRAMA_PROD as varchar)+ '' +cast(pp.COD_TIPO_PROGRAMA_PROD as varchar)");
                                                       consulta.append("in( select cast(pria.COD_COMPPROD as varchar)+ '' +cast(pria.COD_FORMULA_MAESTRA as varchar)+ '' +cast(pria.COD_LOTE_PRODUCCION as varchar)+ '' +cast(pria.COD_PROGRAMA_PROD as varchar)+ '' +cast(pria.COD_TIPO_PROGRAMA_PROD as varchar)");
                                                       consulta.append(" from PROGRAMA_PRODUCCION_INGRESOS_ACOND pria inner join INGRESOS_ACOND ia on ia.COD_INGRESO_ACOND=pria.COD_INGRESO_ACOND where ia.fecha_ingresoacond BETWEEN '").append(fechaInicioFormato).append(" 00:00:00'and '").append(fechaFinalFormato).append(" 23:59:59')");
                                                    }
                                                consulta.append(" order by pp.COD_LOTE_PRODUCCION,pp.COD_COMPPROD,pp.COD_TIPO_PROGRAMA_PROD,case when afm.COD_AREA_EMPRESA =76 then 1 when afm.COD_AREA_EMPRESA =97 then 2");
                                                    consulta.append(" when afm.COD_AREA_EMPRESA =96 then 3 when afm.COD_AREA_EMPRESA =82 then 4 when afm.COD_AREA_EMPRESA =75 then 5");
                                                    consulta.append(" when afm.COD_AREA_EMPRESA =40 then 6 when afm.COD_AREA_EMPRESA =1001 then 7 when afm.COD_AREA_EMPRESA =84 then 8");
                                                    consulta.append(" when afm.COD_AREA_EMPRESA =102 then 9 else 10 END,afm.ORDEN_ACTIVIDAD,sppp.FECHA_INICIO,spp.FECHA_FINAL,p.AP_MATERNO_PERSONAL,p.AP_PATERNO_PERSONAL,p.NOMBRES_PERSONAL");
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
                      ResultSet res=st.executeQuery(consulta.toString());
                      String nombreMaquina="";
                      double horasHombreActividad=0d;
                      double horasMaquinaActividad=0d;
                      double horasHombreStandard=0d;
                      double horasMaquinaStandard=0d;
                      String codCompProd="";
                      boolean uno=true;
                      double cantidadMenor=0d;
                      double cantidadMayor=0d;
                      int idMenor=0;
                      int idmayor=0;
                      int codAreaEmpresaProceso=0;
                      String codLoteProduccion="";
                      String abreviaturaTipoProduccion="";
                      double cantidadEnviadaApt=0d;
                      String nombreProducto="";
                      String nombreActividadCabecera="";
                      while(res.next())
                      {
                         
                          cabeceraAux=res.getString("nombreProgramaProd")+"<br></br>Lote: "+res.getString("COD_LOTE_PRODUCCION")+"<br></br>"+res.getString("nombreProducto")+"<br>("+res.getString("nombreTipoProgramaProd")+")";
                           if(!cabeceraLote.equals(cabeceraAux))
                           {
                               if(!cabeceraLote.equals(""))
                               {
                                   cantidadEnviadaApt=this.enviadosAPT(codLoteProduccion, codCompProd);
                                   if(codAreaEmpresaProceso==84){sumaCantidadProceso=cantidadEnviadaApt;}
                                    if(codAreaEmpresaProceso==96){sumaCantidadProceso=this.enviadosAcond(codLoteProduccion, codCompProd);}
                                    out.println("<tr><td class='cellArea'>"+codLoteProduccion+"</td><td class='cellArea'>"+codCompProd+"</td><td class='cellArea'>"+nombreProducto+"</td><td class='cellArea'>"+abreviaturaTipoProduccion+"</td><td class='cellArea'>"+areaProceso+"</td>" +
                                          "<td class='cellArea'>&nbsp;</td><td class='cellArea'>&nbsp;</td><td class='cellArea'>&nbsp;</td>" +
                                          "<td class='cellArea'>Sub Total:</td><td class='cellArea'>"+formato.format(sumaHorasProceso)+"</td>" +
                                          "<td class='cellArea'>"+entero.format(sumaCantidadProceso)+"</td><td class='cellArea'>"+(sumaHorasProceso>0?formato.format(sumaCantidadProceso/sumaHorasProceso):0)+"</td>" +
                                          "<td class='cellArea'>"+formato.format(sumaHorasExtraProceso)+"</td><td class='cellArea'>"+formato.format(sumaCantidadExtraProceso)+"</td>" +
                                          "<td class='cellArea'>"+formato.format(sumahorasProcesoActividadPersonal)+"</td><td class='cellArea'>&nbsp;</td><td class='cellArea'>"+formato.format(sumahorasProcesoActividadMaquina)+"</td>" +
                                          "<td class='cellArea'>"+formato.format(sumahorasProcesoActividadStandardHombre)+"</td>" +
                                          "<td class='cellArea'>"+formato.format(sumahorasProcesoActividadStandardMaquina)+"</td></tr>");
                                   out.println("<tr><td class='cellLote'>"+codLoteProduccion+"</td><td class='cellLote'>"+codCompProd+"</td><td class='cellLote'>"+nombreProducto+"</td><td class='cellLote'>"+abreviaturaTipoProduccion+"</td><td class='cellLote'>&nbsp;</td>" +
                                          "<td class='cellLote'>&nbsp;</td><td class='cellLote'>&nbsp;</td><td class='cellLote'>&nbsp;</td>" +
                                          "<td class='cellLote'>Total Lote:</td><td class='cellLote'>"+formato.format(sumaLoteHorasPer)+"</td>" +
                                          "<td class='cellLote'>"+entero.format(cantidadEnviadaApt)+"</td><td class='cellLote'>"+(sumaLoteHorasPer>0?(formato.format(cantidadEnviadaApt/sumaLoteHorasPer)):0)+"</td>" +
                                          "<td class='cellLote'>"+formato.format(sumaLoteHorasExtraPer)+"</td><td class='cellLote'>"+formato.format(sumaLoteCanExtraPer)+"</td>" +
                                          "<td class='cellLote'>"+formato.format(sumaLoteHorHomAct)+"</td><td class='cellLote'>&nbsp;</td>" +
                                          "<td class='cellLote'>"+formato.format(sumaLoteHorMaqAct)+"</td>" +
                                          "<td class='cellLote'>"+formato.format(sumaLoteHorHomStand)+"</td>" +
                                          "<td class='cellLote'>"+formato.format(sumaLoteHorMaqStand)+"</td>"+
                                          "</tr>");
                               }
                          sumaLoteHorasPer=0;
                          sumaHorasProceso=0;
                          sumaHorasExtraProceso=0;
                          sumaLoteHorasExtraPer=0;
                          sumaCantidadExtraProceso=0;
                          sumaLoteCanExtraPer=0;
                          sumahorasProcesoActividadPersonal=0;
                          sumaLoteHorHomAct=0;
                          sumahorasProcesoActividadMaquina=0;
                          sumaLoteHorMaqAct=0;
                          sumahorasProcesoActividadStandardHombre=0;
                          sumaLoteHorHomStand=0;
                          sumahorasProcesoActividadStandardMaquina=0;
                          sumaLoteHorMaqStand=0;
                          sumaCantidadProceso=0;
                          cabeceraLote=cabeceraAux;
                          codAreaEmpresaProceso=0;
                          nombreActividadCabecera="";
                           }
                           if(codAreaEmpresaProceso!=res.getInt("COD_AREA_EMPRESA"))
                          {
                              if(codAreaEmpresaProceso>0)
                              {
                                  
                                   if(codAreaEmpresaProceso==84){sumaCantidadProceso=this.enviadosAPT(codLoteProduccion, codCompProd);}
                                    if(codAreaEmpresaProceso==96){sumaCantidadProceso=this.enviadosAcond(codLoteProduccion, codCompProd);}
                                  out.println("<tr><td class='cellArea'>"+codLoteProduccion+"</td><td class='cellArea'>"+codCompProd+"</td><td class='cellArea'>"+nombreProducto+"</td><td class='cellArea'>"+abreviaturaTipoProduccion+"</td><td class='cellArea'>"+areaProceso+"</td>" +
                                          "<td class='cellArea'>&nbsp;</td><td class='cellArea'>&nbsp;</td><td class='cellArea'>&nbsp;</td>" +
                                          "<td class='cellArea'>Sub Total:</td><td class='cellArea'>"+formato.format(sumaHorasProceso)+"</td>" +
                                          "<td class='cellArea'>"+entero.format(sumaCantidadProceso)+"</td><td class='cellArea'>"+(sumaHorasProceso>0?formato.format(sumaCantidadProceso/sumaHorasProceso):0)+"</td>" +
                                          "<td class='cellArea'>"+formato.format(sumaHorasExtraProceso)+"</td><td class='cellArea'>"+formato.format(sumaCantidadExtraProceso)+"</td>" +
                                          "<td class='cellArea'>"+formato.format(sumahorasProcesoActividadPersonal)+"</td><td class='cellArea'>&nbsp;</td><td class='cellArea'>"+formato.format(sumahorasProcesoActividadMaquina)+"</td>" +
                                          "<td class='cellArea'>"+formato.format(sumahorasProcesoActividadStandardHombre)+"</td>" +
                                          "<td class='cellArea'>"+formato.format(sumahorasProcesoActividadStandardMaquina)+"</td></tr>");
                              }
                              sumaHorasProceso=0;
                              sumaHorasExtraProceso=0;
                              sumaCantidadExtraProceso=0;
                              sumahorasProcesoActividadMaquina=0;
                              sumahorasProcesoActividadPersonal=0;
                              sumahorasProcesoActividadStandardHombre=0;
                              sumahorasProcesoActividadStandardMaquina=0;
                              codAreaEmpresaProceso=res.getInt("COD_AREA_EMPRESA");
                              nombreActividadCabecera="";
                              sumaCantidadProceso=0;
                          }
                          codCompProd=res.getString("COD_COMPPROD");
                          areaProceso=res.getString("NOMBRE_AREA_EMPRESA");
                          horasPersonal=res.getDouble("HORAS_HOMBRE");
                          cantidadPersonal=res.getDouble("UNIDADES_PRODUCIDAS");
                          horasExtraPersonal=res.getDouble("HORAS_EXTRA");
                          cantidadExtraPersonal=res.getDouble("UNIDADES_PRODUCIDAS_EXTRA");
                          horasHombreActividad=res.getDouble("HORAS_HOMBRE_ACTIVIDAD");
                          nombreMaquina=res.getString("NOMBRE_MAQUINA");
                          horasMaquinaActividad=res.getDouble("HORAS_MAQUINA_ACTIVIDAD");
                          horasHombreStandard=res.getDouble("horHOmbre");
                          horasMaquinaStandard=res.getDouble("horMaq");
                          codLoteProduccion=res.getString("COD_LOTE_PRODUCCION");
                          abreviaturaTipoProduccion=res.getString("ABREVIATURA");
                          nombreProducto=res.getString("nombreProducto");
                          nombreActividad=res.getString("NOMBRE_ACTIVIDAD");
                          sumaLoteHorasPer+=horasPersonal;
                          sumaHorasProceso+=horasPersonal;
                          sumaHorasExtraProceso+=horasExtraPersonal;
                          sumaLoteHorasExtraPer+=horasExtraPersonal;
                          sumaCantidadExtraProceso+=cantidadExtraPersonal;
                          sumaLoteCanExtraPer+=cantidadExtraPersonal;
                          sumaCantidadProceso+=cantidadPersonal;
                          if(!nombreActividad.equals(nombreActividadCabecera))
                          {
                              sumahorasProcesoActividadPersonal+=horasHombreActividad;
                              sumaLoteHorHomAct+=horasHombreActividad;
                              sumahorasProcesoActividadMaquina+=horasMaquinaActividad;
                              sumaLoteHorMaqAct+=horasMaquinaActividad;
                              nombreActividadCabecera=nombreActividad;
                              sumahorasProcesoActividadStandardHombre+=horasHombreStandard;
                              sumaLoteHorHomStand+=horasHombreStandard;
                              sumahorasProcesoActividadStandardMaquina+=horasMaquinaStandard;
                              sumaLoteHorMaqStand+=horasMaquinaStandard;
                          }
                          
                          
                          out.println("<tr><td class='cellNormal'>"+codLoteProduccion+"</td>" +
                                  "<td class='cellNormal'>"+codCompProd+"</td>"+
                                  "<td class='cellNormal'>"+nombreProducto+"</td>"+
                                  "<td class='cellNormal'>"+abreviaturaTipoProduccion+"</td>"+
                                  "<td class='cellNormal'>"+areaProceso+"</td>"+
                                  "<td class='cellNormal'>"+nombreActividad+"</td>"+
                                  "<td class='cellNormal'>"+(res.getTimestamp("FECHA_INICIO")==null?"":format.format(res.getTimestamp("FECHA_INICIO"))+" "+horas.format(res.getTimestamp("FECHA_INICIO")))+"</td>"+
                                  "<td class='cellNormal'>"+(res.getTimestamp("FECHA_FINAL")==null?"":format.format(res.getTimestamp("FECHA_FINAL"))+" "+horas.format(res.getTimestamp("FECHA_FINAL")))+"</td>"+
                                  "<td class='cellNormal'>"+res.getString("nombre")+"</td>"+
                                  "<td class='cellNormal'>"+formato.format(horasPersonal)+"</td>"+
                                  "<td class='cellNormal'>"+entero.format(cantidadPersonal)+"</td>"+
                                  "<td class='cellNormal'>"+(horasPersonal>0?(formato.format((cantidadPersonal/horasPersonal))):0)+"</td>"+
                                  "<td class='cellNormal'>"+formato.format(horasExtraPersonal)+"</td>"+
                                  "<td class='cellNormal'>"+entero.format(cantidadExtraPersonal)+"</td>"+
                                  "<td class='cellNormal'>"+formato.format(horasHombreActividad)+"</td>"+
                                  "<td class='cellNormal'>"+nombreMaquina+"</td>"+
                                  "<td class='cellNormal'>"+formato.format(horasMaquinaActividad)+"</td>"+
                                  "<td class='cellNormal'>"+formato.format(horasHombreStandard)+"</td>"+
                                  "<td class='cellNormal'>"+formato.format(horasMaquinaStandard)+"</td>"+
                                  
                                  
                                  "</tr>");

                      }
                      if(!cabeceraLote.equals(""))
                               {
                                   cantidadEnviadaApt=this.enviadosAPT(codLoteProduccion, codCompProd);
                                   if(codAreaEmpresaProceso==84){sumaCantidadProceso=cantidadEnviadaApt;}
                                    if(codAreaEmpresaProceso==96){sumaCantidadProceso=this.enviadosAcond(codLoteProduccion, codCompProd);}
                                    out.println("<tr><td class='cellArea'>"+codLoteProduccion+"</td><td class='cellArea'>"+codCompProd+"</td><td class='cellArea'>"+nombreProducto+"</td><td class='cellArea'>"+abreviaturaTipoProduccion+"</td><td class='cellArea'>"+areaProceso+"</td>" +
                                          "<td class='cellArea'>&nbsp;</td><td class='cellArea'>&nbsp;</td><td class='cellArea'>&nbsp;</td>" +
                                          "<td class='cellArea'>Sub Total:</td><td class='cellArea'>"+formato.format(sumaHorasProceso)+"</td>" +
                                          "<td class='cellArea'>"+entero.format(sumaCantidadProceso)+"</td><td class='cellArea'>"+formato.format(sumaCantidadProceso/sumaHorasProceso)+"</td>" +
                                          "<td class='cellArea'>"+formato.format(sumaHorasExtraProceso)+"</td><td class='cellArea'>"+formato.format(sumaCantidadExtraProceso)+"</td>" +
                                          "<td class='cellArea'>"+formato.format(sumahorasProcesoActividadPersonal)+"</td><td class='cellArea'>&nbsp;</td><td class='cellArea'>"+formato.format(sumahorasProcesoActividadMaquina)+"</td>" +
                                          "<td class='cellArea'>"+formato.format(sumahorasProcesoActividadStandardHombre)+"</td>" +
                                          "<td class='cellArea'>"+formato.format(sumahorasProcesoActividadStandardMaquina)+"</td></tr>");
                                   out.println("<tr><td class='cellLote'>"+codLoteProduccion+"</td><td class='cellLote'>"+codCompProd+"</td><td class='cellLote'>"+nombreProducto+"</td><td class='cellLote'>"+abreviaturaTipoProduccion+"</td><td class='cellLote'>&nbsp;</td>" +
                                          "<td class='cellLote'>&nbsp;</td><td class='cellLote'>&nbsp;</td><td class='cellLote'>&nbsp;</td>" +
                                          "<td class='cellLote'>Total Lote:</td><td class='cellLote'>"+formato.format(sumaLoteHorasPer)+"</td>" +
                                          "<td class='cellLote'>"+entero.format(cantidadEnviadaApt)+"</td><td class='cellLote'>"+formato.format(cantidadEnviadaApt/sumaLoteHorasPer)+"</td>" +
                                          "<td class='cellLote'>"+formato.format(sumaLoteHorasExtraPer)+"</td><td class='cellLote'>"+formato.format(sumaLoteCanExtraPer)+"</td>" +
                                          "<td class='cellLote'>"+formato.format(sumaLoteHorHomAct)+"</td><td class='cellLote'>&nbsp;</td><td class='cellLote'>"+formato.format(sumaLoteHorMaqAct)+"</td>" +
                                          "<td class='cellLote'>"+formato.format(sumaLoteHorHomStand)+"</td>" +
                                          "<td class='cellLote'>"+formato.format(sumaLoteHorMaqStand)+"</td>"+
                                          "</tr>");
                               }
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
         
            <br>
            <br>
            <div align="center">
            </div>
        </form>
    </body>
</html>