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
                    padding:6px;
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
            <table  align="center"  style="margin-top:12px;padding:4px;" class="outputText2"  cellpadding="0" cellspacing="0" >
            <tr>
                <td rowspan="8"><img src="../img/cofar.png" ></td>
            
            <%
            String codProgramaProduccionControlCalidad=request.getParameter("codCC");
            try
            {
               Connection con=null;
               con=Util.openConnection(con);
               Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
               String consulta="select cp.nombre_prod_semiterminado,ppcc.COD_LOTE_PRODUCCION,am.NOMBRE_ALMACEN_MUESTRA,pp.COD_FORMULA_MAESTRA,"+
                               " tee.NOMBRE_TIPO_ESTUDIO_ESTABILIDAD,ppcc.CANTIDAD_MUESTRAS,ppcc.TIEMPO_ESTUDIO,"+
                               " tpp.NOMBRE_TIPO_PROGRAMA_PROD,ppp.NOMBRE_PROGRAMA_PROD as programaLoteProduccion,"+
                               " pppcc.NOMBRE_PROGRAMA_PROD"+
                               "  from PROGRAMA_PRODUCCION_CONTROL_CALIDAD ppcc inner join PROGRAMA_PRODUCCION pp on "+
                               " pp.COD_LOTE_PRODUCCION=ppcc.COD_LOTE_PRODUCCION and ppcc.COD_FORMULA_MAESTRA=pp.COD_FORMULA_MAESTRA"+
                               " and pp.COD_PROGRAMA_PROD=ppcc.COD_PROGRAMA_PROD_LOTE_PRODUCCCION and "+
                               " pp.COD_TIPO_PROGRAMA_PROD=ppcc.COD_TIPO_PROGRAMA_PROD"+
                               " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=pp.COD_COMPPROD"+
                               " inner join TIPOS_ESTUDIO_ESTABILIDAD tee on tee.COD_TIPO_ESTUDIO_ESTABILIDAD=ppcc.COD_TIPO_ESTUDIO_ESTABILIDAD"+
                               " inner join ALMACENES_MUESTRA am on am.COD_ALMACEN_MUESTRA=ppcc.COD_ALMACEN_MUESTRA"+
                               " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=ppcc.COD_TIPO_PROGRAMA_PROD"+
                               " inner join PROGRAMA_PRODUCCION_PERIODO ppp on ppp.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD"+
                               " inner join PROGRAMA_PRODUCCION_PERIODO pppcc on pppcc.COD_PROGRAMA_PROD=ppcc.COD_PROGRAMA_PROD" +
                               " where ppcc.COD_PROGRAMA_PROD_CONTROL_CALIDAD='"+codProgramaProduccionControlCalidad+"' ";
               System.out.println("consulta cargar cabecera "+consulta);
               ResultSet res=st.executeQuery(consulta);
               SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
               
               String codFormulaMAestra="";
               if(res.next())
               {
                   codFormulaMAestra=res.getString("COD_FORMULA_MAESTRA");
                   out.println("<td style='font-weight:bold'>Producto</td><td>::</td><td>"+res.getString("nombre_prod_semiterminado")+"</td><td style='padding-left:12px;font-weight:bold'>Lote Produccion</td><td>::</td><td>"+res.getString("COD_LOTE_PRODUCCION")+"</td></tr>");
                   out.println("<tr><td style='font-weight:bold'>Almacen Muestra</td><td>::</td><td>"+res.getString("NOMBRE_ALMACEN_MUESTRA")+"</td><td style='padding-left:12px;font-weight:bold'>Tipo Estudio</td><td>::</td><td>"+res.getString("NOMBRE_TIPO_ESTUDIO_ESTABILIDAD")+"</td></tr>");
                   out.println("<tr><td style='font-weight:bold'>Cantidad Muestras</td><td>::</td><td>"+res.getString("CANTIDAD_MUESTRAS")+"</td><td style='padding-left:12px;font-weight:bold'>Tiempo de Estudio Programa</td><td>::</td><td>"+res.getString("TIEMPO_ESTUDIO")+"</td></tr>");
                   out.println("<tr><td style='font-weight:bold'>Tipo Programa</td><td>::</td><td>"+res.getString("NOMBRE_TIPO_PROGRAMA_PROD")+"</td><td style='padding-left:12px;font-weight:bold'>Programa Produccion</td><td>::</td><td>"+res.getString("programaLoteProduccion")+"</td></tr>");
                   out.println("<tr><td style='font-weight:bold'>Programa Estadibilidad</td><td>::</td><td>"+res.getString("NOMBRE_PROGRAMA_PROD")+"</td><td style='padding-left:12px;font-weight:bold'>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>");
               }
              
            %>
            </table>
            <table  align="center" class="outputText0" style="border-top:solid #000000 1px;border-left:solid #000000 1px;margin-top:12px" cellpadding="0" cellspacing="0" >
                     <tr class="headerClassACliente">
                         <td rowspan="2"  align='center' class="headerLocal"><b>Tiempo<br>Estudio</b></td>
                         <td rowspan="2" align='center' class="headerLocal"><b>Fecha Analisis</b></td>
                            <td rowspan="2" align='center' class="headerLocal"><b>Tipo Material Reactivo</b></td>
                            <td rowspan="2" align='center' class="headerLocal"s><b>Cant.<br> Test<br>Disolución</b></td>
                            <td rowspan="2" align='center' class="headerLocal"><b>Cant.<br>Test<br>Valoración</b></td>
                            <td rowspan="2" align='center' class="headerLocal"><b>Procede</b></td>
                            <td rowspan="2" align='center' class="headerLocal"><b>Observaciones</b></td>
                            <td colspan="4" align='center' class="headerLocal"><b>Materiales</b></td>
                      </tr>
                      <tr class="headerClassACliente">
                          <td align='center' class="headerLocal" ><b>Nombre<br>Material</b></td>
                          <td align='center' class="headerLocal"><b>Cantidad</b></td>
                          <td align='center' class="headerLocal"><b>Unidad de <br>Medida</b></td>
                          <td align='center' class="headerLocal"><b>Tipo De Analisis</b></td>
                      </tr>
              
            <%
            consulta="select ppcca.COD_CONTROL_CALIDAD_ANALISIS,ppcca.TIEMPO_ESTUDIO,ppcca.FECHA_ANALISIS,tmr.NOMBRE_TIPO_MATERIAL_REACTIVO,"+
                     " ppcca.CANTIDAD_TEST_DISOLUCION,ppcca.CANTIDAD_TEST_VALORACION,ppcca.PROCEDE,"+
                     " ppcca.OBSERVACION,m.NOMBRE_MATERIAL,fmd.COD_TIPO_ANALISIS_MATERIAL,fmd.CANTIDAD" +
                     " ,tamr.nombre_tipo_analisis_material_reactivo,um.NOMBRE_UNIDAD_MEDIDA"+
                     " from PROGRAMA_PRODUCCION_CONTROL_CALIDAD_ANALISIS ppcca inner join "+
                     " TIPOS_MATERIAL_REACTIVO tmr on tmr.COD_TIPO_MATERIAL_REACTIVO=ppcca.COD_TIPO_MATERIAL_REACTIVO"+
                     " inner join FORMULA_MAESTRA_DETALLE_MR fmd on fmd.COD_TIPO_MATERIAL=ppcca.COD_TIPO_MATERIAL_REACTIVO"+
                     " inner join TIPOS_ANALISIS_MATERIAL_REACTIVO tamr on tamr.cod_tipo_analisis_material_reactivo=fmd.COD_TIPO_ANALISIS_MATERIAL"+
                     " inner join materiales m on m.COD_MATERIAL=fmd.COD_MATERIAL"+
                     " inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=fmd.COD_UNIDAD_MEDIDA"+
                     " where ppcca.COD_PROGRAMA_PROD_CONTROL_CALIDAD='"+codProgramaProduccionControlCalidad+"'"+
                     " and fmd.COD_FORMULA_MAESTRA='"+codFormulaMAestra+"'"+
                     " order by ppcca.FECHA_ANALISIS,ppcca.COD_CONTROL_CALIDAD_ANALISIS,"+
                     " tmr.NOMBRE_TIPO_MATERIAL_REACTIVO,m.NOMBRE_MATERIAL";
                System.out.println("consulta cargar reporte  "+consulta);
                res=st.executeQuery(consulta);
                int codControlAnalisis=0;
                int tiempoEstudio=0;
                String fechaAnalisis="";
                String tipoMaterialReactivo="";
                int cantidadTestDisolucion=0;
                int cantidadTestValoracion=0;
                String procede="";
                String observaciones="";
                String detalleMateriales="";
                int contCol=0;
                while(res.next())
                {
                    if(res.getInt("COD_CONTROL_CALIDAD_ANALISIS")!=codControlAnalisis)
                    {
                            if(codControlAnalisis>0)
                            {
                                out.println("<tr class='rowClass' > " +
                                        " <td rowspan='"+contCol+"' align='left' class='celdaLocal' ><span class='ouputText2' style='margin-top:12px'>"+tiempoEstudio+" meses</span></td>"+
                                        " <td rowspan='"+contCol+"' align='left' class='celdaLocal' ><span class='ouputText2' style='margin-top:12px'>"+fechaAnalisis+"</span></td>"+
                                        " <td rowspan='"+contCol+"' align='left' class='celdaLocal' ><span class='ouputText2' style='margin-top:12px'>"+tipoMaterialReactivo+"</span></td>"+
                                        " <td rowspan='"+contCol+"' align='left' class='celdaLocal' ><span class='ouputText2' style='margin-top:12px'>"+cantidadTestDisolucion+"</span></td>"+
                                        " <td rowspan='"+contCol+"' align='left' class='celdaLocal' ><span class='ouputText2' style='margin-top:12px'>"+cantidadTestValoracion+"</span></td>"+
                                        " <td rowspan='"+contCol+"' class='celdaLocal' align='left;padding:8px'  ><span class='ouputText2'>"+procede+"</span></td>"+
                                        " <td rowspan='"+contCol+"' align='left' class='celdaLocal' ><span class='ouputText2' style='margin-top:12px'>"+observaciones+"</span></td>"+detalleMateriales);
                            }
                            tiempoEstudio=res.getInt("TIEMPO_ESTUDIO");
                            codControlAnalisis=res.getInt("COD_CONTROL_CALIDAD_ANALISIS");
                            fechaAnalisis=sdf.format(res.getTimestamp("FECHA_ANALISIS"));
                            tipoMaterialReactivo=res.getString("NOMBRE_TIPO_MATERIAL_REACTIVO");
                            cantidadTestDisolucion=res.getInt("CANTIDAD_TEST_DISOLUCION");
                            cantidadTestValoracion=res.getInt("CANTIDAD_TEST_VALORACION");
                            procede=(res.getInt("PROCEDE")==1?"SI":(res.getInt("PROCEDE")==2?"NO":"&nbsp;"));
                            observaciones=res.getString("OBSERVACION");
                            detalleMateriales="";
                            contCol=0;
                   }
                    contCol++;
                    detalleMateriales+=(detalleMateriales.equals("")?"":"<tr class='rowClass'>")+
                            " <td align='left' class='celdaLocal' ><span class='ouputText2' style='margin-top:12px'>"+res.getString("NOMBRE_MATERIAL")+"</span></td>"+
                            " <td align='left' class='celdaLocal' ><span class='ouputText2' style='margin-top:12px'>"+((res.getInt("COD_TIPO_ANALISIS_MATERIAL")==1?cantidadTestValoracion:cantidadTestDisolucion)*res.getInt("CANTIDAD"))+"</span></td>" +
                            " <td align='left' class='celdaLocal' ><span class='ouputText2' style='margin-top:12px'>"+res.getString("NOMBRE_UNIDAD_MEDIDA")+"</span></td>"+
                            " <td align='left' class='celdaLocal' ><span class='ouputText2' style='margin-top:12px'>"+res.getString("nombre_tipo_analisis_material_reactivo")+"</span></td>"+
                            "</tr>";
                }
                if(codControlAnalisis>0)
                {
                    out.println("<tr class='rowClass' > " +
                            " <td rowspan='"+contCol+"' align='left' class='celdaLocal' ><span class='ouputText2' style='margin-top:12px'>"+tiempoEstudio+" meses</span></td>"+
                            " <td rowspan='"+contCol+"' align='left' class='celdaLocal' ><span class='ouputText2' style='margin-top:12px'>"+fechaAnalisis+"</span></td>"+
                            " <td rowspan='"+contCol+"' align='left' class='celdaLocal' ><span class='ouputText2' style='margin-top:12px'>"+tipoMaterialReactivo+"</span></td>"+
                            " <td rowspan='"+contCol+"' align='left' class='celdaLocal' ><span class='ouputText2' style='margin-top:12px'>"+cantidadTestDisolucion+"</span></td>"+
                            " <td rowspan='"+contCol+"' align='left' class='celdaLocal' ><span class='ouputText2' style='margin-top:12px'>"+cantidadTestValoracion+"</span></td>"+
                            " <td rowspan='"+contCol+"' class='celdaLocal' align='left;padding:8px'  ><span class='ouputText2'>"+procede+"</span></td>"+
                            " <td rowspan='"+contCol+"' align='left' class='celdaLocal' ><span class='ouputText2' style='margin-top:12px'>"+observaciones+"</span></td>"+detalleMateriales);
                }
               
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
