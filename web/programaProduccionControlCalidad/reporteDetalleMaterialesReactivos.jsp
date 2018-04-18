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
<%@ page language="java" import="java.util.*,com.cofar.util.CofarConnection" %>
<%@ page errorPage="ExceptionHandler.jsp" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../../js/general.js"></script>
        <style>
            .headerLocal{
                    background-image:none;
                    background-color:#9d5f9f;
                    font-weight:bold;
                    border-bottom:1px solid black;
                    border-right:1px solid black;
                    padding:3px;
                }
            .celdaLocal{
                    padding:3px;
                    font-size:12px;
                    border-bottom:1px solid black;
                    border-right:1px solid black;
            }
            .rowClass
            {
                  background-image:none;
                  background-color:#ffffff;
                  font-weight:normal;
            }
            .rowClass:hover
            {
                color:blue;
                background-color:#dddddd;
            }
            .textoCabecera
            {
                font-weight:bold;
                font-size:14px;
            }
        </style>
    </head>
    <body>
        <form>
            
            <center><span class="textoCabecera">Detalle de Materiales Reactivos</span></center>
            <table  align="center" class="outputText0" style="border-top:solid #000000 1px;border-left:solid #000000 1px;margin-top:12px" cellpadding="0" cellspacing="0" >

             <tr class="headerClassACliente">
                 <td  align='center' class="headerLocal"><b>Tipo Material Reactivo</b></td>
                 <td  align='center' class="headerLocal"><b>Tipo Analisis</b></td>
                    <td  align='center' class="headerLocal"><b>Material</b></td>
                    <td  align='center' class="headerLocal"s><b>Cantidad</b></td>
                    <td  align='center' class="headerLocal"><b>Unidad de Medida</b></td>


              </tr>
            <%
            String codFormulaMaestra=request.getParameter("codFormula");
            String tipoMaterialReactivo=request.getParameter("codTipoMaterial");
            int cantidadAnalisisValoracion=Integer.valueOf(request.getParameter("cantidadValoracion"));
            int cantidadAnalisisDIsolucion=Integer.valueOf(request.getParameter("cantidadDisolucion"));
            try
            {
                Connection con=null;
                con=Util.openConnection(con);
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                String consulta="select fmd.COD_TIPO_ANALISIS_MATERIAL,m.NOMBRE_MATERIAL,m.NOMBRE_CCC,fmd.CANTIDAD,um.NOMBRE_UNIDAD_MEDIDA,"+
                                " tamr.nombre_tipo_analisis_material_reactivo,tmr.NOMBRE_TIPO_MATERIAL_REACTIVO"+
                                " from FORMULA_MAESTRA_DETALLE_MR fmd inner join"+
                                " materiales m on m.COD_MATERIAL=fmd.COD_MATERIAL"+
                                " inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=fmd.COD_UNIDAD_MEDIDA"+
                                " inner join TIPOS_MATERIAL_REACTIVO tmr on tmr.COD_TIPO_MATERIAL_REACTIVO=fmd.COD_TIPO_MATERIAL"+
                                " inner join TIPOS_ANALISIS_MATERIAL_REACTIVO tamr on tamr.cod_tipo_analisis_material_reactivo=fmd.COD_TIPO_ANALISIS_MATERIAL"+
                                " where fmd.COD_TIPO_MATERIAL ='"+tipoMaterialReactivo+"' and " +
                                " fmd.COD_TIPO_ANALISIS_MATERIAL in (0"+(cantidadAnalisisDIsolucion>0?",2":"")+(cantidadAnalisisValoracion>0?",1":"")+")"+
                                " and fmd.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'"+
                                " order by tmr.NOMBRE_TIPO_MATERIAL_REACTIVO,m.NOMBRE_MATERIAL";
                System.out.println("consulta cargar reporte  "+consulta);
                ResultSet res=st.executeQuery(consulta);
                while(res.next())
                {
                    out.println("<tr class='rowClass' > " +
                            " <td align='left' class='celdaLocal' ><span class='ouputText2' style='margin-top:12px'>"+res.getString("NOMBRE_TIPO_MATERIAL_REACTIVO")+"</span></td>"+
                                " <td align='left' class='celdaLocal' ><span class='ouputText2' style='margin-top:12px'>"+res.getString("nombre_tipo_analisis_material_reactivo")+"</span></td>"+
                                " <td align='left' class='celdaLocal' ><span class='ouputText2' style='margin-top:12px'>"+res.getString("NOMBRE_MATERIAL")+"</span></td>"+
                                " <td class='celdaLocal' align='left;padding:8px'  ><span class='ouputText2'>"+((res.getInt("COD_TIPO_ANALISIS_MATERIAL")==1?cantidadAnalisisValoracion:cantidadAnalisisDIsolucion)*res.getInt("CANTIDAD"))+"</span></td>"+
                                " <td class='celdaLocal' align='left;padding:8px'  ><span class='ouputText2'>"+res.getString("NOMBRE_UNIDAD_MEDIDA")+"</span></td>"+
                        "</tr>");
                }
                st.close();
                st.close();
                con.close();
            }
            catch(SQLException ex)
            {
                ex.printStackTrace();
            }
            %>
            </table>
        </form>
    </body>
</html>
