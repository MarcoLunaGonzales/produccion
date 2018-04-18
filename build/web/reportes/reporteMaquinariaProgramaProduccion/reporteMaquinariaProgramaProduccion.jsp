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
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../js/general.js"></script>
    </head>
    <body>
        <form>
            <h4 align="center">Reporte Tiempos Standard por Maquinarias</h4>
           
                    <%
                    

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
                        

                        
/*
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

                         String arraydesde[]=desdeFecha.split("/");
                         desdeFecha=arraydesde[2] +"/"+ arraydesde[1]+"/"+arraydesde[0];

                         String arrayhasta[]=hastaFecha.split("/");
                         hastaFecha=arrayhasta[2]+"/"+arrayhasta[1]+"/"+arrayhasta[0];

                         Double totalHoraInicio=0.0d;
                         Double totalHoraFinal=0.0d;
                         
                         Double totalHorasHombre=0.0d;
                         Double totalHorasMaquina=0.0d;


                         //System.out.println("las fechas en el reporte" + desdeFecha + " " +hastaFecha );

*/                      
                        String arrayCodMaquinaria = request.getParameter("arrayCodMaquinaria")==null?"0":request.getParameter("arrayCodMaquinaria");
                        arrayCodMaquinaria=arrayCodMaquinaria.equals("")?"0":arrayCodMaquinaria;
                        System.out.println("arrayCodMaquinaria:"+arrayCodMaquinaria);
                        float totalHorasHombre =0;
                        float totalHorasMaquina=0;
                    %>
              
            <%--div class="outputText0" align="center">
                PROGRAMA PRODUCCION: <%= nombreProgramaProduccionPeriodo %> <br>
                AREA(S) : <%= arrayNombreAreaEmpresa %><br>
                DE <%= arraydesde[0] +"/"+ arraydesde[1]+"/"+arraydesde[2] %> <br>
                HASTA <%= arrayhasta[0] +"/"+ arrayhasta[1]+"/"+arrayhasta[2] %>
            </div--%>
            
            <br>
            <table width="60%" align="center" class="outputText0" style="border : solid #000000 1px;" cellpadding="0" cellspacing="0" >
                <tr bgcolor="#f2f2f2">                    
                    <td align='left'  style='border : solid #f2f2f2 1px;' width='70%'>Producto</td>
                    <td align='right' style='border : solid #f2f2f2 1px;' width='15%'>Horas Hombre</td>
                    <td align='right' style='border : solid #f2f2f2 1px;' width='15%'>Horas Maquina</td>                                        
                </tr>
                
                <%                
                
                String consulta=" select maq.COD_MAQUINA,maq.NOMBRE_MAQUINA from MAQUINARIAS maq where  maq.COD_MAQUINA in(  " +
                        " select maf.COD_MAQUINA from MAQUINARIA_ACTIVIDADES_FORMULA maf where maf.COD_ACTIVIDAD_FORMULA in( " +
                        " select afm.COD_ACTIVIDAD_FORMULA from ACTIVIDADES_FORMULA_MAESTRA afm )) and maq.COD_MAQUINA IN("+arrayCodMaquinaria+") order by maq.NOMBRE_MAQUINA asc";
                                
                System.out.println("consulta 1 "+ consulta);
                con=Util.openConnection(con);
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs = st.executeQuery(consulta);
                while (rs.next()) {
                    //System.out.println("consulta 1 "+ consulta);
                    String codMaquina= rs.getString("COD_MAQUINA");
                    String nombreMaquina= rs.getString("NOMBRE_MAQUINA");

                    
                %>
                <tr><td class="border"  align="left" colspan="3" ><b><%=nombreMaquina%></b></td></tr>

                                <%

                            String consultaProductoHorasHombreHorasMaquina=" select cp.nombre_prod_semiterminado,fm.COD_COMPPROD,sum(cast(maf.HORAS_HOMBRE as float)) SUM_HORAS_HOMBRE,sum(cast (maf.HORAS_MAQUINA as float)) SUM_HORAS_MAQUINA " +
                                    " from FORMULA_MAESTRA fm  " +
                                    " inner join ACTIVIDADES_FORMULA_MAESTRA afm on fm.COD_FORMULA_MAESTRA = afm.COD_FORMULA_MAESTRA " +
                                    " inner join MAQUINARIA_ACTIVIDADES_FORMULA maf on maf.COD_ACTIVIDAD_FORMULA = afm.COD_ACTIVIDAD_FORMULA " +
                                    " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = fm.COD_COMPPROD " +
                                    " where maf.COD_MAQUINA in ("+codMaquina+") and fm.COD_ESTADO_REGISTRO=1 group by cp.nombre_prod_semiterminado,fm.COD_COMPPROD ";
                                    //setCon(Util.openConnection(getCon()));
                            System.out.println("consulta 2 "+ consultaProductoHorasHombreHorasMaquina);


                            Statement stProdHorasHombreHorasMaquina=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            ResultSet rsProdHorasHombreHorasMaquina=stProdHorasHombreHorasMaquina.executeQuery(consultaProductoHorasHombreHorasMaquina);
                            totalHorasHombre=0;
                            totalHorasMaquina=0;
                            while(rsProdHorasHombreHorasMaquina.next()){
                                String nombreProdSemiterminado = rsProdHorasHombreHorasMaquina.getString("nombre_prod_semiterminado");
                                String codCompProd = rsProdHorasHombreHorasMaquina.getString("COD_COMPPROD");
                                float sumHorasHombre = rsProdHorasHombreHorasMaquina.getFloat("SUM_HORAS_HOMBRE");
                                float sumHorasMaquina = rsProdHorasHombreHorasMaquina.getFloat("SUM_HORAS_MAQUINA");
                                totalHorasHombre=totalHorasHombre+sumHorasHombre;
                                totalHorasMaquina=totalHorasMaquina+sumHorasMaquina ;

                                out.print("<tr>");
                                out.print("<td align='left'  style='border : solid #f2f2f2 1px;' width='70%'>"+nombreProdSemiterminado+"</td>");
                                out.print("<td align='right' style='border : solid #f2f2f2 1px;' width='15%'>"+formato.format(sumHorasHombre)+"</td>");
                                out.print("<td align='right' style='border : solid #f2f2f2 1px;' width='15%'>"+formato.format(sumHorasMaquina)+"</td>");
                                out.print("</tr>");
                            }
                            out.print("<tr>");
                            out.print("<td align='right'  style='border : solid #f2f2f2 1px;' bgcolor='#f2f2f2' width='70%'>TOTAL:</td>");
                            out.print("<td align='right' style='border : solid #f2f2f2 1px;' bgcolor='#f2f2f2' width='15%'>"+formato.format(totalHorasHombre)+"</td>");
                            out.print("<td align='right' style='border : solid #f2f2f2 1px;' bgcolor='#f2f2f2' width='15%'>"+formato.format(totalHorasMaquina)+"</td>");
                            out.print("</tr>");

                            %>
                
                <%
                    }
                %>
            </table>
            
            <br>
            
            <br>
            <div align="center">
                <%--<INPUT type="button" class="commandButton" name="btn_registrar" value="<-- Atrás" onClick="cancelar();"  >--%>

            </div>
        </form>
    </body>
</html>
