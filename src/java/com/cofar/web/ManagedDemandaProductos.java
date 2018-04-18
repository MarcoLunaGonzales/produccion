/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.web;

import com.cofar.bean.DemandaProductos;
import com.cofar.bean.DemandaProductosDetalle;
import com.cofar.bean.ExplosionMateriales;
import com.cofar.bean.FormulaMaestraDetalleMP;
import com.cofar.bean.ProgramaProduccion;
import com.cofar.bean.MaterialesConflicto;
import com.cofar.bean.Materiales;
import com.cofar.bean.AbstractBean;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import javax.faces.context.FacesContext;
import javax.servlet.http.HttpServletRequest;
import org.richfaces.component.html.HtmlDataTable;

/**
 *
 * @author hvaldivia
 */

public class ManagedDemandaProductos {

    /** Creates a new instance of ManagedDemandaProductos */
    public ManagedDemandaProductos() {
    }
    List demandaProductosList = new ArrayList();
    HtmlDataTable demandaProductosDataTable = new HtmlDataTable();
    DemandaProductos demandaProductos = new DemandaProductos();
    List demandaProductosDetalleList = new ArrayList();
    List productosConMaterialesList = new ArrayList();
    List productosConMaterialesConflictoList = new ArrayList();



    public List explosionMaterialesList = new ArrayList();

    public DemandaProductos getDemandaProductos() {
        return demandaProductos;
    }

    public void setDemandaProductos(DemandaProductos demandaProductos) {
        this.demandaProductos = demandaProductos;
    }

    public HtmlDataTable getDemandaProductosDataTable() {
        return demandaProductosDataTable;
    }

    public void setDemandaProductosDataTable(HtmlDataTable demandaProductosDataTable) {
        this.demandaProductosDataTable = demandaProductosDataTable;
    }

    public List getDemandaProductosDetalleList() {
        return demandaProductosDetalleList;
    }

    public void setDemandaProductosDetalleList(List demandaProductosDetalleList) {
        this.demandaProductosDetalleList = demandaProductosDetalleList;
    }

    public List getDemandaProductosList() {
        return demandaProductosList;
    }

    public void setDemandaProductosList(List demandaProductosList) {
        this.demandaProductosList = demandaProductosList;
    }

    public List getProductosConMaterialesList() {
        return productosConMaterialesList;
    }

    public void setProductosConMaterialesList(List productosConMaterialesList) {
        this.productosConMaterialesList = productosConMaterialesList;
    }

    public List getProductosConMaterialesConflictoList() {
        return productosConMaterialesConflictoList;
    }

    public void setProductosConMaterialesConflictoList(List productosConMaterialesConflictoList) {
        this.productosConMaterialesConflictoList = productosConMaterialesConflictoList;
    }
    

    public class ProductosConflicto extends AbstractBean{
        ProgramaProduccion programaProduccion = new ProgramaProduccion();
        double cantidad = 0;
        int tamanioLista = 0;

        public double getCantidad() {
            return cantidad;
        }

        public void setCantidad(double cantidad) {
            this.cantidad = cantidad;
        }

        public ProgramaProduccion getProgramaProduccion() {
            return programaProduccion;
        }

        public void setProgramaProduccion(ProgramaProduccion programaProduccion) {
            this.programaProduccion = programaProduccion;
        }

        public int getTamanioLista() {
            return tamanioLista;
        }

        public void setTamanioLista(int tamanioLista) {
            this.tamanioLista = tamanioLista;
        }


    }

    







    public String getCargarDemandaProductos(){
        try {
            demandaProductosList = this.cargarDemandaProductos();

        } catch (Exception e) {
        }
        return null;
    }
    public List cargarDemandaProductos(){
        List demandaProductosList = new ArrayList();
        try {
            String consulta =   " select d.cod_demanda,d.nombre_demanda,d.FECHA_GENERADO,e.COD_ESTADODEMANDAPRODUCTOS,e.NOMBRE_ESTADODEMANDAPRODUCTOS" +
                                " from DEMANDA_DEPRODUCTOS d" +
                                " inner join ESTADO_DEMANDA_DEPRODUCTOS e on e.COD_ESTADODEMANDAPRODUCTOS = d.COD_ESTADODEMANDAPRODUCTOS";
            System.out.println("consulta " + consulta);
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(consulta);
            while(rs.next()){
                DemandaProductos d = new DemandaProductos();
                d.setCodDemanda(rs.getInt("cod_demanda"));
                d.setNombreDemanda(rs.getString("nombre_demanda"));
                d.setFechaGenerado(rs.getDate("fecha_generado"));
                d.getEstadoDemandaProductos().setCodEstadoDemandaProductos(rs.getInt("COD_ESTADODEMANDAPRODUCTOS"));
                d.getEstadoDemandaProductos().setNombreEstadoDemandaProductos(rs.getString("NOMBRE_ESTADODEMANDAPRODUCTOS"));
                demandaProductosList.add(d);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return demandaProductosList;
    }
    public String seleccionarDemandaProductos_action(){
        demandaProductos = (DemandaProductos)demandaProductosDataTable.getRowData();
        return null;
    }
    public List cargarDemandaDetalle(){
        List demandaProductosDetalleList = new ArrayList();
        try {
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            String consulta = " select c.nombre_prod_semiterminado,f.CANTIDAD_LOTE,d.COD_COMPPROD,f.cod_formula_maestra,d.CANT_A_PROD_MC,d.CANT_A_PROD_MM,d.CANT_A_PROD_MI" +
                    " from DEMANDA_DEPRODUCTOSDETALLE d inner join FORMULA_MAESTRA f on f.COD_COMPPROD = d.COD_COMPPROD" +
                    " inner join componentes_prod c on c.cod_compprod = d.cod_compprod " +
                    " where d.COD_DEMANDA = '"+demandaProductos.getCodDemanda()+"' ";
            System.out.println("consulta " + consulta);
            ResultSet rs = st.executeQuery(consulta);
            while(rs.next()){
                DemandaProductosDetalle d = new DemandaProductosDetalle();
                d.getFormulaMaestra().setCantidadLote(rs.getDouble("cantidad_lote"));
                d.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(rs.getString("nombre_prod_semiterminado"));
                d.getFormulaMaestra().setCodFormulaMaestra(rs.getString("cod_formula_maestra"));
                d.getFormulaMaestra().getComponentesProd().setCodCompprod(rs.getString("COD_COMPPROD"));
                d.setCantProdMC(rs.getDouble("CANT_A_PROD_MC"));
                d.setCantProdMM(rs.getDouble("CANT_A_PROD_MM"));
                d.setCantProdMI(rs.getDouble("CANT_A_PROD_MI"));

                d.setCantLotesMC(Math.ceil(rs.getDouble("CANT_A_PROD_MC")/rs.getDouble("cantidad_lote")));
                d.setCantLotesMM(Math.ceil(rs.getDouble("CANT_A_PROD_MM")/rs.getDouble("cantidad_lote")));
                d.setCantLotesMI(Math.ceil(rs.getDouble("CANT_A_PROD_MI")/rs.getDouble("cantidad_lote")));
                demandaProductosDetalleList.add(d);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return demandaProductosDetalleList;
    }
    public String getCargarDemandaProductosDetalle(){
        demandaProductosDetalleList = this.cargarDemandaDetalle();
        return null;
    }
    public String generarProgramaProduccionSimulacion(){
        try {
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();

            String consulta = " select isnull(max(cod_programa_prod),0)+1 cod_programa_prod from programa_produccion_periodo ";
            System.out.println("consulta " + consulta);
            ResultSet rs = st.executeQuery(consulta);
            int codProgramaProd = 0;
            if(rs.next()){
                codProgramaProd = rs.getInt("cod_programa_prod");
            }
            Date fecha = new Date();
            SimpleDateFormat sdf = new SimpleDateFormat();

            consulta =  " INSERT INTO PROGRAMA_PRODUCCION_PERIODO(  COD_PROGRAMA_PROD,  NOMBRE_PROGRAMA_PROD,  OBSERVACIONES,  COD_ESTADO_PROGRAMA," +
                    "  FECHA_INICIO,  FECHA_FINAL,  COD_TIPO_PRODUCCION,COD_DEMANDA) " +
                    "VALUES ( '"+codProgramaProd+"' ,  'DEMANDA PROGRAMA PRODUCCION',  '',  '4',  '"+sdf.format(fecha)+"',  '"+sdf.format(fecha)+"'," +
                    "  '1','"+demandaProductos.getCodDemanda()+"'); ";
            st.executeUpdate(consulta);
            System.out.println("consulta " + consulta);

            int correlativo = 1;
            Iterator i = demandaProductosDetalleList.iterator();
            while(i.hasNext()){
                DemandaProductosDetalle d = (DemandaProductosDetalle) i.next();
                for(int j = 1;j<=d.getCantLotesMC();j++){
                    consulta = " INSERT INTO PROGRAMA_PRODUCCION(  COD_PROGRAMA_PROD,  COD_COMPPROD,  COD_FORMULA_MAESTRA,  FECHA_INICIO,  FECHA_FINAL," +
                            "  COD_ESTADO_PROGRAMA,  COD_LOTE_PRODUCCION,  VERSION_LOTE,  CANT_LOTE_PRODUCCION,  OBSERVACION,  COD_TIPO_PROGRAMA_PROD," +
                            "  MATERIAL_TRANSITO,  COD_PRESENTACION,  COD_TIPO_APROBACION,  NRO_LOTES,  COD_COMPPROD_PADRE,  cod_lugar_acond)VALUES (" +
                            "  '"+codProgramaProd+"',  '"+d.getFormulaMaestra().getComponentesProd().getCodCompprod()+"',  '"+d.getFormulaMaestra().getCodFormulaMaestra()+"',  '',  '',  '4',  '"+correlativo+"'," +
                            "  '',  '"+d.getFormulaMaestra().getCantidadLote()+"' ,  '',  '1',  '',  '',  ''," +
                            "  1,  '',  '2'); ";
                    System.out.println("consulta "  + consulta);
                    st.executeUpdate(consulta);
                    this.guardaMateriales(correlativo, codProgramaProd, d, "1");
                    
                    
                    


                    
                    correlativo++;
                }
                for(int j = 1;j<=d.getCantLotesMM();j++){
                    consulta = " INSERT INTO PROGRAMA_PRODUCCION(  COD_PROGRAMA_PROD,  COD_COMPPROD,  COD_FORMULA_MAESTRA,  FECHA_INICIO,  FECHA_FINAL," +
                            "  COD_ESTADO_PROGRAMA,  COD_LOTE_PRODUCCION,  VERSION_LOTE,  CANT_LOTE_PRODUCCION,  OBSERVACION,  COD_TIPO_PROGRAMA_PROD," +
                            "  MATERIAL_TRANSITO,  COD_PRESENTACION,  COD_TIPO_APROBACION,  NRO_LOTES,  COD_COMPPROD_PADRE,  cod_lugar_acond)VALUES (" +
                            "  '"+codProgramaProd+"',  '"+d.getFormulaMaestra().getComponentesProd().getCodCompprod()+"',  '"+d.getFormulaMaestra().getCodFormulaMaestra()+"',  '',  '',  '4',  '"+correlativo+"'," +
                            "  '',  '"+d.getFormulaMaestra().getCantidadLote()+"' ,  '',  '3',  '',  '',  ''," +
                            "  1,  '',  '2'); ";
                    System.out.println("consulta " + consulta);
                    this.guardaMateriales(correlativo, codProgramaProd, d, "3");
                    st.executeUpdate(consulta);
                    correlativo++;
                }
                for(int j = 1;j<=d.getCantLotesMI();j++){
                    consulta = " INSERT INTO PROGRAMA_PRODUCCION(  COD_PROGRAMA_PROD,  COD_COMPPROD,  COD_FORMULA_MAESTRA,  FECHA_INICIO,  FECHA_FINAL," +
                            "  COD_ESTADO_PROGRAMA,  COD_LOTE_PRODUCCION,  VERSION_LOTE,  CANT_LOTE_PRODUCCION,  OBSERVACION,  COD_TIPO_PROGRAMA_PROD," +
                            "  MATERIAL_TRANSITO,  COD_PRESENTACION,  COD_TIPO_APROBACION,  NRO_LOTES,  COD_COMPPROD_PADRE,  cod_lugar_acond)VALUES (" +
                            "  '"+codProgramaProd+"',  '"+d.getFormulaMaestra().getComponentesProd().getCodCompprod()+"',  '"+d.getFormulaMaestra().getCodFormulaMaestra()+"',  '',  '',  '4',  '"+correlativo+"'," +
                            "  '',  '"+d.getFormulaMaestra().getCantidadLote()+"' ,  '',  '2',  '',  '',  ''," +
                            "  1,  '',  '2'); ";
                    System.out.println("consulta " + consulta);
                    this.guardaMateriales(correlativo, codProgramaProd, d, "2");
                    st.executeUpdate(consulta);
                    correlativo ++;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
 public void guardaMateriales(int correlativo,int codProgramaProd,DemandaProductosDetalle d,String codTipoProgramaProd){
     try {
         Connection con = null;
         con = Util.openConnection(con);
         Statement st = con.createStatement();
         String consulta ="";

     consulta = " INSERT INTO PROGRAMA_PRODUCCION_DETALLE(COD_PROGRAMA_PROD,  COD_COMPPROD,  COD_MATERIAL,  COD_UNIDAD_MEDIDA,  CANTIDAD," +
                            "  COD_LOTE_PRODUCCION,  COD_TIPO_PROGRAMA_PROD,  COD_TIPO_MATERIAL,COD_ESTADO_REGISTRO) select '"+codProgramaProd+"',  '"+d.getFormulaMaestra().getComponentesProd().getCodCompprod()+"',  f.COD_MATERIAL," +
                            "  f.COD_UNIDAD_MEDIDA,  f.CANTIDAD,  '"+correlativo+"',  '"+codTipoProgramaProd+"',  1,1 from formula_maestra_detalle_mp f where f.cod_formula_maestra = '"+d.getFormulaMaestra().getCodFormulaMaestra()+"'";
                    System.out.println("consulta " + consulta);
                    st.executeUpdate(consulta);
                    consulta = " INSERT INTO PROGRAMA_PRODUCCION_DETALLE(COD_PROGRAMA_PROD,  COD_COMPPROD,  COD_MATERIAL,  COD_UNIDAD_MEDIDA,  CANTIDAD," +
                            " COD_LOTE_PRODUCCION,  COD_TIPO_PROGRAMA_PROD,  COD_TIPO_MATERIAL,COD_ESTADO_REGISTRO) select '"+codProgramaProd+"',  '"+d.getFormulaMaestra().getComponentesProd().getCodCompprod()+"',  f.COD_MATERIAL," +
                            " f.COD_UNIDAD_MEDIDA,  f.CANTIDAD,  '"+correlativo+"',  '"+codTipoProgramaProd+"',  2,1 from formula_maestra_detalle_ep f inner join presentaciones_primarias p on p.cod_presentacion_primaria = f.cod_presentacion_primaria" +
                            " where cod_formula_maestra = '"+d.getFormulaMaestra().getCodFormulaMaestra()+"' and p.cod_tipo_programa_prod = '1'";
                    System.out.println("consulta " + consulta);
                    st.executeUpdate(consulta);

                    consulta = " INSERT INTO PROGRAMA_PRODUCCION_DETALLE(COD_PROGRAMA_PROD,  COD_COMPPROD,  COD_MATERIAL,  COD_UNIDAD_MEDIDA,  CANTIDAD," +
                            "  COD_LOTE_PRODUCCION,  COD_TIPO_PROGRAMA_PROD,  COD_TIPO_MATERIAL,COD_ESTADO_REGISTRO) select '"+codProgramaProd+"',  '"+d.getFormulaMaestra().getComponentesProd().getCodCompprod()+"',  f.COD_MATERIAL," +
                            "  f.COD_UNIDAD_MEDIDA,  f.CANTIDAD,  '"+correlativo+"',  '"+codTipoProgramaProd+"',  3,1 " +
                            " from formula_maestra fm inner join componentes_presprod c on c.cod_compprod = fm.cod_compprod and c.cod_tipo_programa_prod = '1'" +
                            " inner join formula_maestra_detalle_es f on f.cod_formula_maestra = fm.cod_formula_maestra and c.cod_presentacion = f.cod_presentacion_producto" +
                            " where fm.cod_formula_maestra = '"+d.getFormulaMaestra().getCodFormulaMaestra()+"'";
                    System.out.println("consulta " + consulta);
                    st.executeUpdate(consulta);
     } catch (Exception e) {
       e.printStackTrace();
     }
 }
 
 
 public String getCargarProductosProduccion1(){
     try {
         List productosList = new ArrayList();
         String codProgramaProd = "";
            HttpServletRequest request = (HttpServletRequest) FacesContext.getCurrentInstance().getExternalContext().getRequest();
            if (request.getParameter("codProgramaPeriodo") != null) {
                codProgramaProd = request.getParameter("codProgramaPeriodo");
            }
            this.cargarExplosionMateriales(codProgramaProd);
            String consulta = " select prp.COD_COMPPROD,dp.CANT_A_PROD_MC+dp.CANT_A_PROD_MM+dp.CANT_A_PROD_MI cant_prod," +
                    " fm.CANTIDAD_LOTE,fm.cod_formula_maestra,cp.nombre_prod_semiterminado,prp.CANT_LOTE_PRODUCCION,prp.COD_LOTE_PRODUCCION,t.COD_TIPO_PROGRAMA_PROD,t.NOMBRE_TIPO_PROGRAMA_PROD,e.COD_ESTADO_PROGRAMA_PROD,e.NOMBRE_ESTADO_PROGRAMA_PROD" +
                    " from PROGRAMA_PRODUCCION_PERIODO p inner join PROGRAMA_PRODUCCION prp on p.COD_PROGRAMA_PROD = prp.COD_PROGRAMA_PROD" +
                    " inner join FORMULA_MAESTRA fm on fm.COD_COMPPROD = prp.COD_COMPPROD" +
                    " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = fm.COD_COMPPROD" +
                    " inner join TIPOS_PROGRAMA_PRODUCCION t on t.COD_TIPO_PROGRAMA_PROD = prp.COD_TIPO_PROGRAMA_PROD " +
                    " inner join ESTADOS_PROGRAMA_PRODUCCION e on e.COD_ESTADO_PROGRAMA_PROD = prp.COD_ESTADO_PROGRAMA" +
                    " left outer join DEMANDA_DEPRODUCTOS d on d.COD_DEMANDA = p.COD_DEMANDA" +
                    " left outer join DEMANDA_DEPRODUCTOSDETALLE dp on dp.COD_DEMANDA = d.COD_DEMANDA and dp.COD_COMPPROD = prp.COD_COMPPROD" +
                    " where p.COD_PROGRAMA_PROD = '"+codProgramaProd+"'" +
                    " order by cant_prod desc ";
            Connection con = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(consulta);
            // primero hallar para los cuales alcanza el material
            while(rs.next()){
                ProgramaProduccion p = new ProgramaProduccion();
                p.getFormulaMaestra().getComponentesProd().setCodCompprod(rs.getString("cod_compprod"));
                p.getFormulaMaestra().setCantidadLote(rs.getDouble("cantidad_lote"));
                p.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(rs.getString("nombre_prod_semiterminado"));
                p.setCantidadLote(rs.getDouble("cant_lote_produccion"));
                p.setCodLoteProduccion(rs.getString("cod_lote_produccion"));
                p.getTiposProgramaProduccion().setCodTipoProgramaProd(rs.getString("cod_tipo_programa_prod"));
                p.getTiposProgramaProduccion().setNombreTipoProgramaProd(rs.getString("nombre_tipo_programa_prod"));
                p.getEstadoProgramaProduccion().setCodEstadoProgramaProd(rs.getString("cod_estado_programa_prod"));
                p.getEstadoProgramaProduccion().setNombreEstadoProgramaProd(rs.getString("nombre_estado_programa_prod"));
                p.getFormulaMaestra().setCodFormulaMaestra(rs.getString("cod_formula_maestra"));
                productosList.add(p);

//                if(this.alcanzaMateriales(this.formulaMaestraMP(p), explosionMaterialesList)==1
//                        && this.alcanzaMateriales(this.formulaMaestraMP(p), explosionMaterialesList)==1
//                        && this.alcanzaMateriales(this.formulaMaestraMP(p), explosionMaterialesList)==1){
//                    productosConMaterialesList.add(p);
//                }
            }
            Iterator i = productosList.iterator();
            while(i.hasNext()){
                ProgramaProduccion p = (ProgramaProduccion) i.next();
                if(this.alcanzaMateriales(this.formulaMaestraMP(p), explosionMaterialesList)==1
                        && this.alcanzaMateriales(this.formulaMaestraEP(p), explosionMaterialesList)==1
                        && this.alcanzaMateriales(this.formulaMaestraES(p), explosionMaterialesList)==1){
                    productosConMaterialesList.add(p);
                    i.remove();
                }
            }
            //productos disponibles para su proceso
            i = productosList.iterator();
            String codFormulaMaestra = "0";
            while(i.hasNext()){
                ProgramaProduccion p = (ProgramaProduccion) i.next();
                codFormulaMaestra = codFormulaMaestra+ ","+p.getFormulaMaestra().getCodFormulaMaestra();
            }
            System.out.println("cod formula maestra " + codFormulaMaestra);
            consulta = " select m.COD_MATERIAL,m.NOMBRE_MATERIAL,g.COD_GRUPO,g.NOMBRE_GRUPO" +
                    " from materiales m inner join unidades_medida u on u.cod_unidad_medida = m.cod_unidad_medida" +
                    " inner join grupos g on g.COD_GRUPO = m.COD_GRUPO" +
                    " where m.COD_MATERIAL in (" +
                    " select f.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_MP f where f.COD_FORMULA_MAESTRA in ("+codFormulaMaestra+")" +
                    " union all" +
                    " select f.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_EP f where f.COD_FORMULA_MAESTRA in ("+codFormulaMaestra+")" +
                    " union all" +
                    " select f.COD_MATERIAL from FORMULA_MAESTRA_DETALLE_ES f where f.COD_FORMULA_MAESTRA in ("+codFormulaMaestra+")) ";
            System.out.println("consulta " + consulta);
            Statement st1 = con.createStatement();
            ResultSet rs1 = st1.executeQuery(consulta);
            //por cada material buscar los productos implicados
            productosConMaterialesConflictoList.clear();
            while(rs1.next()){
                MaterialesConflicto m = new MaterialesConflicto();
                m.getMateriales().setCodMaterial(rs1.getString("cod_material"));
                m.getMateriales().setNombreMaterial(rs1.getString("nombre_material"));
                m.getMateriales().getGrupo().setCodGrupo(rs1.getInt("cod_grupo"));
                m.getMateriales().getGrupo().setNombreGrupo(rs1.getString("nombre_grupo"));
                m.setProductosList(productosConflicto(m.getMateriales(), codProgramaProd));
                m.setCantidad(this.buscaCantidad(explosionMaterialesList, m.getMateriales().getCodMaterial()));
                productosConMaterialesConflictoList.add(m);
            }

//            //productos con conflictos de materiales
//            i = productosList.iterator();
//            while(i.hasNext()){
//
//            }
            //productos donde no alcanza materiales
         

     } catch (Exception e) {
         e.printStackTrace();
     }
     return null;
 }
 public Double buscaCantidad(List explosionMaterialesList,String codMaterial){
     double cantidadMaterial = 0.0;
     try {
         Iterator i = explosionMaterialesList.iterator();
         while(i.hasNext()){
             ExplosionMateriales e = (ExplosionMateriales) i.next();
             if(e.getMateriales().getCodMaterial().equals(codMaterial)){
                 cantidadMaterial = e.getCantidadDisponible()+e.getCantidadTransito();
                 break;
             }
         }

     } catch (Exception e) {
         e.printStackTrace();
     }
     return cantidadMaterial;
 }
 public List productosConflicto(Materiales m,String codProgramaProd){
     List productosConflicto = new ArrayList();
     try {
         Connection con = null;
         con = Util.openConnection(con);
         Statement st = con.createStatement();
         String consulta = " select c.nombre_prod_semiterminado,t.NOMBRE_TIPO_PROGRAMA_PROD,t.cod_tipo_programa_prod,f.CANTIDAD" +
                 " from PROGRAMA_PRODUCCION p inner join COMPONENTES_PROD c on c.COD_COMPPROD = p.COD_COMPPROD" +
                 " inner join TIPOS_PROGRAMA_PRODUCCION t on t.COD_TIPO_PROGRAMA_PROD = p.COD_TIPO_PROGRAMA_PROD" +
                 " inner join FORMULA_MAESTRA_DETALLE_MP f on f.COD_FORMULA_MAESTRA = p.COD_FORMULA_MAESTRA and f.COD_MATERIAL = '"+m.getCodMaterial()+"'" +
                 " and p.COD_PROGRAMA_PROD = '"+codProgramaProd+"' ";
         System.out.println("consulta " + consulta);
         ResultSet rs = st.executeQuery(consulta);
         while(rs.next()){
             ProductosConflicto p = new ProductosConflicto();
             p.getProgramaProduccion().getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(rs.getString("nombre_prod_semiterminado"));
             p.getProgramaProduccion().getTiposProgramaProduccion().setCodTipoProgramaProd(rs.getString("cod_tipo_programa_prod"));
             p.getProgramaProduccion().getTiposProgramaProduccion().setNombreTipoProgramaProd(rs.getString("nombre_tipo_programa_prod"));
             p.setCantidad(rs.getDouble("CANTIDAD"));
             productosConflicto.add(p);
         }
     } catch (Exception e) {
         e.printStackTrace();
     }
     return productosConflicto;
 }
 public List formulaMaestraMP(ProgramaProduccion p){
     List formulaMaestraMPList = new ArrayList();
     try {
         Connection con = null;
         con = Util.openConnection(con);
         Statement st = con.createStatement();
         String consulta = " select f.COD_MATERIAL,f.CANTIDAD,f.COD_UNIDAD_MEDIDA" +
                 " from FORMULA_MAESTRA_DETALLE_MP f" +
                 " where f.COD_FORMULA_MAESTRA = '"+p.getFormulaMaestra().getCodFormulaMaestra()+"' ";
         System.out.println("consulta " + consulta);
         ResultSet rs = st.executeQuery(consulta);
         while(rs.next()){
             FormulaMaestraDetalleMP fm = new FormulaMaestraDetalleMP();
             fm.getMateriales().setCodMaterial(rs.getString("cod_material"));
             fm.setCantidad(rs.getDouble("cantidad"));
             fm.getUnidadesMedida().setCodUnidadMedida(rs.getString("cod_unidad_medida"));
             formulaMaestraMPList.add(fm);
         }
         rs.close();
         st.close();
         con.close();


     } catch (Exception e) {
         e.printStackTrace();
     }
     return formulaMaestraMPList;
 }
 
 public List formulaMaestraEP(ProgramaProduccion p){
     List formulaMaestraMPList = new ArrayList();
     try {
         Connection con = null;
         con = Util.openConnection(con);
         Statement st = con.createStatement();
         String consulta = " select f.COD_MATERIAL,  f.CANTIDAD, f.COD_UNIDAD_MEDIDA" +
                 " from formula_maestra_detalle_ep f inner join presentaciones_primarias p on p.cod_presentacion_primaria = f.cod_presentacion_primaria" +
                 " where cod_formula_maestra = '"+p.getFormulaMaestra().getCodFormulaMaestra()+"' and p.cod_tipo_programa_prod = '"+p.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' ";
         System.out.println("consulta " + consulta);
         ResultSet rs = st.executeQuery(consulta);
         while(rs.next()){
             FormulaMaestraDetalleMP fm = new FormulaMaestraDetalleMP();
             fm.getMateriales().setCodMaterial(rs.getString("cod_material"));
             fm.setCantidad(rs.getDouble("cantidad"));
             fm.getUnidadesMedida().setCodUnidadMedida(rs.getString("cod_unidad_medida"));
             formulaMaestraMPList.add(fm);
         }
         rs.close();
         st.close();
         con.close();


     } catch (Exception e) {
         e.printStackTrace();
     }
     return formulaMaestraMPList;
 }
 public List formulaMaestraES(ProgramaProduccion p){
     List formulaMaestraMPList = new ArrayList();
     try {
         Connection con = null;
         con = Util.openConnection(con);
         Statement st = con.createStatement();
         String consulta = " select f.COD_MATERIAL,f.COD_UNIDAD_MEDIDA,  f.CANTIDAD " +
                            " from formula_maestra fm inner join componentes_presprod c on c.cod_compprod = fm.cod_compprod and c.cod_tipo_programa_prod = '"+p.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'" +
                            " inner join formula_maestra_detalle_es f on f.cod_formula_maestra = fm.cod_formula_maestra and c.cod_presentacion = f.cod_presentacion_producto" +
                            " where fm.cod_formula_maestra = '"+p.getFormulaMaestra().getCodFormulaMaestra()+"' ";
         System.out.println("consulta " + consulta);
         ResultSet rs = st.executeQuery(consulta);
         while(rs.next()){
             FormulaMaestraDetalleMP fm = new FormulaMaestraDetalleMP();
             fm.getMateriales().setCodMaterial(rs.getString("cod_material"));
             fm.setCantidad(rs.getDouble("cantidad"));
             fm.getUnidadesMedida().setCodUnidadMedida(rs.getString("cod_unidad_medida"));
             formulaMaestraMPList.add(fm);
         }
         rs.close();
         st.close();
         con.close();


     } catch (Exception e) {
         e.printStackTrace();
     }
     return formulaMaestraMPList;
 }
 public int alcanzaMateriales(List formulaMaestraList,List explosionMaterialesList){
     int alcanzaMateriales = 1;
     Iterator i = formulaMaestraList.iterator();
     double cantidadAux = 0.0;
     while(i.hasNext()){
         FormulaMaestraDetalleMP mp = (FormulaMaestraDetalleMP) i.next();
         Iterator i1 = explosionMaterialesList.iterator();
         while(i1.hasNext()){
             ExplosionMateriales e = (ExplosionMateriales) i1.next();
             if(e.getMateriales().getCodMaterial().equals(mp.getMateriales().getCodMaterial())){
                 System.out.println("se va restando la cantidad "+ mp.getMateriales().getCodMaterial()+ ": " + e.getCantidadDisponible() +" -  "+ mp.getCantidad());
                 cantidadAux = e.getCantidadDisponible();
                e.setCantidadDisponible(e.getCantidadDisponible()-mp.getCantidad());
                if(e.getCantidadDisponible()<0){
                    alcanzaMateriales=0;
                    System.out.println("comparacion que afecto "+ mp.getMateriales().getCodMaterial()+ ": " + cantidadAux +" -  "+ mp.getCantidad());
                }
             }
         }
         
     }
     return alcanzaMateriales;     
 }
 
 



 public void cargarExplosionMateriales(String codProgramaProduccion){
        try {
            Connection con  = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            String consulta = " delete from explosion_materiales where cod_programa_produccion = '"+codProgramaProduccion+"' ";
            System.out.println("consulta " + consulta);
            st.executeUpdate(consulta);
            
            
            Date fechaActual = new Date();
            SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy/MM/dd");

            Date fecha = new Date();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
            
            consulta = " insert into explosion_materiales select '"+codProgramaProduccion+"',cod_material, cod_unidad_medida,0,(isnull(aprobados,0) + isnull(cuarentena,0)) disponible,cant_transito"+ //- isnull(rechazado,0) - isnull(vencido,0) - isnull(obsoleto,0) - isnull(reserva1,0) - isnull(salidas,0) + isnull(devoluciones1,0)
                                    "	from ("+
                                    "	select m.cod_material,"+
                                    "m.stock_minimo_material,"+
                                    "m.stock_maximo_material,"+
                                    "m.stock_seguridad,"+
                                    "m.cod_unidad_medida,"+
                                    "m.nombre_material,"+
                                    "u.nombre_unidad_medida,"+
                                    "("+
                                    "  select SUM(iade.cantidad_restante)"+
                                    "  from ingresos_almacen_detalle_estado iade,"+
                                    "       ingresos_almacen_detalle iad,"+
                                    "       ingresos_almacen ia"+
                                    "  WHERE iade.cod_material = m.cod_material and"+
                                    "        ia.cod_estado_ingreso_almacen = 1 and"+
                                    "        iad.cod_ingreso_almacen = ia.cod_ingreso_almacen and"+
                                    "        ia.estado_sistema = 1 and"+
                                    "        iade.cod_material = iad.cod_material and"+
                                    "        iade.cod_ingreso_almacen = iad.cod_ingreso_almacen and"+
                                    "        ia.fecha_ingreso_almacen <= '"+sdf.format(fecha)+" 23:59:00' and"+
                                    "        iade.cod_estado_material in (2, 6,8) and"+
                                    "        iade.cantidad_restante > 0"+
                                    ") as aprobados,"+
                                    "(0) as salidas,"+
                                    "(0) as devoluciones1,"+
                                    "("+
                                    "  select SUM(iade.cantidad_restante)"+
                                    "  from ingresos_almacen_detalle_estado iade,"+
                                    "       ingresos_almacen_detalle iad,"+
                                    "       ingresos_almacen ia"+
                                    "  WHERE iade.cod_material = m.cod_material and"+
                                    "        ia.cod_estado_ingreso_almacen = 1 and"+
                                    "        iad.cod_ingreso_almacen = ia.cod_ingreso_almacen and"+
                                    "        ia.estado_sistema = 1 and"+
                                    "        iade.cod_material = iad.cod_material and"+
                                    "        iade.cod_ingreso_almacen = iad.cod_ingreso_almacen and"+
                                    "        ia.fecha_ingreso_almacen <= '"+sdf.format(fecha)+" 23:59:00' and"+
                                    "        iade.cod_estado_material in (1) and"+
                                    "        iade.cantidad_restante > 0"+
                                    ") as cuarentena,"+
                                    "("+
                                    "  select SUM(iade.cantidad_restante)"+
                                    "  from ingresos_almacen_detalle_estado iade,"+
                                    "       ingresos_almacen_detalle iad,"+
                                    "       ingresos_almacen ia"+
                                    "  WHERE iade.cod_material = m.cod_material and"+
                                    "        ia.cod_estado_ingreso_almacen = 1 and"+
                                    "        iad.cod_ingreso_almacen = ia.cod_ingreso_almacen and"+
                                    "        ia.estado_sistema = 1 and"+
                                    "        iade.cod_material = iad.cod_material and"+
                                    "        iade.cod_ingreso_almacen = iad.cod_ingreso_almacen and"+
                                    "        ia.fecha_ingreso_almacen <= '"+sdf.format(fecha)+" 23:59:00' and"+
                                    "        iade.cod_estado_material in (3) and"+
                                    "        iade.cantidad_restante > 0"+
                                    ") as rechazado,"+
                                    "("+
                                    "  select SUM(iade.cantidad_restante)"+
                                    "  from ingresos_almacen_detalle_estado iade,"+
                                    "       ingresos_almacen_detalle iad,"+
                                    "       ingresos_almacen ia"+
                                    "  WHERE iade.cod_material = m.cod_material and"+
                                    "        ia.cod_estado_ingreso_almacen = 1 and"+
                                    "        iad.cod_ingreso_almacen = ia.cod_ingreso_almacen and"+
                                    "        ia.estado_sistema = 1 and"+
                                    "        iade.cod_material = iad.cod_material and"+
                                    "        iade.cod_ingreso_almacen = iad.cod_ingreso_almacen and"+
                                    "        ia.fecha_ingreso_almacen <= '"+sdf.format(fecha)+" 23:59:00' and"+
                                    "        iade.cod_estado_material in (4) and"+
                                    "        iade.cantidad_restante > 0"+
                                    ") as vencido,"+
                                    "(0) as obsoleto,"+
                                    "(0) as reserva1,"+
                                    "g.NOMBRE_GRUPO,"+
                                    "c.NOMBRE_CAPITULO,"+
                                    "oc1.cant_transito"+
                                    "	from materiales m inner join grupos g on m.COD_GRUPO = g.COD_GRUPO and m.MATERIAL_ALMACEN = 1 and m.MOVIMIENTO_ITEM = 1 and m.COD_ESTADO_REGISTRO = 1"+
                                    "		 inner join capitulos c on c.COD_CAPITULO = g.COD_CAPITULO				"+
                                    "	     inner join UNIDADES_MEDIDA u on u.COD_UNIDAD_MEDIDA = m.COD_UNIDAD_MEDIDA"+
                                    "	     outer apply"+
                                    "	     (  select top 1 oc.fecha_emision,oc.cod_orden_compra,oc.cod_moneda,ocd.cod_unidad_medida,"+
                                    "			precio_unitario,case when cantidad_neta-cantidad_ingreso_almacen<0 then 0 end cant_transito,um.NOMBRE_UNIDAD_MEDIDA,oc.FECHA_ENTREGA			"+
                                    "			from ordenes_compra_detalle ocd,ORDENES_COMPRA oc,UNIDADES_MEDIDA um			"+
                                    "			where oc.cod_orden_compra = ocd.cod_orden_compra and oc.COD_ESTADO_COMPRA IN (5,6,13) AND			"+
                                    "			oc.ESTADO_SISTEMA = 1 AND um.COD_UNIDAD_MEDIDA=ocd.cod_unidad_medida and			"+
                                    "			cod_material=m.COD_MATERIAL and oc.FECHA_ENTREGA >= '"+sdf.format(fecha)+" 00:00:00'  order by oc.FECHA_EMISION asc			"+
                                    " ) oc1"+
                                    "	where /*m.cod_grupo = g.cod_grupo and"+
                                    "	      g.cod_capitulo = c.cod_capitulo and"+
                                    "	      m.material_almacen = 1 and"+
                                    "	      m.movimiento_item = 1 and"+
                                    "	      m.cod_estado_registro = 1 and"+
                                    "	      u.cod_unidad_medida = m.cod_unidad_medida and*/"+
                                    "	      m.cod_material in (select distinct p.COD_MATERIAL from PROGRAMA_PRODUCCION_DETALLE p where p.COD_PROGRAMA_PROD = '"+codProgramaProduccion+"')"+
                                    "	) as tabla";
            
            System.out.println("consulta " + consulta);
            st.executeUpdate(consulta);
            st.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
 
}
