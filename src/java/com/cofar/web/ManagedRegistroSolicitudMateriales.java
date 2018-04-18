/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.web;

import com.cofar.bean.MaterialesSolicitudMantenimiento;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import javax.faces.application.FacesMessage;
import javax.faces.component.UIInput;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.model.SelectItem;
import javax.servlet.http.HttpServletRequest;
import org.richfaces.component.html.HtmlDataTable;

/**
 *
 * @author sistemas1
 */
public class ManagedRegistroSolicitudMateriales {

    //para datos de trabajo de solicitud
    private List<MaterialesSolicitudMantenimiento> materialesSolMantList = new ArrayList<MaterialesSolicitudMantenimiento>();
    private MaterialesSolicitudMantenimiento itemMateriales = new MaterialesSolicitudMantenimiento();
    private MaterialesSolicitudMantenimiento adicionarItemMaterial = new MaterialesSolicitudMantenimiento();
    private MaterialesSolicitudMantenimiento borrarItemMaterial = new MaterialesSolicitudMantenimiento();
    private MaterialesSolicitudMantenimiento modificarItemMaterial = new MaterialesSolicitudMantenimiento();
    private MaterialesSolicitudMantenimiento itemIteracionMateriales = new MaterialesSolicitudMantenimiento();
    private HtmlDataTable materialesDataTable;
    private HtmlDataTable ordenCompraMaterialesDataTable;
    private List<MaterialesSolicitudMantenimiento> ordenCompraMaterialesList = new ArrayList<MaterialesSolicitudMantenimiento>();
    private List materialesList = new ArrayList();
    private Connection con;
    private int codSolicitudMantenimiento;
    private int codMaterial;
    private transient UIInput alert;

    //------------materiales en espera de almacen ---------------
    private List<MaterialesSolicitudMantenimiento> materialesEnEspera = new ArrayList<MaterialesSolicitudMantenimiento>();
    private HtmlDataTable materialesEnEsperaDataTable;
    private String codEstadoSolicitudMateriales;
    private String nombreEstadoSolicitudMateriales;

    //-----------materiales en espera por orden de compra---------------
    private List<MaterialesSolicitudMantenimiento> materialesEnEsperaOrdenDeCompra = new ArrayList<MaterialesSolicitudMantenimiento>();
    private HtmlDataTable materialesEnEsperaOrdenDeCompraDataTable;
    private String codEstadoSolicitudOrdenDeCompraMateriales;
    private String nombreEstadoSolicitudOrdenDeCompraMateriales;

    //para datos de materiales de solicitud
    /** Creates a new instance of ManagedRegistroSolicitudMateriales */
    public ManagedRegistroSolicitudMateriales() {
    }

    public MaterialesSolicitudMantenimiento getAdicionarItemMaterial() {
        return adicionarItemMaterial;
    }

    public void setAdicionarItemMaterial(MaterialesSolicitudMantenimiento adicionarItemMaterial) {
        this.adicionarItemMaterial = adicionarItemMaterial;
    }

    public int getCodSolicitudMantenimiento() {
        return codSolicitudMantenimiento;
    }

    public void setCodSolicitudMantenimiento(int codSolicitudMantenimiento) {
        this.codSolicitudMantenimiento = codSolicitudMantenimiento;
    }

    public MaterialesSolicitudMantenimiento getItemMateriales() {
        return itemMateriales;
    }

    public void setItemMateriales(MaterialesSolicitudMantenimiento itemMateriales) {
        this.itemMateriales = itemMateriales;
    }

    public HtmlDataTable getMaterialesDataTable() {
        return materialesDataTable;
    }

    public void setMaterialesDataTable(HtmlDataTable materialesDataTable) {
        this.materialesDataTable = materialesDataTable;
    }

    public List getMaterialesList() {
        return materialesList;
    }

    public void setMaterialesList(List materialesList) {
        this.materialesList = materialesList;
    }

    public List<MaterialesSolicitudMantenimiento> getMaterialesSolMantList() {
        return materialesSolMantList;
    }

    public void setMaterialesSolMantList(List<MaterialesSolicitudMantenimiento> materialesSolMantList) {
        this.materialesSolMantList = materialesSolMantList;
    }

    public MaterialesSolicitudMantenimiento getModificarItemMaterial() {
        return modificarItemMaterial;
    }

    public void setModificarItemMaterial(MaterialesSolicitudMantenimiento modificarItemMaterial) {
        this.modificarItemMaterial = modificarItemMaterial;
    }

    public HtmlDataTable getOrdenCompraMaterialesDataTable() {
        return ordenCompraMaterialesDataTable;
    }

    public void setOrdenCompraMaterialesDataTable(HtmlDataTable ordenCompraMaterialesDataTable) {
        this.ordenCompraMaterialesDataTable = ordenCompraMaterialesDataTable;
    }

    public List<MaterialesSolicitudMantenimiento> getOrdenCompraMaterialesList() {
        return ordenCompraMaterialesList;
    }

    public void setOrdenCompraMaterialesList(List<MaterialesSolicitudMantenimiento> ordenCompraMaterialesList) {
        this.ordenCompraMaterialesList = ordenCompraMaterialesList;
    }

    public UIInput getAlert() {
        return alert;
    }

    public void setAlert(UIInput alert) {
        this.alert = alert;
    }

    public List<MaterialesSolicitudMantenimiento> getMaterialesEnEspera() {
        return materialesEnEspera;
    }

    public void setMaterialesEnEspera(List<MaterialesSolicitudMantenimiento> materialesEnEspera) {
        this.materialesEnEspera = materialesEnEspera;
    }

    public HtmlDataTable getMaterialesEnEsperaDataTable() {
        return materialesEnEsperaDataTable;
    }

    public void setMaterialesEnEsperaDataTable(HtmlDataTable materialesEnEsperaDataTable) {
        this.materialesEnEsperaDataTable = materialesEnEsperaDataTable;
    }

    public String getNombreEstadoSolicitudMateriales() {
        return nombreEstadoSolicitudMateriales;
    }

    public void setNombreEstadoSolicitudMateriales(String nombreEstadoSolicitudMateriales) {
        this.nombreEstadoSolicitudMateriales = nombreEstadoSolicitudMateriales;
    }

    public String getCodEstadoSolicitudOrdenDeCompraMateriales() {
        return codEstadoSolicitudOrdenDeCompraMateriales;
    }

    public void setCodEstadoSolicitudOrdenDeCompraMateriales(String codEstadoSolicitudOrdenDeCompraMateriales) {
        this.codEstadoSolicitudOrdenDeCompraMateriales = codEstadoSolicitudOrdenDeCompraMateriales;
    }

    public List<MaterialesSolicitudMantenimiento> getMaterialesEnEsperaOrdenDeCompra() {
        return materialesEnEsperaOrdenDeCompra;
    }

    public void setMaterialesEnEsperaOrdenDeCompra(List<MaterialesSolicitudMantenimiento> materialesEnEsperaOrdenDeCompra) {
        this.materialesEnEsperaOrdenDeCompra = materialesEnEsperaOrdenDeCompra;
    }

    public HtmlDataTable getMaterialesEnEsperaOrdenDeCompraDataTable() {
        return materialesEnEsperaOrdenDeCompraDataTable;
    }

    public void setMaterialesEnEsperaOrdenDeCompraDataTable(HtmlDataTable materialesEnEsperaOrdenDeCompraDataTable) {
        this.materialesEnEsperaOrdenDeCompraDataTable = materialesEnEsperaOrdenDeCompraDataTable;
    }

    public String getNombreEstadoSolicitudOrdenDeCompraMateriales() {
        return nombreEstadoSolicitudOrdenDeCompraMateriales;
    }

    public void setNombreEstadoSolicitudOrdenDeCompraMateriales(String nombreEstadoSolicitudOrdenDeCompraMateriales) {
        this.nombreEstadoSolicitudOrdenDeCompraMateriales = nombreEstadoSolicitudOrdenDeCompraMateriales;
    }

    void init() {
        try {

            HttpServletRequest request = (HttpServletRequest) FacesContext.getCurrentInstance().getExternalContext().getRequest();
            if (request.getParameter("nroSolicitud") != null) {
                codSolicitudMantenimiento = Integer.parseInt(request.getParameter("nroSolicitud"));
            }
            con = (Util.openConnection(con));
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            String consulta = "";
            //se lista los componentes a fabricar para programa_produccion

            consulta = " SELECT SMM.COD_SOLICITUD_MANTENIMIENTO,SMM.DESCRIPCION,M.COD_MATERIAL,M.NOMBRE_MATERIAL,UM.COD_UNIDAD_MEDIDA,UM.NOMBRE_UNIDAD_MEDIDA,SMM.CANTIDAD " +
                    " FROM SOLICITUDES_MANTENIMIENTO_MATERIALES SMM " +
                    " INNER JOIN MATERIALES M ON SMM.COD_MATERIAL=M.COD_MATERIAL " +
                    " INNER JOIN UNIDADES_MEDIDA UM ON M.COD_UNIDAD_MEDIDA=UM.COD_UNIDAD_MEDIDA " +
                    " WHERE SMM.COD_SOLICITUD_MANTENIMIENTO= " + codSolicitudMantenimiento;
            System.out.println("consulta "+consulta);
            ResultSet rs = st.executeQuery(consulta);

            rs.last();
            int filas = rs.getRow();
            //programaProduccionList.clear();
            rs.first();
            materialesSolMantList.clear();
            for (int i = 0; i < filas; i++) {
                itemMateriales = new MaterialesSolicitudMantenimiento();
                itemMateriales.setCodSolicitudMantenimiento(rs.getString("COD_SOLICITUD_MANTENIMIENTO"));
                itemMateriales.setDescripcion(rs.getString("DESCRIPCION"));
                itemMateriales.setCodMaterial(rs.getString("COD_MATERIAL"));
                itemMateriales.setNombreMaterial(rs.getString("NOMBRE_MATERIAL"));
                itemMateriales.setCodUnidadMedida(rs.getString("COD_UNIDAD_MEDIDA"));
                itemMateriales.setNombreUnidadMedida(rs.getString("NOMBRE_UNIDAD_MEDIDA"));
                itemMateriales.setCantidad(rs.getString("CANTIDAD"));
                itemMateriales.setDisponible(this.getDisponible(rs.getString("COD_MATERIAL")));

                materialesSolMantList.add(itemMateriales);
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

    public String getInit() {
        this.init();
        return "";
    }

    public String getDisponible(String codMaterial) {

        String disponible = "0";
        try {

            con = (Util.openConnection(con));
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            String consulta = " " +
                    " select DISTINCT m.cod_material, " +
                    " ISNULL((select SUM(iade.cantidad_parcial) " +
                    " from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia " +
                    " WHERE iade.cod_material=m.cod_material and ia.cod_estado_ingreso_almacen=1 and  " +
                    " iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and  " +
                    " iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen " +
                    " and ia.fecha_ingreso_almacen<=GETDATE() ) ,0) - " +
                    " ISNULL((select SUM(sadi.cantidad) " +
                    " from salidas_almacen_detalle sad,salidas_almacen_detalle_ingreso sadi,ingresos_almacen_detalle_estado iade, salidas_almacen sa " +
                    " WHERE sa.cod_salida_almacen=sad.cod_salida_almacen and sa.estado_sistema=1 and sa.cod_estado_salida_almacen=1 and " +
                    " sad.cod_salida_almacen=sadi.cod_salida_almacen and sad.cod_material=sadi.cod_material and " +
                    " sadi.cod_ingreso_almacen=iade.cod_ingreso_almacen and sadi.cod_material=iade.cod_material and sadi.ETIQUETA=iade.ETIQUETA " +
                    " and sad.cod_material=m.cod_material and sa.fecha_salida_almacen<=GETDATE() ) ,0)  + " +
                    " ISNULL( (select sum(iad.cant_total_ingreso_fisico) from DEVOLUCIONES d, ingresos_almacen ia,INGRESOS_ALMACEN_DETALLE iad " +
                    " where ia.cod_devolucion=d.cod_devolucion and ia.fecha_ingreso_almacen<=GETDATE() and d.cod_estado_devolucion=1 and d.estado_sistema=1 and ia.cod_estado_ingreso_almacen=1 " +
                    " and ia.cod_almacen=d.cod_almacen and ia.cod_ingreso_almacen=iad.cod_ingreso_almacen and iad.cod_material=m.cod_material) ,0) - " +
                    " ISNULL( (select SUM(iade.cantidad_restante) from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia " +
                    " WHERE iade.cod_material=m.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen " +
                    " and iade.cod_estado_material=1 and ia.fecha_ingreso_almacen<=GETDATE() ) ,0) - " +
                    " ISNULL( (select SUM(iade.cantidad_restante) from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia " +
                    " WHERE iade.cod_material=m.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen " +
                    " and iade.cod_estado_material=3 and ia.fecha_ingreso_almacen<=GETDATE() ) ,0) - " +
                    " ISNULL( (select SUM(iade.cantidad_restante)  from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia " +
                    " WHERE iade.cod_material=m.cod_material and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen " +
                    " and iade.cod_estado_material=4 and ia.fecha_ingreso_almacen<=GETDATE() ) ,0) - " +
                    " ISNULL( (select SUM(iade.cantidad_restante) from ingresos_almacen_detalle_estado iade,ingresos_almacen_detalle  iad,ingresos_almacen ia " +
                    " WHERE iade.cod_material=m.cod_material  and ia.cod_estado_ingreso_almacen=1 and iad.cod_ingreso_almacen=ia.cod_ingreso_almacen  and ia.estado_sistema=1 and iade.cod_material=iad.cod_material and iade.cod_ingreso_almacen=iad.cod_ingreso_almacen " +
                    " and iade.cod_estado_material=5 and ia.fecha_ingreso_almacen<=GETDATE() ),0) AS DISPONIBLE, m.COD_UNIDAD_MEDIDA " +
                    " from materiales m,grupos g,capitulos c, SECCIONES s,SECCIONES_DETALLE sd,almacenes al " +
                    " where m.cod_grupo=g.cod_grupo  and g.cod_capitulo=c.cod_capitulo and  m.material_almacen=1 and m.COD_MATERIAL='" + codMaterial + "'";
            System.out.println("consulta "+consulta);
            ResultSet rs = st.executeQuery(consulta);
            if (rs.next()) {
                disponible = rs.getString("DISPONIBLE");
            }

            if (rs != null) {
                rs.close();
                st.close();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return disponible;
    }

    public String editar_action() {
        try {


            this.cargarMateriales();
            modificarItemMaterial = new MaterialesSolicitudMantenimiento();
            modificarItemMaterial = (MaterialesSolicitudMantenimiento) materialesDataTable.getRowData();

            codMaterial = Integer.parseInt(modificarItemMaterial.getCodMaterial());

            //System.out.println("el codigo de Material" + modificarItemMaterial.getCodTipoMaterial());
            //System.out.println("el codigo de PERSONAL" + modificarItemMaterial.getCodPersonal());

            //System.out.println("el codigo de Material" + codTipoMaterial);

            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();

            ext.redirect("modificar_material_solicitud_mantenimiento.jsf");

//
//            con = (Util.openConnection(con));
//            String consulta = " SELECT SMT.COD_SOLICITUD_MANTENIMIENTO, SMT.COD_PERSONAL,SMT.COD_TIPO_TRABAJO,SMT.DESCRIPCION,SMT.FECHA_INICIO, " +
//                              " SMT.FECHA_FIN, SMT.HORAS_TRABAJO FROM SOLICITUDES_MANTENIMIENTO_TRABAJOS SMT "+
//                              " WHERE SMT.COD_SOLICITUD_MANTENIMIENTO=4 AND SMT.COD_PERSONAL = 2 ";
//
//
//            ResultSet rs = null;
//
//            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
//            tiposTrabajosList.clear();
//            rs = st.executeQuery(consulta);
//            while (rs.next()) {
//                tiposTrabajosList.add(new SelectItem(rs.getString(1), rs.getString(2)));
//            }
//
//            if (rs != null) {
//                rs.close();
//                st.close();
//                rs = null;
//                st = null;
//            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public String action_guardarModificacionMaterial() {
        try {
            System.out.println("ENTRO AL EVENTO  DE GUARDAR MODIFICACFION ");
            con = (Util.openConnection(con));

            String consulta = " UPDATE  " +
                    " SOLICITUDES_MANTENIMIENTO_MATERIALES " +
                    " SET " +
                    " COD_MATERIAL = '" + modificarItemMaterial.getCodMaterial() + "', " +
                    " DESCRIPCION ='" + modificarItemMaterial.getDescripcion() + "', " +
                    " CANTIDAD = '" + modificarItemMaterial.getCantidad() + "'" +
                    " WHERE COD_SOLICITUD_MANTENIMIENTO = '" + codSolicitudMantenimiento + "'" +
                    " AND COD_MATERIAL=" + codMaterial;

            System.out.println(consulta);

            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            st.executeUpdate(consulta);

            this.init();

        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            ext.redirect("listado_materiales_solicitud_mantenimiento.jsf");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String borrar_action() {
        try {
            borrarItemMaterial = (MaterialesSolicitudMantenimiento) materialesDataTable.getRowData();
            con = (Util.openConnection(con));

            String consulta = "  DELETE " +
                    " FROM SOLICITUDES_MANTENIMIENTO_MATERIALES " +
                    " WHERE COD_SOLICITUD_MANTENIMIENTO = '" + borrarItemMaterial.getCodSolicitudMantenimiento() + "' " +
                    " AND COD_MATERIAL = '" + borrarItemMaterial.getCodMaterial() + "'";

            System.out.println(consulta);

            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            st.executeUpdate(consulta);

            this.init();
            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            ext.redirect("listado_materiales_solicitud_mantenimiento.jsf");
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public void cargarMateriales() {
        try {
            con = (Util.openConnection(con));
            String consulta = " select M.COD_MATERIAL,M.NOMBRE_MATERIAL from materiales M WHERE M.COD_GRUPO IN(" +
                    " select G.COD_GRUPO from grupos G WHERE G.COD_CAPITULO=22) " +
                    " ORDER BY M.NOMBRE_MATERIAL ASC ";
            System.out.println("consulta "+consulta);
            ResultSet rs = null;

            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            materialesList.clear();
            rs = st.executeQuery(consulta);
            while (rs.next()) {
                materialesList.add(new SelectItem(rs.getString("COD_MATERIAL"), rs.getString("NOMBRE_MATERIAL")));
            }

            if (rs != null) {
                rs.close();
                st.close();
                rs = null;
                st = null;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public String adicionar_action() {
        try {

            adicionarItemMaterial = new MaterialesSolicitudMantenimiento();
            this.cargarMateriales();
            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            ext.redirect("agregar_material_solicitud_mantenimiento.jsf");


        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String retornar_action() {
        try {

            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            ext.redirect("navegador_solicitud_mantenimiento_usuario.jsf");

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String retornarListadoMateriales_action() {
        try {

            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            ext.redirect("listado_materiales_solicitud_mantenimiento.jsf");

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String action_guardarMaterial() {
        try {


            con = (Util.openConnection(con));

            String consulta = " INSERT INTO SOLICITUDES_MANTENIMIENTO_MATERIALES(COD_SOLICITUD_MANTENIMIENTO, COD_MATERIAL, DESCRIPCION, CANTIDAD) " +
                    " VALUES(" + codSolicitudMantenimiento + "," + adicionarItemMaterial.getCodMaterial() + ",'" + adicionarItemMaterial.getDescripcion() + "'," +
                    "'" + adicionarItemMaterial.getCantidad() + "') ";


            System.out.println(consulta);

            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            st.executeUpdate(consulta);

            this.init();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            ext.redirect("listado_materiales_solicitud_mantenimiento.jsf");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String cancelar_action() {
        try {

            this.init();
            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            ext.redirect("listado_materiales_solicitud_mantenimiento.jsf");

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String maximoIdSolicitudSalidaAlmacen() {
        String codMax = "0";
        try {
            String consulta = " SELECT (MAX(SS.COD_FORM_SALIDA)+1) AS IDMAX FROM SOLICITUDES_SALIDA SS ";
            System.out.println("consulta "+consulta);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            if (rs.next()) {
                codMax = rs.getString("IDMAX");
            }
            if (rs != null) {
                rs.close();
                st.close();
                rs = null;
                st = null;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return codMax;
    }

    public void generaSolicitudSalidaAlmacen(String codMax) {
        try {
            ManagedAccesoSistema m = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");
            String codPersonal = m.getUsuarioModuloBean().getCodUsuarioGlobal();

            String consulta = "INSERT INTO  dbo.SOLICITUDES_SALIDA(   COD_GESTION,   COD_FORM_SALIDA,   COD_TIPO_SALIDA_ALMACEN,   COD_ESTADO_SOLICITUD_SALIDA_ALMACEN, " +
                    "  SOLICITANTE,   AREA_DESTINO_SALIDA,   FECHA_SOLICITUD,   COD_LOTE_PRODUCCION,   OBS_SOLICITUD,   ESTADO_SISTEMA,   CONTROL_CALIDAD,   COD_INGRESO_ALMACEN, " +
                    "  COD_ALMACEN,   orden_trabajo) VALUES(   " +
                    "  (SELECT G.COD_GESTION FROM GESTIONES G WHERE G.GESTION_ESTADO=1)," +
                    "  " + codMax + ", " +
                    "  NULL,'1', " + codPersonal + ", 86,   GETDATE(),   NULL,   NULL,   1, " +
                    "  '0',   NULL,   '1','" + codSolicitudMantenimiento + "')   ";
            System.out.println("consulta "+consulta);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            st.executeUpdate(consulta);

            st.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void generaDetalleSolicitudSalidaAlmacen(String codMax) {
        try {

            String consulta = "";
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            //iterar el htmldatatable
            MaterialesSolicitudMantenimiento itemIteracionMaterial;
            for (int i = 0; i < materialesDataTable.getRowCount(); i++) {
                materialesDataTable.setRowIndex(i);
                itemIteracionMaterial = (MaterialesSolicitudMantenimiento) materialesDataTable.getRowData();
                consulta = " INSERT INTO " +
                        " dbo.SOLICITUDES_SALIDA_DETALLE(  COD_FORM_SALIDA,  COD_MATERIAL,   CANTIDAD,   CANTIDAD_ENTREGADA,   COD_UNIDAD_MEDIDA) " +
                        " VALUES('" + codMax + "', '" + itemIteracionMaterial.getCodMaterial() + "' , " +
                        "  " + itemIteracionMaterial.getCantidad() + ",   NULL,  '" + itemIteracionMaterial.getCodUnidadMedida() + "') ";
                System.out.println("consulta "+consulta);

                st.executeUpdate(consulta);

            }
            st.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String maximoIdSolicitudOrdenCompra() {
        String codMax = "0";
        try {
            String consulta = " SELECT (MAX(SC.COD_SOLICITUD_COMPRA)+1) IDMAX FROM SOLICITUDES_COMPRA SC ";
            System.out.println("consulta "+consulta);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(consulta);
            if (rs.next()) {
                codMax = rs.getString("IDMAX");
            }
            if (rs != null) {
                rs.close();
                st.close();
                rs = null;
                st = null;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return codMax;
    }

    public void generaSolicitudOrdenCompra(String codSolicitudCompra) {
        try {
            ManagedAccesoSistema m = (ManagedAccesoSistema) Util.getSessionBean("ManagedAccesoSistema");
            String codPersonal = m.getUsuarioModuloBean().getCodUsuarioGlobal();
            
            String consulta = " INSERT INTO dbo.SOLICITUDES_COMPRA( COD_SOLICITUD_COMPRA, COD_GESTION,   COD_TIPO_SOLICITUD_COMPRA,   COD_RESPONSABLE_COMPRAS,   COD_ESTADO_SOLICITUD_COMPRA, " +
                    " ESTADO_SISTEMA,  COD_PERSONAL,   COD_AREA_EMPRESA,   FECHA_SOLICITUD_COMPRA,    OBS_SOLICITUD_COMPRA,   FECHA_ENVIO) " +
                    " VALUES('" + codSolicitudCompra + "',  (SELECT G.COD_GESTION FROM GESTIONES G WHERE G.GESTION_ESTADO=1) ," +
                    " '1', '0' , '1', '1','" + codPersonal + "','"+m.getCodAreaEmpresaGlobal()+"', GETDATE() ,   NULL,   NULL)";
            System.out.println("consulta "+consulta);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            st.executeUpdate(consulta);

            st.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void generaDetalleSolicitudOrdenCompra(String codMax) {
        try {

            String consulta = "";
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            //iterar el htmldatatable
            MaterialesSolicitudMantenimiento itemIteracionMaterial;
            for (int i = 0; i < ordenCompraMaterialesDataTable.getRowCount(); i++) {
                ordenCompraMaterialesDataTable.setRowIndex(i);
                itemIteracionMaterial = (MaterialesSolicitudMantenimiento) ordenCompraMaterialesDataTable.getRowData();

                consulta = " INSERT INTO SOLICITUDES_COMPRA_DETALLE( COD_MATERIAL,   COD_SOLICITUD_COMPRA,   CANT_SOLICITADA,   COD_UNIDAD_MEDIDA, " +
                        " OBS_MATERIAL_SOLICITUD )  VALUES( '" + itemIteracionMaterial.getCodMaterial() + "', '" + codMax + "'," +
                        "  '" + itemIteracionMaterial.getCantidadSugerida() + "' , '" + itemIteracionMaterial.getCodUnidadMedida() + "',   NULL)";
                System.out.println("consulta "+consulta);
                st.executeUpdate(consulta);

            }
            st.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean compruebaOrdenCompra() {
        boolean tieneOrdenDeCompra = false;
        try {
            con = (Util.openConnection(con));
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            String consulta = "";
            //se lista los componentes a fabricar para programa_produccion

            consulta = " SELECT * FROM SOLICITUDES_MANTENIMIENTO SM WHERE SM.COD_SOLICITUD_MANTENIMIENTO='" + codSolicitudMantenimiento + "'" +
                    " AND SM.COD_SOLICITUD_COMPRA IS NOT NULL";
            System.out.println("consulta "+consulta);
            ResultSet rs = st.executeQuery(consulta);

            if (rs.next()) {
                tieneOrdenDeCompra = true;
            }

            if (rs != null) {
                rs.close();
                st.close();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return tieneOrdenDeCompra;
    }

    public String solicitudAlmacen_action() {
        try {
            //iterar el htmldatatable
            int tieneStock = 1;

            for (int i = 0; i < materialesDataTable.getRowCount(); i++) {
                materialesDataTable.setRowIndex(i);
                itemIteracionMateriales = (MaterialesSolicitudMantenimiento) materialesDataTable.getRowData();
                if (Float.parseFloat(itemIteracionMateriales.getCantidad()) > Float.parseFloat(itemIteracionMateriales.getDisponible())) {
                    FacesContext facesContext = FacesContext.getCurrentInstance();
                    facesContext.addMessage(alert.getClientId(facesContext),
                            new FacesMessage(FacesMessage.SEVERITY_INFO, itemIteracionMateriales.getNombreMaterial() +
                            " no tiene stock ", ""));
                    tieneStock = 0;

                }
            }
            

            if (tieneStock == 1) {
                //generar solicitud de salida de almacen
                //genera detalle de solicitud de salida de almacen
                String idMax = this.maximoIdSolicitudSalidaAlmacen();
                this.generaSolicitudSalidaAlmacen(idMax);
                this.generaDetalleSolicitudSalidaAlmacen(idMax);
                this.solicitudEsperaDeMateriales("3"); //cambio de estado a espera de materiales 3: por espera en almacen
                this.solicitudConSalidaAlmacen(idMax); //actualizacion del campo de codigo de solicitud de almacen

                //redireccion a la pagina principal

                FacesContext facesContext = FacesContext.getCurrentInstance();
                ExternalContext ext = facesContext.getExternalContext();
                ext.redirect("navegador_solicitud_mantenimiento_usuario.jsf");

            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void solicitudEsperaDeMateriales(String codEstado) {

        try {
            //3:ESTADO DE ESPERA DE MATERIALES
            String consulta = "UPDATE SOLICITUDES_MANTENIMIENTO SET   COD_ESTADO_SOLICITUD_MANTENIMIENTO = '" + codEstado + "'" +
                    ", FECHA_CAMBIO_ESTADOSOLICITUD = GETDATE()  " +
                    " WHERE COD_SOLICITUD_MANTENIMIENTO = '" + codSolicitudMantenimiento + "'";
            System.out.println("consulta "+consulta);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            st.executeUpdate(consulta);

            st.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    public void solicitudConCompraDeMateriales(String idmax) {

        try {
            //3:ESTADO DE ESPERA DE MATERIALES
            String consulta = "UPDATE SOLICITUDES_MANTENIMIENTO SET COD_SOLICITUD_COMPRA = '" + idmax + "'" +                    
                    " WHERE COD_SOLICITUD_MANTENIMIENTO = '" + codSolicitudMantenimiento + "'";
            System.out.println("consulta "+consulta);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            st.executeUpdate(consulta);

            st.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void solicitudConSalidaAlmacen(String idmax) {

        try {
            //3:ESTADO DE ESPERA DE MATERIALES
            String consulta = "UPDATE SOLICITUDES_MANTENIMIENTO SET COD_FORM_SALIDA = '" + idmax + "'" +                    
                    " WHERE COD_SOLICITUD_MANTENIMIENTO = '" + codSolicitudMantenimiento + "'";
            System.out.println("consulta "+consulta);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            st.executeUpdate(consulta);

            st.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    public String ordenDeCompra_action() {
        try {
            //si tiene orden de compra
            if (this.compruebaOrdenCompra() == true) {
                FacesContext facesContext = FacesContext.getCurrentInstance();
                facesContext.addMessage(alert.getClientId(facesContext),
                        new FacesMessage(FacesMessage.SEVERITY_INFO,
                        " ya realizo orden de compra ", ""));
                return null;
            }

            //iterar la tabla principal e insertar en la tabla de ordenes de compra
            float cantidadSugerida = 0.0f;
            ordenCompraMaterialesList.clear();
            for (int i = 0; i < materialesDataTable.getRowCount(); i++) {
                materialesDataTable.setRowIndex(i);
                itemIteracionMateriales = (MaterialesSolicitudMantenimiento) materialesDataTable.getRowData();
                if (Float.parseFloat(itemIteracionMateriales.getCantidad()) > Float.parseFloat(itemIteracionMateriales.getDisponible())) {
                    cantidadSugerida = Float.parseFloat(itemIteracionMateriales.getCantidad()) - Float.parseFloat(itemIteracionMateriales.getDisponible());
                    itemIteracionMateriales.setCantidadSugerida(String.valueOf(cantidadSugerida)); //colocamos la cantidad sugerida                    
                    ordenCompraMaterialesList.add(itemIteracionMateriales);
                }
            }

            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            ext.redirect("registrar_orden_compra_materiales.jsf");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String solicitarOrdenDeCompra_action() {
        try {
            //iterar el htmldatatable
            int existeMenos = 0;
            float minimoSolicitar = 0.0f;
            for (int i = 0; i < ordenCompraMaterialesDataTable.getRowCount(); i++) {
                ordenCompraMaterialesDataTable.setRowIndex(i);
                itemIteracionMateriales = (MaterialesSolicitudMantenimiento) ordenCompraMaterialesDataTable.getRowData();
                minimoSolicitar = Float.parseFloat(itemIteracionMateriales.getCantidad()) - Float.parseFloat(itemIteracionMateriales.getDisponible());
                System.out.println("desde solicitar orden de compra" + itemIteracionMateriales.getNombreMaterial() + " " +
                        itemIteracionMateriales.getCantidadSugerida());

                if (Float.parseFloat(itemIteracionMateriales.getCantidadSugerida()) < minimoSolicitar) {
                    FacesContext facesContext = FacesContext.getCurrentInstance();
                    facesContext.addMessage(alert.getClientId(facesContext),
                            new FacesMessage(FacesMessage.SEVERITY_INFO, itemIteracionMateriales.getNombreMaterial() +
                            " tiene cantidad menor que la requerida para la solicitud de Orden de Compra ", ""));
                    existeMenos = 1;
                }
            }
            if (existeMenos == 0) {
                //generar solicitud de Orden de Compra
                //genera detalle de solicitud de Orden de Compra
                String idMax = this.maximoIdSolicitudOrdenCompra();
                this.generaSolicitudOrdenCompra(idMax);
                this.generaDetalleSolicitudOrdenCompra(idMax);
                this.solicitudEsperaDeMateriales("4"); //cambio de estado a espera de materiales 4: por espera de orden de compra
                this.solicitudConCompraDeMateriales(idMax);

                //redireccion a la pagina principal
                FacesContext facesContext = FacesContext.getCurrentInstance();
                ExternalContext ext = facesContext.getExternalContext();
                ext.redirect("navegador_solicitud_mantenimiento_usuario.jsf");

            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public String getinitEsperaMateriales() {
        this.initEsperaMateriales();
        return "";
    }

    public void getEstadoSolicitudMaterialesAlmacen() {
        try {
            con = (Util.openConnection(con));
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            String consulta = "";
            //se lista los componentes a fabricar para programa_produccion

            consulta = " SELECT ESSA.COD_ESTADO_SOLICITUD_SALIDA_ALMACEN, ESSA.NOMBRE_ESTADO_SOLICITUD_SALIDA_ALMACEN  FROM " +
                    " SOLICITUDES_MANTENIMIENTO SM  INNER JOIN SOLICITUDES_SALIDA SS ON SM.COD_FORM_SALIDA = SS.COD_FORM_SALIDA " +
                    " INNER JOIN ESTADOS_SOLICITUD_SALIDAS_ALMACEN ESSA " +
                    " ON SS.COD_ESTADO_SOLICITUD_SALIDA_ALMACEN = ESSA.COD_ESTADO_SOLICITUD_SALIDA_ALMACEN " +
                    " WHERE SM.COD_SOLICITUD_MANTENIMIENTO = '" + codSolicitudMantenimiento + "'";
            System.out.println(" la consulta de estado de solicitud " + consulta);
            ResultSet rs = st.executeQuery(consulta);

            if (rs.next()) {
                codEstadoSolicitudMateriales = rs.getString("COD_ESTADO_SOLICITUD_SALIDA_ALMACEN");
                nombreEstadoSolicitudMateriales = rs.getString("NOMBRE_ESTADO_SOLICITUD_SALIDA_ALMACEN");
            }

            if (rs != null) {
                rs.close();
                st.close();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
//para espera de materiales por solicitud en almacen

    void initEsperaMateriales() {
        try {

            HttpServletRequest request = (HttpServletRequest) FacesContext.getCurrentInstance().getExternalContext().getRequest();
            if (request.getParameter("nroSolicitud") != null) {
                codSolicitudMantenimiento = Integer.parseInt(request.getParameter("nroSolicitud"));
            }
            con = (Util.openConnection(con));
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            String consulta = "";
            //se lista los componentes a fabricar para programa_produccion

            consulta = " SELECT SMM.COD_SOLICITUD_MANTENIMIENTO,SMM.DESCRIPCION,M.COD_MATERIAL,M.NOMBRE_MATERIAL,UM.COD_UNIDAD_MEDIDA,UM.NOMBRE_UNIDAD_MEDIDA,SMM.CANTIDAD " +
                    " FROM SOLICITUDES_MANTENIMIENTO_MATERIALES SMM " +
                    " INNER JOIN MATERIALES M ON SMM.COD_MATERIAL=M.COD_MATERIAL " +
                    " INNER JOIN UNIDADES_MEDIDA UM ON M.COD_UNIDAD_MEDIDA=UM.COD_UNIDAD_MEDIDA " +
                    " WHERE SMM.COD_SOLICITUD_MANTENIMIENTO= " + codSolicitudMantenimiento;
            System.out.println("consulta "+consulta);
            ResultSet rs = st.executeQuery(consulta);

            rs.last();
            int filas = rs.getRow();
            //programaProduccionList.clear();
            rs.first();
            materialesEnEspera.clear();
            for (int i = 0; i < filas; i++) {
                itemMateriales = new MaterialesSolicitudMantenimiento();
                itemMateriales.setCodSolicitudMantenimiento(rs.getString("COD_SOLICITUD_MANTENIMIENTO"));
                itemMateriales.setDescripcion(rs.getString("DESCRIPCION"));
                itemMateriales.setCodMaterial(rs.getString("COD_MATERIAL"));
                itemMateriales.setNombreMaterial(rs.getString("NOMBRE_MATERIAL"));
                itemMateriales.setCodUnidadMedida(rs.getString("COD_UNIDAD_MEDIDA"));
                itemMateriales.setNombreUnidadMedida(rs.getString("NOMBRE_UNIDAD_MEDIDA"));
                itemMateriales.setCantidad(rs.getString("CANTIDAD"));

                materialesEnEspera.add(itemMateriales);
                rs.next();
            }
            if (rs != null) {
                rs.close();
                st.close();
            }
            this.getEstadoSolicitudMaterialesAlmacen();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String aceptarEntregaMateriales_action() {
        //primero comprobar que el codigo de solicitud materiales es 2: entregado
        // luego cambiar de estado a la solicitud de mantenimiento a estado 5 : con materiales
        try {


            if (codEstadoSolicitudMateriales.equals("2") || codEstadoSolicitudMateriales.equals("3")) {
                String consulta = "UPDATE SOLICITUDES_MANTENIMIENTO SET COD_ESTADO_SOLICITUD_MANTENIMIENTO = '5'" +
                        " WHERE COD_SOLICITUD_MANTENIMIENTO = '" + codSolicitudMantenimiento + "'";
                System.out.println("consulta "+consulta);
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                st.executeUpdate(consulta);
                st.close();

                //redireccion a la pagina principal
                FacesContext facesContext = FacesContext.getCurrentInstance();
                ExternalContext ext = facesContext.getExternalContext();
                ext.redirect("navegador_solicitud_mantenimiento_usuario.jsf");

            } else {
                FacesContext facesContext = FacesContext.getCurrentInstance();
                facesContext.addMessage(alert.getClientId(facesContext),
                        new FacesMessage(FacesMessage.SEVERITY_INFO, itemIteracionMateriales.getNombreMaterial() +
                        " no hubo entrega de materiales ", ""));
            }



        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
//para espera de materiales por orden de compra

    void initEsperaMaterialesOrdenDeCompra() {
        try {

            HttpServletRequest request = (HttpServletRequest) FacesContext.getCurrentInstance().getExternalContext().getRequest();
            if (request.getParameter("nroSolicitud") != null) {
                codSolicitudMantenimiento = Integer.parseInt(request.getParameter("nroSolicitud"));
            }
            con = (Util.openConnection(con));
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            String consulta = "";
            //se lista los componentes a fabricar para programa_produccion

            consulta = " SELECT SM.COD_SOLICITUD_MANTENIMIENTO, M.COD_MATERIAL,M.NOMBRE_MATERIAL, UM.COD_UNIDAD_MEDIDA, UM.NOMBRE_UNIDAD_MEDIDA,SCD.CANT_SOLICITADA FROM SOLICITUDES_MANTENIMIENTO SM  " +
                    " INNER JOIN SOLICITUDES_COMPRA SC ON SM.COD_SOLICITUD_COMPRA = SC.COD_SOLICITUD_COMPRA " +
                    " INNER JOIN SOLICITUDES_COMPRA_DETALLE SCD ON SC.COD_SOLICITUD_COMPRA = SCD.COD_SOLICITUD_COMPRA " +
                    " INNER JOIN MATERIALES M ON SCD.COD_MATERIAL=M.COD_MATERIAL " +
                    " INNER JOIN UNIDADES_MEDIDA UM ON SCD.COD_UNIDAD_MEDIDA = UM.COD_UNIDAD_MEDIDA " +
                    " WHERE SM.COD_SOLICITUD_MANTENIMIENTO = '" + codSolicitudMantenimiento + "'";

            ResultSet rs = st.executeQuery(consulta);

            rs.last();
            int filas = rs.getRow();
            //programaProduccionList.clear();
            rs.first();
            materialesEnEsperaOrdenDeCompra.clear();
            for (int i = 0; i < filas; i++) {

                itemMateriales = new MaterialesSolicitudMantenimiento();
                itemMateriales.setCodSolicitudMantenimiento(rs.getString("COD_SOLICITUD_MANTENIMIENTO"));
                itemMateriales.setCodMaterial(rs.getString("COD_MATERIAL"));
                itemMateriales.setNombreMaterial(rs.getString("NOMBRE_MATERIAL"));
                itemMateriales.setCodUnidadMedida(rs.getString("COD_UNIDAD_MEDIDA"));
                itemMateriales.setNombreUnidadMedida(rs.getString("NOMBRE_UNIDAD_MEDIDA"));
                itemMateriales.setCantidadSugerida(rs.getString("CANT_SOLICITADA"));
                itemMateriales.setDisponible(this.getDisponible(rs.getString("COD_MATERIAL")));

                materialesEnEsperaOrdenDeCompra.add(itemMateriales);
                rs.next();
            }
            if (rs != null) {
                rs.close();
                st.close();
            }
            this.getEstadoSolicitudCompraMateriales();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String getinitEsperaMaterialesOrdenDeCompra() {
        this.initEsperaMaterialesOrdenDeCompra();
        return "";
    }

    public void getEstadoSolicitudCompraMateriales() {
        try {
            con = (Util.openConnection(con));
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            String consulta = "";

            //se lista los componentes a fabricar para programa_produccion

            consulta = "SELECT EC.NOMBRE_ESTADO_COMPRA FROM SOLICITUDES_MANTENIMIENTO SM  " +
                    " INNER JOIN SOLICITUDES_COMPRA SC ON SM.COD_SOLICITUD_COMPRA = SC.COD_SOLICITUD_COMPRA " +
                    " INNER JOIN COTIZACIONES C ON SC.COD_SOLICITUD_COMPRA = C.COD_SOLICITUD_COMPRA " +
                    " INNER JOIN ORDENES_COMPRA OC ON C.COD_COTIZACION = OC.COD_COTIZACION " +
                    " INNER JOIN ESTADOS_COMPRA EC ON OC.COD_ESTADO_COMPRA = EC.COD_ESTADO_COMPRA " +
                    " WHERE SM.COD_SOLICITUD_MANTENIMIENTO = '" + codSolicitudMantenimiento + "'" +
                    " AND C.COD_ESTADO_COTIZACION='2' " +
                    " AND OC.COD_ESTADO_COMPRA IN (6,7,14) ";
            System.out.println("consulta "+consulta);
            ResultSet rs = st.executeQuery(consulta);

            if (rs.next()) {
                nombreEstadoSolicitudOrdenDeCompraMateriales = rs.getString("NOMBRE_ESTADO_COMPRA");
            } else {
                nombreEstadoSolicitudOrdenDeCompraMateriales = "EN PROGRESO DE COMPRAS";
            }

            if (rs != null) {
                rs.close();
                st.close();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String solicitarAlmacen_action() {
        try {
            //iterar el htmldatatable
            int tieneStock = 1;

            for (int i = 0; i < materialesEnEsperaOrdenDeCompraDataTable.getRowCount(); i++) {
                materialesEnEsperaOrdenDeCompraDataTable.setRowIndex(i);
                itemIteracionMateriales = (MaterialesSolicitudMantenimiento) materialesEnEsperaOrdenDeCompraDataTable.getRowData();

                System.out.println(" la comparacion en la orden de compra : " +
                        Float.parseFloat(itemIteracionMateriales.getCantidadSugerida()) + " > " +
                        Float.parseFloat(itemIteracionMateriales.getDisponible()));

                if (Float.parseFloat(itemIteracionMateriales.getCantidadSugerida()) > Float.parseFloat(itemIteracionMateriales.getDisponible())) {
                    FacesContext facesContext = FacesContext.getCurrentInstance();
                    facesContext.addMessage(alert.getClientId(facesContext),
                            new FacesMessage(FacesMessage.SEVERITY_INFO, itemIteracionMateriales.getNombreMaterial() +
                            " no tiene stock ", ""));
                    tieneStock = 0;

                }
            }
            if (tieneStock == 1) {

                //cambiar a estado revisado pero se tiene que verificar en solicitud de almacen que ya no puede realizar otra orden de compra
                //2 :estado de revisado

                String consulta = "UPDATE SOLICITUDES_MANTENIMIENTO SET COD_ESTADO_SOLICITUD_MANTENIMIENTO = '2'" +
                        ", FECHA_CAMBIO_ESTADOSOLICITUD = GETDATE()  " +
                        " WHERE COD_SOLICITUD_MANTENIMIENTO = '" + codSolicitudMantenimiento + "'";
                System.out.println("consulta "+consulta);
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                st.executeUpdate(consulta);
                st.close();


                FacesContext facesContext = FacesContext.getCurrentInstance();
                ExternalContext ext = facesContext.getExternalContext();
                ext.redirect("navegador_solicitud_mantenimiento_usuario.jsf?nroSolicitud=" + codSolicitudMantenimiento);

            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}
