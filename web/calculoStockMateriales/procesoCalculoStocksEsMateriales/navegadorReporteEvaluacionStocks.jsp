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
<%@ page errorPage="ExceptionHandler.jsp" %>
<%! public String nombrePresentacion1(String codPresentacion) {

       

        String nombreproducto = "";
        Connection con1=null;
        try {
            con1 = Util.openConnection(con1);
            String sql_aux = "select cod_presentacion, nombre_producto_presentacion from presentaciones_producto where cod_presentacion='" + codPresentacion + "'";
            System.out.println("PresentacionesProducto:sql:" + sql_aux);
            Statement st = con1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql_aux);
            while (rs.next()) {
                String codigo = rs.getString(1);
                nombreproducto = rs.getString(2);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "";
    }
public double compara(int unidad1, int unidad2) {

        String nombre_material = "", nombre_unidad_medida = "", nombre_unidad_medida2 = "";


        double valor_equivalencia = 1;
        try {
            Connection con = null;
            con = Util.openConnection(con);
            String sql = "select cod_unidad_medida,cod_unidad_medida2,valor_equivalencia";
            sql += " from equivalencias";
            sql += " where cod_unidad_medida=" + unidad1;
            sql += " and cod_unidad_medida2=" + unidad2;
            sql += " and cod_estado_registro=1";
            System.out.println("sql:1***********" + sql);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql);
            int sw = 0;
            double equivalencia = 0;
            while (rs.next()) {
                equivalencia = rs.getDouble(3);
                sw = 1;
            }
            if (sw == 1) {
                valor_equivalencia = 1 / equivalencia;
            } else {
                String sql2 = "select cod_unidad_medida,cod_unidad_medida2,valor_equivalencia";
                sql2 += " from equivalencias";
                sql2 += " where cod_unidad_medida=" + unidad2;
                sql2 += " and cod_unidad_medida2=" + unidad1;
                sql2 += " and cod_estado_registro=1";
                System.out.println("sql:2***********" + sql2);
                Statement st2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs2 = st2.executeQuery(sql2);
                sw = 0;
                while (rs2.next()) {
                    sw = 1;
                    equivalencia = rs2.getDouble(3);
                }
                if (sw == 1) {
                    valor_equivalencia = equivalencia;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        System.out.println("valor_equivalencia:" + valor_equivalencia);
        return valor_equivalencia;
    }
 public double redondear(double numero, int decimales) {
        return Math.round(numero * Math.pow(10, decimales)) / Math.pow(10, decimales);
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
        <h3 align="center">Calculo de Stocks de Materiales</h3>
        <br>
        <form>
            <table align="center" width="90%">

                <%
                    System.out.println("explosion es");
        Connection con = null;
        float nroMesesStockMinimo=Float.valueOf(request.getParameter("nroMeses"));
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat format = (DecimalFormat) nf;
        format.applyPattern("#,###.00");
        con = Util.openConnection(con);
        String fechaInicial = request.getParameter("fechaFinalP");
        String fechaFinal = request.getParameter("fechaFinalP");
        String codGrupo = request.getParameter("codGrupoP");
        String codAlmacen = request.getParameter("codAlmacenP")==null?"0":request.getParameter("codAlmacenP");
        String[] arrayFechaInicial = fechaInicial.split("/");
        String[] arrayFechaFinal = fechaFinal.split("/");
        String fechaInicialConsulta = String.valueOf(Integer.valueOf(arrayFechaInicial[2]) - 1) + "/" + arrayFechaInicial[1] + "/" + arrayFechaInicial[0];
        String fechaFinalConsulta = arrayFechaFinal[2] + "/" + arrayFechaFinal[1] + "/" + arrayFechaFinal[0];
        SimpleDateFormat sdfDias= new SimpleDateFormat("dd/MM/yyyy");
        

                %>
                <tr>
                    <td align="left" width="25%"><img src="../img/cofar.png"></td>
                    <td align="left" class="outputText2" width="50%" >

                    </td>
                    <td width="25%">
                        <table border="0" class="outputText2" width="100%" >
                            <tr>
                                <td align="right"><b>A Fecha&nbsp;::&nbsp;</b><%=fechaFinal%></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <br>
            <br>
            <br>
            <table  align="center" width="90%" class="tablaReporte" cellpadding="0" cellspacing="0">
                <thead>
                    <tr>
                        <td >Material</td>
                        <td>Unidad de Medida</td>
                        <td>Ultima Fecha Compra</td>
                        <td>Ultimo Tipo Compra</td>
                        <td>Ultimo Tipo Transporte</td>
                        <td>Cantidad en Lote</td>
                        <td>Salidas Año Movil</td>
                        <td>Salidas Ultimo Trimestre</td>
                        <td>Fecha Ultima Salida</td>
                        <td>Cantidad Ultima Salida</td>
                        <td>Lote Ultima Salida</td>
                        <td>Nro. Meses Stock Minimo</td>
                        <td>Stock Mínimo</td>
                        <td>Nro. Meses Stock Reposicion</td>
                        <td>Stock Reposición</td>
                        <td>Aprobados<br>(ALMACEN TRANSITORIO DE E.S.)</td>
                        <td>Cuarentena<br>(ALMACEN TRANSITORIO DE E.S.)</td>
                        <td>Aprobados<br>(Almacenes Filtro)</td>
                        <td>Vencidos<br>(Almacenes Filtro)</td>
                        <td>Rechazados<br>(Almacenes Filtro)</td>
                        <td>Reanalisis<br>(Almacenes Filtro)</td>
                        <td>Cantidad Transito</td>
                        <td>Fecha Entrega</td>
                        <td>Proveedor Ultima Compra</td>
                        <td>Ordenes de Compra</td>
                        <td>Comprar</td>
                    </tr>
                </thead>

                <%
        try {
            Date fechaActual = new Date();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
            StringBuilder consulta=new StringBuilder(" SET NOCOUNT ON DECLARE @codigosAlmacen TdatosIntegerRef ");
                                consulta.append(" DECLARE @codigosGrupo TdatosIntegerRef");
                                consulta.append(" INSERT INTO @codigosAlmacen VALUES (0)");
                                for(String codAlmacenRef:codAlmacen.split(","))
                                    consulta.append(" ,(").append(codAlmacenRef).append(")");
                                consulta.append(" INSERT INTO @codigosGrupo VALUES (0)");
                                for(String codGrupoRef:codGrupo.split(","))
                                    consulta.append(" ,(").append(codGrupoRef).append(") ");
                                consulta.append(" exec PAA_CALCULO_STOCK_ES ?,@codigosAlmacen,@codigosGrupo");
                                consulta.append(" SET NOCOUNT OFF");
            System.out.println("consulta repote "+consulta.toString());
            PreparedStatement pst=con.prepareStatement(consulta.toString());
            pst.setString(1,sdf.format(new Date())+" 23:59:59");
            ResultSet res = pst.executeQuery();
            while (res.next()) 
            {
                System.out.println("111");
                String codMaterial = res.getString("COD_MATERIAL");
                int codigoGrupo = res.getInt("COD_GRUPO");
                int codigoCapitulo = res.getInt("COD_CAPITULO");
                out.print("<tr><td ><b>" +res.getString("NOMBRE_MATERIAL")+ "</b></td>");
                out.print("<td ><b>" +res.getString("ABREVIATURA") + "</b></td>");
                Double totalSalidasAlmacen = res.getDouble("totalSalidasAnioMovil");
                Double salidasBacoMes = totalSalidasAlmacen / 12;
                Double cantItemEnLote=res.getDouble("cantidadLote");
                float nroMeses = nroMesesStockMinimo;
                float nroMesesReposicion =res.getFloat("NRO_MESES_STOCK_REPOSICION");
                int codUnidadMedidadMaterial=res.getInt("COD_UNIDAD_MEDIDA");
                Double stockMinimo=0d;
                Double stockReposicion =0d;
                Double stockMaximo = 0d;
                double cantidad_neta_transito = 0;
                Date fechaEntrega = null;
                String ordenCompra = "";
                if((salidasBacoMes*nroMeses)<cantItemEnLote)
                {
                    stockMinimo=cantItemEnLote;
                }
                else
                {
                    stockMinimo=(salidasBacoMes*nroMeses);
                }
                stockReposicion=stockMinimo+(salidasBacoMes*nroMesesReposicion);
                sdf = new SimpleDateFormat("yyyy/MM/01");
                fechaEntrega= null;
                consulta = new StringBuilder("select oc.nro_orden_compra,oc.fecha_emision,oc.cod_orden_compra,oc.cod_moneda,ocd.cod_unidad_medida,");
                            consulta.append(" precio_unitario,cantidad_neta-cantidad_ingreso_almacen transito,um.NOMBRE_UNIDAD_MEDIDA,oc.FECHA_ENTREGA,ocd.COD_MATERIAL,oc.FECHA_ENTREGA");
                            consulta.append(" from ordenes_compra_detalle ocd ");
                                    consulta.append(" inner join  ORDENES_COMPRA oc on oc.cod_orden_compra = ocd.cod_orden_compra");
                                    consulta.append(" inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=ocd.cod_unidad_medida");
                            consulta.append(" where  oc.COD_ESTADO_COMPRA IN (2,6,13)");//aprobada,ingresada parcialmente, enviada parcialmente
                                    consulta.append(" and oc.ESTADO_SISTEMA = 1 ");
                                    consulta.append(" and ocd.cod_material='").append(codMaterial).append("'");
                                    consulta.append(" and dateadd(month,3,oc.FECHA_ENTREGA) >= '"+sdf.format(new Date())+"'");
                            consulta.append(" order by oc.FECHA_EMISION asc");
                System.out.println("consulta " + consulta.toString());
                Statement st1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs1 = st1.executeQuery(consulta.toString());
                cantidad_neta_transito = 0;
                String unidad_medida_transito = "";
                int cod_unidad_medida_compra = 0;
                String transito = "";
                ordenCompra = "";
                while (rs1.next()) 
                {
                    cod_unidad_medida_compra = rs1.getInt("cod_unidad_medida");
                    cantidad_neta_transito = cantidad_neta_transito+ rs1.getDouble("transito");
                    cantidad_neta_transito = cantidad_neta_transito<0?0:cantidad_neta_transito;
                    unidad_medida_transito = rs1.getString("nombre_unidad_medida");
                    fechaEntrega=rs1.getDate("fecha_entrega");

                    double equivalencia = compara(codUnidadMedidadMaterial, cod_unidad_medida_compra);
                    cantidad_neta_transito = cantidad_neta_transito * equivalencia;
                    cantidad_neta_transito = redondear(cantidad_neta_transito, 3);
                    ordenCompra = ordenCompra + " <br/> " + rs1.getString("nro_orden_compra");
                }
                    String mesesStockMinimo="SELECT s.DIAS_STOCKMINIMO, s.DIAS_STOCKMAXIMO, s.DIAS_STOCKREPO from STOCK_MINIMO_GRUPOSES s " +
                                " where s.COD_CAPITULO in (" + codigoCapitulo + ") and s.COD_GRUPO=" + codigoGrupo + "";
                        System.out.println("stocks:   " + mesesStockMinimo);
                        Statement stMesesStockMinimo = con.createStatement();
                        ResultSet rsMesesStockMinimo = stMesesStockMinimo.executeQuery(mesesStockMinimo);
                        float nroMesesMaximo =0;
                        if (rsMesesStockMinimo.next()) {
                            nroMesesMaximo = (rsMesesStockMinimo.getFloat(2)) / 30;
                            System.out.println("nro meses max "+nroMesesMaximo);
                        }
                    stockMaximo = stockMinimo + (salidasBacoMes * nroMesesMaximo * nroMeses);
                    String sqlUpd = "update materiales set stock_minimo_material=" + stockMinimo + ", stock_seguridad=" + stockReposicion + ", " +
                            " stock_maximo_material=" + stockMaximo + " where cod_material=" + codMaterial + "";
                    Statement stUpd = con.createStatement();
                    stUpd.executeUpdate(sqlUpd);
                    System.out.println("UPD STOCKS:.........." + sqlUpd);

                
                   sdf=new SimpleDateFormat("dd/MM/yyyy");
                    out.print("<td >" +(res.getTimestamp("FECHA_EMISION")!=null?sdf.format(res.getTimestamp("FECHA_EMISION")):"&nbsp;") + " &nbsp;</td>");
                    out.print("<td >" +res.getString("NOMBRE_TIPO_COMPRA") + "&nbsp;</td>");
                    out.print("<td >" + res.getString("NOMBRE_TIPO_TRANSPORTE") + "&nbsp;</td>");
                    out.print("<td >" + cantItemEnLote + "</td>");
                    out.print("<td >" + format.format(totalSalidasAlmacen) + "</td>");
                    out.print("<td >" + format.format(res.getDouble("totalSalidasAlmacenTrimestre")) + "</td>");
                    out.print("<td >" +(res.getTimestamp("fechaUltimaSalida")!=null?sdf.format(res.getTimestamp("fechaUltimaSalida")):"&nbsp;") + " &nbsp;</td>");
                    out.print("<td >" + format.format(res.getDouble("cantidadUltimaSalida")) + "</td>");
                    out.print("<td>"+res.getString("codLoteUltimaSalida")+"</td>");
                    out.print("<td >" + format.format(nroMeses) + "</td>");
                    out.print("<td >" + format.format(stockMinimo) + "</td>");
                    out.print("<td >" + format.format(nroMesesReposicion) + "</td>");
                    out.print("<td >" + format.format(stockReposicion) + "</td>");
                    out.print("<td >" + format.format(res.getDouble("cantidadAprobadosTransitorio")) + "</td>");
                    out.print("<td >" + format.format(res.getDouble("cantidadCuarentenaTransitorio")) + "</td>");
                    out.print("<td >" + format.format(res.getDouble("cantidadAprobados")) + "</td>");
                    out.print("<td >" + format.format(res.getDouble("cantidadVencidos")) + "</td>");
                    out.print("<td >" + format.format(res.getDouble("cantidadRechazados")) + "</td>");
                    out.print("<td >" + format.format(res.getDouble("cantidadReanalisis")) + "</td>");
                    out.print("<td >" + format.format(cantidad_neta_transito) + "</td>");
                    out.print("<td >&nbsp;" + (fechaEntrega==null?"":sdfDias.format(fechaEntrega)) + "</td>");
                    out.print("<td >&nbsp;" + res.getString("NOMBRE_PROVEEDOR")+ "</td>");
                    out.print("<td >&nbsp;" + ordenCompra + "</td>");
                    out.print("<td >&nbsp;" + (stockReposicion>(res.getDouble("cantidadAprobados")+res.getDouble("cantidadAprobadosTransitorio")+res.getDouble("cantidadCuarentenaTransitorio")+cantidad_neta_transito)?format.format(stockReposicion-(res.getDouble("cantidadAprobados")+res.getDouble("cantidadAprobadosTransitorio")+res.getDouble("cantidadCuarentenaTransitorio")+cantidad_neta_transito)):"no") + "</td>");
                    out.print("</tr>");
                    
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
                %>

            </table>

        </form>
    </body>
</html>