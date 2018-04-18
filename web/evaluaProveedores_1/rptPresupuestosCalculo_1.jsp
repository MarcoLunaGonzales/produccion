package evaluaProveedores;

package calculoPremiosBimensuales_1;

package calculoPremiosBimensuales;

package calculoTipoIncentivoRegionalesOtros_1;


<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.text.DecimalFormat"%>
<%@ page import = "java.text.NumberFormat"%>
<%@ page import = "java.util.Locale"%>
<%@ page import = "org.joda.time.DateTime"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.text.*"%>
<%@ page import = "java.text.DecimalFormat"%>
<%@ page import = "java.text.NumberFormat"%>
<%@ page import = "java.util.Locale"%>
<%!    Connection con = null;%>
<link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
<head>
    <script>
        function  cerraringLiquidacion(){
            window.close();
            window.opener.location.reload();

        }
    </script>
</head>
<html>
    <body>
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
                            double monto_porcentaje=rs8.getInt(1);
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
        <%!    /***aqui**/
    public double verifica4(double monto, String codAreaEmpresa, String codCategoriaComision, String codLineaMKT) {
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
                            maximo = maximo;
                            break;
                        }
                        minimo = maximo;
                    }

                    st7 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    sql7 = "select isnull(c.MONTO,0) from CATEGORIAS_INCENTIVOS_OTROS_DETALLE c where c.COD_CATEGORIA_INCENTIVO=" + codCategoriaCom + " and c.PORCENTAJE=" + maximo + " and c.COD_LINEA_MKT=" + codLineaMKT + "";
                    System.out.println("-**sql7:" + sql7);
                    rs7 = st7.executeQuery(sql7);
                    while (rs7.next()) {
                        monto_cumplimiento = rs7.getDouble(1);
                    }

                    System.out.println("monto_cumplimiento:" + monto_cumplimiento);

                    Statement st8 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    String sql8 = "select distinct  top 1  c.PORCENTAJE from CATEGORIAS_INCENTIVOS_OTROS_DETALLE c where c.COD_CATEGORIA_INCENTIVO=" + codCategoriaCom + "";
                    System.out.println("-**sql9:" + sql8);
                    ResultSet rs8 = st8.executeQuery(sql8);
                    while (rs8.next()) {
                        int porcentaje_min = rs8.getInt(1);
                        System.out.println("entro.." + minimo_aux);
                        System.out.println("entro.porcentaje_min." + porcentaje_min);
                        System.out.println("entro.monto_cumplimiento_min." + monto_cumplimiento);

                        if (minimo_aux == porcentaje_min) {
                            monto_cumplimiento = (monto * monto_cumplimiento) / porcentaje_min;
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
        <%!    public double verifica1(double monto, String cod_categoria, String codAreaEmpresa, String codLineaVenta, String codTipoIncentivoRegional, String categoriaIncentivo) {
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
                sql7 += " from INCENTIVOS_DETALLE i";
                sql7 += " where i.COD_TIPO_INCENTIVO=" + codTipoIncentivo + " " +
                        " and i.COD_CATEGORIA_PRESENTACION=" + cod_categoria + " and i.COD_INCENTIVO='" + categoriaIncentivo + "'";
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
        <%
        String codCategoria = request.getParameter("codCategoria");
        String nombreCategoria = request.getParameter("nombreCategoria");

        String codAreaEmpresaF = request.getParameter("area");
        String nombreAreaEmpresaF = request.getParameter("nombreagencia");
        String codLineaF = request.getParameter("codlinea");
        String nombreLineaF = request.getParameter("nombrelinea");
        System.out.println("codAreaEmpresaF:" + codAreaEmpresaF);
        System.out.println("nombreAreaEmpresaF:" + nombreAreaEmpresaF);
        System.out.println("codLineaF:" + codLineaF);
        System.out.println("nombreLineaF:" + nombreLineaF);
        String codGestionF = "";
        String codPeriodoGestion = "";
        String codPeriodoGestionOriginal = "";
        String fechaInicio = request.getParameter("fechaInicio");
        String fechaFinal = request.getParameter("fechaFinal");
        //String categoriaIncentivo = request.getParameter("codCatIncentivo");
        String nombreCategoriaIncentivo = "";
        double sumaTotalMontoIncentivo = 0;
        String cod_tipo_incentivo_regional = request.getParameter("cod_tipo_incentivo_regional");
        String nombreTipoIncentivo = "";
        String nombreTipo = "";
        float monto_premium = 0;
        float monto_pecunium = 0;
        String codTipo = "";
        System.out.println("codAreaEmpresaF :" + codAreaEmpresaF);
        System.out.println("nombreAreaEmpresaF :" + nombreAreaEmpresaF);
        System.out.println("codLineaF :" + codLineaF);
        System.out.println("nombreLineaF :" + nombreLineaF);
        System.out.println("codGestionF :" + codGestionF);
        System.out.println("codPeriodoGestion :" + codPeriodoGestion);
        SimpleDateFormat f = new SimpleDateFormat("yyyy/MM/dd");
        String sql_insertar = "";
        String nombreGestionF = "";
        String codMesF = "";
        int sw = 0;
        try {
            con = Util.openConnection(con);


            /*String sql_nom = "select i.NOMBRE_TIPO_INCENTIVO from TIPOS_INCENTIVO_REGIONAL_DETALLE t,TIPOS_INCENTIVO i " +
            "where t.COD_AREA_EMPRESA='" + codAreaEmpresaF + "' and t.COD_LINEA_VENTA='" + codLineaF + "' and t.COD_TIPO_INCENTIVO_REGIONAL='" + cod_tipo_incentivo_regional + "' and i.COD_TIPO_INCENTIVO=t.COD_TIPO_INCENTIVO";
            System.out.println("sql_nom........:" + sql_nom);
            Statement st_nom = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs_nom = st_nom.executeQuery(sql_nom);
            while (rs_nom.next()) {
            nombreTipoIncentivo = rs_nom.getString(1);

            }
            String sql_nom = "select c.NOMBRE_CATEGORIA_INCENTIVO from CATEGORIAS_INCENTIVOS c where c.COD_CATEGORIA_INCENTIVO='" + categoriaIncentivo + "'";
            System.out.println("sql_nomcat........:" + sql_nom);
            Statement st_nom = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs_nom = st_nom.executeQuery(sql_nom);
            while (rs_nom.next()) {
            nombreCategoriaIncentivo = rs_nom.getString(1);

            }*/


            String valuesx[] = fechaInicio.split("/");
            String valuesx2[] = fechaFinal.split("/");
            String SQLFecha1 = valuesx[2] + "/" + valuesx[1] + "/" + valuesx[0];
            String SQLFecha2 = valuesx2[2] + "/" + valuesx2[1] + "/" + valuesx2[0];

            String sql_000 = "select g.COD_GESTION from GESTIONES g where g.FECHA_INI<='" + SQLFecha1 + "' and g.FECHA_FIN>='" + SQLFecha2 + "'";
            System.out.println("sql_000........:" + sql_000);
            Statement st_000 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs_000 = st_000.executeQuery(sql_000);
            SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
            while (rs_000.next()) {
                codGestionF = rs_000.getString(1);
                sw = 1;
            }
            if (sw == 1) {
                String sql_aux2 = "select nombre_gestion from GESTIONES where cod_gestion in(" + codGestionF + ")";
                System.out.println("sql_aux2 :" + sql_aux2);
                Statement st_aux2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs_aux2 = st_aux2.executeQuery(sql_aux2);
                if (rs_aux2.next()) {
                    nombreGestionF = rs_aux2.getString(1);
                }
            }
            String mesesArray = "";
            if (Integer.parseInt(valuesx2[2]) == Integer.parseInt(valuesx[2])) {
                for (int i = 0; i <= Integer.parseInt(valuesx2[1]) - Integer.parseInt(valuesx[1]); i++) {
                    int aux = Integer.parseInt(valuesx[1]) + i;
                    mesesArray = mesesArray + aux + ",";
                }
            } else {
                for (int i = 0; i <= 12 - Integer.parseInt(valuesx[1]); i++) {
                    int aux = Integer.parseInt(valuesx[1]) + i;
                    mesesArray = mesesArray + aux + ",";
                }
                for (int i = 0; i <= Integer.parseInt(valuesx2[1]) - 1; i++) {
                    int aux = i + 1;
                    mesesArray = mesesArray + aux + ",";
                }
            }
            mesesArray = mesesArray.substring(0, mesesArray.length() - 1);
            codMesF = mesesArray;
            System.out.println("mesesArray................:" + mesesArray);
            if (sw == 1) {
                String sql_p = "select DISTINCT(p.COD_PERIODO) from PERIODOS_VENTAS p,PERIODOS_DETALLEMESES pd";
                sql_p += " where p.COD_PERIODO = pd.COD_PERIODO and p.COD_GESTION in(" + codGestionF + ") and pd.COD_MESES in (" + mesesArray + ")";
                Statement st_p = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs_p = st_p.executeQuery(sql_p);
                while (rs_p.next()) {
                    codPeriodoGestion = codPeriodoGestion + "," + rs_p.getString(1);
                }
                codPeriodoGestionOriginal = codPeriodoGestion;
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            //con.close();
        }
        if (sw == 1) {
            /*codPeriodoGestion = codPeriodoGestion.substring(1, codPeriodoGestion.length());
            System.out.println("codMesF :" + codMesF);

            String codMesVector[] = codMesF.split(",");
            int colspan = (codMesVector.length) * 2;

            double anteriorPeriodoUU[] = new double[codMesVector.length];
            double anteriorPeriodoVV[] = new double[codMesVector.length];

            double UnidadUU[] = new double[codMesVector.length];

            double UUpresupuestadoV[] = new double[codMesVector.length];
            double VVpresupuestadoV[] = new double[codMesVector.length];


            double sumaAnteriorGestion[] = new double[colspan];

            double sumaGeneralPresupuesto[] = new double[colspan];
            double sumaGeneralVenta[] = new double[colspan];

            NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
            DecimalFormat form = (DecimalFormat) nf;
            form.applyPattern("#,###.00");
            NumberFormat nf1 = NumberFormat.getNumberInstance(Locale.ENGLISH);
            DecimalFormat form1 = (DecimalFormat) nf1;
            form.applyPattern("#,###");
            double width = codMesVector.length * 33d;
            width = width + 50;*/

        %>
        <div align="center">

            <table width="80%">
                <tr>
                    <td colspan="3" align="center" >
                        <h3>Incentivos por  Regional </h3>
                    </td>
                </tr>
                <tr>
                    
                    <td align="left" class="outputText2" width="100%" >
                        <%

                        %>
                        <b> <MARQUEE bgcolor = "#FFFFFF" width = 100% scrolldelay = 0 >  Los Datos se Calcularon Correctamente</MARQUEE>
                        
                    </td>
                </tr>

                <tr>
                    <td colspan="3">
                        <%--table   width="100%" align="center" cellpadding="0" cellspacing="0">
                            <tr  class="tituloCampo">
                            <td align="center" style="border-left:1px solid #000000;border-right:1px solid #000000;border-top:1px solid #000000;color: #123456;"><b>Area Empresa</b></td>
                            <td align="center" style="border-left:1px solid #000000;border-right:1px solid #000000;border-top:1px solid #000000;color: #123456;"><b>Linea Comisión</b></td>
                            <td align="center" style="border-left:1px solid #000000;border-right:1px solid #000000;border-top:1px solid #000000;color: #123456;"><b>Tipo Incentivo</b></td>
                            <td align="center" style="border-left:1px solid #000000;border-right:1px solid #000000;border-top:1px solid #000000;color: #123456;"><b>Porcentaje</b></td--%>

                            <%


            String codCategoriaVector[] = codCategoria.split(",");
            String nombreCategoriaVector[] = nombreCategoria.split(",");
            for (int m = 0; m <= codCategoriaVector.length - 1; m++) {
                codPeriodoGestion = codPeriodoGestionOriginal;
                String codCategoriaFiltro = codCategoriaVector[m];
                System.out.println("codCategoriaFiltro:" + codCategoriaFiltro);
                System.out.println("/**************************************** INICIO AREA  ********************************************/");
                String sql_areas = "select c.COD_AREA_EMPRESA from CATEGORIAS_INCENTIVOS_OTROS_AREAS c " +
                        " where c.COD_CATEGORIA_INCENTIVO=" + codCategoriaFiltro + "";
                Statement st_areas = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs_areas = st_areas.executeQuery(sql_areas);
                while (rs_areas.next()) {
                    codAreaEmpresaF = rs_areas.getString(1);
                    System.out.println("/**************************************** INICIO LINEA ********************************************/");
                    codPeriodoGestion = codPeriodoGestionOriginal;
                    codPeriodoGestion = codPeriodoGestion.substring(1, codPeriodoGestion.length());
                    System.out.println("codMesF :" + codMesF);

                    String codMesVector[] = codMesF.split(",");
                    int colspan = (codMesVector.length) * 2;

                    double anteriorPeriodoUU[] = new double[codMesVector.length];
                    double anteriorPeriodoVV[] = new double[codMesVector.length];

                    double UnidadUU[] = new double[codMesVector.length];

                    double UUpresupuestadoV[] = new double[codMesVector.length];
                    double VVpresupuestadoV[] = new double[codMesVector.length];


                    double sumaAnteriorGestion[] = new double[colspan];

                    double sumaGeneralPresupuesto[] = new double[colspan];
                    double sumaGeneralVenta[] = new double[colspan];

                    NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                    DecimalFormat form = (DecimalFormat) nf;
                    form.applyPattern("#,###.00");
                    NumberFormat nf1 = NumberFormat.getNumberInstance(Locale.ENGLISH);
                    DecimalFormat form1 = (DecimalFormat) nf1;
                    form.applyPattern("#,###");
                    double width = codMesVector.length * 33d;
                    width = width + 50;

                    System.out.println("******codAreaEmpresaF:" + codAreaEmpresaF);
                    /******************** Eliminamos *********************************/
                    /*con = Util.openConnection(con);
                    String sql_del = " delete from COMISIONES_PERSONAL_LINEASMKT_OTROS where COD_TIPO_INCENTIVO_REGIONAL=" + cod_tipo_incentivo_regional + " ";
                    sql_del += " and COD_AREA_EMPRESA='" + codAreaEmpresaF + "' AND COD_CATEGORIA_COMISION='" + codCategoriaFiltro + "'";
                    System.out.println("sql_del:" + sql_del);
                    Statement st_del = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    int rs_del = st_del.executeUpdate(sql_del);*/
                    /******************** Fin Eliminamos *********************************/
                            %>

                            <%--tr  class="tituloCampo">
                                <td><span class="outputTextNormal">&nbsp;</span></td>
                                <td><span class="outputTextNormal">&nbsp;</span></td>
                                <td align="center" style="background-color:#c5d9f1;border-left:1px solid #000000;border-top:1px solid #000000;border-right:1px solid #000000;" colspan="2"><b>Ventas Gestión Análisis</b></td>
                                <td align="center" style="background-color:#FDe9d9;border-right:1px solid #000000;border-top:1px solid #000000;" colspan="2"><b>Presupuesto Periodo de Análisis</b></td>
                                <td align="center" style="background-color:#ADD797;border-right:1px solid #000000;border-top:1px solid #000000;" colspan="2" ><b>Cumplimiento</b></td>
                                <td align="center" style="background-color:#dbE5F1;border-right:1px solid #000000;border-top:1px solid #000000;" colspan="2" ><b>Crecimiento</b></td>
                            </tr--%>
                            <%--tr  class="tituloCampo">
                                <td align="center" style="border-left:1px solid #000000;border-right:1px solid #000000;border-top:1px solid #000000;"><b>Producto</b></td>
                                <td align="center" style="border-left:1px solid #000000;border-right:1px solid #000000;border-top:1px solid #000000;"><b>Categoría</b></td--%>
                            <%        try {

                                                    String mesesV[] = new String[codMesVector.length];
                                                    int ind = 0;
                            %>
                            <%
            ////////////////////////////////////////////////////////////////////
            //  CABEZERA PRESUPUESTO
            ////////////////////////////////////////////////////////////////////
            String sql_mesVV = "select cod_mes,ABREVIATURA_MES+'.' from meses where cod_mes in (" + codMesF + ") ORDER BY ORDEN_MES ASC";
            System.out.println("sql_mesVV..........:" + sql_mesVV);
            Statement st_mesVV = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs_mesVV = st_mesVV.executeQuery(sql_mesVV);
            while (rs_mesVV.next()) {
                String codMes = rs_mesVV.getString(1);
                String nombreMes = rs_mesVV.getString(2);
                nombreMes = nombreMes.toUpperCase();
                mesesV[ind] = nombreMes;
                System.out.println("1111111");
                            %>
                            <%----td align="center" style="background-color:#CCC0DA;border-right:1px solid #000000;border-top:1px solid #000000;"><b><%=nombreMes%><br>Bs.</b></td--%>
                            <%
                ind++;

            }
                            %>
                            <%
            System.out.println("salio..." + ind);
            for (int k = 0; k <= ind - 1; k++) {
                            %>
                            <%----td align="center" style="background-color:#CCC0DA;border-right:1px solid #000000;border-top:1px solid #000000;"><b><%=mesesV[k]%><br>Unid.</b></td--%>
                            <%            }
                            %>
                            <%
            for (int k = 0; k <= ind - 1; k++) {
                            %>
                            <%--td align="center" style="background-color:#c5d9f1;border-right:1px solid #000000;border-top:1px solid #000000;"><b><%=mesesV[k]%><br>Bs.</b></td--%>
                            <%            }
                            %>
                            <%
            for (int k = 0; k <= ind - 1; k++) {
                            %>
                            <%--td align="center" style="background-color:#c5d9f1;border-right:1px solid #000000;border-top:1px solid #000000;"><b><%=mesesV[k]%><br>Unid.</b></td--%>
                            <%            }
                            %>
                            <%
            ////////////////////////////////////////////////////////////////////
            //  CABEZERA VENTAS
            ////////////////////////////////////////////////////////////////////
            for (int k = 0; k <= ind - 1; k++) {
                            %>
                            <%--td align="center" style="background-color:#FDe9d9;border-right:1px solid #000000;border-top:1px solid #000000;"><b><%=mesesV[k]%><br>Bs.</b></td--%>
                            <%}%>

                            <%
            for (int k = 0; k <= ind - 1; k++) {
                            %>
                            <%--td align="center" style="background-color:#FDe9d9;border-right:1px solid #000000;border-top:1px solid #000000;"><b><%=mesesV[k]%><br>Unid.</b></td--%>
                            <%            }
                            %>



                            <%
            for (int k = 0; k <= ind - 1; k++) {
                            %>
                            <%--td align="center" style="background-color:#ADD797;border-right:1px solid #000000;border-top:1px solid #000000;"><b><%=mesesV[k]%><br>Bs.</b></td--%>
                            <%}%>


                            <%
            for (int k = 0; k <= ind - 1; k++) {
                            %>
                            <%--td align="center" style="background-color:#ADD797;border-right:1px solid #000000;border-top:1px solid #000000;"><b><%=mesesV[k]%><br>Unid.</b></td--%>
                            <%}%>


                            <%
            for (int k = 0; k <= ind - 1; k++) {
                            %>
                            <%--td align="center" style="background-color:#dbE5F1;border-right:1px solid #000000;border-top:1px solid #000000;"><b><%=mesesV[k]%><br>Bs.%</b></td--%>
                            <%}%>
                            <%
            for (int k = 0; k <= ind - 1; k++) {
                            %>
                            <%--td align="center" style="background-color:#dbE5F1;border-right:1px solid #000000;border-top:1px solid #000000;"><b><%=mesesV[k]%><br>Unid.%</b></td--%>
                            <%}%>


                            <%

            double ventasMensuales[] = new double[ind];
            double presupuestosMensuales[] = new double[ind];



            double ventasMensualesUnidades[] = new double[ind];
            double presupuestosMensualesUnidades[] = new double[ind];



                            %>
                            <%--td align="center" style="border-left:1px solid #000000;border-right:1px solid #000000;border-top:1px solid #000000;"><b>Monto Incentivo (Bs)</b></td--%>
            <%--<td align="center" class="bordeNegroTdMod"><b>Bs.</b></td--%>
            <%--td align="center" class="bordeNegroTdMod"><b>Unid.</b></td--%>
        <%--/tr--%>

                            <%
                                  /******************** Eliminamos *********************************/
                con = Util.openConnection(con);
                String sql_del = " delete from COMISIONES_PERSONAL_LINEASMKT_OTROS where COD_TIPO_INCENTIVO_REGIONAL=" + cod_tipo_incentivo_regional + " ";
                sql_del += " and COD_AREA_EMPRESA='" + codAreaEmpresaF + "' AND COD_CATEGORIA_COMISION='" + codCategoriaFiltro + "'";
                System.out.println("sql_del:" + sql_del);
                Statement st_del = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                int rs_del = st_del.executeUpdate(sql_del);

                /******************** Fin Eliminamos *********************************/

            String sqlLinea = "select l.COD_LINEAMKT,l.NOMBRE_LINEAMKT from LINEAS_MKT l where l.COD_LINEAMKT in (SELECT distinct c.COD_LINEA_MKT FROM CATEGORIAS_INCENTIVOS_OTROS_DETALLE c,CATEGORIAS_INCENTIVOS_OTROS_AREAS ca where c.COD_CATEGORIA_INCENTIVO=" + codCategoriaFiltro + ") order by l.NOMBRE_LINEAMKT asc";
            System.out.println("sqlLinea...:" + sqlLinea);
            Statement stLinea = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rsLinea = stLinea.executeQuery(sqlLinea);
            while (rsLinea.next()) {

                double sumaMontoIncentivo = 0;
                System.out.println("/*********** INICIO DE LINEA *********************************/" + sumaMontoIncentivo);
                String codLineaFiltro = rsLinea.getString(1);
                String nombreLineaFiltro = rsLinea.getString(2);
          
                double subTotalUU1[] = new double[codMesF.length()];
                double subTotalUU2[] = new double[codMesF.length()];
                double subTotalUU3[] = new double[codMesF.length()];
                double subTotalVV1[] = new double[codMesF.length()];
                double subTotalVV2[] = new double[codMesF.length()];
                double subTotalVV3[] = new double[codMesF.length()];

                String sql_00 = "select p.cod_presentacion,pp.NOMBRE_PRODUCTO_PRESENTACION, p.cod_lineamkt,pp.cantidad_presentacion,pp.cod_categoria from PRODUCTOS_PRESUPUESTAR p,PRESENTACIONES_PRODUCTO pp";
                sql_00 += " where p.COD_PRESENTACION=pp.cod_presentacion and p.cod_gestion in(" + codGestionF + ")";
                sql_00 += " and p.cod_lineamkt in (" + codLineaFiltro + ") and p.cod_estado = 1 order by pp.cod_categoria,pp.NOMBRE_PRODUCTO_PRESENTACION asc";
                System.out.println("sql_00.............:" + sql_00);
                Statement st_00 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs_00 = st_00.executeQuery(sql_00);
                while (rs_00.next()) {
                    sql_insertar = "INSERT INTO COMISIONES_PERSONAL_LINEASMKT_OTROS (COD_TIPO_INCENTIVO_REGIONAL,";
                    sql_insertar += " COD_LINEAMKT,COD_AREA_EMPRESA,COD_CATEGORIA_COMISION,COD_PRESENTACION,NOMBRE_PRESENTACION,";
                    sql_insertar += " COD_CATEGORIA_PRESENTACION,NOMBRE_CATEGORIA_PRESENTACION,VENTAS_ANTERIOR_BS,VENTAS_ANTERIOR_UNID,VENTAS_ANALISIS_BS,VENTAS_ANALISIS_UNID,";
                    sql_insertar += " PRESUPUESTO_ANALISIS_BS,PRESUPUESTO_ANALISIS_UNID,CUMPLIMIENTO_BS,CUMPLIMIENTO_UNID,CRECIMIENTO_BS,CRECIMIENTO_UNID,MONTO_INCENTIVO)";
                    sql_insertar += " VALUES(" + cod_tipo_incentivo_regional + "," + codLineaFiltro + "," + codAreaEmpresaF + "," + codCategoriaFiltro + ",";
                    String codPresentacion = rs_00.getString(1);
                    String nombrePresentacion = rs_00.getString(2);


                    sql_insertar += "" + codPresentacion + ",'" + nombrePresentacion + "',";
                    String codLineaMkt = rs_00.getString(3);
                    float cantidadPresentacionPadre = rs_00.getFloat(4);
                    String cod_categoria_presentacion = rs_00.getString(5);
                    /*********************** revisar *************************************/
                    String sqlLineaVenta = "select l.COD_LINEAVENTA from LINEAS_VENTA_MKT l where l.COD_LINEAMKT=" + codLineaMkt;
                    System.out.println("sqlLineaVenta:" + sqlLineaVenta);
                    Statement stLineaVenta = con.createStatement();
                    ResultSet rsLineaVenta = stLineaVenta.executeQuery(sqlLineaVenta);
                    String codLineaVenta = "0";
                    if (rsLineaVenta.next()) {
                        codLineaVenta = rsLineaVenta.getString(1);
                    }
                    String sqlCategoria = "select c.NOMBRE_CATEGORIA from CATEGORIAS_PRODUCTO c where c.COD_CATEGORIA=" + cod_categoria_presentacion;
                    Statement stCategoria = con.createStatement();
                    ResultSet rsCategoria = stCategoria.executeQuery(sqlCategoria);
                    String nomCategoriaPresentacion = "";
                    if (rsCategoria.next()) {
                        nomCategoriaPresentacion = rsCategoria.getString(1);
                    }
                    sql_insertar += "" + cod_categoria_presentacion + ",'" + nomCategoriaPresentacion + "',";
                    double sumaVVpresupuesto = 0;
                    double sumaUUpresupuesto = 0;
                    double sumaVVventa = 0;
                    double sumaUUventa = 0;

                    ////////////////////////////////////////////////////////////////////
                    // OBTENEMOS LOS CODIGOS DE PRESENTACION PADRE
                    ////////////////////////////////////////////////////////////////////
                    String sql_01 = "select cod_presentacion from PRODUCTOS_PRESUPUESTAR where cod_presentacionpadre=" + codPresentacion + " and cod_gestion in(" + codGestionF + ")";
                    System.out.println("sql_01:" + sql_01);
                    Statement st_01 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs_01 = st_01.executeQuery(sql_01);
                    String codPresentacionPadre = "0";
                    while (rs_01.next()) {
                        codPresentacionPadre = codPresentacionPadre + "," + rs_01.getString(1);
                    }
                    System.out.println("codPresentacionPadre" + codPresentacionPadre);
                            %>
                            <%--tr  class="tituloCampo"--%>
        <%--td style="background-color:#FFFF99;border-left:1px solid #000000;border-top:1px solid #000000;border-right:1px solid #000000;"><%=nombrePresentacion%></td>
                                <td style="background-color:#FFFF99;border-left:1px solid #000000;border-top:1px solid #000000;border-right:1px solid #000000;">&nbsp;<%=nomCategoriaPresentacion%></td--%>


                            <%
                                                int cont = 0;
                                                int contador = 0;
                                                int contadorIndices = 0;
                                                int contadorIndicesUnidades = 0;
                                                SimpleDateFormat sd = new SimpleDateFormat("yyyy/MM/dd");

                                                String sql_001 = "select pdv.FECHA_INICIO,pdv.FECHA_FINAL from PERIODOS_VENTAS pv,PERIODOS_DETALLEMESES pdv";
                                                sql_001 += " where pv.COD_PERIODO = pdv.COD_PERIODO and pv.COD_GESTION =" + (Integer.parseInt(codGestionF) - 1);
                                                sql_001 += " and pdv.COD_MESES in (" + codMesF + ") order by pdv.FECHA_INICIO asc";

                                                System.out.println(sql_001);

                                                Statement st_001 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                                ResultSet rs_001 = st_001.executeQuery(sql_001);
                                                while (rs_001.next()) {
                                                    String fechaInicioMes = sd.format(rs_001.getDate(1));
                                                    String fechaFinalMes = sd.format(rs_001.getDate(2));


                                                    String sql_002 = "select sum(ROUND(((sd.CANTIDAD_TOTAL*pp.cantidad_presentacion) + isnull(sd.CANTIDAD_UNITARIATOTAL,0)), 2)) as totalUnidades";
                                                    sql_002 += ",sum((sd.CANTIDAD +(sd.CANTIDAD_UNITARIA / pp.cantidad_presentacion)) * sd.PRECIO_LISTA";
                                                    sql_002 += " *((100 - s.porcentaje_descuento) / 100) *((100 -sd.PORCENTAJE_APLICADOPRECIO) / 100)) as montoVenta";
                                                    sql_002 += " from SALIDAS_VENTAS s,SALIDAS_DETALLEVENTAS sd,ALMACENES_VENTAS av,PRESENTACIONES_PRODUCTO pp,clientes cl";
                                                    sql_002 += " where s.COD_SALIDAVENTA = sd.COD_SALIDAVENTAS and s.COD_ALMACEN_VENTA = av.COD_ALMACEN_VENTA";
                                                    sql_002 += " and pp.cod_presentacion = sd.COD_PRESENTACION and s.COD_CLIENTE = cl.cod_cliente";
                                                    sql_002 += " and av.COD_AREA_EMPRESA in(" + codAreaEmpresaF + ")";
                                                    sql_002 += " and cl.cod_tipocliente in (1,5,4,6)";
                                                    sql_002 += " and s.FECHA_SALIDAVENTA>='" + fechaInicioMes + " 00:00:00' and s.FECHA_SALIDAVENTA<='" + fechaFinalMes + " 23:59:59'";
                                                    sql_002 += " and pp.cod_presentacion in(" + codPresentacionPadre + ") and s.COD_ESTADO_SALIDAVENTA<>2 and s.COD_TIPOSALIDAVENTAS=3";

                                                    System.out.println(sql_002);
                                                    Statement st_002 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                                    ResultSet rs_002 = st_002.executeQuery(sql_002);
                                                    float UUpresupuesto = 0;
                                                    float VVpresupuesto = 0;
                                                    if (rs_002.next()) {
                                                        UUpresupuesto = rs_002.getFloat(1);
                                                        if (cantidadPresentacionPadre > 0) {
                                                            UUpresupuesto = java.lang.Math.round(UUpresupuesto / cantidadPresentacionPadre);
                                                        }
                                                        VVpresupuesto = java.lang.Math.round(rs_002.getFloat(2));
                                                        anteriorPeriodoUU[cont] = UUpresupuesto;
                                                        anteriorPeriodoVV[cont] = VVpresupuesto;
                                                        subTotalUU1[cont] = subTotalUU1[cont] + UUpresupuesto;
                                                        subTotalVV1[cont] = +subTotalVV1[cont] + VVpresupuesto;
                                                        sumaAnteriorGestion[contador] = sumaAnteriorGestion[contador] + VVpresupuesto;
                                                        sql_insertar += "" + VVpresupuesto + ",";


                                                    }
                                                    contadorIndices = contadorIndices + 1;
                            %>
                            <%--td align="right" style="background-color:#CCC0DA;border-right:1px solid #000000;border-top:1px solid #000000;"><%=form.format(VVpresupuesto)%></td--%>
                            <%
                                                    cont++;
                                                    contador++;
                                                }
                                                for (int i = 0; i <= anteriorPeriodoUU.length - 1; i++) {
                                                    sumaAnteriorGestion[contador] = sumaAnteriorGestion[contador] + anteriorPeriodoUU[i];
                                                    sql_insertar += "" + anteriorPeriodoUU[i] + ",";
                            %>
                            <%--td align="right" style="background-color:#CCC0DA;border-right:1px solid #000000;border-top:1px solid #000000;"><%=form.format(anteriorPeriodoUU[i])%></td--%>

                            <%
                                                    contador++;
                                                }
                            %>

                            <%

                                                String sql_05 = "select pdv.FECHA_INICIO,pdv.FECHA_FINAL from PERIODOS_VENTAS pv,PERIODOS_DETALLEMESES pdv";
                                                sql_05 += " where pv.COD_PERIODO = pdv.COD_PERIODO and pv.COD_GESTION =" + codGestionF;
                                                sql_05 += " and pdv.COD_MESES in (" + codMesF + ") order by pdv.FECHA_INICIO asc";
                                                Statement st_05 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                                ResultSet rs_05 = st_05.executeQuery(sql_05);
                                                cont = 0;
                                                contador = 0;
                                                contadorIndices = 0;
                                                while (rs_05.next()) {
                                                    String fechaInicioMes = sd.format(rs_05.getDate(1));
                                                    String fechaFinalMes = sd.format(rs_05.getDate(2));
                                                    String sql_06 = "select sum(ROUND(((sd.CANTIDAD_TOTAL*pp.cantidad_presentacion) + isnull(sd.CANTIDAD_UNITARIATOTAL,0)), 2)) as totalUnidades";
                                                    sql_06 += ",sum((sd.CANTIDAD +(sd.CANTIDAD_UNITARIA / pp.cantidad_presentacion)) * sd.PRECIO_LISTA";
                                                    sql_06 += " *((100 - s.porcentaje_descuento) / 100) *((100 -sd.PORCENTAJE_APLICADOPRECIO) / 100)) as montoVenta";
                                                    sql_06 += " from SALIDAS_VENTAS s,SALIDAS_DETALLEVENTAS sd,ALMACENES_VENTAS av,PRESENTACIONES_PRODUCTO pp,clientes cl";
                                                    sql_06 += " where s.COD_SALIDAVENTA = sd.COD_SALIDAVENTAS and s.COD_ALMACEN_VENTA = av.COD_ALMACEN_VENTA";
                                                    sql_06 += " and pp.cod_presentacion = sd.COD_PRESENTACION and s.COD_CLIENTE = cl.cod_cliente";
                                                    sql_06 += " and av.COD_AREA_EMPRESA in(" + codAreaEmpresaF + ")";
                                                    sql_06 += " and cl.cod_tipocliente in (1,5,4,6)";
                                                    sql_06 += " and s.FECHA_SALIDAVENTA>='" + fechaInicioMes + " 00:00:00' and s.FECHA_SALIDAVENTA<='" + fechaFinalMes + " 23:59:59'";
                                                    sql_06 += " and pp.cod_presentacion in(" + codPresentacionPadre + ") and s.COD_ESTADO_SALIDAVENTA<>2 and s.COD_TIPOSALIDAVENTAS=3";
                                                    System.out.println("sql_06:::::::::::::::::::" + sql_06);
                                                    Statement st_06 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                                    ResultSet rs_06 = st_06.executeQuery(sql_06);
                                                    float UUpresupuesto = 0;
                                                    float VVpresupuesto = 0;
                                                    if (rs_06.next()) {
                                                        UUpresupuesto = rs_06.getFloat(1);
                                                        if (cantidadPresentacionPadre > 0) {
                                                            UUpresupuesto = java.lang.Math.round(UUpresupuesto / cantidadPresentacionPadre);
                                                        }
                                                        VVpresupuesto = java.lang.Math.round(rs_06.getFloat(2));
                                                        UUpresupuestadoV[cont] = UUpresupuesto;
                                                        VVpresupuestadoV[cont] = VVpresupuesto;
                                                        subTotalUU2[cont] = subTotalUU2[cont] + UUpresupuesto;
                                                        subTotalVV2[cont] = subTotalVV2[cont] + VVpresupuesto;
                                                        sumaGeneralVenta[contador] = sumaGeneralVenta[contador] + VVpresupuesto;
                                                    }
                                                    sumaUUventa = sumaUUventa + UUpresupuesto;
                                                    sumaVVventa = sumaVVventa + VVpresupuesto;
                                                    presupuestosMensuales[contadorIndices] = VVpresupuesto;
                                                    contadorIndices = contadorIndices + 1;
                                                    sql_insertar += "" + VVpresupuesto + ",";
                            %>
                            <%--td align="right" style="background-color:#c5d9f1;border-right:1px solid #000000;border-top:1px solid #000000;"><%=form.format(VVpresupuesto)%></td--%>
                            <%
                                                    cont++;
                                                    contador++;
                                                }
                            %>

                            <%

                                                contadorIndicesUnidades = 0;
                                                for (int i = 0; i <= UUpresupuestadoV.length - 1; i++) {
                                                    sumaGeneralVenta[contador] = sumaGeneralVenta[contador] + UUpresupuestadoV[i];
                                                    presupuestosMensualesUnidades[contadorIndicesUnidades] = UUpresupuestadoV[i];
                                                    contadorIndicesUnidades++;
                                                    sql_insertar += "" + UUpresupuestadoV[i] + ",";

                            %>
                            <%--td align="right" style="background-color:#c5d9f1;border-right:1px solid #000000;border-top:1px solid #000000;"><%=form.format(UUpresupuestadoV[i])%></td--%>
                            <%
                                                    contador++;
                                                }
                            %>

                            <%
                                                String sql_02 = "select pdv.COD_MESES from PERIODOS_VENTAS pv,PERIODOS_DETALLEMESES pdv";
                                                sql_02 += " where pv.COD_PERIODO = pdv.COD_PERIODO and pv.COD_GESTION =" + codGestionF;
                                                sql_02 += " and pdv.COD_MESES in (" + codMesF + ") order by pdv.FECHA_INICIO asc";
                                                System.out.println("sql_02.............:" + sql_02);
                                                Statement st_02 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                                ResultSet rs_02 = st_02.executeQuery(sql_02);
                                                cont = 0;
                                                contador = 0;
                                                contadorIndices = 0;
                                                while (rs_02.next()) {
                                                    String codMes = rs_02.getString(1);

                                                    String sql_03 = "select SUM(pvm.CANTIDAD_UNITARIA),SUM(pvm.PRECIO_MINIMO * pvm.CANTIDAD_UNITARIA) as MONTO_VENTA";
                                                    sql_03 += " from PRESUPUESTO_VENTASGESTION pg,PRESUPUESTO_VENTASMENSUAL pvm,PRESENTACIONES_PRODUCTO pp";
                                                    sql_03 += " where pg.COD_PRESUPUESTOVENTAS = pvm.COD_PRESUPUESTOVENTAS and pvm.COD_PRESENTACION = pp.cod_presentacion";
                                                    sql_03 += " and pg.COD_GESTION =" + codGestionF + " and pg.COD_AREA_EMPRESA IN (" + codAreaEmpresaF + ") and ";
                                                    sql_03 += "pvm.COD_MES =" + codMes + " and pp.COD_LINEAMKT in (SELECT distinct c.COD_LINEA_MKT FROM CATEGORIAS_INCENTIVOS_OTROS_DETALLE c,CATEGORIAS_INCENTIVOS_OTROS_AREAS ca where c.COD_CATEGORIA_INCENTIVO=" + codCategoriaFiltro + ")";
                                                    sql_03 += " and pg.NRO_VERSIONPRESUPUESTOVENTAS in (select nro_versionpresupuestoventas ";
                                                    sql_03 += "from PRESUPUESTO_VENTASGESTION where cod_gestion =" + codGestionF + " and cod_area_empresa ";
                                                    sql_03 += " in (" + codAreaEmpresaF + ") and cod_lineamkt in (" + codLineaVenta + ") and cod_periodo in(" + codPeriodoGestion + "))";
                                                    sql_03 += " and pp.cod_presentacion IN (" + codPresentacionPadre + ")";
                                                    System.out.println("sql_03:::::::::::" + sql_03);
                                                    Statement st_03 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                                    ResultSet rs_03 = st_03.executeQuery(sql_03);
                                                    double UU = 0d;
                                                    double VV = 0d;
                                                    if (rs_03.next()) {
                                                        UU = rs_03.getFloat(1);
                                                        VV = rs_03.getFloat(2);
                                                        UnidadUU[cont] = UU;
                                                        subTotalUU3[cont] = subTotalUU3[cont] + UU;
                                                        subTotalVV3[cont] = subTotalVV3[cont] + VV;
                                                        sumaGeneralPresupuesto[contador] = sumaGeneralPresupuesto[contador] + VV;
                                                    }
                                                    sumaUUpresupuesto = sumaUUpresupuesto + UU;
                                                    sumaVVpresupuesto = sumaVVpresupuesto + VV;

                                                    ventasMensuales[contadorIndices] = VV;

                                                    contadorIndices = contadorIndices + 1;
                                                    sql_insertar += "" + VV + ",";


                            %>
                            <%--td align="right" style="background-color:#FDe9d9;border-right:1px solid #000000;border-top:1px solid #000000;"><%=form.format(VV)%></td--%>
                            <%
                                                    cont++;
                                                    contador++;

                                                    contadorIndicesUnidades = 0;
                                                }
                                                for (int i = 0; i <= UnidadUU.length - 1; i++) {
                                                    sumaGeneralPresupuesto[contador] = sumaGeneralPresupuesto[contador] + UnidadUU[i];

                                                    ventasMensualesUnidades[contadorIndicesUnidades] = UnidadUU[i];
                                                    contadorIndicesUnidades++;
                                                    sql_insertar += "" + UnidadUU[i] + ",";

                            %>
                            <%--td align="right" style="background-color:#FDe9d9;border-right:1px solid #000000;border-top:1px solid #000000;"><%=form.format(UnidadUU[i])%></td--%>
                            <%
                                                    contador++;
                                                }
                            %>





                            <%
                                                double cumplimientoVV = 0;
                                                double cumplimientoUU = 0;
                                                if (sumaVVpresupuesto > 0) {
                                                    cumplimientoVV = (sumaVVventa / sumaVVpresupuesto) * 100;
                                                }
                                                if (sumaUUpresupuesto > 0) {
                                                    cumplimientoUU = (sumaUUventa / sumaUUpresupuesto) * 100;
                                                }
                                                double cumplimientoVVaux = java.lang.Math.round(cumplimientoVV);
                                                double cumplimientoUUaux = java.lang.Math.round(cumplimientoUU);
                            %>

                            <%
                                                contadorIndices = 0;
                                                double cumplimientoVxMes = 0.0d;


                                                for (double VxMes : ventasMensuales) {
                                                    if (VxMes > 0.0d) {
                                                        cumplimientoVxMes = (presupuestosMensuales[contadorIndices] / VxMes) * 100.0d;
                                                    }
                                                    sql_insertar += "" + cumplimientoVxMes + ",";
                            %>
                            <%--td align="right" style="background-color:#ADD797;border-right:1px solid #000000;border-top:1px solid #000000;"><%=form.format(cumplimientoVxMes)%> %</td--%>

                            <%
                                                    contadorIndices++;
                                                }
                            %>



                            <%
                                                contadorIndicesUnidades = 0;

                                                double cumplimientoVxMesUnid = 0.0d;

                                                for (double VxMes : ventasMensualesUnidades) {
                                                    if (VxMes > 0.0d) {
                                                        cumplimientoVxMesUnid = (presupuestosMensualesUnidades[contadorIndicesUnidades] / VxMes) * 100.0d;
                                                    }
                                                    sql_insertar += "" + cumplimientoVxMesUnid + ",";
                            %>
                            <%--td align="right" style="background-color:#ADD797;border-right:1px solid #000000;border-top:1px solid #000000;"><%=form.format(cumplimientoVxMesUnid)%> %</td--%>

                            <%
                                                    contadorIndicesUnidades++;
                                                }
                            %>
                            <%
                                                for (int i = 0; i <= anteriorPeriodoVV.length - 1; i++) {
                                                    double crecimientoVV = 0;
                                                    if (anteriorPeriodoVV[i] > 0) {
                                                        crecimientoVV = ((VVpresupuestadoV[i] - anteriorPeriodoVV[i]) / anteriorPeriodoVV[i]) * 100;
                                                        crecimientoVV = java.lang.Math.round(crecimientoVV);
                                                    }
                                                    sql_insertar += "" + crecimientoVV + ",";
                            %>
                            <%--td align="right" style="background-color:#dbE5F1;border-right:1px solid #000000;border-top:1px solid #000000;"><%=form.format(crecimientoVV)%>%</td--%>
                            <%
                                                }
                            %>
                            <%
                                                for (int i = 0; i <= anteriorPeriodoUU.length - 1; i++) {
                                                    double crecimientoUU = 0;
                                                    if (anteriorPeriodoVV[i] > 0) {
                                                        crecimientoUU = ((UUpresupuestadoV[i] - anteriorPeriodoUU[i]) / anteriorPeriodoUU[i]) * 100;
                                                        crecimientoUU = java.lang.Math.round(crecimientoUU);
                                                    }
                                                    sql_insertar += "" + crecimientoUU + ",";
                            %>
                            <%--td align="right" style="background-color:#dbE5F1;border-right:1px solid #000000;border-top:1px solid #000000;"><%=form.format(crecimientoUU)%>%</td--%>
                            <%
                                                }
                                                //String montoIncentivoPresentacion = form.format(verifica(cumplimientoVxMesUnid, cod_categoria_presentacion, codAreaEmpresaF, codLineaF, cod_tipo_incentivo_regional, categoriaIncentivo));
                                                //sumaMontoIncentivo = sumaMontoIncentivo + verifica(cumplimientoVxMesUnid, cod_categoria_presentacion, codAreaEmpresaF, codLineaF, cod_tipo_incentivo_regional, categoriaIncentivo);
                                                //sumaTotalMontoIncentivo = sumaTotalMontoIncentivo + verifica(cumplimientoVxMesUnid, cod_categoria_presentacion, codAreaEmpresaF, codLineaF, cod_tipo_incentivo_regional, categoriaIncentivo);
                                                System.out.println("sumaTotalMontoIncentivo:" + sumaTotalMontoIncentivo);
                                                System.out.println("sumaTotalMontoIncentivo:" + sumaTotalMontoIncentivo);
                                                sql_insertar += "0)";
                                                System.out.println("sql_insertar:" + sql_insertar);
                                                Statement st_insertar = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                                int rs_insertar = st_insertar.executeUpdate(sql_insertar);


                            %>

                            <%--td align="right" style="background-color:#dbE5F1;border-right:1px solid #000000;border-top:1px solid #000000;"><%=form.format(verifica(cumplimientoVxMesUnid, cod_categoria_presentacion, codAreaEmpresaF, codLineaF, cod_tipo_incentivo_regional, categoriaIncentivo))%></td--%>


                            <%--/tr--%>
                            <%}%>
                            <%--tr  class="tituloCampo"--%>
        <%--td align="right" style="background-color:#FFFF99;border-left:1px solid #000000;border-top:1px solid #000000;border-right:1px solid #000000;color: red;"><b>TOTAL &nbsp;<%=nombreLineaFiltro%>&nbsp;</b></td--%>
                            <%
                                            sql_insertar = "INSERT INTO COMISIONES_PERSONAL_LINEASMKT_OTROS (COD_TIPO_INCENTIVO_REGIONAL,";
                                            sql_insertar += " COD_LINEAMKT,COD_AREA_EMPRESA,COD_CATEGORIA_COMISION,COD_PRESENTACION,NOMBRE_PRESENTACION,";
                                            sql_insertar += " COD_CATEGORIA_PRESENTACION,NOMBRE_CATEGORIA_PRESENTACION,VENTAS_ANTERIOR_BS,VENTAS_ANTERIOR_UNID,VENTAS_ANALISIS_BS,VENTAS_ANALISIS_UNID,";
                                            sql_insertar += " PRESUPUESTO_ANALISIS_BS,PRESUPUESTO_ANALISIS_UNID,CUMPLIMIENTO_BS,CUMPLIMIENTO_UNID,CRECIMIENTO_BS,CRECIMIENTO_UNID,MONTO_INCENTIVO)";
                                            sql_insertar += " VALUES(" + cod_tipo_incentivo_regional + "," + codLineaFiltro + "," + codAreaEmpresaF + "," + codCategoriaFiltro + ",0,'" + nombreLineaFiltro + "',";
                                            sql_insertar += " 10,'Z',";
                                            System.out.println("----------------------------------------------->" + codMesVector.length);
                                            for (int k = 0; k <= codMesVector.length - 1; k++) {
                                                sql_insertar += "" + subTotalVV1[k] + ",";
                            %>
                            <%--td align="right" style="background-color:#FFFF99;border-top:1px solid #000000;border-right:1px solid #000000;color: red;"><b><%=form.format(subTotalVV1[k])%></b></td--%>
                            <%}%>
                            <%
                                            for (int k = 0; k <= codMesVector.length - 1; k++) {
                                                sql_insertar += "" + subTotalUU1[k] + ",";
                            %>
                            <%--td align="right" style="background-color:#FFFF99;border-top:1px solid #000000;border-right:1px solid #000000;color: red;"><b>&nbsp;</b></td--%>
                            <%}%>
                            <%
                                            for (int k = 0; k <= codMesVector.length - 1; k++) {
                                                sql_insertar += "" + subTotalVV2[k] + ",";
                            %>
                            <%--td align="right" style="background-color:#FFFF99;border-top:1px solid #000000;border-right:1px solid #000000;color: red;"><b><%=form.format(subTotalVV2[k])%></b></td--%>
                            <%}%>
                            <%
                                            for (int k = 0; k <= codMesVector.length - 1; k++) {
                                                sql_insertar += "" + subTotalUU2[k] + ",";
                            %>
                            <%--td align="right" style="background-color:#FFFF99;border-top:1px solid #000000;border-right:1px solid #000000;color: red;"><b><%=form.format(subTotalUU2[k])%></b></td--%>
                            <%}%>
                            <%
                                            for (int k = 0; k <= codMesVector.length - 1; k++) {
                                                sql_insertar += "" + subTotalVV3[k] + ",";
                            %>
                            <%--td align="right" style="background-color:#FFFF99;border-top:1px solid #000000;border-right:1px solid #000000;color: red;"><b><%=form.format(subTotalVV3[k])%></b></td--%>
                            <%}%>
                            <%
                                            for (int k = 0; k <= codMesVector.length - 1; k++) {
                                                sql_insertar += "" + subTotalUU3[k] + ",";
                            %>
                            <%--td align="right" style="background-color:#FFFF99;border-top:1px solid #000000;border-right:1px solid #000000;color: red;"><b><%=form.format(subTotalUU3[k])%></b></td--%>
                            <%}%>

                            <%
                                            for (int k = 0; k <= codMesVector.length - 1; k++) {
                                                double cumplimientoVV = 0;
                                                if (subTotalVV2[k] > 0) {
                                                    System.out.println("subTotalVV2[k]:" + subTotalVV2[k]);
                                                    System.out.println("subTotalVV3[k]:" + subTotalVV3[k]);
                                                    cumplimientoVV = (subTotalVV2[k] / subTotalVV3[k]) * 100;
                                                    System.out.println("cumplimientoVV:" + cumplimientoVV);
                                                }
                                                sql_insertar += "" + cumplimientoVV + ",";
                            %>
                            <%--td align="right" style="background-color:#FFFF99;border-top:1px solid #000000;border-right:1px solid #000000;color: red;"><b><%=form.format(cumplimientoVV)%>%</b></td--%>
                            <%}%>
                            <%
                                            for (int k = 0; k <= codMesVector.length - 1; k++) {
                                                double cumplimientoUU = 0;
                                                if (subTotalUU2[k] > 0) {
                                                    cumplimientoUU = (subTotalUU2[k] / subTotalUU3[k]) * 100;
                                                }
                                                sql_insertar += "" + cumplimientoUU + ",";
                            %>
                            <%--td align="right" style="background-color:#FFFF99;border-top:1px solid #000000;border-right:1px solid #000000;color: red;"><b><%=form.format(cumplimientoUU)%>%</b></td--%>
                            <%}%>
                            <%
                                            for (int k = 0; k <= codMesVector.length - 1; k++) {
                                                double crecimientoVV = 0;
                                                if (subTotalVV1[k] > 0) {
                                                    crecimientoVV = ((subTotalVV2[k] - subTotalVV1[k]) / subTotalVV1[k]) * 100;
                                                }
                                                sql_insertar += "" + crecimientoVV + ",";
                                                try {
                                                    sql_del = "delete from  TIPOS_INCENTIVO_REGIONAL_OTROS_DETALLE where COD_TIPO_INCENTIVO_REGIONAL='" + cod_tipo_incentivo_regional + "'  ";
                                                    sql_del += " and COD_AREA_EMPRESA='" + codAreaEmpresaF + "' and COD_CATEGORIA_INCENTIVO ='" + codCategoriaFiltro + "'";
                                                    sql_del += " and COD_LINEA_MKT='" + codLineaFiltro + "'";
                                                    System.out.println("sql_del:" + sql_del);
                                                    con = Util.openConnection(con);
                                                    PreparedStatement st_eli = con.prepareStatement(sql_del);
                                                    int result_del = st_eli.executeUpdate();
                                                    String sql = "insert into TIPOS_INCENTIVO_REGIONAL_OTROS_DETALLE(COD_TIPO_INCENTIVO_REGIONAL,";
                                                    sql += " COD_AREA_EMPRESA,COD_CATEGORIA_INCENTIVO,PORCENTAJE,COD_LINEA_MKT)values(";
                                                    sql += "'" + cod_tipo_incentivo_regional + "',";
                                                    sql += "'" + codAreaEmpresaF + "','" + codCategoriaFiltro + "','" + form.format(crecimientoVV) + "'," + codLineaFiltro + ")";
                                                    System.out.println("sql INSERT TIPOS:" + sql);
                                                    //con = Util.openConnection(con);
                                                    PreparedStatement st = con.prepareStatement(sql);
                                                    int result = st.executeUpdate();

                                                } catch (SQLException e) {
                                                    e.printStackTrace();
                                                }
                            %>
                            <%--td align="right" style="background-color:#FFFF99;border-top:1px solid #000000;border-right:1px solid #000000;color: red;"><b><%=form.format(crecimientoVV)%>%</b></td--%>
                            <%}%>
                            <%
                                            for (int k = 0; k <= codMesVector.length - 1; k++) {
                                                double crecimientoUU = 0;
                                                if (subTotalUU1[k] > 0) {
                                                    crecimientoUU = ((subTotalUU2[k] - subTotalUU1[k]) / subTotalUU1[k]) * 100;
                                                }
                                                sql_insertar += "" + crecimientoUU + ",";

                            %>
                            <%--td align="right" style="background-color:#FFFF99;border-top:1px solid #000000;border-right:1px solid #000000;color: red;"><b><%=form.format(crecimientoUU)%>%</b></td--%>
                            <%}
                                            sql_insertar += "" + sumaMontoIncentivo + ")";
                                            System.out.println("sql_insertar-sum:" + sql_insertar);
                                            Statement st_insertar = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                            int rs_insertar = st_insertar.executeUpdate(sql_insertar);
                                            /***************************************Calcula Monto***********************************************/
                                            double sumTotalMontoParcial = 0;
                                            double sumTotalMonto = 0;
                                            String nombreAreaEmpresa = "";
                                            String nombreLineaComision = "";
                                            con = Util.openConnection(con);
                                            Statement st6 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                            String sql6 = " select c.NOMBRE_PRESENTACION,c.COD_CATEGORIA_PRESENTACION,c.NOMBRE_CATEGORIA_PRESENTACION,c.VENTAS_ANALISIS_BS,c.VENTAS_ANALISIS_UNID,";
                                            sql6 += " c.PRESUPUESTO_ANALISIS_BS,c.PRESUPUESTO_ANALISIS_UNID,c.CUMPLIMIENTO_BS,c.CUMPLIMIENTO_UNID,";
                                            sql6 += " c.CRECIMIENTO_BS,c.CRECIMIENTO_UNID from COMISIONES_PERSONAL_LINEASMKT_OTROS c WHERE";
                                            sql6 += " c.COD_AREA_EMPRESA=" + codAreaEmpresaF + " and c.COD_CATEGORIA_COMISION=" + codCategoriaFiltro + " and c.COD_TIPO_INCENTIVO_REGIONAL=" + cod_tipo_incentivo_regional + "";
                                            sql6 += " and c.COD_LINEAMKT=" + codLineaFiltro + " and c.COD_CATEGORIA_PRESENTACION=10";
                                            sql6 += " order by c.COD_LINEAMKT,c.COD_CATEGORIA_PRESENTACION";
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

                                                /*NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                                                DecimalFormat form = (DecimalFormat) nf;
                                                form.applyPattern("#,###.00");*/
                                                //String montoIncentivoPresentacion = "0";
                                                double montoIncentivoPresentacion = verifica(cumplimiento_bs, codAreaEmpresaF, codCategoriaFiltro, codLineaFiltro);
                                                //String montoIncentivoPresentacion = form.format(verifica(crecimiento_bs, codAreaEmpresaF, codCategoriaFiltro, codLineaFiltro));
                                                double montoaux = montoIncentivoPresentacion;
                                                sumTotalMontoParcial = sumTotalMontoParcial + montoaux;
                                                System.out.println("sumTotalMontoParcial:" + sumTotalMontoParcial);
                                                sumTotalMontoParcial = redondear(sumTotalMontoParcial, 0);
                                                sumTotalMonto = sumTotalMonto + montoaux;
                                                sumTotalMonto = redondear(sumTotalMonto, 0);
                                                System.out.println("sumTotalMonto:" + sumTotalMonto);
                                            }

                                            try {
                                                String sql_upd = " UPDATE TIPOS_INCENTIVO_REGIONAL_OTROS_DETALLE SET";
                                                sql_upd += " MONTO=" + sumTotalMonto + " WHERE COD_TIPO_INCENTIVO_REGIONAL='" + cod_tipo_incentivo_regional + "' " +
                                                        " AND COD_AREA_EMPRESA='" + codAreaEmpresaF + "' AND COD_CATEGORIA_INCENTIVO=" + codCategoriaFiltro + " " +
                                                        " and COD_LINEA_MKT=" + codLineaFiltro + "";
                                                System.out.println("sql_upd_update:" + sql_upd);
                                                con = Util.openConnection(con);
                                                PreparedStatement st = con.prepareStatement(sql_upd);
                                                int result = st.executeUpdate();
                                                sql_upd = " UPDATE TIPOS_INCENTIVO_REGIONAL_OTROS_DETALLE SET";
                                                sql_upd += " MONTO=0 WHERE COD_TIPO_INCENTIVO_REGIONAL='" + cod_tipo_incentivo_regional + "' AND COD_AREA_EMPRESA='" + codAreaEmpresaF + "' AND COD_CATEGORIA_INCENTIVO=" + codCategoriaFiltro + " " +
                                                        " AND COD_LINEA_MKT=0";
                                                System.out.println("sql_upd_update:" + sql_upd);
                                                con = Util.openConnection(con);
                                                st = con.prepareStatement(sql_upd);
                                                result = st.executeUpdate();
                                            } catch (SQLException ex) {
                                                ex.printStackTrace();
                                            }
                                        /***************************************Fin Calcula Monto***********************************************/

                            %>
                            <%--td align="right" style="background-color:#FFFF99;border-right:1px solid #000000;border-top:1px solid #000000;color: red;"><b><%=form.format(sumaMontoIncentivo)%></b></td--%>
                            <%--/tr--%>
                            <%            }
                            %>
                            <%
                                                } catch (SQLException ex) {
                                                    ex.printStackTrace();
                                                } finally {
                                                    //con.close();
                                                }
                            %>
                            <tr  class="tituloCampo">
                                <%
                                                sql_insertar = "INSERT INTO COMISIONES_PERSONAL_LINEASMKT_OTROS (COD_TIPO_INCENTIVO_REGIONAL,";
                                                sql_insertar += " COD_LINEAMKT,COD_AREA_EMPRESA,COD_CATEGORIA_COMISION,COD_PRESENTACION,NOMBRE_PRESENTACION,";
                                                sql_insertar += " COD_CATEGORIA_PRESENTACION,NOMBRE_CATEGORIA_PRESENTACION,VENTAS_ANTERIOR_BS,VENTAS_ANTERIOR_UNID,VENTAS_ANALISIS_BS,VENTAS_ANALISIS_UNID,";
                                                sql_insertar += " PRESUPUESTO_ANALISIS_BS,PRESUPUESTO_ANALISIS_UNID,CUMPLIMIENTO_BS,CUMPLIMIENTO_UNID,CRECIMIENTO_BS,CRECIMIENTO_UNID,MONTO_INCENTIVO)";
                                                sql_insertar += " VALUES(" + cod_tipo_incentivo_regional + ",20," + codAreaEmpresaF + "," + codCategoriaFiltro + ",-1,'',";
                                                sql_insertar += " 10,'Z',";
                                %>
                                <%--td align="left" style="border-left:1px solid #000000;border-right:1px solid #000000;border-top:1px solid #000000;border-bottom:1px solid #000000;color: red;"><b><%=nombreAreaEmpresaF%></b></td--%>
                                <%
                                                for (int k = 0; k < sumaAnteriorGestion.length; k++) {
                                                    sql_insertar += "" + sumaAnteriorGestion[k] + ",";
                                %>
                                <%--td style="background-color:#CCC0DA;border-right:1px solid #000000;border-top:1px solid #000000;border-bottom:1px solid #000000;" align="right"><b><%=form.format(sumaAnteriorGestion[k])%></b></td--%>
                                <%        }
                                %>
                                <%--td style="background-color:#CCC0DA;border-right:1px solid #000000;border-top:1px solid #000000;border-bottom:1px solid #000000;" align="right"><b>&nbsp;</b></td--%>
                                <%
                                                for (int k = 0; k < sumaGeneralVenta.length; k++) {
                                                    sql_insertar += "" + sumaGeneralVenta[k] + ",";
                                %>
                                <%--td style="background-color:#c5d9f1;border-right:1px solid #000000;border-top:1px solid #000000;border-bottom:1px solid #000000;" align="right"><b><%=form.format(sumaGeneralVenta[k])%></b></td--%>
                                <%        }%>
                                <%
                                                for (int k = 0; k < sumaGeneralPresupuesto.length; k++) {
                                                    sql_insertar += "" + sumaGeneralPresupuesto[k] + ",";
                                %>
                                <%--td style="background-color:#FDe9d9;border-right:1px solid #000000;border-top:1px solid #000000;border-bottom:1px solid #000000;" align="right"><b><%=form.format(sumaGeneralPresupuesto[k])%></b></td--%>
                                <%        }
                                %>
                                <%
                                                for (int k = 0; k < sumaGeneralVenta.length; k++) {

                                                    double cumplimiento = 0.0f;
                                                    if (sumaGeneralPresupuesto[k] > 0) {
                                                        cumplimiento = (sumaGeneralVenta[k] / sumaGeneralPresupuesto[k]) * 100;

                                                    }
                                                    sql_insertar += "" + cumplimiento + ",";

                                %>
                                <%--td style="background-color:#ADD797;border-right:1px solid #000000;border-top:1px solid #000000;border-bottom:1px solid #000000;" align="right"><b><%=form.format(cumplimiento)%>%</b></td--%>
                                <%        }%>
                                <%
                                                for (int k = 0; k < anteriorPeriodoVV.length; k++) {
                                                    double crecimientoTotalVV = 0;
                                                    if (sumaAnteriorGestion[k] > 0) {
                                                        crecimientoTotalVV = ((sumaGeneralVenta[k] - sumaAnteriorGestion[k]) / sumaAnteriorGestion[k]) * 100;
                                                    }
                                                    con = Util.openConnection(con);
                                                    crecimientoTotalVV = java.lang.Math.round(crecimientoTotalVV);
                                                    String sql_inc = "select t.VALOR_TIPO_INCENTIVO from TIPOS_INCENTIVO t where t.COD_TIPO_INCENTIVO in (1,2)";
                                                    System.out.println("sql_inc:" + sql_inc);
                                                    Statement st_inc = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                                    ResultSet rs_inc = st_inc.executeQuery(sql_inc);
                                                    int i = 0;
                                                    while (rs_inc.next()) {
                                                        if (i == 0) {
                                                            monto_pecunium = rs_inc.getFloat(1);
                                                            i++;
                                                        } else {
                                                            monto_premium = rs_inc.getFloat(1);
                                                        }

                                                    }
                                                    System.out.println("monto_pecunium:" + monto_pecunium);
                                                    System.out.println("monto_premium:" + monto_premium);
                                                    if (crecimientoTotalVV > monto_pecunium && crecimientoTotalVV < monto_premium) {
                                                        nombreTipo = "PECUNIUM";
                                                        codTipo = "1";
                                                    } else {
                                                        if (crecimientoTotalVV > 28) {
                                                            nombreTipo = "PREMIUM";
                                                            codTipo = "2";
                                                        } else {
                                                            nombreTipo = "NINGUNO";
                                                            codTipo = "0";
                                                        }
                                                    }

                                                    sql_insertar += "" + crecimientoTotalVV + ",";
                                %>
                                <%--td align="right" style="background-color:yellow;border-right:1px solid #000000;border-top:1px solid #000000;"><%=nombreLineaF%> </td>
                                <td align="right" style="background-color:yellow;border-right:1px solid #000000;border-top:1px solid #000000;"><%=nombreTipo%> </td>
                                <td style="background-color:#dbE5F1;border-right:1px solid #000000;border-top:1px solid #000000;border-bottom:1px solid #000000;" align="right"><b><%=form.format(crecimientoTotalVV)%>%</b></td--%>
                                <%        }
                                %>
                                <%
                                                for (int k = anteriorPeriodoVV.length; k < anteriorPeriodoVV.length * 2; k++) {
                                                    double crecimientoTotalUU = 0;
                                                    if (sumaAnteriorGestion[k] > 0) {
                                                        crecimientoTotalUU = ((sumaGeneralVenta[k] - sumaAnteriorGestion[k]) / sumaAnteriorGestion[k]) * 100;
                                                    }
                                                    crecimientoTotalUU = java.lang.Math.round(crecimientoTotalUU);
                                                    sql_insertar += "" + crecimientoTotalUU + ",";
                                %>
                                <%--td style="background-color:#dbE5F1;border-right:1px solid #000000;border-top:1px solid #000000;border-bottom:1px solid #000000;" align="right"><b><%=form.format(crecimientoTotalUU)%>%</b></td--%>
                                <%        }
                                                sql_insertar += "" + sumaTotalMontoIncentivo + ")";
                                                System.out.println("sql_insertar:" + sql_insertar);
                                                Statement st_insertar = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                                int rs_insertar = st_insertar.executeUpdate(sql_insertar);

                                %>
                                <%--td align="right" style="background-color:yellow;border-right:1px solid #000000;border-top:1px solid #000000;">TT: <%=form.format(sumaTotalMontoIncentivo)%></td--%>
                            </tr>
                            <%
                /***************************************Calcula Monto ww***********************************************/
                /* double sumTotalMontoParcial = 0;
                double sumTotalMonto = 0;
                String nombreAreaEmpresa = "";
                String nombreLineaComision = "";
                con = Util.openConnection(con);
                Statement st6 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                String sql6 = " select c.NOMBRE_PRESENTACION,c.COD_CATEGORIA_PRESENTACION,c.NOMBRE_CATEGORIA_PRESENTACION,c.VENTAS_ANALISIS_BS,c.VENTAS_ANALISIS_UNID,";
                sql6 += " c.PRESUPUESTO_ANALISIS_BS,c.PRESUPUESTO_ANALISIS_UNID,c.CUMPLIMIENTO_BS,c.CUMPLIMIENTO_UNID,";
                sql6 += " c.CRECIMIENTO_BS,c.CRECIMIENTO_UNID from COMISIONES_PERSONAL_LINEASMKT_OTROS c WHERE";
                //sql6 += " c.COD_AREA_EMPRESA=" + codAreaEmpresa + " and c.COD_LINEA_COMISIONMKT=1 and c.COD_TIPO_INCENTIVO_REGIONAL=" + cod_tipo_incentivo_regional + "";
                sql6 += " c.COD_AREA_EMPRESA=" + codAreaEmpresaF + " and c.COD_CATEGORIA_COMISION=" + codCategoriaFiltro + " and c.COD_TIPO_INCENTIVO_REGIONAL=" + cod_tipo_incentivo_regional + "";
                sql6 += " order by c.COD_LINEAMKT,c.COD_CATEGORIA_PRESENTACION";
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

                //String montoIncentivoPresentacion = "0";
                String montoIncentivoPresentacion = form.format(verifica(cumplimiento_unid, codAreaEmpresaF, codCategoriaFiltro, cod_tipo_incentivo_regional));
                double montoaux = Double.parseDouble(montoIncentivoPresentacion);
                sumTotalMontoParcial = sumTotalMontoParcial + montoaux;
                System.out.println("sumTotalMontoParcial:" + sumTotalMontoParcial);
                sumTotalMontoParcial = redondear(sumTotalMontoParcial, 0);
                sumTotalMonto = sumTotalMonto + montoaux;
                sumTotalMonto = redondear(sumTotalMonto, 0);
                System.out.println("sumTotalMonto:" + sumTotalMonto);
                }

                try {
                String sql_upd = " UPDATE TIPOS_INCENTIVO_REGIONAL_OTROS_DETALLE SET";
                sql_upd += " MONTO=" + sumTotalMonto + " WHERE COD_TIPO_INCENTIVO_REGIONAL='" + cod_tipo_incentivo_regional + "' AND COD_AREA_EMPRESA='" + codAreaEmpresaF + "' AND COD_CATEGORIA_INCENTIVO=" + codCategoriaFiltro + " ";
                System.out.println("sql_upd_update:" + sql_upd);
                con = Util.openConnection(con);
                PreparedStatement st = con.prepareStatement(sql_upd);
                int result = st.executeUpdate();
                sql_upd = " UPDATE TIPOS_INCENTIVO_REGIONAL_OTROS_DETALLE SET";
                sql_upd += " MONTO=0 WHERE COD_TIPO_INCENTIVO_REGIONAL='" + cod_tipo_incentivo_regional + "' AND COD_AREA_EMPRESA='" + codAreaEmpresaF + "' AND COD_CATEGORIA_INCENTIVO=" + codCategoriaFiltro + " " +
                " AND COD_LINEA_MKT=0";
                System.out.println("sql_upd_update:" + sql_upd);
                con = Util.openConnection(con);
                st = con.prepareStatement(sql_upd);
                result = st.executeUpdate();
                } catch (SQLException ex) {
                ex.printStackTrace();
                }*/
                /***************************************Fin Calcula Monto wwwww***********************************************/
                }
            /***************************************Calcula Monto***********************************************/
            /*  double sumTotalMontoParcial = 0;
            double sumTotalMonto = 0;
            String nombreAreaEmpresa = "";
            String nombreLineaComision = "";
            Statement st6 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String sql6 = " select c.NOMBRE_PRESENTACION,c.COD_CATEGORIA_PRESENTACION,c.NOMBRE_CATEGORIA_PRESENTACION,c.VENTAS_ANALISIS_BS,c.VENTAS_ANALISIS_UNID,";
            sql6 += " c.PRESUPUESTO_ANALISIS_BS,c.PRESUPUESTO_ANALISIS_UNID,c.CUMPLIMIENTO_BS,c.CUMPLIMIENTO_UNID,";
            sql6 += " c.CRECIMIENTO_BS,c.CRECIMIENTO_UNID from COMISIONES_PERSONAL_LINEASMKT c WHERE";
            //sql6 += " c.COD_AREA_EMPRESA=" + codAreaEmpresa + " and c.COD_LINEA_COMISIONMKT=1 and c.COD_TIPO_INCENTIVO_REGIONAL=" + cod_tipo_incentivo_regional + "";
            sql6 += " c.COD_AREA_EMPRESA=" + codAreaEmpresaF + " and c.COD_LINEA_COMISIONMKT=" + codLineaF + " and c.COD_TIPO_INCENTIVO_REGIONAL=" + cod_tipo_incentivo_regional + "";
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

            String montoIncentivoPresentacion = form.format(verifica(cumplimiento_unid, codCategoriaPres, codAreaEmpresaF, codLineaF, cod_tipo_incentivo_regional));
            double montoaux = Double.parseDouble(montoIncentivoPresentacion);
            sumTotalMontoParcial = sumTotalMontoParcial + montoaux;
            System.out.println("sumTotalMontoParcial:" + sumTotalMontoParcial);
            sumTotalMontoParcial = redondear(sumTotalMontoParcial, 0);
            sumTotalMonto = sumTotalMonto + montoaux;
            sumTotalMonto = redondear(sumTotalMonto, 0);
            System.out.println("sumTotalMonto:" + sumTotalMonto);


            }

            try {
            String sql_upd = " UPDATE TIPOS_INCENTIVO_REGIONAL_DETALLE SET";
            sql_upd += " MONTO=" + sumTotalMonto + " WHERE COD_TIPO_INCENTIVO_REGIONAL='" + cod_tipo_incentivo_regional + "' AND COD_AREA_EMPRESA='" + codAreaEmpresaF + "' AND COD_LINEA_VENTA=" + codLineaF + " ";
            System.out.println("sql_upd_update:" + sql_upd);
            con = Util.openConnection(con);
            PreparedStatement st = con.prepareStatement(sql_upd);
            int result = st.executeUpdate();
            sql_upd = " UPDATE TIPOS_INCENTIVO_REGIONAL_DETALLE SET";
            sql_upd += " MONTO=0 WHERE COD_TIPO_INCENTIVO_REGIONAL='" + cod_tipo_incentivo_regional + "' AND COD_AREA_EMPRESA='" + codAreaEmpresaF + "' AND COD_LINEA_VENTA=" + codLineaF + " " +
            " AND COD_TIPO_INCENTIVO=0";
            System.out.println("sql_upd_update:" + sql_upd);
            con = Util.openConnection(con);
            st = con.prepareStatement(sql_upd);
            result = st.executeUpdate();
            } catch (SQLException ex) {
            ex.printStackTrace();
            }*/
            /***************************************Fin Calcula Monto***********************************************/
            }
                            %>
                        </table>

                    </td>
                </tr>
            </table>
            <br><br>
            <input type="submit" value="Cerrar" onclick="cerraringLiquidacion();">

        </div>
        <%} else {
        %>
        <span class="outputTextNormal">
            <marquee BEHAVIOR=ALTERNATE style="color:red;" > <center><b>Error en el Reporte</b></center></marquee><p>
            <center>El rango de las fechas es incorrecto.</center>
            <center>Intente nuevamente ó comuniquese con:<p>
            <b><span style="color:#8A0886">Laboratorios Cofar S.A. - Departamento de Sistemas</span></b></center>
        </span>
        <%                    }%>
    </body>
</html>