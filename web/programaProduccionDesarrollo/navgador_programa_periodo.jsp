<%@ page import="java.sql.*" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%! Connection con = null;
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
    .commandButtonRene{
        font-family: Verdana, Arial, Helvetica, sans-serif;
        font-size: 11px;
        width: 150px;
        height: 20px;
        background-repeat :repeat-x;
        background-image: url('../img/bar3.png');
    }
</style>

<html>
    <head>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <link rel="stylesheet" type="text/css" href="../css/style.css" />
        <script >
   
    function editar(nametable){
        var count=0;
        var elements=document.getElementById(nametable);
        var rowsElement=elements.rows;
        var codProgramaPeriodo=0;
        for(var i=1;i<rowsElement.length;i++){
            var cellsElement=rowsElement[i].cells;
            var cel=cellsElement[0];
            var celda=cel.getElementsByTagName('input')[0];
            if(celda!=null){
                if(celda.type=='checkbox'){
                    if(celda.checked){
                        count++;
                        codProgramaPeriodo=celda.value;
                    }
                }
            }
        }
        if(count==1){
            form1.action="editar_programa_periodo.jsf?codProgramaPeriodo="+codProgramaPeriodo;
            form1.submit();
        } else if(count==0){
            alert('No escogio ningun registro');
            return false;
        }
        else if(count>1){
            alert('Solo puede escoger un registro');
            return false;
        }
    }
    /*function registrar(f){

        f.action="registrar_programa_periodo.jsf";
        f.submit();
    }*/

    function eliminar(nametable){
        var count=0;
        var elements=document.getElementById(nametable);
        var rowsElement=elements.rows;
        codProgramaPeriodo=new Array();

        for(var i=1;i<rowsElement.length;i++){
            var cellsElement=rowsElement[i].cells;
            var cel=cellsElement[0];
            var celda=cel.getElementsByTagName('input')[0];
            if(celda!=null){
                if(celda.type=='checkbox'){
                    if(celda.checked){
                        codProgramaPeriodo[count]=celda.value;
                        count++;
                        //codProgramaPeriodo=celda.value;
                    }
                }
            }
        }
        if(count==0){
            alert('No escogio ningun registro');
            return false;
        }
        else if(count>=1){
            msj=confirm("Desea Eliminar estos Registros ?");
            if (msj==true)
            {	msj1=confirm("Esta Seguro de Eliminar ?");
                if (msj1==true)
                {
                    form1.action="eliminar_programa_periodo.jsf?codProgramaPeriodo="+codProgramaPeriodo;
                    form1.submit();
                }
            }

        }
    }
    /* function programarProduccion(){

      izquierda = (screen.width) ? (screen.width-300)/2 : 100
      arriba = (screen.height) ? (screen.height-400)/2 : 200
      //url='../configuracionReporte/navegadorConfiguracionReporteReplica.jsf?codigo='+cod+'';
      url='programar_produccion_verificar.jsf?codigo='+codigo+'&codFormula='+codFormula+'&nombre='+nombre+'&cantidad='+cantidad+'&codCompProd='+codProd;
      opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width=700,height=400,left='+izquierda+ ',top=' + arriba + ''
      window.open(url, 'popUp',opciones)

    }*/
    function programarProduccion(nametable){
        var count=0;
        var elements=document.getElementById(nametable);
        var rowsElement=elements.rows;
        var codProgramaPeriodo=0;
        for(var i=1;i<rowsElement.length;i++){
            var cellsElement=rowsElement[i].cells;
            var cel=cellsElement[0];
            var celda=cel.getElementsByTagName('input')[0];
            if(celda!=null){
                if(celda.type=='checkbox'){
                    if(celda.checked){
                        count++;
                        codProgramaPeriodo=celda.value;
                    }
                }
            }
        }
        if(count==1){
            form1.action="programar_produccion_verificar.jsf?codProgramaPeriodo="+codProgramaPeriodo;
            form1.target="_blank";
            form1.submit();
        } else if(count==0){
            alert('No escogio ningun registro');
            return false;
        }
        else if(count>1){
            alert('Solo puede escoger un registro');
            return false;
        }
    }
     function registrar(){
        
        var general=document.getElementById('navegador');
        var tabla= new Array(general.rows.length-1);
        for(var i=1;i<general.rows.length;i++)
        {
            tabla[i-1]=general.rows[i].cells[1].getElementsByTagName('a')[0].innerHTML.replace(/^\s+/g,'').replace(/\s+$/g,'');
        }
        var valor=Math.floor(Math.random() * (5000 - 1 + 1)) + 5000;
        window.location="registrar_programa_periodo.jsf?nombresProgProd="+tabla+"&codigo='"+valor+"'";
        
    }

</script>
    </head>
    <body>

        <form method="post" action="procesoPresupuestoVentas.jsf"  name="form1">
            <br>
            <div align="center">
                <%
        try {
            con = Util.openConnection(con);
                %>
                <STRONG STYLE="font-size:16px;color:#000000;">Programa Producción Desarrollo</STRONG>
                <br><br>
                <table border="0" class="outputText2"  style="border:1px solid #000000"  width="95%" cellspacing="0" cellpadding="2" id="navegador">
                    <tr class="headerClassACliente">
                        <td colspan="2">
                            <div class="outputText2"><b>Nombre Programa Producción</b></div>
                        </td>
                        <td>
                            <div class="outputText2"><b>Obervaciones</b></div>
                        </td>
                        <td>
                            <div class="outputText2"><b>Estado</b></div>
                        </td>
                    </tr>
                    <%
                    String consulta = "SELECT PP.COD_PROGRAMA_PROD,PP.NOMBRE_PROGRAMA_PROD,PP.OBSERVACIONES";
                    consulta += ",(SELECT EP.NOMBRE_ESTADO_PROGRAMA_PROD FROM ESTADOS_PROGRAMA_PRODUCCION EP WHERE EP.COD_ESTADO_PROGRAMA_PROD = PP.COD_ESTADO_PROGRAMA)";
                    consulta += " FROM PROGRAMA_PRODUCCION_PERIODO PP WHERE PP.COD_ESTADO_PROGRAMA<>4 AND PP.COD_TIPO_PRODUCCION=2";
                    System.out.println("consulta cargar programa periodo "+consulta);
                    Statement st_1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs_1 = st_1.executeQuery(consulta);
                    while (rs_1.next()) {
                        String COD_PROGRAMA_PROD = rs_1.getString(1);
                        String NOMBRE_PROGRAMA_PROD = rs_1.getString(2);
                        String OBSERVACIONES = rs_1.getString(3);
                        String NOMBRE_ESTADO_PROGRAMA_PROD = rs_1.getString(4);
                    %>
                    <tr>
                        <h2>
                            <td><input type="checkbox" value="<%=COD_PROGRAMA_PROD%>"></td>
                            <td>
                                &nbsp;&nbsp;<a href="navegador_programa_produccion_desarrollo.jsf?codProgramaProd=<%=COD_PROGRAMA_PROD%>" title="Click para ingresasar"><%=NOMBRE_PROGRAMA_PROD%></a>
                            </td>
                            <td style="color:#000000" ><%=OBSERVACIONES%></td>
                            <td style="color:#000000"><%=NOMBRE_ESTADO_PROGRAMA_PROD%></td>
                        </h2>
                    </tr>
                    <%}%>
                </table>
                <%
            con.close();
        } catch (Exception e) {
        }
                %>
            </div>
            
                
        </form>
        <center>
                    
            <input type="button"   class="commandButtonRene" value="Registrar" name="registrar" onclick="registrar();">
            <input type="button"   class="commandButtonRene" value="Editar" name="editar" onclick="return editar('navegador');">
            <input type="button"   class="commandButtonRene" value="Eliminar" name="editar" onclick="return eliminar('navegador');">
            <%--input type="button"   class="commandButtonRene" value="Programar Produccion" name="editar" onclick="return programarProduccion('navegador');"--%>
        </center>
    
    </body>
</html>