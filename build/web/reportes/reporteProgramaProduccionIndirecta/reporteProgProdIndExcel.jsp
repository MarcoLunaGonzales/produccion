

<%@ page contentType="application/vnd.ms-excel"%>
<%--@page contentType="text/html"--%>
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

cdcdcd
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
    </head>
    <body>
        <form>
            
<%
                    try {
                        String fechaInicio=request.getParameter("fecha_inicio");
                        String fechaFinal=request.getParameter("fecha_final");
                        String nombresProgramaPeriodo=request.getParameter("nomProgPeriodo")==null?"":request.getParameter("nomProgPeriodo");
                        String nombreTipoActividad=request.getParameter("nomTipoActividad")==null?"":request.getParameter("nomTipoActividad");
                        
                        String codTipoActividad=request.getParameter("codFormulaMaestraP");
                        String nombreTiposActvidad=request.getParameter("nombreProductoP");
                        String codProgProd=request.getParameter("codProg");
                        String nombreProgProg=request.getParameter("nombreProg");
                        String todoProd=request.getParameter("codTodoProg");
                        String todoActividad=request.getParameter("codTodoActividad");
                        System.out.println("programa "+nombreProgProg+"actividades "+nombreTiposActvidad);
                        String[] arrayCodComprod=codProgProd.split(",");
                        String[] arraynombresProg=nombreProgProg.split(",");
                        String[] arrayCodAreas=codTipoActividad.split(",");
                        String[] arrayNombreAreas=nombreTiposActvidad.split(",");
                        NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
                        DecimalFormat formato = (DecimalFormat) numeroformato;
                        formato.applyPattern("#,###.##;(#,###.##)");

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
            <table  align="center" width="60%" class="outputTextNormal" style="border : solid #f2f2f2 1px;" cellpadding="0" cellspacing="0">

                <tr class="tablaFiltroReporte" bgcolor="#dddddd">
                    <td  align="center" class="bordeNegroTd" width="20%" ><b>Programa Produccion</b></td>
                    <td  align="center" class="bordeNegroTd" width="20%" ><b>Area</b></td>
                    <td  align="center" class="bordeNegroTd"><b>Orden</b></td>
                    <td  align="center" class="bordeNegroTd"><b>Actividad</b></td>
                    <td  align="center" class="bordeNegroTd"><b>Personal</b></td>
                    <td  align="center" class="bordeNegroTd"><b>Horas Hombre Personal</b></td>
                    <td  align="center" class="bordeNegroTd"><b>Fecha Inicio</b></td>
                    <td  align="center" class="bordeNegroTd"><b>fecha Final</b></td>
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
                String consulta="";
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet res=null;
                int contProd=0;
                int contAreas=0;
                String nombreActividad="";
                float horasHombre=0;
                int orden=0;
                double totalHorasHombreActividad = 0.0;
                int codActividad = 0;
                DecimalFormat df = new DecimalFormat("###.00");
                SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy HH:mm");
                for(int i=0;i<arrayCodComprod.length;i++)
                {
                    for(int j=0;j<arrayCodAreas.length;j++)
                    {
                         consulta="select appi.COD_ACTIVIDAD, sppi.HORAS_HOMBRE,appi.ORDEN,ap.NOMBRE_ACTIVIDAD,"+
                                  " case when p.COD_PERSONAL>0 then(p.AP_PATERNO_PERSONAL + ' ' + p.AP_MATERNO_PERSONAL + ' ' +p.NOMBRES_PERSONAL + ' ' + p.nombre2_personal) "+
                                  " else (pt.AP_PATERNO_PERSONAL + ' ' + pt.AP_MATERNO_PERSONAL + ' ' +pt.NOMBRES_PERSONAL + ' ' + pt.nombre2_personal) end as nombrePersonal,"+
                                  " sppip.HORAS_HOMBRE horas_hombre_personal,sppip.FECHA_INICIO,sppip.FECHA_FINAL,ppr.nombre_programa_prod, ae.nombre_area_empresa,ae.cod_area_empresa "+
                                  " from programa_produccion_periodo ppr" +
                                  " inner join SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO sppi on sppi.cod_programa_prod = ppr.cod_programa_prod " +
                                  " inner join ACTIVIDADES_PROGRAMA_PRODUCCION_INDIRECTO appi on appi.COD_ACTIVIDAD=sppi.COD_ACTIVIDAD and appi.COD_AREA_EMPRESA=sppi.COD_AREA_EMPRESA and sppi.COD_ESTADO_REGISTRO=1 "+
                                  " inner join ACTIVIDADES_PRODUCCION ap on ap.COD_ACTIVIDAD=appi.COD_ACTIVIDAD "+
                                  " inner join SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO_PERSONAL sppip on "+
                                  " sppip.COD_AREA_EMPRESA=sppi.COD_AREA_EMPRESA and sppip.COD_ACTVIDAD=sppi.COD_ACTIVIDAD"+
                                  " and sppip.COD_PROGRAMA_PROD=sppi.COD_PROGRAMA_PROD"+
                                  " left outer join personal p on p.COD_PERSONAL = sppip.COD_PERSONAL"+
                                  " left outer join PERSONAL_TEMPORAL pt on pt.COD_PERSONAL=sppip.COD_PERSONAL" +
                                  " inner join areas_empresa ae on ae.cod_area_empresa = sppi.cod_area_empresa " +
                                  " where sppi.COD_AREA_EMPRESA="+arrayCodAreas[j]+" and sppi.COD_PROGRAMA_PROD="+arrayCodComprod[i]+
                                  (fechaInicio.equals("")||fechaFinal.equals("")?"":" and sppip.FECHA_INICIO between '"+fechaInicio+" 00:00:00' and '"+fechaFinal+" 23:59:59'")+
                                  " order by appi.ORDEN,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL asc";
                         System.out.println("consulta cargar personal "+consulta);
                         res=st.executeQuery(consulta);
                         codActividad = 0;
                         while(res.next())
                             {
                             if(codActividad!=res.getInt("cod_actividad")){
                                 codActividad = res.getInt("cod_actividad");
                                 if(totalHorasHombreActividad>0){
                                 %>
                                 <tr bgcolor="#dddddd">
                                    <th  class="bordeNegroTd" >&nbsp;</th>
                                    <th  class="bordeNegroTd" >&nbsp;</th>
                                    <th  class="bordeNegroTd" >&nbsp;</th>
                                    <th  class="bordeNegroTd" >&nbsp;</th>
                                    <th  class="bordeNegroTd" >&nbsp;</th>
                                    <th  class="bordeNegroTd" ><%=df.format(totalHorasHombreActividad)%></th>
                                    <th  class="bordeNegroTd" >&nbsp;</th>
                                    <th  class="bordeNegroTd" >&nbsp;</th>
                                </tr>


                                 <%
                                 }
                                 totalHorasHombreActividad = 0;
                                 
                             }
                         %>
                                <tr>
                                    <th  class="bordeNegroTd" ><%=res.getString("nombre_programa_prod")%></th>
                                    <th  class="bordeNegroTd" ><%=res.getString("nombre_area_empresa")%></th>
                                    <th  class="bordeNegroTd" >&nbsp;</th>
                                    <th  class="bordeNegroTd" ><%=res.getString("NOMBRE_ACTIVIDAD")%></th>
                                    <th  class="bordeNegroTd" ><%=res.getString("nombrePersonal")%></th>
                                    <th  class="bordeNegroTd" ><%=df.format(res.getDouble("HORAS_HOMBRE_PERSONAL"))%></th>
                                    <th  class="bordeNegroTd" ><%=sdf.format(res.getTimestamp("FECHA_INICIO"))%></th>
                                    <th  class="bordeNegroTd" ><%=sdf.format(res.getTimestamp("FECHA_FINAL"))%></th>
                                </tr>

                                     <%
                                     totalHorasHombreActividad += res.getDouble("HORAS_HOMBRE_PERSONAL");
                                 }
                         }
                    }
                if(totalHorasHombreActividad>0){
                                 %>
                                 <tr bgcolor="#dddddd">
                                    <th  class="bordeNegroTd" >&nbsp;</th>
                                    <th  class="bordeNegroTd" >&nbsp;</th>
                                    <th  class="bordeNegroTd" >&nbsp;</th>
                                    <th  class="bordeNegroTd" >&nbsp;</th>
                                    <th  class="bordeNegroTd" >&nbsp;</th>
                                    <th  class="bordeNegroTd" ><%=df.format(totalHorasHombreActividad)%></th>
                                    <th  class="bordeNegroTd" >&nbsp;</th>
                                    <th  class="bordeNegroTd" >&nbsp;</th>
                                </tr>


                                 <%
                                 }
                                        %>
           </table>

                  
            <br>

            <br>
            <div align="center">
                <%--<INPUT type="button" class="commandButton" name="btn_registrar" value="<-- Atrás" onClick="cancelar();"  >--%>

            </div>
            <%
             }
            catch(SQLException ex)
             {
                        ex.printStackTrace();
               }
           %>
        </form>
    </body>
</html>
