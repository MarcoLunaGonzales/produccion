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



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />

        <script src="../js/general.js"></script>
    </head>
    <body>
        <form>
            <h4 align="center">Reporte de devoluciones programa produccion</h4>

                    <%
                    try {

                        String codLoteProduccion=request.getParameter("codLote");
                        String nombreProducto=request.getParameter("nombreProd");
                        String nombreTipoProg=request.getParameter("nomTipoProd");
                        String nombreArea=request.getParameter("area");
                        String codProgProdDevMat=request.getParameter("codProgProd");

                    %>

            <br>
            <table width="70%" border="0" align="center">
                <tr>
                    <td>
            <img src="../img/cofar.png" alt="logo cofar" align="left" />
            </td><td>
            <table border="0" class="outputText1" >
                <tbody>
                    <tr>
                        <td><b>Producto:</b></td>
                        <td><%=nombreProducto%></td>
                    </tr>
                     <tr>
                        <td><b>Lote:</b></td>
                        <td><%=codLoteProduccion%></td>
                    </tr>
                    <tr>
                        <td><b>Tipo Programa Producción:</b></td>
                        <td><%=nombreTipoProg%></td>
                    </tr>
                    <tr>
                        <td><b>Area:</b></td>
                        <td><%=nombreArea%></td>
                    </tr>
                </tbody>
            </table>
            </td>
            </tr>
            </table>
            <center>
            <table>
                <tr class="outputText0">
                    <td bgcolor="#F0E686" width="45px" height="15px"></td>
                    <td>Materiales devueltos Parcialmente</td>
                </tr>
                 <tr class="outputText0">
                    <td bgcolor="#bff9bf" width="45px" height="15px"></td>
                    <td>Materiales devueltos totalmente</td>
                </tr>
                
            </table>
            </center>
            <table width="70%" align="center" class="outputText0" style="border : solid #000000 1px;" cellpadding="0" cellspacing="0" >


                <tr class="">
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2"  align="center" ><b>Material</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2"  align="center" ><b>Cant. Buenos</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2"  align="center" ><b>Cant. Buenos Entregado</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2"  align="center" ><b>Cant. Buenos A Devolver</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2"  align="center" ><b>Cant. Malos</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2"  align="center" ><b>Cant. Malos Entregados</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2"  align="center" ><b>Cant. Malos A Devolver</b></td>
                    <td  class="border" style="border : solid #D8D8D8 1px" bgcolor="#f2f2f2"  align="center"><b>Unid.</b></td>
                    <td  style="border : solid #D8D8D8 1px" class="border"  bgcolor="#f2f2f2"  align="center"><b>Observación</b></td>
                </tr>

                <%
                NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat format = (DecimalFormat)nf;
                format.applyPattern("#,###.00");
                String consulta="select m.NOMBRE_MATERIAL,ppdmd.CANTIDAD_BUENOS,ppdmd.CANTIDAD_BUENOS_ENTREGADOS,(ppdmd.CANTIDAD_BUENOS-ppdmd.CANTIDAD_BUENOS_ENTREGADOS) as cantRestBuenos,"+
                                " ppdmd.CANTIDAD_MALOS,ppdmd.CANTIDAD_MALOS_ENTREGADOS,(ppdmd.CANTIDAD_MALOS-ppdmd.CANTIDAD_MALOS_ENTREGADOS) as cantResMalos," +
                                " um.ABREVIATURA,ppdmd.OBSERVACION from MATERIALES m  inner join FORMULA_MAESTRA_DETALLE_EP fmd "+
                                " on m.COD_MATERIAL = fmd.COD_MATERIAL INNER JOIN PRESENTACIONES_PRIMARIAS PP ON "+
                                " PP.COD_PRESENTACION_PRIMARIA = fmd.COD_PRESENTACION_PRIMARIA inner join UNIDADES_MEDIDA um on "+
                                " um.COD_UNIDAD_MEDIDA = fmd.COD_UNIDAD_MEDIDA inner join FORMULA_MAESTRA fm "+
                                " on fm.COD_FORMULA_MAESTRA = fmd.COD_FORMULA_MAESTRA and fm.COD_ESTADO_REGISTRO = 1 "+
                                " inner join PROGRAMA_PRODUCCION_DEVOLUCION_MATERIAL ppdm on"+
                                " pp.COD_TIPO_PROGRAMA_PROD=ppdm.COD_TIPO_PROGRAMA_PROD and ppdm.COD_FORMULA_MAESTRA="+
                                " fmd.COD_FORMULA_MAESTRA inner join PROGRAMA_PRODUCCION_DEVOLUCION_MATERIAL_DETALLE ppdmd on " +
                                " ppdmd.COD_PROGRAMA_PRODUCCION_DEVOLUCION_MATERIAL=ppdm.COD_PROGRAMA_PRODUCCION_DEVOLUCION_MATERIAL " +
                                " and m.COD_MATERIAL=ppdmd.COD_MATERIAL where ppdm.COD_PROGRAMA_PRODUCCION_DEVOLUCION_MATERIAL='"+codProgProdDevMat+"'"+
                                " order by m.NOMBRE_MATERIAL";
                    System.out.println("consulta "+consulta);
                    Connection con=null;
                    con=Util.openConnection(con);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet res=st.executeQuery(consulta);
                    String nombreMaterial="";
                    String abrevUnidadMedida="";
                    String observacion="";
                    double cantBuenos=0d;
                    double cantBuenosEntregada=0d;
                    double cantBuenoRestante=0d;
                    double cantMalos=0d;
                    double cantMalosEntregada=0d;
                    double cantMalosRestante=0d;
                    String bgcolor="";
                    while(res.next())
                    {
                        nombreMaterial=res.getString("NOMBRE_MATERIAL");
                        abrevUnidadMedida=res.getString("ABREVIATURA");
                        observacion=res.getString("OBSERVACION");
                        cantBuenos=res.getDouble("CANTIDAD_BUENOS");
                        cantBuenosEntregada=res.getDouble("CANTIDAD_BUENOS_ENTREGADOS");
                        cantBuenoRestante=res.getDouble("cantRestBuenos");
                        cantMalos=res.getDouble("CANTIDAD_MALOS");
                        cantMalosEntregada=res.getDouble("CANTIDAD_MALOS_ENTREGADOS");
                        cantMalosRestante=res.getDouble("cantResMalos");
                        if(cantBuenosEntregada>0||cantMalosEntregada>0)
                        {

                            bgcolor="#F0E686";
                            if(cantBuenoRestante==0&& cantMalosRestante==0)
                            {
                            bgcolor="#bff9bf";
                            }
                        }
                        else
                        {
                            bgcolor="#FFFFFF";
                        }
                        %>

                    </style>
                       <tr  bgcolor="<%=bgcolor%>">
                            <td  class="border" style="border : solid #D8D8D8 1px"  bgcolor="<%=bgcolor%>" align="center" ><%=nombreMaterial%></td>
                            <td  class="border" style="border : solid #D8D8D8 1px"  bgcolor="<%=bgcolor%>"  align="center" ><%=format.format(cantBuenos)%></td>
                            <td  class="border" style="border : solid #D8D8D8 1px"  bgcolor="<%=bgcolor%>" align="center" ><%=format.format(cantBuenosEntregada)%></td>
                            <td  class="border" style="border : solid #D8D8D8 1px"  bgcolor="<%=bgcolor%>" align="center" ><%=format.format(cantBuenoRestante)%></td>
                            <td  class="border" style="border : solid #D8D8D8 1px"  bgcolor="<%=bgcolor%>" align="center" ><%=format.format(cantMalos)%></td>
                            <td  class="border" style="border : solid #D8D8D8 1px"  bgcolor="<%=bgcolor%>" align="center" ><%=format.format(cantMalosEntregada)%></td>
                            <td  class="border" style="border : solid #D8D8D8 1px"  bgcolor="<%=bgcolor%>" align="center" ><%=format.format(cantMalosRestante)%></td>
                            <td  class="border" style="border : solid #D8D8D8 1px"  bgcolor="<%=bgcolor%>" align="center"><%=abrevUnidadMedida%></td>
                            <td  class="border" style="border : solid #D8D8D8 1px"  bgcolor="<%=bgcolor%>"  align="center"><%=observacion%></td>
                        </tr>
                        <%
                    }
                    res.close();
                    st.close();
                    con.close();
               %>
               </table>

                <%
                    }
                    catch(SQLException ex)
                     {
                        ex.printStackTrace();
                    }

                %>
            <br>

            <br>
            <div align="center">

            </div>
        </form>
    </body>
</html>
