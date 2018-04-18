
<%@page import="javax.faces.context.FacesContext"%>
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

public float enviadosAcond(String codLote,String codCompProd,String codProgramaProd,String codTipoProgramaProd,String codFormulaMaestra){
    float enviadosAcond=0;
    try{
        String consulta = " select sum(i.CANT_INGRESO_PRODUCCION) enviados_acond from PROGRAMA_PRODUCCION ppr inner join " +
                " PROGRAMA_PRODUCCION_INGRESOS_ACOND ppria on ppr.COD_PROGRAMA_PROD = ppria.COD_PROGRAMA_PROD and ppr.COD_LOTE_PRODUCCION = ppria.COD_LOTE_PRODUCCION" +
                " and ppr.COD_COMPPROD = ppria.COD_COMPPROD and ppr.COD_FORMULA_MAESTRA = ppria.COD_FORMULA_MAESTRA" +
                " and ppr.COD_TIPO_PROGRAMA_PROD = ppria.COD_TIPO_PROGRAMA_PROD " +
                " inner join INGRESOS_ACOND ia on ia.COD_INGRESO_ACOND = ppria.COD_INGRESO_ACOND" +
                " inner join INGRESOS_DETALLEACOND i on ia.COD_INGRESO_ACOND = i.COD_INGRESO_ACOND and ppria.COD_LOTE_PRODUCCION = i.COD_LOTE_PRODUCCION and i.COD_COMPPROD = ppria.COD_COMPPROD" +
                " where ppria.COD_LOTE_PRODUCCION = '"+codLote+"' and ppria.COD_PROGRAMA_PROD = '"+codProgramaProd+"' and ppria.COD_COMPPROD = '"+codCompProd+"' and ppria.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and ppria.COD_TIPO_PROGRAMA_PROD = '"+codTipoProgramaProd+"'" +
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
%>
<%! Connection con = null;

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../../js/general.js"></script>
        <style>
            .outputTextNormal{
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 9px;
                font-weight: normal;
            }
        </style>
        
    </head>
    <body>
        <%
        try{
            String tipoReporte=request.getParameter("codTipoReporteDetallado");
            String reporte="Reporte de Tiempos Producción Resumido";
            if(tipoReporte.equals("1"))
                reporte="Reporte de Tiempos Producción Detallado";
            %>
        <form>
            <h4 align="center" class="outputText5"><b><%=reporte%></b></h4>
            

            <br>
            <table width="70%" align="center" class="outputTextNormal" style="border : solid #000000 1px;" cellpadding="0" cellspacing="0" >

                <tr class="">
                    <%
                    if(tipoReporte.equals("1"))
                        {
                    %>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='20%' align="center"><b>Actividad</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='15%' align="center" ><b>Fecha Inicio</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='15%' align="center" ><b>Fecha Final</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='15%' align="center" ><b>Operario</b></td>
                    <%}
                    else
                        {%>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='10%' align="center"><b>Lote</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='15%' align="center" ><b>Programa de Producción</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='15%' align="center" ><b>Producto</b></td>

                    <%
                    }
                    %>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center"><b>Horas Hombre Personal</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Cantidad Producida Personal</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center"><b>Productividad Personal</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center"><b>Horas Hombre </b></td>
                    <%if(tipoReporte.equals("1"))
                        {
                        %>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Máquina</b></td>
                    <%
                    }
                    %>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Horas Máquina </b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Standar Horas Hombre </b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Standar Horas Máquina </b></td>


                </tr>
                    <%
                    HttpSession session1= (HttpSession)FacesContext.getCurrentInstance().getExternalContext().getSession(false);
                    System.out.println("session "+session1.getId());
                      NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
                        DecimalFormat formato = (DecimalFormat) numeroformato;
                        formato.applyPattern("####.##;(####.##)");
                        System.out.println("1");
                        String codProgramaProdPeriodo=request.getParameter("codProgramaProduccionPeriodo")==null?"''":request.getParameter("codProgramaProduccionPeriodo");
                        System.out.println("1");
                        String arrayCodCompProd =request.getParameter("codCompProdArray")==null?"''":request.getParameter("codCompProdArray");
                        System.out.println("1");
                        String nombreProgramaProduccionPeriodo = request.getParameter("nombreProgramaProduccionPeriodo")==null?"''":request.getParameter("nombreProgramaProduccionPeriodo");
                        System.out.println("1");
                        arrayCodCompProd = arrayCodCompProd + (arrayCodCompProd.length()==0?"' '":"");
                        String[] valores=arrayCodCompProd.split(",");
                        System.out.println(arrayCodCompProd);
                         /**
                        boolean aux1=true;
                        String codComprod1="";
                        String codLotes="";
                        String codTipProg="";
                        System.out.println("1");
                       
                        for(String aux2:valores)
                        {
                            System.out.println(aux2);
                            if(aux1)
                            {
                                codLotes="'"+aux2.split("/")[0]+"'";
                                codComprod1="'"+aux2.split("/")[1]+"'";
                                codTipProg="'"+aux2.split("/")[2]+"'";
                                aux1=false;
                            }
                            else
                            {
                                codLotes+=",'"+aux2.split("/")[0]+"'";
                                codComprod1+=",'"+aux2.split("/")[1]+"'";
                                codTipProg+=",'"+aux2.split("/")[2]+"'";
                            }
                        }
                        System.out.println("1");
                        */
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


                    //verificar

                    String arrayProgram=request.getParameter("codProgramaProdArray");
                    String arrayNombres=request.getParameter("nombreProgramaProd");
                    String fechaInicio=request.getParameter("desdeFechaP");
                    String fechaFinal=request.getParameter("hastaFechaP");
                    String fechaInicioPer=request.getParameter("desdeFechaPers");
                    String fechaFinalper=request.getParameter("hastaFechaPers");
                    SimpleDateFormat format=new SimpleDateFormat("dd/MM/yyyy");
                    System.out.println("codProd "+arrayProgram);
                    System.out.println("nombreProd "+arrayNombres);
                    System.out.println("fecha inicio "+fechaInicio);
                    System.out.println("fecha final "+fechaFinal);
                    System.out.println("codigo reporte "+tipoReporte);
                    String[] fecha1=fechaInicio.split("/");
                    String[] fecha2=fechaFinal.split("/");
                    String[] fecha3=fechaInicioPer.split("/");
                    String[] fecha4=fechaFinalper.split("/");
                    String fechaInicioFormato=fecha1[2]+"/"+fecha1[1]+"/"+fecha1[0];
                    String fechaFinalFormato=fecha2[2]+"/"+fecha2[1]+"/"+fecha2[0];
                    String fechaInicioFormatoPer=fecha3[2]+"/"+fecha3[1]+"/"+fecha3[0];
                    String fechaFinalFormatoPer=fecha4[2]+"/"+fecha4[1]+"/"+fecha4[0];
                    boolean reportAcond=(request.getParameter("reporteconfechas").equals("1"));
                    boolean reportPers=(request.getParameter("reporteconfechasPer").equals("1"));
                    if(reportPers)
                    {
                        System.out.println("reporte con fechas de ingreso");
                    }
                    try{
                        String consulta="select ISNULL((select cp.nombre_prod_semiterminado from COMPONENTES_PROD cp where cp.COD_COMPPROD=pr.COD_COMPPROD),'')as producto, ";
                                consulta+="ISNULL((select tpr.NOMBRE_TIPO_PROGRAMA_PROD from TIPOS_PROGRAMA_PRODUCCION tpr where tpr.COD_TIPO_PROGRAMA_PROD=pr.COD_TIPO_PROGRAMA_PROD),'') as pProduccion, ";
                                consulta+="(select ppp.NOMBRE_PROGRAMA_PROD from PROGRAMA_PRODUCCION_PERIODO ppp where ppp.COD_PROGRAMA_PROD=pr.COD_PROGRAMA_PROD) as programa, ";
                               consulta+=" pr.COD_COMPPROD,pr.COD_FORMULA_MAESTRA,pr.COD_LOTE_PRODUCCION,pr.COD_LOTE_PRODUCCION,";
                               consulta+="pr.COD_PROGRAMA_PROD,pr.COD_TIPO_PROGRAMA_PROD ";
                               consulta+="from PROGRAMA_PRODUCCION pr  INNER JOIN  COMPONENTES_PROD CPR";
                               consulta+=" ON pr.COD_COMPPROD = CPR.COD_COMPPROD ";
                               /** if(reportAcond)
                                   {
                               consulta+=" inner join PROGRAMA_PRODUCCION_INGRESOS_ACOND pria";
                               consulta+=" on pria.COD_COMPPROD=pr.COD_COMPPROD  and pria.COD_FORMULA_MAESTRA=pr.COD_FORMULA_MAESTRA and pria.COD_LOTE_PRODUCCION=pr.COD_LOTE_PRODUCCION ";
                               consulta+=" and pria.COD_PROGRAMA_PROD=pr.COD_PROGRAMA_PROD and pria.COD_TIPO_PROGRAMA_PROD=pr.COD_TIPO_PROGRAMA_PROD";
                             
                               consulta+=" inner join INGRESOS_ACOND ia on  pria.COD_INGRESO_ACOND=ia.COD_INGRESO_ACOND ";
                               }*/
                               consulta+=" where pr.COD_PROGRAMA_PROD IN ("+arrayProgram+") ";
                               /**
                               consulta+="  and pr.COD_LOTE_PRODUCCION in ("+codLotes+")";
                               consulta+="and cpr.COD_COMPPROD in ("+codComprod1+") and pr.COD_TIPO_PROGRAMA_PROD IN ("+codTipProg+")";
                                */
                               consulta+=" AND pr.COD_LOTE_PRODUCCION +''+ CAST(pr.COD_COMPPROD  AS VARCHAR(20))+''+cast( pr.COD_TIPO_PROGRAMA_PROD as varchar(20)) IN ("+arrayCodCompProd+") ";
                               consulta+="AND CPR.COD_AREA_EMPRESA IN ("+arrayCodAreaEmpresa+")";
                               if(reportAcond)
                                   {
                               consulta+= " and cast(pr.COD_COMPPROD as varchar) + '' +cast(pr.COD_FORMULA_MAESTRA as varchar)+ '' +cast(pr.COD_LOTE_PRODUCCION as varchar)+ '' +cast(pr.COD_PROGRAMA_PROD as varchar)+ '' +cast(pr.COD_TIPO_PROGRAMA_PROD as varchar)";
                               consulta+="in( select cast(pria.COD_COMPPROD as varchar)+ '' +cast(pria.COD_FORMULA_MAESTRA as varchar)+ '' +cast(pria.COD_LOTE_PRODUCCION as varchar)+ '' +cast(pria.COD_PROGRAMA_PROD as varchar)+ '' +cast(pria.COD_TIPO_PROGRAMA_PROD as varchar)";
                               consulta+=" from PROGRAMA_PRODUCCION_INGRESOS_ACOND pria inner join INGRESOS_ACOND ia on ia.COD_INGRESO_ACOND=pria.COD_INGRESO_ACOND where ia.fecha_ingresoacond BETWEEN '"+fechaInicioFormato+" 00:00:00'and '"+fechaFinalFormato+" 23:59:59')";
                               }
                               consulta+="order by pr.COD_LOTE_PRODUCCION asc";
                            con=Util.openConnection(con);
                        System.out.println("consulta cargar datos /n"+consulta);
                        Statement st1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        ResultSet result1=st1.executeQuery(consulta);
                        String codLote="";
                        String codComprod="";
                        String codProgram="";
                        String codTipoProg="";
                        String codFormulaMaestra="";
                        String nombrePrograma="";
                        String nombreProducto="";

                        while(result1.next())
                        {
                            codLote=result1.getString("COD_LOTE_PRODUCCION");
                            codComprod=result1.getString("COD_COMPPROD");
                            codProgram=result1.getString("COD_PROGRAMA_PROD");
                            codTipoProg=result1.getString("COD_TIPO_PROGRAMA_PROD");
                            codFormulaMaestra=result1.getString("COD_FORMULA_MAESTRA");
                            nombreProducto=result1.getString("producto")+"("+result1.getString("pProduccion")+")";
                            nombrePrograma=result1.getString("programa");
                                                                      
                                    /**
                         String consulta2="select ap.NOMBRE_ACTIVIDAD, afm.COD_ACTIVIDAD_FORMULA, s.HORAS_HOMBRE,s.HORAS_MAQUINA,ISNULL(m.NOMBRE_MAQUINA,' ') as NOMBRE_MAQUINA1 ";

                         consulta2+="from SEGUIMIENTO_PROGRAMA_PRODUCCION s left outer join maquinarias m on m.cod_maquina = s.cod_maquina,ACTIVIDADES_FORMULA_MAESTRA afm,ACTIVIDADES_PRODUCCION ap ";
                         consulta2+="ACTIVIDADES_FORMULA_MAESTRA afm,ACTIVIDADES_PRODUCCION ap ";
                         consulta2+="where  s.COD_ACTIVIDAD_PROGRAMA = afm.COD_ACTIVIDAD_FORMULA and ";
                         consulta2+="ap.COD_ACTIVIDAD=afm.COD_ACTIVIDAD";
                         consulta2+="and s.COD_LOTE_PRODUCCION = '"+codLote+"' and s.COD_PROGRAMA_PROD = '"+codProgram+"'";
                         consulta2+="and s.COD_TIPO_PROGRAMA_PROD = '"+codTipoProg+"' and s.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"' and s.COD_COMPPROD = '"+codComprod+"'";
                         consulta2+=" order by afm.ORDEN_ACTIVIDAD asc ";
*/
                         String consulta2="select ap.NOMBRE_ACTIVIDAD, afm.COD_ACTIVIDAD_FORMULA, s.HORAS_HOMBRE,s.HORAS_MAQUINA,ISNULL(m.NOMBRE_MAQUINA,' ') as NOMBRE_MAQUINA1,maf.HORAS_HOMBRE as horHOmbre , maf.HORAS_MAQUINA as horMaq ";

                         consulta2+="from SEGUIMIENTO_PROGRAMA_PRODUCCION s left outer join maquinarias m on m.cod_maquina = s.cod_maquina ";
                         consulta2+="inner join ACTIVIDADES_FORMULA_MAESTRA afm on s.COD_ACTIVIDAD_PROGRAMA = afm.COD_ACTIVIDAD_FORMULA left outer join MAQUINARIA_ACTIVIDADES_FORMULA maf on maf.COD_ACTIVIDAD_FORMULA= afm.COD_ACTIVIDAD_FORMULA and maf.COD_MAQUINA=m.COD_MAQUINA ,ACTIVIDADES_PRODUCCION ap ";
                         consulta2+="where ap.COD_ACTIVIDAD=afm.COD_ACTIVIDAD ";
                         consulta2+="and s.COD_LOTE_PRODUCCION = '"+codLote+"' and s.COD_PROGRAMA_PROD = '"+codProgram+"'";
                         consulta2+="and s.COD_TIPO_PROGRAMA_PROD = '"+codTipoProg+"' and s.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"' and s.COD_COMPPROD = '"+codComprod+"'";
                         if(!codAreaEmpresaAct.equals("0"))
                         consulta2+=" and afm.COD_AREA_EMPRESA in ("+codAreaEmpresaAct+") ";
                         consulta2+=" order by afm.ORDEN_ACTIVIDAD asc ";
                         System.out.println("consulta 2 "+consulta2);
                         Statement st2=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                         ResultSet result2=st2.executeQuery(consulta2);
                         String nombreMaquina="";
                         double horasHombre=0;
                         double horasMaquina=0;
                         String nombreActividad="";
                         String codActividad="";
                         double standarHorasHombre=0;
                         double standarHorasMaquina=0;
                         double sumHorHombre=0;
                         double sumHorMaquina=0;
                         double sumHorHombreStan=0;
                         double sumHorMaquinaStan=0;
                         double sumHorHombrePer=0;
                         double sumUnidPer=0;


                         while(result2.next())
                         {
                             horasHombre=result2.getDouble("HORAS_HOMBRE");
                             horasMaquina=result2.getDouble("HORAS_MAQUINA");
                             nombreMaquina=result2.getString("NOMBRE_MAQUINA1");
                             nombreActividad=result2.getString("NOMBRE_ACTIVIDAD");
                             standarHorasHombre=result2.getDouble("horHOmbre");
                             standarHorasMaquina=result2.getDouble("horMaq");
                             codActividad=result2.getString("COD_ACTIVIDAD_FORMULA");
                            
                             String consulta3="select spp.FECHA_INICIO,spp.FECHA_FINAL, p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRE_PILA,spp.HORAS_HOMBRE,spp.UNIDADES_PRODUCIDAS ";
                             consulta3+=" from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL spp,PERSONAL p ";
                             consulta3+=" where spp.COD_PERSONAL=p.COD_PERSONAL and spp.COD_ACTIVIDAD_PROGRAMA='"+codActividad+"'";
                             consulta3+=" and spp.COD_COMPPROD = '"+codComprod+"' and spp.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'";
                             consulta3+=" and  spp.COD_LOTE_PRODUCCION='"+codLote+"'and spp.COD_PROGRAMA_PROD='"+codProgram+"'";
                             consulta3+=" and spp.COD_TIPO_PROGRAMA_PROD='"+codTipoProg+"'";
                             if(reportPers)
                             {
                                 consulta3+=" and spp.FECHA_INICIO BETWEEN '"+fechaInicioFormatoPer+" 00:00:00' and '"+fechaFinalFormatoPer+" 23:59:59'";
                                 consulta3+=" and spp.FECHA_FINAL BETWEEN '"+fechaInicioFormatoPer+" 00:00:00' and '"+fechaFinalFormatoPer+" 23:59:59'";
                             }
                             System.out.println("consulta3 "+consulta3);
                             Statement st3=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                             ResultSet result3=st3.executeQuery(consulta3);
                             String nombrePersonal="";
                             double horaspersonal=0;
                             double unidadesprod=0;
                             double productividad=0;
                             String fechaInicio1="";
                             String fechaFinal1="";
                             int filas=1;
                                if(result3.last())
                               filas=result3.getRow();
                             result3.absolute(0);
                               System.out.println("cantidad  "+filas);
                               if(!reportPers||result3.first())
                                   {
                                   result3.absolute(0);
                                    sumHorHombre+=horasHombre;
                                    sumHorMaquina+=horasMaquina;
                                     sumHorHombreStan+=standarHorasHombre;
                                    sumHorMaquinaStan+=standarHorasMaquina;
                                    if(tipoReporte.equals("1"))
                                        {
                                    %>
                                    <tr class="outputTextNormal">
                                        <th rowspan="<%=filas%>" class="outputTextNormal" style="border : solid #D8D8D8 1px"><%=nombreActividad%></th>
                                    
                                            <%
                                            }
                                            if(result3.next())
                                            {
                                                if(result3.getString("FECHA_INICIO")!=null)
                                                {
                                                    fechaInicio1=format.format(result3.getDate("FECHA_INICIO"));
                                                }
                                                else
                                                    fechaInicio1="";
                                                if(result3.getString("FECHA_FINAL")!=null)
                                                {
                                                    fechaFinal1=format.format(result3.getDate("FECHA_FINAL"));
                                                }
                                                else
                                                    fechaFinal1="";


                                                nombrePersonal=result3.getString("AP_PATERNO_PERSONAL")+" "+result3.getString("AP_MATERNO_PERSONAL")+" "+result3.getString("NOMBRE_PILA");
                                                horaspersonal=result3.getDouble("HORAS_HOMBRE");
                                                unidadesprod=result3.getDouble("UNIDADES_PRODUCIDAS");
                                                productividad=(horaspersonal!=0?(unidadesprod/horaspersonal):0);
                                                sumHorHombrePer+=horaspersonal;
                                                sumUnidPer+=unidadesprod;
                                              
                                                if(tipoReporte.equals("1"))
                                                 {

                                                %>
                                                    <th class="outputTextNormal" style="border : solid #D8D8D8 1px"><%=fechaInicio1%>&nbsp;</th>
                                                    <th class="outputTextNormal" style="border : solid #D8D8D8 1px"><%=fechaFinal1%>&nbsp;</th>
                                                    <th class="outputTextNormal" style="width:2200px; border : solid #D8D8D8 1px"><div><%=nombrePersonal%></div></th>
                                                    <th class="outputTextNormal" style="border : solid #D8D8D8 1px"><%=horaspersonal%></th>
                                                     <th class="outputTextNormal" style="border : solid #D8D8D8 1px"><%=unidadesprod%></th>
                                                      <th class="outputTextNormal" style="border : solid #D8D8D8 1px"><%=formato.format(productividad)%></th>
                                                <%
                                                }
                                            }
                                               else
                                                   {
                                                   if(tipoReporte.equals("1"))
                                                 {
                                                  %>
                                                  <th style="border : solid #D8D8D8 1px">&nbsp;  </th><th style="border : solid #D8D8D8 1px">&nbsp;</th>
                                                    <th style="border : solid #D8D8D8 1px"> &nbsp; </th><th style="border : solid #D8D8D8 1px">&nbsp;</th>
                                                  <th style="border : solid #D8D8D8 1px">&nbsp;</th>
                                                  <th style="border : solid #D8D8D8 1px">&nbsp;</th>
                                                  <%
                                                  }
                                               }
                                               if(tipoReporte.equals("1"))
                                                 {
                                            %>
                                              
                                               <th rowspan="<%=filas%>" class="outputTextNormal" style="border : solid #D8D8D8 1px"><%=formato.format(horasHombre)%></th>
                                                 <th rowspan="<%=filas%>" class="outputTextNormal" style="border : solid #D8D8D8 1px"><%=nombreMaquina%>&nbsp;</th>
                                                   <th rowspan="<%=filas%>" class="outputTextNormal" style="border : solid #D8D8D8 1px"><%=formato.format(horasMaquina)%></th>
                                                   <th rowspan="<%=filas%>" class="outputTextNormal" style="border : solid #D8D8D8 1px"><%=formato.format(standarHorasHombre)%></th>
                                                   <th rowspan="<%=filas%>" class="outputTextNormal" style="border : solid #D8D8D8 1px"><%=formato.format(standarHorasMaquina)%></th>
                                    
                                        
                                        </tr>
                                        <%
                                                }
                                        while(result3.next())
                                        {
                                              if(result3.getString("FECHA_INICIO")!=null)
                                                {
                                                    fechaInicio1=format.format(result3.getDate("FECHA_INICIO"));
                                                }
                                                else
                                                    fechaInicio1="";
                                                if(result3.getString("FECHA_FINAL")!=null)
                                                {
                                                    fechaFinal1=format.format(result3.getDate("FECHA_FINAL"));
                                                }
                                                else
                                                    fechaFinal1="";
                                             nombrePersonal=result3.getString("AP_PATERNO_PERSONAL")+" "+result3.getString("AP_MATERNO_PERSONAL")+" "+result3.getString("NOMBRE_PILA");
                                             horaspersonal=result3.getDouble("HORAS_HOMBRE");
                                             unidadesprod=result3.getDouble("UNIDADES_PRODUCIDAS");
                                             productividad=(horaspersonal!=0?(unidadesprod/horaspersonal):0);
                                              sumHorHombrePer+=horaspersonal;
                                                sumUnidPer+=unidadesprod;
                                                if(tipoReporte.equals("1"))
                                                 {
                                            %>
                                             <tr>
                                               <th class="outputTextNormal" style="border : solid #D8D8D8 1px"><%=fechaInicio1%>&nbsp;</th>
                                                    <th class="outputTextNormal" style="border : solid #D8D8D8 1px"><%=fechaFinal1%>&nbsp;</th>
                                             <th class="outputTextNormal" style="border : solid #D8D8D8 1px"><%=nombrePersonal%></th>
                                               <th class="outputTextNormal" style="border : solid #D8D8D8 1px"><%=horaspersonal%></th>
                                                     <th class="outputTextNormal" style="border : solid #D8D8D8 1px"><%=unidadesprod%></th>
                                                      <th class="outputTextNormal" style="border : solid #D8D8D8 1px"> ddd<%=formato.format(productividad)%></th>
                                                    
                                             
                                             </tr>



                                            <%
                                            }
                                        }
                                        %>
                                    <%
                                    }

                         }
                         result2.close();
                         st2.close();

                         double prod=0;
                         if(sumHorHombrePer>0)
                             prod=sumUnidPer/sumHorHombrePer;

                          %>
                         <tr>
                             

                              <th class="outputTextNormal" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" colspan="1"><b> <%=codLote%></b></th>
                               <th class="outputTextNormal" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" colspan="1"><b><%=nombrePrograma%></b></th>
                                <th class="outputTextNormal" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" colspan="1"><b><%=nombreProducto%></b></th>
                                <%
                             if(tipoReporte.equals("1"))
                                                 {

                             %>
                            <th class="outputTextNormal" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" colspan="1"><b>Subtotal</b></th>
                          <%
                             }
                         %>
                           <th class="outputTextNormal" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" ><b><%=formato.format(sumHorHombrePer)%></b></th>
                           <th class="outputTextNormal" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" ><b><%=formato.format(this.enviadosAcond(codLote, codComprod, codProgramaProdPeriodo, codTipoProg,codFormulaMaestra))%></b></th>
                           <th class="outputTextNormal" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2"><b><%=formato.format(prod)%></b></th>
                           <th class="outputTextNormal" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" ><b><%=formato.format(sumHorHombre)%></b></th>
                            <%
                            if(tipoReporte.equals("1"))
                                                 {
                            %>
                           <th class="outputTextNormal" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" ></th>
                           <%
                           }
                           %>
                           <th class="outputTextNormal" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" ><b><%=formato.format(sumHorMaquina)%></b></th>
                           <th class="outputTextNormal" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" ><b><%=formato.format(sumHorHombreStan)%></b></th>
                           <th class="outputTextNormal" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2"><b><%=formato.format(sumHorMaquinaStan)%></b></th>




                         </tr>

                         <%

                        }
                        result1.close();
                        st1.close();
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
                <%--<INPUT type="button" class="commandButton" name="btn_registrar" value="<-- Atrás" onClick="cancelar();"  >--%>

            </div>
        </form>
    </body>
</html>