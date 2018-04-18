/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.web;

import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import com.cofar.bean.ProduccionOrdenCantidad;
import javax.annotation.PostConstruct;
import org.richfaces.component.html.HtmlDataTable;

/**
 *
 * @author sistemas1
 */
public class ManagedProgramaProduccionOrdenCantidad {

    /** Creates a new instance of ManagedProgramaProduccionOrdenCantidad */
    private Connection con;
    private List<ProduccionOrdenCantidad> produccionOrdenCantidadList = new ArrayList<ProduccionOrdenCantidad>();
    private List<ProduccionOrdenCantidad> produccionOrdenCantidadList1 = new ArrayList<ProduccionOrdenCantidad>();
    private List<ProduccionOrdenCantidad> produccionOrdenCantidadList2 = new ArrayList<ProduccionOrdenCantidad>();
    ProduccionOrdenCantidad itemProd = new ProduccionOrdenCantidad();
    ArrayList alfila = new ArrayList();
    private List lista;
    String prueba;
    private HtmlDataTable productosDataTable;
    private String codProgramaProd="0";

    public HtmlDataTable getProductosDataTable() {
        return productosDataTable;
    }

    public void setProductosDataTable(HtmlDataTable productosDataTable) {
        this.productosDataTable = productosDataTable;
    }

    public String getPrueba() {
        return prueba;
    }

    public void setPrueba(String prueba) {
        this.prueba = prueba;
    }
    /*
    @init
     */

    public ManagedProgramaProduccionOrdenCantidad() {
    }

    @PostConstruct
    public void init() {
        try {
            codProgramaProd="7";
            con = (Util.openConnection(con));
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            String consulta = "";
            //se lista los componentes a fabricar para programa_produccion

            consulta = " SELECT PP.COD_PROGRAMA_PROD,PP.COD_COMPPROD,CP.nombre_prod_semiterminado,PP.COD_FORMULA_MAESTRA,NULL " +
                    " FROM PROGRAMA_PRODUCCION PP " +
                    " INNER JOIN  FORMULA_MAESTRA FM ON PP.COD_FORMULA_MAESTRA = FM.COD_FORMULA_MAESTRA " +
                    " INNER JOIN COMPONENTES_PROD CP ON FM.COD_COMPPROD=CP.COD_COMPPROD " +
                    " WHERE PP.COD_PROGRAMA_PROD='"+codProgramaProd+"' " +
                    " AND PP.COD_ESTADO_PROGRAMA=4 " +
                    " ORDER BY CP.nombre_prod_semiterminado ASC ";

            ResultSet rs = st.executeQuery(consulta);

            rs.last();
            int filas = rs.getRow();
            //programaProduccionList.clear();
            rs.first();
            produccionOrdenCantidadList.clear();
            for (int i = 0; i < filas; i++) {
                itemProd = new ProduccionOrdenCantidad();
                itemProd.setLinkOperacion("PRODUCIR");
                itemProd.setCodProgramaProd(rs.getString("cod_programa_prod"));
                itemProd.setNombreProdSemiterminado(rs.getString("nombre_prod_semiterminado"));
                itemProd.setCodCompProd(rs.getString("cod_compprod"));
                itemProd.setEstadoProduccion("");
                itemProd.setObservacion("");
                produccionOrdenCantidadList.add(itemProd);
                rs.next();
            }
            if (rs != null) {
                rs.close();
                st.close();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String comenzarSimulacion() {
        try {

            con = (Util.openConnection(con));
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            String consulta = "";
            //para que entre solo una vez cuando la instancia aun sea nula


            consulta = "delete from PROGRAMA_PRODUCCION_MATERIAL " +
                    "where COD_PROGRAMA_PROD ='"+codProgramaProd+"'";

            st.executeUpdate(consulta); //borrado de registros relacionados

            //insercion de registros relacionados al

            consulta = "INSERT INTO PROGRAMA_PRODUCCION_MATERIAL " +
                    " select PPD.COD_PROGRAMA_PROD, PPD.COD_COMPPROD,PPD.COD_UNIDAD_MEDIDA,PPD.COD_MATERIAL,PPD.CANTIDAD,0 " +
                    " from PROGRAMA_PRODUCCION_DETALLE  PPD WHERE PPD.COD_PROGRAMA_PROD='"+codProgramaProd+"' ";
                    
            st.executeUpdate(consulta); //insertamos los registros

            //borramos lo disponible de los materiales necesarios

            consulta = "delete from PROGRAMA_PRODUCCION_MATERIAL_DISP " +
                    "where COD_PROGRAMA_PROD ='"+codProgramaProd+"'";

            st.executeUpdate(consulta);

            //insertamos lo actual disponible de los materiales necesarios

//            consulta = " insert into PROGRAMA_PRODUCCION_MATERIAL_DISP " +
//                    " SELECT PP.COD_PROGRAMA_PROD ,M.COD_MATERIAL ,(select DISTINCT ISNULL((select SUM(iade.cantidad_parcial) " +
//                    " from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia WHERE iade.cod_material=MAT.cod_material and ia.cod_estado_ingreso_almacen=1 and  iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and  iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen and ia.fecha_ingreso_almacen<='10/25/2010' ),0)  - ISNULL( (select SUM(sadi.cantidad) from salidas_almacen_detalle sad,salidas_almacen_detalle_ingreso sadi,ingresos_almacen_detalle_estado iade, salidas_almacen sa WHERE sa.cod_salida_almacen=sad.cod_salida_almacen and sa.estado_sistema=1 and sa.cod_estado_salida_almacen=1 and sad.cod_salida_almacen=sadi.cod_salida_almacen and sad.cod_material=sadi.cod_material and sadi.cod_ingreso_almacen=iade.cod_ingreso_almacen and sadi.cod_material=iade.cod_material and sadi.ETIQUETA=iade.ETIQUETA  and sad.cod_material=MAT.cod_material and sa.fecha_salida_almacen<='10/25/2010' ),0) + ISNULL( (select sum(iad.cant_total_ingreso_fisico) from DEVOLUCIONES d, ingresos_almacen ia,INGRESOS_ALMACEN_DETALLE iad where ia.cod_devolucion=d.cod_devolucion and ia.fecha_ingreso_almacen<='10/25/2010' and d.cod_estado_devolucion=1 and d.estado_sistema=1 and ia.cod_estado_ingreso_almacen=1 " +
//                    " and ia.cod_almacen=d.cod_almacen and ia.cod_ingreso_almacen=iad.cod_ingreso_almacen and iad.cod_material=MAT.cod_material),0) - ISNULL( (select SUM(iade.cantidad_restante) from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia WHERE iade.cod_material=MAT.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen and iade.cod_estado_material=1 and ia.fecha_ingreso_almacen<='10/25/2010' ) ,0) - ISNULL( (select SUM(iade.cantidad_restante) from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia WHERE iade.cod_material=MAT.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen and iade.cod_estado_material=3 and ia.fecha_ingreso_almacen<='10/25/2010' ) ,0) - ISNULL( (select SUM(iade.cantidad_restante) from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia WHERE iade.cod_material=MAT.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen and iade.cod_estado_material=4 and ia.fecha_ingreso_almacen<='10/25/2010' ) ,0) - ISNULL((select SUM(iade.cantidad_restante) from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia WHERE iade.cod_material=MAT.cod_material  and ia.cod_estado_ingreso_almacen=1  and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen  and ia.estado_sistema=1  and iade.cod_material=iad.cod_material  and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen and iade.cod_estado_material=5 and ia.fecha_ingreso_almacen<='10/25/2010' ),0) AS DISPONIBLE from materiales MAT,grupos g,capitulos c, SECCIONES s,SECCIONES_DETALLE sd,almacenes al " +
//                    " where MAT.cod_grupo=g.cod_grupo  and g.cod_capitulo=c.cod_capitulo  and  MAT.material_almacen=1 and MAT.COD_MATERIAL=M.COD_MATERIAL ) FROM PROGRAMA_PRODUCCION PP   INNER JOIN  FORMULA_MAESTRA FM ON PP.COD_FORMULA_MAESTRA = FM.COD_FORMULA_MAESTRA  INNER JOIN FORMULA_MAESTRA_DETALLE_MP FMDMP ON FM.COD_FORMULA_MAESTRA= FMDMP.COD_FORMULA_MAESTRA INNER JOIN MATERIALES M ON FMDMP.COD_MATERIAL=M.COD_MATERIAL INNER JOIN INGRESOS_ALMACEN_DETALLE_ESTADO IADE ON M.COD_MATERIAL=IADE.COD_MATERIAL INNER JOIN INGRESOS_ALMACEN_DETALLE IAD ON IADE.COD_INGRESO_ALMACEN = IAD.COD_INGRESO_ALMACEN  AND IADE.COD_MATERIAL=IAD.COD_MATERIAL  INNER JOIN INGRESOS_ALMACEN IA ON IAD.COD_INGRESO_ALMACEN = IA.COD_INGRESO_ALMACEN  WHERE PP.COD_PROGRAMA_PROD='"+codProgramaProd+"'  AND IA.COD_ESTADO_INGRESO_ALMACEN=1   AND IA.ESTADO_SISTEMA=1   AND IA.FECHA_INGRESO_ALMACEN<='10/25/2010'  GROUP BY PP.COD_PROGRAMA_PROD,M.COD_MATERIAL UNION ALL   SELECT PP.COD_PROGRAMA_PROD ,M.COD_MATERIAL ,(select DISTINCT ISNULL((select SUM(iade.cantidad_parcial) from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia WHERE iade.cod_material=MAT.cod_material and ia.cod_estado_ingreso_almacen=1 and  iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and  iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen  and ia.fecha_ingreso_almacen<='10/25/2010' ),0) - ISNULL( (select SUM(sadi.cantidad) from salidas_almacen_detalle sad,salidas_almacen_detalle_ingreso sadi,ingresos_almacen_detalle_estado iade, salidas_almacen sa WHERE sa.cod_salida_almacen=sad.cod_salida_almacen and sa.estado_sistema=1 and sa.cod_estado_salida_almacen=1 and sad.cod_salida_almacen=sadi.cod_salida_almacen and sad.cod_material=sadi.cod_material and sadi.cod_ingreso_almacen=iade.cod_ingreso_almacen and sadi.cod_material=iade.cod_material and sadi.ETIQUETA=iade.ETIQUETA  and sad.cod_material=MAT.cod_material and sa.fecha_salida_almacen<='10/25/2010' ),0) + ISNULL( (select sum(iad.cant_total_ingreso_fisico) from DEVOLUCIONES d, ingresos_almacen ia,INGRESOS_ALMACEN_DETALLE iad  " +
//                    " where ia.cod_devolucion=d.cod_devolucion and ia.fecha_ingreso_almacen<='10/25/2010' and d.cod_estado_devolucion=1 and d.estado_sistema=1 and ia.cod_estado_ingreso_almacen=1 and ia.cod_almacen=d.cod_almacen and ia.cod_ingreso_almacen=iad.cod_ingreso_almacen and iad.cod_material=MAT.cod_material),0) - ISNULL( (select SUM(iade.cantidad_restante) from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia WHERE iade.cod_material=MAT.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen and iade.cod_estado_material=1 and ia.fecha_ingreso_almacen<='10/25/2010' ) ,0) - ISNULL( (select SUM(iade.cantidad_restante) from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia WHERE iade.cod_material=MAT.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen and iade.cod_estado_material=3 and ia.fecha_ingreso_almacen<='10/25/2010' ) ,0) - ISNULL( (select SUM(iade.cantidad_restante) from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia WHERE iade.cod_material=MAT.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen and iade.cod_estado_material=4 and ia.fecha_ingreso_almacen<='10/25/2010' ) ,0)  - " +
//                    " ISNULL( (select SUM(iade.cantidad_restante) from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia  WHERE iade.cod_material=MAT.cod_material and ia.cod_estado_ingreso_almacen=1  and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen  and ia.estado_sistema=1  and iade.cod_material=iad.cod_material  and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen and iade.cod_estado_material=5 and ia.fecha_ingreso_almacen<='10/25/2010' ),0) AS DISPONIBLE from materiales MAT,grupos g,capitulos c, SECCIONES s,SECCIONES_DETALLE sd,almacenes al  where MAT.cod_grupo=g.cod_grupo  and g.cod_capitulo=c.cod_capitulo  and  MAT.material_almacen=1 and MAT.COD_MATERIAL=M.COD_MATERIAL ) FROM PROGRAMA_PRODUCCION PP   INNER JOIN  FORMULA_MAESTRA FM ON PP.COD_FORMULA_MAESTRA = FM.COD_FORMULA_MAESTRA  INNER JOIN FORMULA_MAESTRA_DETALLE_EP FMDMP ON FM.COD_FORMULA_MAESTRA= FMDMP.COD_FORMULA_MAESTRA INNER JOIN MATERIALES M ON FMDMP.COD_MATERIAL=M.COD_MATERIAL INNER JOIN INGRESOS_ALMACEN_DETALLE_ESTADO IADE ON M.COD_MATERIAL=IADE.COD_MATERIAL INNER JOIN INGRESOS_ALMACEN_DETALLE IAD ON IADE.COD_INGRESO_ALMACEN = IAD.COD_INGRESO_ALMACEN  AND IADE.COD_MATERIAL=IAD.COD_MATERIAL  INNER JOIN INGRESOS_ALMACEN IA ON IAD.COD_INGRESO_ALMACEN = IA.COD_INGRESO_ALMACEN  WHERE PP.COD_PROGRAMA_PROD='"+codProgramaProd+"'  AND IA.COD_ESTADO_INGRESO_ALMACEN=1   AND IA.ESTADO_SISTEMA=1   AND IA.FECHA_INGRESO_ALMACEN<='10/25/2010'  GROUP BY PP.COD_PROGRAMA_PROD,M.COD_MATERIAL  UNION ALL  SELECT PP.COD_PROGRAMA_PROD ,M.COD_MATERIAL ,(select DISTINCT ISNULL((select SUM(iade.cantidad_parcial) " +
//                    " from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia WHERE iade.cod_material=MAT.cod_material and ia.cod_estado_ingreso_almacen=1 and  iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and  iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen and ia.fecha_ingreso_almacen<='10/25/2010' ),0)  - ISNULL( (select SUM(sadi.cantidad) from salidas_almacen_detalle sad,salidas_almacen_detalle_ingreso sadi,ingresos_almacen_detalle_estado iade, salidas_almacen sa WHERE sa.cod_salida_almacen=sad.cod_salida_almacen and sa.estado_sistema=1 and sa.cod_estado_salida_almacen=1 and sad.cod_salida_almacen=sadi.cod_salida_almacen and sad.cod_material=sadi.cod_material and sadi.cod_ingreso_almacen=iade.cod_ingreso_almacen and sadi.cod_material=iade.cod_material and sadi.ETIQUETA=iade.ETIQUETA  and sad.cod_material=MAT.cod_material and sa.fecha_salida_almacen<='10/25/2010' ),0) + ISNULL( (select sum(iad.cant_total_ingreso_fisico) from DEVOLUCIONES d, ingresos_almacen ia,INGRESOS_ALMACEN_DETALLE iad where ia.cod_devolucion=d.cod_devolucion and ia.fecha_ingreso_almacen<='10/25/2010' and d.cod_estado_devolucion=1 and d.estado_sistema=1 and ia.cod_estado_ingreso_almacen=1 and ia.cod_almacen=d.cod_almacen and ia.cod_ingreso_almacen=iad.cod_ingreso_almacen and iad.cod_material=MAT.cod_material),0) - ISNULL( (select SUM(iade.cantidad_restante) from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia WHERE iade.cod_material=MAT.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen and iade.cod_estado_material=1 and ia.fecha_ingreso_almacen<='10/25/2010' ) ,0) - ISNULL( (select SUM(iade.cantidad_restante) from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia WHERE iade.cod_material=MAT.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen and iade.cod_estado_material=3 and ia.fecha_ingreso_almacen<='10/25/2010' ) ,0) - " +
//                    " ISNULL( (select SUM(iade.cantidad_restante) from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia WHERE iade.cod_material=MAT.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen and iade.cod_estado_material=4 and ia.fecha_ingreso_almacen<='10/25/2010' ) ,0) - ISNULL( (select SUM(iade.cantidad_restante) from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia WHERE iade.cod_material=MAT.cod_material  and ia.cod_estado_ingreso_almacen=1  and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen  and ia.estado_sistema=1  and iade.cod_material=iad.cod_material  and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen and iade.cod_estado_material=5 and ia.fecha_ingreso_almacen<='10/25/2010' ),0) AS DISPONIBLE from materiales MAT,grupos g,capitulos c, SECCIONES s,SECCIONES_DETALLE sd,almacenes al  " +
//                    " where MAT.cod_grupo=g.cod_grupo  and g.cod_capitulo=c.cod_capitulo  and  MAT.material_almacen=1 and MAT.COD_MATERIAL=M.COD_MATERIAL ) " +
//                    " FROM PROGRAMA_PRODUCCION PP   INNER JOIN  FORMULA_MAESTRA FM ON PP.COD_FORMULA_MAESTRA = FM.COD_FORMULA_MAESTRA  INNER JOIN FORMULA_MAESTRA_DETALLE_ES FMDMP ON FM.COD_FORMULA_MAESTRA= FMDMP.COD_FORMULA_MAESTRA INNER JOIN MATERIALES M ON FMDMP.COD_MATERIAL=M.COD_MATERIAL INNER JOIN INGRESOS_ALMACEN_DETALLE_ESTADO IADE ON M.COD_MATERIAL=IADE.COD_MATERIAL INNER JOIN INGRESOS_ALMACEN_DETALLE IAD ON IADE.COD_INGRESO_ALMACEN = IAD.COD_INGRESO_ALMACEN  AND IADE.COD_MATERIAL=IAD.COD_MATERIAL  INNER JOIN INGRESOS_ALMACEN IA ON IAD.COD_INGRESO_ALMACEN = IA.COD_INGRESO_ALMACEN  WHERE PP.COD_PROGRAMA_PROD='"+codProgramaProd+"'  AND IA.COD_ESTADO_INGRESO_ALMACEN=1   AND IA.ESTADO_SISTEMA=1   AND IA.FECHA_INGRESO_ALMACEN<='10/25/2010'  GROUP BY PP.COD_PROGRAMA_PROD,M.COD_MATERIAL        ";

            consulta = " insert into PROGRAMA_PRODUCCION_MATERIAL_DISP SELECT PP.COD_PROGRAMA_PROD ,M.COD_MATERIAL ,(select DISTINCT  ISNULL((select SUM(iade.cantidad_parcial) from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia WHERE iade.cod_material=MAT.cod_material and ia.cod_estado_ingreso_almacen=1 and  iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and  iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen and ia.fecha_ingreso_almacen<='10/25/2010' ),0)  - " +
                    " ISNULL( (select SUM(sadi.cantidad) from salidas_almacen_detalle sad,salidas_almacen_detalle_ingreso sadi,ingresos_almacen_detalle_estado iade, salidas_almacen sa WHERE sa.cod_salida_almacen=sad.cod_salida_almacen and sa.estado_sistema=1 and sa.cod_estado_salida_almacen=1 and sad.cod_salida_almacen=sadi.cod_salida_almacen and sad.cod_material=sadi.cod_material and sadi.cod_ingreso_almacen=iade.cod_ingreso_almacen and sadi.cod_material=iade.cod_material and sadi.ETIQUETA=iade.ETIQUETA  and sad.cod_material=MAT.cod_material and sa.fecha_salida_almacen<='10/25/2010' ),0) + " +
                    " ISNULL( (select sum(iad.cant_total_ingreso_fisico) from DEVOLUCIONES d, ingresos_almacen ia,INGRESOS_ALMACEN_DETALLE iad where ia.cod_devolucion=d.cod_devolucion and ia.fecha_ingreso_almacen<='10/25/2010' and d.cod_estado_devolucion=1 and d.estado_sistema=1 and ia.cod_estado_ingreso_almacen=1 and ia.cod_almacen=d.cod_almacen and ia.cod_ingreso_almacen=iad.cod_ingreso_almacen and iad.cod_material=MAT.cod_material),0) - " +
                    " ISNULL( (select SUM(iade.cantidad_restante) from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia WHERE iade.cod_material=MAT.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen and iade.cod_estado_material=1 and ia.fecha_ingreso_almacen<='10/25/2010' ) ,0) - " +
                    " ISNULL( (select SUM(iade.cantidad_restante) from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia WHERE iade.cod_material=MAT.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen and iade.cod_estado_material=3 and ia.fecha_ingreso_almacen<='10/25/2010' ) ,0) - " +
                    " ISNULL( (select SUM(iade.cantidad_restante) from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia WHERE iade.cod_material=MAT.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen and iade.cod_estado_material=4 and ia.fecha_ingreso_almacen<='10/25/2010' ) ,0) - " +
                    " ISNULL( (select SUM(iade.cantidad_restante) from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia WHERE iade.cod_material=MAT.cod_material  and ia.cod_estado_ingreso_almacen=1  and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen  and ia.estado_sistema=1  and iade.cod_material=iad.cod_material  and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen and iade.cod_estado_material=5 and ia.fecha_ingreso_almacen<='10/25/2010' ),0) AS DISPONIBLE " +
                    " from materiales MAT,grupos g,capitulos c, SECCIONES s,SECCIONES_DETALLE sd,almacenes al  " +
                    " where MAT.cod_grupo=g.cod_grupo  and g.cod_capitulo=c.cod_capitulo  and  MAT.material_almacen=1  and MAT.COD_MATERIAL=M.COD_MATERIAL ) " +
                    " FROM PROGRAMA_PRODUCCION PP INNER JOIN PROGRAMA_PRODUCCION_DETALLE PPD ON PPD.COD_PROGRAMA_PROD = PP.COD_PROGRAMA_PROD AND PPD.COD_COMPPROD=PP.COD_COMPPROD   INNER JOIN MATERIALES M ON M.COD_MATERIAL = PPD.COD_MATERIAL INNER JOIN INGRESOS_ALMACEN_DETALLE_ESTADO IADE ON M.COD_MATERIAL=IADE.COD_MATERIAL INNER JOIN INGRESOS_ALMACEN_DETALLE IAD ON IADE.COD_INGRESO_ALMACEN = IAD.COD_INGRESO_ALMACEN  AND IADE.COD_MATERIAL=IAD.COD_MATERIAL  INNER JOIN INGRESOS_ALMACEN IA ON IAD.COD_INGRESO_ALMACEN = IA.COD_INGRESO_ALMACEN  " +
                    " WHERE PP.COD_PROGRAMA_PROD='"+codProgramaProd+"'  AND IA.COD_ESTADO_INGRESO_ALMACEN=1 AND IA.ESTADO_SISTEMA=1   AND IA.FECHA_INGRESO_ALMACEN<='10/25/2010'  GROUP BY PP.COD_PROGRAMA_PROD,M.COD_MATERIAL ";

            st.executeUpdate(consulta);

            // cargarAreasEmpresa("", null);
            this.init();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;

    }

    public String inicializaDatos() {
        return null;
    }

    public List<ProduccionOrdenCantidad> getProduccionOrdenCantidadList() {
        return produccionOrdenCantidadList;
    }

    public void setProduccionOrdenCantidadList(List<ProduccionOrdenCantidad> produccionOrdenCantidadList) {
        this.produccionOrdenCantidadList = produccionOrdenCantidadList;
    }

    public boolean noExisteElMaterialDisp(String codCompProd) {
        boolean noExisteElMaterial = false;
        try {
            con = (Util.openConnection(con));
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            String consulta = "";
            //se lista los componentes a fabricar para programa_produccion

            consulta = " SELECT * FROM PROGRAMA_PRODUCCION_MATERIAL PPM " +
                    " WHERE PPM.COD_MATERIAL NOT IN (SELECT PPMD.COD_MATERIAL FROM PROGRAMA_PRODUCCION_MATERIAL_DISP PPMD " +
                    " WHERE PPMD.COD_PROGRAMA_PROD=PPM.COD_PROGRAMA_PROD ) " +
                    " AND PPM.COD_PROGRAMA_PROD='"+codProgramaProd+"' " +
                    " AND PPM.COD_COMPPROD='" + codCompProd + "' ";

            ResultSet rs = st.executeQuery(consulta);

            if (rs.next()) {
                noExisteElMaterial = true;
            }

            if (rs != null) {
                rs.close();
                st.close();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return noExisteElMaterial;
    }

    public String seleccionaComponente() {
        try {
            ProduccionOrdenCantidad proOrdenFila = (ProduccionOrdenCantidad) productosDataTable.getRowData();
            //evaluar si se puede producir
            // sacar la cantidad necesaria por cada elemento
            con = (Util.openConnection(con));
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            System.out.println(proOrdenFila.getCodProgramaProd());
            System.out.println(proOrdenFila.getCodCompProd());
            System.out.println(proOrdenFila.getLinkOperacion());

            if (proOrdenFila.getLinkOperacion().equals("PRODUCIR")) {

                String consulta = " SELECT * FROM PROGRAMA_PRODUCCION_MATERIAL_DISP PPMD " +
                        " INNER JOIN PROGRAMA_PRODUCCION_MATERIAL PPM ON PPMD.COD_MATERIAL= PPM.COD_MATERIAL " +
                        " AND PPM.COD_PROGRAMA_PROD = PPMD.COD_PROGRAMA_PROD " +
                        " WHERE PPM.COD_COMPPROD=" + proOrdenFila.getCodCompProd() +
                        " AND PPM.CANTIDAD_REQUERIDA > PPMD.DISPONIBLE " +
                        " AND PPM.COD_PROGRAMA_PROD='"+codProgramaProd+"'";


                ResultSet rs = st.executeQuery(consulta);

                rs.last();
                int filas = rs.getRow();
                rs.first();

                System.out.println("antes del principio" + filas);
                System.out.println(consulta);

                if (filas == 0 && this.noExisteElMaterialDisp(proOrdenFila.getCodCompProd()) == false) {

                    consulta = "SELECT PPM.COD_PROGRAMA_PROD,PPM.COD_COMPPROD,PPM.COD_MATERIAL,PPM.CANTIDAD_REQUERIDA,PPM.CANTIDAD_USADA " +
                            ",PPMD.DISPONIBLE FROM PROGRAMA_PRODUCCION_MATERIAL_DISP PPMD " +
                            " INNER JOIN PROGRAMA_PRODUCCION_MATERIAL PPM ON PPMD.COD_MATERIAL= PPM.COD_MATERIAL  " +
                            " AND PPM.COD_PROGRAMA_PROD = PPMD.COD_PROGRAMA_PROD " +
                            " WHERE PPM.COD_COMPPROD=" + proOrdenFila.getCodCompProd();
                    ResultSet rsProgramaProduccion = st.executeQuery(consulta);

                    rsProgramaProduccion.last();
                    filas = rsProgramaProduccion.getRow();
                    rsProgramaProduccion.first();
                    System.out.println("filas a recorrer " + filas);

                    for (int i = 0; i < filas; i++) {

                        Statement stmt = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                        consulta = " UPDATE PROGRAMA_PRODUCCION_MATERIAL " +
                                " SET CANTIDAD_USADA =  CANTIDAD_REQUERIDA " +
                                " WHERE COD_PROGRAMA_PROD = " + rsProgramaProduccion.getString("cod_programa_prod") +
                                " AND COD_COMPPROD = " + rsProgramaProduccion.getString("cod_compprod") +
                                " AND COD_MATERIAL = " + rsProgramaProduccion.getString("cod_material");
                        System.out.println(consulta);
                        stmt.executeUpdate(consulta);

                        stmt = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);


                        consulta = " UPDATE PROGRAMA_PRODUCCION_MATERIAL_DISP " +
                                " SET DISPONIBLE = DISPONIBLE - " + rsProgramaProduccion.getString("cantidad_requerida") +
                                " WHERE COD_PROGRAMA_PROD = " + rsProgramaProduccion.getString("cod_programa_prod") +
                                " AND COD_MATERIAL=" + rsProgramaProduccion.getString("cod_material");
                        System.out.println(consulta);

                        stmt.executeUpdate(consulta);
                        rsProgramaProduccion.next();


                    }


                    produccionOrdenCantidadList1 = produccionOrdenCantidadList;
                    produccionOrdenCantidadList2 = new ArrayList<ProduccionOrdenCantidad>();

                    for (ProduccionOrdenCantidad itemProds : produccionOrdenCantidadList1) {
                        //proOrdenFila.getCodCompProd()

                        if (itemProds.getCodCompProd().equals(proOrdenFila.getCodCompProd())) {
                            itemProds.setLinkOperacion("PRODUCIDO");
                            itemProds.setEstadoProduccion("DETALLE");
                        }
                        produccionOrdenCantidadList2.add(itemProds);
                    }
                    produccionOrdenCantidadList = produccionOrdenCantidadList2;

                }

            } else if (proOrdenFila.getLinkOperacion().equals("PRODUCIDO")) {


                String consulta = "SELECT PPM.COD_PROGRAMA_PROD,PPM.COD_COMPPROD,PPM.COD_MATERIAL,PPM.CANTIDAD_REQUERIDA,PPM.CANTIDAD_USADA " +
                        ",PPMD.DISPONIBLE FROM PROGRAMA_PRODUCCION_MATERIAL_DISP PPMD " +
                        " INNER JOIN PROGRAMA_PRODUCCION_MATERIAL PPM ON PPMD.COD_MATERIAL= PPM.COD_MATERIAL  " +
                        " AND PPM.COD_PROGRAMA_PROD = PPMD.COD_PROGRAMA_PROD " +
                        " WHERE PPM.COD_COMPPROD=" + proOrdenFila.getCodCompProd();
                ResultSet rsProgramaProduccion = st.executeQuery(consulta);

                rsProgramaProduccion.last();
                int filas = rsProgramaProduccion.getRow();
                rsProgramaProduccion.first();

                for (int i = 0; i < filas; i++) {

                    Statement stmt = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    consulta = " UPDATE PROGRAMA_PRODUCCION_MATERIAL " +
                            " SET CANTIDAD_USADA =  0 " +
                            " WHERE COD_PROGRAMA_PROD = " + rsProgramaProduccion.getString("cod_programa_prod") +
                            " AND COD_COMPPROD = " + rsProgramaProduccion.getString("cod_compprod") +
                            " AND COD_MATERIAL = " + rsProgramaProduccion.getString("cod_material");
                    System.out.println(consulta);
                    stmt.executeUpdate(consulta);

                    stmt = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);


                    consulta = " UPDATE PROGRAMA_PRODUCCION_MATERIAL_DISP " +
                            " SET DISPONIBLE = DISPONIBLE + " + rsProgramaProduccion.getString("cantidad_requerida") +
                            " WHERE COD_PROGRAMA_PROD = " + rsProgramaProduccion.getString("cod_programa_prod") +
                            " AND COD_MATERIAL=" + rsProgramaProduccion.getString("cod_material");
                    System.out.println(consulta);

                    stmt.executeUpdate(consulta);
                    rsProgramaProduccion.next();
                //proOrdenFila.setLinkOperacion("PRODUCIR");
                }
                //actualizar la lista

                produccionOrdenCantidadList1 = produccionOrdenCantidadList;
                produccionOrdenCantidadList2 = new ArrayList<ProduccionOrdenCantidad>();

                for (ProduccionOrdenCantidad itemProds : produccionOrdenCantidadList1) {
                    //proOrdenFila.getCodCompProd()

                    if (itemProds.getCodCompProd().equals(proOrdenFila.getCodCompProd())) {
                        itemProds.setLinkOperacion("PRODUCIR");
                    }
                    produccionOrdenCantidadList2.add(itemProds);
                }
                produccionOrdenCantidadList = produccionOrdenCantidadList2;


            }

        } catch (Exception e) {
            e.printStackTrace();

        }
        return "";
    }

    public void seleccionaComponenteXX(javax.faces.event.ValueChangeEvent e) {


        System.out.println("XXXXXXXXXXXX:" + e.getNewValue().toString());

    /*try {
    ProduccionOrdenCantidad proOrdenFila = (ProduccionOrdenCantidad) productosDataTable.getRowData();
    System.out.println(proOrdenFila);

    } catch (Exception e) {
    System.out.println(e);
    }*/

    }

    public String ejecutar() {
        try {
            System.out.println("prueba");
        } catch (Exception e) {
            System.out.println("prueba");
        }
        return "";
    }

    public String getCloseConnection() throws SQLException {
        if (con != null) {
            con.close();
        }
        return "";
    }

    public List getLista() {
        return lista;
    }

    public void setLista(List lista) {
        this.lista = lista;
    }
}
