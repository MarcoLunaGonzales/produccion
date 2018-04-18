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
                        <td>Salidas Año Movil</td>
                        <td>Salidas Ultimo Trimestre</td>
                        <td>Salidas Mensual</td>
                        <td>Aprobados</td>
                        <%--td>STOCK MINIMO</td--%>
                        <td>STOCK REPOSICIÓN</td>
                        <td>STOCK MAXIMO</td>
                        <td>Cantidad Transito</td>
                        <td>Fecha Entrega</td>
                        <td>Proveedor Ultima Compra</td>
                        <td>Comprar</td>
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
                                            consulta.append(" exec PAA_CALCULO_STOCK_OTROS ?,@codigosAlmacen,@codigosGrupo");
                                            consulta.append(" SET NOCOUNT OFF");
                        System.out.println("CONSULTA GRUPOS MATERIALES" + consulta.toString());
                        PreparedStatement pst=con.prepareStatement(consulta.toString());
                        pst.setString(1,sdf.format(new Date())+" 23:59:59");
                        ResultSet res = pst.executeQuery();
                        while (res.next()) 
                        {
                            Double salidasAnioMovil=res.getDouble("totalSalidasAnioMovil");
                            Double salidasTrimestral=res.getDouble("totalSalidasAlmacenTrimestre");
                            Double salidasMensual=salidasAnioMovil/12;
                            Double stockMinimo=salidasMensual*2;
                            Double stockReposicion=stockMinimo+salidasMensual*0.5;
                            Double stockMaximo=salidasMensual*4;
                            
                            out.println("<tr>");
                                    out.println("<td>"+res.getString("NOMBRE_MATERIAL")+"</td>");
                                    out.println("<td>"+res.getString("NOMBRE_GRUPO")+"</td>");
                                    out.println("<td>"+res.getString("NOMBRE_CAPITULO")+"</td>");
                                    out.println("<td>"+res.getString("ABREVIATURA")+"</td>");
                                    out.println("<td>"+(res.getTimestamp("FECHA_EMISION")!=null?sdf.format(res.getTimestamp("FECHA_EMISION")):"")+ "</td>");
                                    out.println("<td>"+format.format(salidasAnioMovil)+"</td>");
                                    out.println("<td>"+format.format(salidasTrimestral)+"</td>");
                                    out.println("<td>"+format.format(salidasAnioMovil/12)+"</td>");
                                    out.println("<td class='celdaExistencia tdRight'>"+format.format(res.getDouble("cantidadAprobados")) +"</td>");
                                    //out.println("<td>"+format.format(stockMinimo)+"</td>");
                                    out.println("<td>"+format.format(stockReposicion)+"</td>");
                                    out.println("<td>"+format.format(stockMaximo)+"</td>");
                                    out.println("<td>"+format.format(res.getDouble("cantidadTransito")) + "</td>");
                                    out.println("<td>&nbsp;" + (res.getTimestamp("fechaEntregaTransito")==null?"":sdf1.format(res.getTimestamp("fechaEntregaTransito"))) + "</td>");
                                    out.println("<td>" + res.getString("NOMBRE_PROVEEDOR") + "</td>");
                                    out.println("<td>" +(res.getDouble("cantidadAprobados")<=(stockReposicion+res.getDouble("cantidadTransito"))?format.format(stockMaximo-res.getDouble("cantidadAprobados")-res.getDouble("cantidadTransito")):"NO")+ "</td>");
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