<%@ page import="java.sql.*" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%! Connection con=null;       
%>
<%
     con=Util.openConnection(con);
%>

<style type="text/css">
    .tituloCampo1{
    font-family: Verdana, Arial, Helvetica, sans-serif;
    font-size: 11px;
    font-weight: bold;
    }
    .outputText2{          
    font-family: Verdana, Arial, Helvetica, sans-serif;
    font-size: 11px;    
    }
    .inputText2{          
    font-family: Verdana, Arial, Helvetica, sans-serif;
    font-size: 11px;    
    }
    .commandButtonR{
    font-family: Verdana, Arial, Helvetica, sans-serif;
    font-size: 11px;
    width: 150px;
    height: 20px;
    background-repeat :repeat-x;
    background-image: url('../img/bar3.png');
    }
</style>

<script >
function selecccionarTodo(f){
  for(var i=0;i<=f.codMaquina.options.length-1;i++)
  {  
    if (f.chk_todoTipo.checked == true){
       f.codMaquina.options[i].selected=true; 
    }else{
       f.codMaquina.options[i].selected=false; 
  }    
 } 
 return(true);
}
    
function iniciarCarga(f,codigo){                
  f.tipoarchivo.value=codigo;
  if(f.codGestion.value==0){
     alert("Seleccione una Gestión.");
     f.codGestion.focus();
     return false();
  }
  if(f.codMes.value==0){
     alert("Seleccione un Mes.");
     f.codMes.focus();
     return false();
  }
  if(f.uploadfile.value==0){
     alert("Seleccione un Archivo para Cargar Datos.");
     f.uploadfile.focus();
     return false();
  }
  if(window.confirm("Esta seguro de Iniciar la Actualización de Costos?")){
     f.submit();                        
  }
}                 
                
function mandar(){

     var porcentajeVariacion =document.getElementById("PorcentajeVariacion").value;
     
     form1.action="navegadorReportesExploMaterCarga.jsf?porcentajeVariacion="+porcentajeVariacion;
     form1.submit(); 
   }
</script>

<html>
    <head>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
    </head>
    <title>
       Reporte Formula Maestra
    </title>
    <body>
        
        <form method="post" action="navegadorReportesExploMaterCarga.jsf" name="form1" target="_blank" enctype="multipart/form-data">
            
            <div align="center">
                <h4 align="center">REPORTE  DE  VERIFICACION  BACO  -  ATLAS </h4>
                
                <table border="0"  border="0" class="outputText2"  style="border:1px solid #000000"  cellspacing="0">    
                    <tr class="headerClassACliente">
                        <td  colspan="3" >
                            <div class="outputText2" align="center">
                                
                            </div>    
                        </td>
                    </tr>    
                    <tr><td>&nbsp;</td></tr>
                    
                    <tr class="outputText3">
                        <td>&nbsp;&nbsp;<b>Adjuntar Archivo</b></td>
                         <td  class="border">
                            <input type="file" class="outputText2" name="uploadfile" size="58" class="inputText">
                            <input type="hidden" name="todo" value="upload">                              
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;&nbsp;<b>Porcentaje de Variaci�n</b></td>
                        <td>
                            <input type="text"  size="15"  value="" name="PorcentajeVariacion" class="inputText" id="PorcentajeVariacion">
                        </td>
                    </tr>
                </table>
            </div>
            <br>
            <center>                
                <input type="button" class="commandButtonR"  value="Ver Reporte" name="reporte" onclick="mandar();">                
                <input type="reset"   class="commandButtonR"  value="Limpiar" name="limpiar">
            </center>
            
            <input type="hidden" name="codMaquinaF" id="codMaquinaF">
            <input type="hidden" name="codigosPrograma" id="codigosPrograma"> 
            <input type="hidden" name="FechaInicial" id="FechaInicial"> 
            <input type="hidden" name="FechaFinal" id="FechaFinal"> 
            <input type="hidden" name="PORCENTAJE_VARIACION" id="PORCENTAJE_VARIACION"> 
            
        </form>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
    </body>
</html>

