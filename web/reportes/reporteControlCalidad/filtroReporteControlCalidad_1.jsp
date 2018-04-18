

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
            function cancelar(){
                // alert(codigo);
                location='../personal_jsp/navegador_personal.jsf';
            }
            function cargarAlmacen(f){
                var codigo=f.codAreaEmpresa.value;
                location.href="filtroReporteExistencias.jsp?codArea="+codigo;
            }
             /****************** NUEVO AJAX ********************/
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
                ajax.open("GET","ajaxLotes.jsf?lote="+lote.value+"&codComprod="+codComprod+"&alea="+Math.random(),true);
                ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {
                        div_lotes.innerHTML=ajax.responseText;
                    }
                }

                ajax.send(null);

            }
            function verReporte(f){

                   var count=0;
                   var elements=document.getElementById('dataLote');
                   var rowsElement=elements.rows;
                   var codLote="ninguno";
                   for(var i=1;i<rowsElement.length;i++){
                       
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    if(cel.getElementsByTagName('input').length>0)
                        {
                            if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                                //alert(cel.getElementsByTagName('input')[0].checked);
                                  if(cel.getElementsByTagName('input')[0].checked){
                                   codLote=cellsElement[1].getElementsByTagName("span")[0].innerHTML;
                                   f.codForma.value=cellsElement[1].getElementsByTagName("input")[0].value;
                                   f.codProd.value=cellsElement[2].getElementsByTagName("input")[0].value;
                                   count++;
                                 }

                             }
                        }

                   }
                  
                    
                  if(count==1){
                      f.codLote.value=codLote;
                      f.submit();
                      return true;
                   } else if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                   }
                   else if(count>1){
                       alert('Solo puede escoger un registro');
                       return false;
                   }
                   form1.submit();

                }

        </script>
    </head>
    <body><br><br>
        <h3 align="center">Reporte Control de Calidad</h3>

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
                                            " from COMPONENTES_PROD cp where cp.COD_COMPPROD in (select ra.COD_COMPROD from RESULTADO_ANALISIS ra)" +
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
                        <td colspan="3"><div id="divLotes" style="height:200px;overflow:auto;"></div>
                        </td>
                    </tr>
                  
                </table>

            </div>
            <br>
            <center>
                <input type="button"   class="btn" size="35" value="Ver Reporte" onclick="verReporte(form1)" name="reporte" >
                <input type="hidden" name="codLote" id="codLote">
                <input type="hidden" name="codProd" id="codProd">
                <input type="hidden" name="codForma" id="codForma">
            </center>
        </form>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
    </body>
</html>