
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
<%@ page import = "com.cofar.bean.*" %>
<%@ page language="java" import="java.util.*,com.cofar.util.CofarConnection" %>
<%@ page errorPage="ExceptionHandler.jsp" %>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        
        <%--meta http-equiv="Content-Type" content="text/html; charset=UTF-8"--%>
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../../../css/ventas.css" />
        <style>
            .tablaCabecera tr td
            {
                padding:0.2em;
            }
            .tablaDetalle
            {
                padding:0.5em;
            }
            .tablaDetalle thead tr td
            {
                padding:0.5em;
                border-bottom:1px solid #aaaaaa;
                border-left:1px solid #aaaaaa;
                background-color:#eeeeee;
                font-weight:bold;
            }
            .tablaDetalle tbody tr td
            {
                padding:0.5em;
                border-bottom:1px solid #aaaaaa;
                border-left:1px solid #aaaaaa;
            }
            .tablaDetalle
            {
                border-top:1px solid #aaaaaa;
                border-right:1px solid #aaaaaa;
            }
        </style>
    </head>
    <body>
        

                <%
                    Connection con=null;
                    NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                    DecimalFormat form = (DecimalFormat)nf;
                    form.applyPattern("#,###");
                    String codFormSalida=request.getParameter("codFormSalida");
                    int codAlmacen=0;
                    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                    
                %>
                <form target="_blank" id="form" name="form">
            
                <%
                    String observacion="";
                try{
                    
                    String consulta = " select g.NOMBRE_GESTION,t.NOMBRE_TIPO_SALIDA_ALMACEN,e.NOMBRE_ESTADO_SOLICITUD_SALIDA_ALMACEN,(p.NOMBRE_PILA+' '+p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL) NOMBRE_SOLICITANTE,ae.NOMBRE_AREA_EMPRESA " +
                                    " ,s.FECHA_SOLICITUD,s.COD_LOTE_PRODUCCION,s.OBS_SOLICITUD,s.orden_trabajo,a.NOMBRE_ALMACEN,s.cod_form_salida" +
                                    " ,isnull(m.NOMBRE_MAQUINA,'') AS NOMBRE_MAQUINA,ISNULL(ai.nombre_area_instalacion,'') as nombre_area_instalacion,isnull(m.COD_MAQUINA,0)as COD_MAQUINA,isnull(a.NOMBRE_ALMACEN,'') as NOMBRE_ALMACEN,s.COD_ALMACEN" +
                             " from SOLICITUDES_SALIDA s inner join GESTIONES g on g.COD_GESTION = s.COD_GESTION " +
                                    " inner join TIPOS_SALIDAS_ALMACEN t on t.COD_TIPO_SALIDA_ALMACEN = s.COD_TIPO_SALIDA_ALMACEN " +
                                    " inner join ESTADOS_SOLICITUD_SALIDAS_ALMACEN e on e.COD_ESTADO_SOLICITUD_SALIDA_ALMACEN = s.COD_ESTADO_SOLICITUD_SALIDA_ALMACEN " +
                                    " inner join PERSONAL p on p.COD_PERSONAL = s.SOLICITANTE " +
                                    " inner join AREAS_EMPRESA ae on s.AREA_DESTINO_SALIDA = ae.COD_AREA_EMPRESA " +
                                    " inner join ALMACENES a on a.COD_ALMACEN = s.COD_ALMACEN " +
                                     " left outer join PRESENTACIONES_PRODUCTO pp on s.COD_PRESENTACION=pp.cod_presentacion" +
                                     " left outer join COMPONENTES_PROD cp on s.COD_COMPPROD= cp.COD_COMPPROD" +
                                     " left outer join maquinarias m on m.cod_maquina = s.cod_maquina left outer join areas_instalaciones ai on ai.cod_area_instalacion = s.cod_area_instalacion " +
                               " where s.COD_FORM_SALIDA = '"+codFormSalida+"' ";
                    
                System.out.println("consulta"+consulta);
                con = Util.openConnection(con);
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet res=st.executeQuery(consulta);
                out.println("<table align='center' width='80%' border='0' style='text-align:left' class='outputText2 tablaCabecera'>");
                if(res.next()){
                    observacion=res.getString("OBS_SOLICITUD");
                    codAlmacen=res.getInt("COD_ALMACEN");
                        out.println("<tr><td colspan='5' class='outputTextBold' align='center'>SOLICITUD SALIDA DE "+res.getString("NOMBRE_ALMACEN")+"</td></tr>");
                        out.println("<tr>");
                                out.println("<td rowspan='6'><img src='../../../img/cofar.png' /></td>");
                                out.println("<td><b> Nro Solicitud Salida : </b></td><td colspan='3'> "+res.getString("cod_form_salida")+" </td>");
                        out.println("</tr>");
                        out.println("<tr>");
                                out.println("<td><b>Fecha de Solicitud Salida: </b></td><td> "+(res.getDate("FECHA_SOLICITUD")==null?"":sdf.format(res.getDate("FECHA_SOLICITUD")))+" </td> ");
                                out.println("<td><b>Maquina :</b></td> <td>"+res.getString("nombre_maquina")+"</td>");
                        out.println("</tr>");
                        out.println(" <tr>");
                                out.println("<td><b>Instalacion : </b></td> <td>"+res.getString("nombre_area_instalacion")+"</td>");
                                out.println("<td><b> Area/Dpto. Destino: </b></td> <td>"+res.getString("NOMBRE_AREA_EMPRESA")+"</td>");
                        out.println("</tr>");
                        out.println("<tr>");
                                out.println("<td><b>Tipo Salida: </b></td><td>"+res.getString("NOMBRE_TIPO_SALIDA_ALMACEN")+"</td>");
                                out.println("<td><b>Solicitante: </b></td><td>"+res.getString("NOMBRE_SOLICITANTE")+"</td>");
                        out.println("</tr>");
                        out.println("<tr>");
                                out.println("<td><b>Estado Solicitud: </b></td><td>"+res.getString("NOMBRE_ESTADO_SOLICITUD_SALIDA_ALMACEN")+"</td> <td></td><td></td>");
                        out.println("</tr>");
                        if(res.getInt("cod_maquina")>0)
                        {
                            out.println("<tr>");
                                    out.println("<td><b>Maquinaria.: </b></td><td>"+res.getString("nombre_maquina")+"</td> <td></td><td></td>");
                            out.println("</tr>");
                        }
                        out.println("<tr>");
                        out.println("<td><b>OT.: </b></td><td>"+res.getString("orden_trabajo")+"</td> <td></td><td></td> </tr> ");
                        out.println("</tr>");
                }
                out.print(" </table> ");
                out.println("</table>");
                System.out.println("termino");

            %>
            <br>

            <table  align="center" width="90%" class="tablaReporte" cellpadding="0" cellspacing="0">

            <thead>
                <tr >
                    <td  align="center" >Código</td>
                    <td  align="center" >Item</td>
                    <td  align="center" >Cantidad a solicitar</td>
                    <td  align="center" >Cantidad Existente</td>
                    <td  align="center" >Unidades</td>
                </tr>
            </thead>
            <tbody>
                <%
                consulta = " select m.CODIGO_ANTIGUO,m.cod_material,m.NOMBRE_MATERIAL,u.cod_unidad_medida,u.NOMBRE_UNIDAD_MEDIDA,u.ABREVIATURA,s.CANTIDAD,s.CANTIDAD_ENTREGADA" +
                         " ,isnull((select sum(iade.CANTIDAD_RESTANTE)"+
                         " from INGRESOS_ALMACEN_DETALLE_ESTADO iade inner join INGRESOS_ALMACEN ia on" +
                         " ia.COD_INGRESO_ALMACEN =iade.COD_INGRESO_ALMACEN"+
                         " where ia.COD_ALMACEN ="+codAlmacen+" and ia.COD_ESTADO_INGRESO_ALMACEN = 1 and"+
                         " iade.COD_MATERIAL = s.COD_MATERIAL),0) as cantidadExistente" +
                         " from SOLICITUDES_SALIDA_DETALLE s inner join materiales m on m.COD_MATERIAL = s.COD_MATERIAL " +
                         " inner join UNIDADES_MEDIDA u on u.COD_UNIDAD_MEDIDA = s.COD_UNIDAD_MEDIDA " +
                         " where s.COD_FORM_SALIDA = '"+codFormSalida+"' ";
                System.out.println("consulta"+consulta);                        
                ResultSet rs=st.executeQuery(consulta);

                while (rs.next()){                    
                    String codMaterial = rs.getString("COD_MATERIAL");
                    String nombreMaterial = rs.getString("NOMBRE_MATERIAL");
                    String codUnidadMedida = rs.getString("COD_UNIDAD_MEDIDA");
                    String abreviatura = rs.getString("ABREVIATURA");
                    float cantidadSolicitada = rs.getFloat("CANTIDAD");
                    float cantidadEntregada = rs.getFloat("CANTIDAD_ENTREGADA");
                    String codigoAntiguo = rs.getString("CODIGO_ANTIGUO");
                    
                    out.print("<tr>");
                    out.print("<td  align='right'>"+(codigoAntiguo==null?"":codigoAntiguo)+"&nbsp;</td>");
                    out.print("<td  align='right'>"+nombreMaterial+"</td>");
                    out.print("<td  align='right'>"+cantidadSolicitada+"</td>");
                    out.print("<td  align='right'>"+rs.getDouble("cantidadExistente")+"</td>");
                    out.print("<td  align='right'>"+abreviatura +"</td>");
                    out.print("</tr>");
                    }
                }catch(Exception e){
                e.printStackTrace();
                }
                finally
                {
                    con.close();
                }
                %>
               </tbody>
            </table>
            <table width="90%" align="center">
            <tr><td>
            Glosa:
            <%out.print(observacion);%>
            </td>
            </tr>
            </table>
            <br/><br/><br/><br/><br/>

            <table style="text-align:center" align="center" width="70%">
                <tr><td style="border-bottom-color:black;border-bottom-style:solid;border-bottom-width:thin;border-right-width:20px;border-right-color:white;border-right-style:solid" width="33%"></td>
                <td style="border-bottom-color:black;border-bottom-style:solid;border-bottom-width:thin;border-right-width:20px;border-right-color:white;border-right-style:solid" width="33%"> </td>
                <td style="border-bottom-color:black;border-bottom-style:solid;border-bottom-width:thin" width="33%"> </td></tr>
                <tr><td>Aprobado</td><td>Entregado <br/> Nombre y Firma</td><td>Recibido<br/> Nombre y Firma</td></tr>
            </table>

          
                            


            <table style="background:#BBFFCC"></table>
            
            
            
        </form>
    </body>
</html>