package reportesProgramaProduccion;

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


<%! Connection con = null;
String codPresentacion = "";
String nombrePresentacion = "";
String linea_mkt = "";
String agenciaVenta = "";
%>
<%! public String nombrePresentacion1() {



    String nombreproducto = "";
//ManagedAccesoSistema bean1=(ManagedAccesoSistema)com.cofar.util.Util.getSessionBean("ManagedAccesoSistema");
    try {
        con = Util.openConnection(con);
        String sql_aux = "select cod_presentacion, nombre_producto_presentacion from presentaciones_producto where cod_presentacion='" + codPresentacion + "'";
        System.out.println("PresentacionesProducto:sql:" + sql_aux);
        Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rs = st.executeQuery(sql_aux);
        while (rs.next()) {
            String codigo = rs.getString(1);
            nombreproducto = rs.getString(2);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return nombreproducto;
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
    </head>
    <body>
        <form>
            <h4 align="center">Reporte Seguimiento Programa Producción</h4>

                    <%
                    try {

                /*
                         <input type="hidden" name="codProgramaProduccionPeriodo">
                        <input type="hidden" name="codCompProd">
                        <input type="hidden" name="nombreCompProd">
                        */

                        NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
                        DecimalFormat formato = (DecimalFormat) numeroformato;
                        formato.applyPattern("#,###.##;(#,###.##)");

                        SimpleDateFormat f=new SimpleDateFormat("dd/MM/yyyy");

                        con = Util.openConnection(con);

                        String codProgramaProdPeriodo=request.getParameter("codProgramaProduccionPeriodo")==null?"''":request.getParameter("codProgramaProduccionPeriodo");
                        String arrayCodCompProd = request.getParameter("codCompProdArray")==null?"''":request.getParameter("codCompProdArray");
                        String nombreProgramaProduccionPeriodo = request.getParameter("nombreProgramaProduccionPeriodo")==null?"''":request.getParameter("nombreProgramaProduccionPeriodo");
                        arrayCodCompProd = arrayCodCompProd + (arrayCodCompProd.length()==0?"' '":"");


                        System.out.println("los datos de peticion para el reporte : "+request.getParameter("codAreaEmpresaP"));
                        System.out.println(request.getParameter("nombreAreaEmpresaP"));

                        System.out.println(request.getParameter("desdeFechaP"));
                        System.out.println(request.getParameter("hastaFechaP"));

                        String arrayCodAreaEmpresa= request.getParameter("codAreaEmpresaP");
                        String arrayNombreAreaEmpresa= request.getParameter("nombreAreaEmpresaP");

                        String desdeFecha=request.getParameter("desdeFechaP");
                        String hastaFecha=request.getParameter("hastaFechaP");


                        String codEstadoProgramaProduccion=request.getParameter("codEstadoPrograma");
                         String arraydesde[]=desdeFecha.split("/");
                         desdeFecha=arraydesde[2] +"/"+ arraydesde[1]+"/"+arraydesde[0];

                         String arrayhasta[]=hastaFecha.split("/");
                         hastaFecha=arrayhasta[2]+"/"+arrayhasta[1]+"/"+arrayhasta[0];

                         //Double totalHoraInicio=0.0d;
                         //Double totalHoraFinal=0.0d;

                         Double totalHorasHombre=0.0d;
                         Double totalHorasMaquina=0.0d;

                         Double totalHorasHombreFormulaMaestra=0.0d;
                         Double totalHorasMaquinaFormulaMaestra=0.0d;

                         //1:todos , 2:con seguimiento, 3:sin seguimiento


                         String codTipoReporteSeguimientoProgramaProduccion=request.getParameter("codTipoReporteSeguimientoProgramaProduccion");

                         String codTipoActividadProduccion=request.getParameter("codTipoActividadProduccion")==null?"0":request.getParameter("codTipoActividadProduccion");

                         //System.out.println("las fechas en el reporte" + desdeFecha + " " +hastaFecha );


                    %>

            <div class="outputText0" align="center">
                PROGRAMA PRODUCCION: <%= nombreProgramaProduccionPeriodo %> <br>
                AREA(S) : <%= arrayNombreAreaEmpresa %><br>
                DE <%= arraydesde[0] +"/"+ arraydesde[1]+"/"+arraydesde[2] %> <br>
                HASTA <%= arrayhasta[0] +"/"+ arrayhasta[1]+"/"+arrayhasta[2] %>
                <%--PRODUCTO<%=nombreComponenteProd%>--%>
            </div>

            <br>
            <table width="70%" align="center" class="outputText0" style="border : solid #000000 1px;" cellpadding="0" cellspacing="0" >


                <tr class="">
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='10%' align="center" colspan="2"><b>Producto - Actividades</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center" ><b>Lote</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='20%' align="center"><b>Maquina (Standard)</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center"><b>Horas Hombre (Standard)</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Horas Maquina (Standard)</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center"><b>Maquina </b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center"><b>Fecha Inicial </b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Fecha Final</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center"><b>Horas Hombre</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Horas Maquina</b></td>
                </tr>

                <%

                String consulta=" SELECT  PPR.COD_LOTE_PRODUCCION,CPR.COD_COMPPROD ,CPR.nombre_prod_semiterminado " +
                                " FROM PROGRAMA_PRODUCCION PPR INNER JOIN COMPONENTES_PROD CPR ON PPR.COD_COMPPROD = CPR.COD_COMPPROD " +
                                " WHERE PPR.COD_ESTADO_PROGRAMA IN ("+codEstadoProgramaProduccion+") AND PPR.COD_PROGRAMA_PROD='"+codProgramaProdPeriodo+ "'" +
                                " AND PPR.COD_LOTE_PRODUCCION +''+ CAST(PPR.COD_COMPPROD  AS VARCHAR(20)) IN ("+arrayCodCompProd+")" +
                                " AND CPR.COD_AREA_EMPRESA IN ("+arrayCodAreaEmpresa+") " +
                                " ORDER BY CPR.nombre_prod_semiterminado,PPR.COD_LOTE_PRODUCCION ";

                System.out.println("consulta 1 "+ consulta);
                con=Util.openConnection(con);
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs = st.executeQuery(consulta);
                while (rs.next()) {
                    //System.out.println("consulta 1 "+ consulta);
                    String nombreProductoSemiternimando= rs.getString("nombre_prod_semiterminado");
                    String codLoteProduccion = rs.getString("COD_LOTE_PRODUCCION");
                    String codCompProd = rs.getString("COD_COMPPROD");
                %>
                <tr>
                    <td class="border"  align="left" colspan="2"><b><%=nombreProductoSemiternimando%></b></td>
                    <td class="border" align="center"><b><%=codLoteProduccion%></b></td>
                    <td class="border" align="right" colspan="8">&nbsp;</td>
                </tr>
                                <%                                
                             String consultaActividades="";

                             


                            if(codTipoReporteSeguimientoProgramaProduccion.equals("1")){
                            consultaActividades="SELECT PPR.COD_LOTE_PRODUCCION,CPR.nombre_prod_semiterminado,APR.COD_ACTIVIDAD,AFM.COD_ACTIVIDAD_FORMULA, APR.NOMBRE_ACTIVIDAD,AFM.ORDEN_ACTIVIDAD,FM.COD_FORMULA_MAESTRA " +
                                        " FROM ACTIVIDADES_FORMULA_MAESTRA AFM  " +
                                        " INNER JOIN ACTIVIDADES_PRODUCCION APR ON AFM.COD_ACTIVIDAD = APR.COD_ACTIVIDAD  " +
                                        " INNER JOIN FORMULA_MAESTRA FM ON FM.COD_FORMULA_MAESTRA = AFM.COD_FORMULA_MAESTRA  "+
                                        " INNER JOIN PROGRAMA_PRODUCCION PPR ON PPR.COD_FORMULA_MAESTRA = FM.COD_FORMULA_MAESTRA " +
                                        " INNER JOIN COMPONENTES_PROD CPR ON PPR.COD_COMPPROD = CPR.COD_COMPPROD " +
                                        " AND CPR.COD_COMPPROD = FM.COD_COMPPROD " +
                                        " WHERE PPR.COD_COMPPROD='"+codCompProd+"'" +
                                        " AND PPR.COD_LOTE_PRODUCCION = '"+codLoteProduccion+"' " +
                                        " AND PPR.COD_ESTADO_PROGRAMA IN ("+codEstadoProgramaProduccion+") AND PPR.COD_PROGRAMA_PROD='"+codProgramaProdPeriodo+"'" +
                                        " AND APR.COD_TIPO_ACTIVIDAD_PRODUCCION='"+codTipoActividadProduccion+"' " +
                                        " ORDER BY CPR.nombre_prod_semiterminado,PPR.COD_LOTE_PRODUCCION,AFM.ORDEN_ACTIVIDAD";
                            }
                             if(codTipoReporteSeguimientoProgramaProduccion.equals("2")){
                            consultaActividades=" SELECT PPR.COD_LOTE_PRODUCCION,CPR.nombre_prod_semiterminado,APR.COD_ACTIVIDAD,AFM.COD_ACTIVIDAD_FORMULA, APR.NOMBRE_ACTIVIDAD,AFM.ORDEN_ACTIVIDAD,FM.COD_FORMULA_MAESTRA " +
                                        " FROM ACTIVIDADES_FORMULA_MAESTRA AFM " +
                                        " INNER JOIN ACTIVIDADES_PRODUCCION APR ON AFM.COD_ACTIVIDAD = APR.COD_ACTIVIDAD  " +
                                        " INNER JOIN FORMULA_MAESTRA FM ON FM.COD_FORMULA_MAESTRA = AFM.COD_FORMULA_MAESTRA  "+
                                        " INNER JOIN PROGRAMA_PRODUCCION PPR ON PPR.COD_FORMULA_MAESTRA = FM.COD_FORMULA_MAESTRA " +
                                        " INNER JOIN COMPONENTES_PROD CPR ON PPR.COD_COMPPROD = CPR.COD_COMPPROD " +
                                        " AND CPR.COD_COMPPROD = FM.COD_COMPPROD " +
                                        " WHERE PPR.COD_COMPPROD='"+codCompProd+"'" +
                                        " AND PPR.COD_LOTE_PRODUCCION = '"+codLoteProduccion+"' " +
                                        " AND PPR.COD_ESTADO_PROGRAMA IN ("+codEstadoProgramaProduccion+") AND PPR.COD_PROGRAMA_PROD='"+codProgramaProdPeriodo+"'" +
                                        " AND AFM.COD_ACTIVIDAD_FORMULA IN (select s.COD_ACTIVIDAD_PROGRAMA   " +
                                        " from SEGUIMIENTO_PROGRAMA_PRODUCCION s   " +
                                        " where  s.COD_PROGRAMA_PROD='"+codProgramaProdPeriodo+"' and s.COD_COMPPROD='"+codCompProd+"' and s.COD_FORMULA_MAESTRA=FM.COD_FORMULA_MAESTRA and s.COD_LOTE_PRODUCCION=PPR.COD_LOTE_PRODUCCION " +
                                        " and s.FECHA_INICIO>='"+ desdeFecha +" 00:00:00' and  s.FECHA_FINAL<= '"+hastaFecha+" 23:59:59')  " +
                                        " AND APR.COD_TIPO_ACTIVIDAD_PRODUCCION='"+codTipoActividadProduccion+"' " +
                                        " ORDER BY CPR.nombre_prod_semiterminado,PPR.COD_LOTE_PRODUCCION,AFM.ORDEN_ACTIVIDAD";
                                        }
                             if(codTipoReporteSeguimientoProgramaProduccion.equals("3")){
                                 consultaActividades="SELECT PPR.COD_LOTE_PRODUCCION,CPR.nombre_prod_semiterminado,APR.COD_ACTIVIDAD,AFM.COD_ACTIVIDAD_FORMULA, APR.NOMBRE_ACTIVIDAD,AFM.ORDEN_ACTIVIDAD,FM.COD_FORMULA_MAESTRA " +
                                        " FROM ACTIVIDADES_FORMULA_MAESTRA AFM " +
                                        " INNER JOIN ACTIVIDADES_PRODUCCION APR ON AFM.COD_ACTIVIDAD = APR.COD_ACTIVIDAD  " +
                                        " INNER JOIN FORMULA_MAESTRA FM ON FM.COD_FORMULA_MAESTRA = AFM.COD_FORMULA_MAESTRA  "+
                                        " INNER JOIN PROGRAMA_PRODUCCION PPR ON PPR.COD_FORMULA_MAESTRA = FM.COD_FORMULA_MAESTRA " +
                                        " INNER JOIN COMPONENTES_PROD CPR ON PPR.COD_COMPPROD = CPR.COD_COMPPROD " +
                                        " AND CPR.COD_COMPPROD = FM.COD_COMPPROD " +
                                        " WHERE PPR.COD_COMPPROD='"+codCompProd+"'" +
                                        " AND PPR.COD_LOTE_PRODUCCION = '"+codLoteProduccion+"' " +
                                        " AND PPR.COD_ESTADO_PROGRAMA IN ("+codEstadoProgramaProduccion+") AND PPR.COD_PROGRAMA_PROD='"+codProgramaProdPeriodo+"'" +
                                        " AND AFM.COD_ACTIVIDAD_FORMULA NOT IN (select s.COD_ACTIVIDAD_PROGRAMA   " +
                                        " from SEGUIMIENTO_PROGRAMA_PRODUCCION s   " +
                                        " where  s.COD_PROGRAMA_PROD='"+codProgramaProdPeriodo+"' and s.COD_COMPPROD='"+codCompProd+"' and s.COD_FORMULA_MAESTRA=FM.COD_FORMULA_MAESTRA and s.COD_LOTE_PRODUCCION=PPR.COD_LOTE_PRODUCCION " +
                                        " and s.FECHA_INICIO>='"+ desdeFecha +" 00:00:00' and  s.FECHA_FINAL<= '"+hastaFecha+" 23:59:59')  " +
                                        " AND APR.COD_TIPO_ACTIVIDAD_PRODUCCION='"+codTipoActividadProduccion+"' " +
                                        " ORDER BY CPR.nombre_prod_semiterminado,PPR.COD_LOTE_PRODUCCION,AFM.ORDEN_ACTIVIDAD";
                             }

                                    //setCon(Util.openConnection(getCon()));
                            System.out.println("consulta 2 "+ consultaActividades);


                            Statement stActividad=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            ResultSet rsActividad=stActividad.executeQuery(consultaActividades);
                            float horasHombre = 0;
                            float horasMaquina = 0;

                            float horasHombreFormulaMaestra = 0;
                            float horasMaquinaFormulaMaestra = 0;


                            while(rsActividad.next()){
                                String codActividad = rsActividad.getString("COD_ACTIVIDAD");
                                String nombreActividad = rsActividad.getString("NOMBRE_ACTIVIDAD");
                                String codFormulaMaestra = rsActividad.getString("COD_FORMULA_MAESTRA");
                                String codActividadFormula= rsActividad.getString("COD_ACTIVIDAD_FORMULA");
                                String ordenActividad = rsActividad.getString("ORDEN_ACTIVIDAD");
                                out.print("<tr>");
                                out.print("<td align='right'  style='border : solid #f2f2f2 1px' bgcolor='#F9F9F9' width='5%' ><b>"+ordenActividad+"</b></td>");
                                out.print("<td align='left'  style='border : solid #f2f2f2 1px'  bgcolor='#F9F9F9' colspan='2'><b>"+nombreActividad+"</b></td>");
                                out.print("<td align='left'  style='border : solid #f2f2f2 1px' bgcolor='#F9F9F9'>&nbsp;</td>");
                                out.print("<td align='left'  style='border : solid #f2f2f2 1px' bgcolor='#F9F9F9'>&nbsp;</td>");
                                out.print("<td align='left'  style='border : solid #f2f2f2 1px' bgcolor='#F9F9F9'>&nbsp;</td>");
                                out.print("<td align='left'  style='border : solid #f2f2f2 1px' bgcolor='#F9F9F9'>&nbsp;</td>");
                                out.print("<td align='left'  style='border : solid #f2f2f2 1px' bgcolor='#F9F9F9'>&nbsp;</td>");
                                out.print("<td align='left'  style='border : solid #f2f2f2 1px' bgcolor='#F9F9F9'>&nbsp;</td>");
                                out.print("<td align='left'  style='border : solid #f2f2f2 1px' bgcolor='#F9F9F9'>&nbsp;</td>");
                                out.print("<td align='left'  style='border : solid #f2f2f2 1px' bgcolor='#F9F9F9'>&nbsp;</td>");
                                out.print("</tr>");
                                
                                //------------datos standard -----------------------
                                String consultaActividadesFormulaMaestra= " select maf.COD_ACTIVIDAD_FORMULA,maf.COD_MAQUINA,m.NOMBRE_MAQUINA,maf.HORAS_HOMBRE,maf.HORAS_MAQUINA " +
                                        " from MAQUINARIA_ACTIVIDADES_FORMULA maf inner join maquinarias  m on m.COD_MAQUINA = maf.COD_MAQUINA " +
                                        " where maf.COD_ACTIVIDAD_FORMULA = "+codActividadFormula;
                                System.out.println("consulta actividad formula maestra" + consultaActividadesFormulaMaestra);
                                Statement stActividadFormulaMaestra=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                ResultSet rsActividadFormulaMaestra=stActividadFormulaMaestra.executeQuery(consultaActividadesFormulaMaestra);
                                boolean sinMaquinaria = false;
                                boolean conMaquinaria = false;
                                while(rsActividadFormulaMaestra.next()){
                                    String codMaquinaFormulaMaestra = rsActividadFormulaMaestra.getString("COD_MAQUINA");
                                    String nombreMaquinaFormulaMaestra = rsActividadFormulaMaestra.getString("NOMBRE_MAQUINA");
                                    String horaHombreFormulaMaestra = rsActividadFormulaMaestra.getString("HORAS_HOMBRE");
                                    String horaMaquinaFormulaMaestra = rsActividadFormulaMaestra.getString("HORAS_MAQUINA");
                                    out.print("<tr>");
                                    out.print("<td align='right'  style='border : solid #f2f2f2 1px' >&nbsp;</td>");
                                    out.print("<td align='right'  style='border : solid #f2f2f2 1px' colspan =2>&nbsp;</td>");
                                    out.print("<td align='left'  style='border : solid #f2f2f2 1px'>"+nombreMaquinaFormulaMaestra+"</td>");
                                    out.print("<td align='left'  style='border : solid #f2f2f2 1px' >"+horaHombreFormulaMaestra+"</td>");
                                    out.print("<td align='left'  style='border : solid #f2f2f2 1px' >"+horaMaquinaFormulaMaestra+"</td>");
                                    
                                    

                                    //si se tiene el dato de seguimiento de acuerdo al dato standar imprimirlo+
                                    String  consultaSeguimiento = " select top 1 s.COD_SEGUIMIENTO_PROGRAMA,s.HORAS_HOMBRE,s.HORAS_MAQUINA,s.FECHA_INICIO,s.FECHA_FINAL, " +
                                    " s.HORA_INICIO,s.HORA_FINAL,(select isnull(M.COD_MAQUINA,'') from MAQUINARIAS M where s.COD_MAQUINA=M.COD_MAQUINA ) COD_MAQUINA, " +
                                    " (select isnull(M.NOMBRE_MAQUINA,'') from MAQUINARIAS M where s.COD_MAQUINA=M.COD_MAQUINA ) NOMBRE_MAQUINA " +
                                    " from SEGUIMIENTO_PROGRAMA_PRODUCCION s  where s.COD_ACTIVIDAD_PROGRAMA='"+codActividadFormula+"'  " +
                                    " and s.COD_PROGRAMA_PROD='"+codProgramaProdPeriodo+"'  and s.COD_COMPPROD='"+codCompProd+"' and s.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' " +
                                    " and (s.COD_MAQUINA ="+codMaquinaFormulaMaestra+" OR 0=0 ) " +
                                    " and s.COD_LOTE_PRODUCCION='"+codLoteProduccion+"' and s.FECHA_INICIO>='"+ desdeFecha +" 00:00:00'  and  s.FECHA_FINAL<= '"+hastaFecha+" 23:59:59' " +
                                    " order by s.COD_SEGUIMIENTO_PROGRAMA desc ";
                                    
                                    System.out.println("consulta seguimiento " + consultaSeguimiento);


                            Statement stSeguimiento=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            ResultSet rsSeguimiento=stSeguimiento.executeQuery(consultaSeguimiento);

                            

                            if(rsSeguimiento.next() && sinMaquinaria ==false && conMaquinaria == false){
                                
                                Date fechaInicioSeguimiento = rsSeguimiento.getDate("FECHA_INICIO");
                                Date fechaFinalSeguimiento = rsSeguimiento.getDate("FECHA_FINAL");
                                String horaInicioSeguimiento = rsSeguimiento.getString("HORA_INICIO");
                                String horaFinalSeguimiento = rsSeguimiento.getString("HORA_FINAL");
                                String horaHombreSeguimiento = rsSeguimiento.getString("HORAS_HOMBRE");
                                String horaMaquinaSeguimiento = rsSeguimiento.getString("HORAS_MAQUINA");
                                String codMaquinaSeguimiento = rsSeguimiento.getString("NOMBRE_MAQUINA");
                                String nombreMaquinaSeguimiento = rsSeguimiento.getString("NOMBRE_MAQUINA");
                                
                                out.print("<td  style='border : solid #f2f2f2 1px'  align='right'  >"+(nombreMaquinaSeguimiento==null?"&nbsp;":nombreMaquinaSeguimiento)+" </td>");
                                out.print("<td  style='border : solid #f2f2f2 1px'  align='left' >"+f.format(fechaInicioSeguimiento)+" </td>");
                                out.print("<td  style='border : solid #f2f2f2 1px'  align='left' >"+f.format(fechaFinalSeguimiento)+" </td>");

                                out.print("<td  style='border : solid #f2f2f2 1px'  align='right' >"+horaHombreSeguimiento+" </td>");
                                out.print("<td  style='border : solid #f2f2f2 1px'  align='right'  >"+ horaMaquinaSeguimiento +" </td>");


                                horasHombre = horasHombre + Float.valueOf(horaHombreSeguimiento.equals("")?"0":horaHombreSeguimiento.replace(",", "."));
                                horasMaquina = horasMaquina + Float.valueOf(horaMaquinaSeguimiento.equals("")?"0":horaMaquinaSeguimiento.replace(",", "."));

                                totalHorasHombre = totalHorasHombre + Double.valueOf(horaHombreSeguimiento.equals("")?"0":horaHombreSeguimiento.replace(",", "."));
                                totalHorasMaquina = totalHorasMaquina + Double.valueOf(horaMaquinaSeguimiento.equals("")?"0":horaMaquinaSeguimiento.replace(",", "."));


                                if(nombreMaquinaSeguimiento==null || nombreMaquinaSeguimiento.equals("")){
                                    sinMaquinaria = true;
                                }else{
                                    conMaquinaria = true;
                                }
                                
                                }

                                horasHombreFormulaMaestra = horasHombreFormulaMaestra + Float.valueOf(horaHombreFormulaMaestra.equals("")?"0":horaHombreFormulaMaestra.replace(",", "."));
                                horasMaquinaFormulaMaestra = horasMaquinaFormulaMaestra + Float.valueOf(horaMaquinaFormulaMaestra.equals("")?"0":horaMaquinaFormulaMaestra.replace(",", "."));

                                totalHorasHombreFormulaMaestra = totalHorasHombreFormulaMaestra + Double.valueOf(horaHombreFormulaMaestra.equals("")?"0":horaHombreFormulaMaestra.replace(",", "."));
                                totalHorasMaquinaFormulaMaestra = totalHorasMaquinaFormulaMaestra + Double.valueOf(horaMaquinaFormulaMaestra.equals("")?"0":horaMaquinaFormulaMaestra.replace(",", "."));
                                
                                out.print("</tr>");
                                
                                }
                                
                            }
                            out.print("<tr>");
                            out.print("<td align='right'  style='border : solid #D8D8D8 1px' >&nbsp;</td>");
                            out.print("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' colspan='2'>&nbsp;</td>");
                            out.print("<td align='center' style='border : solid #D8D8D8 1px' class='border'  bgcolor='#f2f2f2' >TOTAL</td>");
                            out.print("<td align='center' style='border : solid #D8D8D8 1px' class='border'  bgcolor='#f2f2f2' >"+formato.format(horasHombreFormulaMaestra)+"</td>");
                            out.print("<td align='center' style='border : solid #D8D8D8 1px' class='border'  bgcolor='#f2f2f2' >"+formato.format(horasMaquinaFormulaMaestra)+"</td>");
                            out.print("<td align='center' style='border : solid #D8D8D8 1px' class='border'  bgcolor='#f2f2f2' >&nbsp;</td>");
                            out.print("<td align='right' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' >&nbsp;</td>");
                            out.print("<td align='right' style='border : solid #D8D8D8 1px' class='border'  bgcolor='#f2f2f2' >&nbsp;</td>");
                            out.print("<td align='right' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' >"+formato.format(horasHombre)+"</td>");
                            out.print("<td align='right' style='border : solid #D8D8D8 1px' class='border'  bgcolor='#f2f2f2' >"+formato.format(horasMaquina)+"</td>");
                            out.print("</tr>");
                        }
                                out.print("<tr>");
                                out.print("<td align='right'  style='border : solid #D8D8D8 1px' ></td>");
                                out.print("<td  class='border' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' colspan='2'>&nbsp;</td>");
                                out.print("<td align='center' style='border : solid #D8D8D8 1px' class='border'  bgcolor='#f2f2f2' >TOTAL GENERAL</td>");
                                out.print("<td align='center' style='border : solid #D8D8D8 1px' class='border'  bgcolor='#f2f2f2' >"+formato.format(totalHorasHombreFormulaMaestra)+"</td>");
                                out.print("<td align='center' style='border : solid #D8D8D8 1px' class='border'  bgcolor='#f2f2f2' >"+formato.format(totalHorasMaquinaFormulaMaestra)+"</td>");
                                out.print("<td align='center' style='border : solid #D8D8D8 1px' class='border'  bgcolor='#f2f2f2' ></td>");
                                out.print("<td align='right' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' ></td>");
                                out.print("<td align='right' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' ></td>");
                                out.print("<td align='right' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' >"+formato.format(totalHorasHombre)+"</td>");
                                out.print("<td align='right' style='border : solid #D8D8D8 1px' bgcolor='#f2f2f2' >"+formato.format(totalHorasMaquina)+"</td>");
                                out.print("</tr>");


               %>
               </table>

                <%



                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                %>
            <br>

            <br>
            <div align="center">
                <%--<INPUT type="button" class="commandButton" name="btn_registrar" value="<-- Atrás" onClick="cancelar();"  >--%>

            </div>
        </form>
    </body>
</html>