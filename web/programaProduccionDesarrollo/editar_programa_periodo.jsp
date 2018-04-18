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
                    f.action="guardar_modificacion_periodo.jsf";
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
        <%
        String codProgramaPeriodo=request.getParameter("codProgramaPeriodo");        
        System.out.println("codProgramaPeriodo:"+codProgramaPeriodo);
        try{
            con=Util.openConnection(con);
            String sql_0="select NOMBRE_PROGRAMA_PROD,OBSERVACIONES from PROGRAMA_PRODUCCION_PERIODO where COD_PROGRAMA_PROD ="+codProgramaPeriodo;
            Statement st_0=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet rs_0=st_0.executeQuery(sql_0);
            String nombrePrograma="";
            String obsPrograma="";
            if(rs_0.next()){
                nombrePrograma=rs_0.getString(1);
                obsPrograma=rs_0.getString(2);
            }
        %>
        <form method="post" action="guardar_programa_periodo.jsf" name="form1">
            <div align="center">                
                <STRONG STYLE="font-size:16px;color:#000000;">Editar Programa de Producción</STRONG><p>
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
                        <td><input type="text" id="nombrePrograma" class="inputText" style="text-transform: uppercase;" onkeypress="valMAY();" size="80" value="<%=nombrePrograma%>"></input></td>
                    </tr>
                    <tr class="outputText3">
                        <td>&nbsp;&nbsp;<b>Observación</b></td>
                        <td>&nbsp;&nbsp;<b>::</b>&nbsp;&nbsp;</td>
                        <td><textarea id="obs" cols="79" class="inputText" rows="3" ><%=obsPrograma%></textarea></td>
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
            <input type="hidden" name="codProgramaPeriodo" value="<%=codProgramaPeriodo%>">
        </form>
        <%
        } catch (SQLException e) {
            e.printStackTrace();
        }
        %>        
    </body>
</html>