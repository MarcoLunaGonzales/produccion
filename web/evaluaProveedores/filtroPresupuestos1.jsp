package evaluaProveedores;

package calculoPremiosBimensuales_1;

<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.cofar.web.*" %>

<%!Connection con = null;%>
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

        background-image: url('../../../img/bar3.png');
    }
</style>
<script type="text/javascript" language="javascript">
    function enviarForm(f)
    {
        /*************************** AGENCIA *************************/
        var arrayAgencia=new Array();
        var arrayAgencia1=new Array();
        var j=0;
        for(var i=0;i<=f.codAreaEmpresa.options.length-1;i++)
        {	if(f.codAreaEmpresa.options[i].selected)
            {	arrayAgencia[j]=f.codAreaEmpresa.options[i].value;
                arrayAgencia1[j]=" "+f.codAreaEmpresa.options[i].innerHTML;
                j++;
            }
        }
        f.area.value=arrayAgencia;
        f.nombreagencia.value=arrayAgencia1;

        /*************************** LINEAS *************************/
        var arrayLineas=new Array();
        var arrayLineas1=new Array();
        var j=0;
        for(var i=0;i<=f.codLineaMkt.options.length-1;i++)
        {	if(f.codLineaMkt.options[i].selected)
            {	arrayLineas[j]=f.codLineaMkt.options[i].value;
                arrayLineas1[j]=" "+f.codLineaMkt.options[i].innerHTML;
                j++;
            }
        }
        f.codLinea.value=arrayLineas;
        f.nombreLinea.value=arrayLineas1;

        if(f.chk_todoAgencia.checked==true){
            f.nombreagencia.value='TODOS';
        }
        result="rptPresupuestosCalculo.jsf";
        f.action=result;
        f.submit();
    }
    function enviarForm1(f)
    {   //sacar el valor del multiple
        var codAreas=new Array();
        var j=0;
        for(var i=0;i<=f.codarea.options.length-1;i++)
        {	if(f.codarea.options[i].selected)
            {	codAreas[j]=f.codarea.options[i].value;
                j++;
            }
        }
        f.areas.value=codAreas;
        f.action="reporteDevolucionPasajesAreas.jsf";
        f.submit();
    }
    function sel_todo(f){
        for(var i=0;i<=f.codTipoDoc.options.length-1;i++)
        {   if(f.chk_todo.checked==true)
            {   f.codTipoDoc.options[i].selected=true;
            }
            else
            {   f.codTipoDoc.options[i].selected=false;
            }
        }
        return(true);
    }
    function sel_todoTipoSalida(f){
        for(var i=0;i<=f.codTipoSalidaVenta.options.length-1;i++)
        {   if(f.chk_todoTipoSalida.checked==true)
            {   f.codTipoSalidaVenta.options[i].selected=true;
            }
            else
            {   f.codTipoSalidaVenta.options[i].selected=false;
            }
        }
        return(true);
    }
    function sel_todoTipoCliente(f){
        for(var i=0;i<=f.codTipoCliente.options.length-1;i++)
        {   if(f.chk_todoTipoCliente.checked==true)
            {   f.codTipoCliente.options[i].selected=true;
            }
            else
            {   f.codTipoCliente.options[i].selected=false;
            }
        }
        return(true);
    }

    /****************** SELECCIONAR TODO PRODUCTO ********************/
    function sel_todoLineaMkt(f){
        var arrayLinea=new Array();
        var j=0;
        for(var i=0;i<=f.codLineaMkt.options.length-1;i++)
        {   if(f.chk_todoLineaMkt.checked==true)
            {   f.codLineaMkt.options[i].selected=true;
                arrayLinea[j]=f.codLineaMkt.options[i].value;
                j++;
            }
            else
            {   f.codLineaMkt.options[i].selected=false;
            }
        }
        /*
                var div_producto;
                div_producto=document.getElementById("div_producto");
                codLineaMkt=f.codLineaMkt;
                ajax=nuevoAjax();
                ajax.open("GET","ajaxProductosMultiple.jsf?codLineaMkt="+arrayLinea,true);
                ajax.onreadystatechange=function(){
                        if (ajax.readyState==4) {
                        div_producto.innerHTML=ajax.responseText;
                    }
                }
                ajax.send(null)  */
        return(true);
    }
    /****************** FUNCION DISTRITO ********************/
    function sel_todoDistrito(f){
        var arrayDistrito=new Array();
        var j=0;
        for(var i=0;i<=f.coddistrito.options.length-1;i++)
        {   if(f.chk_todoDistrito.checked==true)
            {   f.coddistrito.options[i].selected=true;
                arrayDistrito[j]=f.coddistrito.options[i].value;
                j++;
            }
            else
            {   f.coddistrito.options[i].selected=false;
            }
        }
        f.coddistrio=arrayDistrito;
        var div_zona;
        div_zona=document.getElementById("div_zona");
        coddistrito=f.coddistrito;
        ajax=nuevoAjax();
        ajax.open("GET","ajaxZonas.jsf?coddistrito="+arrayDistrito,true);
        ajax.onreadystatechange=function(){
            if (ajax.readyState==4) {
                div_zona.innerHTML=ajax.responseText;
            }
        }
        ajax.send(null)
        return(true);
    }
    /****************** FUNCION SELECCIONAR ZONAS ********************/
    function sel_todoZona(f){
        for(var i=0;i<=f.codzona.options.length-1;i++)
        {   if(f.chk_todoZona.checked==true)
            {   f.codzona.options[i].selected=true;
            }
            else
            {   f.codzona.options[i].selected=false;
            }
        }
        return(true);
    }
    /****************** FUNCION SELECCIONAR AREAS EMPRESA ********************/
    function sel_todoAgencia(f){
        for(var i=0;i<=f.codAreaEmpresa.options.length-1;i++)
        {   if(f.chk_todoAgencia.checked==true)
            {   f.codAreaEmpresa.options[i].selected=true;
            }
            else
            {   f.codAreaEmpresa.options[i].selected=false;
            }
        }
        return(true);
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
    /****************** AJAX DISTRITOS ********************/
    function ajaxDistritos(f)
    {
        var div_distrito;
        div_distrito=document.getElementById("div_distrito");
        codAreaEmpresa=f.codAreaEmpresa.value;
        ajax=nuevoAjax();

        ajax.open("GET","ajaxDistritos.jsf?codAreaEmpresa="+codAreaEmpresa,true);
        ajax.onreadystatechange=function(){
            if (ajax.readyState==4) {
                div_distrito.innerHTML=ajax.responseText;
            }
        }
        ajax.send(null)
        var div_zona=document.getElementById("div_zona");
        clearChild(div_zona.firstChild);
    }
    /****************** AJAX PRODUCTOS ********************/
    function ajaxProducto(f)
    {
        var div_producto;
        div_producto=document.getElementById("div_producto");
        var arrayLinea=new Array();
        var j=0;
        for(var i=0;i<=f.codLineaMkt.options.length-1;i++)
        {	if(f.codLineaMkt.options[i].selected)
            {	arrayLinea[j]=f.codLineaMkt.options[i].value;
                j++;
            }
        }
        codigo=arrayLinea;
        ajax=nuevoAjax();
        ajax.open("GET","ajaxProductosMultiple.jsf?codLineaMkt="+codigo,true);
        ajax.onreadystatechange=function(){
            if (ajax.readyState==4) {
                div_producto.innerHTML=ajax.responseText;
            }
        }
        ajax.send(null);
    }
    /****************** AJAX ZONAS ********************/
    function ajaxZonas(f)
    {
        var div_zona;
        div_zona=document.getElementById("div_zona");
        coddistrito=f.coddistrito.value;
        ajax=nuevoAjax();
        ajax.open("GET","ajaxZonas.jsf?coddistrito="+coddistrito,true);
        ajax.onreadystatechange=function(){
            if (ajax.readyState==4) {
                div_zona.innerHTML=ajax.responseText;
            }
        }
        ajax.send(null)
    }
    function clearChild(obj){
        while(obj.hasChildNodes())
            obj.removeChild(obj.lastChild);
    }
    /**********************************************************/
    function sel_todoProducto(f){
        for(var i=0;i<=f.codproducto.options.length-1;i++)
        {   if(f.chk_todoProducto.checked==true)
            {   f.codproducto.options[i].selected=true;
            }
            else
            {   f.codproducto.options[i].selected=false;
            }
        }
        return(true);
    }
    /****************** AJAX DISTRITOS ********************/
    function ajaxPeriodo(f)
    {
        var div_periodo;
        div_periodo=document.getElementById("div_periodo");
        var codGestion=f.codGestion.value;
        ajax=nuevoAjax();
        ajax.open("GET","ajaxPeriodo.jsf?codGestion="+codGestion,true);
        ajax.onreadystatechange=function(){
            if (ajax.readyState==4) {
                div_periodo.innerHTML=ajax.responseText;
            }
        }
        ajax.send(null);
        return(true)
    }

    /**********************************************************/
    function validarCliente(obj){
    }
    function desabilitarProductoMultiple(f){
        f.chk_todoProducto.checked=false;
    }
    function desabilitarAgencias(f){
        f.chk_todoAgencia.checked=false;
    }
    function desabilitarLinea(f){
        f.chk_todoLineaMkt.checked=false;
    }
    function desabilitarTipoCliente(f){
        f.chk_todoTipoCliente.checked=false;
    }
</script>

<html>
    <head>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
    </head>
    <body>
        <h4 align="center">Cálculo Premio Bimensual</h4>
        <form method="post" action="reporteSeguimientoMensualPresupuestosXRegionalXLinea.jsf" name="form1" target="_blank">
            <div align="center">
                <table border="0" class="outputText2" style="border:1px solid #000000" cellspacing="0" cellpadding="0" >
                    <tr class="headerClassACliente">
                        <td  colspan="3" >
                            <div class="outputText2" align="center">
                                Introduzca los Datos
                            </div>
                        </td>
                    </tr>
                    <tr class="outputText3">
                    <tr>
                        <td>&nbsp;</td>
                    </tr>
                    <td>&nbsp;&nbsp;<b>Agencia</b></td>
                    <td>&nbsp;&nbsp;<b>::</b>&nbsp;&nbsp;</td>
                    <%
                                //ManagedAccesoSistema obj = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");
                                con = Util.openConnection(con);
                                String cod_tipo_inc_regional = request.getParameter("cod_tipo_incentivo_regional");
                                String cod_gestion = request.getParameter("cod_gestion");
                                String cod_mes = request.getParameter("cod_mes");
                                String nombre_gestion = request.getParameter("nombre_gestion");
                                String nombre_mes = request.getParameter("nombre_mes");
                                System.out.println("cod_tipo_inc_regional:"+cod_tipo_inc_regional);
                                System.out.println("cod_gestion:"+cod_gestion);
                                System.out.println("cod_mes:"+cod_mes);
                                System.out.println("nombre_gestion:"+nombre_gestion);
                                System.out.println("nombre_mes:"+nombre_mes);
                                try {
                                    Statement st6 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                    String sql6 = "select av.cod_area_empresa,ae.nombre_area_empresa ";
                                    sql6 += " from agencias_venta av,areas_empresa ae  ";
                                    sql6 += " where  ";
                                    sql6 += " av.cod_area_empresa=ae.cod_area_empresa and  ae.cod_area_empresa not in (1, 34, 40)";
                                    System.out.println("sql6:"+sql6);
                                    ResultSet rs6 = st6.executeQuery(sql6);
                    %>
                    <td>
                        <select name="codAreaEmpresa" class="outputText3" size="12" multiple onchange="desabilitarAgencias(form1);">
                            <%
                                                                String cod_area_empresa = "", nombre_area_empresa = "";
                                                                while (rs6.next()) {
                                                                    cod_area_empresa = rs6.getString("cod_area_empresa");
                                                                    nombre_area_empresa = rs6.getString("nombre_area_empresa");
                            %>
                            <option value="<%=cod_area_empresa%>"><%=nombre_area_empresa%></option>
                            <%
                                                                }
                                                                st6.close();
                                                                rs6.close();
                            %>
                        </select>
                        <input type="checkbox" value="0" onclick="sel_todoAgencia(form1)" name="chk_todoAgencia">Todo
                        <%

                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }
                        %>
                    </td>
                    </tr>

                    <tr class="outputText3">
                        <td>&nbsp;&nbsp;<b>Linea</b></td>
                        <td>&nbsp;&nbsp;<b>::</b>&nbsp;&nbsp;</td>
                        <%
                                    try {
                                        Statement st7 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                        String sql7 = "select l.cod_lineamkt, l.nombre_lineamkt ";
                                        sql7 += " from lineas_mkt l";
                                        sql7 += " where l.cod_estado_registro=1  order by nombre_lineamkt ";
                                        System.out.println("sql7:"+sql7);
                                        ResultSet rs7 = st7.executeQuery(sql7);
                        %>
                        <td>
                            <select name="codLineaMkt" id="codLineaMkt" class="outputText3" multiple size="9">
                                <%
                                                                        String cod_lineamkt = "", nombre_lineamkt = "";
                                                                        while (rs7.next()) {
                                                                            cod_lineamkt = rs7.getString(1);
                                                                            nombre_lineamkt = rs7.getString(2);
                                %>
                                <option value="<%=cod_lineamkt%>"><%=nombre_lineamkt%></option>
                                <%
                                                                        }
                                                                        st7.close();
                                                                        rs7.close();
                                %>
                            </select>
                            <%

                                        } catch (Exception e) {
                                        }
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
                        <td>&nbsp;&nbsp;<b>Fecha Inicio</b></td>
                        <td>&nbsp;&nbsp;<b>::</b>&nbsp;&nbsp;</td>
                        <td>

                            <input type="text" class="outputText3" size="16" name="fechaInicio" id="fechaInicio" value="<%=fechaInicioMes%>">
                            <img id="imagenFecha1" src="../img/fecha.bmp">
                    <DLCALENDAR tool_tip="Seleccione la Fecha"
                                daybar_style="background-color: DBE1E7;
                                font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                                input_element_id="fechaInicio"; click_element_id="imagenFecha1">
                </DLCALENDAR>
                </td>
                </tr>
                <tr>
                    <td>&nbsp;&nbsp;<b>Fecha Final</b></td>
                    <td>&nbsp;&nbsp;<b>::</b>&nbsp;&nbsp;</td>
                    <td>
                        <input type="text" class="outputText3" size="16"  value="<%=fechaActual%>" name="fechaFinal" id="fechaFinal">
                        <img id="imagenFecha2" src="../img/fecha.bmp">
                <DLCALENDAR tool_tip="Seleccione la Fecha"
                            daybar_style="background-color: DBE1E7;
                            font-family: verdana; color:000000;"navbar_style="background-color: 7992B7; color:ffffff;"
                            input_element_id="fechaFinal"; click_element_id="imagenFecha2">
            </DLCALENDAR>
            </td>
            </tr>
            <tr class="outputText3">
                        <td>&nbsp;&nbsp;<b>Calculo Cualitativo</b></td>
                        <td>&nbsp;&nbsp;<b>::</b>&nbsp;&nbsp;</td>

                        <td>
                            <select name="ponderado" id="ponderado" class="outputText3" >
                                <option value="1">% Unidades</option>
                                <option value="2">% Ponderado</option>
                            </select>
                        </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
            </tr>
        </table>
    </div>
    <br>
    <center>
        <input type="button" class="commandButtonR"  value="Calcular" name="reporte" onclick="enviarForm(form1)">
        <input type="reset"   class="commandButtonR"   value="Limpiar" name="limpiar">
    </center>
    <input type="hidden" name="cod_tipo_inc_regional" value="<%=cod_tipo_inc_regional%>">
    <input type="hidden" name="cod_gestion" value="<%=cod_gestion%>">
    <input type="hidden" name="nombre_gestion" value="<%=nombre_gestion%>">
    <input type="hidden" name="cod_mes" value="<%=cod_mes%>">
    <input type="hidden" name="nombre_mes" value="<%=nombre_mes%>">
    <input type="hidden" name="area">
    <input type="hidden" name="nombreagencia">
    <input type="hidden" name="codLinea">
    <input type="hidden" name="nombreLinea">

</form>
<script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
</body>
</html>