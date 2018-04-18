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
        <script src="../../js/general.js"></script>
    </head>
    <body>
        <h3 align="center">Reporte de Lotes pendientes de registro de tiempos</h3>
        <br>
        <form>
            <table align="center" width="90%">

                <%
                try{
                NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat format = (DecimalFormat)nf;
                format.applyPattern("#,###.00");


                    //int codComprod=Integer.valueOf(request.getParameter("codCompProd"));
                    String loteFiltro=request.getParameter("nroLote");
                    String codProgramaProdPeriodo=request.getParameter("codProgramaProdPeriodo")==null?"0":request.getParameter("codProgramaProdPeriodo");
                    String nombreProgramaProdPeriodo=request.getParameter("nombreProgramaProduccion")==null?"0":request.getParameter("nombreProgramaProduccion");
                    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                    //String fechaInicial=request.getParameter("fechaInicial")==null?"0":request.getParameter("fechaInicial");
                    //String fechaFinal=request.getParameter("fechaFinal")==null?"0":request.getParameter("fechaFinal");
                    
                    //String[] arrayFechaInicial = fechaInicial.split("/");
                    //String[] arrayFechaFinal = fechaFinal.split("/");
                    //String codEstadoProd=request.getParameter("codEstadoProd");
                %>
                <table align="center" width="60%" class='outputText0'>
                <tr>
                    <td width="10%">
                        <img src="../img/cofar.png">
                    </td>
                <td align="center" width="80%">
                <br>
                   
                    <br><br>
                    
                    <br><br>
                    

                </td>
                <td align="center" >
                </td>
                </tr>
            </table>
            </table>
            <br>
            <br>
            <br>
            <table  align="center" width="60%" class="outputText2" style="border : solid #f2f2f2 1px;" cellpadding="0" cellspacing="0">

                <tr class="tablaFiltroReporte">
                    <td  align="center" class="bordeNegroTd" width="20%" ><b>Lote</b></td>
                    <td  align="center" class="bordeNegroTd" width="20%" ><b>Producto</b></td>
                    <td  align="center" class="bordeNegroTd"><b>Tipo Programa Produccion</b></td>
                    <td  align="center" class="bordeNegroTd"><b>Fecha Ingreso Acond.</b></td>
                    
                    <td  align="center" class="bordeNegroTd" ><b>Entrega</b></td>
                </tr>

                <%
                
                String 
                  consulta = "  select p.COD_LOTE_PRODUCCION,c.nombre_prod_semiterminado,t.NOMBRE_TIPO_PROGRAMA_PROD,ia.fecha_ingresoacond,ta.NOMBRE_TIPO_ENTREGA_ACOND" +
                           " from programa_produccion p" +
                           " inner join COMPONENTES_PROD c on c.COD_COMPPROD = p.COD_COMPPROD" +
                           " inner join TIPOS_PROGRAMA_PRODUCCION t on t.COD_TIPO_PROGRAMA_PROD = p.COD_TIPO_PROGRAMA_PROD" +
                           " inner join PROGRAMA_PRODUCCION_INGRESOS_ACOND ppia on ppia.COD_PROGRAMA_PROD = p.COD_PROGRAMA_PROD" +
                           " and ppia.COD_COMPPROD = p.COD_COMPPROD and ppia.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and ppia.COD_TIPO_PROGRAMA_PROD = p.COD_TIPO_PROGRAMA_PROD" +
                           " and ppia.COD_LOTE_PRODUCCION = p.COD_LOTE_PRODUCCION" +
                           " inner join INGRESOS_ACOND ia on ia.COD_INGRESO_ACOND = ppia.COD_INGRESO_ACOND" +
                           " inner join TIPOS_ENTREGA_ACOND ta on ta.COD_TIPO_ENTREGA_ACOND = ppia.COD_TIPO_ENTREGA_ACOND" +
                           " where p.COD_PROGRAMA_PROD = '220'" +
                           " and p.FALTA_REGISTRO_TIEMPOS = '1' and ppia.COD_TIPO_ENTREGA_ACOND = 2";

                System.out.println("consulta"+consulta);
                con = Util.openConnection(con);                            
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs=st.executeQuery(consulta);

                while (rs.next()){
                    String codLoteProduccion  = rs.getString("COD_LOTE_PRODUCCION");
                    String nombreProdSemiterminado = rs.getString("nombre_prod_semiterminado");
                    String tipoProgramaProd= rs.getString("NOMBRE_TIPO_PROGRAMA_PROD");
                    Date fechaIngresoAcond=rs.getDate("fecha_ingresoacond");
                    String nombreTipoEntregaAcond = rs.getString("NOMBRE_TIPO_ENTREGA_ACOND");
                    



                    out.print("<tr>");
                    out.print("<td class='bordeNegroTd' align='left'>"+codLoteProduccion+"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+nombreProdSemiterminado+"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+tipoProgramaProd+"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+fechaIngresoAcond+"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+nombreTipoEntregaAcond+"</td>");

                    out.print("</tr>");
                    }
                rs.close();
                st.close();
                
                  %>
            </table><br/>
            
                  <%
            
                }catch(Exception e){
                e.printStackTrace();
                }
                %>           
            
        </form>
    </body>
</html>