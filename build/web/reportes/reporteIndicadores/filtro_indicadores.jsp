package reportes.reporteIndicadores;

<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import="com.cofar.util.*" %>
<%@ page language="java" import="javazoom.upload.*,java.util.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%! Connection con=null;
%>
<%
con=CofarConnection.getConnectionJsp();    
%>

<html>
    <head>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script src="../js/general.js"></script>
        <script>
            
    function detalle(f){
          var arrayLineas=new Array();
          var j=0;
          izquierda = (screen.width) ? (screen.width-300)/2 : 100; 
          arriba = (screen.height) ? (screen.height-400)/2 : 200; 
          izquierda = 0; 
          arriba = 0; 
          var fecha1=f.fecha1.value;
          var fecha2=f.fecha2.value;
          var divi=f.division.value;
          url='reporte_indicadores.jsf?fecha1='+fecha1+'&fecha2='+fecha2+'&area='+divi;
          opciones='toolbar=1,location=0,directories=0,status=0,menubar=1,scrollbars=1,resizable=1,width=900,height=500,left='+izquierda+ ',top=' + arriba + '' 
          window.open(url, 'popUp',opciones,'_blank')
    }
    
    function resumen(f){
          var arrayLineas=new Array();
          var j=0;
          izquierda = (screen.width) ? (screen.width-300)/2 : 100; 
          arriba = (screen.height) ? (screen.height-400)/2 : 200; 
          izquierda = 0; 
          arriba = 0; 
          var fecha1=f.fecha1.value;
          var fecha2=f.fecha2.value;
          var divi=f.division.value;
          url='reporte_indicadores.jsf?fecha1='+fecha1+'&fecha2='+fecha2+'&area='+divi;
          opciones='toolbar=1,location=0,directories=0,status=0,menubar=1,scrollbars=1,resizable=1,width=900,height=500,left='+izquierda+ ',top=' + arriba + '' 
          window.open(url, 'popUp',opciones,'_blank')
    }
        </script>
    </head>
    <body >
        <br>
        <br>
        <h4 align="center">Listado de Indicadores de Trabajo</h4>
        <form  >
            <div align="center">
                <table border="0" style="border : solid #CCCCCC 1px;"  class="outputText2" align="center" width="50%">
                    <tr class="headerClassACliente">
                        <td  colspan="5" >
                            <div class="outputText2" align="center">
                                Introduzca Datos
                            </div>    
                        </td>
                        
                    </tr>
                    <tr>
                        <td >Area Empresa</td>
                        <td >::</td>
                        <td >
                            
                            <%
                            try{
                                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                String sql="select cod_area_empresa,nombre_area_empresa from areas_empresa";
                                sql+=" where cod_estado_registro=1 " +
                                        " order by nombre_area_empresa";
                                System.out.println("sql:"+ sql);
                                
                                ResultSet rs = st.executeQuery(sql);
                            %> 
                            
                            <select name="division" class="inputText2" >
                                <option value="1">DIVISION ADMINISTRATIVA</option>
                                <option value="2">DIVISION COMERCIAL</option>
                                <option value="3">DIVISION INDUSTRIAL</option>
                                
                            </select>
                            <%
                            
                            } catch(Exception e) {
                            }               
                            %>            
                        </td>
                    </tr>
                    <%
                    Date fechaSistema=new Date();
                    SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");
                    String fechaActual = formatoFecha.format(fechaSistema);
                    String[] fechaIniMes = fechaActual.split("/");
                    String fechaInicioMes="01/"+fechaIniMes[1]+"/"+fechaIniMes[2];
                    
                    %>
                    
                    <tr class="outputText3">
                        <td>Fecha Inicio</td>
                        <td>::</td>
                        <td>
                            <input type="text" class="outputText3" size="16"  value="<%=fechaInicioMes%>" name="fecha1">
                            <img id="imagenFecha1" src="../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7;font-family: verdana; color:000000;" navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fecha1" click_element_id="imagenFecha1">
                            </DLCALENDAR>
                        </td>
                    </tr>
                    <tr class="outputText3">
                        <td>Fecha Final</td>
                        <td>::</td>
                        <td>
                            <input type="text" class="outputText3" size="16"  value="<%=fechaActual%>" name="fecha2">
                            <img id="imagenFecha2" src="../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7;
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fecha2" click_element_id="imagenFecha2">
                            </DLCALENDAR>
                        </td>
                    </tr>
                    
                </table> 
                <br>
                
                
                
            </div>
            <center>
                <input type="button" class="btn" size="35" value="Detallado" onclick="detalle(this.form);">
                <input type="button" class="btn" size="35" value="Resumido" onclick="resumen(this.form);">
            </center>
        </form>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
    </body>
</html>