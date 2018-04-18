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
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>

        
        <title>JSP Page</title>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <style type="text/css">
            .celdaCalculo
            {
                background-color: #fce9b0;
            }
            .celdaExistencia
            {
                background-color:#cdeecd;
            }
            .hidden
            {
                display: none;
            }
            .stockHermes
            {
                background-color:#ffddfb;
            }
        </style>
        <script src="../../js/general.js"></script>
    </head>
    <body>
        <h3 align="center">Calculo de Stocks de Materiales</h3>
        <br>
        <form>
            <%
                SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
            %>
            <table align="center" width="90%">
                <tr>
                    <td align="left" width="25%" rowspan="3"><img src="../../img/cofar.png"></td>
                    <td class="outputTextBold">Grupo</td>
                    <td class="outputTextBold">::</td>
                    <td class="outputText2"><%=(request.getParameter("nombreGrupoP"))%></td>
                </tr>
                <tr>
                    <td class="outputTextBold">Almacen</td>
                    <td class="outputTextBold">::</td>
                    <td class="outputText2"><%=(request.getParameter("nombreAlmacenP"))%></td>
                </tr>
                <tr>
                    <td class="outputTextBold">A fecha</td>
                    <td class="outputTextBold">::</td>
                    <td class="outputText2"><%=(sdf.format(new Date()))%></td>
                </tr>
            </table>
            <table width="100%" class="tablaReporte" cellpadding="0" cellspacing="0">
                <thead>
                    <tr>
                        <td>Material</td>
                        <td>Grupo</td>
                        <td>Capitulo</td>
                        <td>Unidad de Medida</td>
                        <td>Ultima Fecha Compra</td>
                        <td>Ultimo Tipo Compra</td>
                        <td>Ultimo Tipo Transporte</td>
                        <td>Cantidad en Lote</td>
                        <td>Maximo Hermes (Presentación)</td>
                        <td>Cantidad Maximo Hermes</td>
                        <td>Salidas Año Movil</td>
                        <td>Salidas Ultimo Trimestre</td>
                        <td>Fecha Ultima Salida</td>
                        <td>Cantidad Ultima Salida</td>
                        <%--td class="hidden" >Nivel Maximo de Stock</td>
                        <td class="hidden">Nivel Minimo de Stock</td>
                        <td class="hidden">Numero de ciclos de reaprovisionamiento</td>
                        <td class="hidden">DM</td>
                        <td class="hidden">Nro. Meses Stock Seguridad</td>
                        <td>Stock Seguridad</td>
                        <td class="hidden">Nro. Meses Punto de Pedido</td--%>
                        <td>Stock Punto de Pedido</td>
                        <td>Aprobados</td>
                        <td>Cuerentena</td>
                        <td class="hidden">Vencidos</td>
                        <td class="hidden">Rechazados</td>
                        <td>Reanalisis</td>
                        <td>Cantidad Transito</td>
                        <td>Fecha Entrega</td>
                        <td>Proveedor Ultima Compra</td>
                        <%--td class="hidden">Ordenes de Compra</td--%>
                        <td>ALARMA DE COMPRA</td>
                    </tr>
                </thead>

                <%
                    Connection con = null;
                    NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                    DecimalFormat format = (DecimalFormat) nf;
                    format.applyPattern("#,##0.00");
                    String codGrupo = request.getParameter("codGrupoP");
                    String codAlmacen = request.getParameter("codAlmacenP")==null?"0":request.getParameter("codAlmacenP");
                    SimpleDateFormat sdf1= new SimpleDateFormat("dd/MM/yyyy");
                    try 
                    {
                        con=Util.openConnection(con);
                        sdf = new SimpleDateFormat("yyyy/MM/dd");
                        StringBuilder consulta=new StringBuilder("update materiales");
                                                consulta.append(" set stock_minimo_material=?,");
                                                        consulta.append(" stock_seguridad=?,");
                                                        consulta.append(" stock_maximo_material=?");
                                                consulta.append(" where cod_material=?");
                        PreparedStatement pstUp=con.prepareStatement(consulta.toString());
                        System.out.println("consulta registrar stock reposicion "+consulta.toString());
                                    
                        consulta=new StringBuilder(" SET NOCOUNT ON DECLARE @codigosAlmacen TdatosIntegerRef ");
                                            consulta.append(" DECLARE @codigosGrupo TdatosIntegerRef");
                                            consulta.append(" INSERT INTO @codigosAlmacen VALUES (0)");
                                            for(String codAlmacenRef:codAlmacen.split(","))
                                                consulta.append(" ,(").append(codAlmacenRef).append(")");
                                            consulta.append(" INSERT INTO @codigosGrupo VALUES (0)");
                                            for(String codGrupoRef:codGrupo.split(","))
                                                consulta.append(" ,(").append(codGrupoRef).append(") ");
                                            consulta.append(" exec PAA_CALCULO_STOCK_MP_EP ?,@codigosAlmacen,@codigosGrupo");
                                            consulta.append(" SET NOCOUNT OFF");
                        System.out.println("consulta GRUPOS MATERIALES" + consulta.toString());
                        PreparedStatement pst=con.prepareStatement(consulta.toString());
                        pst.setString(1,sdf.format(new Date())+" 23:59:59");
                        ResultSet res = pst.executeQuery();
                        while (res.next()) 
                        {
                            Double salidasAnioMovil=res.getDouble("totalSalidasAnioMovil");
                            Double salidasTrimestral=res.getDouble("totalSalidasAlmacenTrimestre");
                            boolean verificarStockHermes=res.getInt("VERIFICAR_STOCK_HERMES")>0;
                            Double stockMaximoHermes=res.getDouble("stockHermes");
                            //en caso de empaque secundario solo salidas con lote
                            if(res.getInt("COD_CAPITULO")==4||res.getInt("COD_CAPITULO")==8)
                            {
                                salidasAnioMovil=res.getDouble("totalSalidasAnioMovilLote");
                                salidasTrimestral=res.getDouble("totalSalidasAlmacenTrimestreLote");
                            }
                            
                            Double consumoMensualPromedio=(salidasAnioMovil/12);
                            Double dm=(res.getDouble("NUMERO_CICLOS")>0?(consumoMensualPromedio*res.getDouble("NIVEL_MAXIMO_STOCK")+consumoMensualPromedio*res.getDouble("NIVEL_MINIMO_STOCK"))/2/res.getDouble("NUMERO_CICLOS"):0);
                            Double stockMinimo=(dm*res.getDouble("NRO_MESES_STOCK_MINIMO"));
                            Double stockReposicion=stockMinimo+(dm*res.getDouble("NRO_MESES_STOCK_REPOSICION"));
                            Double stockMaximo=(consumoMensualPromedio*res.getDouble("NIVEL_MAXIMO_STOCK"));
                            
                            
                            //para empaque primario y secundarion si la cantidad para el lote supera el calculo de stock de reposision se setea al tamanio del lote
                            if((res.getInt("verificaCantidadLote")>0)&&(res.getDouble("cantidadLote")>stockReposicion)&&(!verificarStockHermes))
                                stockReposicion=res.getDouble("cantidadLote");
                            if(verificarStockHermes)
                            {
                                if(res.getInt("COD_CAPITULO")==3)
                                {
                                    if(res.getDouble("cantidadEpHermes")>stockReposicion)
                                    {
                                        stockReposicion=res.getDouble("cantidadEpHermes");
                                    }
                                }
                                else
                                {
                                    if(stockMaximoHermes>stockReposicion)
                                    {
                                        stockReposicion=stockMaximoHermes;
                                    }
                                }
                                    
                            }
                            out.println("<tr>");
                                    out.println("<td>"+res.getString("NOMBRE_MATERIAL")+"</td>");
                                    out.println("<td>"+res.getString("NOMBRE_GRUPO")+"</td>");
                                    out.println("<td>"+res.getString("NOMBRE_CAPITULO")+"</td>");
                                    out.println("<td>"+res.getString("ABREVIATURA")+"</td>");
                                    out.println("<td>"+(res.getTimestamp("FECHA_EMISION")!=null?sdf.format(res.getTimestamp("FECHA_EMISION")):"")+ "</td>");
                                    out.println("<td>"+res.getString("NOMBRE_TIPO_COMPRA")+ "</td>");
                                    out.println("<td>"+ res.getString("NOMBRE_TIPO_TRANSPORTE") + "</td>");
                                    out.println("<td>"+format.format(res.getDouble("cantidadLote"))+"</td>");
                                    out.println("<td class='stockHermes'>"+(verificarStockHermes?format.format(stockMaximoHermes):"--No aplica--")+"</td>");
                                    out.println("<td class='stockHermes'>"+(verificarStockHermes?format.format(res.getDouble("cantidadEpHermes")):"--No aplica--")+"</td>");
                                    out.println("<td>"+format.format(salidasAnioMovil)+"</td>");
                                    out.println("<td>"+format.format(salidasTrimestral)+"</td>");
                                    out.println("<td>"+(res.getTimestamp("fechaUltimaSalida")!=null?sdf.format(res.getTimestamp("fechaUltimaSalida")):"&nbsp;") + "</td>");
                                    out.println("<td>"+format.format(res.getDouble("cantidadUltimaSalida")) + "</td>");
                                    /*out.println("<td class='celdaCalculo tdRight hidden'>"+format.format(res.getDouble("NIVEL_MAXIMO_STOCK"))+"</td>");
                                    out.println("<td class='celdaCalculo tdRight hidden'>"+format.format(res.getDouble("NIVEL_MINIMO_STOCK"))+"</td>");
                                    out.println("<td class='celdaCalculo tdRight hidden'>"+format.format(res.getDouble("NUMERO_CICLOS"))+"</td>");
                                    out.println("<td class='celdaCalculo tdRight hidden'>"+format.format(dm)+"</td>");
                                    out.println("<td class='celdaCalculo tdRight hidden'>"+res.getDouble("NRO_MESES_STOCK_MINIMO")+"</td>");
                                    out.println("<td class='celdaCalculo tdRight'>"+format.format(stockMinimo)+"</td>");
                                    out.println("<td class='celdaCalculo tdRight hidden'>"+res.getDouble("NRO_MESES_STOCK_REPOSICION")+"</td>");*/
                                    out.println("<td class='celdaCalculo tdRight'>"+format.format(stockReposicion)+"</td>");
                                    out.println("<td class='celdaExistencia tdRight'>"+format.format(res.getDouble("cantidadAprobados")) +"</td>");
                                    out.println("<td class='celdaExistencia tdRight'>"+format.format(res.getDouble("cantidadCuarentena")) + "</td>");
                                    out.println("<td class='celdaExistencia tdRight hidden'>"+format.format(res.getDouble("cantidadVencidos")) + "</td>");
                                    out.println("<td class='celdaExistencia tdRight hidden'>"+format.format(res.getDouble("cantidadRechazados")) + "</td>");
                                    out.println("<td class='celdaExistencia tdRight'>"+format.format(res.getDouble("cantidadReanalisis")) + "</td>");
                                    out.println("<td>"+format.format(res.getDouble("cantidadTransito")) + "</td>");
                                    out.println("<td>&nbsp;" + (res.getTimestamp("fechaEntregaTransito")==null?"":sdf1.format(res.getTimestamp("fechaEntregaTransito"))) + "</td>");
                                    out.println("<td>" + res.getString("NOMBRE_PROVEEDOR") + "</td>");
                                    /*out.println("<td class>"+res.getString("ocPendientes")+"</td>");*/
                                    out.println("<td>&nbsp;" + (stockReposicion>(res.getDouble("cantidadAprobados")+res.getDouble("cantidadCuarentena")+res.getDouble("cantidadTransito"))?format.format(stockReposicion-(res.getDouble("cantidadAprobados")+res.getDouble("cantidadCuarentena")+res.getDouble("cantidadTransito"))):"no") + "</td>");
                            out.println("</tr>");
                    pstUp.setDouble(1,stockMinimo);System.out.println("pstStock p1: "+stockMinimo);
                    pstUp.setDouble(2,stockReposicion);System.out.println("pstStock p2: "+stockReposicion);
                    pstUp.setDouble(3,stockMaximo);System.out.println("pstStock p3: "+stockMaximo);
                    pstUp.setInt(4,res.getInt("COD_MATERIAL"));System.out.println("pstStock p4: "+res.getInt("COD_MATERIAL"));
                    if(pstUp.executeUpdate()>0)System.out.println("se actualizo el stock de reposicion");
                    
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        catch(Exception ex)
        {
            ex.printStackTrace();
        }
        finally
        {
            con.close();
        }
    %>

            </table>

        </form>
    </body>
</html>