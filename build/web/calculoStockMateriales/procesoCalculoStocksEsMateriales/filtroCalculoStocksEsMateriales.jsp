<%@ page import="java.sql.*" %>

<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<script type="text/javascript" src="../../js/general.js"></script>
<style>
    .panelRegistrarMeses
    {
        padding: 50px;
        
        background-color: #cccccc;
        top: 0px;
        z-index: 2;
        left: 0px;
        position: absolute;
        border :2px solid #3C8BDA;
        width :100%;
        height: 100%;
        filter: alpha(opacity=70);
        opacity: 0.8;
        visibility:hidden;
    }
    .panelRegistrar1
    {
        
        text-align:center;
        position:absolute;
        top:0px;
    }
    .formRegistrar
    {
        z-index:100;
        visibility:hidden;
        text-align:center;
        position:absolute;
        top:5em;

        width:100%;
    }
    
    .formRegistrar table
    {
        background-color:white;
        border:1px solid #cccccc;
    }
    .formRegistrar table tr td
    {
        padding:0.3em;
    }
</style>
<script language="javascript">
    function enviarForm1(f)
    {
        var arrayCodGrupo=new Array();
        var arrayNombreGrupo=new Array();
        var j=0;
        for(var i=0;i<=f.codGrupo.options.length-1;i++)
        {	if(f.codGrupo.options[i].selected)
            {	arrayCodGrupo[j]=f.codGrupo.options[i].value;
                arrayNombreGrupo[j]=f.codGrupo.options[i].innerHTML;
                j++;
            }
        }
        //---------
        j=0;
        var arrayCodAlmacen = new Array();
        var arrayNombreAlmacen = new Array();
        for(var i=0;i<=f.codAlmacen.options.length-1;i++)
        {	if(f.codAlmacen.options[i].selected)
            {	arrayCodAlmacen[j]=f.codAlmacen.options[i].value;
                arrayNombreAlmacen[j]=f.codAlmacen.options[i].innerHTML;
                j++;
            }
        }
        f.codAlmacenP.value = arrayCodAlmacen;
        f.nombreAlmacenP.value = arrayNombreAlmacen;
        f.codGrupoP.value=arrayCodGrupo;
        f.nombreGrupoP.value=arrayNombreGrupo;
        
        f.fechaFinalP.value =f.fecha2.value;
        f.action="navegadorReporteEvaluacionStocks.jsf";
        f.submit();
    }

    function almacenVentaSeleccionarTodo_change(f){
        for(var i=0;i<=f.codAlmacenVenta.options.length-1;i++)
        {   if(f.chk_todoAlmacen.checked==true)
            {   f.codAlmacenVenta.options[i].selected=true;
            }
            else
            {   f.codAlmacenVenta.options[i].selected=false;
            }
        }
        return(true);
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
    function ocultarDefinirMesesReposicion()
    {
        document.getElementById("formRegistrar").style.visibility='hidden';
        document.getElementById('panelRegistrarMeses').style.visibility='hidden';
    }
    function guardarMesesReposicionGrupos()
    {
        var tabla=document.getElementById("tablaGruposReposicion");
        var arrayDatos=new Array();
        for(var i=2;i<tabla.rows.length-1;i++)
        {
            arrayDatos[arrayDatos.length]=tabla.rows[i].cells[0].getElementsByTagName("input")[0].value;
            arrayDatos[arrayDatos.length]=tabla.rows[i].cells[1].getElementsByTagName("input")[0].value;
        }
        var ajax=nuevoAjax();
        
        document.getElementById("buttonMat1").style.visibility='hidden';
        document.getElementById("buttonMat2").style.visibility='hidden';
        ajax.open ("GET","ajaxGuardarMesesGrupos.jsf?datos="+arrayDatos+"&alea="+(new Date()).getTime().toString(), true);
        ajax.onreadystatechange = function()
        {
            if(ajax.readyState==4)
            {
                if(ajax.responseText==null || ajax.responseText=='')
                        {
                            alert('No se puede conectar con el servidor, verfique su conexión a internet');
                            return false;
                        }
                        if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                        {
                            alert('Se registraron los datos');
                            document.getElementById("buttonMat1").style.visibility='visible';
                            document.getElementById("buttonMat2").style.visibility='visible';
                            document.getElementById("formRegistrar").innerHTML=ajax.responseText;
                            document.getElementById("formRegistrar").style.visibility='hidden';
                            document.getElementById('panelRegistrarMeses').style.visibility='hidden';
                            
                            return true;
                        }
                        else
                        {
                            document.getElementById("buttonMat1").style.visibility='visible';
                            document.getElementById("buttonMat2").style.visibility='visible';
                            alert(ajax.responseText.split("\n").join(""));
                            return false;
                        }
                        
                        
                   

            }
        }
        ajax.send(null);
    }
    function mostrarDefinirMesesReposicion()
    {
        var arrayGrupo=new Array();
        var listGrupos=document.getElementById("codGrupo");
        for(var i=0;i<listGrupos.options.length;i++)
        {	
            if(listGrupos.options[i].selected)
            {
                arrayGrupo[arrayGrupo.length]=listGrupos.options[i].value;
            }
        }



        var ajax=nuevoAjax();
        ajax.open ("GET","stockMaterialesGrupos.jsf?codGrupo="+arrayGrupo+"&alea="+(new Date()).getTime().toString(), true);
        ajax.onreadystatechange = function()
        {
            if(ajax.readyState==4)
            {
                    if(ajax.status==200){
                    document.getElementById("formRegistrar").innerHTML=ajax.responseText;
                    document.getElementById("formRegistrar").style.visibility='visible'
                    mostrarPanel();
                    }
               
            }
        }
        ajax.send(null);
    }
    function mostrarPanel()
    {
        var b=document.getElementById('panelRegistrarMeses');
        b.style.visibility='visible';
        b.style.width=window.document.body.scrollWidth;
        b.style.height=window.document.body.scrollHeight;
        
    }
    function capitulo_change(f){
        var arrayCodCapitulo=new Array();
        var arrayNombreCapitulo=new Array();
        var j=0;
        for(var i=0;i<=f.codCapitulo.options.length-1;i++)
        {	if(f.codCapitulo.options[i].selected)
            {	arrayCodCapitulo[j]=f.codCapitulo.options[i].value;
                arrayNombreCapitulo[j]=f.codCapitulo.options[i].innerHTML;
                j++;
            }
        }



        var ajax=nuevoAjax();
        var url='grupoAjax.jsp?codCapitulo='+arrayCodCapitulo;
        url+='&pq='+(Math.random()*1000);
        // alert(url);
        ajax.open ('GET', url, true);
        ajax.onreadystatechange = function() {
            //alert(ajax.readyState);
            if (ajax.readyState==1) {
                //alert("hola");
            }else if(ajax.readyState==4){
                if(ajax.status==200){
                    //alert(ajax.responseText);
                    var divGrupo=document.getElementById('div_grupo');
                    divGrupo.innerHTML=ajax.responseText;
                }
            }
        }
        ajax.send(null);
    }




</script>

<html>
    <head>
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
            .commandButtonR{
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 11px;
                width: 150px;
                height: 20px;
                background-repeat :repeat-x;

                background-image: url('../img/bar3.png');
            }
        </style>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
    </head>
    <body>
        <h4 align="center">Calculo de Stocks<br>Empaque Secundario</h4>
        <form method="post" action="navegadorReporteEvaluacionStocks.jsf" name="form1" target="_blank">
            <div align="center">
                <table border="0" class="outputText2" style="border:1px solid #000000" cellspacing="0" cellpadding="0">
                    <tr class="headerClassACliente">
                        <td  colspan="3" >
                            <div class="outputText2" align="center">
                                Introduzca los Parámetros del Reporte
                            </div>
                        </td>
                    </tr>


                    <tr class="outputText3">
                        <td>&nbsp;&nbsp;<b>Capitulo</b></td>
                        <td><b>::</b>&nbsp;</td>
                        <%
                        Connection con = null;
        try {
            
            con = Util.openConnection(con);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = "select c.COD_CAPITULO,c.NOMBRE_CAPITULO"+
                              " from capitulos c where c.COD_CAPITULO in (4,8) and c.COD_ESTADO_REGISTRO=1"+
                              " order  by c.NOMBRE_CAPITULO";
            ResultSet res = st.executeQuery(consulta);
                        %>
                        <td>
                            <select name="codCapitulo" class="outputText2" onchange="capitulo_change(form1)" multiple size="2">
                                <%
                            while (res.next()) {
                                out.println("<option value='"+res.getInt("COD_CAPITULO")+"'>"+res.getString("NOMBRE_CAPITULO")+"</option>");
                                }
                                %>
                            </select>
                           
                        </td>
                    </tr>

                    <tr class="border">
                        <td>&nbsp;&nbsp;<b>Grupos</b></td>
                        <td >::</td>
                        <td>
                            <div id="div_grupo">
                                <select name="codGrupo" id="codGrupo" class="inputText2" multiple >
                                    <option>Seleccione una opcion</option>
                                </select>
                            </div>
                        </td>
                    </tr>

                    <tr class="outputText3">
                        <td>&nbsp;&nbsp;<b>Almacen</b></td>
                        <td><b>::</b>&nbsp;</td>
                        <%
                           consulta= "select a.COD_ALMACEN,a.NOMBRE_ALMACEN from almacenes a where a.COD_ESTADO_REGISTRO = 1 and a.cod_almacen=2";
                           System.out.println(consulta);
                           res = st.executeQuery(consulta);
                                            %>
                                            <td>
                                                <select name="codAlmacen" class="outputText2"  multiple size="3">
                                                    <%
                                                        while (res.next()) {
                                                            out.println("<option value='"+res.getInt("COD_ALMACEN")+"'>"+res.getString("NOMBRE_ALMACEN")+"</option>");
                                                        }
                                  } catch (Exception e) {
                                e.printStackTrace();
                            }
                                                    %>
                                                </select>
                                                <%

                            
                            %>
                        </td>
                    </tr>


                    <%
        Date fechaSistema = new Date();
        SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");
        String fechaActual = formatoFecha.format(fechaSistema);
        String[] fechaIniMes = fechaActual.split("/");
        String fechaInicioMes = "01/" + fechaIniMes[1] + "/" + fechaIniMes[2];

                    %>

                    <tr class="outputText3">
                        <td>&nbsp;&nbsp;<b>A Fecha</b></td>
                        <td>&nbsp;&nbsp;<b>::</b>&nbsp;&nbsp;</td>
                        <td>
                            <input type="text" class="outputText3" size="16"  value="<%=fechaActual%>" name="fecha2" >
                            <img id="imagenFecha2" src="../img/fecha.bmp">
                            <DLCALENDAR tool_tip="Seleccione la Fecha"
                                        daybar_style="background-color: DBE1E7;
                                        font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                        input_element_id="fecha2" click_element_id="imagenFecha2">
                            </DLCALENDAR>

                        </td>
                    </tr>
                    <tr class="outputText3">
                        <td>&nbsp;&nbsp;<b>Nro de Meses Stock Minimo</b></td>
                        <td>&nbsp;&nbsp;<b>::</b>&nbsp;&nbsp;</td>
                        <td>
                            <input id="nroMeses" name="nroMeses" value="" />
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                    </tr>
                </table>
            </div>
            <br>
            <center>
                <a class="btn" onclick="mostrarDefinirMesesReposicion()">Definir Meses de reposicion</button>
                <a class="btn" onclick="enviarForm1(form1)">Ver Reporte</a>
                <input type="reset"   class="btn"  size="35" value="Limpiar" name="limpiar">
            </center>


            <input type="hidden" name="codAlmacenVentaP">
            <input type="hidden" name="codTipoClienteP">
            <input type="hidden" name="nombreAlmacenVentaP">
            <input type="hidden" name="nombreTipoClienteP">
            <input type="hidden" name="fechaFinalP">
            <input type="hidden" name="codGrupoP">
            <input type="hidden" name="nombreGrupoP">

            <input type="hidden" name="codAlmacenP">
            <input type="hidden" name="nombreAlmacenP">
            
            
                <div id="formRegistrar" class="formRegistrar">

                </div>
            
            
            <div id="panelRegistrarMeses" class="panelRegistrarMeses">
                &nbsp;
            </div>
        </form>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
    </body>
</html>