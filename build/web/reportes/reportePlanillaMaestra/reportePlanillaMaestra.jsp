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
public String buscaNombreMes(String codMes){
    String nombreMes = "";
    try{
        con= Util.openConnection(con);
        String consulta = " select m.NOMBRE_MES from MESES m where m.COD_MES = '"+codMes+"'";
        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        ResultSet rs=st.executeQuery(consulta);
        if(rs.next()){
            nombreMes = rs.getString("NOMBRE_MES");
        }

    }catch(Exception e){
        e.printStackTrace();
    }
    
    return nombreMes;
}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../js/general.js"></script>
    </head>
    <body>
        <form>
            <h4 align="center">Reporte Planilla Maestra</h4>
           
                    <%
                    try {

                        String fechaProduccion = "10/10/2010";                        
                        String codAreaEmpresa = "80,81";
                        String nombreAreaEmpresa = "80,81";

                        if(request.getParameter("fecha_produccion")!=null){
                            fechaProduccion = request.getParameter("fecha_produccion");
                        }
                        if(request.getParameter("codAreaEmpresas")!=null){
                            codAreaEmpresa = request.getParameter("codAreaEmpresas");
                        }
                        if(request.getParameter("nombreAreaEmpresas")!=null){
                            nombreAreaEmpresa = request.getParameter("nombreAreaEmpresas");
                        }
                        String[] fechaProduccionArray= fechaProduccion.split("/");
                        String gestion = fechaProduccionArray[2];
                        String mes = fechaProduccionArray[1];
                        
                        NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
                        DecimalFormat formato = (DecimalFormat) numeroformato;
                        formato.applyPattern("#,###.##;-#,###.##");

                        SimpleDateFormat fechaFormato=new SimpleDateFormat("dd/MM/yyyy");

                        String nombreMes = this.buscaNombreMes(mes);

                        con = Util.openConnection(con);

                        

                         //System.out.println("las fechas en el reporte" + desdeFecha + " " +hastaFecha );


                    %>
              
            <div class="outputText0" align="center">                
                AREA(S) : <%=nombreAreaEmpresa%><br>
                GESTION : <%=gestion%><br>
                MES : <%=nombreMes%>
            </div>
            
            <br>
            <table width="90%" align="center" class="outputText0" style="border : solid #000000 1px;" cellpadding="0" cellspacing="0" >
                
                
                <tr class="">                    
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='35%' align="center" ><b>Nombre Producto</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center" ><b>Forma Famaceutica</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Presentacion Unitaria</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center"><b>Lote Estandard</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Lote No</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2" width='5%' align="center"><b>Fecha de Fabricacion</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Unidades Programadas</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Unidades Entregadas a Control de Calidad</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Unidades de Mermas</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Fecha de Entrega a acondicionamiento</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Unidades Producidas</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Horas Hombre</b></td>
                    <td align="center" style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2" width='5%' align="center"><b>Horas Maquina</b></td>
                </tr>                
               
                                
                                <%
                             String consultaProduccion= " select fm.COD_FORMULA_MAESTRA,cp.nombre_prod_semiterminado,  " +
                                     " (select ff.abreviatura_forma from FORMAS_FARMACEUTICAS ff where ff.cod_forma = cp.COD_FORMA) abreviatura_forma,  " +
                                     " (select ep.NOMBRE_ENVASEPRIM from ENVASES_PRIMARIOS ep where ep.COD_ENVASEPRIM = cp.COD_ENVASEPRIM) NOMBRE_ENVASEPRIM, " +
                                     " '' presentacion_unitaria,  " +
                                     " fm.CANTIDAD_LOTE,  " +
                                     " ppr.COD_LOTE_PRODUCCION,  " +
                                     " '' fecha_fabricacion, isnull(ppr.CANT_LOTE_PRODUCCION,0) * isnull(fm.CANTIDAD_LOTE,0) unidades_programadas, " +
                                     " (select sum(ISNULL(ida.CANT_INGRESO_PRODUCCION,'0')) from INGRESOS_DETALLEACOND ida where ida.COD_LOTE_PRODUCCION = ppr.COD_LOTE_PRODUCCION and ida.COD_COMPPROD=ppr.COD_COMPPROD) UNIDADES_PRODUCIDAS,  " +
                                     " (select sum(ISNULL( sda.CANT_CC,'0')) from SALIDAS_DETALLEACOND sda where sda.COD_LOTE_PRODUCCION =ppr.COD_LOTE_PRODUCCION and sda.COD_COMPPROD=ppr.COD_COMPPROD) CANT_CC, " +
                                     " 0 CANT_MERMAS,  " +
                                     " ia.fecha_ingresoacond " +
                                     " ,(select sum(ida.CANT_INGRESO_PRODUCCION)  from INGRESOS_ACOND ia   " +
                                     " inner join INGRESOS_DETALLEACOND ida on ia.COD_INGRESO_ACOND = ida.COD_INGRESO_ACOND  " +
                                     " where ida.COD_LOTE_PRODUCCION =ppr.COD_LOTE_PRODUCCION and ida.COD_COMPPROD = ppr.COD_COMPPROD) CANT_INGRESO_PRODUCCION " +
                                     " ,(select sum(cast(tabla.HORAS_HOMBRE as float)) from ( select (select top 1 sppr.HORAS_HOMBRE HORAS_HOMBRE from SEGUIMIENTO_PROGRAMA_PRODUCCION sppr  " +
                                     " where sppr.COD_ACTIVIDAD_PROGRAMA = afm.COD_ACTIVIDAD_FORMULA " +
                                     " and sppr.COD_PROGRAMA_PROD = ppr.COD_PROGRAMA_PROD " +
                                     " and sppr.COD_LOTE_PRODUCCION = ppr.COD_LOTE_PRODUCCION " +
                                     " and sppr.COD_FORMULA_MAESTRA = ppr.COD_FORMULA_MAESTRA " +
                                     " and sppr.COD_COMPPROD = ppr.COD_COMPPROD " +
                                     " order by sppr.COD_SEGUIMIENTO_PROGRAMA desc) HORAS_HOMBRE " +
                                     " from ACTIVIDADES_FORMULA_MAESTRA afm where afm.COD_FORMULA_MAESTRA = ppr.COD_FORMULA_MAESTRA) tabla ) HORAS_HOMBRE " +
                                     " ,(select sum(cast(tabla.HORAS_MAQUINA as float)) from ( select (select top 1 sppr.HORAS_MAQUINA HORAS_MAQUINA from SEGUIMIENTO_PROGRAMA_PRODUCCION sppr  " +
                                     " where sppr.COD_ACTIVIDAD_PROGRAMA = afm.COD_ACTIVIDAD_FORMULA " +
                                     " and sppr.COD_PROGRAMA_PROD = ppr.COD_PROGRAMA_PROD " +
                                     " and sppr.COD_LOTE_PRODUCCION = ppr.COD_LOTE_PRODUCCION  " +
                                     " and sppr.COD_FORMULA_MAESTRA = ppr.COD_FORMULA_MAESTRA " +
                                     " and sppr.COD_COMPPROD = ppr.COD_COMPPROD " +
                                     " order by sppr.COD_SEGUIMIENTO_PROGRAMA desc) HORAS_MAQUINA " +
                                     " from ACTIVIDADES_FORMULA_MAESTRA afm where afm.COD_FORMULA_MAESTRA = ppr.COD_FORMULA_MAESTRA) tabla ) HORAS_MAQUINA " +
                                     " from PROGRAMA_PRODUCCION ppr " +
                                     " inner join COMPONENTES_PROD cp on ppr.COD_COMPPROD = cp.COD_COMPPROD " +
                                     " inner join FORMULA_MAESTRA fm on fm.COD_COMPPROD = cp.COD_COMPPROD" +
                                     " inner join INGRESOS_DETALLEACOND ida on ida.COD_LOTE_PRODUCCION = ppr.COD_LOTE_PRODUCCION and ida.COD_COMPPROD = ppr.COD_COMPPROD " +
                                     " inner join INGRESOS_ACOND ia on ia.COD_INGRESO_ACOND = ida.COD_INGRESO_ACOND" +
                                     " where month(ia.fecha_ingresoacond)= '"+mes+"'  " +
                                     " and year(ia.fecha_ingresoacond)= '"+gestion+"' " +
                                     " and cp.COD_AREA_EMPRESA in ("+codAreaEmpresa+")  " +
                                     " order by cp.nombre_prod_semiterminado" +
                                     " asc";
                                    //setCon(Util.openConnection(getCon()));
                            System.out.println("consulta programa produccion "+ consultaProduccion);


                            Statement stProduccion=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            ResultSet rsProduccion=stProduccion.executeQuery(consultaProduccion);
                            
                            
                            
                            while(rsProduccion.next()){
                                String nombreProductoSemiterminado = rsProduccion.getString("nombre_prod_semiterminado");
                                String abreviaturaForma = rsProduccion.getString("abreviatura_forma");
                                String nombreEnvasePrimario = rsProduccion.getString("NOMBRE_ENVASEPRIM");
                                float cantidadLote = rsProduccion.getFloat("CANTIDAD_LOTE");
                                String codLoteProduccion= rsProduccion.getString("COD_LOTE_PRODUCCION");
                                String fechaFabricacion = rsProduccion.getString("fecha_fabricacion");
                                float unidadesProgramadas = rsProduccion.getFloat("unidades_programadas");
                                float unidadesProducidas = rsProduccion.getFloat("UNIDADES_PRODUCIDAS");
                                float unidadesEnviadasControlCalidad = rsProduccion.getFloat("CANT_CC");
                                float cantidadMermas = rsProduccion.getFloat("CANT_MERMAS");
                                Date fechaIngresoAcondicionamiento = rsProduccion.getDate("fecha_ingresoacond");
                                float cantidadIngresosProduccion = rsProduccion.getFloat("CANT_INGRESO_PRODUCCION");
                                float horasMaquina = rsProduccion.getFloat("HORAS_MAQUINA");
                                float horasHombre = rsProduccion.getFloat("HORAS_HOMBRE");
                                
                                cantidadMermas= unidadesProgramadas-(cantidadIngresosProduccion+unidadesEnviadasControlCalidad);
                                out.print("<tr>");
                                out.print("<td align='left'  style='border : solid #D8D8D8 1px' >"+nombreProductoSemiterminado+"</td>");
                                out.print("<td  class='border' style='border : solid #D8D8D8 1px'  >"+(abreviaturaForma==null?"":abreviaturaForma)+"</td>");
                                out.print("<td  class='border' style='border : solid #D8D8D8 1px'  >"+(nombreEnvasePrimario==null?"":nombreEnvasePrimario)+"</td>");
                                out.print("<td align='center' style='border : solid #D8D8D8 1px' class='border'   >"+formato.format(cantidadLote)+"</td>");
                                out.print("<td align='center' style='border : solid #D8D8D8 1px' class='border'   >"+codLoteProduccion+"</td>");
                                out.print("<td align='center' style='border : solid #D8D8D8 1px' class='border'   >"+ fechaFabricacion+"</td>");
                                out.print("<td align='center' style='border : solid #D8D8D8 1px' class='border'  >"+formato.format(unidadesProgramadas)+"</td>");
                                out.print("<td align='right' style='border : solid #D8D8D8 1px' class='border'  >"+formato.format(unidadesEnviadasControlCalidad)+"</td>");
                                out.print("<td align='right' style='border : solid #D8D8D8 1px' class='border'   >"+formato.format(cantidadMermas)+"</td>");
                                out.print("<td align='right' style='border : solid #D8D8D8 1px' class='border'   >"+(fechaIngresoAcondicionamiento==null?"":fechaFormato.format(fechaIngresoAcondicionamiento))+"</td>");
                                out.print("<td align='right' style='border : solid #D8D8D8 1px' class='border'   >"+formato.format(cantidadIngresosProduccion)+"</td>");
                                out.print("<td align='right' style='border : solid #D8D8D8 1px' class='border'   >"+horasMaquina+"</td>");
                                out.print("<td align='right' style='border : solid #D8D8D8 1px' class='border'   >"+horasHombre+"</td>");
                                out.print("</tr>");
                        }


               %>
               </table>                   
                
                <%                
                
                    if (con!=null){
                        con.close();
                        stProduccion.close();
                        rsProduccion.close();
                        rsProduccion=null;
                    }
                  
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
