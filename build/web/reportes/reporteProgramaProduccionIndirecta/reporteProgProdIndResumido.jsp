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
        <script src="../../js/general.js"></script>
        <script>
            function redondeo2decimales(numero)
                {
                var original=parseFloat(numero);
                var result=Math.round(original*100)/100 ;
                return result;
                }
        </script>
        <style>
            .tablaReporte
            {
                border-top:1px solid #cccccc;
                border-left:1px solid #cccccc;
            }
            .tablaReporte tr th
            {
                border-bottom:1px solid #cccccc;
                border-right:1px solid #cccccc;
                font-weight:normal;
                padding:3px;
            }
        </style>
    </head>
    <body>
        <form>
            
<%
                    try {
                        String fechaInicio=request.getParameter("fecha_inicio");
                        String fechaFinal=request.getParameter("fecha_final");
                        String nombresProgramaPeriodo=request.getParameter("nomProgPeriodo")==null?"":request.getParameter("nomProgPeriodo");
                        String nombreTipoActividad=request.getParameter("nomTipoActividad")==null?"":request.getParameter("nomTipoActividad");
                        String codTipoReporte=request.getParameter("codTipoReporte");
                        String codAreasEmpresa=request.getParameter("codFormulaMaestraP");
                        String nombreTiposActvidad=request.getParameter("nombreProductoP");
                        String codProgramaProd=request.getParameter("codProg");
                        String nombreProgProg=request.getParameter("nombreProg");
                        String todoProd=request.getParameter("codTodoProg");
                        String todoActividad=request.getParameter("codTodoActividad");
                        System.out.println("programa "+nombreProgProg+"actividades "+nombreTiposActvidad);

                        String[] arrayCodComprod=codProgramaProd.split(",");
                        String[] arraynombresProg=nombreProgProg.split(",");
                        String[] arrayCodAreas=codAreasEmpresa.split(",");
                        String[] arrayNombreAreas=nombreTiposActvidad.split(",");
                        NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
                        DecimalFormat formato = (DecimalFormat) numeroformato;
                        formato.applyPattern("#,###.##;(#,###.##)");
                        NumberFormat f1 = NumberFormat.getNumberInstance(Locale.ENGLISH);
                        DecimalFormat format = (DecimalFormat) f1;
                        format.applyPattern("###0.00");
                        SimpleDateFormat f=new SimpleDateFormat("dd/MM/yyyy");

                        con = Util.openConnection(con);
                    %>
                    <h4 align="center">Reporte Tiempos</h4>
            <table align="center" width="70%" class='outputText0'>
                <tr>
                    <td width="10%">
                        <img src="../../img/cofar.png">
                    </td>
                    <td align="center" width="80%">
                        <table class="outputTextNormal">
                            <tr>
                                <td align="left"><b>Programa Producción:</b></td>
                                <td align="left"><%=nombresProgramaPeriodo%></td>
                            </tr>
                            <tr>
                                <td align="left"><b>Tipo Actividad:</b></td>
                                <td align="left"><%=nombreTipoActividad%></td>
                            </tr>
                            <tr>
                                <td align="left"><b>Fecha Inicio:</b></td>
                                <td align="left"><%=(fechaInicio)%></td>
                            </tr>
                            <tr>
                                <td align="left"><b>Fecha Final:</b></td>
                                <td align="left"><%=(fechaFinal)%></td>
                            </tr>
                           </table>
                    </td>
                <td align="center" >
                </td>
                </tr>
            </table>
            
            
            </div>

            <br>
            <table  align="center" width="60%" class="tablaReporte" style="border : solid #f2f2f2 1px;" cellpadding="0" cellspacing="0">

                <tr class="tablaFiltroReporte" bgcolor="#dddddd">
                    <td  align="center" class="bordeNegroTd" width="20%" ><b>Programa Produccion</b></td>
                    <td  align="center" class="bordeNegroTd" width="20%" ><b>Area</b></td>
                    <td  align="center" class="bordeNegroTd"><b>Orden</b></td>
                    <td  align="center" class="bordeNegroTd"><b>Actividad</b></td>
                    <td  align="center" class="bordeNegroTd"><b>Horas Hombre Actividad</b></td>
                    

                </tr>
                <%
                if(!fechaInicio.equals("")&&!fechaFinal.equals(""))
                {
                    String[] aray=fechaInicio.split("/");
                    fechaInicio=aray[2]+"/"+aray[1]+"/"+aray[0];
                    aray=fechaFinal.split("/");
                    fechaFinal=aray[2]+"/"+aray[1]+"/"+aray[0];
                }
                String consulta="select ppr.COD_PROGRAMA_PROD,appi.COD_ACTIVIDAD,appi.ORDEN,"+
                                " ap.NOMBRE_ACTIVIDAD,ppr.nombre_programa_prod,ae.nombre_area_empresa,ae.cod_area_empresa,sum(sppip.HORAS_HOMBRE) as horasHombre"+
                                " from programa_produccion_periodo ppr inner join SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO sppi on"+
                                " sppi.cod_programa_prod = ppr.cod_programa_prod inner join ACTIVIDADES_PROGRAMA_PRODUCCION_INDIRECTO appi on"+
                                " appi.COD_ACTIVIDAD = sppi.COD_ACTIVIDAD and appi.COD_AREA_EMPRESA = sppi.COD_AREA_EMPRESA and sppi.COD_ESTADO_REGISTRO = 1"+
                                " inner join ACTIVIDADES_PRODUCCION ap on ap.COD_ACTIVIDAD =appi.COD_ACTIVIDAD"+
                                " inner join SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO_PERSONAL sppip on sppip.COD_AREA_EMPRESA = sppi.COD_AREA_EMPRESA and sppip.COD_ACTVIDAD ="+
                                " sppi.COD_ACTIVIDAD and sppip.COD_PROGRAMA_PROD = sppi.COD_PROGRAMA_PROD inner join areas_empresa ae on ae.cod_area_empresa = sppi.cod_area_empresa"+
                                " where sppi.COD_AREA_EMPRESA in ("+codAreasEmpresa+") and sppi.COD_PROGRAMA_PROD in ("+codProgramaProd+")" +
                                (fechaInicio.equals("")||fechaFinal.equals("")?"":" and sppip.FECHA_INICIO between '"+fechaInicio+" 00:00:00' and '"+fechaFinal+" 23:59:59'")+
                                " group by ppr.COD_PROGRAMA_PROD,appi.COD_ACTIVIDAD,appi.ORDEN,ap.NOMBRE_ACTIVIDAD,ppr.nombre_programa_prod,ae.nombre_area_empresa,ae.cod_area_empresa"+
                                " order by ppr.COD_PROGRAMA_PROD,ae.NOMBRE_AREA_EMPRESA,appi.ORDEN";
                System.out.println("consulta resumido "+consulta);
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet res=st.executeQuery(consulta);
                String innerHTMLArea="";
                int codProgramaProdCabecera=0;
                int contProgProd=0;
                int codAreaEmpresaCabecera=0;
                int contCodArea=0;
                int codActividadCabecera=0;
                int contCodActividad=0;
                double sumaHHactividad=0d;
                double sumaHHPrograma=0d;
                String nombreProgramaProd="";
                
                String innerHTMLActividad="";
                SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy HH:mm");
                        while(res.next())
                        {
                            if(codProgramaProdCabecera!=res.getInt("COD_PROGRAMA_PROD"))
                            {
                                if(codProgramaProdCabecera>0)
                                {
                                    res.previous();
                                    out.println("<tr><th  class='outputText2' style='border : solid #D8D8D8 1px' rowspan='"+contProgProd+"' >"+nombreProgProg+"</th>"+innerHTMLArea+
                                                                                    "<th rowspan='"+contCodArea+"'>"+res.getString("nombre_area_empresa")+"</th>"+innerHTMLActividad);
                                    out.println("<tr bgcolor='#FF8C00'><th colspan='4' align='right'><span style='font-weight:bold'>Total:</span></th><th><span style='font-weight:bold'>"+format.format(sumaHHPrograma)+"</span></th><tr>");
                                    res.next();
                                }
                                codProgramaProdCabecera=res.getInt("COD_PROGRAMA_PROD");
                                nombreProgProg=res.getString("nombre_programa_prod");
                                codAreaEmpresaCabecera=res.getInt("cod_area_empresa");
                                codActividadCabecera=res.getInt("COD_ACTIVIDAD");
                                contCodActividad=0;
                                contCodArea=0;
                                contProgProd=0;
                                innerHTMLActividad="";
                                innerHTMLArea="";
                                sumaHHactividad=0;
                                sumaHHPrograma=0;
                            }
                            if(codAreaEmpresaCabecera!=res.getInt("cod_area_empresa"))
                            {
                                res.previous();
                                innerHTMLArea+=(innerHTMLArea.equals("")?"":"<tr>")+"<th rowspan='"+contCodArea+"'>"+res.getString("nombre_area_empresa")+"</th>"+innerHTMLActividad;
                                res.next();
                                codAreaEmpresaCabecera=res.getInt("cod_area_empresa");
                                contCodArea=0;
                                innerHTMLActividad="";
                                contCodActividad=0;
                                sumaHHactividad=0;
                                codActividadCabecera=res.getInt("COD_ACTIVIDAD");
                            }
                            innerHTMLActividad+=(innerHTMLActividad.equals("")?"":"<tr>")+"<th  class='bordeNegroTd' ><span class='outputText2'>"+res.getInt("ORDEN")+"</span></th>"+
                                                                                         "<th  class='bordeNegroTd' ><span class='outputText2'>"+res.getString("NOMBRE_ACTIVIDAD")+"</span></th>"+
                                                                                         "<th  class='bordeNegroTd' ><span class='outputText2'>"+format.format(res.getDouble("horasHombre"))+"</span></th></tr>";
                                                                                         
                            sumaHHPrograma+=res.getDouble("horasHombre");
                            contProgProd++;
                            contCodArea++;
                           
                        }
                        if(codProgramaProdCabecera>0)
                        {
                            res.previous();
                            out.println("<tr><th  class='outputText2' style='border : solid #D8D8D8 1px' rowspan='"+contProgProd+"' >"+nombreProgProg+"</th>"+innerHTMLArea+
                                                                                    "<th rowspan='"+contCodArea+"'>"+res.getString("nombre_area_empresa")+"</th>"+innerHTMLActividad);
                                    out.println("<tr bgcolor='#FF8C00'><th colspan='4' align='right'><span style='font-weight:bold'>Total:</span></th><th><span style='font-weight:bold'>"+format.format(sumaHHPrograma)+"</span></th><tr>");
                                   
                        }
                }
                catch(SQLException ex)
                {
                    ex.printStackTrace();
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
