<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@page import="java.util.*" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import = "java.text.DecimalFormat"%>
<%@ page import = "java.text.NumberFormat"%>
<%@ page import = "java.util.Locale"%> 
<%

String codCompProd=request.getParameter("codCompProd");
String codLote=request.getParameter("codLote");
String codTipoProgProd=request.getParameter("codTipoProgProd");
String codProgProd=request.getParameter("codProgProd");
String codFormula=request.getParameter("codFormula");
String fechaInicio=request.getParameter("fechaInicio");
String horaInicio=request.getParameter("horaInicio");
String fechaFinal=request.getParameter("fechaFinal");
String horaFinal=request.getParameter("horaFinal");
String[] arrayfecha=fechaInicio.split("/");
System.out.println("inicio guardado"+fechaInicio+" "+fechaFinal);
fechaInicio=arrayfecha[2]+"/"+arrayfecha[1]+"/"+arrayfecha[0];
arrayfecha=fechaFinal.split("/");
fechaFinal=arrayfecha[2]+"/"+arrayfecha[1]+"/"+arrayfecha[0];
String consulta="UPDATE PROGRAMA_PRODUCCION_CRONOGRAMA_DIAS SET "+
                " FECHA_INICIO = '"+fechaInicio+" "+horaInicio+"',"+
                " FECHA_FINAL = '"+fechaFinal+" "+horaFinal+"'"+
                " WHERE COD_PROGRAMA_PROD = '"+codProgProd+"' and "+
                " COD_COMPPROD = '"+codCompProd+"' and "+
                " COD_FORMULA_MAESTRA = '"+codFormula+"' and "+
                " COD_LOTE_PRODUCCION =  '"+codLote+"' and "+
                " COD_TIPO_PROGRAMA_PROD = '"+codTipoProgProd+"'  ";

System.out.println("consulta Insert"+consulta);
try
{
    Connection con=null;
    con=Util.openConnection(con);
    PreparedStatement pst=con.prepareStatement(consulta);
    if(pst.executeUpdate()>0)System.out.println("se actualizo el registro");
    pst.close();
    con.close();
}
catch(Exception ex)
{
    ex.printStackTrace();
}


%>
