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
        <h3 align="center">Reporte de Explosion de Maquinaria</h3>
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
                    List programaProduccionList = (ArrayList)request.getSession().getAttribute("programaProduccionList");
                    ProgramaProduccion programaProduccion1 = (ProgramaProduccion) request.getSession().getAttribute("programaProduccion");
                    String consulta = "select p.NOMBRE_PROGRAMA_PROD from PROGRAMA_PRODUCCION_PERIODO p where p.COD_PROGRAMA_PROD = '"+programaProduccion1.getCodProgramaProduccion()+"'";
                    System.out.println("consulta " + consulta);
                    con = Util.openConnection(con);
                    Statement st2=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs2=st2.executeQuery(consulta);
                    String nombreProgramaProduccion = "";
                    if(rs2.next()){
                        nombreProgramaProduccion = rs2.getString("nombre_programa_prod");
                    }

                    String codigoTotal = "";
                    String nombreMaquinaTotal = "";
                    String codMaquinaTotal= "";
                    float horasHombreTotal = 0;
                    float horasMaquinaTotal = 0;
                    int diasHabilesTotal = 0;
                    int diasMesTotal = 0;
                    float horasHabilesTotal = 0;
                    float horasMesTotal = 0;
                    float horasMaquinaHabilesMes = 0;
                    


                    
                %>
                <table align="center" width="60%" class='outputText0'>
                <tr>
                    <td width="10%">
                        <img src="../../img/cofar.png">
                    </td>
                <td align="center" width="80%">
                    PROGRAMA PRODUCCION : <%=nombreProgramaProduccion%>
                <%--br>
                    Programa Produccion : <b><%=nombreProgramaProdPeriodo%></b>
                    <br><br>
                    Fecha Inicial : <b><%=fechaInicial%></b>
                    <br><br>
                    Fecha Final : <b><%=fechaFinal%></b--%>

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
                    <td  align="center" class="bordeNegroTd" width="20%" ><b>Codigo</b></td>
                    <td  align="center" class="bordeNegroTd" width="20%" ><b>Maquina</b></td>
                    <td  align="center" class="bordeNegroTd"><b>Horas Hombre</b></td>
                    <td  align="center" class="bordeNegroTd"><b>Horas Maquina</b></td>
                    <td  align="center" class="bordeNegroTd"><b>Horas Mantenimiento</b></td>
                    <td  align="center" class="bordeNegroTd"><b>Horas Mes Hombre</b></td>
                    <td  align="center" class="bordeNegroTd"><b>Horas Mes Maquina</b></td>
                    <%--td  align="center" class="bordeNegroTd"><b></b></td>
                    <td  align="center" class="bordeNegroTd"><b></b></td>
                    <td  align="center" class="bordeNegroTd"><b></b></td>
                    <td  align="center" class="bordeNegroTd"><b></b></td--%>
                </tr>

                <%
                
                consulta = "select codigo,NOMBRE_MAQUINA,cod_maquina,sum(horas_hombre) horas_hombre,sum(horas_maquina) horas_maquina,23 dias_habiles,31 dias_mes from( ";
                Iterator i = programaProduccionList.iterator();
                while(i.hasNext()){
                    ProgramaProduccion programaProduccion = (ProgramaProduccion) i.next();
                    consulta = consulta + " select maq.CODIGO,maq.NOMBRE_MAQUINA,m.COD_MAQUINA,m.HORAS_HOMBRE,m.HORAS_MAQUINA from PROGRAMA_PRODUCCION ppr inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_FORMULA_MAESTRA = ppr.COD_FORMULA_MAESTRA " +
                            "inner join MAQUINARIA_ACTIVIDADES_FORMULA m on m.COD_ACTIVIDAD_FORMULA = afm.COD_ACTIVIDAD_FORMULA and m.COD_ESTADO_REGISTRO = 1 " +
                            "inner join MAQUINARIAS maq on maq.COD_MAQUINA = m.COD_MAQUINA " +
                            "where ppr.COD_PROGRAMA_PROD = '"+programaProduccion.getCodProgramaProduccion()+"' " +
                            " and ppr.COD_FORMULA_MAESTRA = '"+programaProduccion.getFormulaMaestra().getCodFormulaMaestra()+"'" +
                            " and ppr.COD_LOTE_PRODUCCION = '"+programaProduccion.getCodLoteProduccion()+"' " +
                            " and ppr.COD_ESTADO_PROGRAMA = '"+programaProduccion.getEstadoProgramaProduccion().getCodEstadoProgramaProd()+"'" +
                            " and ppr.COD_COMPPROD = '"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'" +
                            " and ppr.COD_TIPO_PROGRAMA_PROD ='"+programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' " +
                            " union all ";
                }
                
                consulta = consulta + " select top 1 '','',0,0,0 from PROGRAMA_PRODUCCION" +
                         " ) as tabla group by nombre_maquina,cod_maquina,codigo";

                System.out.println("consulta"+consulta);
                
                con = Util.openConnection(con);
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet rs=st.executeQuery(consulta);


                while (rs.next()){
                    String codigo = rs.getString("codigo");
                    String nombreMaquina = rs.getString("nombre_maquina");
                    String codMaquina= rs.getString("cod_maquina");
                    float horasHombre = rs.getFloat("horas_hombre");
                    float horasMaquina = rs.getFloat("horas_maquina");
                    int diasHabiles = rs.getInt("dias_habiles");
                    int diasMes = rs.getInt("dias_mes");
                    float horasHabiles = diasHabiles *8;
                    float horasMes = diasMes * 8;
                    if(!nombreMaquina.equals("")){
                    out.print("<tr style='background-color:"+(horasMaquina>504?"#FF0000":"")+"'>");
                    out.print("<td class='bordeNegroTd' align='left'>"+codigo+"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+nombreMaquina+"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+format.format(horasHombre)+"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+format.format(horasMaquina)+"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+format.format(0)+"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+format.format(0)+"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+format.format(504)+"</td>");
                    //out.print("<td class='bordeNegroTd' align='left'>"+format.format(horasHabiles)+"</td>");
                    //out.print("<td class='bordeNegroTd' align='left'>"+format.format(horasMes)+"</td>");
                    //out.print("<td class='bordeNegroTd' align='left'>"+format.format(horasMaquina/horasHabiles)+"</td>");
                    //out.print("<td class='bordeNegroTd' align='left'>"+format.format(horasMaquina/horasMes)+"</td>");
                    out.print("</tr>");
                    horasHombreTotal += horasHombre;
                    horasMaquinaTotal += horasMaquina;
                    diasHabilesTotal =diasHabiles;
                    diasMesTotal = diasMes;
                    horasHabilesTotal = horasHabiles;
                    horasMaquinaHabilesMes = horasMaquinaHabilesMes+504;
                    }
               }
                    out.print("<tr>");
                    out.print("<td class='bordeNegroTd' align='left'></td>");
                    out.print("<td class='bordeNegroTd' align='left'></td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+format.format(horasHombreTotal)+"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+format.format(horasMaquinaTotal)+"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>0.0</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+format.format(5712)+"</td>");
                    out.print("<td class='bordeNegroTd' align='left'>"+format.format(horasMaquinaHabilesMes)+"</td>");
                    //out.print("<td class='bordeNegroTd' align='left'>"+format.format(horasHabilesTotal)+"</td>");
                    //out.print("<td class='bordeNegroTd' align='left'></td>");
                    //out.print("<td class='bordeNegroTd' align='left'></td>");
                    //out.print("<td class='bordeNegroTd' align='left'></td>");
                    out.print("</tr>");


             

                
                }catch(Exception e){
                e.printStackTrace();
                }
                %>
               
            </table>
            
        </form>
    </body>
</html>