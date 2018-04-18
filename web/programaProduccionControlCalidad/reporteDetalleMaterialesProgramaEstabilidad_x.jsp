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
                            <td   align='center' class="headerLocal"><b>Fecha</b></td>
                            <td  align='center' class="headerLocal"><b>Material</b></td>
                            <td  align='center' class="headerLocal"><b>Cantidad</b></td>
                            <td  align='center' class="headerLocal"s><b>Unidad Medida</b></td>
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
            consulta = " select p.FECHA_ANALISIS,m.NOMBRE_MATERIAL,p1.cantidad,u.NOMBRE_UNIDAD_MEDIDA,p.COD_CONTROL_CALIDAD_ANALISIS" +
                       " from PROGRAMA_PRODUCCION_CONTROL_CALIDAD_ANALISIS p" +
                       " inner join PROGRAMA_PROD_CONTROL_CALIDAD_DETALLE p1 on p1.cod_programa_prod_control_calidad = p.COD_PROGRAMA_PROD_CONTROL_CALIDAD" +
                       " and p1.cod_control_calidad_analisis = p.COD_CONTROL_CALIDAD_ANALISIS" +
                       " inner join materiales m on m.COD_MATERIAL = p1.cod_material" +
                       " inner join UNIDADES_MEDIDA u on u.COD_UNIDAD_MEDIDA = p1.cod_unidad_medida" +
                       " where p.COD_PROGRAMA_PROD_CONTROL_CALIDAD = '"+codProgramaProduccionControlCalidad+"'" +
                       " order by p.FECHA_ANALISIS asc ";
                System.out.println("consulta cargar reporte  "+consulta);
                res=st.executeQuery(consulta);
                
                int contCol=0;
                String deta = "";
                int filas = 1;


                Date fecha = new Date();
                while(res.next())
                {
                    if(!fecha.equals(res.getDate("fecha_analisis"))&& deta.length()>0){
                        deta = " <tr class='rowClass'><td rowspan='"+filas+"' align='left' class='celdaLocal' ><span class='ouputText2' style='margin-top:12px'>"+sdf.format(fecha)+" </span></td></tr>"+deta;
                        out.print(deta);
                        filas = 1;
                        deta = "";
                    }
                fecha = res.getDate("fecha_analisis");
                String nombreMaterial = res.getString("nombre_material");
                Double cantidad = res.getDouble("cantidad");
                String nombreUnidadMedida =res.getString("nombre_unidad_medida");
                deta +=     " <tr class='rowClass' > " +
                            " <td rowspan='"+contCol+"' align='left' class='celdaLocal' ><span class='ouputText2' style='margin-top:12px'>"+nombreMaterial+"</span></td>"+
                            " <td rowspan='"+contCol+"' align='left' class='celdaLocal' ><span class='ouputText2' style='margin-top:12px'>"+cantidad+"</span></td>"+
                            " <td rowspan='"+contCol+"' align='left' class='celdaLocal' ><span class='ouputText2' style='margin-top:12px'>"+nombreUnidadMedida+"</span></td>"+
                            " </span></td>";
                filas++;
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
