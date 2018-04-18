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
    <%!    public double verifica(double monto, String cod_categoria, String codAreaEmpresa, String codLineaVenta, String codTipoIncentivoRegional) {
        double monto_cumplimiento = 0;
        try {
            Statement st_ver = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String sql_ver = "select t.COD_TIPO_INCENTIVO from TIPOS_INCENTIVO_REGIONAL_DETALLE t ";
            sql_ver += " where t.COD_AREA_EMPRESA=" + codAreaEmpresa + " and t.COD_LINEA_VENTA='" + codLineaVenta + "'";
            sql_ver += " and t.COD_TIPO_INCENTIVO_REGIONAL=" + codTipoIncentivoRegional + " ";
            System.out.println("sql_ver:" + sql_ver);
            ResultSet rs_ver = st_ver.executeQuery(sql_ver);
            while (rs_ver.next()) {
                String codTipoIncentivo = rs_ver.getString(1);

                Statement st7 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                String sql7 = "select i.MONTO_CUMPLIMIENTO_100,i.MONTO_CUMPLIMIENTO_105,i.MONTO_CUMPLIMIENTO_110";
                sql7 += " from INCENTIVOS_DETALLE i,CATEGORIAS_INCENTIVOS c ";
                sql7 += " where i.COD_TIPO_INCENTIVO=" + codTipoIncentivo + " and i.COD_INCENTIVO=c.COD_CATEGORIA_INCENTIVO" +
                        " and i.COD_CATEGORIA_PRESENTACION=" + cod_categoria + " and c.COD_LINEA_COMISION=" + codLineaVenta + "";
                System.out.println("-sql7:" + sql7);
                ResultSet rs7 = st7.executeQuery(sql7);
                while (rs7.next()) {
                    double monto_cum100 = rs7.getDouble("MONTO_CUMPLIMIENTO_100");
                    double monto_cum105 = rs7.getDouble("MONTO_CUMPLIMIENTO_105");
                    double monto_cum110 = rs7.getDouble("MONTO_CUMPLIMIENTO_110");
                    if (monto >= 100 && monto < 105) {
                        monto_cumplimiento = monto_cum100;
                    }
                    if (monto >= 105 && monto < 110) {
                        monto_cumplimiento = monto_cum105;
                    }
                    if (monto >= 110) {
                        monto_cumplimiento = monto_cum110;
                    }

                }
                st7.close();
                rs7.close();
            }
        } catch (Exception e) {
        }
        return monto_cumplimiento;
    }
    %>
    <head>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
    </head>
    <body>
        <h3 align="center"></h3>
        <form method="post" action="rptMovimientoDeClientePorArticuloJSP.jsf" name="form1" target="_blank">
            <div align="center">



                <%
        //ManagedAccesoSistema obj = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");
        //String cod_personal=obj.getUsuarioModuloBean().getCodUsuarioGlobal();

        con = Util.openConnection(con);
        String cod_tipo_incentivo_regional = request.getParameter("cod_tipo_incentivo_regional");
        String nombre_gestion = request.getParameter("nombre_gestion");
        String nombre_mes = request.getParameter("nombre_mes");
        System.out.println("nombre_gestion:" + nombre_gestion);
        System.out.println("nombre_mes:" + nombre_mes);
        System.out.println("cod_tipo_incentivo_regional:" + cod_tipo_incentivo_regional);
        double sumTotalMontoParcial = 0;
        double sumTotalMonto = 0;
        String nombreAreaEmpresa = "";
        String nombreLineaComision = "";

        try {
            Statement st0 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            Statement stnom = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);


            String sql0 = " SELECT DISTINCT T.COD_AREA_EMPRESA,T.COD_LINEA_VENTA,T.COD_TIPO_INCENTIVO FROM TIPOS_INCENTIVO_REGIONAL_DETALLE T ";
            sql0 += " WHERE T.COD_TIPO_INCENTIVO_REGIONAL=" + cod_tipo_incentivo_regional + " AND T.COD_TIPO_INCENTIVO<>-1";

            System.out.println("sql0:" + sql0);
            ResultSet rs0 = st0.executeQuery(sql0);
            while (rs0.next()) {
                sumTotalMonto = 0;
                String codAreaEmpresa = rs0.getString("COD_AREA_EMPRESA");
                String sqlnombre = " select nombre_area_empresa from areas_empresa where cod_area_empresa=" + codAreaEmpresa + "";
                System.out.println("sqlnombre:" + sqlnombre);
                ResultSet rsnom = stnom.executeQuery(sqlnombre);
                while (rsnom.next()) {
                    nombreAreaEmpresa = rsnom.getString(1);
                }

                String codLineaVenta = rs0.getString("COD_LINEA_VENTA");
                sqlnombre = " select l.NOMBRE_LINEACOMISION from LINEAS_COMISIONES l where l.COD_LINEACOMISION=" + codLineaVenta + "";
                System.out.println("sqlnombrel:" + sqlnombre);
                rsnom = stnom.executeQuery(sqlnombre);
                while (rsnom.next()) {
                    nombreLineaComision = rsnom.getString(1);
                }
                String codTipoIncentivo = rs0.getString("COD_TIPO_INCENTIVO");
                %>
             
                <%--p align="center"> Area Empresa: <%=nombreAreaEmpresa%> Linea Comisión:<%=nombreLineaComision%></p--%>
             
                <%--table border="0" class="outputText2" style="border:1px solid #000000" cellspacing="0" cellpadding="0" width="90%">

                    <tr  class="tituloCampo">
                        <td style="border-top:1px solid #000000;"><span class="outputTextNormal">&nbsp;</span></td>
                        <td style="border-top:1px solid #000000;"><span class="outputTextNormal">&nbsp;</span></td>
                        <td align="center" style="background-color:#c5d9f1;border-left:1px solid #000000;border-top:1px solid #000000;border-right:1px solid #000000;" colspan="2"><b>Ventas Gestión Análisis</b></td>
                        <td align="center" style="background-color:#FDe9d9;border-right:1px solid #000000;border-top:1px solid #000000;" colspan="2"><b>Presupuesto Periodo de Análisis</b></td>
                        <td align="center" style="background-color:#ADD797;border-right:1px solid #000000;border-top:1px solid #000000;" colspan="2" ><b>Cumplimiento</b></td>
                        <td align="center" style="background-color:#dbE5F1;border-right:1px solid #000000;border-top:1px solid #000000;" colspan="2" ><b>Crecimiento</b></td>
                    </tr>
                    <tr  class="tituloCampo">
                        <td style="border:1px solid #000000;"><span class="outputTextNormal">Presentación</span></td>
                        <td style="border:1px solid #000000;"><span class="outputTextNormal">Categoría</span></td>
                        <td align="center" style="background-color:#c5d9f1;border-right:1px solid #000000;border-top:1px solid #000000;" ><b>Bs.</b></td>
                        <td align="center" style="background-color:#c5d9f1;border-right:1px solid #000000;border-top:1px solid #000000;" ><b>Unid.</b></td>
                        <td align="center" style="background-color:#FDe9d9;border-right:1px solid #000000;border-top:1px solid #000000;" ><b>Bs.</b></td>
                        <td align="center" style="background-color:#FDe9d9;border-right:1px solid #000000;border-top:1px solid #000000;" ><b>Unid.</b></td>
                        <td align="center" style="background-color:#ADD797;border-right:1px solid #000000;border-top:1px solid #000000;" ><b>Bs.</b></td>
                        <td align="center" style="background-color:#ADD797;border-right:1px solid #000000;border-top:1px solid #000000;" ><b>Unid.</b></td>
                        <td align="center" style="background-color:#dbE5F1;border-right:1px solid #000000;border-top:1px solid #000000;" ><b>Bs.</b></td>
                        <td align="center" style="background-color:#dbE5F1;border-right:1px solid #000000;border-top:1px solid #000000;" ><b>Unid.</b></td>
                        <td align="center" style="background-color:#dbE5F1;border-right:1px solid #000000;border-top:1px solid #000000;" ><b>Monto Bs.</b></td>
                    </tr--%>

                <%

                        Statement st6 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                        String sql6 = " select c.NOMBRE_PRESENTACION,c.COD_CATEGORIA_PRESENTACION,c.NOMBRE_CATEGORIA_PRESENTACION,c.VENTAS_ANALISIS_BS,c.VENTAS_ANALISIS_UNID,";
                        sql6 += " c.PRESUPUESTO_ANALISIS_BS,c.PRESUPUESTO_ANALISIS_UNID,c.CUMPLIMIENTO_BS,c.CUMPLIMIENTO_UNID,";
                        sql6 += " c.CRECIMIENTO_BS,c.CRECIMIENTO_UNID from COMISIONES_PERSONAL_LINEASMKT c WHERE";
                        //sql6 += " c.COD_AREA_EMPRESA=" + codAreaEmpresa + " and c.COD_LINEA_COMISIONMKT=1 and c.COD_TIPO_INCENTIVO_REGIONAL=" + cod_tipo_incentivo_regional + "";
                        sql6 += " c.COD_AREA_EMPRESA=" + codAreaEmpresa + " and c.COD_LINEA_COMISIONMKT=" + codLineaVenta + " and c.COD_TIPO_INCENTIVO_REGIONAL=" + cod_tipo_incentivo_regional + "";
                        sql6 += " order by c.COD_TIPO_INCENTIVO,c.COD_CATEGORIA_PRESENTACION";
                        System.out.println("sql6:" + sql6);
                        ResultSet rs6 = st6.executeQuery(sql6);

                        while (rs6.next()) {
                            sumTotalMontoParcial = 0;
                            String nombrePresentacion = rs6.getString("NOMBRE_PRESENTACION");
                            String codCategoriaPres = rs6.getString("COD_CATEGORIA_PRESENTACION");
                            String nombreCategoriaPres = rs6.getString("NOMBRE_CATEGORIA_PRESENTACION");
                            double ventas_analisis_bs = rs6.getDouble("VENTAS_ANALISIS_BS");
                            ventas_analisis_bs = redondear(ventas_analisis_bs, 0);
                            double ventas_analisis_unid = rs6.getDouble("VENTAS_ANALISIS_UNID");
                            ventas_analisis_unid = redondear(ventas_analisis_unid, 0);
                            double pres_analisis_bs = rs6.getDouble("PRESUPUESTO_ANALISIS_BS");
                            pres_analisis_bs = redondear(pres_analisis_bs, 0);
                            double pres_analisis_unid = rs6.getDouble("PRESUPUESTO_ANALISIS_UNID");
                            pres_analisis_unid = redondear(pres_analisis_unid, 0);
                            double cumplimiento_bs = rs6.getDouble("CUMPLIMIENTO_BS");
                            cumplimiento_bs = redondear(cumplimiento_bs, 0);
                            double cumplimiento_unid = rs6.getDouble("CUMPLIMIENTO_UNID");
                            cumplimiento_unid = redondear(cumplimiento_unid, 0);
                            double crecimiento_bs = rs6.getDouble("CRECIMIENTO_BS");
                            crecimiento_bs = redondear(crecimiento_bs, 0);
                            double crecimiento_unid = rs6.getDouble("CRECIMIENTO_UNID");
                            crecimiento_unid = redondear(crecimiento_unid, 0);

                            NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                            DecimalFormat form = (DecimalFormat) nf;
                            form.applyPattern("#,###.00");

                            String montoIncentivoPresentacion = form.format(verifica(cumplimiento_unid, codCategoriaPres, codAreaEmpresa, codLineaVenta, cod_tipo_incentivo_regional));
                            double montoaux = Double.parseDouble(montoIncentivoPresentacion);
                            sumTotalMontoParcial = sumTotalMontoParcial + montoaux;
                            System.out.println("sumTotalMontoParcial:" + sumTotalMontoParcial);
                            sumTotalMontoParcial = redondear(sumTotalMontoParcial, 0);
                            sumTotalMonto = sumTotalMonto + montoaux;
                            sumTotalMonto = redondear(sumTotalMonto, 0);
                            System.out.println("sumTotalMonto:" + sumTotalMonto);
                            if (!nombreCategoriaPres.equals("Z")) {
                %>
                <%--tr  class="tituloCampo">
                        <td style="border:1px solid #000000;"><span class="outputTextNormal"><%=nombrePresentacion%></span></td>
                        <td style="border:1px solid #000000;"><span class="outputTextNormal"><%=nombreCategoriaPres%></span></td>
                        <td align="center" style="background-color:#c5d9f1;border-right:1px solid #000000;border-top:1px solid #000000;" ><b><%=ventas_analisis_bs%></b></td>
                        <td align="center" style="background-color:#c5d9f1;border-right:1px solid #000000;border-top:1px solid #000000;" ><b><%=ventas_analisis_unid%></b></td>
                        <td align="center" style="background-color:#FDe9d9;border-right:1px solid #000000;border-top:1px solid #000000;" ><b><%=pres_analisis_bs%></b></td>
                        <td align="center" style="background-color:#FDe9d9;border-right:1px solid #000000;border-top:1px solid #000000;" ><b><%=pres_analisis_unid%></b></td>
                        <td align="center" style="background-color:#ADD797;border-right:1px solid #000000;border-top:1px solid #000000;" ><b><%=cumplimiento_bs%></b></td>
                        <td align="center" style="background-color:#ADD797;border-right:1px solid #000000;border-top:1px solid #000000;" ><b><%=cumplimiento_unid%></b></td>
                        <td align="center" style="background-color:#dbE5F1;border-right:1px solid #000000;border-top:1px solid #000000;" ><b><%=crecimiento_bs%></b></td>
                        <td align="center" style="background-color:#dbE5F1;border-right:1px solid #000000;border-top:1px solid #000000;" ><b><%=crecimiento_unid%></b></td>
                        <td align="center" style="background-color:#dbE5F1;border-right:1px solid #000000;border-top:1px solid #000000;" ><b><%=montoIncentivoPresentacion%></b></td>
                    </tr--%>

                <%                                            } else {
                %>
                <%--tr  class="tituloCampo">
                        <td style="background-color:#c2c2c2;border-right:1px solid #000000;border:1px solid #000000;" colspan="2"><b><%=nombrePresentacion%></b></td>

                        <td align="center" style="background-color:#c2c2c2;border-right:1px solid #000000;border-top:1px solid #000000;" ><b><%=ventas_analisis_bs%></b></td>
                        <td align="center" style="background-color:#c2c2c2;border-right:1px solid #000000;border-top:1px solid #000000;" ><b><%=ventas_analisis_unid%></b></td>
                        <td align="center" style="background-color:#c2c2c2;border-right:1px solid #000000;border-top:1px solid #000000;" ><b><%=pres_analisis_bs%></b></td>
                        <td align="center" style="background-color:#c2c2c2;border-right:1px solid #000000;border-top:1px solid #000000;" ><b><%=pres_analisis_unid%></b></td>
                        <td align="center" style="background-color:#c2c2c2;border-right:1px solid #000000;border-top:1px solid #000000;" ><b><%=cumplimiento_bs%></b></td>
                        <td align="center" style="background-color:#c2c2c2;border-right:1px solid #000000;border-top:1px solid #000000;" ><b><%=cumplimiento_unid%></b></td>
                        <td align="center" style="background-color:#c2c2c2;border-right:1px solid #000000;border-top:1px solid #000000;" ><b><%=crecimiento_bs%></b></td>
                        <td align="center" style="background-color:#c2c2c2;border-right:1px solid #000000;border-top:1px solid #000000;" ><b><%=crecimiento_unid%></b></td>
                        <td align="center" style="background-color:#c2c2c2;border-right:1px solid #000000;border-top:1px solid #000000;" ><b><%=sumTotalMontoParcial%></b></td>
                    </tr--%>

                <%                            }


                        }

                        try {
                            String sql_upd = " UPDATE TIPOS_INCENTIVO_REGIONAL_DETALLE SET";
                            sql_upd += " MONTO=" + sumTotalMonto + " WHERE COD_TIPO_INCENTIVO_REGIONAL='" + cod_tipo_incentivo_regional + "' AND COD_AREA_EMPRESA='" + codAreaEmpresa + "' AND COD_LINEA_VENTA=" + codLineaVenta + " ";
                            System.out.println("sql_upd_update:" + sql_upd);
                            con = Util.openConnection(con);
                            PreparedStatement st = con.prepareStatement(sql_upd);
                            int result = st.executeUpdate();
                            sql_upd = " UPDATE TIPOS_INCENTIVO_REGIONAL_DETALLE SET";
                            sql_upd += " MONTO=0 WHERE COD_TIPO_INCENTIVO_REGIONAL='" + cod_tipo_incentivo_regional + "' AND COD_AREA_EMPRESA='" + codAreaEmpresa + "' AND COD_LINEA_VENTA=" + codLineaVenta + " " +
                                    " AND COD_TIPO_INCENTIVO=0";
                            System.out.println("sql_upd_update:" + sql_upd);
                            con = Util.openConnection(con);
                            st = con.prepareStatement(sql_upd);
                            result = st.executeUpdate();
                        } catch (SQLException ex) {
                            ex.printStackTrace();
                        }
                %>
                <%--tr  class="tituloCampo">
                        <td  style="background-color:#c2c2c2;border-right:1px solid #000000;border:1px solid #000000;" colspan="10"><b>Total</b></td>

                        <td align="center" style="background-color:#c2c2c2;border-right:1px solid #000000;border-top:1px solid #000000;" ><b><%=sumTotalMonto%></b></td>
                    </tr>

                </table--%>
                <%
            }


        } catch (Exception e) {
            e.printStackTrace();
        }
                %>
                <span class="outputTextNormal">
                    <marquee BEHAVIOR=ALTERNATE style="color:red;" > <center><b>Se realizó el Cálculo de Comisiones Correctamente</b></center></marquee><p>
                  
                </span>
                <a href="navegadorTipoincentivoRegionalDetalle.jsf?cod_tipo_inc_regional=<%=cod_tipo_incentivo_regional%>&nombre_gestion=<%=nombre_gestion%>&nombre_mes=<%=nombre_mes%>" ><-- Atrás</a>
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