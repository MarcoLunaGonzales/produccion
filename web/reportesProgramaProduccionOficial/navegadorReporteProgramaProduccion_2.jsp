<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import="com.cofar.bean.*" %>
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
<%@ page language="java" import = "org.joda.time.*"%>
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
            <h4 align="center">Reporte Programa Producción</h4>
            <%
            con=Util.openConnection(con);
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            SimpleDateFormat sdf1 = new SimpleDateFormat("MM/yyyy");
            NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
            DecimalFormat format = (DecimalFormat) nf;
            format.applyPattern("#,###.00");
            
            String codProgramaProduccion = request.getParameter("codProgramaProd")==null?"0":request.getParameter("codProgramaProd");
            String nombreProgramaProduccion = request.getParameter("nombreProgramaProduccion")==null?"0":request.getParameter("nombreProgramaProduccion");
            
            String codAreaEmpresa = request.getParameter("codigosArea")==null?"0":request.getParameter("codigosArea");
            String nombresAreaEmpresa = request.getParameter("nombresArea")==null?"0":request.getParameter("nombresArea");

            String fechaInicialP = request.getParameter("fechaInicial")==null?"0":request.getParameter("fechaInicial");
            String fechaFinalP = request.getParameter("fechaFinal")==null?"0":request.getParameter("fechaFinal");
            SimpleDateFormat sdfd = new SimpleDateFormat("dd");
            SimpleDateFormat sdfm = new SimpleDateFormat("MM");
            SimpleDateFormat sdfy = new SimpleDateFormat("yyyy");


            %>

            <table align="center" width="90%" class='outputText0'>
                <tr>
                    <td width="10%">
                        <img src="../img/cofar.png">
                    </td>                
                <td align="center" width="80%">
                <br>
                    Area(s) : <b><%=nombresAreaEmpresa%></b>
                    <br><br>
                    Programa Produccion : <b><%=nombreProgramaProduccion%></b>
                    <br><br>
                    Fecha Inicial : <b><%=fechaInicialP%></b>
                    <br><br>
                    Fecha Final : <b><%=fechaFinalP%></b>

                </td>
                <td align="center" >
                </td>
                </tr>
            </table>
            <div class="outputText0" align="center">
                
                
            </div>
            <br>
            <table width="90%" align="center" class='outputText0' style="border : solid #000000 1px;" cellpadding="0" cellspacing="0" >
                
                
                <tr class='bordeNegroTd'>
                    <th  class='bordeNegroTd'>Producto</th>
                    <th class='bordeNegroTd' align="center" >Lote</th>
                    <th class='bordeNegroTd' align="center" >Nro de Lote</th>
                    <th class='bordeNegroTd' align="center" >Fecha Inicio</th>
                    <%--th class='bordeNegroTd' align="center" >Fecha Final</th--%>
                    <th class='bordeNegroTd' align="center" >horas Hombre (Pesaje)</th>
                    <th class='bordeNegroTd' align="center" >horas Maquina (Pesaje)</th>
                    <th class='bordeNegroTd' align="center" >Tipo Programa Producción</th>
                    <th class='bordeNegroTd' align="center" >Categoría</th>
                    <th class='bordeNegroTd' align="center" >Estado Materia Prima</th>
                    <th class='bordeNegroTd' align="center" >Area</th>
                    <th class='bordeNegroTd' align="center" >Estado</th>
                    <th class='bordeNegroTd' align="center" >Reg. Sanitario</th>
                    <th class='bordeNegroTd' align="center" >Vida Util</th>
                    <th class='bordeNegroTd' align="center" >Fecha Vencimiento</th>
                </tr>


                <%
                com.cofar.web.ManagedProgramaProduccion managedProgramaProduccion = new com.cofar.web.ManagedProgramaProduccion();
                try{
                    String consulta = " select pp.cod_programa_prod,fm.cod_formula_maestra,pp.cod_lote_produccion, " +
                            " pp.fecha_inicio,pp.fecha_final,pp.cod_estado_programa,pp.observacion, " +
                            " cp.nombre_prod_semiterminado,cp.cod_compprod,fm.cantidad_lote, " +
                            " epp.NOMBRE_ESTADO_PROGRAMA_PROD,pp.cant_lote_produccion,tp.COD_TIPO_PROGRAMA_PROD,tp.NOMBRE_TIPO_PROGRAMA_PROD " +
                            " ,ISNULL((SELECT C.NOMBRE_CATEGORIACOMPPROD FROM CATEGORIAS_COMPPROD C WHERE C.COD_CATEGORIACOMPPROD=cp.COD_CATEGORIACOMPPROD),'') nombre_categoria, " +
                            " pp.MATERIAL_TRANSITO,cp.cod_area_empresa " +
                            " ,(SELECT ISNULL(ae.NOMBRE_AREA_EMPRESA,'') FROM AREAS_EMPRESA ae WHERE ae.COD_AREA_EMPRESA =cp.COD_AREA_EMPRESA) NOMBRE_AREA_EMPRESA, " +
                            " (select top 1 s.FECHA_INICIO from SEGUIMIENTO_PROGRAMA_PRODUCCION s where s.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD and s.COD_LOTE_PRODUCCION = pp.COD_LOTE_PRODUCCION " +
                            " and s.COD_COMPPROD = pp.COD_COMPPROD and s.COD_FORMULA_MAESTRA= pp.COD_FORMULA_MAESTRA and s.cod_tipo_programa_prod = pp.cod_tipo_programa_prod " +
                            " and s.COD_ACTIVIDAD_PROGRAMA in ( select afm.COD_ACTIVIDAD_FORMULA from ACTIVIDADES_FORMULA_MAESTRA afm  " +
                            " where afm.COD_FORMULA_MAESTRA = s.COD_FORMULA_MAESTRA and afm.COD_ACTIVIDAD in( 76,186) )  order by s.COD_SEGUIMIENTO_PROGRAMA desc ) fecha_inicio_pesaje," +
                            " (select top 1 s.horas_hombre from SEGUIMIENTO_PROGRAMA_PRODUCCION s where s.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD and s.COD_LOTE_PRODUCCION = pp.COD_LOTE_PRODUCCION " +
                            " and s.COD_COMPPROD = pp.COD_COMPPROD and s.COD_FORMULA_MAESTRA= pp.COD_FORMULA_MAESTRA and s.cod_tipo_programa_prod = pp.cod_tipo_programa_prod" +
                            " and s.COD_ACTIVIDAD_PROGRAMA in ( select afm.COD_ACTIVIDAD_FORMULA from ACTIVIDADES_FORMULA_MAESTRA afm  " +
                            " where afm.COD_FORMULA_MAESTRA = s.COD_FORMULA_MAESTRA and afm.COD_ACTIVIDAD in( 76,186) )  order by s.COD_SEGUIMIENTO_PROGRAMA desc ) horas_hombre_pesaje," +
                            " (select top 1 s.horas_maquina from SEGUIMIENTO_PROGRAMA_PRODUCCION s where s.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD and s.COD_LOTE_PRODUCCION = pp.COD_LOTE_PRODUCCION " +
                            " and s.COD_COMPPROD = pp.COD_COMPPROD and s.COD_FORMULA_MAESTRA= pp.COD_FORMULA_MAESTRA and s.cod_tipo_programa_prod = pp.cod_tipo_programa_prod " +
                            " and s.COD_ACTIVIDAD_PROGRAMA in ( select afm.COD_ACTIVIDAD_FORMULA from ACTIVIDADES_FORMULA_MAESTRA afm  " +
                            " where afm.COD_FORMULA_MAESTRA = s.COD_FORMULA_MAESTRA and afm.COD_ACTIVIDAD in( 76,186) )  order by s.COD_SEGUIMIENTO_PROGRAMA desc ) horas_maquina_pesaje," +
                            " cp.VIDA_UTIL,dateadd(month,cp.VIDA_UTIL,(select top 1 s.FECHA_INICIO from SEGUIMIENTO_PROGRAMA_PRODUCCION s " +
                            " inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA=s.COD_ACTIVIDAD_PROGRAMA " +
                            " where s.COD_COMPPROD = pp.COD_COMPPROD " +
                            " and s.COD_LOTE_PRODUCCION = pp.COD_LOTE_PRODUCCION and s.COD_FORMULA_MAESTRA = pp.COD_FORMULA_MAESTRA " +
                            " and s.COD_PROGRAMA_PROD = pp.COD_PROGRAMA_PROD and s.cod_tipo_programa_prod = pp.cod_tipo_programa_prod and afm.COD_ACTIVIDAD in( 76,186))) fecha_vencimiento,cp.REG_SANITARIO " +
                            " from programa_produccion pp,formula_maestra fm,componentes_prod cp,ESTADOS_PROGRAMA_PRODUCCION epp,TIPOS_PROGRAMA_PRODUCCION tp " +
                            " where pp.cod_formula_maestra=fm.cod_formula_maestra and cp.cod_compprod=fm.cod_compprod and epp.COD_ESTADO_PROGRAMA_PROD=pp.cod_estado_programa " +
                            " and tp.COD_TIPO_PROGRAMA_PROD = pp.COD_TIPO_PROGRAMA_PROD  " +
                            " and cp.COD_AREA_EMPRESA in ("+codAreaEmpresa+") " ;
                    if(!codProgramaProduccion.equals("-1")){
                        consulta = consulta + " and pp.cod_programa_prod='"+codProgramaProduccion+"'  " ;
                    }

                    if(!fechaInicialP.equals("") && !fechaFinalP.equals("")){
                        String[] arrayFechaInicial = fechaInicialP.split("/");
                        String[] arrayFechaFinal = fechaFinalP.split("/");                        

                        consulta = consulta + " and cast(pp.COD_PROGRAMA_PROD as varchar)+','+cast(pp.COD_COMPPROD as varchar)+','+CAST(pp.COD_FORMULA_MAESTRA as varchar)+','+pp.COD_LOTE_PRODUCCION in " +
                                " (select cast(sppr.COD_PROGRAMA_PROD as varchar)+','+cast( sppr.COD_COMPPROD as varchar)+','+CAST( sppr.COD_FORMULA_MAESTRA as varchar)+','+sppr.COD_LOTE_PRODUCCION " +
                                " from ACTIVIDADES_FORMULA_MAESTRA afm inner join SEGUIMIENTO_PROGRAMA_PRODUCCION sppr " +
                                " on sppr.COD_ACTIVIDAD_PROGRAMA = afm.COD_ACTIVIDAD_FORMULA where afm.COD_ACTIVIDAD in( 76,186) " +
                                " and sppr.FECHA_INICIO>='"+arrayFechaInicial[2]+"/"+arrayFechaInicial[1]+"/"+arrayFechaInicial[0]+"' " +
                                " and sppr.FECHA_FINAL<='"+arrayFechaFinal[2]+"/"+arrayFechaFinal[1]+"/"+arrayFechaFinal[0]+"') " ;
                    }
                    consulta = consulta  + " order by cp.nombre_prod_semiterminado ";


                    System.out.println("consulta " + consulta);
                    Statement st = con.createStatement();
                    ResultSet rs = st.executeQuery(consulta);
                    while(rs.next()){
                        String nombreProdSemiterminado = rs.getString("nombre_prod_semiterminado");
                        int cantLoteProduccion = rs.getInt("cant_lote_produccion");
                        int cantLote = rs.getInt("cantidad_lote");
                        String codLoteProduccion = rs.getString("cod_lote_produccion");
                        Date fechaInicio = rs.getDate("fecha_inicio");
                        Date fechaFinal = rs.getDate("fecha_final");
                        String nombreTipoProgramaProd = rs.getString("NOMBRE_TIPO_PROGRAMA_PROD");
                        String nombreCategoria = rs.getString("nombre_categoria");
                        int materialTransito = rs.getInt("MATERIAL_TRANSITO");
                        String nombreAreaEmpresa = rs.getString("NOMBRE_AREA_EMPRESA");
                        String nombreEstadoProgramaProd= rs.getString("NOMBRE_ESTADO_PROGRAMA_PROD");                        
                        Date fechaInicioPesaje= rs.getDate("fecha_inicio_pesaje");
                        String horasHombrePesaje = rs.getString("horas_hombre_pesaje");
                        String horasMaquinaPesaje = rs.getString("horas_maquina_pesaje");
                        Date fechaVencimiento = rs.getDate("fecha_vencimiento");
                        int vidaUtil = rs.getInt("VIDA_UTIL");
                        String registroSanitario = rs.getString("REG_SANITARIO");
                        DateTime dt = new DateTime();
                        if(fechaVencimiento==null){fechaVencimiento = new Date();
                        dt = new DateTime();
                        dt = dt.plusMonths(vidaUtil);
                        /*dt = dt.withYear(Integer.valueOf(sdfy.format(fechaVencimiento)));
                        dt = dt.withMonthOfYear(Integer.valueOf(sdfm.format(fechaVencimiento)));
                        dt = dt.withDayOfMonth(Integer.valueOf(sdfd.format(fechaVencimiento)));*/
                        dt = dt.dayOfMonth().withMaximumValue();
                        fechaVencimiento = dt.toDate();
                        }else
                        {dt = new DateTime();
                        dt = dt.withYear(Integer.valueOf(sdfy.format(fechaVencimiento)));
                        dt = dt.withMonthOfYear(Integer.valueOf(sdfm.format(fechaVencimiento)));
                        dt = dt.withDayOfMonth(Integer.valueOf(sdfd.format(fechaVencimiento)));
                        dt = dt.dayOfMonth().withMaximumValue();
                        fechaVencimiento = dt.toDate();
                        //System.out.println("validate 1");
                        }
                        Date fechaActual = new Date();
                        System.out.println(fechaActual.getDate());
                        if(fechaActual.getDate()>=28){
                            dt = dt.plusMonths(1);
                            dt = dt.dayOfMonth().withMaximumValue();
                            fechaVencimiento = dt.toDate();
                        }
                        com.cofar.bean.ProgramaProduccion programaProduccion = new com.cofar.bean.ProgramaProduccion();
                        programaProduccion.setCodProgramaProduccion(rs.getString("cod_programa_prod"));
                        programaProduccion.getFormulaMaestra().setCodFormulaMaestra(rs.getString("cod_formula_maestra"));
                        programaProduccion.setCodLoteProduccion(rs.getString("cod_lote_produccion"));
                        programaProduccion.getFormulaMaestra().getComponentesProd().setCodCompprod(rs.getString("cod_compprod"));
                        programaProduccion.getFormulaMaestra().getComponentesProd().getAreasEmpresa().setCodAreaEmpresa(rs.getString("cod_area_empresa"));
                        programaProduccion.getFormulaMaestra().getComponentesProd().setVidaUtil(rs.getString("vida_util"));
                        fechaVencimiento = managedProgramaProduccion.calculaFechaVencimiento(programaProduccion);
                        
                        
                        
                        
                         out.print("<tr >");
                         out.print("<td  class='bordeNegroTd' align='left'>"+nombreProdSemiterminado+"</td>");
                         out.print("<td class='bordeNegroTd' align='left'>"+format.format(cantLoteProduccion)+"</td>");
                         out.print("<td class='bordeNegroTd' align='left'>"+codLoteProduccion+"</td>");
                         out.print("<td class='bordeNegroTd' align='left'>"+(fechaInicioPesaje!=null?sdf.format(fechaInicioPesaje):"")+"</td>");
                        // out.print("<td class='bordeNegroTd' align='left'>"+(fechaFinal!=null?sdf.format(fechaFinal):"")+"</td>");
                         out.print("<td class='bordeNegroTd' align='left'>"+(horasHombrePesaje!=null?horasHombrePesaje:"")+"</td>");
                         out.print("<td class='bordeNegroTd' align='left'>"+(horasMaquinaPesaje!=null?horasMaquinaPesaje:"")+"</td>");
                         out.print("<td class='bordeNegroTd' align='left'>"+nombreTipoProgramaProd+"</td>");
                         out.print("<td class='bordeNegroTd' align='left'>"+nombreCategoria+"</td>");
                         out.print("<td class='bordeNegroTd' align='left'>"+(materialTransito==0?"CON EXISTENCIA":materialTransito==1?"EN TRÁNSITO":"")+"</td>");
                         out.print("<td class='bordeNegroTd' align='left'>"+nombreAreaEmpresa+"</td>");
                         out.print("<td class='bordeNegroTd' align='left'>"+nombreEstadoProgramaProd+"</td>");
                         out.print("<td class='bordeNegroTd' align='left'>"+registroSanitario+"</td>");
                         out.print("<td class='bordeNegroTd' style='background-color:#ffeb9a'  align='left'>"+vidaUtil+"</td>");
                         out.print("<td class='bordeNegroTd' style='background-color:#ffeb9a' align='left'>"+(fechaVencimiento!=null?sdf1.format(fechaVencimiento):"")+"</td>");
                         out.print("</tr>");
                   
                    }
                    }catch(Exception e){
                        e.printStackTrace();
                    }
                %>
                
            </table>
            <br>
            
            <br>
            <div align="center" >
                <%--<INPUT type="button" class="commandButton" name="btn_registrar" value="<-- Atrás" onClick="cancelar();"  >--%>

            </div>
        </form>
    </body>
</html>
