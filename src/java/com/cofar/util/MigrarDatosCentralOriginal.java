    /*
 * MigrarDatosCentral.java
 *
 * Created on 13 de noviembre de 2008, 20:15
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */
package com.cofar.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 *
 * @author Administrador
 */
public class MigrarDatosCentralOriginal {

    /** Creates
     * a new instance of MigrarDatosCentral */
    Connection conOrigen;
    Connection conDestino;
    //SimpleDateFormat f=new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");

    private Connection getConnectionDestino() {
        Connection con = null;

        try {


            //String url="jdbc:sqlserver://localhost;user=sa;password=n3td4t4;databaseName=CAR2_RIBERALTA";
            //String url="jdbc:sqlserver://172.16.10.21;user=sa;password=n3td4t4;databaseName=CAR2_QUINTANILLA";
            String url = "jdbc:sqlserver://172.16.10.239;user=sa;password=n3td4t4;databaseName=SARTORIUS";

            System.out.println("url destino:" + url);
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            con = DriverManager.getConnection(url);
            Statement stCon = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            stCon.executeUpdate("set DATEFORMAT ymd");



        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e1) {
            e1.printStackTrace();

        }
        return con;
    }

    public Connection getConnectionParam(String host, String password, String basededatos) {
        Connection con = null;

        try {
            String url = "jdbc:sqlserver://" + host + ";user=sa;password=" + password + ";databaseName=" + basededatos;
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            System.out.println("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
            con = DriverManager.getConnection(url);
            Statement stCon = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            stCon.executeUpdate("set DATEFORMAT ymd");


        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e1) {
            e1.printStackTrace();

        }
        return con;

    }

    private Connection getConnectionOrigen(String origen) {
        Connection con = null;

        try {
            String url = "jdbc:sqlserver://172.16.10.21;user=sa;password=n3td4t4;databaseName=" + origen;
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            con = DriverManager.getConnection(url);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e1) {
            e1.printStackTrace();

        }
        return con;
    }
    private String host = "";
    private String bd = "";
    private String password = "";

    public MigrarDatosCentralOriginal(String host, String bd, String password) {
        this.host = host;
        this.bd = bd;
        this.password = password;

        //conOrigen= getConnectionOrigen();
        conDestino = getConnectionDestino();


    }

    public MigrarDatosCentralOriginal(String origen) {
        conOrigen = getConnectionOrigen(origen);
        conDestino = getConnectionDestino();

    }

    public void pro() throws SQLException {
        Connection conOrigen = getConnectionParam(host, password, bd);
        System.out.println("conOrigen1212:" + host + "/" + bd);
        System.out.println("conDestino12112:" + conDestino);

        String sql = "SELECT * FROM SALIDAS_VENTAS S,SALIDAS_DETALLEVENTAS sd WHERE  COD_ALMACEN_VENTADESTINO=4 AND FECHA_SALIDAVENTA BETWEEN '2009-05-01' AND '2009-05-31' and sd.COD_SALIDAVENTAS=s.COD_SALIDAVENTA";
        Statement st = conDestino.createStatement();
        ResultSet rs = st.executeQuery(sql);
        while (rs.next()) {
            String codsalidaventa = rs.getString("cod_salidaventa");
            String codpresentacion = rs.getString("cod_presentacion");
            float COSTO_ALMACEN = rs.getFloat("COSTO_ALMACEN");
            float COSTO_ACTUALIZADO = rs.getFloat("COSTO_ACTUALIZADO");
            float COSTO_ACTUALIZADO_FINAL = rs.getFloat("COSTO_ACTUALIZADO_FINAL");
            String FECHA_ACTUALIZACION = rs.getString("FECHA_ACTUALIZACION");

            String sss = "select  cod_salidaventa from SALIDAS_VENTAS where COD_PEDIDOVENTA=" + codsalidaventa;
            Statement st1 = conOrigen.createStatement();
            ResultSet rrr = st1.executeQuery(sss);
            String cod_salidaventa_registro = "";
            while (rrr.next()) {
                cod_salidaventa_registro = rrr.getString(1);
            }
            if (!cod_salidaventa_registro.equals("")) {
                String sqlUpdate = "update SALIDAS_DETALLEVENTAS set COSTO_ALMACEN=" + COSTO_ALMACEN + ",COSTO_ACTUALIZADO=" + COSTO_ACTUALIZADO + ",COSTO_ACTUALIZADO_FINAL=" + COSTO_ACTUALIZADO_FINAL + ",FECHA_ACTUALIZACION='" + FECHA_ACTUALIZACION + "'";
                sqlUpdate += " where cod_salidaventas=" + cod_salidaventa_registro + " and cod_presentacion=" + codpresentacion;
                System.out.println("sqlUpdate:" + sqlUpdate);
                st1.executeUpdate(sqlUpdate);
            }


        }


    }

    public void procesoMigracionCentral() {


        System.out.println("INICIALIZO::::::::::::::");
        Connection conOrigen = getConnectionParam(host, password, bd);
        System.out.println("conOrigen1212:" + host + "/" + bd);
        System.out.println("conDestino:" + conDestino);
        try {
            String sqlDelete = "delete from ORDENES_COMPRA ";
            System.out.println("sqlDelete:" + sqlDelete);
            Statement stDelete = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            int resultado = stDelete.executeUpdate(sqlDelete);
            /***********                REGISTRAR ORDENES COMPRA                          *******/
            String sqlOrdenesCompraOrigen = "select [COD_GESTION], [COD_ORDEN_COMPRA], [NRO_ORDEN_COMPRA], [COD_PROVEEDOR],";
            sqlOrdenesCompraOrigen += " [COD_REPRESENTANTE], [COD_PRE_ORDEN_COMPRA], [COD_ESTADO_COMPRA], [COD_TIPO_TRANSPORTE], [COD_TIPO_COMPRA], [COD_CONDICION_PRECIO],";
            sqlOrdenesCompraOrigen += " [COD_TIPO_PAGO], [COD_MONEDA], [COD_COTIZACION], [COD_MEDIOPAGO], [COD_RESPONSABLE_COMPRAS], [DIVISION], [FECHA_EMISION],";
            sqlOrdenesCompraOrigen += " [FECHA_ENTREGA], [DESC_FECHA_ENTREGA], [FECHA_ALERTA], [FECHA_DESPACHO], [CREDITO_FISCAL_SI_NO], [OBS_ORDEN_COMPRA], [ESTADO_SISTEMA],";
            sqlOrdenesCompraOrigen += " [EMITIR_CHEQUEANOMBREDE], [CODIGO_CUENTA], [COD_ALMACEN_ENTREGA], [DIAS_TERMINOSPAGO], [COD_TIPO_DOCUMENTO_TERMINOSPAGO],";
            sqlOrdenesCompraOrigen += " [COD_LUGARENTREGA], [OBS_ORDEN_COMPRA_APROBACION], [COD_PROYECTO], [FECHA_ENVIO_PROVEEDOR], [FECHA_FINAL_SEGUIMIENTO], [obs_oc_transito],";
            sqlOrdenesCompraOrigen += " [nro_doc_transporte] from [ORDENES_COMPRA]";
            System.out.println("sqlOrdenesCompraOrigen:" + sqlOrdenesCompraOrigen);
            Statement stOrdenesCompraOrigen = conOrigen.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rsOrdenesCompraOrigen = stOrdenesCompraOrigen.executeQuery(sqlOrdenesCompraOrigen);
            while (rsOrdenesCompraOrigen.next()) {
            String codGestion = rsOrdenesCompraOrigen.getString(1);
            String codOrdenCompra = rsOrdenesCompraOrigen.getString(2);
            String nroOrdenCompra = rsOrdenesCompraOrigen.getString(3);
            String codProveedor = rsOrdenesCompraOrigen.getString(4);
            String codRepresentante = rsOrdenesCompraOrigen.getString(5);
            String codPreOrdenCompra = rsOrdenesCompraOrigen.getString(6);
            String CodEstadoCompra = rsOrdenesCompraOrigen.getString(7);
            String codTipoTransporte = rsOrdenesCompraOrigen.getString(8);
            String codTipoCompra = rsOrdenesCompraOrigen.getString(9);
            String codCondicionPrecio = rsOrdenesCompraOrigen.getString(10);
            String codTipoPago = rsOrdenesCompraOrigen.getString(11);
            String codMoneda = rsOrdenesCompraOrigen.getString(12);

            String codCotizacion = rsOrdenesCompraOrigen.getString(13);
            String codMedioPago = rsOrdenesCompraOrigen.getString(14);
            String codResponsableCompras = rsOrdenesCompraOrigen.getString(15);
            String division = rsOrdenesCompraOrigen.getString(16);
            //Date fechaAux=rsOrdenesCompraOrigen.getDate(17);
            //SimpleDateFormat f=new SimpleDateFormat("yyyy/MM/dd");
            String fechaEmision = rsOrdenesCompraOrigen.getString(17);
            //fechaAux=rsOrdenesCompraOrigen.getDate(18);
            String fechaEntrega = rsOrdenesCompraOrigen.getString(18);
            String descFechaEntrega = rsOrdenesCompraOrigen.getString(19);
            //fechaAux=rsOrdenesCompraOrigen.getDate(20);
            String fechaAlerta = rsOrdenesCompraOrigen.getString(20);
            //fechaAux=rsOrdenesCompraOrigen.getDate(21);
            String fechaDespacho = rsOrdenesCompraOrigen.getString(21);
            String creditoFiscal = rsOrdenesCompraOrigen.getString(22);
            String obsOrdenCompra = rsOrdenesCompraOrigen.getString(23);
            String estadoSistema = rsOrdenesCompraOrigen.getString(24);
            String emitirCheque = rsOrdenesCompraOrigen.getString(25);
            String codigoCuenta = rsOrdenesCompraOrigen.getString(26);
            String codAlmacenEntrega = rsOrdenesCompraOrigen.getString(27);
            String diasTermino = rsOrdenesCompraOrigen.getString(28);
            String codTipoDocTerminosPago = rsOrdenesCompraOrigen.getString(29);
            String codLugarEntrega = rsOrdenesCompraOrigen.getString(30);
            String obsOrdenCompraAprobacion = rsOrdenesCompraOrigen.getString(31);
            String codProyecto = rsOrdenesCompraOrigen.getString(32);
            //fechaAux=rsOrdenesCompraOrigen.getDate(33);
            String fechaEnvioProveedor = rsOrdenesCompraOrigen.getString(33);
            //fechaAux=rsOrdenesCompraOrigen.getDate(34);
            String fechaFinSeguimiento = rsOrdenesCompraOrigen.getString(34);
            String obsOcTransito = rsOrdenesCompraOrigen.getString(35);
            String nroDocTransporte = rsOrdenesCompraOrigen.getString(36);



            String sqlOrdenesCompraDestino = "INSERT INTO [ORDENES_COMPRA] ([COD_GESTION], [COD_ORDEN_COMPRA], [NRO_ORDEN_COMPRA], [COD_PROVEEDOR],";
            sqlOrdenesCompraDestino += " [COD_REPRESENTANTE], [COD_PRE_ORDEN_COMPRA], [COD_ESTADO_COMPRA], [COD_TIPO_TRANSPORTE], [COD_TIPO_COMPRA], [COD_CONDICION_PRECIO],";
            sqlOrdenesCompraDestino += " [COD_TIPO_PAGO], [COD_MONEDA], [COD_COTIZACION], [COD_MEDIOPAGO], [COD_RESPONSABLE_COMPRAS], [DIVISION], [FECHA_EMISION],";
            sqlOrdenesCompraDestino += " [FECHA_ENTREGA], [DESC_FECHA_ENTREGA], [FECHA_ALERTA], [FECHA_DESPACHO], [CREDITO_FISCAL_SI_NO], [OBS_ORDEN_COMPRA], [ESTADO_SISTEMA],";
            sqlOrdenesCompraDestino += " [EMITIR_CHEQUEANOMBREDE], [CODIGO_CUENTA], [COD_ALMACEN_ENTREGA], [DIAS_TERMINOSPAGO], [COD_TIPO_DOCUMENTO_TERMINOSPAGO],";
            sqlOrdenesCompraDestino += " [COD_LUGARENTREGA], [OBS_ORDEN_COMPRA_APROBACION], [COD_PROYECTO], [FECHA_ENVIO_PROVEEDOR], [FECHA_FINAL_SEGUIMIENTO], [obs_oc_transito],";
            sqlOrdenesCompraDestino += " [nro_doc_transporte]) values(";
            sqlOrdenesCompraDestino += " " + codGestion + "," + codOrdenCompra + "," + nroOrdenCompra + "," + codProveedor + "," + codRepresentante + "," + codPreOrdenCompra + "," + CodEstadoCompra + ",";
            sqlOrdenesCompraDestino += " " + codTipoTransporte + "," + codTipoCompra + "," + codCondicionPrecio + "," + codTipoPago + "," + codMoneda + "," + codCotizacion + "," + codMedioPago + ",";
            sqlOrdenesCompraDestino += " " + codResponsableCompras + "," + division + ",";
            if (fechaEmision == null) {
            sqlOrdenesCompraDestino += " " + fechaEmision + ",";
            } else {
            sqlOrdenesCompraDestino += " '" + fechaEmision + "',";
            }
            if (fechaEntrega == null) {
            sqlOrdenesCompraDestino += " " + fechaEntrega + ",";
            } else {
            sqlOrdenesCompraDestino += " '" + fechaEntrega + "',";
            }
            sqlOrdenesCompraDestino += " '" + descFechaEntrega + "',";
            if (fechaAlerta == null) {
            sqlOrdenesCompraDestino += " " + fechaAlerta + ",";
            } else {
            sqlOrdenesCompraDestino += " '" + fechaAlerta + "',";
            }
            if (fechaDespacho == null) {
            sqlOrdenesCompraDestino += " " + fechaDespacho + ",";
            } else {
            sqlOrdenesCompraDestino += " '" + fechaDespacho + "',";
            }
            sqlOrdenesCompraDestino += " " + creditoFiscal + ",'" + obsOrdenCompra + "'," + estadoSistema + ",'" + emitirCheque + "','" + codigoCuenta + "'," + codAlmacenEntrega + "," + diasTermino + ",";
            sqlOrdenesCompraDestino += " " + codTipoDocTerminosPago + "," + codLugarEntrega + ",'" + obsOrdenCompraAprobacion + "'," + codProyecto + ",";

            if (fechaEnvioProveedor == null) {
            sqlOrdenesCompraDestino += " " + fechaEnvioProveedor + ",";
            } else {
            sqlOrdenesCompraDestino += " '" + fechaEnvioProveedor + "',";
            }
            if (fechaFinSeguimiento == null) {
            sqlOrdenesCompraDestino += " " + fechaFinSeguimiento + ",";
            } else {
            sqlOrdenesCompraDestino += " '" + fechaFinSeguimiento + "',";
            }

            sqlOrdenesCompraDestino += " '" + obsOcTransito + "','" + nroDocTransporte + "')";
            System.out.println("sqlOrdenesCompraDestino:" + sqlOrdenesCompraDestino);
            Statement stDeleteOrdenesCompra = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            resultado = stDeleteOrdenesCompra.executeUpdate(sqlOrdenesCompraDestino);
            }

            /*********************** ORDENES COMPRA DETALLE  ********************************/
            sqlDelete = "delete from ORDENES_COMPRA_DETALLE ";
            System.out.println("sqlDelete ORDENES_COMPRA_DETALLE:" + sqlDelete);
            stDelete = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            resultado = stDelete.executeUpdate(sqlDelete);
            String sqlOrdenesCompraDetOrigen = "select [COD_ORDEN_COMPRA], [COD_ORDENCOMPRADETALLE], [COD_MATERIAL], [CANTIDAD_NETA], [COD_UNIDAD_MEDIDA],";
            sqlOrdenesCompraDetOrigen += "  [PRECIO_UNITARIO], [CANTIDAD_INGRESO_ALMACEN], [PRECIO_TOTAL], [DESCRIPCION]";
            sqlOrdenesCompraDetOrigen += " from [ORDENES_COMPRA_DETALLE]";
            System.out.println("sqlOrdenesCompraDetOrigen:" + sqlOrdenesCompraDetOrigen);
            Statement stOrdenesCompraDetOrigen = conOrigen.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rsOrdenesCompraDetOrigen = stOrdenesCompraDetOrigen.executeQuery(sqlOrdenesCompraDetOrigen);
            while (rsOrdenesCompraDetOrigen.next()) {
            String codOrdenCompra = rsOrdenesCompraDetOrigen.getString(1);
            String codOrdenCompraDetalle = rsOrdenesCompraDetOrigen.getString(2);
            String codMaterial = rsOrdenesCompraDetOrigen.getString(3);
            String cantidadNeta = rsOrdenesCompraDetOrigen.getString(4);
            String codUnidadMedida = rsOrdenesCompraDetOrigen.getString(5);
            String precioUnitario = rsOrdenesCompraDetOrigen.getString(6);
            String cantIngresoAlmacen = rsOrdenesCompraDetOrigen.getString(7);
            String precioTotal = rsOrdenesCompraDetOrigen.getString(8);
            String descripcion = rsOrdenesCompraDetOrigen.getString(9);




            String sqlOrdenesCompraDetDestino = "INSERT INTO [ORDENES_COMPRA_DETALLE] ([COD_ORDEN_COMPRA], [COD_ORDENCOMPRADETALLE], [COD_MATERIAL], [CANTIDAD_NETA], [COD_UNIDAD_MEDIDA], [PRECIO_UNITARIO], [CANTIDAD_INGRESO_ALMACEN], [PRECIO_TOTAL], [DESCRIPCION])";
            sqlOrdenesCompraDetDestino += " values(";
            sqlOrdenesCompraDetDestino += " " + codOrdenCompra + "," + codOrdenCompraDetalle + "," + codMaterial + "," + cantidadNeta + "," + codUnidadMedida + "," + precioUnitario + "," + cantIngresoAlmacen + ",";
            sqlOrdenesCompraDetDestino += " " + precioTotal + ",'" + descripcion + "')";
            System.out.println("sqlOrdenesCompraDet Destino:" + sqlOrdenesCompraDetDestino);
            Statement stDeleteOrdenesDetCompra = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            resultado = stDeleteOrdenesDetCompra.executeUpdate(sqlOrdenesCompraDetDestino);
            }
            /*********************************** INGRESOS ALMACEN ********************************/
            sqlDelete = "delete from INGRESOS_ALMACEN_TRIGGER ";
            System.out.println("sqlDelete _TRIGGER:" + sqlDelete);
            stDelete = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            resultado = stDelete.executeUpdate(sqlDelete);
            sqlDelete = "delete from INGRESOS_ALMACEN ";
            System.out.println("sqlDelete INGRESOS_ALMACEN:" + sqlDelete);
            stDelete = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            resultado = stDelete.executeUpdate(sqlDelete);
            String sqlIngresosAlmacen = "select [COD_INGRESO_ALMACEN], [COD_TIPO_INGRESO_ALMACEN], [COD_ORDEN_COMPRA], [COD_GESTION],";
            sqlIngresosAlmacen += " [COD_ESTADO_INGRESO_ALMACEN], [COD_DEVOLUCION], [FECHA_INGRESO_ALMACEN], [COD_TIPO_DOCUMENTO], [NRO_DOCUMENTO],";
            sqlIngresosAlmacen += " [FECHA_DOCUMENTO], [CREDITO_FISCAL_SI_NO], [OBS_INGRESO_ALMACEN], [NRO_INGRESO_ALMACEN], [COD_PROVEEDOR],";
            sqlIngresosAlmacen += " [ESTADO_SISTEMA], [COD_TIPO_COMPRA], [COD_ALMACEN], [COD_SALIDA_ALMACEN], [COD_PERSONAL], [COD_ESTADO_INGRESO_LIQUIDACION],";
            sqlIngresosAlmacen += " [FECHA_LIQUIDACION], [COD_SALIDA_ALMACEN_DEVOLUCION]";
            sqlIngresosAlmacen += " from [INGRESOS_ALMACEN]";
            System.out.println("sqlIngresosAlmacen:" + sqlIngresosAlmacen);
            Statement stIngresosAlmacen = conOrigen.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rsIngresosAlmacen = stIngresosAlmacen.executeQuery(sqlIngresosAlmacen);
            while (rsIngresosAlmacen.next()) {
                String codIngresoAlmacen = rsIngresosAlmacen.getString(1);
                String codTipoIngresoAlmacen = rsIngresosAlmacen.getString(2);
                String codOrdenCompra = rsIngresosAlmacen.getString(3);
                String codGestion = rsIngresosAlmacen.getString(4);
                String codEstadoIngresoAlmacen = rsIngresosAlmacen.getString(5);
                String codDevolucion = rsIngresosAlmacen.getString(6);
                String fechaIngresoAlmacen = rsIngresosAlmacen.getString(7);
                String codTipoDocumento = rsIngresosAlmacen.getString(8);
                String nroDocumento = rsIngresosAlmacen.getString(9);
                String fechaDocumento = rsIngresosAlmacen.getString(10);
                String creditoFiscal = rsIngresosAlmacen.getString(11);
                String obsIngresoAlmacen = rsIngresosAlmacen.getString(12);
                String nroIngresoAlmacen = rsIngresosAlmacen.getString(13);
                String codProveedor = rsIngresosAlmacen.getString(14);
                String estadoSistema = rsIngresosAlmacen.getString(15);
                String codTipoCompra = rsIngresosAlmacen.getString(16);
                String codAlmacen = rsIngresosAlmacen.getString(17);
                String codSalidaAlmacen = rsIngresosAlmacen.getString(18);
                String codPersonal = rsIngresosAlmacen.getString(19);
                String codEstadoIngresoLiquidacion = rsIngresosAlmacen.getString(20);
                String fechaLiquidacion = rsIngresosAlmacen.getString(21);
                String codSalidaAlmacenDevolucion = rsIngresosAlmacen.getString(22);


                String sqlIngresosAlmacenDestino = "INSERT INTO [INGRESOS_ALMACEN] ([COD_INGRESO_ALMACEN], [COD_TIPO_INGRESO_ALMACEN], [COD_ORDEN_COMPRA], [COD_GESTION],";
                sqlIngresosAlmacenDestino += " [COD_ESTADO_INGRESO_ALMACEN], [COD_DEVOLUCION], [FECHA_INGRESO_ALMACEN], [COD_TIPO_DOCUMENTO], [NRO_DOCUMENTO],";
                sqlIngresosAlmacenDestino += " [FECHA_DOCUMENTO], [CREDITO_FISCAL_SI_NO], [OBS_INGRESO_ALMACEN], [NRO_INGRESO_ALMACEN], [COD_PROVEEDOR], ";
                sqlIngresosAlmacenDestino += " [ESTADO_SISTEMA], [COD_TIPO_COMPRA], [COD_ALMACEN], [COD_SALIDA_ALMACEN], [COD_PERSONAL], [COD_ESTADO_INGRESO_LIQUIDACION],";
                sqlIngresosAlmacenDestino += " [COD_SALIDA_ALMACEN_DEVOLUCION],[FECHA_LIQUIDACION])";
                sqlIngresosAlmacenDestino += " values(";
                sqlIngresosAlmacenDestino += " " + codIngresoAlmacen + "," + codTipoIngresoAlmacen + "," + codOrdenCompra + "," + codGestion + "," + codEstadoIngresoAlmacen + "," + codDevolucion + ",";

                if (fechaIngresoAlmacen == null) {
                    sqlIngresosAlmacenDestino += " " + fechaIngresoAlmacen + ",";
                } else {
                    sqlIngresosAlmacenDestino += " '" + fechaIngresoAlmacen + "',";
                }
                sqlIngresosAlmacenDestino += " " + codTipoDocumento + ",'" + nroDocumento + "',";
                if (fechaDocumento == null) {
                    sqlIngresosAlmacenDestino += " " + fechaDocumento + ",";
                } else {
                    sqlIngresosAlmacenDestino += " '" + fechaDocumento + "',";
                }
                sqlIngresosAlmacenDestino += " " + creditoFiscal + ",'" + obsIngresoAlmacen + "'," + nroIngresoAlmacen + ",";
                sqlIngresosAlmacenDestino += " " + codProveedor + "," + estadoSistema + "," + codTipoCompra + "," + codAlmacen + "," + codSalidaAlmacen + "," + codPersonal + ",";
                sqlIngresosAlmacenDestino += " " + codEstadoIngresoLiquidacion + "," + codSalidaAlmacenDevolucion + ",";

                if (fechaLiquidacion == null) {
                    sqlIngresosAlmacenDestino += " " + fechaLiquidacion + ")";
                } else {
                    sqlIngresosAlmacenDestino += " '" + fechaLiquidacion + "')";
                }
                System.out.println("sqlIngresosAlmacenDestino:" + sqlIngresosAlmacenDestino);
                Statement stIngresosAlmacenDestino = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                resultado = stIngresosAlmacenDestino.executeUpdate(sqlIngresosAlmacenDestino);
            }

            /*********************************** INGRESOS ALMACEN DETALLE ********************************/
            sqlDelete = "delete from INGRESOS_ALMACEN_DETALLE ";
            System.out.println("sqlDelete:" + sqlDelete);
            stDelete = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            resultado = stDelete.executeUpdate(sqlDelete);
            String sqlIngresosAlmacenDetOrigen = "select [COD_MATERIAL], [COD_INGRESO_ALMACEN], [COD_SECCION], [NRO_UNIDADES_EMPAQUE], [CANT_TOTAL_INGRESO], ";
            sqlIngresosAlmacenDetOrigen += "[CANT_TOTAL_INGRESO_FISICO], [COD_UNIDAD_MEDIDA], [PRECIO_TOTAL_MATERIAL], [PRECIO_UNITARIO_MATERIAL], [COSTO_UNITARIO], ";
            sqlIngresosAlmacenDetOrigen += "[observacion], [PRECIO_NETO], [COSTO_PROMEDIO], [COSTO_UNITARIO_ACTUALIZADO], [FECHA_ACTUALIZACION], [COSTO_UNITARIO_ACTUALIZADO_FINAL]";

            sqlIngresosAlmacenDetOrigen += " from [INGRESOS_ALMACEN_DETALLE]";
            System.out.println("sqlIngresosAlmacenDetOrigen:" + sqlIngresosAlmacenDetOrigen);
            Statement stIngresosAlmacenDetOrigen = conOrigen.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rsIngresosAlmacenDetOrigen = stIngresosAlmacenDetOrigen.executeQuery(sqlIngresosAlmacenDetOrigen);
            while (rsIngresosAlmacenDetOrigen.next()) {
                String codMaterial = rsIngresosAlmacenDetOrigen.getString(1);
                String codIngresoAlmacen = rsIngresosAlmacenDetOrigen.getString(2);
                String codSeccion = rsIngresosAlmacenDetOrigen.getString(3);
                String nroUnidadesEmpaque = rsIngresosAlmacenDetOrigen.getString(4);
                String cantTotalIngreso = rsIngresosAlmacenDetOrigen.getString(5);
                String cantTotalIngFisico = rsIngresosAlmacenDetOrigen.getString(6);
                String codUnidadMedida = rsIngresosAlmacenDetOrigen.getString(7);
                String precioTotalMaterial = rsIngresosAlmacenDetOrigen.getString(8);
                String precioUnitarioMaterial = rsIngresosAlmacenDetOrigen.getString(9);
                String costoUnitario = rsIngresosAlmacenDetOrigen.getString(10);
                String observacion = rsIngresosAlmacenDetOrigen.getString(11);
                String precioNeto = rsIngresosAlmacenDetOrigen.getString(12);
                String costoPromedio = rsIngresosAlmacenDetOrigen.getString(13);
                String costoUnitActualizado = rsIngresosAlmacenDetOrigen.getString(14);
                String fechaActualizacion = rsIngresosAlmacenDetOrigen.getString(15);
                String costoUnitactualizadofinal = rsIngresosAlmacenDetOrigen.getString(16);

                String sqlIngresosAlmacenDetDestino = "INSERT INTO [INGRESOS_ALMACEN_DETALLE] ([COD_MATERIAL], [COD_INGRESO_ALMACEN], [COD_SECCION], [NRO_UNIDADES_EMPAQUE], [CANT_TOTAL_INGRESO], ";
                sqlIngresosAlmacenDetDestino += "[CANT_TOTAL_INGRESO_FISICO], [COD_UNIDAD_MEDIDA], [PRECIO_TOTAL_MATERIAL], [PRECIO_UNITARIO_MATERIAL], [COSTO_UNITARIO], ";
                sqlIngresosAlmacenDetDestino += "[observacion], [PRECIO_NETO], [COSTO_PROMEDIO], [COSTO_UNITARIO_ACTUALIZADO],[COSTO_UNITARIO_ACTUALIZADO_FINAL], [FECHA_ACTUALIZACION])";

                sqlIngresosAlmacenDetDestino += " values(";
                sqlIngresosAlmacenDetDestino += " " + codMaterial + "," + codIngresoAlmacen + "," + codSeccion + "," + nroUnidadesEmpaque + "," + cantTotalIngreso + ",";
                sqlIngresosAlmacenDetDestino += " " + cantTotalIngFisico + "," + codUnidadMedida + "," + precioTotalMaterial + "," + precioUnitarioMaterial + "," + costoUnitario + ",";
                sqlIngresosAlmacenDetDestino += " '" + observacion + "'," + precioNeto + "," + costoPromedio + "," + costoUnitActualizado + "," + costoUnitactualizadofinal + ",";

                if (fechaActualizacion == null) {
                    sqlIngresosAlmacenDetDestino += " " + fechaActualizacion + ")";
                } else {
                    sqlIngresosAlmacenDetDestino += " '" + fechaActualizacion + "')";
                }

                System.out.println("sqlIngresosAlmacenDetDestino:" + sqlIngresosAlmacenDetDestino);
                Statement stIngresosAlmacenDetDestino = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                resultado = stIngresosAlmacenDetDestino.executeUpdate(sqlIngresosAlmacenDetDestino);
            }


            /*********************************** INGRESOS ALMACEN DETALLE ESTADO ********************************/
            sqlDelete = "delete from INGRESOS_ALMACEN_DETALLE_ESTADO ";
            System.out.println("sqlDelete:" + sqlDelete);
            stDelete = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            resultado = stDelete.executeUpdate(sqlDelete);
            String sqlIngresosAlmacenEstadoOrigen = "select [ETIQUETA], [COD_INGRESO_ALMACEN], [COD_MATERIAL], [COD_ESTADO_MATERIAL], [COD_EMPAQUE_SECUNDARIO_EXTERNO],";
            sqlIngresosAlmacenEstadoOrigen += " [CANTIDAD_PARCIAL], [CANTIDAD_RESTANTE], [FECHA_VENCIMIENTO], [LOTE_MATERIAL_PROVEEDOR], [LOTE_INTERNO], [FECHA_MANUFACTURA],";
            sqlIngresosAlmacenEstadoOrigen += " [FECHA_REANALISIS], [OBSERVACIONES], [OBS_CONTROL_CALIDAD], [fecha_vencimiento1], [fecha_reanalisis1], [fecha_vencimiento2], [fecha_reanalisis2]";
            sqlIngresosAlmacenEstadoOrigen += " from [INGRESOS_ALMACEN_DETALLE_ESTADO]";
            System.out.println("sqlIngresosAlmacenEstadoOrigen:" + sqlIngresosAlmacenEstadoOrigen);
            Statement stIngresosAlmacenEstadoOrigen = conOrigen.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rsIngresosAlmacenEstadoOrigen = stIngresosAlmacenEstadoOrigen.executeQuery(sqlIngresosAlmacenEstadoOrigen);
            while (rsIngresosAlmacenEstadoOrigen.next()) {
                String etiqueta = rsIngresosAlmacenEstadoOrigen.getString(1);
                String codIngresoAlmacen = rsIngresosAlmacenEstadoOrigen.getString(2);
                String codMaterial = rsIngresosAlmacenEstadoOrigen.getString(3);
                String codEstadoMaterial = rsIngresosAlmacenEstadoOrigen.getString(4);
                String codEmpaqueSecundario = rsIngresosAlmacenEstadoOrigen.getString(5);
                String cantParcial = rsIngresosAlmacenEstadoOrigen.getString(6);
                String cantRestante = rsIngresosAlmacenEstadoOrigen.getString(7);
                String fechaVencimiento = rsIngresosAlmacenEstadoOrigen.getString(8);
                String loteMaterialProveedor = rsIngresosAlmacenEstadoOrigen.getString(9);
                String loteInterno = rsIngresosAlmacenEstadoOrigen.getString(10);
                String fechaManufactura = rsIngresosAlmacenEstadoOrigen.getString(11);
                String fechaReanalisis = rsIngresosAlmacenEstadoOrigen.getString(12);
                String observaciones = rsIngresosAlmacenEstadoOrigen.getString(13);
                String obsControlCalidad = rsIngresosAlmacenEstadoOrigen.getString(14);
                String fechaVencimiento1 = rsIngresosAlmacenEstadoOrigen.getString(15);
                String fechaReanalisis1 = rsIngresosAlmacenEstadoOrigen.getString(16);
                String fechaVencimiento2 = rsIngresosAlmacenEstadoOrigen.getString(15);
                String fechaReanalisis2 = rsIngresosAlmacenEstadoOrigen.getString(16);

                String sqlIngresosAlmacenEstadoDestino = "INSERT INTO [INGRESOS_ALMACEN_DETALLE_ESTADO] ( [ETIQUETA], [COD_INGRESO_ALMACEN], [COD_MATERIAL], [COD_ESTADO_MATERIAL], [COD_EMPAQUE_SECUNDARIO_EXTERNO],";
                sqlIngresosAlmacenEstadoDestino += " [CANTIDAD_PARCIAL], [CANTIDAD_RESTANTE], [LOTE_MATERIAL_PROVEEDOR], [LOTE_INTERNO],";
                sqlIngresosAlmacenEstadoDestino += "  [OBSERVACIONES], [OBS_CONTROL_CALIDAD],[FECHA_VENCIMIENTO],[FECHA_REANALISIS], [FECHA_MANUFACTURA], [fecha_vencimiento1], [fecha_reanalisis1], [fecha_vencimiento2], [fecha_reanalisis2])";

                sqlIngresosAlmacenEstadoDestino += " values(";
                sqlIngresosAlmacenEstadoDestino += " " + etiqueta + "," + codIngresoAlmacen + "," + codMaterial + "," + codEstadoMaterial + "," + codEmpaqueSecundario + ",";
                sqlIngresosAlmacenEstadoDestino += " " + cantParcial + "," + cantRestante + ",'" + loteMaterialProveedor + "','" + loteInterno + "','" + observaciones + "',";
                sqlIngresosAlmacenEstadoDestino += " " + obsControlCalidad + ",";

                if (fechaVencimiento == null) {
                    sqlIngresosAlmacenEstadoDestino += " " + fechaVencimiento + ",";
                } else {
                    sqlIngresosAlmacenEstadoDestino += " '" + fechaVencimiento + "',";
                }
                if (fechaReanalisis == null) {
                    sqlIngresosAlmacenEstadoDestino += " " + fechaReanalisis + ",";
                } else {
                    sqlIngresosAlmacenEstadoDestino += " '" + fechaReanalisis + "',";
                }
                if (fechaManufactura == null) {
                    sqlIngresosAlmacenEstadoDestino += " " + fechaManufactura + ",";
                } else {
                    sqlIngresosAlmacenEstadoDestino += " '" + fechaManufactura + "',";
                }
                if (fechaVencimiento1 == null) {
                    sqlIngresosAlmacenEstadoDestino += " " + fechaVencimiento1 + ",";
                } else {
                    sqlIngresosAlmacenEstadoDestino += " '" + fechaVencimiento1 + "',";
                }
                if (fechaReanalisis1 == null) {
                    sqlIngresosAlmacenEstadoDestino += " " + fechaReanalisis1 + ",";
                } else {
                    sqlIngresosAlmacenEstadoDestino += " '" + fechaReanalisis1 + "',";
                }
                if (fechaVencimiento2 == null) {
                    sqlIngresosAlmacenEstadoDestino += " " + fechaVencimiento2 + ",";
                } else {
                    sqlIngresosAlmacenEstadoDestino += " '" + fechaVencimiento2 + "',";
                }
                if (fechaReanalisis2 == null) {
                    sqlIngresosAlmacenEstadoDestino += " " + fechaReanalisis2 + ")";
                } else {
                    sqlIngresosAlmacenEstadoDestino += " '" + fechaReanalisis2 + "')";
                }

                System.out.println("sqlIngresosAlmacenEstadoDestino:" + sqlIngresosAlmacenEstadoDestino);
                Statement stIngresosAlmacenEstadoDestino = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                resultado = stIngresosAlmacenEstadoDestino.executeUpdate(sqlIngresosAlmacenEstadoDestino);
            }


            /*********************************** SALIDAS ALMACEN ********************************/
           sqlDelete = "delete from SALIDAS_ALMACEN_TRIGGER ";
            System.out.println("sqlDelete:" + sqlDelete);
           stDelete = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            resultado = stDelete.executeUpdate(sqlDelete);
            sqlDelete = "delete from SALIDAS_ALMACEN ";
            System.out.println("sqlDelete:" + sqlDelete);
            stDelete = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            resultado = stDelete.executeUpdate(sqlDelete);
            
            String sqlSalidasAlmacenOrigen = "SELECT  [COD_GESTION], [COD_SALIDA_ALMACEN], [COD_ORDEN_PESADA], [COD_FORM_SALIDA], [COD_PROD], [COD_TIPO_SALIDA_ALMACEN], ";
            sqlSalidasAlmacenOrigen += " [COD_AREA_EMPRESA], [NRO_SALIDA_ALMACEN], [FECHA_SALIDA_ALMACEN], [OBS_SALIDA_ALMACEN], [ESTADO_SISTEMA], [COD_ALMACEN],";
            sqlSalidasAlmacenOrigen += " [COD_ORDEN_COMPRA], [COD_PERSONAL], [COD_ESTADO_SALIDA_ALMACEN], [COD_LOTE_PRODUCCION], [COD_ESTADO_SALIDA_COSTO],";
            sqlSalidasAlmacenOrigen += " [cod_prod_ant], [orden_trabajo] FROM [SALIDAS_ALMACEN]";
            System.out.println("sqlSalidasAlmacenOrigen:" + sqlSalidasAlmacenOrigen);
            Statement stSalidasAlmacenOrigen = conOrigen.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rsSalidasAlmacenOrigen = stSalidasAlmacenOrigen.executeQuery(sqlSalidasAlmacenOrigen);
            while (rsSalidasAlmacenOrigen.next()) {
                String codGestion = rsSalidasAlmacenOrigen.getString(1);
                String codSalidaAlmacen = rsSalidasAlmacenOrigen.getString(2);
                String codOrdenPesada = rsSalidasAlmacenOrigen.getString(3);
                String codFormSalida = rsSalidasAlmacenOrigen.getString(4);
                String codProd = rsSalidasAlmacenOrigen.getString(5);
                String codTipoSalidaAlmacen = rsSalidasAlmacenOrigen.getString(6);
                String codAreaEmpresa = rsSalidasAlmacenOrigen.getString(7);
                String nroSalidaAlmacen = rsSalidasAlmacenOrigen.getString(8);
                String fechaSalidaAlmacen = rsSalidasAlmacenOrigen.getString(9);
                String obsSalidaAlmacen = rsSalidasAlmacenOrigen.getString(10);
                String estadoSistema = rsSalidasAlmacenOrigen.getString(11);
                String codAlmacen = rsSalidasAlmacenOrigen.getString(12);
                String codOrdenCompra = rsSalidasAlmacenOrigen.getString(13);
                String codpersonal = rsSalidasAlmacenOrigen.getString(14);
                String codEstadoSalidaAlmacen = rsSalidasAlmacenOrigen.getString(15);
                String codLoteProduccion = rsSalidasAlmacenOrigen.getString(16);
                String codEstadoSalidaCosto = rsSalidasAlmacenOrigen.getString(17);
                String codProdAnterior = rsSalidasAlmacenOrigen.getString(18);
                String ordenTrabajo = rsSalidasAlmacenOrigen.getString(19);

                String sqlSalidasAlmacenDestino = "INSERT INTO [SALIDAS_ALMACEN] ([COD_GESTION], [COD_SALIDA_ALMACEN], [COD_ORDEN_PESADA], [COD_FORM_SALIDA], [COD_PROD],";
                sqlSalidasAlmacenDestino += " [COD_TIPO_SALIDA_ALMACEN], [COD_AREA_EMPRESA], [NRO_SALIDA_ALMACEN], [FECHA_SALIDA_ALMACEN], [OBS_SALIDA_ALMACEN],";
                sqlSalidasAlmacenDestino += " [ESTADO_SISTEMA], [COD_ALMACEN], [COD_ORDEN_COMPRA], [COD_PERSONAL], [COD_ESTADO_SALIDA_ALMACEN], [COD_LOTE_PRODUCCION],";
                sqlSalidasAlmacenDestino += " [COD_ESTADO_SALIDA_COSTO], [cod_prod_ant], [orden_trabajo])";
                sqlSalidasAlmacenDestino += " values(";
                sqlSalidasAlmacenDestino += " " + codGestion + "," + codSalidaAlmacen + "," + codOrdenPesada + "," + codFormSalida + "," + codProd + ",";
                sqlSalidasAlmacenDestino += " " + codTipoSalidaAlmacen + "," + codAreaEmpresa + "," + nroSalidaAlmacen + ",";
                if (fechaSalidaAlmacen == null) {
                    sqlSalidasAlmacenDestino += " " + fechaSalidaAlmacen + ",";
                } else {
                    sqlSalidasAlmacenDestino += " '" + fechaSalidaAlmacen + "',";
                }
                sqlSalidasAlmacenDestino += " '" + obsSalidaAlmacen + "'," + estadoSistema + "," + codAlmacen + "," + codOrdenCompra + "," + codpersonal + "," + codEstadoSalidaAlmacen + ",";
                sqlSalidasAlmacenDestino += " '" + codLoteProduccion + "'," + codEstadoSalidaCosto + "," + codProdAnterior + ",'" + ordenTrabajo + "')";

                System.out.println("sqlSalidasAlmacenDestino:" + sqlSalidasAlmacenDestino);
                Statement stSalidasAlmacenDestino = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                resultado = stSalidasAlmacenDestino.executeUpdate(sqlSalidasAlmacenDestino);
            }

            /*********************************** SALIDAS ALMACEN DETALLE ********************************/
           sqlDelete = "delete from SALIDAS_ALMACEN_DETALLE ";
            System.out.println("sqlDelete:" + sqlDelete);
            stDelete = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            resultado = stDelete.executeUpdate(sqlDelete);

            String sqlSalidasAlmacenDetOrigen = "SELECT   [COD_SALIDA_ALMACEN], [COD_MATERIAL], [CANTIDAD_SALIDA_ALMACEN], [COD_UNIDAD_MEDIDA], [COD_ESTADO_MATERIAL]";
            sqlSalidasAlmacenDetOrigen += " FROM [SALIDAS_ALMACEN_DETALLE]";
            System.out.println("sqlSalidasAlmacenDetOrigen:" + sqlSalidasAlmacenDetOrigen);
            Statement stSalidasAlmacenDetOrigen = conOrigen.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rsSalidasAlmacenDetOrigen = stSalidasAlmacenDetOrigen.executeQuery(sqlSalidasAlmacenDetOrigen);
            while (rsSalidasAlmacenDetOrigen.next()) {
                String codSalidaAlmacen = rsSalidasAlmacenDetOrigen.getString(1);
                String codMaterial = rsSalidasAlmacenDetOrigen.getString(2);
                String cantSalidaAlmacen = rsSalidasAlmacenDetOrigen.getString(3);
                String codUnidadMedida = rsSalidasAlmacenDetOrigen.getString(4);
                String codEstadoMaterial = rsSalidasAlmacenDetOrigen.getString(5);


                String sqlSalidasAlmacenDetDestino = "INSERT INTO [SALIDAS_ALMACEN_DETALLE] ([COD_SALIDA_ALMACEN], [COD_MATERIAL], [CANTIDAD_SALIDA_ALMACEN], [COD_UNIDAD_MEDIDA], [COD_ESTADO_MATERIAL])";
                sqlSalidasAlmacenDetDestino += " values(";
                sqlSalidasAlmacenDetDestino += " " + codSalidaAlmacen + "," + codMaterial + "," + cantSalidaAlmacen + "," + codUnidadMedida + "," + codEstadoMaterial + ")";

                System.out.println("sqlSalidasAlmacenDetDestino:" + sqlSalidasAlmacenDetDestino);
                Statement stSalidasAlmacenDetDestino = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                resultado = stSalidasAlmacenDetDestino.executeUpdate(sqlSalidasAlmacenDetDestino);
            }
            /*********************************** SALIDAS ALMACEN DETALLE INGRESO ********************************/
            sqlDelete = "delete from SALIDAS_ALMACEN_DETALLE_INGRESO ";
            System.out.println("sqlDelete:" + sqlDelete);
            stDelete = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            resultado = stDelete.executeUpdate(sqlDelete);




            String sqlSalidasAlmacenIngresoOrigen = "SELECT  [COD_SALIDA_ALMACEN], [COD_MATERIAL], [COD_INGRESO_ALMACEN], [ETIQUETA], [COSTO_SALIDA], [FECHA_VENCIMIENTO], [CANTIDAD], [COSTO_SALIDA_ACTUALIZADO], [FECHA_ACTUALIZACION], [COSTO_SALIDA_ACTUALIZADO_FINAL]";
            sqlSalidasAlmacenIngresoOrigen += " FROM [SALIDAS_ALMACEN_DETALLE_INGRESO]";
            System.out.println("sqlSalidasAlmacenIngresoOrigen:" + sqlSalidasAlmacenIngresoOrigen);
            Statement stSalidasAlmacenIngresoOrigen = conOrigen.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rsSalidasAlmacenIngresoOrigen = stSalidasAlmacenIngresoOrigen.executeQuery(sqlSalidasAlmacenIngresoOrigen);
            while (rsSalidasAlmacenIngresoOrigen.next()) {
                String codSalidaAlmacen = rsSalidasAlmacenIngresoOrigen.getString(1);
                String codMaterial = rsSalidasAlmacenIngresoOrigen.getString(2);
                String codingresoAlmacen = rsSalidasAlmacenIngresoOrigen.getString(3);
                String etiqueta = rsSalidasAlmacenIngresoOrigen.getString(4);
                String costoSalida = rsSalidasAlmacenIngresoOrigen.getString(5);
                String fechaVencimiento = rsSalidasAlmacenIngresoOrigen.getString(6);
                String cantidad = rsSalidasAlmacenIngresoOrigen.getString(7);
                String costoSalidaActualizado = rsSalidasAlmacenIngresoOrigen.getString(8);
                String fechaActualizacion = rsSalidasAlmacenIngresoOrigen.getString(9);
                String costoSalidaActualizadoFinal = rsSalidasAlmacenIngresoOrigen.getString(10);



                String sqlSalidasAlmacenIngresoDestino = "INSERT INTO [SALIDAS_ALMACEN_DETALLE_INGRESO] ([COD_SALIDA_ALMACEN], [COD_MATERIAL], [COD_INGRESO_ALMACEN], [ETIQUETA], [COSTO_SALIDA],";
                sqlSalidasAlmacenIngresoDestino += "   [CANTIDAD], [COSTO_SALIDA_ACTUALIZADO],[COSTO_SALIDA_ACTUALIZADO_FINAL], [FECHA_ACTUALIZACION], [FECHA_VENCIMIENTO])";
                sqlSalidasAlmacenIngresoDestino += " values(";
                sqlSalidasAlmacenIngresoDestino += " " + codSalidaAlmacen + "," + codMaterial + "," + codingresoAlmacen + "," + etiqueta + "," + costoSalida + ",";
                sqlSalidasAlmacenIngresoDestino += " " + cantidad + "," + costoSalidaActualizado + "," + costoSalidaActualizadoFinal + ",";
                if (fechaActualizacion == null) {
                    sqlSalidasAlmacenIngresoDestino += " " + fechaActualizacion + ",";
                } else {
                    sqlSalidasAlmacenIngresoDestino += " '" + fechaActualizacion + "',";
                }
                if (fechaVencimiento == null) {
                    sqlSalidasAlmacenIngresoDestino += " " + fechaVencimiento + ")";
                } else {
                    sqlSalidasAlmacenIngresoDestino += " '" + fechaVencimiento + "')";
                }
                System.out.println("sqlSalidasAlmacenIngresoDestino:" + sqlSalidasAlmacenIngresoDestino);
                Statement stSalidasAlmacenIngresoDestino = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                resultado = stSalidasAlmacenIngresoDestino.executeUpdate(sqlSalidasAlmacenIngresoDestino);
            }

            /*********************************** DEVOLUCIONES ********************************/
            sqlDelete = "delete from DEVOLUCIONES_TRIGGER ";
            System.out.println("sqlDelete:" + sqlDelete);
            stDelete = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            resultado = stDelete.executeUpdate(sqlDelete);
            sqlDelete = "delete from DEVOLUCIONES ";
            System.out.println("sqlDelete:" + sqlDelete);
            stDelete = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            resultado = stDelete.executeUpdate(sqlDelete);


            String sqlDevolucionesOrigen = "SELECT  [COD_DEVOLUCION], [NRO_DEVOLUCION], [COD_FORMULARIO_DEV], [COD_ALMACEN], [COD_SALIDA_ALMACEN], [COD_GESTION], [COD_ESTADO_DEVOLUCION], [ESTADO_SISTEMA], [OBS_DEVOLUCION]";
            sqlDevolucionesOrigen += " FROM [DEVOLUCIONES]";
            System.out.println("sqlDevolucionesOrigen:" + sqlDevolucionesOrigen);
            Statement stDevolucionesOrigen = conOrigen.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rsDevolucionesOrigen = stDevolucionesOrigen.executeQuery(sqlDevolucionesOrigen);
            while (rsDevolucionesOrigen.next()) {
                String codDevolucion = rsDevolucionesOrigen.getString(1);
                String nroDevolucion = rsDevolucionesOrigen.getString(2);
                String codFormularioDev = rsDevolucionesOrigen.getString(3);
                String codAlmacen = rsDevolucionesOrigen.getString(4);
                String codSalidaAlmacen = rsDevolucionesOrigen.getString(5);
                String codGestion = rsDevolucionesOrigen.getString(6);
                String codEstadoDevolucion = rsDevolucionesOrigen.getString(7);
                String estadoSistema = rsDevolucionesOrigen.getString(8);
                String obsDevolucion = rsDevolucionesOrigen.getString(9);



                String sqlDevolucionesDestino = "INSERT INTO [DEVOLUCIONES] ([COD_DEVOLUCION], [NRO_DEVOLUCION], [COD_FORMULARIO_DEV], [COD_ALMACEN], [COD_SALIDA_ALMACEN],";
                sqlDevolucionesDestino += " [COD_GESTION], [COD_ESTADO_DEVOLUCION], [ESTADO_SISTEMA], [OBS_DEVOLUCION])";
                sqlDevolucionesDestino += " values(";
                sqlDevolucionesDestino += " " + codDevolucion + "," + nroDevolucion + "," + codFormularioDev + "," + codAlmacen + "," + codSalidaAlmacen + ",";
                sqlDevolucionesDestino += " " + codGestion + "," + codEstadoDevolucion + "," + estadoSistema + ",'" + obsDevolucion + "')";

                System.out.println("sqlDevolucionesDestino:" + sqlDevolucionesDestino);
                Statement stDevolucionesDestino = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                resultado = stDevolucionesDestino.executeUpdate(sqlDevolucionesDestino);
            }
            /*********************************** DEVOLUCIONES DETALLE ********************************/
            sqlDelete = "delete from DEVOLUCIONES_DETALLE ";
            System.out.println("sqlDelete:" + sqlDelete);
            stDelete = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            resultado = stDelete.executeUpdate(sqlDelete);


            String sqlDevolucionesDetalleOrigen = "SELECT  [COD_DEVOLUCION], [COD_MATERIAL], [CANTIDAD_DEVUELTA], [COD_UNIDAD_MEDIDA]";

            sqlDevolucionesDetalleOrigen += " FROM [DEVOLUCIONES_DETALLE]";
            System.out.println("sqlDevolucionesDetalleOrigen:" + sqlDevolucionesDetalleOrigen);
            Statement stDevolucionesDetalleOrigen = conOrigen.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rsDevolucionesDetalleOrigen = stDevolucionesDetalleOrigen.executeQuery(sqlDevolucionesDetalleOrigen);
            while (rsDevolucionesOrigen.next()) {
                String codDevolucion = rsDevolucionesOrigen.getString(1);
                String codMaterial = rsDevolucionesOrigen.getString(2);
                String cantidadDevuelta = rsDevolucionesOrigen.getString(3);
                String codUnidadMedida = rsDevolucionesOrigen.getString(4);


                String sqlDevolucionesDetalleDestino = "INSERT INTO [DEVOLUCIONES_DETALLE] ([COD_DEVOLUCION], [COD_MATERIAL], [CANTIDAD_DEVUELTA], [COD_UNIDAD_MEDIDA])";
                sqlDevolucionesDetalleDestino += " values(";
                sqlDevolucionesDetalleDestino += " " + codDevolucion + "," + codMaterial + "," + cantidadDevuelta + "," + codUnidadMedida + ")";

                System.out.println("sqlDevolucionesDetalleDestino:" + sqlDevolucionesDetalleDestino);
                Statement stDevolucionesDetalleDestino = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                resultado = stDevolucionesDetalleDestino.executeUpdate(sqlDevolucionesDetalleDestino);
            }
            /*********************************** DEVOLUCIONES DETALLE ********************************/
            sqlDelete = "delete from DEVOLUCIONES_DETALLE_ETIQUETAS ";
            System.out.println("sqlDelete:" + sqlDelete);
            stDelete = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            resultado = stDelete.executeUpdate(sqlDelete);


            String sqlDevolucionesDetalleEtiquetasOrigen = "SELECT [COD_DEVOLUCION], [COD_INGRESO_ALMACEN], [COD_MATERIAL], [ETIQUETA], [CANTIDAD_DEVUELTA], [CANTIDAD_FALLADOS]";

            sqlDevolucionesDetalleEtiquetasOrigen += " FROM [DEVOLUCIONES_DETALLE_ETIQUETAS]";
            System.out.println("sqlDevolucionesDetalleEtiquetasOrigen:" + sqlDevolucionesDetalleEtiquetasOrigen);
            Statement stDevolucionesDetalleEtiquetasOrigen = conOrigen.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rsDevolucionesDetalleEtiquetasOrigen = stDevolucionesDetalleOrigen.executeQuery(sqlDevolucionesDetalleEtiquetasOrigen);
            while (rsDevolucionesDetalleEtiquetasOrigen.next()) {
                String codDevolucion = rsDevolucionesDetalleEtiquetasOrigen.getString(1);
                String codIngresoAlmacen = rsDevolucionesDetalleEtiquetasOrigen.getString(2);
                String codMaterial = rsDevolucionesDetalleEtiquetasOrigen.getString(3);
                String etiqueta = rsDevolucionesDetalleEtiquetasOrigen.getString(4);
                String cantDevuelta = rsDevolucionesDetalleEtiquetasOrigen.getString(5);
                String cantidadFallados = rsDevolucionesDetalleEtiquetasOrigen.getString(6);

                String sqlDevolucionesDetalleDestino = "INSERT INTO [DEVOLUCIONES_DETALLE_ETIQUETAS] ([COD_DEVOLUCION], [COD_INGRESO_ALMACEN], [COD_MATERIAL], [ETIQUETA], [CANTIDAD_DEVUELTA], [CANTIDAD_FALLADOS])";
                sqlDevolucionesDetalleDestino += " values(";
                sqlDevolucionesDetalleDestino += " " + codDevolucion + "," + codIngresoAlmacen + "," + codMaterial + "," + etiqueta + ",";
sqlDevolucionesDetalleDestino += " " + cantDevuelta + "," + cantidadFallados + ")";
                System.out.println("DEVOLUCIONES_DETALLE_ETIQUETAS:" + sqlDevolucionesDetalleDestino);
                Statement stDevolucionesDetalleDestino = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                resultado = stDevolucionesDetalleDestino.executeUpdate(sqlDevolucionesDetalleDestino);
            }

        /*

        String sqlBorrarIngresos = "select cod_ingresoventas from ingresos_ventas where cod_almacen_venta in (select cod_almacen_venta from almacenes_ventas where cod_area_empresa=" + codAreaEmpresa + ") and FECHA_INGRESOVENTAS>='" + fechaDesde + " 00:00:00'   and FECHA_INGRESOVENTAS<='" + fechaHasta + "  23:59:59'";
        System.out.println("sqlBorrarIngresos:" + sqlBorrarIngresos);
        Statement stBorrarIngresos = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rsBorrarIngresos = stBorrarIngresos.executeQuery(sqlBorrarIngresos);
        while (rsBorrarIngresos.next()) {
        int codIngreso = rsBorrarIngresos.getInt(1);
        //borramos detalle
        String sqlDelete = "delete from INGRESOS_DETALLEVENTAS where cod_ingresoventas=" + codIngreso;
        Statement stDelete = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        int resultado = stDelete.executeUpdate(sqlDelete);
        //System.out.println("resultado:"+resultado);
        //borramos cabecera
        sqlDelete = "delete from ingresos_ventas where cod_ingresoventas=" + codIngreso;
        stDelete.executeUpdate(sqlDelete);
        stDelete.close();
        }
        rsBorrarIngresos.close();
        stBorrarIngresos.close();
        //BORRAR SALIDAS
        String sqlBorrarSalidas = "select cod_salidaventa from salidas_ventas where cod_almacen_venta in(select cod_almacen_venta from almacenes_ventas where cod_area_empresa=" + codAreaEmpresa + ") and FECHA_SALIDAVENTA >='" + fechaDesde + " 00:00:00'    and FECHA_SALIDAVENTA<='" + fechaHasta + " 23:59:59'";
        Statement stBorrarSalidas = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rsBorrarSalidas = stBorrarSalidas.executeQuery(sqlBorrarSalidas);
        while (rsBorrarSalidas.next()) {
        int codSalida = rsBorrarSalidas.getInt(1);
        //borramos detalle
        String sqlDelete = "delete from salidas_detalleventas where cod_salidaventas=" + codSalida;
        Statement stDelete = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        int resultado = stDelete.executeUpdate(sqlDelete);
        //borramos ventas_pedidos
        sqlDelete = "delete from ventas_pedidos where cod_salidaventa=" + codSalida;
        resultado = stDelete.executeUpdate(sqlDelete);
        //borramos cabecera
        sqlDelete = "delete from salidas_ventas where cod_salidaventa=" + codSalida;
        resultado = stDelete.executeUpdate(sqlDelete);
        //System.out.println("resultado:salidas:"+resultado);
        stDelete.close();
        }

        rsBorrarSalidas.close();
        stBorrarSalidas.close();

        //BORRAR PEDIDOS
        String sqlBorrarPedidos = "select cod_pedido from pedidos where cod_area_empresa=" + codAreaEmpresa + " and FECHA_PEDIDO >='" + fechaDesde + " 00:00:00'    and FECHA_PEDIDO<='" + fechaHasta + " 23:59:59'";
        Statement stBorrarPedidos = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rsBorrarPedidos = stBorrarPedidos.executeQuery(sqlBorrarPedidos);
        while (rsBorrarPedidos.next()) {
        int codpedido = rsBorrarPedidos.getInt(1);
        //borramos detalle
        String sqlDelete = "delete from pedidos_detalle where cod_pedido=" + codpedido;
        Statement stDelete = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        int resultado = stDelete.executeUpdate(sqlDelete);
        sqlDelete = "delete from pedidos where cod_pedido=" + codpedido;
        stDelete.executeUpdate(sqlDelete);
        }
        rsBorrarPedidos.close();
        stBorrarPedidos.close();
        //BORRAR INGRESOS MATERIAL PROMOCIONAL
        String sqlDelIngMat = "select cod_ingreso_matpromocional from ingresos_matpromocional";
        sqlDelIngMat += "      where cod_almacen_matpromocional in(select cod_almacen_matpromocional from ALMACEN_MATPROMOCIONAL where COD_AREA_EMPRESA=" + codAreaEmpresa + ")";
        sqlDelIngMat += "    and   fecha_ingreso_matpromocional>='" + fechaDesde + " 00:00:00'";
        sqlDelIngMat += "    and   fecha_ingreso_matpromocional<='" + fechaHasta + " 23:59:59'";
        Statement stBorrarIngMat = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rsBorrarIngMat = stBorrarIngMat.executeQuery(sqlDelIngMat);
        while (rsBorrarIngMat.next()) {
        int cod_ingreso_matpromocional = rsBorrarIngMat.getInt(1);
        //borramos detalle
        String sqlDelete = "delete from ingresos_detallematpromocional where cod_ingreso_matpromocional=" + cod_ingreso_matpromocional;
        Statement stDelete = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        int resultado = stDelete.executeUpdate(sqlDelete);
        Statement stDeleteSalMat = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        stDeleteSalMat.executeUpdate("delete from ingresos_matpromocional where cod_ingreso_matpromocional=" + cod_ingreso_matpromocional);
        }
        rsBorrarIngMat.close();
        stBorrarIngMat.close();
        //BORRAR SALIDAS MATERIAL PROMOCIONAL
        String sqlDelSalMat = "select cod_salida_matpromocional from salidas_matpromocional";
        sqlDelSalMat += "      where cod_almacen_matpromocional in(select cod_almacen_matpromocional from ALMACEN_MATPROMOCIONAL where COD_AREA_EMPRESA=" + codAreaEmpresa + ")";
        sqlDelSalMat += "    and   fecha_salida_matpromocional>='" + fechaDesde + " 00:00:00'";
        sqlDelSalMat += "    and   fecha_salida_matpromocional<='" + fechaHasta + " 23:59:59'";
        Statement stBorrarSalMat = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rsBorrarSalMat = stBorrarSalMat.executeQuery(sqlDelSalMat);
        while (rsBorrarSalMat.next()) {
        int cod_salida_matpromocional = rsBorrarSalMat.getInt(1);
        //borramos detalle
        String sqlDelete = "delete from salidas_detallematerialpromocional where cod_salida_matpromocional=" + cod_salida_matpromocional;
        Statement stDelete = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        int resultado = stDelete.executeUpdate(sqlDelete);
        Statement stDeleteSalMat = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        stDeleteSalMat.executeUpdate("delete from salidas_matpromocional where cod_salida_matpromocional=" + cod_salida_matpromocional);

        }
        rsBorrarSalMat.close();
        stBorrarSalMat.close();


        //FIN BORRAR INGRESOS Y SALIDAS

        //BORRAMOS COBRANZAS
        String sqlBorrarCobranzas = "select cod_cobranza from cobranzas where cod_area_empresa=" + codAreaEmpresa + " and FECHA_COBRANZA>='" + fechaDesde + " 00:00:00'  and FECHA_COBRANZA<='" + fechaHasta + " 23:59:59'";
        Statement stBorrarCobranzas = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rsBorrarCobranzas = stBorrarCobranzas.executeQuery(sqlBorrarCobranzas);
        while (rsBorrarCobranzas.next()) {
        int codCobranza = rsBorrarCobranzas.getInt(1);
        String sqlDelete = "delete from cobranzas_detalle where cod_cobranza=" + codCobranza;
        Statement stDelete = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        stDelete.executeUpdate(sqlDelete);
        //borramos cobranzas
        sqlDelete = "delete from cobranzas where cod_cobranza=" + codCobranza;
        stDelete.executeUpdate(sqlDelete);

        }
        rsBorrarCobranzas.close();
        stBorrarCobranzas.close();


        /***********************************************************   REGISTRANDO INGRESOS Y SALIDAS,COBRANZAS PEDIDOS MATERIAL PROMOCIONAL **********************/
        //INSERTANDO INGRESOS MATERIAL PROMOCIONAL
         /*   String sqlIngMat = "";
        sqlIngMat += "select  [cod_ingreso_matpromocional], [cod_almacen_matpromocional], [cod_almacen_matpromocionalorigen], [cod_gestion], [cod_estado_ingresomatpromocional], [fecha_ingreso_matpromocional], [nro_doc_matpromocional], [nro_ingreso_matpromocional], [obs_ingreso_matpromocional]";
        sqlIngMat += " from ingresos_matpromocional";
        sqlIngMat += "      where cod_almacen_matpromocional in(select cod_almacen_matpromocional from ALMACEN_MATPROMOCIONAL where COD_AREA_EMPRESA=" + codAreaEmpresa + ")";
        sqlIngMat += "    and   fecha_ingreso_matpromocional>='" + fechaDesde + " 00:00:00'";
        sqlIngMat += "    and   fecha_ingreso_matpromocional<='" + fechaHasta + " 23:59:59'";

        Statement ingresosMat = conOrigen.createStatement();
        ResultSet rsingresosMat = ingresosMat.executeQuery(sqlIngMat);
        while (rsingresosMat.next()) {
        String cod_ingreso_matpromocional = rsingresosMat.getString(1);
        String cod_almacen_matpromocional = rsingresosMat.getString(2);
        String cod_almacen_matpromocionalorigen = rsingresosMat.getString(3);
        String cod_gestion = rsingresosMat.getString(4);
        String cod_estado_ingresomatpromocional = rsingresosMat.getString(5);
        String fecha_ingreso_matpromocional = rsingresosMat.getString(6);

        String nro_doc_matpromocional = rsingresosMat.getString(7);
        String nro_ingreso_matpromocional = rsingresosMat.getString(8);
        String obs_ingreso_matpromocional = rsingresosMat.getString(9);
        String sqlCorrelativo = "select max(cod_ingreso_matpromocional)+1 from ingresos_matpromocional";
        Statement stCorrelativo = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rsCorrelativo = stCorrelativo.executeQuery(sqlCorrelativo);
        rsCorrelativo.next();
        int cod_ingreso_matpromocionalcorrelativo = rsCorrelativo.getInt(1);
        rsCorrelativo.close();
        stCorrelativo.close();

        String sqlInsertarIngresosMat = "insert into  ingresos_matpromocional( [cod_ingreso_matpromocional], [cod_almacen_matpromocional], [cod_almacen_matpromocionalorigen], [cod_gestion], [cod_estado_ingresomatpromocional], [fecha_ingreso_matpromocional], [nro_doc_matpromocional], [nro_ingreso_matpromocional], [obs_ingreso_matpromocional])values(";
        sqlInsertarIngresosMat += cod_ingreso_matpromocionalcorrelativo + "," + cod_almacen_matpromocional + "," + cod_almacen_matpromocionalorigen + "," + cod_gestion + "," + cod_estado_ingresomatpromocional + ",'" + fecha_ingreso_matpromocional + "'," + nro_doc_matpromocional + "," + nro_ingreso_matpromocional + ",'" + obs_ingreso_matpromocional + "')";

        Statement stInsertSalidas = conDestino.createStatement();
        stInsertSalidas.executeUpdate(sqlInsertarIngresosMat);
        //System.out.println(sqlInsertarIngresosMat);

        String sqlSelectSalidaDetalle = "select  [cod_ingreso_matpromocional], [cod_matpromocional], [cant_unitaria_ingreso], [cod_tipoobsingreso], [cantidad_restante_matpromocional], [obs_ingresodetalle_matpromocional] ";
        sqlSelectSalidaDetalle += "     from [ingresos_detallematpromocional]   where  cod_ingreso_matpromocional=" + cod_ingreso_matpromocional;
        Statement stSelectSalidaDetalle = conOrigen.createStatement();
        ResultSet rsSelectSalidaDetalle = stSelectSalidaDetalle.executeQuery(sqlSelectSalidaDetalle);
        while (rsSelectSalidaDetalle.next()) {
        String cod_matpromocional = rsSelectSalidaDetalle.getString(2);
        String cant_unitaria_ingreso = rsSelectSalidaDetalle.getString(3);
        String cod_tipoobsingreso = rsSelectSalidaDetalle.getString(4);
        String cantidad_restante_matpromocional = rsSelectSalidaDetalle.getString(5);
        String obs_ingresodetalle_matpromocional = rsSelectSalidaDetalle.getString(6);
        String sqlInsertSalidaDetalle = "insert into ingresos_detallematpromocional([cod_ingreso_matpromocional], [cod_matpromocional], [cant_unitaria_ingreso], [cod_tipoobsingreso], [cantidad_restante_matpromocional], [obs_ingresodetalle_matpromocional])values(";
        sqlInsertSalidaDetalle += cod_ingreso_matpromocionalcorrelativo + "," + cod_matpromocional + "," + cant_unitaria_ingreso + "," + cod_tipoobsingreso + "," + cantidad_restante_matpromocional + ",'" + obs_ingresodetalle_matpromocional + "')";
        Statement stInsertSalidaDetalle = conDestino.createStatement();
        //System.out.println(sqlInsertSalidaDetalle);
        stInsertSalidaDetalle.executeUpdate(sqlInsertSalidaDetalle);
        //System.out.println("sqlInsertSalidaDetalle:"+sqlInsertSalidaDetalle);
        }
        rsSelectSalidaDetalle.close();
        stSelectSalidaDetalle.close();

        }
        rsingresosMat.close();
        ingresosMat.close();



        //INSERTANDO SALIDAS MATERIAL PROMOCIONAL


        String sqlMat = "";
        sqlMat += "select [cod_salida_matpromocional], [cod_almacen_matpromocional], [cod_almacen_matpromocionaldestino], [cod_gestion], [cod_cliente], [cod_estado_salidamatpromocional], [fecha_salida_matpromocional], [nro_salida_matpromocional], [obs_salida_matpromocional] ";
        sqlMat += " from  salidas_matpromocional ";
        sqlMat += "      where cod_almacen_matpromocional in(select cod_almacen_matpromocional from ALMACEN_MATPROMOCIONAL where COD_AREA_EMPRESA=" + codAreaEmpresa + ")";
        sqlMat += "    and   fecha_salida_matpromocional>='" + fechaDesde + " 00:00:00'";
        sqlMat += "    and   fecha_salida_matpromocional<='" + fechaHasta + " 23:59:59'";
        //System.out.println(sqlMat);
        Statement salidasMat = conOrigen.createStatement();
        ResultSet rssalidasMat = salidasMat.executeQuery(sqlMat);
        while (rssalidasMat.next()) {
        String cod_salida_matpromocional = rssalidasMat.getString(1);
        String cod_almacen_matpromocional = rssalidasMat.getString(2);
        String cod_almacen_matpromocionaldestino = rssalidasMat.getString(3);
        String cod_gestion = rssalidasMat.getString(4);
        String cod_cliente = rssalidasMat.getString(5);
        String cod_estado_salidamatpromocional = rssalidasMat.getString(6);
        String fecha_salida_matpromocional = rssalidasMat.getString(7);
        String nro_salida_matpromocional = rssalidasMat.getString(8);
        String obs_salida_matpromocional = rssalidasMat.getString(9);

        String sqlCorrelativo = "select max(cod_salida_matpromocional)+1 from salidas_matpromocional";
        Statement stCorrelativo = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rsCorrelativo = stCorrelativo.executeQuery(sqlCorrelativo);
        rsCorrelativo.next();
        int cod_salida_matpromocionalcorrelativo = rsCorrelativo.getInt(1);
        rsCorrelativo.close();
        stCorrelativo.close();

        String sqlInsertarSalidasMat = "insert into  salidas_matpromocional  ([cod_salida_matpromocional], [cod_almacen_matpromocional], [cod_almacen_matpromocionaldestino], [cod_gestion], [cod_cliente], [cod_estado_salidamatpromocional], [fecha_salida_matpromocional], [nro_salida_matpromocional], [obs_salida_matpromocional],[obs_temporal])values(";
        sqlInsertarSalidasMat += cod_salida_matpromocionalcorrelativo + "," + cod_almacen_matpromocional + "," + cod_almacen_matpromocionaldestino + "," + cod_gestion + "," + cod_cliente + "," + cod_estado_salidamatpromocional + ",'" + fecha_salida_matpromocional + "'," + nro_salida_matpromocional + ",'" + obs_salida_matpromocional + "','" + cod_salida_matpromocional + "')";

        //System.out.println(sqlInsertarSalidasMat);
        Statement stInsertSalidas = conDestino.createStatement();
        stInsertSalidas.executeUpdate(sqlInsertarSalidasMat);
        //System.out.println(sqlInsertarSalidasMat);

        String sqlSelectSalidaDetalle = "select    [cod_salida_matpromocional], [cod_matpromocional], [cantidad_salida_matpromocional], [obs_salidadetalle_matpromocional] from [salidas_detallematerialpromocional]  ";
        sqlSelectSalidaDetalle += "        where  cod_salida_matpromocional=" + cod_salida_matpromocional;
        Statement stSelectSalidaDetalle = conOrigen.createStatement();
        ResultSet rsSelectSalidaDetalle = stSelectSalidaDetalle.executeQuery(sqlSelectSalidaDetalle);
        while (rsSelectSalidaDetalle.next()) {
        String cod_matpromocional = rsSelectSalidaDetalle.getString(2);
        String cantidad_salida_matpromocional = rsSelectSalidaDetalle.getString(3);
        String obs_salidadetalle_matpromocional = rsSelectSalidaDetalle.getString(4);
        String sqlInsertSalidaDetalle = "insert into salidas_detallematerialpromocional([cod_salida_matpromocional], [cod_matpromocional], [cantidad_salida_matpromocional], [obs_salidadetalle_matpromocional])values(";
        sqlInsertSalidaDetalle += cod_salida_matpromocionalcorrelativo + "," + cod_matpromocional + "," + cantidad_salida_matpromocional + ",'" + obs_salidadetalle_matpromocional + "')";
        Statement stInsertSalidaDetalle = conDestino.createStatement();
        stInsertSalidaDetalle.executeUpdate(sqlInsertSalidaDetalle);
        //System.out.println("sqlInsertSalidaDetalle:"+sqlInsertSalidaDetalle);
        }
        rsSelectSalidaDetalle.close();
        stSelectSalidaDetalle.close();

        }
        rssalidasMat.close();
        salidasMat.close();

        //INSERCION DE DATOS
        //INGRESOS





        String sqlIngresos = "select cod_gestion, cod_ingresoventas, cod_salida_acond, cod_salidaventa, cod_almacen_venta, " +
        "cod_almacen_ventaorigen, cod_tipoingresoventas, nro_ingresoventas, fecha_ingresoventas, " +
        "cod_estado_ingresoventas, obs_ingresoventas, cod_cliente from ingresos_ventas where cod_almacen_venta " +
        "in (select cod_almacen_venta from almacenes_ventas where cod_area_empresa=" + codAreaEmpresa + ")";
        sqlIngresos += " and fecha_ingresoventas>='" + fechaDesde + " 00:00:00'";
        sqlIngresos += " and fecha_ingresoventas<='" + fechaHasta + " 23:59:59'";
        Statement stIngresos = conOrigen.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rsIngresos = stIngresos.executeQuery(sqlIngresos);
        while (rsIngresos.next()) {

        int cod_gestion = rsIngresos.getInt(1);
        int cod_ingresoventas = rsIngresos.getInt(2);
        int cod_salida_acond = rsIngresos.getInt(3);
        int cod_salidaventa = rsIngresos.getInt(4);
        int cod_almacen_venta = rsIngresos.getInt(5);
        int cod_almacen_ventaorigen = rsIngresos.getInt(6);
        int cod_tipoingresoventas = rsIngresos.getInt(7);
        int nro_ingresoventas = rsIngresos.getInt(8);
        String fecha_ingresoventas = rsIngresos.getString(9);
        int cod_estado_ingresoventas = rsIngresos.getInt(10);
        String obs_ingresoventas = rsIngresos.getString(11);
        int cod_cliente = rsIngresos.getInt(12);

        //generamos el codigo correlativo11
        String sqlCorrelativo = "select max(cod_ingresoventas)+1 as maximo from ingresos_ventas";
        Statement stCorrelativo = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rsCorrelativo = stCorrelativo.executeQuery(sqlCorrelativo);
        rsCorrelativo.next();
        int codigoIngresoInsertar = rsCorrelativo.getInt(1);

        //insertamos ingreso
        String sqlInsertIngreso = "insert into INGRESOS_VENTAS (cod_gestion, cod_ingresoventas, cod_salida_acond, cod_salidaventa, cod_almacen_venta, " +
        "cod_almacen_ventaorigen, cod_tipoingresoventas, nro_ingresoventas, fecha_ingresoventas, " +
        "cod_estado_ingresoventas, obs_ingresoventas, cod_cliente) values (" + cod_gestion + ", " + codigoIngresoInsertar + ", " +
        "" + cod_salida_acond + ", " + cod_salidaventa + ", " + cod_almacen_venta + ", " + cod_almacen_ventaorigen + ", " + cod_tipoingresoventas + ", " +
        "" + nro_ingresoventas + ", '" + fecha_ingresoventas + "', " + cod_estado_ingresoventas + ", '" + obs_ingresoventas + "', " +
        "" + cod_cliente + ")";

        Statement stInsertIngreso = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        stInsertIngreso.executeUpdate(sqlInsertIngreso);
        //System.out.println("sqlInsertIngreso:"+sqlInsertIngreso);

        String sqlDetalleIngreso = "select cod_ingresoventas, cod_presentacion, cod_lote_produccion, cantidad, " +
        "cantidad_unitaria, cantidad_restante, cantidad_unitariarestante, cod_tipoobsingreso, costo_almacen, " +
        "fecha_venc, obs_ingresoprod, costo_actualizado, costo_actualizado_final, fecha_actualizacion, " +
        "cantidad_frv, cantidadunitaria_frv, cantidad_mas, cantidadunitaria_mas, cantidad_menos, " +
        "cantidadunitaria_menos from ingresos_detalleventas where cod_ingresoventas=" + cod_ingresoventas;
        Statement stDetalleIngreso = conOrigen.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rsInsertIngresoDetalle = stDetalleIngreso.executeQuery(sqlDetalleIngreso);

        while (rsInsertIngresoDetalle.next()) {

        int cod_presentacion = rsInsertIngresoDetalle.getInt(2);
        String cod_lote_produccion = rsInsertIngresoDetalle.getString(3);
        int cantidad = rsInsertIngresoDetalle.getInt(4);
        int cantidad_unitaria = rsInsertIngresoDetalle.getInt(5);
        int cantidad_restante = rsInsertIngresoDetalle.getInt(6);
        int cantidad_unitariarestante = rsInsertIngresoDetalle.getInt(7);
        int cod_tipoobsingreso = rsInsertIngresoDetalle.getInt(8);
        float costo_almacen = rsInsertIngresoDetalle.getFloat(9);
        Date fecha_venc = rsInsertIngresoDetalle.getDate(10);
        String obs_ingresoprod = rsInsertIngresoDetalle.getString(11);
        float costo_actualizado = rsInsertIngresoDetalle.getFloat(12);
        float costo_actualizado_final = rsInsertIngresoDetalle.getFloat(13);
        Date fecha_actualizacion = rsInsertIngresoDetalle.getDate(14);
        int cantidad_frv = rsInsertIngresoDetalle.getInt(15);
        int cantidadunitaria_frv = rsInsertIngresoDetalle.getInt(16);
        int cantidad_mas = rsInsertIngresoDetalle.getInt(17);
        int cantidad_unitaria_mas = rsInsertIngresoDetalle.getInt(18);
        int cantidad_menos = rsInsertIngresoDetalle.getInt(19);
        int cantidadunitaria_menos = rsInsertIngresoDetalle.getInt(20);
        String sqlinsertaDetalle = "insert into ingresos_detalleventas (cod_ingresoventas, cod_presentacion, cod_lote_produccion, cantidad, " +
        "cantidad_unitaria, cantidad_restante, cantidad_unitariarestante, cod_tipoobsingreso, costo_almacen, " +
        "fecha_venc, obs_ingresoprod, costo_actualizado, costo_actualizado_final, fecha_actualizacion, " +
        "cantidad_frv, cantidadunitaria_frv, cantidad_mas, cantidadunitaria_mas, cantidad_menos, " +
        "cantidadunitaria_menos) values(" + codigoIngresoInsertar + ", " + cod_presentacion + ", '" + cod_lote_produccion + "', " + cantidad + ", " +
        "" + cantidad_unitaria + ", " + cantidad_restante + ", " + cantidad_unitariarestante + ", " + cod_tipoobsingreso + ", " +
        "" + costo_almacen + ", '" + f.format(fecha_venc) + "', '" + obs_ingresoprod + "', " + costo_actualizado + ", " +
        "" + costo_actualizado_final + ", " + fecha_actualizacion + ", " + cantidad_frv + ", " + cantidadunitaria_frv + ", " +
        "" + cantidad_mas + ", " + cantidad_unitaria_mas + ", " + cantidad_menos + ", " + cantidadunitaria_menos + ")";
        System.out.println("sqlinsertaDetalle:" + sqlinsertaDetalle);
        Statement stInsertaDetalle = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        stInsertaDetalle.executeUpdate(sqlinsertaDetalle);

        }

        }
        rsIngresos.close();
        stIngresos.close();
        //INSERTANDO SALIDAS


        String sql = "";
        sql += "SELECT cod_gestion,cod_salidaventa, ";
        sql += " cod_almacen_venta,cod_almacen_ventadestino, ";
        sql += "       nro_salidaventa,fecha_salidaventa, ";
        sql += " cod_estado_salidaventa,cod_tipodoc_venta, ";
        sql += "       nro_factura,cod_tiposalidaventas,  ";
        sql += " cod_tipoventa,cod_pedidoventa,cod_cliente,  ";
        sql += "       obs_salidaventa,monto_total,porcentaje_descuento,  ";
        sql += "       cod_salida_mat_promocional,monto_cancelado,cod_personal  ";
        sql += "       from SALIDAS_VENTAS  where cod_almacen_venta in(select COD_ALMACEN_VENTA from ALMACENES_VENTAS where COD_AREA_EMPRESA=" + codAreaEmpresa + ")";
        sql += "    and   fecha_salidaventa>='" + fechaDesde + " 00:00:00'";
        sql += "    and   fecha_salidaventa<='" + fechaHasta + " 23:59:59'";

        Statement salidasSt = conOrigen.createStatement();
        ResultSet rsSalidas = salidasSt.executeQuery(sql);
        while (rsSalidas.next()) {
        String cod_gestion = rsSalidas.getString(1);
        int cod_salidaventa = rsSalidas.getInt(2);
        String cod_almacen_venta = rsSalidas.getString(3);
        String cod_almacen_ventadestino = rsSalidas.getString(4);
        String nro_salidaventa = rsSalidas.getString(5);
        String fecha_salidaventa = rsSalidas.getString(6);
        String cod_estado_salidaventa = rsSalidas.getString(7);
        String cod_tipodoc_venta = rsSalidas.getString(8);
        String nro_factura = rsSalidas.getString(9);
        String cod_tiposalidaventas = rsSalidas.getString(10);
        String cod_tipoventa = rsSalidas.getString(11);
        String cod_pedidoventa = rsSalidas.getString(12);
        String cod_cliente = rsSalidas.getString(13);
        String obs_salidaventa = rsSalidas.getString(14);
        float monto_total = rsSalidas.getFloat(15);
        float porcentaje_descuento = rsSalidas.getFloat(16);
        String cod_salida_mat_promocional = rsSalidas.getString(17);
        cod_salida_mat_promocional = (cod_salida_mat_promocional == null) ? "0" : cod_salida_mat_promocional;
        cod_pedidoventa = (cod_pedidoventa == null) ? "0" : cod_pedidoventa;
        cod_almacen_ventadestino = (cod_almacen_ventadestino == null) ? "0" : cod_almacen_ventadestino;
        float monto_cancelado = rsSalidas.getFloat(18);
        String cod_personal = rsSalidas.getString(19);


        String sqlCorrelativo = "select max(COD_SALIDAVENTA)+1 from SALIDAS_VENTAS";
        Statement stCorrelativo = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rsCorrelativo = stCorrelativo.executeQuery(sqlCorrelativo);
        rsCorrelativo.next();
        int codigosalida = rsCorrelativo.getInt(1);

        Statement stM = conDestino.createStatement();
        ResultSet rsM = stM.executeQuery("select cod_salida_matpromocional from salidas_matpromocional where  obs_temporal='" + cod_salida_mat_promocional + "'");
        String cod_salida_matpromocionalO = "";
        if (rsM.next()) {
        cod_salida_matpromocionalO = rsM.getString(1);
        }
        rsM.close();
        stM.close();
        cod_salida_matpromocionalO = (cod_salida_matpromocionalO == null) ? "0" : cod_salida_matpromocionalO;
        cod_salida_matpromocionalO = (cod_salida_matpromocionalO.equals("")) ? "0" : cod_salida_matpromocionalO;

        String sqlInsertarSalidas = "insert into SALIDAS_VENTAS(cod_gestion,cod_salidaventa, ";
        sqlInsertarSalidas += " cod_almacen_venta,cod_almacen_ventadestino, ";
        sqlInsertarSalidas += "       nro_salidaventa,fecha_salidaventa, ";
        sqlInsertarSalidas += " cod_estado_salidaventa,cod_tipodoc_venta, ";
        sqlInsertarSalidas += "       nro_factura,cod_tiposalidaventas,  ";
        sqlInsertarSalidas += " cod_tipoventa,cod_pedidoventa,cod_cliente,  ";
        sqlInsertarSalidas += "       obs_salidaventa,monto_total,porcentaje_descuento,  ";
        sqlInsertarSalidas += "       cod_salida_mat_promocional,monto_cancelado,cod_personal";
        sqlInsertarSalidas += " )values(";
        sqlInsertarSalidas += " " + cod_gestion + "," + codigosalida + "," + cod_almacen_venta + ",";
        sqlInsertarSalidas += " " + cod_almacen_ventadestino + "," + nro_salidaventa + ",'" + fecha_salidaventa + "',";
        sqlInsertarSalidas += " " + cod_estado_salidaventa + "," + cod_tipodoc_venta + "," + nro_factura + ",";
        sqlInsertarSalidas += " " + cod_tiposalidaventas + "," + cod_tipoventa + "," + cod_salidaventa + ",";
        sqlInsertarSalidas += " " + cod_cliente + ",'" + obs_salidaventa + "'," + monto_total + ",";
        sqlInsertarSalidas += " " + porcentaje_descuento + "," + cod_salida_matpromocionalO + "," + monto_cancelado + ",";
        sqlInsertarSalidas += " " + cod_personal + ")";
        Statement stInsertSalidas = conDestino.createStatement();
        stInsertSalidas.executeUpdate(sqlInsertarSalidas);
        //System.out.println("sqlInsertarSalidas:"+sqlInsertarSalidas);

        String sqlSelectSalidaDetalle = " select  ";
        sqlSelectSalidaDetalle += " cod_presentacion, ";
        sqlSelectSalidaDetalle += "        cod_lote_produccion, ";
        sqlSelectSalidaDetalle += " fecha_venc, ";
        sqlSelectSalidaDetalle += "        cantidad,cantidad_unitaria, ";
        sqlSelectSalidaDetalle += "        cantidad_bonificacion, ";
        sqlSelectSalidaDetalle += "        cantidad_unitariabonificacion, ";
        sqlSelectSalidaDetalle += "        cantidad_total, cantidad_unitariatotal, ";
        sqlSelectSalidaDetalle += "        porcentaje_aplicadoprecio,";
        sqlSelectSalidaDetalle += "        precio_lista,precio_venta, ";
        sqlSelectSalidaDetalle += "        costo_almacen, ";
        sqlSelectSalidaDetalle += "        costo_actualizado,costo_actualizado_final, ";
        sqlSelectSalidaDetalle += "        fecha_actualizacion ";
        sqlSelectSalidaDetalle += "        from SALIDAS_DETALLEVENTAS ";
        sqlSelectSalidaDetalle += "        where  cod_salidaventas=" + cod_salidaventa;
        Statement stSelectSalidaDetalle = conOrigen.createStatement();
        ResultSet rsSelectSalidaDetalle = stSelectSalidaDetalle.executeQuery(sqlSelectSalidaDetalle);
        while (rsSelectSalidaDetalle.next()) {
        String cod_presentacion = rsSelectSalidaDetalle.getString(1);
        String cod_lote_produccion = rsSelectSalidaDetalle.getString(2);
        Date fecha_venc = rsSelectSalidaDetalle.getDate(3);
        int cantidad = rsSelectSalidaDetalle.getInt(4);
        int cantidad_unitaria = rsSelectSalidaDetalle.getInt(5);
        int cantidad_bonificacion = rsSelectSalidaDetalle.getInt(6);
        int cantidad_unitariabonificacion = rsSelectSalidaDetalle.getInt(7);
        int cantidad_total = rsSelectSalidaDetalle.getInt(8);
        int cantidad_unitariatotal = rsSelectSalidaDetalle.getInt(9);
        float porcentaje_aplicadoprecio = rsSelectSalidaDetalle.getFloat(10);
        float precio_lista = rsSelectSalidaDetalle.getFloat(11);
        float precio_venta = rsSelectSalidaDetalle.getFloat(12);
        float costo_almacen = rsSelectSalidaDetalle.getFloat(13);
        float costo_actualizado = rsSelectSalidaDetalle.getFloat(14);
        float costo_actualizado_final = rsSelectSalidaDetalle.getFloat(15);
        Date fecha_actualizacion = rsSelectSalidaDetalle.getDate(16);
        //costo_almacen costo_actualizado  costo_actualizado_final  fecha_actualizacion
        String sqlInsertSalidaDetalle = "insert into SALIDAS_DETALLEVENTAS(";
        sqlInsertSalidaDetalle += " cod_salidaventas, ";
        sqlInsertSalidaDetalle += " cod_presentacion, ";
        sqlInsertSalidaDetalle += "        cod_lote_produccion, ";
        sqlInsertSalidaDetalle += " fecha_venc, ";
        sqlInsertSalidaDetalle += "        cantidad,cantidad_unitaria, ";
        sqlInsertSalidaDetalle += "        cantidad_bonificacion, ";
        sqlInsertSalidaDetalle += "        cantidad_unitariabonificacion, ";
        sqlInsertSalidaDetalle += "        cantidad_total, cantidad_unitariatotal, ";
        sqlInsertSalidaDetalle += "        porcentaje_aplicadoprecio,";
        sqlInsertSalidaDetalle += "        precio_lista,precio_venta, ";
        sqlInsertSalidaDetalle += "        costo_almacen, ";
        sqlInsertSalidaDetalle += "        costo_actualizado,costo_actualizado_final, ";
        sqlInsertSalidaDetalle += "        fecha_actualizacion";
        sqlInsertSalidaDetalle += "        )values(";
        sqlInsertSalidaDetalle += "" + codigosalida + "," + cod_presentacion + ",'" + cod_lote_produccion + "',";
        sqlInsertSalidaDetalle += "'" + f.format(fecha_venc) + "'," + cantidad + "," + cantidad_unitaria + ",";
        sqlInsertSalidaDetalle += "" + cantidad_bonificacion + "," + cantidad_unitariabonificacion + "," + cantidad_total + ",";
        sqlInsertSalidaDetalle += "" + cantidad_unitariatotal + "," + porcentaje_aplicadoprecio + "," + precio_lista + ",";
        sqlInsertSalidaDetalle += "" + precio_venta + "," + costo_almacen + "," + costo_actualizado + ",";
        sqlInsertSalidaDetalle += "" + costo_actualizado_final + "," + fecha_actualizacion + ")";
        Statement stInsertSalidaDetalle = conDestino.createStatement();
        stInsertSalidaDetalle.executeUpdate(sqlInsertSalidaDetalle);
        //System.out.println("sqlInsertSalidaDetalle:"+sqlInsertSalidaDetalle);
        }
        rsSelectSalidaDetalle.close();
        stSelectSalidaDetalle.close();

        }




        String sqlPedidos = "SELECT cod_pedido,COD_ESTADOPEDIDO,NRO_PEDIDO,NRO_PEDIDOFISICO,COD_CLIENTE,COD_PERSONAL,COD_TIPOVENTA,FECHA_PEDIDO,COD_AREA_EMPRESA,OBS_PEDIDO,COD_TIPO_DOCUMENTO,DESCUENTO_TOTAL from pedidos where cod_area_empresa=" + codAreaEmpresa + " and FECHA_PEDIDO>='" + fechaDesde + " 00:00:00' and FECHA_PEDIDO<='" + fechaHasta + " 23:59:59'";
        //INSERTAMOS DATOS DE PEDIDOS
        Statement stPedidos = conOrigen.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rsPedidos = stPedidos.executeQuery(sqlPedidos);
        while (rsPedidos.next()) {
        int cod_pedido = rsPedidos.getInt(1);
        int COD_ESTADOPEDIDO = rsPedidos.getInt(2);
        int NRO_PEDIDO = rsPedidos.getInt(3);
        int NRO_PEDIDOFISICO = rsPedidos.getInt(4);
        int COD_CLIENTE = rsPedidos.getInt(5);
        int COD_PERSONAL = rsPedidos.getInt(6);
        int COD_TIPOVENTA = rsPedidos.getInt(7);
        String FECHA_PEDIDO = rsPedidos.getString(8);
        int COD_AREA_EMPRESA = rsPedidos.getInt(9);
        String OBS_PEDIDO = rsPedidos.getString(10);
        int COD_TIPO_DOCUMENTO = rsPedidos.getInt(11);
        float DESCUENTO_TOTAL = rsPedidos.getFloat(12);

        String sqlCorrelativoPedido = "select max(cod_pedido)+1 as maximo from pedidos";
        Statement stCorrelativoPedido = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rsCorrelativoPedido = stCorrelativoPedido.executeQuery(sqlCorrelativoPedido);
        rsCorrelativoPedido.next();
        int codCobranza = rsCorrelativoPedido.getInt(1);
        //INSERTAMOS EN TABLA ---PEDIDOS---
        String sqlInsertPedido = "insert into pedidos   (cod_pedido,COD_ESTADOPEDIDO,NRO_PEDIDO,NRO_PEDIDOFISICO,COD_CLIENTE,COD_PERSONAL,COD_TIPOVENTA,FECHA_PEDIDO,COD_AREA_EMPRESA,OBS_PEDIDO,COD_TIPO_DOCUMENTO,DESCUENTO_TOTAL)";
        sqlInsertPedido += " values(";
        sqlInsertPedido += "" + codCobranza + "," + COD_ESTADOPEDIDO + "," + NRO_PEDIDO + "," + NRO_PEDIDOFISICO + ",";
        sqlInsertPedido += "" + COD_CLIENTE + "," + COD_PERSONAL + "," + COD_TIPOVENTA + ",'" + FECHA_PEDIDO + "'," + COD_AREA_EMPRESA + ",'" + OBS_PEDIDO + "'," + COD_TIPO_DOCUMENTO + "," + DESCUENTO_TOTAL + ")";
        Statement stInsertPedidos = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        //System.out.println("sqlInsertPedido:"+sqlInsertPedido);
        stInsertPedidos.executeUpdate(sqlInsertPedido);
        //INSERTAMOS DATOS DE PEDIDOS DETALLE


        String sqlCobranzasSalidas = "select cod_salidaventa,cod_pedido  from ventas_pedidos where cod_pedido =" + cod_pedido;
        //System.out.println("sqlCobranzasSalidas:"+sqlCobranzasSalidas);
        Statement stCobranzasSalidas = conOrigen.createStatement();
        ResultSet rsCobranzasSalidas = stCobranzasSalidas.executeQuery(sqlCobranzasSalidas);
        String codsalidaventa = "0";
        while (rsCobranzasSalidas.next()) {
        codsalidaventa = rsCobranzasSalidas.getString(1);

        String sqlvp = "select cod_salidaventa  from salidas_ventas where cod_salidaventa is not null and   COD_ALMACEN_VENTA in (select COD_ALMACEN_VENTA from ALMACENES_VENTAS  where cod_area_empresa =" + codAreaEmpresa + "  ) and cod_pedidoventa=" + codsalidaventa;
        //System.out.println("sqlCobranzasSalidas:"+sqlvp);
        Statement stvp = conDestino.createStatement();
        ResultSet rsvp = stvp.executeQuery(sqlvp);
        while (rsvp.next()) {
        codsalidaventa = rsvp.getString(1);
        String sqlVpi = "insert into ventas_pedidos(cod_salidaventa,cod_pedido)values(" + codsalidaventa + "," + codCobranza + ")";
        //System.out.println("sqlVpi:"+sqlVpi);
        Statement stVps = conDestino.createStatement();
        stVps.executeUpdate(sqlVpi);

        }
        rsvp.close();


        stvp.close();



        }

        rsCobranzasSalidas.close();
        stCobranzasSalidas.close();




        String sqlCobranzasDetalle = "select [COD_PRESENTACION], [CANTIDAD_PEDIDO], [CANTIDAD_UNITARIAPEDIDO], [CANTIDAD_PEDIDOEFECTUADA], [CANTIDAD_UNITARIAPEDIDOEFECTUADA], [COD_ESTADO_DETALLEPEDIDO], [CANTIDAD_BONIFICACION], [CANTIDAD_UNITARIABONIFICACION], [OBS_PEDIDODETALLE],  [PRECIO_VENTA], [DESCUENTO] from PEDIDOS_DETALLE where cod_pedido=" + cod_pedido;

        Statement stCobranzasDetalleOrigen = conOrigen.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rsCobranzasDetalleOrigen = stCobranzasDetalleOrigen.executeQuery(sqlCobranzasDetalle);
        while (rsCobranzasDetalleOrigen.next()) {

        int COD_PRESENTACION = rsCobranzasDetalleOrigen.getInt(1);
        int CANTIDAD_PEDIDO = rsCobranzasDetalleOrigen.getInt(2);
        int CANTIDAD_UNITARIAPEDIDO = rsCobranzasDetalleOrigen.getInt(3);
        int CANTIDAD_PEDIDOEFECTUADA = rsCobranzasDetalleOrigen.getInt(4);

        int CANTIDAD_UNITARIAPEDIDOEFECTUADA = rsCobranzasDetalleOrigen.getInt(5);
        int COD_ESTADO_DETALLEPEDIDO = rsCobranzasDetalleOrigen.getInt(6);



        int CANTIDAD_BONIFICACION = rsCobranzasDetalleOrigen.getInt(7);
        int CANTIDAD_UNITARIABONIFICACION = rsCobranzasDetalleOrigen.getInt(8);



        String OBS_PEDIDODETALLE = rsCobranzasDetalleOrigen.getString(9);
        float PRECIO_VENTA = rsCobranzasDetalleOrigen.getFloat(10);
        float DESCUENTO = rsCobranzasDetalleOrigen.getFloat(11);


        //INSERTAMOS EN TABLA ---COBRANZAS DETALLE---
        String sqlInsertCobranzaDetalle = "INSERT INTO [PEDIDOS_DETALLE] ([COD_PEDIDO], [COD_PRESENTACION], [CANTIDAD_PEDIDO], [CANTIDAD_UNITARIAPEDIDO], [CANTIDAD_PEDIDOEFECTUADA], [CANTIDAD_UNITARIAPEDIDOEFECTUADA], [COD_ESTADO_DETALLEPEDIDO], [CANTIDAD_BONIFICACION], [CANTIDAD_UNITARIABONIFICACION], [OBS_PEDIDODETALLE],  [PRECIO_VENTA], [DESCUENTO]";
        sqlInsertCobranzaDetalle += ") values(";
        sqlInsertCobranzaDetalle += codCobranza + "," + COD_PRESENTACION + "," + CANTIDAD_PEDIDO + "," + CANTIDAD_UNITARIAPEDIDO + "," + CANTIDAD_PEDIDOEFECTUADA + "," + CANTIDAD_UNITARIAPEDIDOEFECTUADA + "," + COD_ESTADO_DETALLEPEDIDO + "," + CANTIDAD_BONIFICACION + "," + CANTIDAD_UNITARIABONIFICACION + ",'" + OBS_PEDIDODETALLE + "'," + PRECIO_VENTA + "," + DESCUENTO + ")";
        //System.out.println("sqlInsertCobranzaDetalle:"+sqlInsertCobranzaDetalle);
        Statement stInsertCobranzaDetalle = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        stInsertCobranzaDetalle.executeUpdate(sqlInsertCobranzaDetalle);
        }
        rsCobranzasDetalleOrigen.close();
        }
        //INSERTAMOS DATOS DE COBRANZAS
        String sqlCobranzas = "select cod_cobranza, cod_personal, nro_cobranza, cod_tipo_cobranza, cod_estado_cobranza, ";
        sqlCobranzas += " fecha_cobranza, obs_cobranza, cod_area_empresa from cobranzas where cod_area_empresa=" + codAreaEmpresa;
        sqlCobranzas += " and fecha_cobranza>='" + fechaDesde + " 00:00:00'";
        sqlCobranzas += " and fecha_cobranza<='" + fechaHasta + " 23:59:59'";
        Statement stCobranzasOrigen = conOrigen.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rsCobranzasOrigen = stCobranzasOrigen.executeQuery(sqlCobranzas);
        while (rsCobranzasOrigen.next()) {
        int cod_cobranza = rsCobranzasOrigen.getInt(1);
        int cod_personal = rsCobranzasOrigen.getInt(2);
        int nro_cobranza = rsCobranzasOrigen.getInt(3);
        int cod_tipo_cobranza = rsCobranzasOrigen.getInt(4);
        int cod_estado_cobranza = rsCobranzasOrigen.getInt(5);
        String fecha_cobranza = rsCobranzasOrigen.getString(6);
        String obs_cobranza = rsCobranzasOrigen.getString(7);
        int cod_area_empresa = rsCobranzasOrigen.getInt(8);
        //GENERAR CODIGO CORRELATIVO COBRANZAS..............................................................................
        String sqlCorrelativoCobranza = "select max(cod_cobranza)+1 as maximo from cobranzas";
        Statement stCorrelativoCobranza = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rsCorrelativoCobranza = stCorrelativoCobranza.executeQuery(sqlCorrelativoCobranza);
        rsCorrelativoCobranza.next();
        int codCobranza = rsCorrelativoCobranza.getInt(1);
        //INSERTAMOS EN TABLA ---COBRANZAS---
        String sqlInsertCobranza = "insert into cobranzas (cod_cobranza, cod_personal, nro_cobranza, cod_tipo_cobranza, cod_estado_cobranza,";
        sqlInsertCobranza += "fecha_cobranza, obs_cobranza, cod_area_empresa) values(";
        sqlInsertCobranza += "" + codCobranza + "," + cod_personal + "," + nro_cobranza + "," + cod_tipo_cobranza + ",";
        sqlInsertCobranza += "" + cod_estado_cobranza + ",'" + fecha_cobranza + "','" + obs_cobranza + "'," + cod_area_empresa + ")";
        Statement stInsertCobranza = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        //System.out.println("sqlInsertCobranza:"+sqlInsertCobranza);
        stInsertCobranza.executeUpdate(sqlInsertCobranza);
        //INSERTAMOS DATOS DE COBRANZAS DETALLE
        String sqlCobranzasDetalle = "select cod_salidaventa, cod_tipo_pago, monto_cobranza, cod_banco, ";
        sqlCobranzasDetalle += "nro_cheque, nro_cobranzadetalle, fecha_cobranzadetalle from cobranzas_detalle where cod_cobranza=" + cod_cobranza;
        Statement stCobranzasDetalleOrigen = conOrigen.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rsCobranzasDetalleOrigen = stCobranzasDetalleOrigen.executeQuery(sqlCobranzasDetalle);
        while (rsCobranzasDetalleOrigen.next()) {

        int cod_salidaventa = rsCobranzasDetalleOrigen.getInt(1);
        int cod_tipo_pago = rsCobranzasDetalleOrigen.getInt(2);
        float monto_cobranza = rsCobranzasDetalleOrigen.getFloat(3);
        int cod_banco = rsCobranzasDetalleOrigen.getInt(4);
        String nro_cheque = rsCobranzasDetalleOrigen.getString(5);
        int nro_cobranzadetalle = rsCobranzasDetalleOrigen.getInt(6);
        Date fecha_cobranzadetalle = rsCobranzasDetalleOrigen.getDate(7);

        //String sqlCobranzasSalidas="select cod_salidaventa  from salidas_ventas where COD_ALMACEN_VENTA in (select COD_ALMACEN_VENTA from ALMACENES_VENTAS  where cod_area_empresa ="+codAreaEmpresa+"  and COD_TIPOALMACENVENTA = 6) and cod_pedidoventa="+cod_salidaventa;
        String sqlCobranzasSalidas = "select cod_salidaventa  from salidas_ventas where cod_salidaventa is not null and   COD_ALMACEN_VENTA in (select COD_ALMACEN_VENTA from ALMACENES_VENTAS  where cod_area_empresa =" + codAreaEmpresa + "  ) and cod_pedidoventa=" + cod_salidaventa;
        //System.out.println("sqlCobranzasSalidas:"+sqlCobranzasSalidas);
        Statement stCobranzasSalidas = conDestino.createStatement();
        ResultSet rsCobranzasSalidas = stCobranzasSalidas.executeQuery(sqlCobranzasSalidas);
        String codsalidaventa = "0";
        if (rsCobranzasSalidas.next()) {
        codsalidaventa = rsCobranzasSalidas.getString(1);
        }
        rsCobranzasSalidas.close();
        stCobranzasSalidas.close();

        //INSERTAMOS EN TABLA ---COBRANZAS DETALLE---
        String sqlInsertCobranzaDetalle = "insert into cobranzas_detalle (cod_salidaventa,cod_cobranza, cod_tipo_pago, monto_cobranza, cod_banco,";
        sqlInsertCobranzaDetalle += "nro_cheque, nro_cobranzadetalle, fecha_cobranzadetalle) values(";
        sqlInsertCobranzaDetalle += "" + codsalidaventa + "," + codCobranza + "," + cod_tipo_pago + "," + monto_cobranza + ",";
        sqlInsertCobranzaDetalle += "" + cod_banco + ",'" + nro_cheque + "'," + nro_cobranzadetalle + ",'" + f.format(fecha_cobranzadetalle) + "')";
        //System.out.println("sqlInsertCobranzaDetalle:"+sqlInsertCobranzaDetalle);
        Statement stInsertCobranzaDetalle = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        stInsertCobranzaDetalle.executeUpdate(sqlInsertCobranzaDetalle);
        }
        rsCobranzasDetalleOrigen.close();
        }

        String sqlFacturasEmitidasEliminar = "delete from facturas_emitidas where cod_area_empresa=" + codAreaEmpresa + " and cod_salidaventa in(";
        sqlFacturasEmitidasEliminar += " select cod_salidaventa  from SALIDAS_VENTAS  where cod_almacen_venta in(select COD_ALMACEN_VENTA from ALMACENES_VENTAS where COD_AREA_EMPRESA=" + codAreaEmpresa + ") and   fecha_salidaventa>='" + fechaDesde + " 00:00:00' and fecha_salidaventa<='" + fechaHasta + " 23:59:59' )";
        System.out.println("sqlFacturasEmitidasEliminar:" + sqlFacturasEmitidasEliminar);

        Statement stFacturasEmitidasEliminar = conDestino.createStatement();
        int resultado = stFacturasEmitidasEliminar.executeUpdate(sqlFacturasEmitidasEliminar);
        //System.out.println("resultadoxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx:"+resultado);
        String sqlFacturas = "select cod_factura from facturas where cod_area_empresa=" + codAreaEmpresa;
        Statement stFacturas = conOrigen.createStatement();
        ResultSet rsFacturas = stFacturas.executeQuery(sqlFacturas);
        String codFactura = "";
        if (rsFacturas.next()) {
        codFactura = rsFacturas.getString(1);
        }
        rsFacturas.close();
        stFacturas.close();
        String sqlFacturasEmitidas = "select cod_factura,nro_factura,cod_area_empresa,cod_estado_factura,razon_social,nit,nro_autorizacion,fecha_factura,importe,ice,exentos,importe_neto,iva,codigo_control,glosa,cod_salidaventa from facturas_emitidas where cod_area_empresa=" + codAreaEmpresa + " and cod_salidaventa in(";
        sqlFacturasEmitidas += " select cod_salidaventa  from SALIDAS_VENTAS  where cod_almacen_venta in(select COD_ALMACEN_VENTA from ALMACENES_VENTAS where COD_AREA_EMPRESA=" + codAreaEmpresa + ") and   fecha_salidaventa>='" + fechaDesde + " 00:00:00' and fecha_salidaventa<='" + fechaHasta + " 23:59:59' ) ";
        //System.out.println("sqlFacturasEmitidas:"+sqlFacturasEmitidas);
        Statement stFacturasEmitidas = conOrigen.createStatement();
        ResultSet rsFacturasEmitidas = stFacturasEmitidas.executeQuery(sqlFacturasEmitidas);
        while (rsFacturasEmitidas.next()) {
        String cod_factura = rsFacturasEmitidas.getString(1);
        String nro_factura = rsFacturasEmitidas.getString(2);
        String cod_area_empresa = rsFacturasEmitidas.getString(3);
        String cod_estado_factura = rsFacturasEmitidas.getString(4);
        String razon_social = rsFacturasEmitidas.getString(5);
        String nit = rsFacturasEmitidas.getString(6);
        String nro_autorizacion = rsFacturasEmitidas.getString(7);
        String fecha_factura = rsFacturasEmitidas.getString(8);
        String importe = rsFacturasEmitidas.getString(9);
        String ice = rsFacturasEmitidas.getString(10);
        String exentos = rsFacturasEmitidas.getString(11);
        String importe_neto = rsFacturasEmitidas.getString(12);
        String iva = rsFacturasEmitidas.getString(13);
        String codigo_control = rsFacturasEmitidas.getString(14);
        String glosa = rsFacturasEmitidas.getString(15);
        String cod_salidaventa = rsFacturasEmitidas.getString(16);
        String sqlSalidas = "select cod_salidaventa  from salidas_ventas where cod_salidaventa is not null and COD_ALMACEN_VENTA in (select COD_ALMACEN_VENTA from ALMACENES_VENTAS  where cod_area_empresa =" + codAreaEmpresa + "  ) and cod_pedidoventa=" + cod_salidaventa;
        //System.out.println("sqlSalidas:"+sqlSalidas);
        Statement stSalidas = conDestino.createStatement();
        ResultSet rsSalidasFacturas = stSalidas.executeQuery(sqlSalidas);
        String cod_salidaventan = "";
        if (rsSalidasFacturas.next()) {
        cod_salidaventan = rsSalidasFacturas.getString(1);
        }
        //System.out.println("cod_salidaventan:"+cod_salidaventan);
        String sqlInsertFacturasEmitidas = "insert into facturas_emitidas(cod_factura,nro_factura,cod_area_empresa,cod_estado_factura,razon_social,nit,nro_autorizacion,fecha_factura,importe,ice,exentos,importe_neto,iva,codigo_control,glosa,cod_salidaventa)values(";
        sqlInsertFacturasEmitidas += "" + cod_factura + "," + nro_factura + ",";
        sqlInsertFacturasEmitidas += "" + cod_area_empresa + "," + cod_estado_factura + ",";
        sqlInsertFacturasEmitidas += "'" + razon_social + "','" + nit + "','" + nro_autorizacion + "','" + fecha_factura + "'," + importe + "," + ice + "," + exentos + "," + importe_neto + "," + iva + ",'" + codigo_control + "','" + glosa + "'," + cod_salidaventan + ")";
        System.out.println("sqlInsertFacturasEmitidas:" + sqlInsertFacturasEmitidas);
        Statement stInsertFacturasEmitidas = conDestino.createStatement();
        stInsertFacturasEmitidas.executeUpdate(sqlInsertFacturasEmitidas);
        }




        sql = " select sv.monto_total,sv.monto_cancelado,(select ISNULL(sum(monto_cobranza), 0) as total_cobranza from   cobranzas_detalle cd, cobranzas c where cd.cod_cobranza = c.cod_cobranza and c.fecha_cobranza <= '" + fechaHasta + "' and sv.COD_TIPODOC_VENTA in (2, 1,3) and cd.cod_salidaventa = sv.cod_salidaventa) as total_cobranza ";
        sql += " from salidas_ventas sv,tipo_documentos_ventas tdv,estados_salida_ventas esv,almacenes_ventas av, areas_empresa ae  ";
        sql += " where monto_total > (select ISNULL(sum(monto_cobranza), 0) + 1 from cobranzas_detalle cd,cobranzas c where cd.cod_cobranza = c.cod_cobranza and c.fecha_cobranza         <= '" + fechaHasta + "' and cd.cod_salidaventa = sv.cod_salidaventa) and  ";
        sql += " sv.cod_tipodoc_venta = tdv.cod_tipodoc_venta and ";
        sql += " sv.COD_TIPODOC_VENTA in (2, 1, 3) and ";
        sql += " sv.cod_estado_salidaventa = esv.cod_estado_salidaventa and ";
        sql += " sv.cod_estado_salidaventa = 1 and ";
        sql += " sv.fecha_salidaventa <= '" + fechaHasta + "' and ";
        sql += " sv.cod_almacen_venta = av.cod_almacen_venta and ";
        sql += " av.cod_area_empresa = '" + codAreaEmpresa + "' and  ";
        sql += " av.cod_area_empresa = ae.cod_area_empresa and ";
        sql += " sv.monto_total >(select ISNULL(sum(monto_cobranza), 0) as total_cobranza from cobranzas_detalle cd, cobranzas c where cd.cod_cobranza = c.cod_cobranza ";
        sql += " and c.fecha_cobranza <= '" + fechaHasta + "' and cd.cod_salidaventa =sv.cod_salidaventa) ";

        Statement stCuentasCobrarDestino = conDestino.createStatement();
        ResultSet rsCuentasCobrarDestino = stCuentasCobrarDestino.executeQuery(sql);
        double cuentasporCobrarMontoTotalDestino = 0.0d;
        double cuentasporCobrarMontoCanceladoDestino = 0.0d;
        while (rsCuentasCobrarDestino.next()) {
        cuentasporCobrarMontoTotalDestino = cuentasporCobrarMontoTotalDestino + rsCuentasCobrarDestino.getDouble(1);
        cuentasporCobrarMontoCanceladoDestino = cuentasporCobrarMontoCanceladoDestino + rsCuentasCobrarDestino.getDouble(3);

        }

        rsCuentasCobrarDestino.close();
        stCuentasCobrarDestino.close();

        sql = " select sv.monto_total,sv.monto_cancelado,(select ISNULL(sum(monto_cobranza), 0) as total_cobranza from   cobranzas_detalle cd, cobranzas c where cd.cod_cobranza = c.cod_cobranza and c.fecha_cobranza <= '" + fechaHasta + "' and sv.COD_TIPODOC_VENTA in (2, 1,3) and cd.cod_salidaventa = sv.cod_salidaventa) as total_cobranza ";
        sql += " from salidas_ventas sv,tipo_documentos_ventas tdv,estados_salida_ventas esv,almacenes_ventas av, areas_empresa ae  ";
        sql += " where monto_total > (select ISNULL(sum(monto_cobranza), 0) + 1 from cobranzas_detalle cd,cobranzas c where cd.cod_cobranza = c.cod_cobranza and c.fecha_cobranza         <= '" + fechaHasta + "' and cd.cod_salidaventa = sv.cod_salidaventa) and  ";
        sql += " sv.cod_tipodoc_venta = tdv.cod_tipodoc_venta and ";
        sql += " sv.COD_TIPODOC_VENTA in (2, 1, 3) and ";
        sql += " sv.cod_estado_salidaventa = esv.cod_estado_salidaventa and ";
        sql += " sv.cod_estado_salidaventa = 1 and ";
        sql += " sv.fecha_salidaventa <= '" + fechaHasta + "' and ";
        sql += " sv.cod_almacen_venta = av.cod_almacen_venta and ";
        sql += " av.cod_area_empresa = '" + codAreaEmpresa + "' and  ";
        sql += " av.cod_area_empresa = ae.cod_area_empresa and ";
        sql += " sv.monto_total >(select ISNULL(sum(monto_cobranza), 0) as total_cobranza from cobranzas_detalle cd, cobranzas c where cd.cod_cobranza = c.cod_cobranza ";
        sql += " and c.fecha_cobranza <= '" + fechaHasta + "' and cd.cod_salidaventa =sv.cod_salidaventa) ";

        Statement stCuentasCobrarOrigen = conOrigen.createStatement();
        ResultSet rsCuentasCobrarOrigen = stCuentasCobrarOrigen.executeQuery(sql);
        double cuentasporCobrarMontoTotalOrigen = 0.0d;
        double cuentasporCobrarMontoCanceladoOrigen = 0.0d;
        while (rsCuentasCobrarOrigen.next()) {
        cuentasporCobrarMontoTotalOrigen = cuentasporCobrarMontoTotalOrigen + rsCuentasCobrarOrigen.getDouble(1);
        cuentasporCobrarMontoCanceladoOrigen = cuentasporCobrarMontoCanceladoOrigen + rsCuentasCobrarOrigen.getDouble(3);

        }


        double diferencia1 = Math.abs((cuentasporCobrarMontoTotalDestino - cuentasporCobrarMontoTotalOrigen));
        double diferencia2 = Math.abs((cuentasporCobrarMontoCanceladoDestino - cuentasporCobrarMontoCanceladoOrigen));

        //System.out.println("diferencia1:"+diferencia1);
        //System.out.println("diferencia2:"+diferencia2);
        if (diferencia1 > 1 || diferencia2 > 1) {
        System.out.println("|--------------------- CUENTAS X COBRABR HAY PROBLEMAS --------------------------------------------------|");
        System.out.println("|--------------------- DESTINO ---------------------------- ORIGEN --------------------|");
        System.out.println("|    MontoTotal | " + cuentasporCobrarMontoTotalDestino + "\t\t\t |" + cuentasporCobrarMontoTotalOrigen + "|");
        System.out.println("|MontoCancelado | " + cuentasporCobrarMontoCanceladoDestino + "\t\t\t |" + cuentasporCobrarMontoCanceladoOrigen + "|");
        System.out.println("|--------------------------------------------------------------------------------------|");
        System.out.println("|         Saldo | " + (cuentasporCobrarMontoTotalDestino - cuentasporCobrarMontoCanceladoDestino) + "\t\t\t |" + (cuentasporCobrarMontoTotalOrigen - cuentasporCobrarMontoCanceladoOrigen) + "|");
        System.out.println("---------------------------------------------------------------------------------------");
        } else {
        System.out.println("|--------------------- CUENTAS X COBRAR TODO BIEN ------------------------------------------------------|");
        System.out.println("|--------------------- DESTINO ---------------------------- ORIGEN --------------------|");
        System.out.println("|    MontoTotal | " + cuentasporCobrarMontoTotalDestino + "\t\t\t |" + cuentasporCobrarMontoTotalOrigen + "|");
        System.out.println("|MontoCancelado | " + cuentasporCobrarMontoCanceladoDestino + "\t\t\t |" + cuentasporCobrarMontoCanceladoOrigen + "|");
        System.out.println("|--------------------------------------------------------------------------------------|");
        System.out.println("|         Saldo | " + (cuentasporCobrarMontoTotalDestino - cuentasporCobrarMontoCanceladoDestino) + "\t\t\t |" + (cuentasporCobrarMontoTotalOrigen - cuentasporCobrarMontoCanceladoOrigen) + "|");
        System.out.println("---------------------------------------------------------------------------------------");
        }*/


        } catch (Exception e) {
            e.printStackTrace();
        }


    }

    public void procesoMigracionCentral2(String codAreaEmpresa, String fechaDesde, String fechaHasta) {


        System.out.println("INICIALIZO::::::::::::::" + codAreaEmpresa);
        Connection conOrigen = getConnectionParam(host, password, bd);
        try {


            String sql = "";
            /*
            sql="select sum(monto_total),sum(monto_cancelado) from salidas_ventas where cod_almacen_venta in(select cod_almacen_venta from almacenes_ventas where cod_area_empresa="+codAreaEmpresa+") and FECHA_SALIDAVENTA >='"+fechaDesde+"'    and FECHA_SALIDAVENTA<='"+fechaHasta+"'";
            //sql="SELECT sum(monto_total),sum(monto_cancelado) ";
            //sql+="  from SALIDAS_VENTAS  where cod_almacen_venta in(select COD_ALMACEN_VENTA from ALMACENES_VENTAS where COD_AREA_EMPRESA="+codAreaEmpresa+")";
            Statement stVerificacionSalidasDestino=conDestino.createStatement();
            ResultSet rsVerificacionSalidasDestino=stVerificacionSalidasDestino.executeQuery(sql);
            double montoTotalDestino=0.0;
            double montoTotalCanceladoDestino=0.0;
            if(rsVerificacionSalidasDestino.next()){
            montoTotalDestino=montoTotalDestino+rsVerificacionSalidasDestino.getDouble(1);
            montoTotalCanceladoDestino=montoTotalCanceladoDestino+rsVerificacionSalidasDestino.getDouble(2);
            }
            rsVerificacionSalidasDestino.close();
            stVerificacionSalidasDestino.close();



            //sql="SELECT sum(monto_total),sum(monto_cancelado) ";
            //sql+="  from SALIDAS_VENTAS  where cod_almacen_venta in(select COD_ALMACEN_VENTA from ALMACENES_VENTAS where COD_AREA_EMPRESA="+codAreaEmpresa+")";
            Statement stVerificacionSalidasOrigen=conOrigen.createStatement();
            ResultSet rsVerificacionSalidasOrigen=stVerificacionSalidasOrigen.executeQuery(sql);
            double montoTotalOrigen=0.0;
            double montoTotalCanceladoOrigen=0.0;
            if(rsVerificacionSalidasOrigen.next()){
            montoTotalOrigen=montoTotalOrigen+rsVerificacionSalidasOrigen.getDouble(1);
            montoTotalCanceladoOrigen=montoTotalCanceladoOrigen+rsVerificacionSalidasOrigen.getDouble(2);
            }
            rsVerificacionSalidasOrigen.close();
            stVerificacionSalidasOrigen.close();

            if(montoTotalOrigen==montoTotalDestino && montoTotalCanceladoDestino==montoTotalCanceladoOrigen){
            System.out.println("OK...:montoTotal:"+montoTotalOrigen);
            System.out.println("OK...:montoTotalCancelado:"+montoTotalCanceladoOrigen);
            }

             */
            sql = " select sv.monto_total,sv.monto_cancelado,(select ISNULL(sum(monto_cobranza), 0) as total_cobranza from   cobranzas_detalle cd, cobranzas c where cd.cod_cobranza = c.cod_cobranza and c.fecha_cobranza <= '" + fechaHasta + "' and sv.COD_TIPODOC_VENTA in (2, 1,3) and cd.cod_salidaventa = sv.cod_salidaventa) as total_cobranza ";
            sql += " from salidas_ventas sv,tipo_documentos_ventas tdv,estados_salida_ventas esv,almacenes_ventas av, areas_empresa ae  ";
            sql += " where monto_total > (select ISNULL(sum(monto_cobranza), 0) + 1 from cobranzas_detalle cd,cobranzas c where cd.cod_cobranza = c.cod_cobranza and c.fecha_cobranza         <= '" + fechaHasta + "' and cd.cod_salidaventa = sv.cod_salidaventa) and  ";
            sql += " sv.cod_tipodoc_venta = tdv.cod_tipodoc_venta and ";
            sql += " sv.COD_TIPODOC_VENTA in (2, 1, 3) and ";
            sql += " sv.cod_estado_salidaventa = esv.cod_estado_salidaventa and ";
            sql += " sv.cod_estado_salidaventa = 1 and ";
            sql += " sv.fecha_salidaventa <= '" + fechaHasta + "' and ";
            sql += " sv.cod_almacen_venta = av.cod_almacen_venta and ";
            sql += " av.cod_area_empresa = '" + codAreaEmpresa + "' and  ";
            sql += " av.cod_area_empresa = ae.cod_area_empresa and ";
            sql += " sv.monto_total >(select ISNULL(sum(monto_cobranza), 0) as total_cobranza from cobranzas_detalle cd, cobranzas c where cd.cod_cobranza = c.cod_cobranza ";
            sql += " and c.fecha_cobranza <= '" + fechaHasta + "' and cd.cod_salidaventa =sv.cod_salidaventa) ";

            Statement stCuentasCobrarDestino = conDestino.createStatement();
            ResultSet rsCuentasCobrarDestino = stCuentasCobrarDestino.executeQuery(sql);
            double cuentasporCobrarMontoTotalDestino = 0.0d;
            double cuentasporCobrarMontoCanceladoDestino = 0.0d;
            while (rsCuentasCobrarDestino.next()) {
                cuentasporCobrarMontoTotalDestino = cuentasporCobrarMontoTotalDestino + rsCuentasCobrarDestino.getDouble(1);
                cuentasporCobrarMontoCanceladoDestino = cuentasporCobrarMontoCanceladoDestino + rsCuentasCobrarDestino.getDouble(3);

            }

            rsCuentasCobrarDestino.close();
            stCuentasCobrarDestino.close();

            sql = " select sv.monto_total,sv.monto_cancelado,(select ISNULL(sum(monto_cobranza), 0) as total_cobranza from   cobranzas_detalle cd, cobranzas c where cd.cod_cobranza = c.cod_cobranza and c.fecha_cobranza <= '" + fechaHasta + "' and sv.COD_TIPODOC_VENTA in (2, 1,3) and cd.cod_salidaventa = sv.cod_salidaventa) as total_cobranza ";
            sql += " from salidas_ventas sv,tipo_documentos_ventas tdv,estados_salida_ventas esv,almacenes_ventas av, areas_empresa ae  ";
            sql += " where monto_total > (select ISNULL(sum(monto_cobranza), 0) + 1 from cobranzas_detalle cd,cobranzas c where cd.cod_cobranza = c.cod_cobranza and c.fecha_cobranza         <= '" + fechaHasta + "' and cd.cod_salidaventa = sv.cod_salidaventa) and  ";
            sql += " sv.cod_tipodoc_venta = tdv.cod_tipodoc_venta and ";
            sql += " sv.COD_TIPODOC_VENTA in (2, 1, 3) and ";
            sql += " sv.cod_estado_salidaventa = esv.cod_estado_salidaventa and ";
            sql += " sv.cod_estado_salidaventa = 1 and ";
            sql += " sv.fecha_salidaventa <= '" + fechaHasta + "' and ";
            sql += " sv.cod_almacen_venta = av.cod_almacen_venta and ";
            sql += " av.cod_area_empresa = '" + codAreaEmpresa + "' and  ";
            sql += " av.cod_area_empresa = ae.cod_area_empresa and ";
            sql += " sv.monto_total >(select ISNULL(sum(monto_cobranza), 0) as total_cobranza from cobranzas_detalle cd, cobranzas c where cd.cod_cobranza = c.cod_cobranza ";
            sql += " and c.fecha_cobranza <= '" + fechaHasta + "' and cd.cod_salidaventa =sv.cod_salidaventa) ";

            Statement stCuentasCobrarOrigen = conOrigen.createStatement();
            ResultSet rsCuentasCobrarOrigen = stCuentasCobrarOrigen.executeQuery(sql);
            double cuentasporCobrarMontoTotalOrigen = 0.0d;
            double cuentasporCobrarMontoCanceladoOrigen = 0.0d;
            while (rsCuentasCobrarOrigen.next()) {
                cuentasporCobrarMontoTotalOrigen = cuentasporCobrarMontoTotalOrigen + rsCuentasCobrarOrigen.getDouble(1);
                cuentasporCobrarMontoCanceladoOrigen = cuentasporCobrarMontoCanceladoOrigen + rsCuentasCobrarOrigen.getDouble(3);

            }


            double diferencia1 = Math.abs((cuentasporCobrarMontoTotalDestino - cuentasporCobrarMontoTotalOrigen));
            double diferencia2 = Math.abs((cuentasporCobrarMontoCanceladoDestino - cuentasporCobrarMontoCanceladoOrigen));

            //System.out.println("diferencia1:"+diferencia1);
            //System.out.println("diferencia2:"+diferencia2);
            if (diferencia1 > 1 || diferencia2 > 1) {
                System.out.println("|--------------------- CUENTAS X COBRABR HAY PROBLEMAS --------------------------------------------------|");
                System.out.println("|--------------------- DESTINO ---------------------------- ORIGEN --------------------|");
                System.out.println("|    MontoTotal | " + cuentasporCobrarMontoTotalDestino + "\t\t\t |" + cuentasporCobrarMontoTotalOrigen + "|");
                System.out.println("|MontoCancelado | " + cuentasporCobrarMontoCanceladoDestino + "\t\t\t |" + cuentasporCobrarMontoCanceladoOrigen + "|");
                System.out.println("|--------------------------------------------------------------------------------------|");
                System.out.println("|         Saldo | " + (cuentasporCobrarMontoTotalDestino - cuentasporCobrarMontoCanceladoDestino) + "\t\t\t |" + (cuentasporCobrarMontoTotalOrigen - cuentasporCobrarMontoCanceladoOrigen) + "|");
                System.out.println("---------------------------------------------------------------------------------------");
            } else {
                System.out.println("|--------------------- CUENTAS X COBRAR TODO BIEN ------------------------------------------------------|");
                System.out.println("|--------------------- DESTINO ---------------------------- ORIGEN --------------------|");
                System.out.println("|    MontoTotal | " + cuentasporCobrarMontoTotalDestino + "\t\t\t |" + cuentasporCobrarMontoTotalOrigen + "|");
                System.out.println("|MontoCancelado | " + cuentasporCobrarMontoCanceladoDestino + "\t\t\t |" + cuentasporCobrarMontoCanceladoOrigen + "|");
                System.out.println("|--------------------------------------------------------------------------------------|");
                System.out.println("|         Saldo | " + (cuentasporCobrarMontoTotalDestino - cuentasporCobrarMontoCanceladoDestino) + "\t\t\t |" + (cuentasporCobrarMontoTotalOrigen - cuentasporCobrarMontoCanceladoOrigen) + "|");
                System.out.println("---------------------------------------------------------------------------------------");
            }


        } catch (Exception e) {
            e.printStackTrace();
        }


    }

    public void crear(int codAreaEmpresa) {



        //int codAreaEmpresa=52;//RIBERALTA

        // int codAreaEmpresa=63;//oruro
        // int codAreaEmpresa=55;//TRINIDAD
        //int codAreaEmpresa=47;//ELALTO
        // int codAreaEmpresa=56;//TARIJA

        // int codAreaEmpresa=49;//CBBA
        // int codAreaEmpresa=54;//SUCRE


        //  int codAreaEmpresa=49;//CBBA

        //int codAreaEmpresa=56;//TARIJA
        //int codAreaEmpresa=52;//riberalta

        //borramos
        //borramos INGRESOS Y SALIDAS

        //    int codAreaEmpresa=48;//POTOSI
        //  int codAreaEmpresa=48;//POTOSI
        //int codAreaEmpresa=51;//QUILLCOLLO
        //int codAreaEmpresa=47;//ORURO
        //int codAreaEmpresa=63;//ORURO

        //int codAreaEmpresa=55;//TRINIDAD
        //int codAreaEmpresa=49;//CBBA
        // int codAreaEmpresa=63;//oruro

        //int codAreaEmpresa=51;//QUILLACOLLO

        //int codAreaEmpresa=54;//QUILLACOLLO
        //int codAreaEmpresa=47;//el alto
        //int codAreaEmpresa=56;//tarija



        try {

            //BORRAR INGRESOS
            String sqlBorrarIngresos = "select cod_ingresoventas from ingresos_ventas where cod_almacen_venta in (select cod_almacen_venta from almacenes_ventas where cod_area_empresa=" + codAreaEmpresa + ")";
            //String sqlBorrarIngresos="select cod_ingreso_ventas from ingresos_ventas where cod_almacen_venta="+codAlmacenVenta;
            Statement stBorrarIngresos = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rsBorrarIngresos = stBorrarIngresos.executeQuery(sqlBorrarIngresos);
            while (rsBorrarIngresos.next()) {
                int codIngreso = rsBorrarIngresos.getInt(1);
                //borramos detalle
                String sqlDelete = "delete from INGRESOS_DETALLEVENTAS where cod_ingresoventas=" + codIngreso;
                Statement stDelete = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                int resultado = stDelete.executeUpdate(sqlDelete);
                System.out.println("resultado:" + resultado);
                //borramos cabecera
                sqlDelete = "delete from ingresos_ventas where cod_ingresoventas=" + codIngreso;
                stDelete.executeUpdate(sqlDelete);


                stDelete.close();
            }
            //BORRAR SALIDAS
            String sqlBorrarSalidas = "select cod_salidaventa from salidas_ventas where cod_almacen_venta in(select cod_almacen_venta from almacenes_ventas where cod_area_empresa=" + codAreaEmpresa + ")";
            Statement stBorrarSalidas = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rsBorrarSalidas = stBorrarSalidas.executeQuery(sqlBorrarSalidas);
            while (rsBorrarSalidas.next()) {
                int codSalida = rsBorrarSalidas.getInt(1);
                //borramos detalle
                String sqlDelete = "delete from salidas_detalleventas where cod_salidaventas=" + codSalida;
                Statement stDelete = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                int resultado = stDelete.executeUpdate(sqlDelete);
                //borramos ventas_pedidos
                sqlDelete = "delete from ventas_pedidos where cod_salidaventa=" + codSalida;
                resultado = stDelete.executeUpdate(sqlDelete);
                //borramos cabecera
                sqlDelete = "delete from salidas_ventas where cod_salidaventa=" + codSalida;
                resultado = stDelete.executeUpdate(sqlDelete);
                System.out.println("resultado:salidas:" + resultado);
                stDelete.close();
            }

            //FIN BORRAR INGRESOS Y SALIDAS

            //BORRAMOS COBRANZAS
            String sqlBorrarCobranzas = "select cod_cobranza from cobranzas where cod_area_empresa=" + codAreaEmpresa;
            Statement stBorrarCobranzas = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rsBorrarCobranzas = stBorrarCobranzas.executeQuery(sqlBorrarCobranzas);
            while (rsBorrarCobranzas.next()) {
                int codCobranza = rsBorrarCobranzas.getInt(1);

                String sqlDelete = "delete from cobranzas_detalle where cod_cobranza=" + codCobranza;
                Statement stDelete = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                stDelete.executeUpdate(sqlDelete);
                //borramos cobranzas
                sqlDelete = "delete from cobranzas where cod_cobranza=" + codCobranza;
                stDelete.executeUpdate(sqlDelete);

            }




            //INSERCION DE DATOS
            //INGRESOS
            String sqlIngresos = "select cod_gestion, cod_ingresoventas, cod_salida_acond, cod_salidaventa, cod_almacen_venta, " +
                    "cod_almacen_ventaorigen, cod_tipoingresoventas, nro_ingresoventas, fecha_ingresoventas, " +
                    "cod_estado_ingresoventas, obs_ingresoventas, cod_cliente from ingresos_ventas where cod_almacen_venta " +
                    "in (select cod_almacen_venta from almacenes_ventas where cod_area_empresa=" + codAreaEmpresa + ")";
            Statement stIngresos = conOrigen.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rsIngresos = stIngresos.executeQuery(sqlIngresos);
            while (rsIngresos.next()) {
                System.out.println("XXXXXXXXXXXxxxxxxxx");
                int cod_gestion = rsIngresos.getInt(1);
                int cod_ingresoventas = rsIngresos.getInt(2);
                int cod_salida_acond = rsIngresos.getInt(3);
                int cod_salidaventa = rsIngresos.getInt(4);
                int cod_almacen_venta = rsIngresos.getInt(5);
                int cod_almacen_ventaorigen = rsIngresos.getInt(6);
                int cod_tipoingresoventas = rsIngresos.getInt(7);
                int nro_ingresoventas = rsIngresos.getInt(8);
                Date fecha_ingresoventas = rsIngresos.getDate(9);
                int cod_estado_ingresoventas = rsIngresos.getInt(10);
                String obs_ingresoventas = rsIngresos.getString(11);
                int cod_cliente = rsIngresos.getInt(12);

                //generamos el codigo correlativo11
                String sqlCorrelativo = "select max(cod_ingresoventas)+1 as maximo from ingresos_ventas";
                Statement stCorrelativo = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rsCorrelativo = stCorrelativo.executeQuery(sqlCorrelativo);
                rsCorrelativo.next();
                int codigoIngresoInsertar = rsCorrelativo.getInt(1);

                //insertamos ingreso
                String sqlInsertIngreso = "insert into INGRESOS_VENTAS (cod_gestion, cod_ingresoventas, cod_salida_acond, cod_salidaventa, cod_almacen_venta, " +
                        "cod_almacen_ventaorigen, cod_tipoingresoventas, nro_ingresoventas, fecha_ingresoventas, " +
                        "cod_estado_ingresoventas, obs_ingresoventas, cod_cliente) values (" + cod_gestion + ", " + codigoIngresoInsertar + ", " +
                        "" + cod_salida_acond + ", " + cod_salidaventa + ", " + cod_almacen_venta + ", " + cod_almacen_ventaorigen + ", " + cod_tipoingresoventas + ", " +
                        "" + nro_ingresoventas + ", '" + f.format(fecha_ingresoventas) + "', " + cod_estado_ingresoventas + ", '" + obs_ingresoventas + "', " +
                        "" + cod_cliente + ")";

                Statement stInsertIngreso = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                stInsertIngreso.executeUpdate(sqlInsertIngreso);
                System.out.println("sqlInsertIngreso:" + sqlInsertIngreso);

                String sqlDetalleIngreso = "select cod_ingresoventas, cod_presentacion, cod_lote_produccion, cantidad, " +
                        "cantidad_unitaria, cantidad_restante, cantidad_unitariarestante, cod_tipoobsingreso, costo_almacen, " +
                        "fecha_venc, obs_ingresoprod, costo_actualizado, costo_actualizado_final, fecha_actualizacion, " +
                        "cantidad_frv, cantidadunitaria_frv, cantidad_mas, cantidadunitaria_mas, cantidad_menos, " +
                        "cantidadunitaria_menos from ingresos_detalleventas where cod_ingresoventas=" + cod_ingresoventas;
                Statement stDetalleIngreso = conOrigen.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rsInsertIngresoDetalle = stDetalleIngreso.executeQuery(sqlDetalleIngreso);

                while (rsInsertIngresoDetalle.next()) {

                    int cod_presentacion = rsInsertIngresoDetalle.getInt(2);
                    String cod_lote_produccion = rsInsertIngresoDetalle.getString(3);
                    int cantidad = rsInsertIngresoDetalle.getInt(4);
                    int cantidad_unitaria = rsInsertIngresoDetalle.getInt(5);
                    int cantidad_restante = rsInsertIngresoDetalle.getInt(6);
                    int cantidad_unitariarestante = rsInsertIngresoDetalle.getInt(7);
                    int cod_tipoobsingreso = rsInsertIngresoDetalle.getInt(8);
                    float costo_almacen = rsInsertIngresoDetalle.getFloat(9);
                    Date fecha_venc = rsInsertIngresoDetalle.getDate(10);
                    String obs_ingresoprod = rsInsertIngresoDetalle.getString(11);
                    float costo_actualizado = rsInsertIngresoDetalle.getFloat(12);
                    float costo_actualizado_final = rsInsertIngresoDetalle.getFloat(13);
                    Date fecha_actualizacion = rsInsertIngresoDetalle.getDate(14);
                    int cantidad_frv = rsInsertIngresoDetalle.getInt(15);
                    int cantidadunitaria_frv = rsInsertIngresoDetalle.getInt(16);
                    int cantidad_mas = rsInsertIngresoDetalle.getInt(17);
                    int cantidad_unitaria_mas = rsInsertIngresoDetalle.getInt(18);
                    int cantidad_menos = rsInsertIngresoDetalle.getInt(19);
                    int cantidadunitaria_menos = rsInsertIngresoDetalle.getInt(20);
                    String sqlinsertaDetalle = "insert into ingresos_detalleventas (cod_ingresoventas, cod_presentacion, cod_lote_produccion, cantidad, " +
                            "cantidad_unitaria, cantidad_restante, cantidad_unitariarestante, cod_tipoobsingreso, costo_almacen, " +
                            "fecha_venc, obs_ingresoprod, costo_actualizado, costo_actualizado_final, fecha_actualizacion, " +
                            "cantidad_frv, cantidadunitaria_frv, cantidad_mas, cantidadunitaria_mas, cantidad_menos, " +
                            "cantidadunitaria_menos) values(" + codigoIngresoInsertar + ", " + cod_presentacion + ", '" + cod_lote_produccion + "', " + cantidad + ", " +
                            "" + cantidad_unitaria + ", " + cantidad_restante + ", " + cantidad_unitariarestante + ", " + cod_tipoobsingreso + ", " +
                            "" + costo_almacen + ", '" + f.format(fecha_venc) + "', '" + obs_ingresoprod + "', " + costo_actualizado + ", " +
                            "" + costo_actualizado_final + ", " + fecha_actualizacion + ", " + cantidad_frv + ", " + cantidadunitaria_frv + ", " +
                            "" + cantidad_mas + ", " + cantidad_unitaria_mas + ", " + cantidad_menos + ", " + cantidadunitaria_menos + ")";
                    System.out.println("sqlinsertaDetalle:" + sqlinsertaDetalle);
                    Statement stInsertaDetalle = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    stInsertaDetalle.executeUpdate(sqlinsertaDetalle);

                }
                rsInsertIngresoDetalle.close();
                stDetalleIngreso.close();

            }


            //INSERTANDO SALIDAS

            double montoTotalVentas = 0.0f;
            String sql = "";
            sql += "SELECT cod_gestion,cod_salidaventa, ";
            sql += " cod_almacen_venta,cod_almacen_ventadestino, ";
            sql += "       nro_salidaventa,fecha_salidaventa, ";
            sql += " cod_estado_salidaventa,cod_tipodoc_venta, ";
            sql += "       nro_factura,cod_tiposalidaventas,  ";
            sql += " cod_tipoventa,cod_pedidoventa,cod_cliente,  ";
            sql += "       obs_salidaventa,monto_total,porcentaje_descuento,  ";
            sql += "       cod_salida_mat_promocional,monto_cancelado,cod_personal  ";
            sql += "       from SALIDAS_VENTAS  where cod_almacen_venta in(select COD_ALMACEN_VENTA from ALMACENES_VENTAS where COD_AREA_EMPRESA=" + codAreaEmpresa + ")";

            Statement salidasSt = conOrigen.createStatement();
            ResultSet rsSalidas = salidasSt.executeQuery(sql);
            while (rsSalidas.next()) {
                String cod_gestion = rsSalidas.getString(1);
                int cod_salidaventa = rsSalidas.getInt(2);
                String cod_almacen_venta = rsSalidas.getString(3);
                String cod_almacen_ventadestino = rsSalidas.getString(4);
                String nro_salidaventa = rsSalidas.getString(5);
                Date fecha_salidaventa = rsSalidas.getDate(6);
                String cod_estado_salidaventa = rsSalidas.getString(7);
                String cod_tipodoc_venta = rsSalidas.getString(8);
                String nro_factura = rsSalidas.getString(9);
                String cod_tiposalidaventas = rsSalidas.getString(10);
                String cod_tipoventa = rsSalidas.getString(11);
                String cod_pedidoventa = rsSalidas.getString(12);
                String cod_cliente = rsSalidas.getString(13);
                String obs_salidaventa = rsSalidas.getString(14);
                float monto_total = rsSalidas.getFloat(15);
                if (!cod_estado_salidaventa.equals("2")) {
                    montoTotalVentas = montoTotalVentas + monto_total;
                }

                float porcentaje_descuento = rsSalidas.getFloat(16);
                String cod_salida_mat_promocional = rsSalidas.getString(17);
                cod_salida_mat_promocional = (cod_salida_mat_promocional == null) ? "0" : cod_salida_mat_promocional;
                cod_pedidoventa = (cod_pedidoventa == null) ? "0" : cod_pedidoventa;
                cod_almacen_ventadestino = (cod_almacen_ventadestino == null) ? "0" : cod_almacen_ventadestino;
                float monto_cancelado = rsSalidas.getFloat(18);
                String cod_personal = rsSalidas.getString(19);
                String sqlCorrelativo = "select max(COD_SALIDAVENTA)+1 from SALIDAS_VENTAS";
                Statement stCorrelativo = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rsCorrelativo = stCorrelativo.executeQuery(sqlCorrelativo);
                rsCorrelativo.next();
                int codigosalida = rsCorrelativo.getInt(1);
                String sqlInsertarSalidas = "insert into SALIDAS_VENTAS(cod_gestion,cod_salidaventa, ";
                sqlInsertarSalidas += " cod_almacen_venta,cod_almacen_ventadestino, ";
                sqlInsertarSalidas += "       nro_salidaventa,fecha_salidaventa, ";
                sqlInsertarSalidas += " cod_estado_salidaventa,cod_tipodoc_venta, ";
                sqlInsertarSalidas += "       nro_factura,cod_tiposalidaventas,  ";
                sqlInsertarSalidas += " cod_tipoventa,cod_pedidoventa,cod_cliente,  ";
                sqlInsertarSalidas += "       obs_salidaventa,monto_total,porcentaje_descuento,  ";
                sqlInsertarSalidas += "       cod_salida_mat_promocional,monto_cancelado,cod_personal";
                sqlInsertarSalidas += " )values(";
                sqlInsertarSalidas += " " + cod_gestion + "," + codigosalida + "," + cod_almacen_venta + ",";
                sqlInsertarSalidas += " " + cod_almacen_ventadestino + "," + nro_salidaventa + ",'" + f.format(fecha_salidaventa) + "',";
                sqlInsertarSalidas += " " + cod_estado_salidaventa + "," + cod_tipodoc_venta + "," + nro_factura + ",";
                sqlInsertarSalidas += " " + cod_tiposalidaventas + "," + cod_tipoventa + "," + cod_salidaventa + ",";
                sqlInsertarSalidas += " " + cod_cliente + ",'" + obs_salidaventa + "'," + monto_total + ",";
                sqlInsertarSalidas += " " + porcentaje_descuento + "," + cod_salida_mat_promocional + "," + monto_cancelado + ",";
                sqlInsertarSalidas += " " + cod_personal + ")";
                Statement stInsertSalidas = conDestino.createStatement();
                stInsertSalidas.executeUpdate(sqlInsertarSalidas);
                System.out.println("sqlInsertarSalidas:" + sqlInsertarSalidas);

                String sqlSelectSalidaDetalle = " select  ";
                sqlSelectSalidaDetalle += " cod_presentacion, ";
                sqlSelectSalidaDetalle += "        cod_lote_produccion, ";
                sqlSelectSalidaDetalle += " fecha_venc, ";
                sqlSelectSalidaDetalle += "        cantidad,cantidad_unitaria, ";
                sqlSelectSalidaDetalle += "        cantidad_bonificacion, ";
                sqlSelectSalidaDetalle += "        cantidad_unitariabonificacion, ";
                sqlSelectSalidaDetalle += "        cantidad_total, cantidad_unitariatotal, ";
                sqlSelectSalidaDetalle += "        porcentaje_aplicadoprecio,";
                sqlSelectSalidaDetalle += "        precio_lista,precio_venta, ";
                sqlSelectSalidaDetalle += "        costo_almacen, ";
                sqlSelectSalidaDetalle += "        costo_actualizado,costo_actualizado_final, ";
                sqlSelectSalidaDetalle += "        fecha_actualizacion ";
                sqlSelectSalidaDetalle += "        from SALIDAS_DETALLEVENTAS ";
                sqlSelectSalidaDetalle += "        where  cod_salidaventas=" + cod_salidaventa;
                Statement stSelectSalidaDetalle = conOrigen.createStatement();
                ResultSet rsSelectSalidaDetalle = stSelectSalidaDetalle.executeQuery(sqlSelectSalidaDetalle);
                while (rsSelectSalidaDetalle.next()) {
                    String cod_presentacion = rsSelectSalidaDetalle.getString(1);
                    String cod_lote_produccion = rsSelectSalidaDetalle.getString(2);
                    Date fecha_venc = rsSelectSalidaDetalle.getDate(3);
                    int cantidad = rsSelectSalidaDetalle.getInt(4);
                    int cantidad_unitaria = rsSelectSalidaDetalle.getInt(5);
                    int cantidad_bonificacion = rsSelectSalidaDetalle.getInt(6);
                    int cantidad_unitariabonificacion = rsSelectSalidaDetalle.getInt(7);
                    int cantidad_total = rsSelectSalidaDetalle.getInt(8);
                    int cantidad_unitariatotal = rsSelectSalidaDetalle.getInt(9);
                    float porcentaje_aplicadoprecio = rsSelectSalidaDetalle.getFloat(10);
                    float precio_lista = rsSelectSalidaDetalle.getFloat(11);
                    float precio_venta = rsSelectSalidaDetalle.getFloat(12);
                    float costo_almacen = rsSelectSalidaDetalle.getFloat(13);
                    float costo_actualizado = rsSelectSalidaDetalle.getFloat(14);
                    float costo_actualizado_final = rsSelectSalidaDetalle.getFloat(15);
                    Date fecha_actualizacion = rsSelectSalidaDetalle.getDate(16);
                    //costo_almacen costo_actualizado  costo_actualizado_final  fecha_actualizacion
                    String sqlInsertSalidaDetalle = "insert into SALIDAS_DETALLEVENTAS(";
                    sqlInsertSalidaDetalle += " cod_salidaventas, ";
                    sqlInsertSalidaDetalle += " cod_presentacion, ";
                    sqlInsertSalidaDetalle += "        cod_lote_produccion, ";
                    sqlInsertSalidaDetalle += " fecha_venc, ";
                    sqlInsertSalidaDetalle += "        cantidad,cantidad_unitaria, ";
                    sqlInsertSalidaDetalle += "        cantidad_bonificacion, ";
                    sqlInsertSalidaDetalle += "        cantidad_unitariabonificacion, ";
                    sqlInsertSalidaDetalle += "        cantidad_total, cantidad_unitariatotal, ";
                    sqlInsertSalidaDetalle += "        porcentaje_aplicadoprecio,";
                    sqlInsertSalidaDetalle += "        precio_lista,precio_venta, ";
                    sqlInsertSalidaDetalle += "        costo_almacen, ";
                    sqlInsertSalidaDetalle += "        costo_actualizado,costo_actualizado_final, ";
                    sqlInsertSalidaDetalle += "        fecha_actualizacion";
                    sqlInsertSalidaDetalle += "        )values(";
                    sqlInsertSalidaDetalle += "" + codigosalida + "," + cod_presentacion + ",'" + cod_lote_produccion + "',";
                    sqlInsertSalidaDetalle += "'" + f.format(fecha_venc) + "'," + cantidad + "," + cantidad_unitaria + ",";
                    sqlInsertSalidaDetalle += "" + cantidad_bonificacion + "," + cantidad_unitariabonificacion + "," + cantidad_total + ",";
                    sqlInsertSalidaDetalle += "" + cantidad_unitariatotal + "," + porcentaje_aplicadoprecio + "," + precio_lista + ",";
                    sqlInsertSalidaDetalle += "" + precio_venta + "," + costo_almacen + "," + costo_actualizado + ",";
                    sqlInsertSalidaDetalle += "" + costo_actualizado_final + "," + fecha_actualizacion + ")";
                    Statement stInsertSalidaDetalle = conDestino.createStatement();
                    stInsertSalidaDetalle.executeUpdate(sqlInsertSalidaDetalle);
                    System.out.println("sqlInsertSalidaDetalle:" + sqlInsertSalidaDetalle);
                }
                rsSelectSalidaDetalle.close();
                stSelectSalidaDetalle.close();

            }

            rsSalidas.close();
            salidasSt.close();



            String sqlPedidos = "";
            sqlPedidos += "SELECT cod_pedido,COD_ESTADOPEDIDO,NRO_PEDIDO,NRO_PEDIDOFISICO,COD_CLIENTE,COD_PERSONAL,COD_TIPOVENTA,FECHA_PEDIDO,COD_AREA_EMPRESA,OBS_PEDIDO,COD_TIPO_DOCUMENTO,DESCUENTO_TOTAL from pedidos where cod_area_empresa=" + codAreaEmpresa;
            //INSERTAMOS DATOS DE COBRANZAS
            Statement stPedidos = conOrigen.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rsPedidos = stPedidos.executeQuery(sqlPedidos);
            while (rsPedidos.next()) {

                int cod_pedido = rsPedidos.getInt(1);
                int COD_ESTADOPEDIDO = rsPedidos.getInt(2);
                int NRO_PEDIDO = rsPedidos.getInt(3);
                int NRO_PEDIDOFISICO = rsPedidos.getInt(4);
                int COD_CLIENTE = rsPedidos.getInt(5);
                int COD_PERSONAL = rsPedidos.getInt(6);
                int COD_TIPOVENTA = rsPedidos.getInt(7);
                Date FECHA_PEDIDO = rsPedidos.getDate(8);
                int COD_AREA_EMPRESA = rsPedidos.getInt(9);
                String OBS_PEDIDO = rsPedidos.getString(10);
                int COD_TIPO_DOCUMENTO = rsPedidos.getInt(11);
                float DESCUENTO_TOTAL = rsPedidos.getFloat(12);

                String sqlCorrelativoCobranza = "select max(cod_pedido)+1 as maximo from pedidos";
                Statement stCorrelativoCobranza = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rsCorrelativoCobranza = stCorrelativoCobranza.executeQuery(sqlCorrelativoCobranza);
                rsCorrelativoCobranza.next();
                int codCobranza = rsCorrelativoCobranza.getInt(1);
                //INSERTAMOS EN TABLA ---COBRANZAS---
                String sqlInsertCobranza = "insert into pedidos   (cod_pedido,COD_ESTADOPEDIDO,NRO_PEDIDO,NRO_PEDIDOFISICO,COD_CLIENTE,COD_PERSONAL,COD_TIPOVENTA,FECHA_PEDIDO,COD_AREA_EMPRESA,OBS_PEDIDO,COD_TIPO_DOCUMENTO,DESCUENTO_TOTAL)";
                sqlInsertCobranza += " values(";
                sqlInsertCobranza += "" + codCobranza + "," + COD_ESTADOPEDIDO + "," + NRO_PEDIDO + "," + NRO_PEDIDOFISICO + ",";
                sqlInsertCobranza += "" + COD_CLIENTE + "," + COD_PERSONAL + "," + COD_TIPOVENTA + ",'" + f.format(FECHA_PEDIDO) + "'," + COD_AREA_EMPRESA + ",'" + OBS_PEDIDO + "'," + COD_TIPO_DOCUMENTO + "," + DESCUENTO_TOTAL + ")";
                Statement stInsertCobranza = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                System.out.println("sqlInsertCobranza:" + sqlInsertCobranza);
                stInsertCobranza.executeUpdate(sqlInsertCobranza);
                //INSERTAMOS DATOS DE COBRANZAS DETALLE


                String sqlCobranzasSalidas = "select cod_salidaventa,cod_pedido  from ventas_pedidos where cod_pedido =" + cod_pedido;
                System.out.println("sqlCobranzasSalidas:" + sqlCobranzasSalidas);
                Statement stCobranzasSalidas = conOrigen.createStatement();
                ResultSet rsCobranzasSalidas = stCobranzasSalidas.executeQuery(sqlCobranzasSalidas);
                String codsalidaventa = "0";
                while (rsCobranzasSalidas.next()) {
                    codsalidaventa = rsCobranzasSalidas.getString(1);

                    String sqlvp = "select cod_salidaventa  from salidas_ventas where cod_salidaventa is not null and   COD_ALMACEN_VENTA in (select COD_ALMACEN_VENTA from ALMACENES_VENTAS  where cod_area_empresa =" + codAreaEmpresa + "  ) and cod_pedidoventa=" + codsalidaventa;
                    System.out.println("sqlCobranzasSalidas:" + sqlvp);
                    Statement stvp = conDestino.createStatement();
                    ResultSet rsvp = stvp.executeQuery(sqlvp);
                    while (rsvp.next()) {
                        codsalidaventa = rsvp.getString(1);
                        String sqlVpi = "insert into ventas_pedidos(cod_salidaventa,cod_pedido)values(" + codsalidaventa + "," + cod_pedido + ")";
                        System.out.println("sqlVpi:" + sqlVpi);
                        Statement stVps = conDestino.createStatement();
                        stVps.executeUpdate(sqlVpi);

                    }
                    rsvp.close();


                    stvp.close();



                }

                rsCobranzasSalidas.close();
                stCobranzasSalidas.close();




                String sqlCobranzasDetalle = "select [COD_PRESENTACION], [CANTIDAD_PEDIDO], [CANTIDAD_UNITARIAPEDIDO], [CANTIDAD_PEDIDOEFECTUADA], [CANTIDAD_UNITARIAPEDIDOEFECTUADA], [COD_ESTADO_DETALLEPEDIDO], [CANTIDAD_BONIFICACION], [CANTIDAD_UNITARIABONIFICACION], [OBS_PEDIDODETALLE],  [PRECIO_VENTA], [DESCUENTO] from PEDIDOS_DETALLE where cod_pedido=" + cod_pedido;
                //sqlCobranzasDetalle+= "nro_cheque, nro_cobranzadetalle, fecha_cobranzadetalle from cobranzas_detalle where cod_cobranza="+cod_cobranza;
                Statement stCobranzasDetalleOrigen = conOrigen.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rsCobranzasDetalleOrigen = stCobranzasDetalleOrigen.executeQuery(sqlCobranzasDetalle);
                while (rsCobranzasDetalleOrigen.next()) {

                    int COD_PRESENTACION = rsCobranzasDetalleOrigen.getInt(1);
                    int CANTIDAD_PEDIDO = rsCobranzasDetalleOrigen.getInt(2);
                    int CANTIDAD_UNITARIAPEDIDO = rsCobranzasDetalleOrigen.getInt(3);
                    int CANTIDAD_PEDIDOEFECTUADA = rsCobranzasDetalleOrigen.getInt(4);

                    int CANTIDAD_UNITARIAPEDIDOEFECTUADA = rsCobranzasDetalleOrigen.getInt(5);
                    int COD_ESTADO_DETALLEPEDIDO = rsCobranzasDetalleOrigen.getInt(6);



                    int CANTIDAD_BONIFICACION = rsCobranzasDetalleOrigen.getInt(7);
                    int CANTIDAD_UNITARIABONIFICACION = rsCobranzasDetalleOrigen.getInt(8);



                    String OBS_PEDIDODETALLE = rsCobranzasDetalleOrigen.getString(9);
                    float PRECIO_VENTA = rsCobranzasDetalleOrigen.getFloat(10);
                    float DESCUENTO = rsCobranzasDetalleOrigen.getFloat(11);


                    //INSERTAMOS EN TABLA ---COBRANZAS DETALLE---
                    String sqlInsertCobranzaDetalle = "INSERT INTO [PEDIDOS_DETALLE] ([COD_PEDIDO], [COD_PRESENTACION], [CANTIDAD_PEDIDO], [CANTIDAD_UNITARIAPEDIDO], [CANTIDAD_PEDIDOEFECTUADA], [CANTIDAD_UNITARIAPEDIDOEFECTUADA], [COD_ESTADO_DETALLEPEDIDO], [CANTIDAD_BONIFICACION], [CANTIDAD_UNITARIABONIFICACION], [OBS_PEDIDODETALLE],  [PRECIO_VENTA], [DESCUENTO]";
                    sqlInsertCobranzaDetalle += ") values(";
                    sqlInsertCobranzaDetalle += codCobranza + "," + COD_PRESENTACION + "," + CANTIDAD_PEDIDO + "," + CANTIDAD_UNITARIAPEDIDO + "," + CANTIDAD_PEDIDOEFECTUADA + "," + CANTIDAD_UNITARIAPEDIDOEFECTUADA + "," + COD_ESTADO_DETALLEPEDIDO + "," + CANTIDAD_BONIFICACION + "," + CANTIDAD_UNITARIABONIFICACION + ",'" + OBS_PEDIDODETALLE + "'," + PRECIO_VENTA + "," + DESCUENTO + ")";
                    System.out.println("sqlInsertCobranzaDetalle:" + sqlInsertCobranzaDetalle);
                    Statement stInsertCobranzaDetalle = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    stInsertCobranzaDetalle.executeUpdate(sqlInsertCobranzaDetalle);
                }
                rsCobranzasDetalleOrigen.close();
            }




            String sqlCobranzas = "select cod_cobranza, cod_personal, nro_cobranza, cod_tipo_cobranza, cod_estado_cobranza, ";
            sqlCobranzas += "fecha_cobranza, obs_cobranza, cod_area_empresa from cobranzas where cod_area_empresa=" + codAreaEmpresa;
            Statement stCobranzasOrigen = conOrigen.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rsCobranzasOrigen = stCobranzasOrigen.executeQuery(sqlCobranzas);
            while (rsCobranzasOrigen.next()) {
                int cod_cobranza = rsCobranzasOrigen.getInt(1);
                int cod_personal = rsCobranzasOrigen.getInt(2);
                int nro_cobranza = rsCobranzasOrigen.getInt(3);
                int cod_tipo_cobranza = rsCobranzasOrigen.getInt(4);
                int cod_estado_cobranza = rsCobranzasOrigen.getInt(5);
                Date fecha_cobranza = rsCobranzasOrigen.getDate(6);
                String obs_cobranza = rsCobranzasOrigen.getString(7);
                int cod_area_empresa = rsCobranzasOrigen.getInt(8);
                //GENERAR CODIGO CORRELATIVO COBRANZAS..............................................................................
                String sqlCorrelativoCobranza = "select max(cod_cobranza)+1 as maximo from cobranzas";
                Statement stCorrelativoCobranza = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rsCorrelativoCobranza = stCorrelativoCobranza.executeQuery(sqlCorrelativoCobranza);
                rsCorrelativoCobranza.next();
                int codCobranza = rsCorrelativoCobranza.getInt(1);
                //INSERTAMOS EN TABLA ---COBRANZAS---
                String sqlInsertCobranza = "insert into cobranzas (cod_cobranza, cod_personal, nro_cobranza, cod_tipo_cobranza, cod_estado_cobranza,";
                sqlInsertCobranza += "fecha_cobranza, obs_cobranza, cod_area_empresa) values(";
                sqlInsertCobranza += "" + codCobranza + "," + cod_personal + "," + nro_cobranza + "," + cod_tipo_cobranza + ",";
                sqlInsertCobranza += "" + cod_estado_cobranza + ",'" + f.format(fecha_cobranza) + "','" + obs_cobranza + "'," + cod_area_empresa + ")";
                Statement stInsertCobranza = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                System.out.println("sqlInsertCobranza:" + sqlInsertCobranza);
                stInsertCobranza.executeUpdate(sqlInsertCobranza);
                //INSERTAMOS DATOS DE COBRANZAS DETALLE
                String sqlCobranzasDetalle = "select cod_salidaventa, cod_tipo_pago, monto_cobranza, cod_banco, ";
                sqlCobranzasDetalle += "nro_cheque, nro_cobranzadetalle, fecha_cobranzadetalle from cobranzas_detalle where cod_cobranza=" + cod_cobranza;
                Statement stCobranzasDetalleOrigen = conOrigen.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rsCobranzasDetalleOrigen = stCobranzasDetalleOrigen.executeQuery(sqlCobranzasDetalle);
                while (rsCobranzasDetalleOrigen.next()) {
                    int cod_salidaventa = rsCobranzasDetalleOrigen.getInt(1);
                    int cod_tipo_pago = rsCobranzasDetalleOrigen.getInt(2);
                    float monto_cobranza = rsCobranzasDetalleOrigen.getFloat(3);
                    int cod_banco = rsCobranzasDetalleOrigen.getInt(4);
                    String nro_cheque = rsCobranzasDetalleOrigen.getString(5);
                    int nro_cobranzadetalle = rsCobranzasDetalleOrigen.getInt(6);
                    Date fecha_cobranzadetalle = rsCobranzasDetalleOrigen.getDate(7);
                    String sqlCobranzasSalidas = "select cod_salidaventa  from salidas_ventas where cod_salidaventa is not null and   COD_ALMACEN_VENTA in (select COD_ALMACEN_VENTA from ALMACENES_VENTAS  where cod_area_empresa =" + codAreaEmpresa + "  ) and cod_pedidoventa=" + cod_salidaventa;
                    System.out.println("sqlCobranzasSalidas:" + sqlCobranzasSalidas);
                    Statement stCobranzasSalidas = conDestino.createStatement();
                    ResultSet rsCobranzasSalidas = stCobranzasSalidas.executeQuery(sqlCobranzasSalidas);
                    String codsalidaventa = "0";
                    if (rsCobranzasSalidas.next()) {
                        codsalidaventa = rsCobranzasSalidas.getString(1);
                    }
                    rsCobranzasSalidas.close();
                    stCobranzasSalidas.close();

                    //INSERTAMOS EN TABLA ---COBRANZAS DETALLE---
                    String sqlInsertCobranzaDetalle = "insert into cobranzas_detalle (cod_salidaventa,cod_cobranza, cod_tipo_pago, monto_cobranza, cod_banco,";
                    sqlInsertCobranzaDetalle += "nro_cheque, nro_cobranzadetalle, fecha_cobranzadetalle) values(";
                    sqlInsertCobranzaDetalle += "" + codsalidaventa + "," + codCobranza + "," + cod_tipo_pago + "," + monto_cobranza + ",";
                    sqlInsertCobranzaDetalle += "" + cod_banco + ",'" + nro_cheque + "'," + nro_cobranzadetalle + ",'" + f.format(fecha_cobranzadetalle) + "')";
                    System.out.println("sqlInsertCobranzaDetalle:" + sqlInsertCobranzaDetalle);
                    Statement stInsertCobranzaDetalle = conDestino.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    stInsertCobranzaDetalle.executeUpdate(sqlInsertCobranzaDetalle);
                }
                rsCobranzasDetalleOrigen.close();
            }




            String sqlFacturasEmitidasEliminar = "delete from facturas_emitidas where cod_area_empresa=" + codAreaEmpresa;
            System.out.println("sqlFacturasEmitidasEliminar:" + sqlFacturasEmitidasEliminar);
            Statement stFacturasEmitidasEliminar = conDestino.createStatement();
            int resultado = stFacturasEmitidasEliminar.executeUpdate(sqlFacturasEmitidasEliminar);

            System.out.println("resultadoxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx:" + resultado);

            String sqlFacturas = "select cod_factura from facturas where cod_area_empresa=" + codAreaEmpresa;
            Statement stFacturas = conOrigen.createStatement();
            ResultSet rsFacturas = stFacturas.executeQuery(sqlFacturas);
            String codFactura = "";
            if (rsFacturas.next()) {
                codFactura = rsFacturas.getString(1);
            }
            rsFacturas.close();
            stFacturas.close();

            String sqlFacturasEmitidas = "select cod_factura,nro_factura,cod_area_empresa,cod_estado_factura,razon_social,nit,nro_autorizacion,fecha_factura,importe,ice,exentos,importe_neto,iva,codigo_control,glosa,cod_salidaventa from facturas_emitidas where cod_area_empresa=" + codAreaEmpresa;
            Statement stFacturasEmitidas = conOrigen.createStatement();
            ResultSet rsFacturasEmitidas = stFacturasEmitidas.executeQuery(sqlFacturasEmitidas);
            while (rsFacturasEmitidas.next()) {
                String cod_factura = rsFacturasEmitidas.getString(1);
                String nro_factura = rsFacturasEmitidas.getString(2);
                String cod_area_empresa = rsFacturasEmitidas.getString(3);
                String cod_estado_factura = rsFacturasEmitidas.getString(4);
                String razon_social = rsFacturasEmitidas.getString(5);
                String nit = rsFacturasEmitidas.getString(6);
                String nro_autorizacion = rsFacturasEmitidas.getString(7);
                Date fecha_factura = rsFacturasEmitidas.getDate(8);
                String importe = rsFacturasEmitidas.getString(9);
                String ice = rsFacturasEmitidas.getString(10);
                String exentos = rsFacturasEmitidas.getString(11);
                String importe_neto = rsFacturasEmitidas.getString(12);
                String iva = rsFacturasEmitidas.getString(13);
                String codigo_control = rsFacturasEmitidas.getString(14);
                String glosa = rsFacturasEmitidas.getString(15);
                String cod_salidaventa = rsFacturasEmitidas.getString(16);
                String sqlSalidas = "select cod_salidaventa  from salidas_ventas where cod_salidaventa is not null and COD_ALMACEN_VENTA in (select COD_ALMACEN_VENTA from ALMACENES_VENTAS  where cod_area_empresa =" + codAreaEmpresa + "  ) and cod_pedidoventa=" + cod_salidaventa;

                System.out.println("sqlSalidas:" + sqlSalidas);
                Statement stSalidas = conDestino.createStatement();
                ResultSet rsSalidasFacturas = stSalidas.executeQuery(sqlSalidas);
                String cod_salidaventan = "";
                if (rsSalidasFacturas.next()) {
                    cod_salidaventan = rsSalidasFacturas.getString(1);
                }
                System.out.println("cod_salidaventan:" + cod_salidaventan);



                String sqlInsertFacturasEmitidas = "insert into facturas_emitidas(cod_factura,nro_factura,cod_area_empresa,cod_estado_factura,razon_social,nit,nro_autorizacion,fecha_factura,importe,ice,exentos,importe_neto,iva,codigo_control,glosa,cod_salidaventa)values(";
                sqlInsertFacturasEmitidas += "" + cod_factura + "," + nro_factura + ",";
                sqlInsertFacturasEmitidas += "" + cod_area_empresa + "," + cod_estado_factura + ",";
                sqlInsertFacturasEmitidas += "'" + razon_social + "','" + nit + "','" + nro_autorizacion + "','" + f.format(fecha_factura) + "'," + importe + "," + ice + "," + exentos + "," + importe_neto + "," + iva + ",'" + codigo_control + "','" + glosa + "'," + cod_salidaventan + ")";
                System.out.println("sqlInsertFacturasEmitidas:" + sqlInsertFacturasEmitidas);
                Statement stInsertFacturasEmitidas = conDestino.createStatement();
                stInsertFacturasEmitidas.executeUpdate(sqlInsertFacturasEmitidas);




            }






        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) throws SQLException {

        //MigrarDatosCentral mc=new MigrarDatosCentral("172.16.10.21","CAR2_COCHABAMBA","n3td4t4");
        //mc.procesoMigracionCentral2("49","01/05/2009","01/12/2009");


        //MigrarDatosCentral m=new MigrarDatosCentral("172.16.10.21","CAR2_QUILLACOLLO","n3td4t4");
        //m.procesoMigracionCentral2("51","01/05/2009","01/12/2009");


        // MigrarDatosCentral m1=new MigrarDatosCentral("200.87.66.186","CAR2_CBBAANTERIOR","n3td4t4");
        // m1.pro();
        //
        //m1.procesoMigracionCentral2("47","2009-05-01","2009-05-31");

        MigrarDatosCentralOriginal m = new MigrarDatosCentralOriginal("172.16.10.21", "SARTORIUS", "n3td4t4");
        m.procesoMigracionCentral();


    /*
    MigrarDatosCentral mq=new MigrarDatosCentral("172.16.10.21","CAR2_QUILLACOLLO","n3td4t4");
    mq.procesoMigracionCentral("51","01/05/2009","01/12/2009");

    MigrarDatosCentral mP=new MigrarDatosCentral("172.16.10.21","CAR2_POTOSI","n3td4t4");
    mP.procesoMigracionCentral("48","01/05/2009","01/12/2009");



    MigrarDatosCentral m5=new MigrarDatosCentral("172.16.10.21","CAR2_RIBERALTA","n3td4t4");
    m5.procesoMigracionCentral("52","01/05/2009","01/12/2009");


    MigrarDatosCentral m7=new MigrarDatosCentral("172.16.10.21","CAR2_TARIJA","n3td4t4");
    m7.procesoMigracionCentral("56","01/05/2009","01/12/2009");

    MigrarDatosCentral m8=new MigrarDatosCentral("172.16.10.21","CAR2_ORURO","n3td4t4");
    m8.procesoMigracionCentral("63","01/05/2009","01/12/2009");

    MigrarDatosCentral m4=new MigrarDatosCentral("172.16.10.21","CAR2_SANTACRUZ","n3td4t4");
    m4.procesoMigracionCentral("53","01/05/2009","01/12/2009");
     */
    // MigrarDatosCentral m9=new MigrarDatosCentral("172.16.10.21","CAR2_SUCRE","n3td4t4");
    //m9.procesoMigracionCentral2("54","01/05/2009","01/12/2009");



    //  MigrarDatosCentral m4=new MigrarDatosCentral("172.16.10.21","CAR2_SANTACRUZ","n3td4t4");
    // m4.procesoMigracionCentral("53","01/05/2009","01/12/2009");



    /*

    MigrarDatosCentral m5=new MigrarDatosCentral("172.16.10.21","CAR2_RIBERALTA","n3td4t4");
    m5.procesoMigracionCentral2("52","01/05/2009","01/12/2009");
    MigrarDatosCentral m10=new MigrarDatosCentral("172.16.10.212","CAR2","n3td4t4");
    m10.procesoMigracionCentral("46","2009-05-01","2009-07-01");
     */


    }

    public void salidasAsalidas(String codAreaEmpresa, String fechaDesde, String fechaHasta) throws SQLException {

        String sql = "";
        sql += "SELECT cod_gestion,cod_salidaventa, ";
        sql += " cod_almacen_venta,cod_almacen_ventadestino, ";
        sql += "       nro_salidaventa,fecha_salidaventa, ";
        sql += " cod_estado_salidaventa,cod_tipodoc_venta, ";
        sql += "       nro_factura,cod_tiposalidaventas,  ";
        sql += " cod_tipoventa,cod_pedidoventa,cod_cliente,  ";
        sql += "       obs_salidaventa,monto_total,porcentaje_descuento,  ";
        sql += "       cod_salida_mat_promocional,monto_cancelado,cod_personal  ";
        sql += "       from SALIDAS_VENTAS  where cod_almacen_venta in(select COD_ALMACEN_VENTA from ALMACENES_VENTAS where COD_AREA_EMPRESA=" + codAreaEmpresa + ")";
        sql += "      and  fecha_salidaventa BETWEEN '" + fechaDesde + "' and '" + fechaHasta + "'";
        Statement st = conOrigen.createStatement();
        ResultSet rsSalidas = st.executeQuery(sql);
        while (rsSalidas.next()) {
            String cod_gestion = rsSalidas.getString(1);
            String cod_salidaventa = rsSalidas.getString(2);
            String cod_almacen_venta = rsSalidas.getString(3);

            float monto_total = rsSalidas.getFloat(15);

            String sqlSelectSalidaDetalle = " select  ";
            sqlSelectSalidaDetalle += " cod_presentacion, ";
            sqlSelectSalidaDetalle += "        cod_lote_produccion, ";
            sqlSelectSalidaDetalle += " fecha_venc, ";
            sqlSelectSalidaDetalle += "        cantidad,cantidad_unitaria, ";
            sqlSelectSalidaDetalle += "        cantidad_bonificacion, ";
            sqlSelectSalidaDetalle += "        cantidad_unitariabonificacion, ";
            sqlSelectSalidaDetalle += "        cantidad_total, cantidad_unitariatotal, ";
            sqlSelectSalidaDetalle += "        porcentaje_aplicadoprecio,";
            sqlSelectSalidaDetalle += "        precio_lista,precio_venta, ";
            sqlSelectSalidaDetalle += "        costo_almacen, ";
            sqlSelectSalidaDetalle += "        costo_actualizado,costo_actualizado_final, ";
            sqlSelectSalidaDetalle += "        fecha_actualizacion ";
            sqlSelectSalidaDetalle += "        from SALIDAS_DETALLEVENTAS ";
            sqlSelectSalidaDetalle += "        where  cod_salidaventas=" + cod_salidaventa;


            Statement stSalidasDetalle = conOrigen.createStatement();
            ResultSet rsSelectSalidaDetalle = stSalidasDetalle.executeQuery(sqlSelectSalidaDetalle);

            while (rsSelectSalidaDetalle.next()) {
                String cod_presentacion = rsSelectSalidaDetalle.getString(1);
                String cod_lote_produccion = rsSelectSalidaDetalle.getString(2);
                Date fecha_venc = rsSelectSalidaDetalle.getDate(3);
                int cantidad = rsSelectSalidaDetalle.getInt(4);
                int cantidad_unitaria = rsSelectSalidaDetalle.getInt(5);
                int cantidad_bonificacion = rsSelectSalidaDetalle.getInt(6);
                int cantidad_unitariabonificacion = rsSelectSalidaDetalle.getInt(7);
                int cantidad_total = rsSelectSalidaDetalle.getInt(8);
                int cantidad_unitariatotal = rsSelectSalidaDetalle.getInt(9);
                float porcentaje_aplicadoprecio = rsSelectSalidaDetalle.getFloat(10);
                float precio_lista = rsSelectSalidaDetalle.getFloat(11);
                float precio_venta = rsSelectSalidaDetalle.getFloat(12);
                float costo_almacen = rsSelectSalidaDetalle.getFloat(13);
                float costo_actualizado = rsSelectSalidaDetalle.getFloat(14);
                float costo_actualizado_final = rsSelectSalidaDetalle.getFloat(15);
                Date fecha_actualizacion = rsSelectSalidaDetalle.getDate(16);
                String updateSalidasDetalle = "update SALIDAS_DETALLEVENTAS set cod_lote_produccion=" + cod_lote_produccion + "";
                updateSalidasDetalle += ",fecha_venc='" + f.format(fecha_venc) + "'";
                updateSalidasDetalle += ",cantidad=" + cantidad;
                updateSalidasDetalle += ",cantidad_unitaria=" + cantidad_unitaria;
                updateSalidasDetalle += ",cantidad_bonificacion=" + cantidad_bonificacion;
                updateSalidasDetalle += ",cantidad_unitariabonificacion=" + cantidad_unitariabonificacion;
                updateSalidasDetalle += ",cantidad_total=" + cantidad_total;
                updateSalidasDetalle += ",cantidad_unitariatotal=" + cantidad_unitariatotal;
                updateSalidasDetalle += ",porcentaje_aplicadoprecio=" + porcentaje_aplicadoprecio;
                updateSalidasDetalle += ",precio_lista=" + precio_lista;
                updateSalidasDetalle += ",precio_venta=" + precio_venta;
                updateSalidasDetalle += ",costo_almacen=" + costo_almacen;
                updateSalidasDetalle += ",costo_actualizado=" + costo_actualizado;
                updateSalidasDetalle += ",costo_actualizado_final=" + costo_actualizado_final;
                //  updateSalidasDetalle+=",fecha_actualizacion='"+f.format(fecha_actualizacion)+"'";
                updateSalidasDetalle += " where cod_salidaventas=" + cod_salidaventa + " and cod_presentacion=" + cod_presentacion;
                System.out.println(updateSalidasDetalle);
                Statement stUpdateSalidasDetalle = conDestino.createStatement();
            // stUpdateSalidasDetalle.executeUpdate(updateSalidasDetalle);

            }

            String updateSalidas = "";
            updateSalidas += "update SALIDAS_VENTAS set monto_total=" + monto_total + " where cod_salidaventa=" + cod_salidaventa;
            updateSalidas += " and COD_ALMACEN_VENTA=" + cod_almacen_venta;
            System.out.println(updateSalidas);
            Statement stUpdateSalidas = conDestino.createStatement();
        //stUpdateSalidas.executeUpdate(updateSalidas);


        }
    }

    public void salidaseliminar() throws SQLException {
        String sql = "select nro_factura,cod_cliente,cod_salidaventa,monto_total from salidas_ventas where COD_ALMACEN_VENTA=27 ";
        sql += " and cod_cliente is not null  order by nro_factura ";
        Statement st = conOrigen.createStatement();
        ResultSet rs = st.executeQuery(sql);
        int xxx = 0;
        while (rs.next()) {
            String nro_factura = rs.getString(1);
            String cod_cliente = rs.getString(2);
            String cod_salidaventa = rs.getString(3);
            String monto_total = rs.getString(4);
            sql = "select nro_factura,cod_cliente,cod_salidaventa,monto_total from salidas_ventas where COD_ALMACEN_VENTA=27 ";
            sql += " and cod_cliente is not null  and cod_cliente=" + cod_cliente + " and nro_factura=" + nro_factura + "  and monto_total=" + monto_total + "  order by cod_salidaventa";
            Statement st2 = conOrigen.createStatement();
            ResultSet rs2 = st2.executeQuery(sql);
            int cantidad = 0;
            while (rs2.next()) {
                cantidad++;
                String cod_salidaventa2 = rs2.getString(3);
                if (cantidad > 1) {
                    System.out.println("cantidad:" + cantidad);

                    xxx++;
                    sql = "delete from SALIDAS_DETALLEVENTAS where cod_salidaventas=" + cod_salidaventa2;
                    Statement st3 = conOrigen.createStatement();
                    st3.executeUpdate(sql);
                    sql = "delete from salidas_ventas where cod_salidaventa=" + cod_salidaventa2;
                    Statement st4 = conOrigen.createStatement();
                    st4.executeUpdate(sql);



                    System.out.println("cod_salidaventa2:" + cod_salidaventa + " \t" + cod_salidaventa2);
                    System.out.println("sql:" + sql);
                }

            }

            if (cantidad > 1) {

                System.out.println("cod_salidaventa:" + cod_salidaventa);

            }
        }

        System.out.println("xxx:" + xxx);
    }

    public void salidaseliminar2() throws SQLException {
        String sql = "select nro_factura,cod_cliente,cod_salidaventa,monto_total from salidas_ventas where COD_ALMACEN_VENTA=27 ";
        sql += " and cod_cliente is not null and cod_personal not in (select cod_personal from personal where cod_area_empresa=89)  order by nro_factura ";
        Statement st = conOrigen.createStatement();
        ResultSet rs = st.executeQuery(sql);
        int xxx = 0;
        while (rs.next()) {
            String nro_factura = rs.getString(1);
            String cod_cliente = rs.getString(2);
            String cod_salidaventa = rs.getString(3);
            String monto_total = rs.getString(4);
            sql = "select nro_factura,cod_cliente,cod_salidaventa,monto_total from salidas_ventas where COD_ALMACEN_VENTA=27 ";
            sql += " and cod_cliente is not null  and cod_cliente=" + cod_cliente + " and nro_factura=" + nro_factura + "  and monto_total=" + monto_total + "  order by cod_salidaventa";
            Statement st2 = conOrigen.createStatement();
            ResultSet rs2 = st2.executeQuery(sql);
            int cantidad = 0;
            while (rs2.next()) {
                cantidad++;


            }

            if (cantidad > 1) {
                xxx++;
                System.out.println("cod_salidaventa:" + cod_salidaventa);


                if (cantidad > 1) {
                    sql = "delete from salidas_detalleventas where cod_salidaventas=" + cod_salidaventa;
                    System.out.println("sql:" + sql);

                    sql = "delete from salidas_ventas where cod_salidaventa=" + cod_salidaventa;

                    System.out.println("sql:" + sql);
                }


            }
        }

        System.out.println("xxx:" + xxx);
    }
}
