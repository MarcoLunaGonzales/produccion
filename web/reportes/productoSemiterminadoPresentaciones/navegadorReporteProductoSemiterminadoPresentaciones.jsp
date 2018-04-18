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
        <h3 align="center">Reporte de Productos y Presentaciones</h3>
        <br>
        <form>
            <table align="center" width="90%">

                <%
                try{
                NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat format = (DecimalFormat)nf;
                format.applyPattern("#,###.00");



                    String codComponenteProd=request.getParameter("codComponenteProd")==null?"0":request.getParameter("codComponenteProd");
                    String nombreProductoSemiterminado=request.getParameter("nombreProductoSemiterminado")==null?"0":request.getParameter("nombreProductoSemiterminado");
                    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                    String fechaInicial=request.getParameter("fechaInicial")==null?"0":request.getParameter("fechaInicial");
                    String fechaFinal=request.getParameter("fechaFinal")==null?"0":request.getParameter("fechaFinal");
                    
                    //String[] arrayFechaInicial = fechaInicial.split("/");
                    //String[] arrayFechaFinal = fechaFinal.split("/");
                    
                %>
                <table align="center" width="60%" class='outputText0'>
                <tr>
                    <td width="10%">
                        <img src="../../img/cofar.png">
                    </td>
                    <%--td align="center" width="80%">
                <br>
                    Programa Produccion : <b><%=nombreProgramaProdPeriodo%></b>
                    <br><br>
                    Fecha Inicial : <b><%=fechaInicial%></b>
                    <br><br>
                    Fecha Final : <b><%=fechaFinal%></b>

                </td--%>
                <td align="center" >
                </td>
                </tr>
            </table>
            </table>
            <br>
            <br>
            <br>
                <H3 ALIGN="CENTER">PRESENTACIONES SECUNDARIAS</H3>
            <table  align="center" width="60%" class="outputText2" style="border : solid #f2f2f2 1px;" cellpadding="0" cellspacing="0">

                <tr class="tablaFiltroReporte">
                    <td  align="center" class="bordeNegroTd" width="20%" ><b>Producto</b></td>
                    <td  align="center" class="bordeNegroTd"><b>Presentacion</b></td>
                    <td  align="center" class="bordeNegroTd"><b>Estado</b></td>

                    <td  align="center" class="bordeNegroTd" width="5%"><b>Tipo Programa Produccion</b></td>
                    
                </tr>

                <%
                String consulta = " select cp.nombre_prod_semiterminado,prp.NOMBRE_PRODUCTO_PRESENTACION,e1.NOMBRE_ESTADO_REGISTRO,t.NOMBRE_TIPO_PROGRAMA_PROD " +
                        " from COMPONENTES_PRESPROD cprp  " +
                        " inner join COMPONENTES_PROD cp on cprp.COD_COMPPROD = cp.COD_COMPPROD "+(!codComponenteProd.equals("-1")?" and cp.cod_compprod='"+codComponenteProd+"' ":"")+" " +
                        " inner join PRESENTACIONES_PRODUCTO prp on cprp.COD_PRESENTACION = prp.cod_presentacion " +
                        " left outer join ESTADOS_REFERENCIALES e1 on e1.COD_ESTADO_REGISTRO = cprp.COD_ESTADO_REGISTRO " +
                        " left outer join TIPOS_PROGRAMA_PRODUCCION t on t.COD_TIPO_PROGRAMA_PROD = cprp.COD_TIPO_PROGRAMA_PROD " +
                        " order by cp.nombre_prod_semiterminado asc ";
                
                
                        
                
                System.out.println("consulta"+consulta);
                con = Util.openConnection(con);                            
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs=st.executeQuery(consulta);

                while (rs.next()){
                    String nombreProdSemiterminado = rs.getString("nombre_prod_semiterminado");
                    String nombreProductoPresentacion = rs.getString("NOMBRE_PRODUCTO_PRESENTACION");
                    String nombreEstadoRegistro = rs.getString("NOMBRE_ESTADO_REGISTRO");
                    String nombreTipoProgramaProd = rs.getString("NOMBRE_TIPO_PROGRAMA_PROD");
                    



                    out.print("<tr>");
                    out.print("<td class='bordeNegroTd' align='left'>"+(nombreProdSemiterminado==null?"":nombreProdSemiterminado)+"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+(nombreProductoPresentacion==null?"":nombreProductoPresentacion)+"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+(nombreEstadoRegistro==null?"":nombreEstadoRegistro)+"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+(nombreTipoProgramaProd==null?"":nombreTipoProgramaProd)+"</td>");
                    


                    out.print("</tr>");
                    }
                
                /*}catch(Exception e){
                e.printStackTrace();
                }*/
                %>
               
            </table>


            <H3 ALIGN="CENTER">PRESENTACIONES PRIMARIAS</H3>
            <table  align="center" width="60%" class="outputText2" style="border : solid #f2f2f2 1px;" cellpadding="0" cellspacing="0">

                <tr class="tablaFiltroReporte">
                    <td  align="center" class="bordeNegroTd" width="20%" ><b>Producto</b></td>
                    <td  align="center" class="bordeNegroTd"><b>Envase Primario</b></td>
                    <td  align="center" class="bordeNegroTd"><b>Cantidad</b></td>
                    <td  align="center" class="bordeNegroTd"><b>Estado</b></td>

                    <td  align="center" class="bordeNegroTd" width="5%"><b>Tipo Programa Produccion</b></td>

                </tr>

                <%
                consulta = " select cp.nombre_prod_semiterminado,prp.NOMBRE_PRODUCTO_PRESENTACION,e1.NOMBRE_ESTADO_REGISTRO,t.NOMBRE_TIPO_PROGRAMA_PROD " +
                        " from COMPONENTES_PRESPROD cprp  " +
                        " inner join COMPONENTES_PROD cp on cprp.COD_COMPPROD = cp.COD_COMPPROD "+(!codComponenteProd.equals("-1")?" and cp.cod_compprod='"+codComponenteProd+"' ":"")+" " +
                        " inner join PRESENTACIONES_PRODUCTO prp on cprp.COD_PRESENTACION = prp.cod_presentacion " +
                        " left outer join ESTADOS_REFERENCIALES e1 on e1.COD_ESTADO_REGISTRO = cprp.COD_ESTADO_REGISTRO " +
                        " left outer join TIPOS_PROGRAMA_PRODUCCION t on t.COD_TIPO_PROGRAMA_PROD = cprp.COD_TIPO_PROGRAMA_PROD " +
                        " order by cp.nombre_prod_semiterminado asc ";
                consulta = " select cp.nombre_prod_semiterminado,   ep.nombre_envaseprim,ppr.CANTIDAD,  e1.NOMBRE_ESTADO_REGISTRO," +
                        "  t.NOMBRE_TIPO_PROGRAMA_PROD from PRESENTACIONES_PRIMARIAS ppr	 " +
                        " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = ppr.COD_COMPPROD "+(!codComponenteProd.equals("-1")?" and cp.cod_compprod='"+codComponenteProd+"' ":"")+" " +
                        " inner join ENVASES_PRIMARIOS ep on ep.cod_envaseprim = ppr.COD_ENVASEPRIM" +
                        " left outer join ESTADOS_REFERENCIALES e1 on e1.COD_ESTADO_REGISTRO =  ppr.COD_ESTADO_REGISTRO " +
                        " left outer join TIPOS_PROGRAMA_PRODUCCION t on t.COD_TIPO_PROGRAMA_PROD = ppr.COD_TIPO_PROGRAMA_PROD " +
                        " order by cp.nombre_prod_semiterminado asc ";





                System.out.println("consulta"+consulta);
                con = Util.openConnection(con);
                Statement st1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs1=st1.executeQuery(consulta);

                while (rs1.next()){
                    String nombreProdSemiterminado = rs1.getString("nombre_prod_semiterminado");
                    String nombreEnvasePrim = rs1.getString("nombre_envaseprim");
                    int cantidad = rs1.getInt("cantidad");
                    String nombreEstadoRegistro = rs1.getString("NOMBRE_ESTADO_REGISTRO");
                    String nombreTipoProgramaProd = rs1.getString("NOMBRE_TIPO_PROGRAMA_PROD");




                    out.print("<tr>");
                    out.print("<td class='bordeNegroTd' align='left'>"+(nombreProdSemiterminado==null?"":nombreProdSemiterminado)+"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+(nombreEnvasePrim==null?"":nombreEnvasePrim)+"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+(cantidad)+"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+(nombreEstadoRegistro==null?"":nombreEstadoRegistro)+"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+(nombreTipoProgramaProd==null?"":nombreTipoProgramaProd)+"</td>");



                    out.print("</tr>");
                    }

                }catch(Exception e){
                e.printStackTrace();
                }
                %>

            </table>

            
            
        </form>
    </body>
</html>