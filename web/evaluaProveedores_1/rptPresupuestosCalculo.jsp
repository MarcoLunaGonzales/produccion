package evaluaProveedores;

package calculoPremiosBimensuales_1;

<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.Connection"%>
<%@ page import = "java.sql.DriverManager"%> 
<%@ page import = "java.sql.ResultSet"%> 
<%@ page import = "java.sql.Statement"%> 
<%@ page import = "java.sql.*"%> 
<%@ page import = "java.text.SimpleDateFormat"%> 
<%@ page import = "java.util.ArrayList"%> 
<%@ page import = "java.util.Date"%> 
<%@ page import="java.text.*" %>
<%@ page import="java.util.*" %>
<style type="text/css">
    .bordeNegroTdMod1 {
        padding: 0px;
        border-right-width: 0px;
        border-bottom-width: 0px;
        border-right-style: solid;
        border-bottom-style: solid;
        border-right-color: #CCCCCC;
        border-bottom-color: #CCCCCC;
        font-family: Verdana, Arial, Helvetica, sans-serif;
        font-size: 9px;
    }
</style>
<%!
    public double importeVentaRegional(String codareaempresa, String fecha1, String fecha2, String codlineas, String codgestion, Connection con) {
        double cantidadVenta = 0.0d;
        double importeVenta = 0.0d;
        double sumasponderados = 0.0d;
        try {

            System.out.println("----REGIONAL----");
            String sqlVM = "select p.cod_presentacion,pp.NOMBRE_PRODUCTO_PRESENTACION,p.cod_lineamkt,pp.cantidad_presentacion";
            sqlVM += " from PRODUCTOS_PRESUPUESTAR p,PRESENTACIONES_PRODUCTO pp where p.COD_PRESENTACION = pp.cod_presentacion and ";
            sqlVM += " p.cod_gestion in (" + codgestion + ") and p.cod_lineamkt in (" + codlineas + ") and    p.cod_estado = 1 order by pp.NOMBRE_PRODUCTO_PRESENTACION asc ";
            Statement stP = con.createStatement();
            ResultSet rsP = stP.executeQuery(sqlVM);



            while (rsP.next()) {
                String codPresentacion = rsP.getString(1);
                String nombreProducto = rsP.getString(2);


                String sql_01 = "select cantidad_presentacion from PRESENTACIONES_PRODUCTO where cod_presentacion=" + codPresentacion + " ";
                Statement st_01 = con.createStatement();
                ResultSet rs_01 = st_01.executeQuery(sql_01);
                int cantidad_presentacion_padre = 0;
                while (rs_01.next()) {
                    cantidad_presentacion_padre = rs_01.getInt(1);
                }


                sqlVM = "select sum(ROUND(((  sd.CANTIDAD_UNITARIATOTAL ) +isnull(sd.CANTIDAD_TOTAL* pp.cantidad_presentacion, 0)), 2) /" + cantidad_presentacion_padre + " ) as totalUnidades";
               /* sqlVM += ",sum((sd.CANTIDAD +(sd.CANTIDAD_UNITARIA / pp.cantidad_presentacion)) * sd.PRECIO_LISTA";
                sqlVM += " *((100 - s.porcentaje_descuento) / 100) *((100 -sd.PORCENTAJE_APLICADOPRECIO) / 100)) as montoVenta";*/
                 sqlVM += ",(CASE sd.COD_OFERTA  When 0 Then isnull(sum((isnull(sd.cantidad, 0) +(isnull(" +
                        " sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) * sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100) *((100" +
                        "  - isnull(s.PORCENTAJE_DESCUENTO_PREFERENCIAL, 0)) / 100) *((100 - s.porcentaje_descuento) / 100)), 0)" +
                        "   ELSE isnull(sum((isnull(sd.cantidad, 0) +(isnull( sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) *" +
                        "  sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100)), 0)  END) as montoVenta";
                sqlVM += " from SALIDAS_VENTAS s,SALIDAS_DETALLEVENTAS sd,ALMACENES_VENTAS av,PRESENTACIONES_PRODUCTO pp,clientes cl";
                sqlVM += " where s.COD_SALIDAVENTA = sd.COD_SALIDAVENTAS and s.COD_ALMACEN_VENTA = av.COD_ALMACEN_VENTA";
                sqlVM += " and pp.cod_presentacion = sd.COD_PRESENTACION and s.COD_CLIENTE = cl.cod_cliente";
                sqlVM += " and av.COD_AREA_EMPRESA in(" + codareaempresa + ")";
                sqlVM += " and cl.cod_tipocliente in (1,5,4,6)";
                sqlVM += " and s.FECHA_SALIDAVENTA between '" + fecha1 + " 00:00:00' and '" + fecha2 + " 23:59:59'";
//sqlVM += " and pp.cod_presentacion in(" + codPresentacionPadre + ") and s.COD_ESTADO_SALIDAVENTA<>2 and s.COD_TIPOSALIDAVENTAS=3";

                sqlVM += " and pp.cod_presentacion in(";
                sqlVM += " select distinct cod_presentacion from PRODUCTOS_PRESUPUESTAR where cod_presentacionpadre in(  ";
                sqlVM += " select p.cod_presentacion from PRODUCTOS_PRESUPUESTAR p,PRESENTACIONES_PRODUCTO pp ";
                sqlVM += " where p.COD_PRESENTACION=pp.cod_presentacion and p.cod_gestion =" + codgestion;
//sqlVM += " and p.cod_lineamkt in ("+codlineas+") and p.cod_estado = 1)) ";
                sqlVM += " and p.cod_presentacion in (" + codPresentacion + ") and p.cod_estado = 1)) ";

                sqlVM += " and s.COD_ESTADO_SALIDAVENTA<>2 and s.COD_TIPOSALIDAVENTAS=3";
                sqlVM += " group by sd.cod_oferta ";

                System.out.println("VENTA:" + sqlVM);
                Statement stVM = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rsVM = stVM.executeQuery(sqlVM);

                /*if (rsVM.next()) {
                    cantidadVenta = rsVM.getDouble(1);
                    importeVenta = rsVM.getDouble(2);

                }*/
                double cantidadVentaAux=0.0d;
                double importeVentaAux=0.0d;
                while (rsVM.next()) {
                    cantidadVentaAux =cantidadVentaAux + rsVM.getDouble(1);
                    importeVentaAux =importeVentaAux + rsVM.getDouble(2);

                }
                cantidadVenta=cantidadVentaAux;
                importeVenta=importeVentaAux;
                rsVM.close();
                stVM.close();
                String mesesData = "";

                List<MonthInterval> m = Util.getMonths(fecha1, fecha2);
                for (MonthInterval mes : m) {

                    mesesData += mes.getEndDate().split("-")[1] + ",";

                }
                mesesData = mesesData.substring(0, mesesData.length() - 1);




                String sqlPresupuesto = "select sum(  (pvm.CANTIDAD_UNITARIA*p.cantidad_presentacion)/" + cantidad_presentacion_padre + "  ),sum(pvm.CANTIDAD_UNITARIA * pvm.PRECIO_MINIMO)";
                sqlPresupuesto += " from PRESUPUESTO_VENTASGESTION pv,PRESUPUESTO_VENTASMENSUAL pvm,PRESENTACIONES_PRODUCTO p";
                sqlPresupuesto += " where pv.COD_PRESUPUESTOVENTAS = pvm.COD_PRESUPUESTOVENTAS and pvm.COD_PRESENTACION=p.cod_presentacion and pv.COD_GESTION =" + codgestion;
                sqlPresupuesto += " and pv.COD_AREA_EMPRESA  in(" + codareaempresa + ") and pv.COD_LINEAMKT in (1,2) ";
//sqlPresupuesto += " and pv.COD_AREA_EMPRESA =" + codareaempresa + " and pv.COD_LINEAMKT in (1,2) and pv.NRO_VERSIONPRESUPUESTOVENTAS =" + nroVersionPresuesto;

                sqlPresupuesto += " and pvm.COD_PRESENTACION  in(";
                sqlPresupuesto += " select cod_presentacion from PRODUCTOS_PRESUPUESTAR where cod_presentacionpadre in(  ";
                sqlPresupuesto += " select p.cod_presentacion from PRODUCTOS_PRESUPUESTAR p,PRESENTACIONES_PRODUCTO pp ";
                sqlPresupuesto += " where p.COD_PRESENTACION=pp.cod_presentacion and p.cod_gestion =" + codgestion;
                sqlPresupuesto += " and p.cod_presentacion in (" + codPresentacion + ") and p.cod_estado = 1)) ";
                sqlPresupuesto += " and cod_mes in (" + mesesData + ")";
                System.out.println("PRESUPUESTO:" + sqlPresupuesto);
                Statement stPresupuesto = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rsPresupuesto = stPresupuesto.executeQuery(sqlPresupuesto);
                double cantidadPresupuesto = 0.0d;
                if (rsPresupuesto.next()) {
                    cantidadPresupuesto = rsPresupuesto.getDouble(1);
//importePresupuesto=rsPresupuesto.getDouble(2);
                }
                rsPresupuesto.close();
                rsPresupuesto.close();

                double cumplimientoCantidad = 0;
                if (cantidadPresupuesto > 0) {
                    cumplimientoCantidad = (cantidadVenta / cantidadPresupuesto) * 100.0d;
                }


//double cumplimientoCantidad=(cantidadVenta/cantidadPresupuesto)*100.0d;
                System.out.println("cumplimientoCantidad:" + cumplimientoCantidad);

                String sqlPonderado = "select isnull(cum.NRO_CUMPLIMENTOVENTASPRODUCTO,0) from CUMPLIMIENTO_VENTASPRODUCTO cum   ";
                sqlPonderado += " where  " + cumplimientoCantidad + "  between (select c.PORCENTAJE_INICIAL from  CUMPLIMIENTO_VENTAS c where       cum.COD_CUMPLIMENTOVENTAS=c.COD_CUMPLIMENTOVENTAS)";
                sqlPonderado += " and (select c.PORCENTAJE_FINAL from  CUMPLIMIENTO_VENTAS c where       cum.COD_CUMPLIMENTOVENTAS=c.COD_CUMPLIMENTOVENTAS)";
                sqlPonderado += "  and cod_presentacion=" + codPresentacion;
                Statement stPonderado = con.createStatement();
                ResultSet rsPonderado = stPonderado.executeQuery(sqlPonderado);
                float ponderado = 0.0f;
                if (rsPonderado.next()) {
                    ponderado = rsPonderado.getFloat(1);
                }
                rsPonderado.close();
                stPonderado.close();


                System.out.println("PONDERADO:" + ponderado);
                System.out.println("nombreProducto:" + nombreProducto);


                sumasponderados = sumasponderados + ponderado;
                //sumasponderados = sumasponderados + ponderado;


            }










        } catch (SQLException e) {
            e.printStackTrace();

        }
        return sumasponderados;

    }%>

<%! Connection con = null;%>
<%!
    public double redondear(double numero, int decimales) {
        return Math.round(numero * Math.pow(10, decimales)) / Math.pow(10, decimales);
    }
%>
<%! class PresupuestoReportes {

        public String codareaempresa = "";
        public String codlineamkt = "";
        public String nombreareaempresa = "";
        public double sumUUVGAnterior = 0.0d;
        public double sumBSVGAnterior = 0.0d;
        public double sumPPVGAnterior = 0.0d;
        public double sumUUVGAnalisis = 0.0d;
        public double sumBSVGAnalisis = 0.0d;
        public double sumPPVGAnalisis = 0.0d;
        public double sumPresupuestoUU = 0.0d;
        public double sumPresupuestoBs = 0.0d;
        public double sumPresupuestoPP = 0.0d;
        public double sumPonderadoPP = 0.0d;
    }%>
<html>
    <head>
        <title>Seguimiento de Presupuesto x Periodo Resumido</title>
        <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
        <script type="text/css" src="../js/general.js"></script>
    </head>
    <body style="margin:0px">
        <form action="">
            <%
        String fechaInicio = request.getParameter("fechaInicio");
        String fechaFinal = request.getParameter("fechaFinal");
        String codArea = request.getParameter("area");
        String nombreagencia = request.getParameter("nombreagencia");
        String codLineaVenta = request.getParameter("codLinea");
        String nombreLineaVenta = request.getParameter("nombreLinea");
        String codGestionF = "";
        String codPeriodo = "";
        String cod_tipo_inc_regional = request.getParameter("cod_tipo_inc_regional");
        String cod_gestion = request.getParameter("cod_gestion");
        String cod_mes = request.getParameter("cod_mes");
        String nombre_gestion = request.getParameter("nombre_gestion");
        String nombre_mes = request.getParameter("nombre_mes");
        String ponderados = request.getParameter("ponderado");

        System.out.println("ponderado:" + ponderados);
        System.out.println("codArea:" + codArea);
        System.out.println("nombreagencia:" + nombreagencia);
        System.out.println("codLineaMkt" + codLineaVenta);
        System.out.println("fechaInicio:" + fechaInicio);
        System.out.println("fechaFinal:" + fechaFinal);

        String valuesx[] = fechaInicio.split("/");
        String valuesx2[] = fechaFinal.split("/");
        String SQLFecha1 = valuesx[2] + "/" + valuesx[1] + "/" + valuesx[0];
        String SQLFecha2 = valuesx2[2] + "/" + valuesx2[1] + "/" + valuesx2[0];
        String SQLFechaIni = valuesx[2] + "-" + valuesx[1] + "-" + valuesx[0];
        String SQLFechaFin = valuesx2[2] + "-" + valuesx2[1] + "-" + valuesx2[0];
        System.out.println("SQLFecha1:"+SQLFecha1);
        System.out.println("SQLFecha2:"+SQLFecha2);
        int sw = 0;

        con = Util.openConnection(con);
        String sql_000 = "select g.COD_GESTION from GESTIONES g where g.FECHA_INI<='" + SQLFecha1 + "' and g.FECHA_FIN>='" + SQLFecha2 + "'";
        System.out.println("sql_000........:" + sql_000);
        Statement st_000 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rs_000 = st_000.executeQuery(sql_000);
        SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
        while (rs_000.next()) {
            codGestionF = rs_000.getString(1);
            sw = 1;
        }


        String codArea1 = codArea;
        String codAreaVector[] = codArea1.split(",");
        for (int k1 = 0; k1 < codAreaVector.length; k1++) {
            codArea = codAreaVector[k1];
            Statement st_delete = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            int rs_delete = st_delete.executeUpdate("delete from TIPOS_PREMIO_BIMENSUAL_DETALLE  where cod_area_empresa=" + codArea + " and cod_tipo_premio=" + cod_tipo_inc_regional + "");
            Statement st_delete1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            int rs_delete1 = st_delete1.executeUpdate("delete from TIPOS_PREMIO_BIMENSUAL_CARGO where cod_area_empresa=" + codArea + " and cod_tipo_premio=" + cod_tipo_inc_regional + "");

            rs_delete = st_delete.executeUpdate("delete from TIPOS_PREMIO_BIMENSUAL_DETALLE  where cod_area_empresa=1000 and cod_tipo_premio=" + cod_tipo_inc_regional + "");
            st_delete1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            rs_delete1 = st_delete1.executeUpdate("delete from TIPOS_PREMIO_BIMENSUAL_CARGO where cod_area_empresa=1000 and cod_tipo_premio=" + cod_tipo_inc_regional + "");

            if (sw == 1) {
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
                System.out.println("mesesArray................:" + mesesArray);
                String sql_001 = "select DISTINCT(p.COD_PERIODO) from PERIODOS_VENTAS p,PERIODOS_DETALLEMESES pd";
                sql_001 += " where p.COD_PERIODO = pd.COD_PERIODO and p.COD_GESTION =" + codGestionF + " and pd.COD_MESES in (" + mesesArray + ")";
                System.out.println("sql_001......:" + sql_001);
                Statement st_001 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs_001 = st_001.executeQuery(sql_001);
                codPeriodo = "";
                while (rs_001.next()) {
                    codPeriodo = codPeriodo + "," + rs_001.getString(1);
                }
                codPeriodo = codPeriodo.substring(1, codPeriodo.length());
                int year = Integer.parseInt(valuesx[2]);
                int yearF = Integer.parseInt(valuesx2[2]);
                int month = Integer.parseInt(valuesx[1]);
                int date = Integer.parseInt(valuesx[0]);
                int yearStart = year - 1;
                int yearFinal = yearF - 1;
                int monthStart = month;
                Calendar calendar = Calendar.getInstance();
                calendar.set(yearStart, monthStart, 0, 0, 0, 0);
                int dayFinal = calendar.getActualMaximum(Calendar.DAY_OF_MONTH);

                String dateBegin = String.valueOf(yearStart) + "/" + monthStart + "/01";
                String dateEnd = String.valueOf(yearStart) + "/" + monthStart + "/" + dayFinal;

                String fechaInicioF = String.valueOf(yearStart) + "/" + valuesx[1] + "/" + valuesx[0];
                String fechaFinalF = String.valueOf(yearFinal) + "/" + valuesx2[1] + "/" + valuesx2[0];


                NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat form = (DecimalFormat) nf;
                form.applyPattern("#,###.00");

                int size = 100;


                List<PresupuestoReportes> array = new ArrayList<PresupuestoReportes>();

                Statement stAgencias = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                String sqlAgencias = "select cod_area_empresa,nombre_area_empresa ";
                sqlAgencias += " from areas_empresa ae  ";
                sqlAgencias += " where ";
                //sql6+=" av.cod_area_empresa=ae.cod_area_empresa and ua.cod_personal="+obj.getUsuarioModuloBean().getCodUsuarioGlobal();
                sqlAgencias += " cod_area_empresa in(" + codArea + ")";
                ResultSet rsAgencias = stAgencias.executeQuery(sqlAgencias);
                String nombreAreaEmpresa = "";
                while (rsAgencias.next()) {
                    String codareaempresa = rsAgencias.getString(1);
                    String nombreareaempresa = rsAgencias.getString(2);
                    PresupuestoReportes p = new PresupuestoReportes();
                    p.codareaempresa = codareaempresa;
                    p.nombreareaempresa = nombreareaempresa;
                    nombreAreaEmpresa = nombreareaempresa;
                    array.add(p);
                }
                size = size + (array.size() * 50);
                /*String sql_01 = "select cod_gestion from GESTIONES where '" + SQLFecha1 + "'>=fecha_ini  and '" + SQLFecha2 + "'<=fecha_fin";
                Statement st_01 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs_01 = st_01.executeQuery(sql_01);
                String codGestionF = "0";
                if (rs_01.next()) {
                codGestionF = rs_01.getString(1);
                }*/

                String sql_03 = "select l.COD_LINEAMKT from LINEAS_MKT l where l.COD_LINEAMKT in (" + codLineaVenta + ")";
                Statement st_03 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs_03 = st_03.executeQuery(sql_03);
                String codLineaMKT = "";
                codLineaMKT = codLineaVenta;

                /*String sql_p="select p.COD_PERIODO from PERIODOS_VENTAS p where p.FECHA_INICIO>='"+SQLFecha1+"' and p.FECHA_FINAL<='"+SQLFecha2+"'";
                Statement st_p = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs_p = st_p.executeQuery(sql_p);
                if(rs_p.next()){
                codPeriodo=rs_p.getString(1);
                }*/
                System.out.println("codPeriodo....:" + codPeriodo);
            %>
            <table align="center" width="90%" >
                <tr >
                    <td colspan="3" align="center" >
                        <h4>Cálculo Premio Bimensual</h4>
                    </td>
                </tr>
                <tr>
                    <td align="left" width="25%"><img src="../img/logo_cofar.png" alt=""></td>
                    <td align="left" class="outputText2" width="50%" >
                        <b>Línea&nbsp;::&nbsp;</b><%=nombreLineaVenta%>
                    </td>
                    <td width="25%">
                        <table border="0" class="outputText2" width="100%" >
                            <tr>
                                <td colspan="2" align="right"><b>Fecha Inicio&nbsp;::&nbsp;</b><%=fechaInicio%><br><b>Fecha &nbsp;Final&nbsp;::&nbsp;</b><%=fechaFinal%></td>
                            </tr>
                            <tr>
                                <td colspan="2" align="right"><b><%=nombreAreaEmpresa%></b></td>
                            </tr>

                        </table>
                    </td>
                </tr>


            </table>



            <table  align="center"  width="<%=(size - 50)%>%" cellpadding="0" cellspacing="0">


                <tr >
                    <td  style="border-right:1px solid #000000;">
                        <span class="outputText2">&nbsp;</span>
                    </td>
                    <%  int index = 2;
                    for (PresupuestoReportes p : array) {
                        String color = "";
                        if (index % 2 == 0) {
                            color = "background-color:#c5d9f1";
                        } else {
                            color = "background-color:#FFFF99";
                        }
                        index++;
                        System.out.println("t------------------------------------------------------------:" + array.size());
                    %>
                    <td  colspan="14" align="center" style="<%=color%>;border-bottom:1px solid #000000;border-top:1px solid #000000;border-right:1px solid #000000;">
                        <span class="outputText2" style="font-weight:bold;"><%=p.nombreareaempresa%></span>
                    </td>
                    <%}%>




                </tr>

                <tr >
                    <td  style="border-right:1px solid #000000;border-bottom:1px solid #000000;" >
                        <span class="outputText2">&nbsp;</span>
                    </td>
                    <%for (PresupuestoReportes p : array) {%>
                    <td  colspan="3" align="center" style="background-color:#CCC0DA;border-right:1px solid #000000;border-bottom:1px solid #000000;"  >
                        <span class="outputText2" style="font-weight:bold">Ventas Gestión Anterior</span>
                    </td>
                    <td  colspan="3" align="center" style="border-right:1px solid #000000;border-bottom:1px solid #000000;background-color:#FDe9d9"  >
                        <span class="outputText2" style="font-weight:bold">Ventas Gestión Análisis</span>
                    </td>
                    <td  colspan="3" align="center" style="background-color:#CCC0DA;border-right:1px solid #000000;border-bottom:1px solid #000000;">
                        <span class="outputText2" style="font-weight:bold">Presupuesto Periodo de Análisis</span>
                    </td>
                    <td  colspan="3" align="center" style="background-color:#ADD797;border-right:1px solid #000000;border-bottom:1px solid #000000;">
                        <span class="outputText2" style="font-weight:bold">Cumplimiento</span>
                    </td>

                    <td  colspan="2" align="center" style="background-color:#dbE5F1;border-right:1px solid #000000;border-bottom:1px solid #000000;">
                        <span class="outputText2" style="font-weight:bold">Crecimiento</span>
                    </td>

                    <%}%>
                </tr>

                <tr >
                    <td  align="center" style="border-right:1px solid #000000;border-bottom:1px solid #000000;border-left:1px solid #000000;">
                        <span class="outputText2"><b>Presentaciones</b></span>
                    </td>
                    <%for (PresupuestoReportes p : array) {%>

                    <td  align="center" style="background-color:#CCC0DA;border-right:1px solid #000000;border-bottom:1px solid #000000;">
                        <span class="outputText2" style="font-weight:bold">UU</span>
                    </td>
                    <td  align="center" style="background-color:#CCC0DA;border-right:1px solid #000000;border-bottom:1px solid #000000;">
                        <span class="outputText2" style="font-weight:bold">Bs</span>
                    </td>
                    <td align="center" style="background-color:#CCC0DA;border-right:1px solid #000000;border-bottom:1px solid #000000;">
                        <span class="outputText2" style="font-weight:bold">PP Bs</span>
                    </td>

                    <td  align="center" style="border-right:1px solid #000000;border-bottom:1px solid #000000;background-color:#FDe9d9;">
                        <span class="outputText2" style="font-weight:bold">UU</span>
                    </td>
                    <td align="center" style="border-right:1px solid #000000;border-bottom:1px solid #000000;background-color:#FDe9d9;">
                        <span class="outputText2" style="font-weight:bold">Bs</span>
                    </td>
                    <td align="center" style="border-right:1px solid #000000;border-bottom:1px solid #000000;background-color:#FDe9d9;">
                        <span class="outputText2" style="font-weight:bold">PP Bs</span>
                    </td>



                    <td  align="center" style="background-color:#CCC0DA;border-right:1px solid #000000;border-bottom:1px solid #000000;">
                        <span class="outputText2" style="font-weight:bold">UU</span>
                    </td>

                    <td align="center" style="background-color:#CCC0DA;border-right:1px solid #000000;border-bottom:1px solid #000000;">
                        <span class="outputText2" style="font-weight:bold">Bs</span>
                    </td>
                    <td align="center" style="background-color:#CCC0DA;border-right:1px solid #000000;border-bottom:1px solid #000000;">
                        <span class="outputText2" style="font-weight:bold">PP Bs</span>
                    </td>



                    <td  align="center" style="background-color:#ADD797;border-right:1px solid #000000;border-bottom:1px solid #000000;">
                        <span class="outputText2" style="font-weight:bold">%UU</span>
                    </td>
                    <td  align="center" style="background-color:#ADD797;border-right:1px solid #000000;border-bottom:1px solid #000000;">
                        <span class="outputText2" style="font-weight:bold">%Bs</span>
                    </td>
                    <td  align="center" style="background-color:#ff6464;border-right:1px solid #000000;border-bottom:1px solid #000000;">
                        <span class="outputText2" style="font-weight:bold">%Ponderado</span>
                    </td>

                    <td  align="center" style="background-color:#dbE5F1;border-right:1px solid #000000;border-bottom:1px solid #000000;">
                        <span class="outputText2" style="font-weight:bold">%UU</span>
                    </td>
                    <td  align="center" style="background-color:#dbE5F1;border-right:1px solid #000000;border-bottom:1px solid #000000;">
                        <span class="outputText2" style="font-weight:bold">%Bs</span>
                    </td>

                    <%}%>

                </tr>
                <%

                    String sqlLinea = "select l.COD_LINEAMKT,l.NOMBRE_LINEAMKT from LINEAS_MKT l where l.COD_LINEAMKT in (" + codLineaMKT + ") order by l.NOMBRE_LINEAMKT asc";
                    Statement stLinea = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet rsLinea = stLinea.executeQuery(sqlLinea);
                    while (rsLinea.next()) {
                        String codLineaFiltro = rsLinea.getString(1);
                        String nombreLineaFiltro = rsLinea.getString(2);
                        double subTotalUU1[] = new double[array.size()];
                        double subTotalUU2[] = new double[array.size()];
                        double subTotalUU3[] = new double[array.size()];
                        double subTotalVV1[] = new double[array.size()];
                        double subTotalVV2[] = new double[array.size()];
                        double subTotalVV3[] = new double[array.size()];

                        double sumPonderados[] = new double[array.size()];

                %>
                <%
                                        String sqlPresentacion2 = "select p.cod_presentacion, pp.NOMBRE_PRODUCTO_PRESENTACION,pp.cantidad_presentacion from PRODUCTOS_PRESUPUESTAR p,PRESENTACIONES_PRODUCTO pp";
                                        sqlPresentacion2 += " where p.COD_PRESENTACION=pp.cod_presentacion and p.cod_gestion =" + codGestionF;
                                        sqlPresentacion2 += " and p.cod_lineamkt in (" + codLineaFiltro + ") and p.cod_estado = 1 order by pp.NOMBRE_PRODUCTO_PRESENTACION asc";
                                        System.out.println("sqlPresentacion2-------------------------------------------:" + sqlPresentacion2);
                                        Statement stPresentacion2 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                        ResultSet rsPresentacion2 = stPresentacion2.executeQuery(sqlPresentacion2);
                                        while (rsPresentacion2.next()) {
                                            String codpresentacion = rsPresentacion2.getString(1);
                                            String nombre_producto_presentacion = rsPresentacion2.getString(2);
                                            float cantidadPresentacionPadre = rsPresentacion2.getFloat(3);
                                            ////////////////////////////////////////////////////////////////////
                                            // OBTENEMOS LOS CODIGOS DE PRESENTACION PADRE
                                            ////////////////////////////////////////////////////////////////////
                                            String sql_00 = "select cod_presentacion from PRODUCTOS_PRESUPUESTAR where cod_presentacionpadre=" + codpresentacion + " and cod_gestion=" + codGestionF;
                                            System.out.println("sql_00..:" + sql_00);
                                            Statement st_00 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                            ResultSet rs_00 = st_00.executeQuery(sql_00);
                                            String codPresentacionPadre = "0";
                                            while (rs_00.next()) {
                                                codPresentacionPadre = codPresentacionPadre + "," + rs_00.getString(1);
                                            }
                %>
                <tr >
                    <td style="border-right:1px solid #000000;border-bottom:1px solid #000000;background-color:#FFFF99;border-left:1px solid #000000;" >
                        <span class="outputText2" ><%=nombre_producto_presentacion%></span>
                    </td>

                    <%
                    int j = 0;
                    for (PresupuestoReportes p : array) {
                        System.out.println("p.codareaempresa:" + p.codareaempresa);
                        ////////////////////////////////////////////////////////
                        //  NRO DE VERSION DE PRESUPUESTO
                        ////////////////////////////////////////////////////////
                        String sql_05 = "select max(nro_versionpresupuestoventas) from PRESUPUESTO_VENTASGESTION where cod_area_empresa =" + p.codareaempresa;
//                                                        sql_05 += " and cod_gestion =" + codGestionF + " and cod_lineamkt in ("+codLineaMKT+")";
                        sql_05 += " and cod_gestion =" + codGestionF + " and cod_lineamkt in (1,2) and cod_periodo in(" + codPeriodo + ")";
                        System.out.println("sql_05:" + sql_05);
                        Statement st_05 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                        ResultSet rs_05 = st_05.executeQuery(sql_05);
                        int nroVersionPresuesto = 0;
                        if (rs_05.next()) {
                            nroVersionPresuesto = rs_05.getInt(1);
                        }

                    %>
                    <%
                        ////////////////////////////////////////////////////////////////////////////
                        //  CC && VV DE UNA GESTION ANTERIOR
                        ////////////////////////////////////////////////////////////////////////////
                        String sqlVA = "select sum(ROUND(((sd.CANTIDAD_TOTAL*pp.cantidad_presentacion) + isnull(sd.CANTIDAD_UNITARIATOTAL,0)), 2)) as totalUnidades";
                        sqlVA += ",sum((sd.CANTIDAD +(sd.CANTIDAD_UNITARIA / pp.cantidad_presentacion)) * sd.PRECIO_LISTA";
                        sqlVA += " *((100 - s.porcentaje_descuento) / 100) *((100 -sd.PORCENTAJE_APLICADOPRECIO) / 100)) as montoVenta,avg(sd.precio_lista)";
                        sqlVA += " from SALIDAS_VENTAS s,SALIDAS_DETALLEVENTAS sd,ALMACENES_VENTAS av,PRESENTACIONES_PRODUCTO pp,clientes cl";
                        sqlVA += " where s.COD_SALIDAVENTA = sd.COD_SALIDAVENTAS and s.COD_ALMACEN_VENTA = av.COD_ALMACEN_VENTA";
                        sqlVA += " and pp.cod_presentacion = sd.COD_PRESENTACION and s.COD_CLIENTE = cl.cod_cliente";
                        sqlVA += " and av.COD_AREA_EMPRESA in(" + p.codareaempresa + ")";
                        sqlVA += " and cl.cod_tipocliente in (1,5,4,6)";
                        sqlVA += " and s.FECHA_SALIDAVENTA>='" + fechaInicioF + " 00:00:00' and s.FECHA_SALIDAVENTA<='" + fechaFinalF + " 23:59:59'";
                        sqlVA += " and pp.cod_presentacion in(" + codPresentacionPadre + ") and s.COD_ESTADO_SALIDAVENTA<>2 and s.COD_TIPOSALIDAVENTAS=3";
                        //System.out.println("ññññññññññññññññññññññññññ:::::::" + sqlVA);
                        Statement stVA = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                        ResultSet rsVA = stVA.executeQuery(sqlVA);
                        double cantidad = 0.0D;
                        double importe = 0.0D;
                        if (rsVA.next()) {
                            cantidad = rsVA.getDouble(1);
                            if (cantidadPresentacionPadre > 0) {
                                cantidad = cantidad / cantidadPresentacionPadre;
                            }
                            importe = rsVA.getDouble(2);
                        }
                        rsVA.close();
                        stVA.close();
                        double precioPromedioA = 0.0D;
                        if (cantidad > 0) {
                            precioPromedioA = importe / cantidad;
                        }
                        p.sumUUVGAnterior = p.sumUUVGAnterior + cantidad;
                        p.sumBSVGAnterior = p.sumBSVGAnterior + importe;
                        p.sumPPVGAnterior = p.sumPPVGAnterior + precioPromedioA;
                        subTotalUU1[j] = subTotalUU1[j] + cantidad;
                        subTotalVV1[j] = subTotalVV1[j] + importe;


                    %>
                    <td align="right" style="border-right:1px solid #000000;border-bottom:1px solid #000000;background-color:#CCC0DA" >
                        <span class="outputText2"><%=form.format(cantidad)%></span>
                    </td>
                    <td align="right" style="border-right:1px solid #000000;border-bottom:1px solid #000000;background-color:#CCC0DA">
                        <span class="outputText2"><%=form.format(importe)%></span>
                    </td>

                    <td align="right" style="border-right:1px solid #000000;border-bottom:1px solid #000000;background-color:#CCC0DA">
                        <span class="outputText2"><%=form.format(precioPromedioA)%></span>
                    </td>


                    <%
                        ////////////////////////////////////////////////////////////////////////////
                        //  CC && VV DE UNA GESTION ANTERIOR
                        ////////////////////////////////////////////////////////////////////////////

                        String sqlVM = "select sum(ROUND(((sd.CANTIDAD_TOTAL*pp.cantidad_presentacion) + isnull(sd.CANTIDAD_UNITARIATOTAL,0)), 2)) as totalUnidades";
                        /*sqlVM += ",sum((sd.CANTIDAD +(sd.CANTIDAD_UNITARIA / pp.cantidad_presentacion)) * sd.PRECIO_LISTA";
                        sqlVM += " *((100 - s.porcentaje_descuento) / 100) *((100 -sd.PORCENTAJE_APLICADOPRECIO) / 100)) as montoVenta";
                         */
                        sqlVM += ",(CASE sd.COD_OFERTA  When 0 Then isnull(sum((isnull(sd.cantidad, 0) +(isnull(" +
                                " sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) * sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100) *((100" +
                                "  - isnull(s.PORCENTAJE_DESCUENTO_PREFERENCIAL, 0)) / 100) *((100 - s.porcentaje_descuento) / 100)), 0)" +
                                "   ELSE isnull(sum((isnull(sd.cantidad, 0) +(isnull( sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) *" +
                                "  sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100)), 0)  END) as montoVenta";

                        sqlVM += " from SALIDAS_VENTAS s,SALIDAS_DETALLEVENTAS sd,ALMACENES_VENTAS av,PRESENTACIONES_PRODUCTO pp,clientes cl";
                        sqlVM += " where s.COD_SALIDAVENTA = sd.COD_SALIDAVENTAS and s.COD_ALMACEN_VENTA = av.COD_ALMACEN_VENTA";
                        sqlVM += " and pp.cod_presentacion = sd.COD_PRESENTACION and s.COD_CLIENTE = cl.cod_cliente";
                        sqlVM += " and av.COD_AREA_EMPRESA in(" + p.codareaempresa + ")";
                        sqlVM += " and cl.cod_tipocliente in (1,5,4,6)";
                        sqlVM += " and s.FECHA_SALIDAVENTA>='" + SQLFecha1 + " 00:00:00' and s.FECHA_SALIDAVENTA<='" + SQLFecha2 + " 23:59:59'";
                        sqlVM += " and pp.cod_presentacion in(" + codPresentacionPadre + ") and s.COD_ESTADO_SALIDAVENTA<>2 and s.COD_TIPOSALIDAVENTAS=3";
                        sqlVM += " group by sd.COD_OFERTA,sd.CANTIDAD";
                        double cantidadV = 0.0D;
                        double importeV = 0.0D;
                        System.out.println("sqlVM--------------------------------:" + sqlVM);
                        Statement stVM = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                        ResultSet rsVM = stVM.executeQuery(sqlVM);
                        /*if (rsVM.next()) {
                        cantidadV = rsVM.getDouble(1);
                        if (cantidadPresentacionPadre > 0) {
                        cantidadV = cantidadV / cantidadPresentacionPadre;
                        }
                        importeV = rsVM.getDouble(2);
                        }*/

                        while (rsVM.next()) {
                            cantidadV = cantidadV + rsVM.getDouble(1);

                            importeV = importeV + rsVM.getDouble(2);
                        }
                        if (cantidadPresentacionPadre > 0) {
                            cantidadV = cantidadV / cantidadPresentacionPadre;
                        }

                        rsVM.close();
                        stVM.close();
                        double precioPromedioV = 0.0D;
                        if (cantidadV > 0) {
                            precioPromedioV = importeV / cantidadV;
                        }



                        p.sumUUVGAnalisis = p.sumUUVGAnalisis + cantidadV;
                        p.sumBSVGAnalisis = p.sumBSVGAnalisis + importeV;
                        p.sumPPVGAnalisis = p.sumPPVGAnalisis + precioPromedioV;
                        subTotalUU2[j] = subTotalUU2[j] + cantidadV;
                        subTotalVV2[j] = subTotalVV2[j] + importeV;

                    %>
                    <td align="right" style="border-right:1px solid #000000;border-bottom:1px solid #000000;background-color:#FDe9d9">
                        <span class="outputText2"><%=form.format(cantidadV)%></span>
                    </td>
                    <td align="right" style="border-right:1px solid #000000;border-bottom:1px solid #000000;background-color:#FDe9d9">
                        <span class="outputText2"><%=form.format(importeV)%></span>
                    </td>

                    <td align="right" style="border-right:1px solid #000000;border-bottom:1px solid #000000;background-color:#FDe9d9">
                        <span class="outputText2"><%=form.format(precioPromedioV)%></span>


                    </td>


                    <%

                        /*String sqlPresupuesto = "select sum(cantidad_unitaria),sum(monto_venta)";
                        sqlPresupuesto += "from presupuesto_ventasperiodo pvp,periodos_ventas pv,presupuesto_ventasgestion pvg where cod_presentacion in (" + codpresentacion + ") and pv.cod_periodo=pvp.cod_periodo";
                        sqlPresupuesto += " and fecha_inicio>='" + SQLFecha1 + "' and fecha_final<='" + SQLFecha2 + "'";
                        sqlPresupuesto += " and pvg.cod_presupuestoventas=pvp.cod_presupuestoventas and cod_area_empresa=" + p.codareaempresa;
                        sqlPresupuesto += " and pvg.nro_versionpresupuestoventas in (select MAX(nro_versionpresupuestoventas) as nroVersionPresupuesto from";
                        sqlPresupuesto += " PRESUPUESTO_VENTASGESTION where cod_area_empresa =" + p.codareaempresa + " and cod_gestion =" + codGestionF + " and cod_lineamkt =" + codLineaMkt + " )";*/

                        String sqlPresupuesto = "select sum(pvm.CANTIDAD_UNITARIA),sum(pvm.CANTIDAD_UNITARIA * pvm.PRECIO_MINIMO)";
                        sqlPresupuesto += " from PRESUPUESTO_VENTASGESTION pv,PRESUPUESTO_VENTASMENSUAL pvm,PRESENTACIONES_PRODUCTO p";
                        sqlPresupuesto += " where pv.COD_PRESUPUESTOVENTAS = pvm.COD_PRESUPUESTOVENTAS and pvm.COD_PRESENTACION=p.cod_presentacion and pv.COD_GESTION =" + codGestionF;
                        sqlPresupuesto += " and pv.COD_AREA_EMPRESA =" + p.codareaempresa + " and pv.COD_LINEAMKT in (1,2) ";
                        //sqlPresupuesto += " and pv.COD_AREA_EMPRESA =" + p.codareaempresa + " and pv.COD_LINEAMKT in (1,2) and pv.NRO_VERSIONPRESUPUESTOVENTAS =" + nroVersionPresuesto;
                        sqlPresupuesto += " and pvm.COD_PRESENTACION in(" + codPresentacionPadre + ") and pvm.cod_periodo in(" + codPeriodo + ")  and cod_mes in (" + mesesArray + ")";

                        //sqlPresupuesto += " and pvm.COD_PRESENTACION in(" + codPresentacionPadre + ") and cod_mes in (" + mesesArray + ")";

                        System.out.println("::::::::::::::::::::::::::::::::::::::::::::::::" + sqlPresupuesto);
                        Statement stPresupuesto = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                        ResultSet rsPresupuesto = stPresupuesto.executeQuery(sqlPresupuesto);
                        double cantidadunitariapresupuesto = 0.0D;
                        double montoventa = 0.0D;
                        double preciopromediopresupuesto = 0.0D;
                        int cantidadPeriodos = 0;
                        if (rsPresupuesto.next()) {
                            cantidadunitariapresupuesto = rsPresupuesto.getDouble(1);
                            montoventa = rsPresupuesto.getDouble(2);
                        }
                        rsPresupuesto.close();
                        stPresupuesto.close();
                        if (cantidadunitariapresupuesto > 0) {
                            preciopromediopresupuesto = montoventa / cantidadunitariapresupuesto;
                        }

                        p.sumPresupuestoUU = p.sumPresupuestoUU + cantidadunitariapresupuesto;
                        p.sumPresupuestoBs = p.sumPresupuestoBs + montoventa;
                        p.sumPresupuestoPP = p.sumPresupuestoPP + preciopromediopresupuesto;
                        p.codlineamkt = codLineaFiltro;

                        subTotalUU3[j] = subTotalUU3[j] + cantidadunitariapresupuesto;
                        subTotalVV3[j] = subTotalVV3[j] + montoventa;
                    %>
                    <td align="right" style="border-right:1px solid #000000;border-bottom:1px solid #000000;background-color:#CCC0DA">
                        <span class="outputText2"><%=form.format(cantidadunitariapresupuesto)%></span>
                    </td>
                    <td align="right" style="border-right:1px solid #000000;border-bottom:1px solid #000000;background-color:#CCC0DA">
                        <span class="outputText2"><%=form.format(montoventa)%></span>
                    </td>
                    <td align="right" style="border-right:1px solid #000000;border-bottom:1px solid #000000;background-color:#CCC0DA">
                        <span class="outputText2"><%=form.format(preciopromediopresupuesto)%></span>
                    </td>

                    <%
                        double cumplimientoUnidad = 0.0D;
                        double cumplimientoBs = 0.0D;
                        if (cantidadunitariapresupuesto > 0) {
                            cumplimientoUnidad = ((cantidadV) / cantidadunitariapresupuesto) * 100;
                        }
                        if (montoventa > 0) {
                            cumplimientoBs = (importeV / montoventa) * 100;
                        }
                    %>
                    <td align="right" style="background-color:#ADD797;border-right:1px solid #000000;border-bottom:1px solid #000000">
                        <span class="outputText2"><%=form.format(cumplimientoUnidad)%>%</span>
                    </td>
                    <td align="right" style="background-color:#ADD797;border-right:1px solid #000000;border-bottom:1px solid #000000">
                        <span class="outputText2"><%=form.format(cumplimientoBs)%>%</span>
                    </td>

                    <%

                        String sqlPonderado = "select isnull(cum.NRO_CUMPLIMENTOVENTASPRODUCTO,0) from CUMPLIMIENTO_VENTASPRODUCTO cum   ";
                        sqlPonderado += " where  " + cumplimientoUnidad + "  between (select c.PORCENTAJE_INICIAL from  CUMPLIMIENTO_VENTAS c where       cum.COD_CUMPLIMENTOVENTAS=c.COD_CUMPLIMENTOVENTAS)";
                        sqlPonderado += " and (select c.PORCENTAJE_FINAL from  CUMPLIMIENTO_VENTAS c where       cum.COD_CUMPLIMENTOVENTAS=c.COD_CUMPLIMENTOVENTAS)";
                        sqlPonderado += "  and cod_presentacion=" + codpresentacion;
                        Statement stPonderado = con.createStatement();
                        ResultSet rsPonderado = stPonderado.executeQuery(sqlPonderado);
                        float ponderado = 0.0f;
                        if (rsPonderado.next()) {
                            ponderado = rsPonderado.getFloat(1);
                        }
                        rsPonderado.close();
                        stPonderado.close();
                        sumPonderados[j] = sumPonderados[j] + ponderado;
                        p.sumPonderadoPP = p.sumPonderadoPP + ponderado;
                    %>
                    <td align="right" style="background-color:#ff6464;border-right:1px solid #000000;border-bottom:1px solid #000000">
                        <span class="outputText2"><%=form.format(ponderado)%>%</span>
                    </td>




                    <%
                        double crecimientoUnidad = 0.0D;
                        double crecimientoImporte = 0.0D;
                        if (cantidad > 0) {
                            crecimientoUnidad = ((cantidadV - cantidad) / cantidad) * 100;
                        }
                        if (importe > 0) {
                            crecimientoImporte = ((importeV - importe) / importe) * 100;
                        }
                    %>
                    <%
                        if (crecimientoImporte < 0) {%>
                    <td align="right" style="background-color:#dbE5F1;border-right:1px solid #000000;border-bottom:1px solid #000000">
                        <span class="outputText2" style="color:red;font-weight:bold"><%=form.format(crecimientoUnidad)%>%</span>
                    </td>
                    <%} else {%>
                    <td align="right" style="background-color:#dbE5F1;border-right:1px solid #000000;border-bottom:1px solid #000000">
                        <span class="outputText2"><%=form.format(crecimientoUnidad)%>%</span>
                    </td>
                    <%}%>
                    <%if (crecimientoImporte < 0) {%>
                    <td align="right" style="background-color:#dbE5F1;border-right:1px solid #000000;border-bottom:1px solid #000000">
                        <span class="outputText2" style="color:red;font-weight:bold"><%=form.format(crecimientoImporte)%>%</span>
                    </td>
                    <%} else {%>
                    <td align="right" style="background-color:#dbE5F1;border-right:1px solid #000000;border-bottom:1px solid #000000">
                        <span class="outputText2" ><%=form.format(crecimientoImporte)%>%</span>
                    </td>
                    <%}%>




                    <%j++;
                    }%>
                </tr>

                <%}%>
                <tr>
                    <td align="right" class="outputText2" style="border-right:1px solid #000000;border-bottom:1px solid #000000;background-color:#FFFF99;border-left:1px solid #000000;color: red;" ><b>TOTAL&nbsp;<%=nombreLineaFiltro%>&nbsp;</b></td>
                    <%
                                        for (int k = 0; k <= subTotalUU1.length - 1; k++) {
                    %>
                    <td align="right" class="outputText2" style="border-right:1px solid #000000;border-bottom:1px solid #000000;background-color:#FFFF99;color: red;" ><b><%=form.format(subTotalUU1[k])%></b></td>
                    <td align="right" class="outputText2" style="border-right:1px solid #000000;border-bottom:1px solid #000000;background-color:#FFFF99;color: red;" ><b><%=form.format(subTotalVV1[k])%></b></td>
                    <%
                        double subTotalPPfiltro1 = 0;
                        if (subTotalUU1[k] > 0) {
                            subTotalPPfiltro1 = subTotalVV1[k] / subTotalUU1[k];
                        }
                    %>
                    <td align="right" class="outputText2" style="border-right:1px solid #000000;border-bottom:1px solid #000000;background-color:#FFFF99;color: red;" ><b><%=form.format(subTotalPPfiltro1)%></b></td>

                    <td align="right" class="outputText2" style="border-right:1px solid #000000;border-bottom:1px solid #000000;background-color:#FFFF99;color: red;" ><b><%=form.format(subTotalUU2[k])%></b></td>
                    <td align="right" class="outputText2" style="border-right:1px solid #000000;border-bottom:1px solid #000000;background-color:#FFFF99;color: red;" ><b><%=form.format(subTotalVV2[k])%></b></td>
                    <%
                        double subTotalPPfiltro2 = 0;
                        if (subTotalUU2[k] > 0) {
                            subTotalPPfiltro2 = subTotalVV2[k] / subTotalUU2[k];
                        }
                    %>
                    <td align="right" class="outputText2" style="border-right:1px solid #000000;border-bottom:1px solid #000000;background-color:#FFFF99;color: red;" ><b><%=form.format(subTotalPPfiltro2)%></b></td>

                    <td align="right" class="outputText2" style="border-right:1px solid #000000;border-bottom:1px solid #000000;background-color:#FFFF99;color: red;" ><b><%=form.format(subTotalUU3[k])%></b></td>
                    <td align="right" class="outputText2" style="border-right:1px solid #000000;border-bottom:1px solid #000000;background-color:#FFFF99;color: red;" ><b><%=form.format(subTotalVV3[k])%></b></td>
                    <%
                        double subTotalPPfiltro3 = 0;
                        if (subTotalUU3[k] > 0) {
                            subTotalPPfiltro3 = subTotalVV3[k] / subTotalUU3[k];
                        }
                    %>
                    <td align="right" class="outputText2" style="border-right:1px solid #000000;border-bottom:1px solid #000000;background-color:#FFFF99;color: red;" ><b><%=form.format(subTotalPPfiltro3)%></b></td>
                    <%
                        double cumplimientoUU1 = 0;
                        double cumplimientoVV1 = 0;
                        if (subTotalUU3[k] > 0) {
                            cumplimientoUU1 = (subTotalUU2[k] / subTotalUU3[k]) * 100;
                        }
                        if (subTotalVV3[k] > 0) {
                            cumplimientoVV1 = (subTotalVV2[k] / subTotalVV3[k]) * 100;
                        }

                        String sql_bimensual = " select t.RANGO_1,t.RANGO_2,t.PORCENTAJE_PREMIO  from ESCALA_PREMIO_BIMENSUAL t where t.COD_TIPO_BIMENSUAL=1 order by t.RANGO_1";
                        Statement st_bimensual = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                        ResultSet rs_bimensual = st_bimensual.executeQuery(sql_bimensual);
                        double porcentaje_calculado = 0;
                        while (rs_bimensual.next()) {
                            int rango_min = rs_bimensual.getInt(1);
                            int rango_max = rs_bimensual.getInt(2);

                            if (redondear(cumplimientoVV1, 0) >= rango_min && redondear(cumplimientoVV1, 0) < rango_max + 1) {
                                porcentaje_calculado = rs_bimensual.getInt(3);
                            }
                        }

                        String sql_insert = " INSERT INTO TIPOS_PREMIO_BIMENSUAL_DETALLE (COD_TIPO_PREMIO,COD_AREA_EMPRESA,COD_LINEA_MKT,PORCENTAJE,PORCENTAJE_CALCULADO,TIPO_PREMIO_BIMENSUAL,PRESUPUESTO,VENTA)";
                        sql_insert += " values (1," + codArea + "";
                        sql_insert += " ," + codLineaFiltro + "";
                        sql_insert += "," + redondear(cumplimientoVV1, 2) + "," + porcentaje_calculado + ",1," + redondear(subTotalVV3[k], 2) + "," + redondear(subTotalVV2[k], 2) + ")";
                        System.out.println("sql_insertar:" + sql_insert);
                        Statement st_insertar = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                        int rs_insertar = st_insertar.executeUpdate(sql_insert);
                        if (ponderados.equals("2")) {
                            sql_bimensual = " select t.RANGO_1,t.RANGO_2,t.PORCENTAJE_PREMIO  from ESCALA_PREMIO_BIMENSUAL t where t.COD_TIPO_BIMENSUAL=2 order by t.RANGO_1";
                            st_bimensual = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            rs_bimensual = st_bimensual.executeQuery(sql_bimensual);
                            porcentaje_calculado = 0;
                            while (rs_bimensual.next()) {
                                int rango_min = rs_bimensual.getInt(1);
                                int rango_max = rs_bimensual.getInt(2);

                                if (redondear(sumPonderados[k], 0) >= rango_min && redondear(sumPonderados[k], 0) < rango_max + 1) {
                                    porcentaje_calculado = rs_bimensual.getInt(3);
                                }
                            }

                            sql_insert = " INSERT INTO TIPOS_PREMIO_BIMENSUAL_DETALLE (COD_TIPO_PREMIO,COD_AREA_EMPRESA,COD_LINEA_MKT,PORCENTAJE,PORCENTAJE_CALCULADO,TIPO_PREMIO_BIMENSUAL,PRESUPUESTO,VENTA)";
                            sql_insert += " values (1," + codArea + "";
                            sql_insert += " ," + codLineaFiltro + "";
                            sql_insert += "," + redondear(sumPonderados[k], 2) + "," + porcentaje_calculado + ",2," + redondear(subTotalUU3[k], 2) + "," + redondear(subTotalUU2[k], 2) + ")";
                            System.out.println("sql_insertar:" + sql_insert);
                            st_insertar = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            rs_insertar = st_insertar.executeUpdate(sql_insert);
                        }
                        if (ponderados.equals("1")) {
                            sql_bimensual = " select t.RANGO_1,t.RANGO_2,t.PORCENTAJE_PREMIO  from ESCALA_PREMIO_BIMENSUAL t where t.COD_TIPO_BIMENSUAL=2 order by t.RANGO_1";
                            st_bimensual = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            rs_bimensual = st_bimensual.executeQuery(sql_bimensual);
                            porcentaje_calculado = 0;
                            while (rs_bimensual.next()) {
                                int rango_min = rs_bimensual.getInt(1);
                                int rango_max = rs_bimensual.getInt(2);

                                if (redondear(cumplimientoUU1, 0) >= rango_min && redondear(cumplimientoUU1, 0) < rango_max + 1) {
                                    porcentaje_calculado = rs_bimensual.getInt(3);
                                }
                            }

                            sql_insert = " INSERT INTO TIPOS_PREMIO_BIMENSUAL_DETALLE (COD_TIPO_PREMIO,COD_AREA_EMPRESA,COD_LINEA_MKT,PORCENTAJE,PORCENTAJE_CALCULADO,TIPO_PREMIO_BIMENSUAL,PRESUPUESTO,VENTA)";
                            sql_insert += " values (1," + codArea + "";
                            sql_insert += " ," + codLineaFiltro + "";
                            sql_insert += "," + redondear(cumplimientoUU1, 2) + "," + porcentaje_calculado + ",2," + redondear(subTotalUU3[k], 2) + "," + redondear(subTotalUU2[k], 2) + ")";
                            System.out.println("sql_insertar:" + sql_insert);
                            st_insertar = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            rs_insertar = st_insertar.executeUpdate(sql_insert);
                        }

                    %>
                    <td align="right" class="outputText2" style="border-right:1px solid #000000;border-bottom:1px solid #000000;background-color:#FFFF99;color: red;" ><b><%=form.format(cumplimientoUU1)%>%</b></td>
                    <td align="right" class="outputText2" style="border-right:1px solid #000000;border-bottom:1px solid #000000;background-color:#FFFF99;color: red;" ><b><%=form.format(cumplimientoVV1)%>%</b></td>
                    <td align="right" class="outputText2" style="border-right:1px solid #000000;border-bottom:1px solid #000000;background-color:#FFFF99;color: red;" ><b><%=form.format(sumPonderados[k])%>%</b></td>








                    <%
                        double crecimientoUU1 = 0;
                        double crecimientoVV1 = 0;
                        if (subTotalUU1[k] > 0) {
                            crecimientoUU1 = ((subTotalUU2[k] - subTotalUU1[k]) / subTotalUU1[k]) * 100;
                        }
                        if (subTotalVV1[k] > 0) {
                            crecimientoVV1 = ((subTotalVV2[k] - subTotalVV1[k]) / subTotalVV1[k]) * 100;
                        }
                    %>
                    <td align="right" class="outputText2" style="border-right:1px solid #000000;border-bottom:1px solid #000000;background-color:#FFFF99;color: red;" ><b><%=form.format(crecimientoUU1)%>%</b></td>
                    <td align="right" class="outputText2" style="border-right:1px solid #000000;border-bottom:1px solid #000000;background-color:#FFFF99;color: red;" ><b><%=form.format(crecimientoVV1)%>%</b></td>
                    <%}%>
                </tr>
                <%
                        rsPresentacion2.close();
                        stPresentacion2.close();
                    }
                %>
                <!--<tr >
                    <td  style="border-right:1px solid #000000;">
                        <span class="outputText2">&nbsp;</span>
                    </td>
                <%  int xxx = 0;
                    for (PresupuestoReportes p : array) {
                %>
                    <td  colspan="2" style="border-right:1px solid #000000;">
                        <span class="outputText2">&nbsp;</span>
                    </td>
                    <td  align="center" >
                        <span class="outputText2" style="font-weight:bold;">10</span>
                    </td>

                    <td  colspan="3" style="border-right:1px solid #000000;">
                        <span class="outputText2">&nbsp;</span>
                    </td>
                    <td  align="center" >
                        <span class="outputText2" style="font-weight:bold;">10</span>
                    </td>
                    <td  colspan="3" style="border-right:1px solid #000000;">
                        <span class="outputText2">&nbsp;</span>
                    </td>
                    <td  align="center" >
                        <span class="outputText2" style="font-weight:bold;">10</span>
                    </td>
                <%}%>
                </tr>-->
                <tr >
                    <td  align="right" style="border-right:1px solid #000000;border-bottom:1px solid #000000;border-left:1px solid #000000;">
                        <span class="outputText2"><b>TOTAL GENERAL&nbsp;&nbsp;</b></span>
                    </td>
                    <%for (PresupuestoReportes p : array) {%>
                    <td  align="right" style="background-color:#CCC0DA;border-right:1px solid #000000;border-bottom:1px solid #000000;">
                        <span class="outputText2" style="font-weight:bold"><%=form.format(p.sumUUVGAnterior)%></span>
                    </td>
                    <td  align="right" style="background-color:#CCC0DA;border-right:1px solid #000000;border-bottom:1px solid #000000;">
                        <span class="outputText2" style="font-weight:bold"><%=form.format(p.sumBSVGAnterior)%></span>
                    </td>
                    <td align="right" style="background-color:#CCC0DA;border-right:1px solid #000000;border-bottom:1px solid #000000;">
                        <!--<span class="outputText2" style="font-weight:bold">form.format(p.sumPPVGAnterior)</span> -->
                        <span class="outputText2" style="font-weight:bold"><%=form.format(p.sumBSVGAnterior / p.sumUUVGAnterior)%></span>
                    </td>
                    <td  align="right" style="border-right:1px solid #000000;border-bottom:1px solid #000000;background-color:#FDe9d9;">
                        <span class="outputText2" style="font-weight:bold"><%=form.format(p.sumUUVGAnalisis)%></span>
                    </td>
                    <td align="right" style="border-right:1px solid #000000;border-bottom:1px solid #000000;background-color:#FDe9d9;">
                        <span class="outputText2" style="font-weight:bold"><%=form.format(p.sumBSVGAnalisis)%></span>
                    </td>
                    <td align="right" style="border-right:1px solid #000000;border-bottom:1px solid #000000;background-color:#FDe9d9;">
                        <!--<span class="outputText2" style="font-weight:bold">form.format(p.sumPPVGAnalisis)</span> -->
                        <span class="outputText2" style="font-weight:bold"><%=form.format(p.sumBSVGAnalisis / p.sumUUVGAnalisis)%></span>
                    </td>
                    <td  align="right" style="background-color:#CCC0DA;border-right:1px solid #000000;border-bottom:1px solid #000000;">
                        <span class="outputText2" style="font-weight:bold"><%=form.format(p.sumPresupuestoUU)%></span>
                    </td>

                    <td align="right" style="background-color:#CCC0DA;border-right:1px solid #000000;border-bottom:1px solid #000000;">
                        <span class="outputText2" style="font-weight:bold"><%=form.format(p.sumPresupuestoBs)%></span>
                    </td>
                    <td align="right" style="background-color:#CCC0DA;border-right:1px solid #000000;border-bottom:1px solid #000000;">
                        <!--<span class="outputText2" style="font-weight:bold">form.format(p.sumPresupuestoPP)</span> -->
                        <span class="outputText2" style="font-weight:bold"><%=form.format(p.sumPresupuestoBs / p.sumPresupuestoUU)%></span>
                    </td>
                    <%
    double cumplimientoUnidad = 0.0D;
    double cumplimientoBs = 0.0D;
    if (p.sumPresupuestoUU > 0) {
        cumplimientoUnidad = ((p.sumUUVGAnalisis) / p.sumPresupuestoUU) * 100;
    }
    if (p.sumPresupuestoBs > 0) {
        cumplimientoBs = (p.sumBSVGAnalisis / p.sumPresupuestoBs) * 100;
    }

    /*String sql_bimensual = " select t.RANGO_1,t.RANGO_2,t.PORCENTAJE_PREMIO  from ESCALA_PREMIO_BIMENSUAL t where t.COD_TIPO_BIMENSUAL=1 order by t.RANGO_1";
    Statement st_bimensual = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
    ResultSet rs_bimensual = st_bimensual.executeQuery(sql_bimensual);
    double porcentaje_calculado = 0;
    while (rs_bimensual.next()) {
    int rango_min = rs_bimensual.getInt(1);
    int rango_max = rs_bimensual.getInt(2);
    if (redondear(cumplimientoUnidad,0) >= rango_min && redondear(cumplimientoUnidad,0) < rango_max+1) {
    porcentaje_calculado = rs_bimensual.getInt(3);
    }
    }

    String sql_insert = " INSERT INTO TIPOS_PREMIO_BIMENSUAL_DETALLE (COD_TIPO_PREMIO,COD_AREA_EMPRESA,COD_LINEA_MKT,PORCENTAJE,PORCENTAJE_CALCULADO,TIPO_PREMIO_BIMENSUAL)";
    sql_insert += " values (1,1000";
    sql_insert += " ," + p.codlineamkt + "";
    sql_insert += "," +redondear(cumplimientoUnidad,2) + "," + porcentaje_calculado + ",1)";
    System.out.println("sql_insertar:" + sql_insert);
    Statement st_insertar = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
    int rs_insertar = st_insertar.executeUpdate(sql_insert);

    sql_bimensual = " select t.RANGO_1,t.RANGO_2,t.PORCENTAJE_PREMIO  from ESCALA_PREMIO_BIMENSUAL t where t.COD_TIPO_BIMENSUAL=2 order by t.RANGO_1";
    st_bimensual = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
    rs_bimensual = st_bimensual.executeQuery(sql_bimensual);
    porcentaje_calculado = 0;
    while (rs_bimensual.next()) {
    int rango_min = rs_bimensual.getInt(1);
    int rango_max = rs_bimensual.getInt(2);
    if (redondear(cumplimientoBs,0) >= rango_min && redondear(cumplimientoBs,0) < rango_max+1) {
    porcentaje_calculado = rs_bimensual.getInt(3);
    }
    }

    sql_insert = " INSERT INTO TIPOS_PREMIO_BIMENSUAL_DETALLE (COD_TIPO_PREMIO,COD_AREA_EMPRESA,COD_LINEA_MKT,PORCENTAJE,PORCENTAJE_CALCULADO,TIPO_PREMIO_BIMENSUAL)";
    sql_insert += " values (1,1000";
    sql_insert += " ," + p.codlineamkt + "";
    sql_insert += "," +redondear(cumplimientoBs,2) + "," + porcentaje_calculado + ",2)";
    System.out.println("sql_insertar:" + sql_insert);
    st_insertar = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
    rs_insertar = st_insertar.executeUpdate(sql_insert);*/
                    %>
                    <td align="right" style="background-color:#ADD797;border-right:1px solid #000000;border-bottom:1px solid #000000">
                        <span class="outputText2" style="font-weight:bold"><%=form.format(cumplimientoUnidad)%>%</span>
                    </td>
                    <td align="right" style="background-color:#ADD797;border-right:1px solid #000000;border-bottom:1px solid #000000">
                        <span class="outputText2" style="font-weight:bold"><%=form.format(cumplimientoBs)%>%</span>
                    </td>

                    <td align="right" style="background-color:#ADD797;border-right:1px solid #000000;border-bottom:1px solid #000000">
                        <span class="outputText2" style="font-weight:bold"><%=form.format(p.sumPonderadoPP)%>%</span>
                    </td>






                    <%
    double crecimientoUnidad = 0.0D;
    double crecimientoImporte = 0.0D;
    if (p.sumUUVGAnterior > 0) {
        crecimientoUnidad = ((p.sumUUVGAnalisis - p.sumUUVGAnterior) / p.sumUUVGAnterior) * 100;
    }
    if (p.sumBSVGAnterior > 0) {
        crecimientoImporte = ((p.sumBSVGAnalisis - p.sumBSVGAnterior) / p.sumBSVGAnterior) * 100;
    }
                    %>
                    <%
    if (crecimientoImporte < 0) {%>
                    <td align="right" style="background-color:#dbE5F1;border-right:1px solid #000000;border-bottom:1px solid #000000">
                        <span class="outputText2" style="color:red;font-weight:bold"><%=form.format(crecimientoUnidad)%>%</span>
                    </td>
                    <%} else {%>
                    <td align="right" style="background-color:#dbE5F1;border-right:1px solid #000000;border-bottom:1px solid #000000">
                        <span class="outputText2" style="font-weight:bold"><%=form.format(crecimientoUnidad)%>%</span>
                    </td>
                    <%}%>
                    <%if (crecimientoImporte < 0) {%>
                    <td align="right" style="background-color:#dbE5F1;border-right:1px solid #000000;border-bottom:1px solid #000000">
                        <span class="outputText2" style="color:red;font-weight:bold"><%=form.format(crecimientoImporte)%>%</span>
                    </td>
                    <%} else {%>
                    <td align="right" style="background-color:#dbE5F1;border-right:1px solid #000000;border-bottom:1px solid #000000">
                        <span class="outputText2" style="font-weight:bold"><%=form.format(crecimientoImporte)%>%</span>
                    </td>
                    <%}%>






                    <%}
                    %>

                </tr>
            </table>
            <%


                } else {%>
            <span class="outputText2">
                <marquee BEHAVIOR=ALTERNATE style="color:red;" > <center><b>Error en el Reporte</b></center></marquee><p>
                <center>El rango de las fechas es incorrecto.</center>
                <center>Intente nuevamente ó comuniquese con:<p>
                <b><span style="color:#8A0886">Laboratorios Cofar S.A. - Departamento de Sistemas</span></b></center>
            </span>
            <%                        }


        }
        try {

            if (ponderados.equals("1")) {
                String sql_area = " select distinct t.COD_LINEA_MKT from TIPOS_PREMIO_BIMENSUAL_DETALLE t where t.COD_TIPO_PREMIO=" + cod_tipo_inc_regional + "";
                System.out.println("sql_area:" + sql_area);
                Statement st_area = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs_area = st_area.executeQuery(sql_area);
                while (rs_area.next()) {
                    String codLineamkt = rs_area.getString(1);
                    String sql_up = " SELECT SUM(T.VENTA)/SUM(T.PRESUPUESTO) FROM TIPOS_PREMIO_BIMENSUAL_DETALLE T WHERE T.COD_TIPO_PREMIO=" + cod_tipo_inc_regional + " ";
                    sql_up += " AND T.TIPO_PREMIO_BIMENSUAL=1 AND T.COD_LINEA_MKT=" + codLineamkt + " AND T.COD_AREA_EMPRESA<>1000";
                    Statement st_up = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs_up = st_up.executeQuery(sql_up);
                    while (rs_up.next()) {
                        double porcentaje = rs_up.getDouble(1);
                        String sql_bimensual = " select t.RANGO_1,t.RANGO_2,t.PORCENTAJE_PREMIO  from ESCALA_PREMIO_BIMENSUAL t where t.COD_TIPO_BIMENSUAL=1 order by t.RANGO_1";
                        Statement st_bimensual = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                        ResultSet rs_bimensual = st_bimensual.executeQuery(sql_bimensual);
                        double porcentaje_calculado = 0;
                        while (rs_bimensual.next()) {
                            int rango_min = rs_bimensual.getInt(1);
                            int rango_max = rs_bimensual.getInt(2);
                            if (redondear(porcentaje * 100, 0) >= rango_min && redondear(porcentaje * 100, 0) < rango_max + 1) {
                                porcentaje_calculado = rs_bimensual.getInt(3);
                            }
                        }
                        String sql_insert = " INSERT INTO TIPOS_PREMIO_BIMENSUAL_DETALLE (COD_TIPO_PREMIO,COD_AREA_EMPRESA,COD_LINEA_MKT,PORCENTAJE,PORCENTAJE_CALCULADO,TIPO_PREMIO_BIMENSUAL)";
                        sql_insert += " values (1,1000";
                        sql_insert += " ," + codLineamkt + "";
                        sql_insert += "," + redondear(porcentaje * 100, 2) + "," + porcentaje_calculado + ",1)";
                        System.out.println("sql_insertar1:" + sql_insert);
                        Statement st_insertar = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                        int rs_insertar = st_insertar.executeUpdate(sql_insert);
                    }

                }
                sql_area = " select distinct t.COD_LINEA_MKT from TIPOS_PREMIO_BIMENSUAL_DETALLE t where t.COD_TIPO_PREMIO=" + cod_tipo_inc_regional + "";
                System.out.println("sql_area:" + sql_area);
                st_area = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                rs_area = st_area.executeQuery(sql_area);
                while (rs_area.next()) {
                    String codLineamkt = rs_area.getString(1);
                    String sql_up = " SELECT SUM(T.VENTA)/SUM(T.PRESUPUESTO) FROM TIPOS_PREMIO_BIMENSUAL_DETALLE T WHERE T.COD_TIPO_PREMIO=" + cod_tipo_inc_regional + " ";
                    sql_up += " AND T.TIPO_PREMIO_BIMENSUAL=2 AND T.COD_LINEA_MKT=" + codLineamkt + " AND T.COD_AREA_EMPRESA<>1000";
                    Statement st_up = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs_up = st_up.executeQuery(sql_up);
                    while (rs_up.next()) {
                        double porcentaje = rs_up.getDouble(1);
                        String sql_bimensual = " select t.RANGO_1,t.RANGO_2,t.PORCENTAJE_PREMIO  from ESCALA_PREMIO_BIMENSUAL t where t.COD_TIPO_BIMENSUAL=2 order by t.RANGO_1";
                        Statement st_bimensual = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                        ResultSet rs_bimensual = st_bimensual.executeQuery(sql_bimensual);
                        double porcentaje_calculado = 0;
                        while (rs_bimensual.next()) {
                            int rango_min = rs_bimensual.getInt(1);
                            int rango_max = rs_bimensual.getInt(2);
                            if (redondear(porcentaje * 100, 0) >= rango_min && redondear(porcentaje * 100, 0) < rango_max + 1) {
                                porcentaje_calculado = rs_bimensual.getInt(3);
                            }
                        }
                        String sql_insert = " INSERT INTO TIPOS_PREMIO_BIMENSUAL_DETALLE (COD_TIPO_PREMIO,COD_AREA_EMPRESA,COD_LINEA_MKT,PORCENTAJE,PORCENTAJE_CALCULADO,TIPO_PREMIO_BIMENSUAL)";
                        sql_insert += " values (1,1000";
                        sql_insert += " ," + codLineamkt + "";
                        sql_insert += "," + redondear(porcentaje * 100, 2) + "," + porcentaje_calculado + ",2)";
                        System.out.println("sql_insertar2:" + sql_insert);
                        Statement st_insertar = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                        int rs_insertar = st_insertar.executeUpdate(sql_insert);
                    }

                }
            }
            if (ponderados.equals("2")) {
              //for (int k1 = 0; k1 < codAreaVector.length; k1++) {
                //String codAreaEmpresa=codAreaVector[k1];
                String sql_area = " select distinct t.COD_LINEA_MKT from TIPOS_PREMIO_BIMENSUAL_DETALLE t where t.COD_TIPO_PREMIO=" + cod_tipo_inc_regional + "";
                System.out.println("sql_area:" + sql_area);
                Statement st_area = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs_area = st_area.executeQuery(sql_area);
                while (rs_area.next()) {
                    String codLineamkt = rs_area.getString(1);
                    /*String sql_up = " SELECT SUM(T.VENTA)/SUM(T.PRESUPUESTO) FROM TIPOS_PREMIO_BIMENSUAL_DETALLE T WHERE T.COD_TIPO_PREMIO=" + cod_tipo_inc_regional + " ";
                    sql_up += " AND T.TIPO_PREMIO_BIMENSUAL=1 AND T.COD_LINEA_MKT=" + codLineamkt + " AND T.COD_AREA_EMPRESA<>1000";
                    Statement st_up = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs_up = st_up.executeQuery(sql_up);
                    while (rs_up.next()) {
                    double porcentaje = rs_up.getDouble(1);*/
                    
                    System.out.println("SQLFecha1:"+SQLFecha1);
                    System.out.println("SQLFecha2:"+SQLFecha2);
                    System.out.println("codLineamkt:"+codLineamkt);
                    double ponderadoXLinea = importeVentaRegional("46,47,49,51,53,54,56,63,48,52,55", SQLFechaIni, SQLFechaFin, codLineamkt, "7", con);

                    String sql_bimensual = " select t.RANGO_1,t.RANGO_2,t.PORCENTAJE_PREMIO  from ESCALA_PREMIO_BIMENSUAL t where t.COD_TIPO_BIMENSUAL=2 order by t.RANGO_1";
                    Statement st_bimensual = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs_bimensual = st_bimensual.executeQuery(sql_bimensual);
                    double porcentaje_calculado = 0;
                    while (rs_bimensual.next()) {
                        int rango_min = rs_bimensual.getInt(1);
                        int rango_max = rs_bimensual.getInt(2);
                        if (redondear(ponderadoXLinea, 2) >= rango_min && redondear(ponderadoXLinea, 2) < rango_max + 1) {
                            porcentaje_calculado = rs_bimensual.getInt(3);
                        }
                    }
                    String sql_insert = " INSERT INTO TIPOS_PREMIO_BIMENSUAL_DETALLE (COD_TIPO_PREMIO,COD_AREA_EMPRESA,COD_LINEA_MKT,PORCENTAJE,PORCENTAJE_CALCULADO,TIPO_PREMIO_BIMENSUAL)";
                    sql_insert += " values (1,1000";
                    sql_insert += " ," + codLineamkt + "";
                    sql_insert += "," + redondear(ponderadoXLinea, 0) + "," + porcentaje_calculado + ",2)";
                    System.out.println("sql_insertar1:" + sql_insert);
                    Statement st_insertar = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    int rs_insertar = st_insertar.executeUpdate(sql_insert);
                //}

                }
                sql_area = " select distinct t.COD_LINEA_MKT from TIPOS_PREMIO_BIMENSUAL_DETALLE t where t.COD_TIPO_PREMIO=" + cod_tipo_inc_regional + "";
                System.out.println("sql_area:" + sql_area);
                st_area = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                rs_area = st_area.executeQuery(sql_area);
                while (rs_area.next()) {
                    String codLineamkt = rs_area.getString(1);
                    String sql_up = " SELECT SUM(T.VENTA)/SUM(T.PRESUPUESTO) FROM TIPOS_PREMIO_BIMENSUAL_DETALLE T WHERE T.COD_TIPO_PREMIO=" + cod_tipo_inc_regional + " ";
                    sql_up += " AND T.TIPO_PREMIO_BIMENSUAL=1 AND T.COD_LINEA_MKT=" + codLineamkt + " AND T.COD_AREA_EMPRESA<>1000";
                    Statement st_up = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet rs_up = st_up.executeQuery(sql_up);
                    while (rs_up.next()) {
                        double porcentaje = rs_up.getDouble(1);
                        String sql_bimensual = " select t.RANGO_1,t.RANGO_2,t.PORCENTAJE_PREMIO  from ESCALA_PREMIO_BIMENSUAL t where t.COD_TIPO_BIMENSUAL=1 order by t.RANGO_1";
                        Statement st_bimensual = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                        ResultSet rs_bimensual = st_bimensual.executeQuery(sql_bimensual);
                        double porcentaje_calculado = 0;
                        while (rs_bimensual.next()) {
                            int rango_min = rs_bimensual.getInt(1);
                            int rango_max = rs_bimensual.getInt(2);
                            if (redondear(porcentaje * 100, 0) >= rango_min && redondear(porcentaje * 100, 0) < rango_max + 1) {
                                porcentaje_calculado = rs_bimensual.getInt(3);
                            }
                        }
                        String sql_insert = " INSERT INTO TIPOS_PREMIO_BIMENSUAL_DETALLE (COD_TIPO_PREMIO,COD_AREA_EMPRESA,COD_LINEA_MKT,PORCENTAJE,PORCENTAJE_CALCULADO,TIPO_PREMIO_BIMENSUAL)";
                        sql_insert += " values (1,1000";
                        sql_insert += " ," + codLineamkt + "";
                        sql_insert += "," + redondear(porcentaje * 100, 2) + "," + porcentaje_calculado + ",1)";
                        System.out.println("sql_insertar2:" + sql_insert);
                        Statement st_insertar = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                        int rs_insertar = st_insertar.executeUpdate(sql_insert);
                    }

                }
              // }
            }
            //Statement st_delete1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            //int rs_delete1 = st_delete1.executeUpdate("delete from TIPOS_PREMIO_BIMENSUAL_CARGO ");
            String sql_calculo = " SELECT C.COD_CARGO_LINEA_PREMIO,c.COD_CARGO,CA.DESCRIPCION_CARGO,c.NOMBRE_CARGO_LINEA_PREMIO,C.COD_LINEA_COMISION FROM CARGOS_LINEAS_PREMIOS_BIMENSUAL C,CARGOS CA WHERE CA.CODIGO_CARGO=C.COD_CARGO and c.COD_ESTADO_REGISTRO=1";
            System.out.println("sql_calculo:" + sql_calculo);
            Statement st_calculo = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            ResultSet rs_calculo = st_calculo.executeQuery(sql_calculo);
            while (rs_calculo.next()) {
                String codCargoLinea = rs_calculo.getString(1);
                String codCargo = rs_calculo.getString(2);
                String nomCargo = rs_calculo.getString(3);
                String nomLineaCargo = rs_calculo.getString(4);
                String codLineaComision = rs_calculo.getString(5);
                String sql_c = " SELECT T.COD_AREA_EMPRESA, T.COD_LINEA_MKT,T.COD_TIPO_PREMIO,T.PORCENTAJE_CALCULADO,T.PORCENTAJE,ae.NOMBRE_AREA_EMPRESA,l.NOMBRE_LINEAMKT FROM TIPOS_PREMIO_BIMENSUAL_DETALLE T,AREAS_EMPRESA ae,LINEAS_MKT l ";
                sql_c += " WHERE  t.COD_LINEA_MKT=l.COD_LINEAMKT and T.TIPO_PREMIO_BIMENSUAL=2 and ae.COD_AREA_EMPRESA=t.COD_AREA_EMPRESA AND  T.COD_AREA_EMPRESA IN (";
                sql_c += " SELECT C.COD_AREA_EMPRESA FROM CARGOS_LINEAS_PREMIOS_BIMENSUAL_AGENCIAS C WHERE C.COD_CARGO_LINEA=" + codCargoLinea + ")";
                System.out.println("sql_c:" + sql_c);
                Statement st_c = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rs_c = st_c.executeQuery(sql_c);
                while (rs_c.next()) {
                    String codAreaEmpresa = rs_c.getString(1);
                    String codLineaMkt = rs_c.getString(2);
                    String codTipoPremio = rs_c.getString(3);
                    double porcentaje_calculado = rs_c.getDouble(4);

                    double porcentaje = rs_c.getDouble(5);
                    porcentaje = redondear(porcentaje, 0);
                    String nomAreaEmpresa = rs_c.getString(6);
                    String nomLinea = rs_c.getString(7);
            %>
            <%--tr>
                    <td><%=nomLineaCargo%></td>
                    <td><%=nomCargo%></td>
                    <td><%=nomAreaEmpresa%></td>
                    <td><%=nomLinea%></td>
                    <td><%=porcentaje%></td>
                    <td><%=porcentaje_calculado%></td--%>
            <%

                                String sql_linea = " select c.MONTO_PREMIO from CARGOS_LINEAS_PREMIOS_BIMENSUAL_DETALLE c where c.COD_CARGO_LINEA=" + codCargoLinea + " and c.COD_LINEA_MKT=" + codLineaMkt + "";
                                System.out.println("sql_linea:" + sql_linea);
                                Statement st_linea = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                ResultSet rs_linea = st_linea.executeQuery(sql_linea);
                                while (rs_linea.next()) {
                                    double monto = rs_linea.getDouble(1);
                                    if (codLineaMkt.equals("4") || codLineaMkt.equals("6") || codLineaMkt.equals("7")) {
                                        monto = 0.3 * monto * porcentaje_calculado / 100;
                                    } else {
                                        monto = 0.7 * monto * porcentaje_calculado / 100;
                                    }
            %>
            <td><%//=monto%></td>

            <%
                                    String sql_insert_linea = "insert into TIPOS_PREMIO_BIMENSUAL_CARGO (COD_TIPO_PREMIO,COD_AREA_EMPRESA,COD_CARGO,COD_LINEA_MKT,MONTO_CUALITATIVO,MONTO_CUANTITATIVO,TIPO_PREMIO_BIMENSUAL)";
                                    sql_insert_linea += " values(" + cod_tipo_inc_regional + "," + codAreaEmpresa + "," + codCargo + "," + codLineaMkt + ",0," + monto + "," + codLineaComision + ")";
                                    System.out.println("sql_insert_linea:" + sql_insert_linea);
                                    Statement st_insertar = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                    int rs_insertar = st_insertar.executeUpdate(sql_insert_linea);
                                }

                            }
            %>
            </tr>
            <%
                        }
            %>
            <%--/table>
<br><br><br>
            <table border="1" class="outputText2" align="center">
                <tr bgcolor="#cccccc">
                    <th>Nombre Categoria Premio</th>
                    <th>Cargo</th>
                    <th>Area Empresa</th>
                    <th>Linea</th>
                    <th>Porcentaje</th>
                    <th>Cuantitativo</th>
                    <th>Monto</th>
                </tr--%>
            <%




                        sql_calculo = " SELECT C.COD_CARGO_LINEA_PREMIO,c.COD_CARGO,CA.DESCRIPCION_CARGO,c.NOMBRE_CARGO_LINEA_PREMIO,C.COD_LINEA_COMISION FROM CARGOS_LINEAS_PREMIOS_BIMENSUAL C,CARGOS CA WHERE CA.CODIGO_CARGO=C.COD_CARGO and c.COD_ESTADO_REGISTRO=1";
                        System.out.println("sql_calculo:" + sql_calculo);
                        st_calculo = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

                        rs_calculo = st_calculo.executeQuery(sql_calculo);
                        while (rs_calculo.next()) {
                            String codCargoLinea = rs_calculo.getString(1);
                            String codCargo = rs_calculo.getString(2);
                            String nomCargo = rs_calculo.getString(3);
                            String nomLineaCargo = rs_calculo.getString(4);
                            String codLineaComision = rs_calculo.getString(5);
                            String sql_c = " SELECT T.COD_AREA_EMPRESA, T.COD_LINEA_MKT,T.COD_TIPO_PREMIO,T.PORCENTAJE_CALCULADO,T.PORCENTAJE,ae.NOMBRE_AREA_EMPRESA,l.NOMBRE_LINEAMKT FROM TIPOS_PREMIO_BIMENSUAL_DETALLE T,AREAS_EMPRESA ae,LINEAS_MKT l ";
                            sql_c += " WHERE  t.COD_LINEA_MKT=l.COD_LINEAMKT and T.TIPO_PREMIO_BIMENSUAL=1 and ae.COD_AREA_EMPRESA=t.COD_AREA_EMPRESA AND  T.COD_AREA_EMPRESA IN (";
                            sql_c += " SELECT C.COD_AREA_EMPRESA FROM CARGOS_LINEAS_PREMIOS_BIMENSUAL_AGENCIAS C WHERE C.COD_CARGO_LINEA=" + codCargoLinea + ")";
                            System.out.println("sql_c:" + sql_c);
                            Statement st_c = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                            ResultSet rs_c = st_c.executeQuery(sql_c);
                            while (rs_c.next()) {
                                String codAreaEmpresa = rs_c.getString(1);
                                String codLineaMkt = rs_c.getString(2);
                                String codTipoPremio = rs_c.getString(3);
                                double porcentaje_calculado = rs_c.getDouble(4);
                                double porcentaje = rs_c.getDouble(5);
                                porcentaje = redondear(porcentaje, 0);
                                String nomAreaEmpresa = rs_c.getString(6);
                                String nomLinea = rs_c.getString(7);
            %>
            <%--tr>
                    <td><%=nomLineaCargo%></td>
                    <td><%=nomCargo%></td>
                    <td><%=nomAreaEmpresa%></td>
                    <td><%=nomLinea%></td>
                    <td><%=porcentaje%></td>
                    <td><%=porcentaje_calculado%></td--%>
            <%

                                            String sql_linea = " select c.MONTO_PREMIO from CARGOS_LINEAS_PREMIOS_BIMENSUAL_DETALLE c where c.COD_CARGO_LINEA=" + codCargoLinea + " and c.COD_LINEA_MKT=" + codLineaMkt + "";
                                            System.out.println("sql_linea:" + sql_linea);
                                            Statement st_linea = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                            ResultSet rs_linea = st_linea.executeQuery(sql_linea);
                                            while (rs_linea.next()) {
                                                double monto = rs_linea.getDouble(1);
                                                if (codLineaMkt.equals("4") || codLineaMkt.equals("6") || codLineaMkt.equals("7")) {
                                                    monto = 0.7 * monto * porcentaje_calculado / 100;
                                                } else {
                                                    monto = 0.3 * monto * porcentaje_calculado / 100;
                                                }


            %>
            <td><%//=monto%></td>

            <%
                                                /*String sql_insert_linea = "insert into TIPOS_PREMIO_BIMENSUAL_CARGO (COD_TIPO_PREMIO,COD_AREA_EMPRESA,COD_CARGO,COD_LINEA_MKT,MONTO_CUALITATIVO,MONTO_CUANTITATIVO,TIPO_PREMIO_BIMENSUAL)";
                                                sql_insert_linea += " values(1," + codAreaEmpresa + "," + codCargo + "," + codLineaMkt + "," + monto + ",0,1)";
                                                System.out.println("sql_insert_linea:" + sql_insert_linea);
                                                Statement st_insertar = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                                int rs_insertar = st_insertar.executeUpdate(sql_insert_linea);*/


                                                String sql_insert_linea = "update TIPOS_PREMIO_BIMENSUAL_CARGO  set  MONTO_CUALITATIVO = " + monto + "";
                                                sql_insert_linea += " where COD_TIPO_PREMIO=" + cod_tipo_inc_regional + " and  cod_area_empresa=" + codAreaEmpresa + " and cod_cargo= " + codCargo + " and cod_linea_mkt=" + codLineaMkt + " and TIPO_PREMIO_BIMENSUAL=" + codLineaComision + "";
                                                System.out.println("sql_udpadte_linea:" + sql_insert_linea);
                                                Statement st_insertar = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                                int rs_insertar = st_insertar.executeUpdate(sql_insert_linea);
                                            }

                                        }


            %>
            </tr>
            <%
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
            %>
            <%--/table--%>
            <p>LOS DATOS SE CALCULARON CORRECTAMENTE.....</p>



            %>
        </form>
    </body>
</html>
