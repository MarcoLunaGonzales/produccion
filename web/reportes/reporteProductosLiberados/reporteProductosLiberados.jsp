<%@page contentType="text/html"%>
<%@page pageEncoding="ISO-8859-1"%>
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
<%@page import="java.text.DecimalFormatSymbols" %>
<%@ page import = "java.text.NumberFormat"%>
<%@ page language="java" import="java.util.*,com.cofar.util.CofarConnection" %>



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../../js/general.js"></script>
        <style>
            .tablaDetalle{
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 11px;
            }
            .tablaDetalle tr td
            {
                border-top:1px solid #bbbbbb;
                border-left:1px solid #bbbbbb;
                padding:1em;
            }
            .tablaDetalle thead tr td
            {
                font-weight:bold;
                background-color:#dddddd;
            }
        </style>
    </head>
    <body>
        <form>
            <span class="outputTextTituloSistema">Reporte de Liberacion de Productos</span>
			
            <table cellpadding="0" cellspacing="0" class="tablaDetalle">
                <thead>
                    <tr>
                        <td>Nro. Registro Sanitario</td>
                        <td>Nombre Comercial</td>
                        <td>Forma Farmaceutica</td>
                        <td>Concentración</td>
                        <td>Presentación</td>
                        <td>Laboratorio Fabricante</td>
                        <td>Tipo de Ingreso</td>
                        <td>Nro. de Lote</td>
                        <td>Nro. de C.C.C. Fisico Quimico</td>
                        <td>Nro. de C.C.C. Microbiologico</td>
                        <td>Fecha de C.C.C.</td>
                        <td>Vencimiento</td>
                        <td>Cantidad Producida(Sólo para Ind. Nal.)</td>
                        <td>Cantidad Liberada o Importada(Cajas)</td>
                        <td>Cantidad Liberada o Importada(Unidades)</td>
                    </tr>
                </thead>
                <tbody>
             <%
                   
				   //codAreaEmpresa
				   
            String codAlmacen = request.getParameter("codAlmacen");
            String fecha_inicio = request.getParameter("fechaInicio");
            String fecha_final = request.getParameter("fechaFinal");
            String valuesx[] = fecha_inicio.split("/");
            String valuesx2[] = fecha_final.split("/");
            String SQLFecha1 = valuesx[2] + "/" + valuesx[1] + "/" + valuesx[0];
            String SQLFecha2 = valuesx2[2] + "/" + valuesx2[1] + "/" + valuesx2[0];
            DecimalFormatSymbols simbolo1=new DecimalFormatSymbols();
            simbolo1.setDecimalSeparator(',');
            simbolo1.setGroupingSeparator('.');
            DecimalFormat formatoMil = new DecimalFormat("###,###.##",simbolo1);
            formatoMil.setMaximumFractionDigits(2);
            NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
            DecimalFormat formato = (DecimalFormat) numeroformato;
            formato.applyPattern("#,##0.00");
            SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
            Connection con=null;
            try{
                con=Util.openConnection(con);
                String consulta="select cp.REG_SANITARIO,tiv.nombre_tipoingresoventas,cp.NOMBRE_COMERCIAL,ff.nombre_forma,isnull(cp.CONCENTRACION_ENVASE_PRIMARIO,'&nbsp;') as CONCENTRACION_ENVASE_PRIMARIO"+
                                " ,pp.NOMBRE_PRODUCTO_PRESENTACION,id.COD_LOTE_PRODUCCION,isnull(ra.NRO_ANALISIS,'&nbsp;') as NRO_ANALISIS,isnull(ra.NRO_ANALISIS_MICROBIOLOGICO,'&nbsp;') as NRO_ANALISIS_MICROBIOLOGICO"+
                                " ,ra.FECHA_EMISION,DATEPART(Year,id.FECHA_VENC) as anio,DATEPART(MONTH,id.FECHA_VENC) as mes" +
                                " ,sum(id.CANTIDAD) as cantidadCajas,sum(id.CANTIDAD_UNITARIA) as cantidadUnitariaCajas" +
                                " ,(select sum(p.CANT_LOTE_PRODUCCION) from PROGRAMA_PRODUCCION p where p.COD_LOTE_PRODUCCION=id.COD_LOTE_PRODUCCION collate traditional_spanish_CI_AI"+
                                " and p.COD_COMPPROD=sda.COD_COMPPROD group by p.COD_LOTE_PRODUCCION,p.COD_COMPPROD) as cantidadLote"+
                                " from INGRESOS_VENTAS iv inner join INGRESOS_DETALLEVENTAS id on "+
                                " iv.COD_INGRESOVENTAS=id.COD_INGRESOVENTAS and iv.COD_AREA_EMPRESA=id.COD_AREA_EMPRESA"+
                                " inner join TIPOS_INGRESOVENTAS tiv on tiv.cod_tipoingresoventas = iv.COD_TIPOINGRESOVENTAS "+
                                " inner join PRESENTACIONES_PRODUCTO pp on pp.cod_presentacion=id.COD_PRESENTACION"+
                                "  inner join SALIDA_DETALLEINGRESOVENTAS sd on sd.COD_INGRESOVENTAS=iv.COD_INGRESOVENTAS"+
                                " inner join SALIDAS_VENTAS sv on    sv.COD_AREA_EMPRESA=iv.COD_AREA_EMPRESA"+
                                " and sv.COD_SALIDAVENTA=sd.COD_SALIDAVENTAS and sv.COD_ESTADO_SALIDAVENTA<>2"+
                                " inner join SALIDAS_ACOND sa on sa.COD_SALIDA_ACOND=iv.COD_SALIDA_ACOND" +
                                " and sa.COD_ESTADO_SALIDAACOND<>2"+
                                " inner join SALIDAS_DETALLEACOND sda on sda.COD_SALIDA_ACOND=sa.COD_SALIDA_ACOND"+
                                " and sda.COD_LOTE_PRODUCCION=id.COD_LOTE_PRODUCCION collate traditional_spanish_CI_AI and sda.COD_PRESENTACION=id.COD_PRESENTACION "+
                                " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=sda.COD_COMPPROD"+
                                " inner join FORMAS_FARMACEUTICAS ff on ff.cod_forma=cp.COD_FORMA"+
                                " left outer join RESULTADO_ANALISIS ra on ra.COD_LOTE=id.COD_LOTE_PRODUCCION collate traditional_spanish_CI_AI and ra.COD_COMPROD=sda.COD_COMPPROD"+
                                " where iv.COD_ESTADO_INGRESOVENTAS=4 and sv.FECHA_SALIDAVENTA BETWEEN"+
                                " '"+SQLFecha1+" 00:00' and '"+SQLFecha2+" 23:59:59' and iv.COD_ALMACEN_VENTA in ("+codAlmacen+")" +
                                " and iv.COD_AREA_EMPRESA=1 and sv.COD_AREA_EMPRESA=1"+
                                " group by "+
                                " cp.REG_SANITARIO, tiv.nombre_tipoingresoventas, cp.NOMBRE_COMERCIAL,ff.nombre_forma,cp.CONCENTRACION_ENVASE_PRIMARIO"+
                                " ,pp.NOMBRE_PRODUCTO_PRESENTACION,id.COD_LOTE_PRODUCCION,ra.NRO_ANALISIS,ra.NRO_ANALISIS_MICROBIOLOGICO"+
                                " ,ra.FECHA_EMISION,DATEPART(Year,id.FECHA_VENC),DATEPART(MONTH,id.FECHA_VENC),sda.COD_COMPPROD" +
                                " order by cp.NOMBRE_COMERCIAL,id.COD_LOTE_PRODUCCION";
                System.out.println("consulta buscar lote "+consulta);
                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                ResultSet res=st.executeQuery(consulta);
                String codTipoProgramaProd="";
                while(res.next())
                {
                    out.println("<tr>" +
                               "<td>"+res.getString("REG_SANITARIO")+"</td>" +
                               "<td>"+res.getString("NOMBRE_COMERCIAL")+"</td>" +
                               "<td>"+res.getString("nombre_forma")+"</td>" +
                               "<td>"+res.getString("CONCENTRACION_ENVASE_PRIMARIO")+"&nbsp;</td>" +
                               "<td>"+res.getString("NOMBRE_PRODUCTO_PRESENTACION")+"</td>" +
                               "<td>Laboratorios COFAR</td>" +
                               "<td>"+res.getString("nombre_tipoingresoventas")+"</td>" +
                               "<td>"+res.getString("COD_LOTE_PRODUCCION")+"</td>" +
                               "<td>"+res.getString("NRO_ANALISIS")+"&nbsp;</td>" +
                               "<td>"+res.getString("NRO_ANALISIS_MICROBIOLOGICO")+"&nbsp;</td>" +
                               "<td>"+(res.getTimestamp("FECHA_EMISION")!=null?sdf.format(res.getTimestamp("FECHA_EMISION")):"&nbsp;")+"&nbsp;</td>" +
                               "<td>"+(res.getInt("mes")>9?"":"0")+res.getInt("mes")+"/"+res.getInt("anio")+"</td>" +
                               "<td>"+res.getInt("cantidadLote")+"</td>" +
                               "<td>"+res.getInt("cantidadCajas")+"</td>" +

                               "<td>"+res.getInt("cantidadUnitariaCajas")+"</td>" +
                               "</tr>");
                }
                        
            }
            catch(SQLException ex)
            {
                ex.printStackTrace();
            }
            finally
            {
                con.close();
            }
            %>
            </tbody>
            </table>
        </form>
    </body>
</html>
