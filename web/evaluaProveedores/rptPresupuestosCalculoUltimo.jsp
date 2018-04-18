package evaluaProveedores;

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
<%! Connection con = null;%>


    <%!
    public double redondear(double numero, int decimales) {
        return Math.round(numero * Math.pow(10, decimales)) / Math.pow(10, decimales);
    }
    %>
<%!
    public double importeVenta(String codareaempresa, String fecha1, String fecha2, String codlineas, String codgestion, Connection con) {
        double cantidadVenta = 0.0d;
        double importeVenta = 0.0d;
        double sumasponderados = 0;
        try {


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


                sqlVM = "select sum(ROUND(((  sd.CANTIDAD_UNITARIATOTAL ) +isnull(sd.CANTIDAD_TOTAL* pp.cantidad_presentacion, 0)), 2) /" + cantidad_presentacion_padre + " ) as totalUnidades2";
                /*sqlVM += ",sum((sd.CANTIDAD +(sd.CANTIDAD_UNITARIA / pp.cantidad_presentacion)) * sd.PRECIO_LISTA";
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
                sqlVM += " group by sd.cod_oferta";

                System.out.println("VENTA:" + sqlVM);
                Statement stVM = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rsVM = stVM.executeQuery(sqlVM);

                /*if (rsVM.next()) {
                    cantidadVenta = rsVM.getDouble(1);
                    importeVenta = rsVM.getDouble(2);

                }*/
                double auxAux=0;
                while (rsVM.next()) {
                    auxAux=+auxAux + rsVM.getDouble(1);
                    importeVenta =importeVenta + rsVM.getDouble(2);
                }
                cantidadVenta =auxAux;
                System.out.println("importeVenta:"+importeVenta);
                System.out.println("cantidadVenta:"+cantidadVenta);
                System.out.println("cantidadVenta/importeVenta:"+cantidadVenta/importeVenta);


                rsVM.close();
                stVM.close();
                String mesesData = "";

                List<MonthInterval> m = Util.getMonths(fecha1, fecha2);
                for (MonthInterval mes : m) {

                    mesesData += mes.getEndDate().split("-")[1] + ",";

                }
                mesesData = mesesData.substring(0, mesesData.length() - 1);

                String sqlPresupuesto = "select sum(   (pvm.CANTIDAD_UNITARIA *p.cantidad_presentacion)/" + cantidad_presentacion_padre + "  ),sum(pvm.CANTIDAD_UNITARIA * pvm.PRECIO_MINIMO)";
                sqlPresupuesto += " from PRESUPUESTO_VENTASGESTION pv,PRESUPUESTO_VENTASMENSUAL pvm,PRESENTACIONES_PRODUCTO p";
                sqlPresupuesto += " where pv.COD_PRESUPUESTOVENTAS = pvm.COD_PRESUPUESTOVENTAS and pvm.COD_PRESENTACION=p.cod_presentacion and pv.COD_GESTION =" + codgestion;
                sqlPresupuesto += " and pv.COD_AREA_EMPRESA =" + codareaempresa + " and pv.COD_LINEAMKT in (1,2) ";
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


            }










        } catch (SQLException e) {
            e.printStackTrace();

        }
        return sumasponderados;

    }%>






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
                while (rsVM.next()) {
                    cantidadVenta =cantidadVenta + rsVM.getDouble(1);
                    importeVenta =importeVenta + rsVM.getDouble(2);

                }
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




<%! class Calculo {

        double importe = 0.0d;
        double presupuesto = 0.0d;
        int codlineamkt=0;
    }

%>



<%! class ReporteAgencias {

        public String nombreAgencia = "";
        public String codAgencia = "";
        public double cantidadTotal = 0.0d;
        public double importeNacional = 0.0d;
        public List<ReporteLineas> reporteLineas = new ArrayList<ReporteLineas>();
        public List<double[]> totalesNacionalRegionales = new ArrayList<double[]>();
        public List<Calculo[]> calculoNacional = new ArrayList<Calculo[]>();
    }%>





<%! class ReporteLineas {

        public String codLineaMkt = "";
        public String nombreLineaMkt = "";
        public String codLineaVenta = "";
        public String nombreLineaVenta = "";
        public String color = "";
        public double montoVenta = 0.0d;
        public double cantidadVenta = 0.0d;
        public double montoVentaLinea = 0.0d;
        public double cantidadVentaLinea = 0.0d;
        public double montoVentaLineaTotal = 0.0d;
        public double cantidadVentaLineaTotal = 0.0d;
        public double montoPresupuesto = 0.0d;
        public double cantidadPresupuesto = 0.0d;
        public double montoPresupuestoLinea = 0.0d;
        public double cantidadPresupuestoLinea = 0.0d;
        public double montoPresupuestoLineaTotal = 0.0d;
        public double cantidadPresupuestoLineaTotal = 0.0d;
        public double cumplimientoCantidad = 0;
        public double cumplimientoCantidadLinea = 0.0d;
        public double cumplimientoCantidadTotal = 0.0d;
        public List<Calculo> calculoTotal = new ArrayList<Calculo>();
    }
%>

<html>
    <head>
        <title>Cálculo Premio Bimensual</title>
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
        String codigoLinea = request.getParameter("codLinea");
        //String nombreLineaVenta = request.getParameter("nombreLinea");
        String codGestionF = "";
        String codPeriodo = "";




        String valuesx[] = fechaInicio.split("/");
        String valuesx2[] = fechaFinal.split("/");
        String SQLFecha1 = valuesx[2] + "-" + valuesx[1] + "-" + valuesx[0];
        String SQLFecha2 = valuesx2[2] + "-" + valuesx2[1] + "-" + valuesx2[0];
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


        //if (sw == 1) {
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
        //System.out.println("mesesArray................:" + mesesArray);
        String sql_001 = "select DISTINCT(p.COD_PERIODO) from PERIODOS_VENTAS p,PERIODOS_DETALLEMESES pd";
        sql_001 += " where p.COD_PERIODO = pd.COD_PERIODO and p.COD_GESTION =" + codGestionF + " and pd.COD_MESES in (" + mesesArray + ")";
        System.out.println("sql_001......:" + sql_001);
        Statement st_001 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rs_001 = st_001.executeQuery(sql_001);
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

        List<ReporteAgencias> agencias = new ArrayList<ReporteAgencias>();
        Statement stAgencias = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        String sqlAgencias = "select cod_area_empresa,nombre_area_empresa ";
        sqlAgencias += " from areas_empresa ae  ";
        sqlAgencias += " where ";
        sqlAgencias += " cod_area_empresa in(" + codArea + ")";
        ResultSet rsAgencias = stAgencias.executeQuery(sqlAgencias);
        while (rsAgencias.next()) {
            String codareaempresa = rsAgencias.getString(1);
            String nombreareaempresa = rsAgencias.getString(2);
            ReporteAgencias r1 = new ReporteAgencias();
            r1.codAgencia = codareaempresa;
            r1.nombreAgencia = nombreareaempresa;
            agencias.add(r1);
        }




        // size = size + (array.size() * 50);
                                    /*String sql_01 = "select cod_gestion from GESTIONES where '" + SQLFecha1 + "'>=fecha_ini  and '" + SQLFecha2 + "'<=fecha_fin";
        Statement st_01 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rs_01 = st_01.executeQuery(sql_01);
        String codGestionF = "0";
        if (rs_01.next()) {
        codGestionF = rs_01.getString(1);
        }*/

        /*String sql_03 = "select l.COD_LINEAMKT from LINEAS_MKT l where l.COD_LINEAMKT in (" + codLineaVenta + ")";
        Statement st_03 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rs_03 = st_03.executeQuery(sql_03);*/

        //String codLineaMKT = "";
        //codLineaMKT = codLineaVenta;

        /*String sql_p="select p.COD_PERIODO from PERIODOS_VENTAS p where p.FECHA_INICIO>='"+SQLFecha1+"' and p.FECHA_FINAL<='"+SQLFecha2+"'";
        Statement st_p = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rs_p = st_p.executeQuery(sql_p);
        if(rs_p.next()){
        codPeriodo=rs_p.getString(1);
        }*/
        // System.out.println("codPeriodo....:" + codPeriodo);

        String sqlLineasVentas = "select COD_LINEAVENTA,NOMBRE_LINEAVENTA FROM LINEAS_VENTAS  k where k.COD_LINEAVENTA in(select a.COD_LINEAVENTA from  LINEAS_VENTA_MKT a where a.COD_LINEAMKT in(" + codigoLinea + "))";
        Statement stLineasVentas = con.createStatement();
        ResultSet rsLineas = stLineasVentas.executeQuery(sqlLineasVentas);
        List<ReporteLineas> lineas2 = new ArrayList<ReporteLineas>();
        //while(rsLineas.next()){
        // String codLineaVenta=rsLineas.getString(1);
        //String nombreLineaVenta=rsLineas.getString(2);
        //String sqlLineasMKT="select COD_LINEAMKT,NOMBRE_LINEAMKT from LINEAS_MKT where COD_LINEAMKT in(select COD_LINEAMKT from lineas_venta_mkt where COD_LINEAVENTA="+codLineaVenta+") and COD_LINEAMKT in("+codigoLinea+")";
        String sqlLineasMKT = "select COD_LINEAMKT,NOMBRE_LINEAMKT from LINEAS_MKT where COD_LINEAMKT in(" + codigoLinea + ")";
        Statement stLineasMKT = con.createStatement();
        ResultSet rsLineasMKT = stLineasMKT.executeQuery(sqlLineasMKT);
        int index = 0;
        while (rsLineasMKT.next()) {
            String codLineaMKT = rsLineasMKT.getString(1);
            String nombreLineaMKT = rsLineasMKT.getString(2);
            ReporteLineas r = new ReporteLineas();
            r.codLineaMkt = codLineaMKT;
            // r.codLineaVenta=codLineaVenta;
            r.nombreLineaMkt = nombreLineaMKT;
            // r.nombreLineaVenta=nombreLineaVenta;
            String color = "";
            if (index % 2 == 0) {
                color = "background-color:#c5d9f1";
            } else {
                color = "background-color:#FFFF99";
            }
            index++;

            r.color = color;
            lineas2.add(r);
        }
        /* rsLineasMKT.close();
        ReporteLineas r=new ReporteLineas();
        r.codLineaMkt="0";
        r.codLineaVenta=codLineaVenta;
        r.nombreLineaMkt="0";
        r.nombreLineaVenta=nombreLineaVenta;
        r.color="background-color:#ff6464";
        lineas2.add(r);*/
        //}





        int size = 0;
        for (ReporteAgencias r1 : agencias) {
            List<ReporteLineas> l = new ArrayList<ReporteLineas>();
            for (ReporteLineas v : lineas2) {
                ReporteLineas r = new ReporteLineas();
                r.codLineaMkt = v.codLineaMkt;
                //r.codLineaVenta=v.codLineaVenta;
                r.nombreLineaMkt = v.nombreLineaMkt;
                //r.nombreLineaVenta=v.nombreLineaVenta;
                r.color = v.color;
                l.add(r);
            }
            r1.reporteLineas = l;
            size = r1.reporteLineas.size();
        }%>
            <table align="center" width="90%" >
                <tr >
                    <td colspan="3" align="center" >
                        <h4>Cálculo Premio Bimensual</h4>
                    </td>
                </tr>
                <tr>


                    <td width="25%">
                        <table border="0" class="outputText2" width="100%" >
                            <tr>
                                <td colspan="2" align="right"><b>Fecha Inicio&nbsp;::&nbsp;</b><%=fechaInicio%><br><b>Fecha &nbsp;Final&nbsp;::&nbsp;</b><%=fechaFinal%></td>
                            </tr>
                            <tr>

                            </tr>

                        </table>
                    </td>
                </tr>


            </table>



            <table  align="center"  width="<%=(lineas2.size() * 10) + 15%>%" cellpadding="0" cellspacing="0">

                <tr>
                    <td  colspan="<%=lineas2.size() + 2%>" align="center" style="background-color:#ADD797;border-bottom:1px solid #000000;border-top:1px solid #000000;border-right:1px solid #000000;">
                        <span class="outputText2" style="font-weight:bold;">&nbsp;CUMPLIMIENTO CUANTITATIVO DE PRESUPUESTO</span>
                    </td>
                </tr>


                <tr>
                    <td   align="center" style="background-color:#ADD797;border-bottom:1px solid #000000;border-top:1px solid #000000;border-right:1px solid #000000;">
                        <span class="outputText2" style="font-weight:bold;">&nbsp;RG</span>
                    </td>
                    <% for (ReporteLineas v : lineas2) {%>
                    <% if (v.codLineaMkt.equals("0")) {%>
                    <!--<td   align="center" style="<%=v.color%>;border-bottom:1px solid #000000;border-top:1px solid #000000;border-right:1px solid #000000;">
                    <span class="outputText2" style="font-weight:bold;"><%=v.nombreLineaVenta%></span>
                    </td>-->
                    <%} else {%>
                    <td   align="center" style="<%=v.color%>;border-bottom:1px solid #000000;border-top:1px solid #000000;border-right:1px solid #000000;">
                        <span class="outputText2" style="font-weight:bold;"><%=v.nombreLineaMkt%></span>
                    </td>
                    <%}%>
                    <%}%>
                    <td   align="right" style="background-color:#ADD797;border-bottom:1px solid #000000;border-top:1px solid #000000;border-right:1px solid #000000;">
                        <span class="outputText2" style="font-weight:bold">TOTAL</span>
                    </td>

                </tr>


                <%
        Statement st_delete = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        int rs_delete = st_delete.executeUpdate("delete from TIPOS_PREMIO_BIMENSUAL_DETALLE ");

        for (ReporteAgencias r : agencias) {
            double importeVentaLinea = 0.0d;
            double cantidadVentaLinea = 0.0d;
            double importePresupuestoLinea = 0.0d;
            double cantidadPresupuestoLinea = 0.0d;
                %>
                <tr>

                    <td   align="LEFT" style="background-color:#ADD797;border-bottom:1px solid #000000;border-top:1px solid #000000;border-right:1px solid #000000;">
                        <span class="outputText2">&nbsp;<%=r.nombreAgencia%></span>
                    </td>
                    <%

                    double cumplimientoCantidadTotal = 0.0d;
                    double cumplimientoImporteTotal = 0.0d;
                    double cumplimientoCantidadTotalPresupuesto = 0.0d;
                    double cumplimientoImporteTotalPresupuesto = 0.0d;

                    double lineasTotalesNacion[] = new double[r.reporteLineas.size()];

                    Calculo calculo[] = new Calculo[r.reporteLineas.size()];

                    int k = 0;
                    for (ReporteLineas v : r.reporteLineas) {

                    %>

                    <%
                                                            if (v.codLineaMkt.equals("0")) {
                                                                double cumplimientoCantidad = 0;
                                                                double cumplimientoVenta = 0.0d;
                                                                if (cantidadPresupuestoLinea > 0.0d) {
                                                                    cumplimientoCantidad = (cantidadVentaLinea / cantidadPresupuestoLinea) * 100.0d;
                                                                }
                                                                if (importePresupuestoLinea > 0.0d) {
                                                                    cumplimientoVenta = (importeVentaLinea / importePresupuestoLinea) * 100.0d;
                                                                }
                                                                cumplimientoCantidadTotal = cumplimientoCantidadTotal + cantidadVentaLinea;
                                                                cumplimientoImporteTotal = cumplimientoImporteTotal + importeVentaLinea;
                                                                cumplimientoCantidadTotalPresupuesto = cumplimientoCantidadTotalPresupuesto + cantidadPresupuestoLinea;
                                                                cumplimientoImporteTotalPresupuesto = cumplimientoImporteTotalPresupuesto + importePresupuestoLinea;
                                                                v.cumplimientoCantidad = cumplimientoCantidad;
                                                                r.importeNacional = r.importeNacional + cumplimientoVenta;

                    %>
                    <!--<td   align="right" style="<%=v.color%>;border-bottom:1px solid #000000;border-top:1px solid #000000;border-right:1px solid #000000;">
                    <span class="outputText2" >xx<%=form.format(cumplimientoVenta)%>%</span>
                    </td>-->
                    <% } else {


                                                                    String sql_05 = "select max(nro_versionpresupuestoventas) from PRESUPUESTO_VENTASGESTION where cod_area_empresa =" + r.codAgencia;
                                                                    sql_05 += " and cod_gestion =" + codGestionF + " and cod_lineamkt in (1,2) and cod_periodo in(" + codPeriodo + ")";
                                                                    Statement st_05 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                                                    ResultSet rs_05 = st_05.executeQuery(sql_05);
                                                                    int nroVersionPresuesto = 0;
                                                                    if (rs_05.next()) {
                                                                        nroVersionPresuesto = rs_05.getInt(1);
                                                                    }

                                                                    String sqlProductosPresu = " select cod_presentacion from PRODUCTOS_PRESUPUESTAR where cod_presentacionpadre in(  ";
                                                                    sqlProductosPresu += " select p.cod_presentacion from PRODUCTOS_PRESUPUESTAR p,PRESENTACIONES_PRODUCTO pp ";
                                                                    sqlProductosPresu += " where p.COD_PRESENTACION=pp.cod_presentacion and p.cod_gestion =" + codGestionF;
                                                                    sqlProductosPresu += " and p.cod_lineamkt in (" + v.codLineaMkt + ") and p.cod_estado = 1) group by cod_presentacion ";
                                                                    Statement stProductosPresu = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                                                    ResultSet rsProductosPresu = stProductosPresu.executeQuery(sqlProductosPresu);
                                                                    double cantidadPresupuesto = 0.0d;
                                                                    double importePresupuesto = 0.0d;


                                                                    double cantidadVenta = 0.0d;
                                                                    double importeVenta = 0.0d;

                                                                    while (rsProductosPresu.next()) {
                                                                        String codPresentacionPro = rsProductosPresu.getString(1);

                                                                        String sql_01 = "select cantidad_presentacion from PRESENTACIONES_PRODUCTO where cod_presentacion=" + codPresentacionPro + " ";
                                                                        Statement st_01 = con.createStatement();
                                                                        ResultSet rs_01 = st_01.executeQuery(sql_01);
                                                                        int cantidad_presentacion_padre = 0;
                                                                        while (rs_01.next()) {
                                                                            cantidad_presentacion_padre = rs_01.getInt(1);
                                                                        }
                                                                       



                                                                        String sqlVM = "select sum(ROUND(((  sd.CANTIDAD_UNITARIATOTAL ) +isnull(sd.CANTIDAD_TOTAL* pp.cantidad_presentacion, 0)), 2) /" + cantidad_presentacion_padre + " ) as totalUnidades";
                                                                        /*sqlVM += ",sum((sd.CANTIDAD +(sd.CANTIDAD_UNITARIA / pp.cantidad_presentacion)) * sd.PRECIO_LISTA";
                                                                        sqlVM += " *((100 - s.porcentaje_descuento) / 100) *((100 -sd.PORCENTAJE_APLICADOPRECIO) / 100)) as montoVenta";*/
                                                                        sqlVM += ",(CASE sd.COD_OFERTA  When 0 Then isnull(sum((isnull(sd.cantidad, 0) +(isnull(" +
                                                                                " sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) * sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100) *((100" +
                                                                                "  - isnull(s.PORCENTAJE_DESCUENTO_PREFERENCIAL, 0)) / 100) *((100 - s.porcentaje_descuento) / 100)), 0)" +
                                                                                "   ELSE isnull(sum((isnull(sd.cantidad, 0) +(isnull( sd.cantidad_unitaria, 0) / pp.cantidad_presentacion)) *" +
                                                                                "  sd.precio_lista *((100 - sd.porcentaje_aplicadoprecio) / 100)), 0)  END) as montoVenta";      

                                                                        sqlVM += " from SALIDAS_VENTAS s,SALIDAS_DETALLEVENTAS sd,ALMACENES_VENTAS av,PRESENTACIONES_PRODUCTO pp,clientes cl";
                                                                        sqlVM += " where s.COD_SALIDAVENTA = sd.COD_SALIDAVENTAS and s.COD_ALMACEN_VENTA = av.COD_ALMACEN_VENTA";
                                                                        sqlVM += " and pp.cod_presentacion = sd.COD_PRESENTACION and s.COD_CLIENTE = cl.cod_cliente";
                                                                        sqlVM += " and av.COD_AREA_EMPRESA in(" + r.codAgencia + ")";
                                                                        sqlVM += " and cl.cod_tipocliente in (1,5,4,6)";
                                                                        sqlVM += " and s.FECHA_SALIDAVENTA between '" + SQLFecha1 + " 00:00:00' and '" + SQLFecha2 + " 23:59:59'";
                                                                        sqlVM += " and pp.cod_presentacion in(" + codPresentacionPro + ") ";
                                                                        //sqlVM += " and pp.cod_presentacion in(";
                                                                        //sqlVM += " select distinct cod_presentacion from PRODUCTOS_PRESUPUESTAR where cod_presentacionpadre in(  ";
                                                                        //sqlVM += " select p.cod_presentacion from PRODUCTOS_PRESUPUESTAR p,PRESENTACIONES_PRODUCTO pp ";
                                                                        //sqlVM += " where p.COD_PRESENTACION=pp.cod_presentacion and p.cod_gestion ="+codGestionF;
                                                                        //sqlVM += " and p.cod_lineamkt in ("+v.codLineaMkt+") and p.cod_estado = 1)) ";

                                                                        sqlVM += " and cod_gestion=" + codGestionF;
                                                                        sqlVM += " and s.COD_ESTADO_SALIDAVENTA<>2 and s.COD_TIPOSALIDAVENTAS=3";
                                                                        sqlVM +=" group by sd.cod_oferta";

                                                                        System.out.println(sqlVM);
                                                                        Statement stVM = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                                                        ResultSet rsVM = stVM.executeQuery(sqlVM);

                                                                        while (rsVM.next()) {
                                                                            cantidadVenta += rsVM.getDouble(1);
                                                                            importeVenta += rsVM.getDouble(2);

                                                                        }
                                                                        rsVM.close();
                                                                        stVM.close();


                                                                        String sqlPresupuesto = "select sum(  (pvm.CANTIDAD_UNITARIA*p.cantidad_presentacion)/" + cantidad_presentacion_padre + " ),sum(pvm.CANTIDAD_UNITARIA * pvm.PRECIO_MINIMO)";
                                                                        sqlPresupuesto += " from PRESUPUESTO_VENTASGESTION pv,PRESUPUESTO_VENTASMENSUAL pvm,PRESENTACIONES_PRODUCTO p";
                                                                        sqlPresupuesto += " where pv.COD_PRESUPUESTOVENTAS = pvm.COD_PRESUPUESTOVENTAS and pvm.COD_PRESENTACION=p.cod_presentacion and pv.COD_GESTION =" + codGestionF;
                                                                        sqlPresupuesto += " and pv.COD_AREA_EMPRESA =" + r.codAgencia + " and pv.COD_LINEAMKT in (1,2)and pv.NRO_VERSIONPRESUPUESTOVENTAS =" + nroVersionPresuesto;
                                                                        sqlPresupuesto += " and pvm.COD_PRESENTACION  in(" + codPresentacionPro + ") ";

                                                                        //sqlPresupuesto += " select cod_presentacion from PRODUCTOS_PRESUPUESTAR where cod_presentacionpadre in(  ";
                                                                        //sqlPresupuesto += " select p.cod_presentacion from PRODUCTOS_PRESUPUESTAR p,PRESENTACIONES_PRODUCTO pp ";
                                                                        //sqlPresupuesto += " where p.COD_PRESENTACION=pp.cod_presentacion and p.cod_gestion ="+codGestionF;
                                                                        //sqlPresupuesto += " and p.cod_lineamkt in ("+v.codLineaMkt+") and p.cod_estado = 1)) ";
                                                                        //sqlPresupuesto += " and p.cod_lineamkt in ("+v.codLineaMkt+") and p.cod_estado = 1)) ";
                                                                        sqlPresupuesto += " and cod_mes in (" + mesesArray + ")";




                                                                        System.out.println(sqlPresupuesto);
                                                                        Statement stPresupuesto = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                                                        ResultSet rsPresupuesto = stPresupuesto.executeQuery(sqlPresupuesto);
                                                                        // cantidadPresupuesto=0.0d;
                                                                        // importePresupuesto=0.0d;
                                                                        while (rsPresupuesto.next()) {
                                                                            cantidadPresupuesto += rsPresupuesto.getDouble(1);
                                                                            importePresupuesto += rsPresupuesto.getDouble(2);
                                                                        }

                                                                        rsPresupuesto.close();
                                                                        rsPresupuesto.close();


                                                                    }



                                                                    importeVentaLinea = importeVentaLinea + importeVenta;
                                                                    cantidadVentaLinea = cantidadVentaLinea + cantidadVenta;






                                                                    double cumplimientoCantidad = 0.0d;
                                                                    double cumplimientoVenta = 0.0d;

                                                                    importePresupuestoLinea = importePresupuestoLinea + importePresupuesto;
                                                                    cantidadPresupuestoLinea = cantidadPresupuestoLinea + cantidadPresupuesto;



                                                                    if (cantidadPresupuesto > 0.0d) {
                                                                        cumplimientoCantidad = (cantidadVenta / cantidadPresupuesto) * 100.0d;
                                                                    }

                                                                    if (importePresupuesto > 0.0d) {
                                                                        cumplimientoVenta = (importeVenta / importePresupuesto) * 100.0d;
                                                                    }

                                                                    Calculo c = new Calculo();
                                                                    c.importe = importeVenta;
                                                                    c.presupuesto = importePresupuesto;
                                                                    c.codlineamkt= Integer.parseInt(v.codLineaMkt) ;

                                                                    calculo[k] = c;

                                                                    v.cumplimientoCantidad = cumplimientoCantidad;
                                                                    lineasTotalesNacion[k] = lineasTotalesNacion[k] + cumplimientoVenta;
                                                                    k++;


                                                                    double ponderadoXLinea = importeVenta(r.codAgencia, SQLFecha1, SQLFecha2, v.codLineaMkt, codGestionF, con);
                                                                    v.cumplimientoCantidad = ponderadoXLinea;


                                                                    cumplimientoImporteTotal = cumplimientoImporteTotal + importeVenta;
                                                                    cumplimientoImporteTotalPresupuesto = cumplimientoImporteTotalPresupuesto + importePresupuesto;
                                                                    String sql_bimensual = " select t.RANGO_1,t.RANGO_2,t.PORCENTAJE_PREMIO  from ESCALA_PREMIO_BIMENSUAL t where t.COD_TIPO_BIMENSUAL=1 order by t.RANGO_1";
                                                                    Statement st_bimensual = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                                                    ResultSet rs_bimensual = st_bimensual.executeQuery(sql_bimensual);
                                                                    double porcentaje_calculado = 0;
                                                                    while (rs_bimensual.next()) {
                                                                        int rango_min = rs_bimensual.getInt(1);
                                                                        int rango_max = rs_bimensual.getInt(2);

                                                                        if (redondear(cumplimientoVenta,0) >= rango_min && redondear(cumplimientoVenta,0)  < rango_max+1) {
                                                                            porcentaje_calculado = rs_bimensual.getInt(3);
                                                                        }
                                                                    }

                                                                    String sql_insert = " INSERT INTO TIPOS_PREMIO_BIMENSUAL_DETALLE (COD_TIPO_PREMIO,COD_AREA_EMPRESA,COD_LINEA_MKT,PORCENTAJE,PORCENTAJE_CALCULADO,TIPO_PREMIO_BIMENSUAL)";
                                                                    sql_insert += " values (1," + r.codAgencia + "";
                                                                    sql_insert += " ," + v.codLineaMkt + "";
                                                                    sql_insert += "," + redondear(cumplimientoVenta,0) + "," + porcentaje_calculado + ",1)";
                                                                    System.out.println("sql_insertar:" + sql_insert);
                                                                    Statement st_insertar = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                                                    int rs_insertar = st_insertar.executeUpdate(sql_insert);



                    %>
                    <td   align="right" style="<%=v.color%>;border-bottom:1px solid #000000;border-top:1px solid #000000;border-right:1px solid #000000;">
                        <span class="outputText2" >CV<%=form.format(cumplimientoVenta)%> %</span>
                    </td>

                    <%}%>




                    <%}
                    r.calculoNacional.add(calculo);
                    r.totalesNacionalRegionales.add(lineasTotalesNacion);


                    double cumplimientoTotal = 0.0d;
                    double cumplimientoVentaTotal = 0.0d;

                    if (cumplimientoCantidadTotalPresupuesto > 0.0d) {
                        cumplimientoTotal = (cumplimientoCantidadTotal / cumplimientoCantidadTotalPresupuesto) * 100.0d;
                    }

                    if (cumplimientoImporteTotalPresupuesto > 0.0d) {
                        cumplimientoVentaTotal = (cumplimientoImporteTotal / cumplimientoImporteTotalPresupuesto) * 100.0d;
                    }




                    //data[2]=Double.valueOf(cumplimientoTotal);
                    // data[3]=v;

                    // v.cumplimientoCantidad=cumplimientoCantidad;
                    r.cantidadTotal = cumplimientoTotal;

                    %>


                    <td   align="right" style="background-color:#ADD797;border-bottom:1px solid #000000;border-top:1px solid #000000;border-right:1px solid #000000;">
                        <span class="outputText2" >CVT<%=form.format(cumplimientoVentaTotal)%>%  </span>
                    </td>
                </tr>
                <%}%>




                <%
        Calculo totalesCC[] = new Calculo[size];
        for (int i = 0; i < totalesCC.length; i++) {
            Calculo cd = new Calculo();
            totalesCC[i] = cd;


        }
        int y = 0;
        for (ReporteAgencias r : agencias) {
            for (Calculo c[] : r.calculoNacional) {
                y = 0;
                for (Calculo va : c) {
                    System.out.println("Lineas:"+va.importe + "\t" + va.presupuesto+ "\t" + va.codlineamkt);
                    totalesCC[y].importe = totalesCC[y].importe + va.importe;
                    totalesCC[y].presupuesto = totalesCC[y].presupuesto + va.presupuesto;
                    totalesCC[y].codlineamkt = va.codlineamkt;
                    y++;

                }
            }


        }

        for (Calculo rrr : totalesCC) {
            System.out.println(rrr.importe + "\t" + rrr.presupuesto+ "\t" + rrr.codlineamkt);


        }



                %>

                <tr>
                    <td   align="center" style="background-color:#ADD797;border-bottom:1px solid #000000;border-top:1px solid #000000;border-right:1px solid #000000;">
                        <span class="outputText2" style="font-weight:bold;">&nbsp;NACIONAL</span>
                    </td>
                    <%

        index = 0;
        for (Calculo ct : totalesCC) {

            String color = "";
            if (index % 2 == 0) {
                color = "background-color:#c5d9f1";
            } else {
                color = "background-color:#FFFF99";
            }
            index++;

            String sql_bimensual = " select t.RANGO_1,t.RANGO_2,t.PORCENTAJE_PREMIO  from ESCALA_PREMIO_BIMENSUAL t where t.COD_TIPO_BIMENSUAL=1 order by t.RANGO_1";
            Statement st_bimensual = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs_bimensual = st_bimensual.executeQuery(sql_bimensual);
            double porcentaje_calculado = 0;
            while (rs_bimensual.next()) {
                 int rango_min = rs_bimensual.getInt(1);
                 int rango_max = rs_bimensual.getInt(2);
                 if (redondear(((ct.importe / ct.presupuesto) * 100.0d),0) >= rango_min && redondear(((ct.importe / ct.presupuesto) * 100.0d),0) < rango_max+1) {
                       porcentaje_calculado = rs_bimensual.getInt(3);
                 }
            }

            String sql_insert = " INSERT INTO TIPOS_PREMIO_BIMENSUAL_DETALLE (COD_TIPO_PREMIO,COD_AREA_EMPRESA,COD_LINEA_MKT,PORCENTAJE,PORCENTAJE_CALCULADO,TIPO_PREMIO_BIMENSUAL)";
            sql_insert += " values (1,1000";
            sql_insert += " ," + ct.codlineamkt + "";
            sql_insert += "," + redondear(((ct.importe / ct.presupuesto) * 100.0d),0) + "," + porcentaje_calculado + ",1)";
            System.out.println("sql_insertar:" + sql_insert);
            Statement st_insertar = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            int rs_insertar = st_insertar.executeUpdate(sql_insert);

                    %>




                    <td   align="right" style="<%=color%>;border-bottom:1px solid #000000;border-top:1px solid #000000;border-right:1px solid #000000;">
                        <span class="outputText2" style="font-weight:bold;">TN<%=form.format((ct.importe / ct.presupuesto) * 100.0d)%>%</span>
                    </td>




                    <%}%>
                    <td   align="right" style="background-color:#ADD797;border-bottom:1px solid #000000;border-top:1px solid #000000;border-right:1px solid #000000;">
                        <span class="outputText2" style="font-weight:bold">TOTAL</span>
                    </td>

                </tr>


            </table>
            <br/>
            <br/>





            <table  align="center"  width="<%=(lineas2.size() * 10) + 15%>%" cellpadding="0" cellspacing="0">
                <tr>
                    <td  colspan="<%=lineas2.size() + 2%>" align="center" style="background-color:#ADD797;border-bottom:1px solid #000000;border-top:1px solid #000000;border-right:1px solid #000000;">
                        <span class="outputText2" style="font-weight:bold;">&nbsp;CUMPLIMIENTO CUALITATIVO DE PRESUPUESTO</span>
                    </td>
                </tr>

                <tr>
                    <td   align="center" style="background-color:#ADD797;border-bottom:1px solid #000000;border-top:1px solid #000000;border-right:1px solid #000000;">
                        <span class="outputText2" style="font-weight:bold;">&nbsp;RG</span>
                    </td>
                    <% for (ReporteLineas v : lineas2) {%>
                    <% if (v.codLineaMkt.equals("0")) {%>
                    <td   align="center" style="<%=v.color%>;border-bottom:1px solid #000000;border-top:1px solid #000000;border-right:1px solid #000000;">
                        <span class="outputText2" style="font-weight:bold;"><%=v.nombreLineaVenta%></span>
                    </td>
                    <%} else {%>
                    <td   align="center" style="<%=v.color%>;border-bottom:1px solid #000000;border-top:1px solid #000000;border-right:1px solid #000000;">
                        <span class="outputText2" style="font-weight:bold;"><%=v.nombreLineaMkt%></span>
                    </td>
                    <%}%>
                    <%}%>
                    <td   align="right" style="background-color:#ADD797;border-bottom:1px solid #000000;border-top:1px solid #000000;border-right:1px solid #000000;">
                        <span class="outputText2" style="font-weight:bold">TOTAL</span>
                    </td>

                </tr>


                <%

        double sumPon[] = new double[lineas2.size()];

        for (ReporteAgencias r : agencias) {


                %>
                <tr>

                    <td   align="left" style="background-color:#ADD797;border-bottom:1px solid #000000;border-top:1px solid #000000;border-right:1px solid #000000;">
                        <span class="outputText2">&nbsp;<%=r.nombreAgencia%></span>
                    </td>


                    <%

                            y = 0;
                            double t = 0.0d;
                            for (ReporteLineas v : r.reporteLineas) {
                                sumPon[y] = sumPon[y] + v.cumplimientoCantidad;
                                y++;
                                t = t + v.cumplimientoCantidad;
                                String sql_bimensual = " select t.RANGO_1,t.RANGO_2,t.PORCENTAJE_PREMIO  from ESCALA_PREMIO_BIMENSUAL t where t.COD_TIPO_BIMENSUAL=2 order by t.RANGO_1";
                                Statement st_bimensual = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                ResultSet rs_bimensual = st_bimensual.executeQuery(sql_bimensual);
                                double porcentaje_calculado = 0;
                                while (rs_bimensual.next()) {
                                    int rango_min = rs_bimensual.getInt(1);
                                    int rango_max = rs_bimensual.getInt(2);

                                    if (redondear(v.cumplimientoCantidad,0) >= rango_min && redondear(v.cumplimientoCantidad,0) < rango_max+1) {
                                        porcentaje_calculado = rs_bimensual.getInt(3);
                                    }
                                }

                                String sql_insert = " INSERT INTO TIPOS_PREMIO_BIMENSUAL_DETALLE (COD_TIPO_PREMIO,COD_AREA_EMPRESA,COD_LINEA_MKT,PORCENTAJE,PORCENTAJE_CALCULADO,TIPO_PREMIO_BIMENSUAL)";
                                sql_insert += " values (1," + r.codAgencia + "";
                                sql_insert += " ," + v.codLineaMkt + "";
                                sql_insert += "," + v.cumplimientoCantidad + "," + porcentaje_calculado + ",2)";
                                System.out.println("sql_insertar:" + sql_insert);
                                Statement st_insertar = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                                int rs_insertar = st_insertar.executeUpdate(sql_insert);
                    %>

                    <td   align="right" style="<%=v.color%>;border-bottom:1px solid #000000;border-top:1px solid #000000;border-right:1px solid #000000;">
                        <%--span class="outputText2" ><%=form.format(v.cumplimientoCantidad)%> %</span--%>
                        <span class="outputText2" ><%=v.cumplimientoCantidad%> %</span>

                    </td>


                    <%}
                       
                            %>

                    <td   align="right" style="background-color:#ADD797;border-bottom:1px solid #000000;border-top:1px solid #000000;border-right:1px solid #000000;">
                        <span class="outputText2" ><%=form.format(t)%></span>
                    </td>
                </tr>
                <%}%>




                <tr>
                    <td   align="left" style="background-color:#ADD797;border-bottom:1px solid #000000;border-top:1px solid #000000;border-right:1px solid #000000;">
                        <span class="outputText2">&nbsp;<%//=r.nombreAgencia%></span>
                    </td>
                    <%
        index = 0;
        double t2 = 0.0d;
        for (ReporteLineas im : lineas2) {

            String color = "";
            if (index % 2 == 0) {
                color = "background-color:#c5d9f1";
            } else {
                color = "background-color:#FFFF99";
            }
            index++;

            double ponderadoXLinea = importeVentaRegional(codArea, SQLFecha1, SQLFecha2, im.codLineaMkt, "7", con);
            t2 = t2 + ponderadoXLinea;

            String sql_bimensual = " select t.RANGO_1,t.RANGO_2,t.PORCENTAJE_PREMIO  from ESCALA_PREMIO_BIMENSUAL t where t.COD_TIPO_BIMENSUAL=2 order by t.RANGO_1";
            Statement st_bimensual = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs_bimensual = st_bimensual.executeQuery(sql_bimensual);
            double porcentaje_calculado = 0;
            while (rs_bimensual.next()) {
                 int rango_min = rs_bimensual.getInt(1);
                 int rango_max = rs_bimensual.getInt(2);
                 if (redondear(ponderadoXLinea,0) >= rango_min && redondear(ponderadoXLinea,0) < rango_max+1) {
                       porcentaje_calculado = rs_bimensual.getInt(3);
                 }
            }

            String sql_insert = " INSERT INTO TIPOS_PREMIO_BIMENSUAL_DETALLE (COD_TIPO_PREMIO,COD_AREA_EMPRESA,COD_LINEA_MKT,PORCENTAJE,PORCENTAJE_CALCULADO,TIPO_PREMIO_BIMENSUAL)";
            sql_insert += " values (1,1000";
            sql_insert += " ," + im.codLineaMkt + "";
            sql_insert += "," + ponderadoXLinea + "," + porcentaje_calculado + ",2)";
            System.out.println("sql_insertar:" + sql_insert);
            Statement st_insertar = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            int rs_insertar = st_insertar.executeUpdate(sql_insert);

                    %>

                    <td   align="right" style="<%=color%>;border-bottom:1px solid #000000;border-top:1px solid #000000;border-right:1px solid #000000;">
                        <span class="outputText2" >tn<%=form.format(ponderadoXLinea)%></span>

                    </td>


                    <%}%>

                    <td   align="right" style="background-color:#ADD797;border-bottom:1px solid #000000;border-top:1px solid #000000;border-right:1px solid #000000;">
                        <span class="outputText2" ><%=form.format(t2)%></span>
                    </td>
                </tr>



            </table>
            <br><br><br>

            <%--table border="1" class="outputText2" align="center">
                <tr bgcolor="#cccccc">
                    <th>Nombre Categoria Premio</th>
                    <th>Cargo</th>
                    <th>Area Empresa</th>
                    <th>Linea</th>
                    <th>Porcentaje</th>
                    <th>Cualitativo</th>
                    <th>Monto</th>
                </tr--%>
                <%
        try{
        Statement st_delete1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        int rs_delete1 = st_delete1.executeUpdate("delete from TIPOS_PREMIO_BIMENSUAL_CARGO ");
        String sql_calculo = " SELECT C.COD_CARGO_LINEA_PREMIO,c.COD_CARGO,CA.DESCRIPCION_CARGO,c.NOMBRE_CARGO_LINEA_PREMIO,C.COD_LINEA_COMISION FROM CARGOS_LINEAS_PREMIOS_BIMENSUAL C,CARGOS CA WHERE CA.CODIGO_CARGO=C.COD_CARGO and c.COD_ESTADO_REGISTRO=1";
        System.out.println("sql_calculo:" + sql_calculo);
        Statement st_calculo = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

        ResultSet rs_calculo = st_calculo.executeQuery(sql_calculo);
        while (rs_calculo.next()) {
            String codCargoLinea = rs_calculo.getString(1);
            String codCargo = rs_calculo.getString(2);
            String nomCargo = rs_calculo.getString(3);
            String nomLineaCargo = rs_calculo.getString(4);
            String codLineaComision=rs_calculo.getString(5);
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
                porcentaje=redondear(porcentaje,0);
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
                            if(codLineaMkt.equals("4") || codLineaMkt.equals("6") || codLineaMkt.equals("7")){
                                monto = 0.3 * monto * porcentaje_calculado / 100;
                            }else{
                                monto = 0.7 * monto * porcentaje_calculado / 100;
                            }
                    %>
                    <td><%//=monto%></td>

                    <%
                            String sql_insert_linea = "insert into TIPOS_PREMIO_BIMENSUAL_CARGO (COD_TIPO_PREMIO,COD_AREA_EMPRESA,COD_CARGO,COD_LINEA_MKT,MONTO_CUALITATIVO,MONTO_CUANTITATIVO,TIPO_PREMIO_BIMENSUAL)";
                            sql_insert_linea += " values(1," + codAreaEmpresa + "," + codCargo + "," + codLineaMkt + ",0," + monto + ","+codLineaComision+")";
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
            String codLineaComision=rs_calculo.getString(5);
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
                porcentaje=redondear(porcentaje,0);
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
                            if(codLineaMkt.equals("4") || codLineaMkt.equals("6") || codLineaMkt.equals("7")){
                                monto = 0.7 * monto * porcentaje_calculado / 100;
                            }else{
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
                            sql_insert_linea += " where COD_TIPO_PREMIO=1 and  cod_area_empresa=" + codAreaEmpresa + " and cod_cargo= " + codCargo + " and cod_linea_mkt=" + codLineaMkt + " and TIPO_PREMIO_BIMENSUAL="+codLineaComision+"";
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
            

            <%con.close();%>

        </form>
    </body>
</html>
