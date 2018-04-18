

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

public float enviadosAcond(String codLote,String codCompProd){
    float enviadosAcond=0;
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
            enviadosAcond = rs.getFloat("cantidadEnviadaAPT");
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
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
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
            
            %>
        <form>
            <h4 align="center" class="outputText5"><b>Reporte de Tiempos Producción Resumido</b></h4>
            

            <br>
            <table width="70%" align="center" class="outputTextNormal" style="border : solid #000000 1px;" cellpadding="0" cellspacing="0" >

                <tr class="">
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='10%' align="center"><b>Lote</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='15%' align="center" ><b>Programa de Producción</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='15%' align="center" ><b>Producto</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center"><b>Horas Hombre Personal</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Cantidad Producida Personal</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center"><b>Productividad Personal</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center"><b>Horas Extra Personal</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Cantidad Producida Extra Personal</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center"><b>Horas Hombre </b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Horas Máquina </b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Standar Horas Hombre </b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Standar Horas Máquina </b></td>


                </tr>
                    <%
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
                    double unidadesExtra=0d;
                    double horasExtra=0d;
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
                              consulta2+=",(select Sum(spp.HORAS_HOMBRE) ";
                             consulta2+=" from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL spp ";
                             consulta2+=" where spp.COD_ACTIVIDAD_PROGRAMA=afm.COD_ACTIVIDAD_FORMULA and  spp.COD_COMPPROD = '"+codComprod+"' and spp.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'";
                             consulta2+=" and  spp.COD_LOTE_PRODUCCION='"+codLote+"'and spp.COD_PROGRAMA_PROD='"+codProgram+"'";
                             consulta2+=" and spp.COD_TIPO_PROGRAMA_PROD='"+codTipoProg+"'";
                              if(reportPers)
                             {
                                 consulta2+=" and spp.FECHA_INICIO BETWEEN '"+fechaInicioFormatoPer+" 00:00:00' and '"+fechaFinalFormatoPer+" 23:59:59'";
                                 consulta2+=" and spp.FECHA_FINAL BETWEEN '"+fechaInicioFormatoPer+" 00:00:00' and '"+fechaFinalFormatoPer+" 23:59:59'";
                             }
                         consulta2+=") as sumaHora from SEGUIMIENTO_PROGRAMA_PRODUCCION s left outer join maquinarias m on m.cod_maquina = s.cod_maquina ";
                         consulta2+="inner join ACTIVIDADES_FORMULA_MAESTRA afm on s.COD_ACTIVIDAD_PROGRAMA = afm.COD_ACTIVIDAD_FORMULA left outer join MAQUINARIA_ACTIVIDADES_FORMULA maf on maf.COD_ACTIVIDAD_FORMULA= afm.COD_ACTIVIDAD_FORMULA and maf.COD_MAQUINA=m.COD_MAQUINA ,ACTIVIDADES_PRODUCCION ap ";
                         consulta2+="where ap.COD_ACTIVIDAD=afm.COD_ACTIVIDAD ";
                         consulta2+="and s.COD_LOTE_PRODUCCION = '"+codLote+"' and s.COD_PROGRAMA_PROD = '"+codProgram+"'";
                         consulta2+="and s.COD_TIPO_PROGRAMA_PROD = '"+codTipoProg+"' and s.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"' and s.COD_COMPPROD = '"+codComprod+"'";
                         if(!codAreaEmpresaAct.equals("0"))
                         consulta2+=" and afm.COD_AREA_EMPRESA in ("+codAreaEmpresaAct+") ";
                         consulta2+=" and afm.COD_ACTIVIDAD_FORMULA in (select spp.COD_ACTIVIDAD_PROGRAMA ";
                             consulta2+=" from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL spp ";
                             consulta2+=" where spp.COD_COMPPROD = '"+codComprod+"' and spp.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'";
                             consulta2+=" and  spp.COD_LOTE_PRODUCCION='"+codLote+"'and spp.COD_PROGRAMA_PROD='"+codProgram+"'";
                             consulta2+=" and spp.COD_TIPO_PROGRAMA_PROD='"+codTipoProg+"'";
                              if(reportPers)
                             {
                                 consulta2+=" and spp.FECHA_INICIO BETWEEN '"+fechaInicioFormatoPer+" 00:00:00' and '"+fechaFinalFormatoPer+" 23:59:59'";
                                 consulta2+=" and spp.FECHA_FINAL BETWEEN '"+fechaInicioFormatoPer+" 00:00:00' and '"+fechaFinalFormatoPer+" 23:59:59'";
                             }
                         consulta2+=") order by afm.ORDEN_ACTIVIDAD asc ";
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
                         horasExtra=0d;
                         unidadesExtra=0d;

                         while(result2.next())
                         {
                             horasHombre=result2.getDouble("sumaHora");
                             horasMaquina=result2.getDouble("HORAS_MAQUINA");
                             nombreMaquina=result2.getString("NOMBRE_MAQUINA1");
                             nombreActividad=result2.getString("NOMBRE_ACTIVIDAD");
                             standarHorasHombre=result2.getDouble("horHOmbre");
                             standarHorasMaquina=result2.getDouble("horMaq");
                             codActividad=result2.getString("COD_ACTIVIDAD_FORMULA");
                            
                             String consulta3="select spp.FECHA_INICIO,spp.FECHA_FINAL, p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRE_PILA,spp.HORAS_HOMBRE," +
                                     "spp.UNIDADES_PRODUCIDAS,ISNULL(spp.HORAS_EXTRA,0) AS HORAS_EXTRA,ISNULL(spp.UNIDADES_PRODUCIDAS_EXTRA,0) AS UNIDADES_PRODUCIDAS_EXTRA ";
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
                                                productividad=unidadesprod/horaspersonal;
                                                sumHorHombrePer+=horaspersonal;
                                                sumUnidPer+=unidadesprod;
                                                horasExtra+=result3.getDouble("HORAS_EXTRA");
                                                unidadesExtra+=result3.getDouble("UNIDADES_PRODUCIDAS_EXTRA");

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
                                             productividad=unidadesprod/horaspersonal;
                                              sumHorHombrePer+=horaspersonal;
                                                sumUnidPer+=unidadesprod;
                                                
                                        }
                                        %>
                                    <%
                                    }

                         }
                         result2.close();
                         st2.close();

                         double prod=0;
                         double enviadosAcond=this.enviadosAcond(codLote, codComprod);
                         if(sumHorHombrePer>0)
                             prod=enviadosAcond/sumHorHombrePer;

                          %>
                         <tr>
                             

                              <th class="outputTextNormal" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" colspan="1"><b> <%=codLote%></b></th>
                               <th class="outputTextNormal" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" colspan="1"><b><%=nombrePrograma%></b></th>
                                <th class="outputTextNormal" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" colspan="1"><b><%=nombreProducto%></b></th>
                           <th class="outputTextNormal" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" ><b><%=formato.format(sumHorHombrePer)%></b></th>
                           <th class="outputTextNormal" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" ><b><%=formato.format(enviadosAcond)%></b></th>
                           <th class="outputTextNormal" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2"><b><%=formato.format(prod)%></b></th>
                           <th class="outputTextNormal" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2"><b><%=formato.format(horasExtra)%></b></th>
                           <th class="outputTextNormal" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2"><b><%=formato.format(unidadesExtra)%></b></th>
                           <th class="outputTextNormal" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" ><b><%=formato.format(sumHorHombre)%></b></th>
                           
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