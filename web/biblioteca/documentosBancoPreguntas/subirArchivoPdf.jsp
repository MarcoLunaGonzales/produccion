<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.sql.Statement"%>
<%@ page import="com.cofar.util.*" %>
<%@ page language="java" import="java.util.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%! Connection con = null;
%>
<%
//con=CofarConnection.getConnectionJsp();
        con = Util.openConnection(con);
        String codDocumentacion = request.getParameter("codDocumentacion");
        System.out.println("documentacion " + codDocumentacion);
        if(codDocumentacion==null){
            out.println("<script>this.parent.ocultaRegistro1();this.parent.location='navegadorPreguntasDocumentacions.jsf?ia='+Math.random()</script>");
        }

%>
<html>
    <head>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
    </head>
    <body>
        <form method="post" action="cargarDepositos.jsf" name="upform" enctype="multipart/form-data">
            <div align="center">

                <div class="outputText2" align="center" style="font-size:14px">
                    <b> Cargar Datos</b>
                </div>


                <table border="0" class="outputText2" style="border:1px solid #000000" cellspacing="0" cellpadding="0" width="50%">
                    <tr class="headerClassACliente">
                        <td  colspan="3" >
                            <div class="outputText2" align="center">
                                Introduzca los Parámetros
                            </div>
                        </td>
                    </tr>
                    <%--tr>
                        <td>
                            Entidad Financiera ::
                        </td>
                            <%
                                try {
                                con = Util.openConnection(con);
                                System.out.println("con:::::::::::::" + con);
                                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

                                String sql = "select ef.COD_ENTIDAD_FINANCIERA,ef.NOMBRE_ENTIDAD_FINANCIERA from ENTIDADES_FINANCIERAS ef  " +
                                        "where ef.COD_ESTADO_REGISTRO=1 AND cod_plan_cuenta>0 order by ef.NOMBRE_ENTIDAD_FINANCIERA";
                        System.out.println("sql filtro:" + sql);
                        ResultSet rs = st.executeQuery(sql);
                                    %>
                        <td class="">
                            <select name="codEntidadFinanciera" class="outputText3" >
                                <%
                            String codEntidadFinanciera = "";
                            String nombreEntidadFinanciera = "";
                            while (rs.next()) {
                                codEntidadFinanciera = rs.getString("COD_ENTIDAD_FINANCIERA");
                                nombreEntidadFinanciera = rs.getString("NOMBRE_ENTIDAD_FINANCIERA");
                                out.print("<option value="+codEntidadFinanciera+" >"+nombreEntidadFinanciera+"</option>");

                            }%>
                            </select>
                            <!--  <input type="checkbox"  onclick="selecccionarTodo(form1)" name="chk_todoTipo" >Todo-->
                            <%
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                            %>
                        </td>

                    </tr>
                    <tr>
                        <td>Fecha Ingreso Deposito ::</td>
                         <td class="">
                             <%
                                SimpleDateFormat form = new SimpleDateFormat("dd/MM/yyyy");
                                Date fecha_deposito = new Date();
                                String fecha1 = form.format(fecha_deposito);
                                String fechaDepositoIngreso = "01";
                                fecha1.substring(2, 10);
                                fechaDepositoIngreso = fechaDepositoIngreso + fecha1.substring(2, 10);
                            %>
                            <input type="text" class="outputText3" size="16"  value="<%=fechaDepositoIngreso%>" name="fechaIngresoDeposito"   >
                            <img id="imagenFecha1" src="../../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                daybar_style="background-color: DBE1E7;
                                font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                input_element_id="fechaIngresoDeposito" click_element_id="imagenFecha1">
                            </DLCALENDAR>
                        </td>
                    </tr--%>

                    <tr>
                        <td>
                            Archivo::
                        </td>
                        <td>
                            <input type="file"       id="uploadfile" name="uploadfile" class="inputText"  value="Cargar Archivo" size="30" onmouseover="this.title=this.value"  >
                            <input type="hidden" id="codDocumentacion" name="codDocumentacion" value="<%=codDocumentacion%>">
                        </td>
                    </tr>

                </table>


                <br>
                <center>
                    <input type="submit" class="btn" value="Actualizar" name="reporte" >
                    <button class="btn" onclick="parent.ocultaRegistro1();">Cancelar</button>
                    <input type="hidden" name="todo" value="upload">
                </center>


            </div>


        </form>

        <script type="text/javascript" language="JavaScript"  src="../../css/dlcalendar.js"></script>

    </body>
</html>