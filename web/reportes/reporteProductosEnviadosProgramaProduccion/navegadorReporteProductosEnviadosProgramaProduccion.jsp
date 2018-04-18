
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
<%@ page errorPage="ExceptionHandler.jsp" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        
        <%--meta http-equiv="Content-Type" content="text/html; charset=UTF-8"--%>
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../../js/general.js"></script>
        <style>
            
        </style>
    </head>
    <body>
        <h3 align="center">Reporte de Productos Enviados a Acondicionamiento</h3>
        <br>
        <form>
            <table align="center" width="90%">

                <%
                try{
                    Connection con=null;
                    //formato numero
                    NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                    DecimalFormat format = (DecimalFormat)nf;
                    format.applyPattern("#,###.00");
                    //datos del filtro
                    int codComprod=Integer.valueOf(request.getParameter("codCompProd"));
                    String loteFiltro=request.getParameter("nroLote");
                    String codProgramaProdPeriodo=request.getParameter("codProgramaProdPeriodo")==null?"0":request.getParameter("codProgramaProdPeriodo");
                    String nombreProgramaProdPeriodo=request.getParameter("nombreProgramaProduccion")==null?"0":request.getParameter("nombreProgramaProduccion");
                    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                    String fechaInicial=request.getParameter("fechaInicial")==null?"0":request.getParameter("fechaInicial");
                    String fechaFinal=request.getParameter("fechaFinal")==null?"0":request.getParameter("fechaFinal");
                    
                    String[] arrayFechaInicial = fechaInicial.split("/");
                    String[] arrayFechaFinal = fechaFinal.split("/");
                    String codEstadoProd=request.getParameter("codEstadoProd");
                    
                %>
                <table align="center" width="60%" class='outputText0'>
                <tr>
                    <td width="20%" rowspan="3">
                        <img src="../../img/cofar.png">
                    </td>
                    <td>
                        <span class="outputTextBold">Programa Produccion :</span>
                    <span class="outputText2"><%=nombreProgramaProdPeriodo%></span>
                    </td>
                </tr>
                <tr>
                    <td>
                        <span class="outputTextBold">Fecha Inicial:</span>
                        <span class="outputText2"><%=fechaInicial%></span>
                    </td>
                </tr>
                <tr>
                    <td>
                        <span class="outputTextBold">Fecha Inicial:</span>
                        <span class="outputText2"><%=fechaFinal%></span>
                    </td>
                </tr>
                

            </table>
            </table>
            <br>
            <br>
            <br>
            <table  align="center" width="60%" class="tablaReporte"cellpadding="0" cellspacing="0">
                <thead>
                    <tr >
                        <td width="20%" ><b>Programa Produccion</b></td>
                        <td width="20%" ><b>Producto</b></td>
                        <td width="20%" ><b>Codigo Producto</b></td>
                        <td width="20%" ><b>Tipo Programa</b></td>
                        <td><b>Lote</b></td>
                        <td><b>Cantidad Lote</b></td>

                        <td width="5%"><b>Nro de ingreso Acond.</b></td>
                        <td><b>Cantidad Ingreso Acond.</b></td>
                        <td><b>Hrs. Hombre</b></td>
                        <td><b>Productividad</b></td>
                        <td width="10%"><b>Rendimiento de Produccion</b></td>


                        <td width="10%"><b>Fecha de Ingreso Acond.</b></td>
                        <td width="10%"><b>Fecha Confirmada<br> de Ingreso Acond.</b></td>
                        <td width="10%"><b>Estados<br>Ingreso<br>Acond.</b></td>
                        <td ><b>Almacen Acondicionamiento</b></td>
                        <td ><b>Area</b></td>
                        <td ><b>Fecha Pesaje</b></td>
                        <td ><b>Vida Util</b></td>
                        <td ><b>Fecha Vencimiento</b></td>
                        <td ><b>Entrega</b></td>
                        <td ><b>Observación</b></td>
                        <td ><b>Estado Certificado CC.</b></td>
                    </tr>
                </thead>
                <%
                String consulta ="SELECT ppria.COD_COMPPROD,pprp.NOMBRE_PROGRAMA_PROD,ppr.COD_PROGRAMA_PROD,CPV.nombre_prod_semiterminado,IDA.COD_LOTE_PRODUCCION,"+
                                    " IA.NRO_INGRESOACOND,IDA.CANT_INGRESO_PRODUCCION,IA.fecha_ingresoacond,A.NOMBRE_ALMACENACOND,fm.cantidad_lote,AE.NOMBRE_AREA_EMPRESA,"+
                                    " cpV.VIDA_UTIL,IDA.FECHA_VEN,datosPesaje.fechaPesaje as  FECHA_PESAJE,"+
                                      " t.nombre_tipo_entrega_acond,datosTiempo.horasHombre as horas_hombre,"+
                                      " ia.OBS_INGRESOACOND, ppr.CANT_LOTE_PRODUCCION ,tpp.NOMBRE_TIPO_PROGRAMA_PROD ,ppria.COD_TIPO_PROGRAMA_PROD" +
                                      " ,ia.FECHA_INGRESOACOND_CONFIRMADO,ei.NOMBRE_ESTADO_INGRESOACOND,cpv.COD_FORMA"+
                                        ",isnull(datosCC.NOMBRE_ESTADO_RESULTADO_ANALISIS,'No Registrado') as estadoCC"+
                                " FROM PROGRAMA_PRODUCCION_INGRESOS_ACOND ppria inner join PROGRAMA_PRODUCCION ppr on ppr.COD_PROGRAMA_PROD ="+
                                      " ppria.COD_PROGRAMA_PROD and ppr.COD_COMPPROD = ppria.COD_COMPPROD" +
                                      " and ppr.COD_FORMULA_MAESTRA = ppria.COD_FORMULA_MAESTRA and ppr.COD_LOTE_PRODUCCION = ppria.COD_LOTE_PRODUCCION" +
                                      " and ppria.cod_tipo_programa_prod = ppr.cod_tipo_programa_prod"+
                                      " inner join INGRESOS_ACOND IA on ia.COD_INGRESO_ACOND =ppria.COD_INGRESO_ACOND" +
                                      " left outer join ESTADOS_INGRESOSACOND ei on ei.COD_ESTADO_INGRESOACOND=ia.COD_ESTADO_INGRESOACOND"+
                                      " INNER JOIN INGRESOS_DETALLEACOND IDA ON IA.COD_INGRESO_ACOND =IDA.COD_INGRESO_ACOND"+
                                      " INNER JOIN COMPONENTES_PROD_VERSION cpv ON cpv.COD_COMPPROD = IDA.COD_COMPPROD and cpv.COD_VERSION=ppr.COD_COMPPROD_VERSION"+
                                      " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=ppr.COD_TIPO_PROGRAMA_PROD"+
                                      " INNER JOIN ALMACENES_ACOND A ON A.COD_ALMACENACOND = IA.COD_ALMACENACOND"+
                                      " INNER JOIN FORMULA_MAESTRA_VERSION FM ON FM.COD_COMPPROD = CPv.COD_COMPPROD" +
                                      " and fm.cod_formula_maestra = ppr.cod_formula_maestra" +
                                      " AND FM.COD_VERSION=PPR.COD_FORMULA_MAESTRA_VERSION"+
                                      " INNER JOIN AREAS_EMPRESA AE ON AE.COD_AREA_EMPRESA = CPV.COD_AREA_EMPRESA"+
                                      " inner join PROGRAMA_PRODUCCION_PERIODO pprp on pprp.COD_PROGRAMA_PROD =ppr.COD_PROGRAMA_PROD"+
                                      " left outer join tipos_entrega_acond t on t.cod_tipo_entrega_acond =ppria.cod_tipo_entrega_acond"+
                                      " outer apply("+
                                            " SELECT top 1 era.NOMBRE_ESTADO_RESULTADO_ANALISIS"+
                                                " from RESULTADO_ANALISIS ra "+
                                                        " inner join PROGRAMA_PRODUCCION pp on pp.COD_LOTE_PRODUCCION=ra.COD_LOTE"+
                                                        " and ra.COD_COMPROD=pp.COD_COMPPROD"+
                                                    " inner join COMPONENTES_PROD_VERSION cpv1 on cpv1.COD_COMPPROD=pp.COD_COMPPROD"+
                                                        " and cpv1.COD_VERSION=pp.COD_COMPPROD_VERSION"+
                                                    " inner join ESTADOS_RESULTADO_ANALISIS era on era.COD_ESTADO_RESULTADO_ANALISIS=ra.COD_ESTADO_RESULTADO_ANALISIS"+
                                                " where ra.COD_LOTE=ppria.COD_LOTE_PRODUCCION"+
                                                        " and	cpv1.COD_PROD=cpv.COD_PROD"+
                                        " ) as datosCC"+
                                        " left join("+
                                                " select spp.COD_LOTE_PRODUCCION,spp.COD_PROGRAMA_PROD,spp.COD_TIPO_PROGRAMA_PROD,spp.COD_COMPPROD,"+
                                                         " sum(spp.HORAS_HOMBRE) as horasHombre"+
                                                " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL spp"+
                                                     " inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_FORMULA_MAESTRA = spp.COD_FORMULA_MAESTRA "+
                                                         " and afm.COD_ACTIVIDAD_FORMULA=spp.COD_ACTIVIDAD_PROGRAMA"+
                                                         " and afm.COD_AREA_EMPRESA in (80, 81, 82, 95, 96)"+
                                                " group by spp.COD_LOTE_PRODUCCION,"+
                                                         " spp.COD_PROGRAMA_PROD,spp.COD_TIPO_PROGRAMA_PROD,spp.COD_COMPPROD"+
                                          " ) datosTiempo on datosTiempo.COD_PROGRAMA_PROD =ppr.COD_PROGRAMA_PROD"+
                                                     " and datosTiempo.COD_LOTE_PRODUCCION=ppr.COD_LOTE_PRODUCCION "+
                                                     " and datosTiempo.COD_TIPO_PROGRAMA_PROD=ppr.COD_TIPO_PROGRAMA_PROD"+
                                                     " and datosTiempo.COD_COMPPROD=ppr.COD_COMPPROD"+
                                          " left join ("+
                                                  " select max(s.FECHA_INICIO) as fechaPesaje,s.COD_LOTE_PRODUCCION"+
                                                  " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s"+
                                                       " inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA = s.COD_ACTIVIDAD_PROGRAMA"+
                                                               " and afm.COD_AREA_EMPRESA = 97"+
                                                  " where afm.COD_ACTIVIDAD in (76, 186)"+
                                                       " and s.horas_hombre > 0"+
                                                  " group by s.COD_LOTE_PRODUCCION"+
                                            " ) as datosPesaje on datosPesaje.COD_LOTE_PRODUCCION = ppr.COD_LOTE_PRODUCCION"+
                                 " WHERE IA.COD_ESTADO_INGRESOACOND IN (1, 4)" +
                                 " AND IA.COD_TIPOINGRESOACOND = 1 "+
                                (codComprod>0?" and cpv.COD_COMPPROD='"+codComprod+"'":"")+
                                (loteFiltro.equals("")?"":" and ppr.COD_LOTE_PRODUCCION='"+loteFiltro+"'")+
                                (codEstadoProd.equals("-1")?"":" and CP.COD_ESTADO_COMPPROD='"+codEstadoProd+"'");
                  if(!codProgramaProdPeriodo.equals("-1")){
                             consulta = consulta + " and pprp.cod_programa_prod = '"+codProgramaProdPeriodo+"' " ;
                         }
                  consulta = consulta + " AND IA.fecha_ingresoacond between '"+arrayFechaInicial[2]+"/" +arrayFechaInicial[1] + "/" + arrayFechaInicial[0]+" 00:00:00' " +
                                " AND '"+arrayFechaFinal[2]+"/" +arrayFechaFinal[1] + "/" + arrayFechaFinal[0]+" 23:59:59'" ;

                System.out.println("consulta rendimiento "+consulta);
                con = Util.openConnection(con);                            
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs=st.executeQuery(consulta);
                SimpleDateFormat sdfDias=new SimpleDateFormat("dd/MM/yyyy");
                SimpleDateFormat sdfHoras=new SimpleDateFormat("HH:mm");
                
                while (rs.next())
                {
                     StringBuilder consulta1=new StringBuilder(" exec PAA_LISTAR_FECHA_VENCIMIENTO_LOTE ")
                                                        .append("'").append(rs.getString("COD_LOTE_PRODUCCION")).append("',")//lote
                                                        .append(rs.getInt("COD_PROGRAMA_PROD")).append(",")//programa
                                                        .append(rs.getInt("cod_compprod")).append(",")//producto
                                                        .append(rs.getInt("COD_FORMA")).append(",")//forma farmaceutica
                                                        .append("?,")//mensaje
                                                        .append("?,")//fecha vencimiento
                                                        .append("?");//fecha pesaje
                    CallableStatement callFechaVencimiento=con.prepareCall(consulta1.toString());
                    callFechaVencimiento.registerOutParameter(1,java.sql.Types.VARCHAR);
                    callFechaVencimiento.registerOutParameter(2,java.sql.Types.TIMESTAMP);
                    callFechaVencimiento.registerOutParameter(3,java.sql.Types.TIMESTAMP);
                    callFechaVencimiento.execute();
                    Date fechaVencimiento = callFechaVencimiento.getTimestamp(2);
                    
                    String nombreProgramaProd = rs.getString("nombre_programa_prod");
                    String nombreProdSemiterminado = rs.getString("nombre_prod_semiterminado");
                    String codLoteProduccion= rs.getString("COD_LOTE_PRODUCCION");
                    String nroIngresoAcond = rs.getString("NRO_INGRESOACOND");
                    float cantIngresoProduccion = rs.getFloat("CANT_INGRESO_PRODUCCION");
                    String fechaIngresoAcond=rs.getString("fecha_ingresoacond");
                    String almacenAcond = rs.getString("NOMBRE_ALMACENACOND");
                    String[] arrayFechaIngresoAcond = fechaIngresoAcond.split(" ");
                    fechaIngresoAcond= arrayFechaIngresoAcond[0];
                    arrayFechaIngresoAcond = fechaIngresoAcond.split("-");
                    float cantidadLote = rs.getFloat("CANT_LOTE_PRODUCCION");
                    String nombreAreaEmpresa= rs.getString("NOMBRE_AREA_EMPRESA");
                    Date fechaPesaje = rs.getDate("FECHA_PESAJE");
                    String vidaUtil = rs.getString("VIDA_UTIL");
                    String nombreTipoEntregaAcond = rs.getString("nombre_tipo_entrega_acond");
                    float horasHombre = rs.getFloat("horas_hombre");




                    out.print("<tr>");
                    out.print("<td  align='left'>"+nombreProgramaProd+"</td>");
                    out.print("<td  align='left'>"+nombreProdSemiterminado+"</td>");
                    out.print("<td  align='left'>"+rs.getString("COD_COMPPROD")+"</td>");
                    out.print("<td  align='left'>"+rs.getString("NOMBRE_TIPO_PROGRAMA_PROD")+"</td>");
                    out.print("<td  align='left'>"+codLoteProduccion+"</td>");
                    out.print("<td  align='left'>"+format.format(cantidadLote)+"</td>");
                    out.print("<td  align='left'>"+nroIngresoAcond+"</td>");
                    out.print("<td  align='left'>"+format.format(cantIngresoProduccion) +"</td>");
                    out.print("<td  align='left'>"+format.format(horasHombre) +"</td>");
                    out.print("<td  align='left'>"+ (horasHombre==0?0:format.format(cantIngresoProduccion/horasHombre)) +"</td>");
                    out.print("<td  align='left'>"+format.format((cantIngresoProduccion/cantidadLote)*100) +"%</td>");
                    out.print("<td  align='left'>"+sdfDias.format(rs.getTimestamp("fecha_ingresoacond"))+"<br>"+sdfHoras.format(rs.getTimestamp("fecha_ingresoacond"))+"</td>");
                    out.print("<td  align='left'>"+(rs.getTimestamp("FECHA_INGRESOACOND_CONFIRMADO")!=null?(sdfDias.format(rs.getTimestamp("FECHA_INGRESOACOND_CONFIRMADO"))+"<br>"+sdfHoras.format(rs.getTimestamp("FECHA_INGRESOACOND_CONFIRMADO"))):"&nbsp;")+"</td>");
                    out.println("<td>"+rs.getString("NOMBRE_ESTADO_INGRESOACOND")+"</td>");
                    out.print("<td  align='left'>"+almacenAcond+"</td>");
                    out.print("<td  align='left'>"+nombreAreaEmpresa+"</td>");
                    out.print("<td  align='left'>"+(fechaPesaje==null?"":sdf.format( fechaPesaje))+"</td>");
                    out.print("<td  align='left'>"+(vidaUtil==null?"":vidaUtil)+"</td>");
                    out.print("<td  align='left'>"+(fechaVencimiento==null?"":sdf.format(fechaVencimiento))+"</td>");
                    out.print("<td  align='left'>"+(nombreTipoEntregaAcond==null?"":nombreTipoEntregaAcond)+"</td>");
		    out.print("<td  align='left'>"+rs.getString("OBS_INGRESOACOND")+"&nbsp;</td>");
                    out.print("<td  align='left'>"+rs.getString("estadoCC")+"&nbsp;</td>");
                    out.print("</tr>");
                    }
                rs.close();
                st.close();
                consulta = " select ae.NOMBRE_AREA_EMPRESA,count(ppria.COD_INGRESO_ACOND) envios,sum(ida.cant_ingreso_produccion) unidades_enviadas" +
                        " from PROGRAMA_PRODUCCION_INGRESOS_ACOND ppria inner join PROGRAMA_PRODUCCION ppr on ppr.COD_PROGRAMA_PROD = ppria.COD_PROGRAMA_PROD" +
                        " and ppr.COD_LOTE_PRODUCCION = ppria.COD_LOTE_PRODUCCION and ppr.COD_COMPPROD = ppria.COD_COMPPROD and ppr.COD_FORMULA_MAESTRA = ppria.COD_FORMULA_MAESTRA" +
                        " and ppr.COD_TIPO_PROGRAMA_PROD = ppria.COD_TIPO_PROGRAMA_PROD inner join PROGRAMA_PRODUCCION_PERIODO pprp on pprp.COD_PROGRAMA_PROD = ppr.COD_PROGRAMA_PROD inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = ppr.COD_COMPPROD inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA = cp.COD_AREA_EMPRESA" +
                        " INNER JOIN INGRESOS_ACOND IA ON IA.COD_INGRESO_ACOND = PPRIA.COD_INGRESO_ACOND" +
                        " inner join ingresos_detalleacond ida on ida.cod_ingreso_acond = ia.cod_ingreso_acond and ida.cod_lote_produccion = ppria.cod_lote_produccion and ida.cod_compprod = ppria.cod_compprod " +
                        " inner join FORMULA_MAESTRA fm on fm.COD_COMPPROD = ppr.COD_COMPPROD and fm.COD_FORMULA_MAESTRA = ppr.COD_FORMULA_MAESTRA" +
                        " WHERE IA.COD_ESTADO_INGRESOACOND IN (1, 4) AND" +
                        " IA.COD_TIPOINGRESOACOND = 1 " +(codEstadoProd.equals("-1")?"":" and cp.COD_ESTADO_COMPPROD='"+codEstadoProd+"' ")+ //+(codEstadoFormula.equals("3")?"":" and fm.COD_ESTADO_REGISTRO ='"+codEstadoFormula+"'");
                        (codComprod>0?" and cp.COD_COMPPROD='"+codComprod+"'":"")+
                        (loteFiltro.equals("")?"":" and ppr.COD_LOTE_PRODUCCION='"+loteFiltro+"'");
                    if(!codProgramaProdPeriodo.equals("-1")){
                             consulta = consulta + " and pprp.cod_programa_prod = '"+codProgramaProdPeriodo+"' " ;
                         }
                  consulta = consulta + " AND IA.fecha_ingresoacond >='"+arrayFechaInicial[2]+"/" +arrayFechaInicial[1] + "/" + arrayFechaInicial[0]+" 00:00:00' " +
                                " AND IA.fecha_ingresoacond<='"+arrayFechaFinal[2]+"/" +arrayFechaFinal[1] + "/" + arrayFechaFinal[0]+" 23:59:59' group by ae.NOMBRE_AREA_EMPRESA " ;
                  System.out.println("consulta " + consulta);
                  Statement st1 = con.createStatement();
                  ResultSet rs1 = st1.executeQuery(consulta);
                  %>
            </table>
            <br>
                  <table  align="center" width="60%" class="tablaReporte" cellpadding="0" cellspacing="0">
                      <thead>
                          <tr><td colspan="3" align="center">Resumen de envios</td></tr>
                            <tr >
                                <td   width="20%" ><b>Area</b></td>
                                <td   width="20%" ><b>Cantidad de Envios</b></td>
                                <td   width="20%" ><b>Unidades Enviadas</b></td>
                            </tr>
                    </thead>
                  <%
                  while(rs1.next()){
                      out.print("<tr>");
                      out.print("<td  align='left'>"+rs1.getString("nombre_area_empresa")+"</td>");
                      out.print("<td  align='left'>"+rs1.getDouble("envios")+"</td>");
                      out.print("<td  align='left'>"+rs1.getDouble("unidades_enviadas")+"</td>");
                      out.print("</tr>");
                  }
                  %>
                  </table>
                  <%
                  rs1.close();
                  st1.close();
                  con.close();

                }catch(Exception e){
                e.printStackTrace();
                }
                %>           
            
        </form>
    </body>
</html>