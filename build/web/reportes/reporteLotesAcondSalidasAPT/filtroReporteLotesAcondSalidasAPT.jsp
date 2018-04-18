<%@page contentType="text/html"%>
<%@page pageEncoding="ISO-8859-1"%>
<%@ page language="java" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 

<%@ page import = "java.text.*"%> 
<%@ page import="com.cofar.util.*" %>
<%@ page language="java" import="java.util.*" %>
<%@ page language="java" import="java.util.Date" %>
<%@ page import="com.cofar.web.*" %>
<style type="text/css">
    .tituloCampo1{
    font-family: Verdana, Arial, Helvetica, sans-serif;
    font-size: 11px;
    font-weight: bold;
    }
    .outputText3{          
    font-family: Verdana, Arial, Helvetica, sans-serif;
    font-size: 11px;    
    }
    .inputText3{          
    font-family: Verdana, Arial, Helvetica, sans-serif;
    font-size: 11px;    
    }
    .commandButtonR{
    font-family: Verdana, Arial, Helvetica, sans-serif;
    font-size: 11px;
    width: 150px;
    height: 20px;
    background-repeat :repeat-x;
    
    background-image: url('../../img/bar3.png');
    }
</style>


<html>

    <head>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../../js/general.js"></script>
        <style>
            td{padding:0.3em;}
        </style>    
        <script>
            function cancelar(){
                  // alert(codigo);
                   location='../personal_jsp/navegador_personal.jsf';
            }
            function cargarAlmacen(f){
            var codigo=f.codAreaEmpresa.value;
                location.href="filtro.jsf?codArea="+codigo;
            }
                
        </script>
    </head>
    <body><br>
        <h3 align="center">Reporte Existencias Acond - APT - Prog. Prod.</h3>
        
        <form method="post" action="reporteLotesAcondSalidasAPT.jsp" target="_blank" name="form1">
            <div align="center">
                <table border="0"  class="outputText2" style="border:1px solid #000000" cellspacing="0">
                    <tr class="headerClassACliente">
                        <td  colspan="3" >
                            <div class="outputText3" align="center">
                                Introduzca Datos
                            </div>    
                        </td>                        
                    </tr>                    
                                     
                     <tr>
                        <td class='outputTextBold'>Programa Produción</td>
                        <td class='outputTextBold'>::</td>
                        <td>
                            <select name="codProgramaProd" class="inputText"> 
                        <%
                        try{
                            Connection con=null;
                            con=Util.openConnection(con);
                            Statement st= con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            String consulta="select p.COD_PROGRAMA_PROD,p.NOMBRE_PROGRAMA_PROD from PROGRAMA_PRODUCCION_PERIODO p where p.COD_TIPO_PRODUCCION=1 and p.COD_ESTADO_PROGRAMA<>4 order by p.COD_PROGRAMA_PROD";
                            ResultSet res = st.executeQuery(consulta);
                            while(res.next())
                            {
                                  out.println("<option value='"+res.getInt("COD_PROGRAMA_PROD")+"'>"+res.getString("NOMBRE_PROGRAMA_PROD")+"</option>");
                            }
                        %>
                            </select>
                        </td>
                     </tr>
                     <tr>
                         <td class='outputTextBold'>Producto</td>
                         <td class='outputTextBold'>::</td>
                         <td>
                            <select name="codCompProd" class="inputText"> 
                        <%
                            consulta="select  c.COD_COMPPROD,c.nombre_prod_semiterminado from COMPONENTES_PROD c where c.COD_TIPO_PRODUCCION=1 and c.COD_ESTADO_COMPPROD=1 order by c.nombre_prod_semiterminado";
                            res = st.executeQuery(consulta);
                            while(res.next())
                            {
                                  out.println("<option value='"+res.getInt("COD_COMPPROD")+"'>"+res.getString("nombre_prod_semiterminado")+"</option>");
                            }
                        %>
                            </select>
                        </td>
                     </tr>
                            <%
                            
                            } catch(Exception e) {
                            }               
                            %>       
                    <tr>
                         <td class='outputTextBold'>Lote</td>
                         <td class='outputTextBold'>::</td>
                         <td>
                             <input type="text" value="" id="codLote" name="codLote" class="inputText"/>
                         </td>
                         
                     <tr>
                         <td colspan="3" align='center'>
                             <input type="submit" value="Ver Reporte" class="btn"/>
                         </td>
                     </tr>
                    <input type="hidden" name="codAlmacen">
                    <input type="hidden" name="nombreAlmacen">
                    <input type="hidden" name="codArea">
                    <input type="hidden" name="nombreArea">
                </table>
                
            </div>
            <br>
            <center>
                
                
            </center>
        </form>
        <script type="text/javascript" language="JavaScript"  src="../../js/dlcalendar.js"></script>
    </body>
</html>