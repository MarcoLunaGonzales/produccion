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
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../../js/general.js"></script>
    </head>
    <body>
        <h3 align="center">Reporte de Cintas de Seguridad</h3>
        <br>
        <form>
            <table align="center" width="90%">

                <%
                
                NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat form = (DecimalFormat)nf;
                form.applyPattern("#,###");                


                    String codProgramaProdPeriodo=request.getParameter("codProgramaProdPeriodo")==null?"0":request.getParameter("codProgramaProdPeriodo");
                    codProgramaProdPeriodo = "60";
                
                %>                
            </table>
            <br>
            <br>
            <br>
            <table  align="center" width="90%" class="outputText2" style="border : solid #f2f2f2 1px;" cellpadding="0" cellspacing="0">

                <tr class="tablaFiltroReporte">
                    <td  align="center" class="bordeNegroTd"><b>Producto</b></td>
                    <td  align="center" class="bordeNegroTd"><b>Lote</b></td>

                    <td  align="center" class="bordeNegroTd"><b>Nro de ingreso</b></td>
                    <td  align="center" class="bordeNegroTd"><b>Cantidad</b></td>

                    <td  align="center" class="bordeNegroTd"><b>Fecha de Ingreso</b></td>                    
                </tr>

                <%
                try{                


                String consulta = " SELECT IA.COD_INGRESO_ACOND,CP.nombre_prod_semiterminado,IDA.COD_LOTE_PRODUCCION,IA.NRO_INGRESOACOND,IDA.CANT_INGRESO_PRODUCCION,IA.fecha_ingresoacond  " +
                        " FROM INGRESOS_ACOND IA INNER JOIN INGRESOS_DETALLEACOND IDA ON IA.COD_INGRESO_ACOND = IDA.COD_INGRESO_ACOND " +
                        " INNER JOIN COMPONENTES_PROD CP ON CP.COD_COMPPROD = IDA.COD_COMPPROD " +
                        " WHERE IDA.COD_LOTE_PRODUCCION IN (SELECT PPR.COD_LOTE_PRODUCCION FROM PROGRAMA_PRODUCCION PPR WHERE PPR.COD_PROGRAMA_PROD = "+codProgramaProdPeriodo+" " +
                        " AND PPR.COD_ESTADO_PROGRAMA IN (1,2,6)) AND IA.COD_ESTADO_INGRESOACOND IN (1,4) ";

                System.out.println("consulta"+consulta);
                con = Util.openConnection(con);                            
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs=st.executeQuery(consulta);

                while (rs.next()){
                    String codIngresoAcond = rs.getString("COD_INGRESO_ACOND");
                    String nombreProdSemiterminado = rs.getString("nombre_prod_semiterminado");
                    String codLoteProduccion= rs.getString("COD_LOTE_PRODUCCION");
                    String nroIngresoAcond = rs.getString("NRO_INGRESOACOND");
                    String cantIngresoProduccion = rs.getString("CANT_INGRESO_PRODUCCION");
                    String fechaIngresoAcond=rs.getString("fecha_ingresoacond");
                    String[] arrayFechaIngresoAcond = fechaIngresoAcond.split(" ");
                    fechaIngresoAcond= arrayFechaIngresoAcond[0];
                    arrayFechaIngresoAcond = fechaIngresoAcond.split("-");

                    out.print("<tr>");
                    out.print("<td class='bordeNegroTd' align='right'>"+nombreProdSemiterminado+"</td>");
                    out.print("<td class='bordeNegroTd' align='right'>"+codLoteProduccion+"</td>");
                    out.print("<td class='bordeNegroTd' align='right'>"+nroIngresoAcond+"</td>");
                    out.print("<td class='bordeNegroTd' align='right'>"+cantIngresoProduccion +"</td>");
                    out.print("<td class='bordeNegroTd' align='right'>"+arrayFechaIngresoAcond[2]+"/"+arrayFechaIngresoAcond[1]+"/"+arrayFechaIngresoAcond[0] +"</td>");
                    out.print("</tr>");
                        //detalle de envases
                        String consultaDetalleCantidadPeso = " select idcp.COD_INGRESODETALLE_CANTIDADPESO,idcp.COD_INGRESOVENTAS,idcp.COD_PRESENTACION,idcp.CANTIDAD,idcp.PESO,idcp.cod_envase,te.NOMBRE_ENVASE,idcp.NRO_CINTASEGURIDAD_1,idcp.NRO_CINTASEGURIDAD_2 " +
                                " from INGRESODETALLE_CANTIDADPESO idcp inner join TIPOS_ENVASE te on idcp.cod_envase = te.COD_ENVASE " +
                                " where idcp.COD_INGRESOVENTAS =  "+codIngresoAcond+" ";
                        Statement stDetalleCantidadPeso = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        ResultSet rsDetalleCantidadPeso = stDetalleCantidadPeso.executeQuery(consultaDetalleCantidadPeso);
                        while(rsDetalleCantidadPeso.next()){
                            String codIngresoDetalleCantidadPeso = rsDetalleCantidadPeso.getString("COD_INGRESODETALLE_CANTIDADPESO");
                            int cantidad = rsDetalleCantidadPeso.getInt("CANTIDAD");
                            int peso = rsDetalleCantidadPeso.getInt("CANTIDAD");
                            String nombreEnvase = rsDetalleCantidadPeso.getString("NOMBRE_ENVASE");
                            int nroCintaSeguridad1 = rsDetalleCantidadPeso.getInt("NRO_CINTASEGURIDAD_1");
                            int nroCintaSeguridad2 = rsDetalleCantidadPeso.getInt("NRO_CINTASEGURIDAD_2");
                            out.print("<tr>");
                            out.print("<td class='bordeNegroTd' align='right'>"+cantidad+"</td>");
                            out.print("<td class='bordeNegroTd' align='right'>"+peso+"</td>");
                            out.print("<td class='bordeNegroTd' align='right'>"+nombreEnvase+"</td>");
                            out.print("<td class='bordeNegroTd' align='right'>"+nroCintaSeguridad1 +"</td>");
                            out.print("<td class='bordeNegroTd' align='right'>"+nroCintaSeguridad2 +"</td>");
                            out.print("</tr>");                            
                        }


                    }
                
                }catch(Exception e){
                e.printStackTrace();
                }
                %>
               
            </table>
            
            
            
        </form>
    </body>
</html>