

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


<%! Connection con = null;
%>
<%
//con=CofarConnection.getConnectionJsp();
con = Util.openConnection(con);

%>



<html>
    <head>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
        <script>
            function cancelar(){
                // alert(codigo);
                location='../personal_jsp/navegador_personal.jsf';
            }
            function cargarAlmacen(f){
                var codigo=f.codAreaEmpresa.value;
                location.href="filtroReporteExistencias.jsp?codArea="+codigo;
            }
            function cargar(f){
                var codigo=f.codPersonal.value;
                //alert(codigo)
                izquierda = (screen.width) ? (screen.width-300)/2 : 100
                arriba = (screen.height) ? (screen.height-400)/2 : 200
                url='../barcode?number=1&location='+codigo;
                //url='../codigo_barras.jsf?codigo='+codigo+'&codFormula='+codFormula+'&nombre='+nombre+'&cantidad='+cantidad+'&cod_comp_prod='+codComProd+'&cod_lote='+codLote;
                //alert(url);
                opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,width=700,height=400,left='+izquierda+ ',top=' + arriba + ''
                window.open(url, 'popUp',opciones)
            }

        </script>
    </head>
    <body><br><br>
        <h3 align="center">Código de Barras Personal</h3>
        
        <form method="post" action="" target="_blank">
            <div align="center">
                <table border="0"  border="0" class="border" width="50%">
                    <tr class="headerClassACliente">
                        <td  colspan="3" >
                            <div class="outputText3" align="center">
                                Introduzca Datos
                            </div>
                        </td>
                        
                    </tr>
                    <tr class="outputText3" >
                        <td class="">Personal</td>
                        <td class="">::</td>
                        <%
                        try {
                            con = Util.openConnection(con);
                            System.out.println("con:::::::::::::" + con);
                            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            String sql="select cod_personal,ap_paterno_personal,ap_materno_personal,nombres_personal from personal" +
                            " order by ap_paterno_personal,ap_materno_personal,nombres_personal ";
                            System.out.println("sql filtro:" + sql);
                            ResultSet rs = st.executeQuery(sql);
                        %>
                        <td class="">
                            <select name="codPersonal" class="outputText3" >
                                <option value="0">Seleccione una opción</option>
                                <%
                                String codPersonal = "";
                                String nombrePersonal= "";
                                while (rs.next()) {
                                    codPersonal = rs.getString(1);
                                    nombrePersonal = rs.getString(2)+" "+rs.getString(3)+" "+rs.getString(4);
                                %>
                                <option value="<%=codPersonal%>"><%=nombrePersonal%></option>
                                <%
                                }%>
                            </select>
                            <%
                            
                            } catch (Exception e) {
                            }
                            %>
                        </td>
                    </tr>
                    
                       
                </table>
                
            </div>
            <br>
            <center>
                <input type="button"   class="commandButton" size="35" value="Imprimir" onclick="cargar(this.form);" name="reporte" >
                
            </center>
        </form>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
    </body>
</html>