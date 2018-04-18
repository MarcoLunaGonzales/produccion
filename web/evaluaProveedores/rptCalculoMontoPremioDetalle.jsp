package evaluaProveedores;

package evaluaProveedores;

package calculoPremiosBimensuales_1;


<%@ page import="java.sql.*" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.text.DecimalFormat"%>
<%@ page import = "java.text.NumberFormat"%>
<%@ page import = "java.util.Locale"%>

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

        background-image: url('../../img/bar3.png');
    }
</style>
<script language="javascript" type="text/javascript">

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

        /*************************** LINEA MKT *************************/
        var arrayLineaMkt=new Array();
        var arrayLineaMkt1=new Array();
        var j=0;
        for(var i=0;i<=f.codLineaMkt.options.length-1;i++)
        {	if(f.codLineaMkt.options[i].selected)
            {	arrayLineaMkt[j]=f.codLineaMkt.options[i].value;
                arrayLineaMkt1[j]=f.codLineaMkt.options[i].innerHTML;
                j++;
            }
        }
        f.codlinea.value=arrayLineaMkt;
        f.nombrelinea.value=arrayLineaMkt1;

        result="";

        result="rptPresupuestos1.jsf";

        /*if(parseInt(f.codReporte.value)==1){
            result="rptPresupuestosCumplidos.jsf";
        }
        if(parseInt(f.codReporte.value)==2){
            result="rptPresupuestosNoCumplidos.jsf";
        }*/
        f.action=result;
        f.submit();
    }
    function enviarForm2(f)
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

        /*************************** LINEA MKT *************************/
        var arrayLineaMkt=new Array();
        var arrayLineaMkt1=new Array();
        var j=0;
        for(var i=0;i<=f.codLineaMkt.options.length-1;i++)
        {	if(f.codLineaMkt.options[i].selected)
            {	arrayLineaMkt[j]=f.codLineaMkt.options[i].value;
                arrayLineaMkt1[j]=f.codLineaMkt.options[i].innerHTML;
                j++;
            }
        }
        f.codlinea.value=arrayLineaMkt;
        f.nombrelinea.value=arrayLineaMkt1;

        result="";

        result="rptPresupuestosCalculo.jsf";

        /*if(parseInt(f.codReporte.value)==1){
            result="rptPresupuestosCumplidos.jsf";
        }
        if(parseInt(f.codReporte.value)==2){
            result="rptPresupuestosNoCumplidos.jsf";
        }*/
        f.action=result;
        f.submit();
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
    function desabilitarAgencias(f){
        f.chk_todoAgencia.checked=false;
    }
    function desabilitarLinea(f){
        f.chk_todoLineaMkt.checked=false;
    }
    /**********************************************************/
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
</script>

<html>
    <%!
    public double redondear(double numero, int decimales) {
        return Math.round(numero * Math.pow(10, decimales)) / Math.pow(10, decimales);
    }
    %>
    <%!    public double verifica(double monto, String codAreaEmpresa, String codCategoriaComision, String codLineaMKT) {
        double monto_cumplimiento = 0;
        System.out.println("monto::::" + monto);
        try {
            Statement st_ver = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String sql_ver = "SELECT C.COD_CATEGORIA_INCENTIVO FROM CATEGORIAS_INCENTIVOS_OTROS_AREAS C WHERE C.COD_CATEGORIA_INCENTIVO=" + codCategoriaComision + " AND C.COD_AREA_EMPRESA=" + codAreaEmpresa + "";
            System.out.println("-**sql_ver:" + sql_ver);
            ResultSet rs_ver = st_ver.executeQuery(sql_ver);
            while (rs_ver.next()) {
                String codCategoriaCom = rs_ver.getString(1);

                Statement st7 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                String sql7 = "select distinct c.PORCENTAJE from CATEGORIAS_INCENTIVOS_OTROS_DETALLE c where c.COD_CATEGORIA_INCENTIVO=" + codCategoriaCom + "";
                System.out.println("-**sql7:" + sql7);
                ResultSet rs7 = st7.executeQuery(sql7);
                int minimo = 0;
                int maximo = 0;
                int minimo_aux = 0;
                int c = 0;
                if (monto > 0) {
                    while (rs7.next()) {
                        maximo = rs7.getInt("PORCENTAJE");
                        if (c == 0) {
                            minimo_aux = maximo;
                            c++;
                        }

                        if (monto >= minimo && monto < maximo) {
                            maximo = minimo;
                            break;
                        }
                        minimo = maximo;
                    }
                    System.out.println("maximo:" + maximo);
                    st7 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    sql7 = "select isnull(c.MONTO,0) from CATEGORIAS_INCENTIVOS_OTROS_DETALLE c where c.COD_CATEGORIA_INCENTIVO=" + codCategoriaCom + " and c.PORCENTAJE=" + maximo + " and c.COD_LINEA_MKT=" + codLineaMKT + "";
                    System.out.println("-**sql7:" + sql7);
                    rs7 = st7.executeQuery(sql7);
                    while (rs7.next()) {
                        monto_cumplimiento = rs7.getDouble(1);
                    }

                    System.out.println("monto_cumplimiento:" + monto_cumplimiento);

                    if (maximo == 0) {
                        Statement st8 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                        String sql8 = "select isnull(c.MONTO,0) from CATEGORIAS_INCENTIVOS_OTROS_DETALLE c where c.COD_CATEGORIA_INCENTIVO=" + codCategoriaCom + " and c.PORCENTAJE=" + minimo_aux + " and c.COD_LINEA_MKT=" + codLineaMKT + "";
                        System.out.println("-**sql9:" + sql8);
                        ResultSet rs8 = st8.executeQuery(sql8);
                        while (rs8.next()) {
                            //int porcentaje_min = rs8.getInt(1);
                            double monto_porcentaje = rs8.getInt(1);
                            System.out.println("entro.." + minimo_aux);
                            System.out.println("entro.porcentaje_min." + minimo_aux);
                            System.out.println("entro.monto_porcentaje." + monto_porcentaje);
                            System.out.println("entro.monto." + monto);
                            monto_cumplimiento = (monto * monto_porcentaje) / minimo_aux;
                            System.out.println("Entro:" + monto_cumplimiento);
                        }
                    }
                }
                st7.close();
                rs7.close();
            }
            System.out.println("monto_cumplimiento:" + monto_cumplimiento);
        } catch (Exception e) {
        }
        return monto_cumplimiento;
    }
    %>
    <head>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
    </head>
    <body>
        <h3 align="center">Premios Bimensuales Detallado</h3>
        <form method="post" action="rptMovimientoDeClientePorArticuloJSP.jsf" name="form1" target="_blank">
            <div align="center">



                <%
        //ManagedAccesoSistema obj = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");
        //String cod_personal=obj.getUsuarioModuloBean().getCodUsuarioGlobal();

        con = Util.openConnection(con);
        String cod_tipo_incentivo_regional = request.getParameter("cod_tipo_incentivo_regional");
        String cod_area_empresa = request.getParameter("cod_area_empresa");
        String cod_categoria = request.getParameter("cod_categoria");
        String cod_linea_comision = request.getParameter("cod_linea_comision");
        String cod_cargo = request.getParameter("cod_cargo");
        System.out.println("cod_area_empresa:" + cod_area_empresa);
        System.out.println("cod_categoria:" + cod_categoria);
        System.out.println("cod_tipo_incentivo_regional:" + cod_tipo_incentivo_regional);
        double sumTotalMontoParcial = 0;
        double sumTotalMonto = 0;
        double sumTotalPremio = 0;
        int sw_premio = 0;
        double montoPremioCumplimiento = 0;
        String nombreAreaEmpresa = "";
        String nombreLineaComision = "";
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat form = (DecimalFormat) nf;
        form.applyPattern("#,###");

        try {
            Statement st0 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            Statement stnom = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            sumTotalMonto = 0;
            String codAreaEmpresa = cod_area_empresa;
            String sqlnombre = " select nombre_area_empresa from areas_empresa where cod_area_empresa=" + codAreaEmpresa + "";
            System.out.println("sqlnombre:" + sqlnombre);
            ResultSet rsnom = stnom.executeQuery(sqlnombre);
            while (rsnom.next()) {
                nombreAreaEmpresa = rsnom.getString(1);
            }

            String codCategoria = cod_categoria;
            sqlnombre = " select c.NOMBRE_CARGO_LINEA_PREMIO,c.MONTO_CUMPLIMIENTO from CARGOS_LINEAS_PREMIOS_BIMENSUAL c where c.COD_CARGO_LINEA_PREMIO=" + codCategoria + "";
            System.out.println("sqlnombrel:" + sqlnombre);
            rsnom = stnom.executeQuery(sqlnombre);
            while (rsnom.next()) {
                nombreLineaComision = rsnom.getString(1);
                montoPremioCumplimiento = rsnom.getDouble(2);
            }

                %>
                <br><br>
                <p align="center"> <b>Area Empresa: </b><%=nombreAreaEmpresa%> <br><br><b>Categoria Comisión: </b><%=nombreLineaComision%>  </p>
                <br>

                <table border="0" class="outputText2" style="border:1px solid #000000" cellspacing="0" cellpadding="0" width="60%">

                <table width="75%" align="center" class="outputText2" cellpadding="0" cellspacing="0">
                    <tr bgcolor="#F7D358">
                        <th height="20px" width="35%" align="center">Linea MKT</th>
                        <th width="20%"align="center">% Cuantitativo</th>
                        <th width="30%"align="center">% Alcanzado</th>
                        <th width="15%"align="center"> Monto (Bs)</th>
                    </tr>

                    <%




                    String sql0 = " select lc.COD_LINEA_MKT,l.NOMBRE_LINEAMKT,t.PORCENTAJE,t.PORCENTAJE_CALCULADO,t.MONTO,t.TIPO_PREMIO_BIMENSUAL";
                    sql0 += " from CARGOS_LINEAS_PREMIOS_BIMENSUAL_DETALLE lc,LINEAS_MKT l,TIPOS_PREMIO_BIMENSUAL_DETALLE t";
                    sql0 += " where lc.COD_CARGO_LINEA=" + codCategoria + " and l.COD_LINEAMKT=lc.COD_LINEA_MKT and t.COD_TIPO_PREMIO=" + cod_tipo_incentivo_regional + " and t.COD_LINEA_MKT=l.COD_LINEAMKT";
                    sql0 += " and t.COD_AREA_EMPRESA=" + codAreaEmpresa + " and t.COD_LINEA_MKT=lc.COD_LINEA_MKT and t.TIPO_PREMIO_BIMENSUAL=1 order by l.NOMBRE_LINEAMKT";
                    System.out.println("sql0:" + sql0);

                    st0 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs0 = st0.executeQuery(sql0);
                    double total = 0;
                    while (rs0.next()) {

                        String codLinea = rs0.getString(1);
                        String nomLinea = rs0.getString(2);
                        double porcentaje = rs0.getDouble(3);
                        if (porcentaje < 100) {
                            sw_premio = 1;
                        }
                        double porcentaje_cal = rs0.getDouble(4);
                        porcentaje_cal = porcentaje_cal;
                        String sql_monto = "select c.MONTO_PREMIO from CARGOS_LINEAS_PREMIOS_BIMENSUAL_DETALLE c where c.COD_CARGO_LINEA=" + codCategoria + " and c.COD_LINEA_MKT=" + codLinea + "";
                        st0 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                        ResultSet rs_monto = st0.executeQuery(sql_monto);
                        double monto_premio = 0;
                        while (rs_monto.next()) {
                            monto_premio = rs_monto.getDouble(1);
                        }
                        if (codLinea.equals("4") || codLinea.equals("6") || codLinea.equals("7")) {
                            monto_premio = porcentaje_cal / 100 * monto_premio * 0.7;
                        } else {
                            monto_premio = porcentaje_cal / 100 * monto_premio * 0.3;
                        }
                        total = total + monto_premio;
                        sumTotalPremio = sumTotalPremio + monto_premio;
                    %>
                    <tr>
                        <td   style="border : solid #cccccc 1px;"><%=nomLinea%> </td>
                        <td  align="center" style="border : solid #cccccc 1px;"><%=redondear(porcentaje, 2)%> %</td>
                        <td align="CENTER" style="border : solid #cccccc 1px;"><%=redondear(porcentaje_cal, 2)%> %</td>
                        <td align="RIGHT" style="border : solid #cccccc 1px;"><%=redondear(monto_premio, 2)%> &nbsp;</td>
                    </tr>

                    <%                }
                    %>
                    <tr >
                        <td colspan="2" align="center" >&nbsp;</td>
                        <th bgcolor="#F7D358" align="RIGHT" style="border : solid #cccccc 1px;">TOTAL CUANTITATIVO&nbsp;</th>
                        <th bgcolor="#F7D358" align="RIGHT" style="border : solid #cccccc 1px;"><%=redondear(total, 2)%> &nbsp;</th>
                    </tr>



                </table>

                <table border="0" class="outputText2" style="border:1px solid #000000" cellspacing="0" cellpadding="0" width="60%">

                <table width="75%" align="center" class="outputText2" cellpadding="0" cellspacing="0">
                    <tr height="20px" bgcolor="#F7D358">
                        <th width="35%" align="center">Linea MKT</th>
                        <th width="20%" align="center">% Cualitativo</th>
                        <th width="30%" align="center">% Alcanzado</th>
                        <th width="15%" align="center"> Monto (Bs)</th>
                    </tr>

                    <%




                    sql0 = " select lc.COD_LINEA_MKT,l.NOMBRE_LINEAMKT,t.PORCENTAJE,t.PORCENTAJE_CALCULADO,t.MONTO,t.TIPO_PREMIO_BIMENSUAL";
                    sql0 += " from CARGOS_LINEAS_PREMIOS_BIMENSUAL_DETALLE lc,LINEAS_MKT l,TIPOS_PREMIO_BIMENSUAL_DETALLE t";
                    sql0 += " where lc.COD_CARGO_LINEA=" + codCategoria + " and l.COD_LINEAMKT=lc.COD_LINEA_MKT and t.COD_TIPO_PREMIO=" + cod_tipo_incentivo_regional + " and t.COD_LINEA_MKT=l.COD_LINEAMKT";
                    sql0 += " and t.COD_AREA_EMPRESA=" + codAreaEmpresa + " and t.COD_LINEA_MKT=lc.COD_LINEA_MKT and t.TIPO_PREMIO_BIMENSUAL=2 order by l.NOMBRE_LINEAMKT";
                    System.out.println("sql0:" + sql0);

                    st0 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    rs0 = st0.executeQuery(sql0);
                    total = 0;
                    while (rs0.next()) {

                        String codLinea = rs0.getString(1);
                        String nomLinea = rs0.getString(2);
                        double porcentaje = rs0.getDouble(3);
                        double porcentaje_cal = rs0.getDouble(4);
                        porcentaje_cal = porcentaje_cal;
                        /*String sql_monto = "select c.MONTO_PREMIO from CARGOS_LINEAS_PREMIOS_BIMENSUAL_DETALLE c where c.COD_CARGO_LINEA=" + codCategoria + " ";
                        sql_monto += " and c.COD_LINEA_MKT in (select l.COD_LINEAMKT from LINEAS_COMISIONES_MKT l,CARGOS_LINEAS_PREMIOS_BIMENSUAL ca ";
                        sql_monto += " where l.COD_LINEACOMISION=ca.COD_LINEA_COMISION and ca.COD_CARGO_LINEA_PREMIO="+codCategoria+") ";
*/
                        String sql_monto = "select c.MONTO_PREMIO from CARGOS_LINEAS_PREMIOS_BIMENSUAL_DETALLE c where c.COD_CARGO_LINEA=" + codCategoria + " and c.COD_LINEA_MKT=" + codLinea + "";
                        st0 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                        ResultSet rs_monto = st0.executeQuery(sql_monto);
                        double monto_premio = 0;
                        while (rs_monto.next()) {
                            monto_premio = rs_monto.getDouble(1);
                        }
                        if (codLinea.equals("4") || codLinea.equals("6") || codLinea.equals("7")) {
                            monto_premio = porcentaje_cal / 100 * monto_premio * 0.3;
                        } else {
                            monto_premio = porcentaje_cal / 100 * monto_premio * 0.7;
                        }
                        //monto_premio = porcentaje_cal / 100 * monto_premio * 0.7;
                        total = total + monto_premio;
                        sumTotalPremio = sumTotalPremio + monto_premio;
                    %>
                    <tr>
                        <td   style="border : solid #cccccc 1px;"><%=nomLinea%> </td>
                        <td  align="center" style="border : solid #cccccc 1px;"><%=redondear(porcentaje, 2)%> %</td>
                        <td  align="center" style="border : solid #cccccc 1px;"><%=redondear(porcentaje_cal, 2)%> %</td>
                        <td  align="RIGHT" style="border : solid #cccccc 1px;"><%=redondear(monto_premio, 2)%> &nbsp;</td>
                    </tr>

                    <%                }

                    if (sw_premio != 0) {
                        montoPremioCumplimiento = 0;
                    }

                    %>
                    <tr >
                        <td colspan="2" align="center" >&nbsp;</td>
                        <th bgcolor="#F7D358" align="RIGHT" style="border : solid #cccccc 1px;">TOTAL CUALITATIVO&nbsp;</th>
                        <th bgcolor="#F7D358" align="RIGHT" style="border : solid #cccccc 1px;"><%=redondear(total, 2)%> &nbsp;</th>
                    </tr>
                    <tr >
                        <td colspan="4" align="center" >&nbsp;</td>

                    </tr>
                    <tr >
                        <td colspan="2" align="center" >&nbsp;</td>
                        <th bgcolor="#F7D358" align="RIGHT" style="border : solid #cccccc 1px;">MONTO CUMPLIMIENTO&nbsp;</th>
                        <th bgcolor="#F7D358" align="RIGHT" style="border : solid #cccccc 1px;"><%=redondear(montoPremioCumplimiento, 2)%> &nbsp;</th>
                    </tr>
                    <tr >
                        <td colspan="2" align="center" >&nbsp;</td>
                        <th bgcolor="#F7D358" align="RIGHT" style=>TOTAL MONTO PREMIO&nbsp;</th>
                        <th bgcolor="#F7D358" align="RIGHT" style=><%=redondear(sumTotalPremio + montoPremioCumplimiento, 2)%>&nbsp; </th>
                    </tr>




                </table>

                <BR><BR>


                <%
        } catch (Exception e) {
            e.printStackTrace();
        }
                %>

                <input type="hidden" name="cod_tipo_incentivo_regional" id="cod_tipo_incentivo_regional" class="btn" value="<%=cod_tipo_incentivo_regional%>" >
            </div>
            <br>

            <input type="hidden" name="area">
            <input type="hidden" name="nombreagencia">
            <input type="hidden" name="codlinea">
            <input type="hidden" name="nombrelinea">
        </form>
        <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js"></script>
    </body>
</html>