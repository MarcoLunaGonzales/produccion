package programaProduccion_1;

<%@ page import="java.sql.*" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%! Connection con=null;
%>
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
    
    background-image: url('../img/bar3.png');
    }
</style>
<script >
            function mandar(f){
                if(f.nombrePrograma.value==""){
                    alert("Nombre vacio.");
                    f.nombrePrograma.focus();
                    return false;
                }
                if(confirm('Está seguro de Guardar los datos.')){
                    f.action="guardar_programa_periodo.jsf";
                    f.nombreProgramaF.value=f.nombrePrograma.value;
                    f.obsF.value=f.obs.value;
                    f.submit();
                }else{
                    return false;
                }
            }
</script>

<html>
    <head>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />        
        <script type="text/javascript" src="../js/general.js"></script>
    </head>
    <body>
        <% SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");%>
        
        <form method="post" action="guardar_programa_periodo.jsf" name="form1">
            <div align="center">                
                <STRONG STYLE="font-size:16px;color:#000000;">Registrar Programa de Producción</STRONG><p>
                <table border="0"  border="0" class="outputText2"  style="border:1px solid #000000"  cellspacing="0">    
                    <tr class="headerClassACliente">
                        <td  colspan="3" >
                            <div class="outputText2" align="center">
                                
                            </div>    
                        </td>
                        <td>&nbsp;&nbsp;&nbsp;</td>
                    </tr>
                    <tr><td>&nbsp;</td></tr>
                    <tr class="outputText3">                                         
                        <td>&nbsp;&nbsp;<b>Nombre</b></td>
                        <td>&nbsp;&nbsp;<b>::</b>&nbsp;&nbsp;</td>
                        <td><input type="text" id="nombrePrograma" class="inputText" style="text-transform: uppercase;" onkeypress="valMAY();" size="80"></input></td>
                    </tr>
                    <tr class="outputText3">
                        <td>&nbsp;&nbsp;<b>Observación</b></td>
                        <td>&nbsp;&nbsp;<b>::</b>&nbsp;&nbsp;</td>
                        <td><textarea id="obs" cols="79" class="inputText" rows="3" ></textarea></td>
                    </tr>
                    <tr class="outputText3">
                        <td>&nbsp;&nbsp;<b>Estado</b></td>
                        <td>&nbsp;&nbsp;<b>::</b>&nbsp;&nbsp;</td>
                        <td>REGISTRADO</td>
                    </tr>
                    <tr class="outputText3">
                        <td>&nbsp;&nbsp;<b>fecha Inicio</b></td>
                        <td>&nbsp;&nbsp;<b>::</b>&nbsp;&nbsp;</td>
                        <td><input type="text" id="fecha_inicio" name="fecha_inicio" class="inputText" value="<%= sdf.format(new Date())%>" onblur="valFecha(this);" />
                            <img src="../img/fecha.bmp" id="imagen_fechaInicio" /><DLCALENDAR tool_tip='Seleccione la Fecha'  daybar_style='background-color: DBE1E7;font-family: verdana; color:000000;'    navbar_style='background-color: 7992B7; color:ffffff;'
                         input_element_id='fecha_inicio' click_element_id='imagen_fechaInicio'></DLCALENDAR>
                        </td>
                    </tr>
                    <tr class="outputText3">
                        <td>&nbsp;&nbsp;<b>fecha Final</b></td>
                        <td>&nbsp;&nbsp;<b>::</b>&nbsp;&nbsp;</td>
                        <td><input type="text" id="fecha_final" name="fecha_final" class="inputText" value="<%= sdf.format(new Date()) %>" onblur="valFecha(this);" />
                        <img src="../img/fecha.bmp" id="imagen_fechaFinal" />
                        <DLCALENDAR tool_tip='Seleccione la Fecha'  daybar_style='background-color: DBE1E7;font-family: verdana; color:000000;'    navbar_style='background-color: 7992B7; color:ffffff;'
                         input_element_id='fecha_final' click_element_id='imagen_fechaFinal'></DLCALENDAR>
                        </td>
                    </tr>

                    <tr>
                        <td>&nbsp;</td>
                    </tr>
                </table>
            </div>
            <br>
            <center>
                <input type="button" class="commandButtonR"   value="Guardar" name="guardar" onclick="return mandar(form1)">
                <input type="button" class="commandButtonR"   value="Cancelar" name="calcenlar" onclick="window.history.back(1);">
            </center>
            <input type="hidden" name="nombreProgramaF">
            <input type="hidden" name="obsF">            
        </form>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
    </body>
</html>