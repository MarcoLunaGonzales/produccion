package evaluaProveedores;

<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%
//out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
System.out.println("entro");
String codMaterial=request.getParameter("codMaterial");
String codPeriodo=request.getParameter("codPeriodo");
String codProveedor=request.getParameter("codProveedor");
String codCategoriaProveedor=request.getParameter("codCategoriaProveedor");
String puntaje=request.getParameter("puntaje");
String codPeriodoEvaluacion=request.getParameter("codPeriodoEvaluacion");
String fecha=request.getParameter("fecha");
String codOrdenCompra=request.getParameter("codOrdenCompra");
String consulta = "  ";

String[] fechaArray = fecha.split("/");
//System.out.println("consulta Programa Produccion"+codMaterial);
Connection con=null;
con=Util.openConnection(con);
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
consulta = " INSERT INTO EVALUACION_PROVEEDORES_MATERIAL(COD_PROVEEDOR,COD_MATERIAL,COD_ESTADO_REGISTRO,COD_CATEGORIA_PROVEEDOR," +
        " PUNTUACION_TOTAL,  COD_PERIODO_EVALUACION,  FECHA_COMPRAS,  FECHA_CONTROL,  NRO_ORDEN_COMPRA,  COD_ORDEN_COMPRA) " +
        " VALUES (  '"+codProveedor+"',  '"+codMaterial+"',  '1',  '"+codCategoriaProveedor+"',  '"+puntaje+"'," +
        " '"+codPeriodoEvaluacion+"',  '"+fechaArray[2]+"/"+fechaArray[1]+"/"+fechaArray[0]+"',  '',  '', '"+codOrdenCompra+"');  ";
System.out.println("consulta " + consulta);
st.executeUpdate(consulta);
//ResultSet rs=st.executeQuery(consulta);
//out.println("<select name='codAreaEmpresa' size='15' class='inputText' multiple onchange='ajaxProductos(form1);form1.chk_todoArea.checked=false;'>");
//while(rs.next()){
    //out.println("<option value=\" "+rs.getString("COD_AREA_EMPRESA")+" \">"+rs.getString("NOMBRE_AREA_EMPRESA")+"</option>");
//}
//out.println("</select>");
//out.println("<input type='checkbox'  onclick='selecccionarTodoArea(form1)' name='chk_todoArea' >Todo");
%>
