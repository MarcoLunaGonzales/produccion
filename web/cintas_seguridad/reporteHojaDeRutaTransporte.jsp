
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
<%! Connection con=null;


%>
<%! public String nombrePresentacion1(String codPresentacion){
    

 
String  nombreproducto="";

try{
con=Util.openConnection(con);
String sql_aux="select cod_presentacion, nombre_producto_presentacion from presentaciones_producto where cod_presentacion='"+codPresentacion+"'";
System.out.println("PresentacionesProducto:sql:"+sql_aux);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet rs=st.executeQuery(sql_aux);
while (rs.next()){
String codigo=rs.getString(1);
nombreproducto=rs.getString(2);
}
} catch (SQLException e) {
e.printStackTrace();
    }
    return "";
}

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        
        <%--meta http-equiv="Content-Type" content="text/html; charset=UTF-8"--%>
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
        <STYLE TYPE="text/css">
                .fila {
                border-bottom-color:gray;border-bottom-style:solid;border-bottom-width:thin
                }



        </STYLE>
    </head>
    <body>
        
        <br>
        <form>
            <table align="center" width="90%">

                <%
                try{
                NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat format = (DecimalFormat)nf;
                format.applyPattern("#,###.00");



                    String codProgramaProdPeriodo=request.getParameter("codProgramaProdPeriodo")==null?"0":request.getParameter("codProgramaProdPeriodo");
                    String nombreProgramaProdPeriodo=request.getParameter("nombreProgramaProduccion")==null?"0":request.getParameter("nombreProgramaProduccion");
                    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                    String fechaInicial=request.getParameter("fechaInicial")==null?"0":request.getParameter("fechaInicial");
                    String fechaFinal=request.getParameter("fechaFinal")==null?"0":request.getParameter("fechaFinal");
                    
                    String[] arrayFechaInicial = fechaInicial.split("/");
                    String[] arrayFechaFinal = fechaFinal.split("/");
                    ManagedCintasSeguridad.IngresoDetalleAcondCantidadPeso ingresoDetalleAcondCantidadPeso = (ManagedCintasSeguridad.IngresoDetalleAcondCantidadPeso)request.getSession().getAttribute("ingresoDetalleAcondCantidadPeso");
                    
                %>
             <table align="center" width="60%" class='outputText0'>
                <tr>
                    <td width="10%">
                        <img src="../img/cofar.png">
                    </td>
                <td align="center" width="80%">
                <h3 align="center">Hoja de Ruta de Transporte de Producto</h3>

                </td>
                <td align="center" >
                </td>
                </tr>
            </table>
            </table>
            <br>
            <br>
            <br>                
                <%
                
                String consulta = " SELECT IA.NRO_INGRESOACOND, IDA.COD_INGRESO_ACOND,IDA.COD_COMPPROD,CP.nombre_prod_semiterminado," +
                        "IDA.COD_LOTE_PRODUCCION, IDA.FECHA_VEN,IDA.CANT_INGRESO_PRODUCCION,FM.CANTIDAD_LOTE,IA.FECHA_INGRESOACOND FROM INGRESOS_ACOND IA " +
                        " INNER JOIN INGRESOS_DETALLEACOND IDA ON IA.COD_INGRESO_ACOND = IDA.COD_INGRESO_ACOND " +
                        " INNER JOIN COMPONENTES_PROD CP ON IDA.COD_COMPPROD = CP.COD_COMPPROD " +
                        " INNER JOIN FORMULA_MAESTRA FM ON FM.COD_COMPPROD = CP.COD_COMPPROD " +
                        " WHERE IA.COD_INGRESO_ACOND = '"+ingresoDetalleAcondCantidadPeso.getIngresosAcondicionamiento().getCodIngresoAcond()+"' ";
                        
                System.out.println("consulta"+consulta);
                con = Util.openConnection(con);
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs=st.executeQuery(consulta);
                while (rs.next()){
                    int nroIngresoAcond = rs.getInt("NRO_INGRESOACOND");
                    int codIngresoAcond = rs.getInt("COD_INGRESO_ACOND");
                    int codCompProd = rs.getInt("COD_COMPPROD");
                    String nombreProdSemiterminado = rs.getString("nombre_prod_semiterminado");
                    String codLoteProduccion = rs.getString("COD_LOTE_PRODUCCION");
                    Date fechaVencimiento = rs.getDate("FECHA_VEN");
                    Double cantIngresoProduccion = rs.getDouble("CANT_INGRESO_PRODUCCION");
                    Double cantidadLote = rs.getDouble("CANTIDAD_LOTE");
                    Date fechaIngresoAcond = rs.getDate("FECHA_INGRESOACOND");
                    out.print("<table align='center' width='90%' class='outputText2' style='border : solid #f2f2f2 1px;' cellpadding='0' cellspacing='0'>");
                    out.print("<tr>");
                    out.print("<td class='bordeNegroTd' align='left'><b>Fecha Ingreso Acond.</b></td>");
                    out.print("<td class='bordeNegroTd' align='left'><b>Nro Ingreso Acond.</b></td>");
                    out.print("<td class='bordeNegroTd' align='left'><b>Producto</b></td>");
                    out.print("<td class='bordeNegroTd' align='left'><b>Lote</b></td>");
                    out.print("<td class='bordeNegroTd' align='left'><b>Cantidad Lote</b></td>");
                    out.print("<td class='bordeNegroTd' align='left'><b>Cantidad Ingreso Acond.</b></td>");
                    out.print("<td class='bordeNegroTd' align='left'><b>Fecha Vencimiento</b></td>");                    
                    out.print("</tr>");
                    
                    out.print("<tr>");
                    out.print("<td class='bordeNegroTd' align='left'>"+sdf.format(fechaIngresoAcond)+"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+nroIngresoAcond+"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+nombreProdSemiterminado+"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+codLoteProduccion+"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+format.format(cantidadLote)+"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+format.format(cantIngresoProduccion) +"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+sdf.format(fechaVencimiento)+"</td>");
                    out.print("</tr>");
                    out.print("</table><br/><br/>");
                    /*detalle*/
                    consulta = " select idcp.COD_INGRESODETALLE_CANTIDADPESO, idcp.COD_INGRESOVENTAS,  idcp.COD_PRESENTACION,  idcp.CANTIDAD," +
                            "  idcp.PESO,   idcp.cod_envase,   te.NOMBRE_ENVASE, idcp.NRO_CINTASEGURIDAD_1,  idcp.NRO_CINTASEGURIDAD_2 " +
                            " from INGRESODETALLE_CANTIDADPESO idcp " +
                            " inner join TIPOS_ENVASE te on idcp.cod_envase = te.COD_ENVASE " +
                            " where idcp.COD_INGRESOVENTAS = "+codIngresoAcond+"  ";
                    System.out.println("consulta " + consulta );
                    Statement st1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs1=st1.executeQuery(consulta);
                    out.print("<table align='center' width='90%' class='outputText2' style='border : solid #f2f2f2 1px;' cellpadding='0' cellspacing='0' >");
                    out.print("<tr>");
                    out.print("<td class='bordeNegroTd' align='left'><b>Cantidad</b></td>");
                    out.print("<td class='bordeNegroTd' align='left'><b>Peso</b></td>");
                    out.print("<td class='bordeNegroTd' align='left'><b>Envase</b></td>");
                    out.print("<td class='bordeNegroTd' align='left'><b>Nro Cinta de Seguridad 1</b></td>");
                    out.print("<td class='bordeNegroTd' align='left'><b>Nro Cinta de Seguridad 2</b></td>");
                    out.print("<td class='bordeNegroTd' align='left'><b>Observaciones</b></td>");
                    out.print("</tr>");
                    while(rs1.next()){
                        int codIngresoDetalleCantidadPeso = rs1.getInt("COD_INGRESODETALLE_CANTIDADPESO");
                        int codIngresoVentas = rs1.getInt("COD_INGRESOVENTAS");
                        int codPresentacion = rs1.getInt("COD_PRESENTACION");
                        float cantidad = rs1.getFloat("CANTIDAD");
                        float peso = rs1.getFloat("PESO");
                        int codEnvase = rs1.getInt("COD_ENVASE");
                        String nombreEnvase = rs1.getString("NOMBRE_ENVASE");
                        int nroCintaSeguridad1 = rs1.getInt("NRO_CINTASEGURIDAD_1");
                        int nroCintaSeguridad2 = rs1.getInt("NRO_CINTASEGURIDAD_2");
                                out.print("<tr>");
                                out.print("<td class='bordeNegroTd' align='left'>"+cantidad+"</td>");
                                out.print("<td class='bordeNegroTd' align='left'>"+peso+"</td>");
                                out.print("<td class='bordeNegroTd' align='left'>"+nombreEnvase+"</td>");
                                out.print("<td class='bordeNegroTd' align='left'>"+nroCintaSeguridad1+"</td>");
                                out.print("<td class='bordeNegroTd' align='left'>"+nroCintaSeguridad2+"</td>");
                                out.print("<td class='bordeNegroTd' align='left'></td>");                                
                                out.print("</tr>");
                    }
                    out.print("</table>");
                    }
                }catch(Exception e){
                e.printStackTrace();
                }
                %>
                <BR/><BR/>
                
                <br/><br/>
                <table align='center' width='90%' class='outputText2' >
                    <tr style="height:15px"><td class="fila">Rendimiento (%)</td><td></td></tr>
                    <tr style="height:15px"><td class="fila">Productividad (und/hh)</td><td></td></tr>
                    <tr><td>&nbsp;</td><td></td></tr>
                    <tr style="height:15px"><td class="fila" colspan="2">Responsable de la entrega de producto a transporte:</td></tr>
                    <tr style="height:15px"><td class="fila" colspan="2">Responsable del transporte:</td></tr>
                    <tr style="height:15px"><td class="fila">Fecha de envio:</td><td class="fila">Hora de envio:</td></tr>
                    <tr style="height:15px"><td class="fila">Fecha de recepcion: </td><td class="fila">Hora de recepción:</td></tr>
                    <tr style="height:15px"><td class="fila">Nombre encargado de recepción:</td><td class="fila"> Firma:</td></tr>
                    <tr style="height:15px"><td class="fila" colspan="2">Observaciones de recepción</td></tr>
                    <tr style="height:15px"><td></td></tr>
                    <tr style="height:15px"><td></td></tr>
                </table>
         </form>
    </body>
</html>