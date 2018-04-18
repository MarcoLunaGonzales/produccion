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
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../../js/general.js"></script>
        <script>
            var cod=0;
            function verCertificadoPDf(direccion)
            {
                izquierda = (screen.width) ? (screen.width-300)/2 : 100
                arriba = (screen.height) ? (screen.height-400)/2 : 200
                var url=direccion+'?codP='+Math.random();
                 opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,width=700,height=400,left='+izquierda+ ',top=' + arriba + ''
                 cod++;
                window.open("../../cotizaciones/certificadosCCC/"+url,('popUp'+cod),opciones)
            }
            function nuevoAjax()
            {	var xmlhttp=false;
                try {
                    xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
                } catch (e) {
                    try {
                        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
                    } catch (E) {
                        xmlhttp = false;
                    }
                }
                if (!xmlhttp && typeof XMLHttpRequest!="undefined") {
                    xmlhttp = new XMLHttpRequest();
                }

                return xmlhttp;
            }
            function buscarLote()
            {
                
                ajax=nuevoAjax();
                var div_lotes=document.getElementById("divLotes");
                var lote=document.getElementById("lote");
               // alert(lote.value);
               var codComprod=document.getElementById('codComprod').value;
                ajax.open("GET","ajaxLotesRegional.jsf?lote="+lote.value+"&codComprod="+codComprod+"&alea="+Math.random(),true);
                ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        div_lotes.innerHTML=ajax.responseText;
                    }
                }

                ajax.send(null);

            }
            function verReporte(codLote,codForma,codProd)
            {
                var f=document.getElementById("form1");
                f.codForma.value=codForma;
                f.codProd.value=codProd;
                f.codLote.value=codLote;
                f.submit();
            }

        </script>
    </head>
    <body>
        <h3 align="center">Reporte Control de Calidad(Regional)</h3>

        <form id="form1" method="post" action="reporteControlCalidad.jsp" target="_blank">
            <div align="center">
                <table border="0"  border="0" class="tablaFiltroReporte" width="50%">
                    <tr class="headerClassACliente">
                        <td  colspan="3" >
                            <div class="outputText3" align="center">
                                Introduzca Datos
                            </div>
                        </td>

                    </tr>
                    <tr>
                        <td class="outputText2">Lote</td>
                        <td class="outputText2">:</td>
                        <td><input value="" class="inputText" type="text" id="lote"/> </td>
                        
                    </tr>
                    <tr>
                        <td class="outputText2">Producto</td>
                        <td class="outputText2"s>:</td>
                        <td>
                            <select  class="inputText" id="codComprod">
                                <option value="0">-TODOS-</option>
                            <%
                            Connection con=null;
                            con=Util.openConnection(con);
                            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            String consulta="select cp.COD_COMPPROD,cp.nombre_prod_semiterminado"+
                                            " from COMPONENTES_PROD cp where  cp.COD_COMPPROD in (select ra.COD_COMPROD from RESULTADO_ANALISIS ra where ra.COD_ESTADO_RESULTADO_ANALISIS=1)" +
                                            "order by cp.nombre_prod_semiterminado";
                            ResultSet res=st.executeQuery(consulta);
                            while(res.next())
                            {
                                out.println("<option value='"+res.getString("COD_COMPPROD")+"'>"+res.getString("nombre_prod_semiterminado")+"</option>");
                            }
                            res.close();
                            st.close();
                            con.close();
                            
                            %>
                            </select>
                        </td>

                    </tr>
                    <tr>
                        <td colspan="3"><center><input type="button" class="btn" value="BUSCAR" onclick="buscarLote()"/>
                        </center></td>
                        
                    </tr>
                    <tr class="outputText3">
                        <td colspan="3">
                            <center><div id="divLotes"></div></center>
                        </td>
                    </tr>
                  
                </table>

            </div>
            <br>
            <center>
                <input type="hidden" name="codLote" id="codLote">
                <input type="hidden" name="codProd" id="codProd">
                <input type="hidden" name="codForma" id="codForma">
            </center>
        </form>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
    </body>
</html>