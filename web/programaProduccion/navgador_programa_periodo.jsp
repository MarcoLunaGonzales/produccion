<%@ page import="java.sql.*" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import="com.cofar.bean.ProgramaProduccion" %>
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
<script >
    function registrar(f){
        f.action="registrar_programa_periodo.jsf";
        f.submit();
    }

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
    function registrar(f){
        f.action="registrar_programa_periodo.jsf";
        f.submit();
    }

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
    function cambioEstadoProduccion(nametable){
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
            msj=confirm("Desea cambio de estado ?");
            if (msj==true)
            {	msj1=confirm("esta seguro de cambiar de estado ?");
                if (msj1==true)
                {
                    form1.action="cambio_estado_programa_periodo.jsf?codProgramaPeriodo="+codProgramaPeriodo;
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
    function mostrarModal(){
        document.getElementById('divDetalle').style.marginTop=(document.documentElement.scrollTop+30);
        document.getElementById('divDetalle').style.visibility='visible';
        document.getElementById('formSuper').style.visibility='visible';
        var a = document.getElementById('formSuper').style;
        a.height=document.body.offsetHeight;
        return false;
    }
    function ocultarModal(){
        document.getElementById('divDetalle').style.visibility='hidden';
        document.getElementById('formSuper').style.visibility='hidden';
        return false;
    }
    function buscarLote(){
        var codLoteProduccion = "";
        codLoteProduccion = document.getElementById("codLoteProduccion").value;
        if(codLoteProduccion==""){
            alert("coloque un valor de Lote");
            return false;
        }
        location="navegador_programa_produccion.jsf?codLoteProduccion="+codLoteProduccion;
    }
</script>
<html>
    <head>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <link rel="stylesheet" type="text/css" href="../css/style.css" />
        <script  type="" src="scripts.js" ></script>
    </head>
    <body onload="carga()">
        <div  id="divDetalle" style="
              background-color: #FFFFFF;
              z-index: 2;
              top: 12px;
              position:absolute;
              left:450px;
              border :2px solid #FFFFFF;
              width :350px;
              height: 150px;
              visibility:hidden;
              overflow:auto;
              text-align:center;"  >
            <div class='headerClassACliente' onmouseover="this.style.cursor='move'" onmousedown="comienzoMovimiento(event, 'divDetalle')"  >Buscar Lote</div>
            

            <center>
                <div id="panelSeguimiento" style="overflow:auto;width:330px;height:40px;" >

                    <table class="outputText2"><tr>
                    <td>Lote :
                    </td><td><input id="codLoteProduccion" type="text" class="inputText"></td></tr>
                     </table>

                </div>
            </center>
            <button class="btn" onclick="buscarLote();">Buscar</button>
            <button class="btn" onclick="ocultarModal()">Cancelar</button>
        </div>
        <div  id="formsuper"  style="
                padding: 50px;
                background-color: #cccccc;
                position:absolute;
                z-index: 1;
                left:0px;
                top: 0px;
                border :2px solid #3C8BDA;
                width :100%;
                height: 100%;
                filter: alpha(opacity=70);
                visibility:hidden;
                opacity: 0.8;" >
                    hidheidhedede
          </div>
        
        <form method="post" action="procesoPresupuestoVentas.jsf"  name="form1">
            
            <br>
            <div align="center">
                <%
        try {
            con = Util.openConnection(con);
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                %>
                <STRONG STYLE="font-size:16px;color:#000000;">Programa Producción</STRONG>
                <div align="center"><a onclick="mostrarModal()" href="#">Buscar<img src="../img/buscar.png"></a></div>
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
                        <td>
                            <div class="outputText2"><b>Fecha Inicio</b></div>
                        </td>
                        <td>
                            <div class="outputText2"><b>Fecha Final</b></div>
                        </td>
                    </tr>
                    <%
                    ManagedProgramaProduccion mp = (ManagedProgramaProduccion) (Util.getSessionBean("ManagedProgramaProduccion")==null?new ManagedProgramaProduccion():Util.getSessionBean("ManagedProgramaProduccion"));
                    mp.setProgramaProduccionBuscar(new ProgramaProduccion());
                    String sql_1 = "SELECT PP.COD_PROGRAMA_PROD,PP.NOMBRE_PROGRAMA_PROD,PP.OBSERVACIONES";
                    sql_1 += ",(SELECT EP.NOMBRE_ESTADO_PROGRAMA_PROD FROM ESTADOS_PROGRAMA_PRODUCCION EP WHERE EP.COD_ESTADO_PROGRAMA_PROD = PP.COD_ESTADO_PROGRAMA),PP.FECHA_INICIO,PP.FECHA_FINAL";
                    sql_1 += " FROM PROGRAMA_PRODUCCION_PERIODO PP WHERE PP.COD_ESTADO_PROGRAMA<>4 and ISNULL(PP.COD_TIPO_PRODUCCION,1) in (1) ";
                    System.out.println("consulta cargar periodo "+sql_1);
                    Statement st_1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs_1 = st_1.executeQuery(sql_1);
                    while (rs_1.next()) {
                        String COD_PROGRAMA_PROD = rs_1.getString(1);
                        String NOMBRE_PROGRAMA_PROD = rs_1.getString(2);
                        String OBSERVACIONES = rs_1.getString(3);
                        String NOMBRE_ESTADO_PROGRAMA_PROD = rs_1.getString(4);
                        Date fechaInicio = rs_1.getDate("FECHA_INICIO");
                        Date fechaFinal = rs_1.getDate("FECHA_FINAL");
                    %>
                    <tr>
                        <h2>
                            <td><input type="checkbox" value="<%=COD_PROGRAMA_PROD%>"></td>
                            <td>
                                &nbsp;&nbsp;<a href="../programaProduccion/navegador_programa_produccion.jsf?codProgramaProd=<%=COD_PROGRAMA_PROD%>" title="Click para ingresasar"><%=NOMBRE_PROGRAMA_PROD%></a>
                            </td>
                            <td style="color:#000000" ><%=OBSERVACIONES%></td>
                            <td style="color:#000000"><%=NOMBRE_ESTADO_PROGRAMA_PROD%></td>
                            <td style="color:#000000"><%=fechaInicio!=null?sdf.format(fechaInicio):""%></td>
                            <td style="color:#000000"><%=fechaFinal!=null?sdf.format(fechaFinal):""%></td>
                        </h2>
                    </tr>
                    <%}%>
                </table>
                <%
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
                %>
            </div>
        </form>
        <center>
            <input type="button"   class="commandButtonRene" value="Registrar" name="registrar" onclick="registrar(form1)">
            <input type="button"   class="commandButtonRene" value="Editar" name="editar" onclick="return editar('navegador');">
            <input type="button"   class="commandButtonRene" value="Eliminar" name="editar" onclick="return eliminar('navegador');">
            <input type="button"   class="commandButtonRene" value="Cerrar" name="Cerrar" onclick="return cambioEstadoProduccion('navegador');">
            <input type="button"   class="commandButtonRene" value="Programar Produccion" name="editar" onclick="return programarProduccion('navegador');">
        </center>
    </body>
</html>