/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.web;

import com.cofar.bean.Maquinaria;
import com.cofar.bean.ProgramaProduccion;
import com.cofar.bean.ProgramaProduccionDetalle;
import com.cofar.bean.AbstractBean;
import com.cofar.bean.DemandaProductos;
import com.cofar.bean.DemandaProductosDetalle;
import com.cofar.util.Util;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import javax.faces.application.FacesMessage;
import javax.faces.component.UIInput;
import javax.faces.context.ExternalContext;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;
import javax.faces.event.ValueChangeEvent;
import javax.servlet.http.HttpServletRequest;
import org.joda.time.DateTime;
import org.richfaces.component.html.HtmlDataTable;

/**
 *
 * @author sistemas1
 */
public class ManagedProgramaProduccionVerificarProducto {

    public class Componente {

        private String codProgramaProd = "";
        private String codCompProd = "";
        private String nombreCompProd = "";
        private String codMaterial = "";
        private String nombreMaterial = "";
        private String cantidadAUtilizar = "";
        private String cantidadDisponible = "";
        private String cantidadEnTransito = "";
        private String stockMinimoMaterial = "";
        private String cantLoteProduccion = "";
        private String codTipoProgramaProd = "";
        private String nombreTipoProgramaProd = "";
        private String categoria = "";
        private String conCheck = "";
        private String seleccionadoCheck = "";
        private String cantidadAUtilizarRef = "";
        private String cantidadDisponibleRef = "";
        private String cantidadEnTransitoRef = "";
        private String cantLoteProduccionRef = "";
        private String nombreTipoProgramaProdRef = "";
        private String linkOperacion = "";
        private String codLoteProduccion = "";
        private String codPresentacion = "";
        private String iconoEstadoSimulacion = "";
        private String tieneIconoEstadoSimulacion = "";
        private String estiloEstado = "";
        private String conInputTextCantLoteProduccion = "";
        private String inputTextCantLoteProduccionSoloLectura = "";
        private String codFormulaMaestra = "";
        private String conMateriales = "";
        private String codTipoAprobacionProgramaProduccion="";
        private String nombreTipoAprobacionProgramaProduccion="";
        
        public String getCantLoteProduccion() {
            return cantLoteProduccion;
        }

        public void setCantLoteProduccion(String cantLoteProduccion) {
            this.cantLoteProduccion = cantLoteProduccion;
        }

        public String getCantidadAUtilizar() {
            return cantidadAUtilizar;
        }

        public void setCantidadAUtilizar(String cantidadAUtilizar) {
            this.cantidadAUtilizar = cantidadAUtilizar;
        }

        public String getCantidadDisponible() {
            return cantidadDisponible;
        }

        public void setCantidadDisponible(String cantidadDisponible) {
            this.cantidadDisponible = cantidadDisponible;
        }

        public String getCantidadEnTransito() {
            return cantidadEnTransito;
        }

        public void setCantidadEnTransito(String cantidadEnTransito) {
            this.cantidadEnTransito = cantidadEnTransito;
        }

        public String getCodCompProd() {
            return codCompProd;
        }

        public void setCodCompProd(String codCompProd) {
            this.codCompProd = codCompProd;
        }

        public String getCodMaterial() {
            return codMaterial;
        }

        public void setCodMaterial(String codMaterial) {
            this.codMaterial = codMaterial;
        }

        public String getCodProgramaProd() {
            return codProgramaProd;
        }

        public void setCodProgramaProd(String codProgramaProd) {
            this.codProgramaProd = codProgramaProd;
        }

        public String getNombreCompProd() {
            return nombreCompProd;
        }

        public void setNombreCompProd(String nombreCompProd) {
            this.nombreCompProd = nombreCompProd;
        }

        public String getStockMinimoMaterial() {
            return stockMinimoMaterial;
        }

        public void setStockMinimoMaterial(String stockMinimoMaterial) {
            this.stockMinimoMaterial = stockMinimoMaterial;
        }

        public String getNombreMaterial() {
            return nombreMaterial;
        }

        public void setNombreMaterial(String nombreMaterial) {
            this.nombreMaterial = nombreMaterial;
        }

        public String getNombreTipoProgramaProd() {
            return nombreTipoProgramaProd;
        }

        public void setNombreTipoProgramaProd(String nombreTipoProgramaProd) {
            this.nombreTipoProgramaProd = nombreTipoProgramaProd;
        }

        public String getCategoria() {
            return categoria;
        }

        public void setCategoria(String categoria) {
            this.categoria = categoria;
        }

        public String getConCheck() {
            return conCheck;
        }

        public void setConCheck(String conCheck) {
            this.conCheck = conCheck;
        }

        public String getSeleccionadoCheck() {
            return seleccionadoCheck;
        }

        public void setSeleccionadoCheck(String seleccionadoCheck) {
            this.seleccionadoCheck = seleccionadoCheck;
        }

        public String getCantidadAUtilizarRef() {
            return cantidadAUtilizarRef;
        }

        public void setCantidadAUtilizarRef(String cantidadAUtilizarRef) {
            this.cantidadAUtilizarRef = cantidadAUtilizarRef;
        }

        public String getCantidadDisponibleRef() {
            return cantidadDisponibleRef;
        }

        public void setCantidadDisponibleRef(String cantidadDisponibleRef) {
            this.cantidadDisponibleRef = cantidadDisponibleRef;
        }

        public String getCantidadEnTransitoRef() {
            return cantidadEnTransitoRef;
        }

        public void setCantidadEnTransitoRef(String cantidadEnTransitoRef) {
            this.cantidadEnTransitoRef = cantidadEnTransitoRef;
        }

        public String getCantLoteProduccionRef() {
            return cantLoteProduccionRef;
        }

        public void setCantLoteProduccionRef(String cantLoteProduccionRef) {
            this.cantLoteProduccionRef = cantLoteProduccionRef;
        }

        public String getNombreTipoProgramaProdRef() {
            return nombreTipoProgramaProdRef;
        }

        public void setNombreTipoProgramaProdRef(String nombreTipoProgramaProdRef) {
            this.nombreTipoProgramaProdRef = nombreTipoProgramaProdRef;
        }

        public String getLinkOperacion() {
            return linkOperacion;
        }

        public void setLinkOperacion(String linkOperacion) {
            this.linkOperacion = linkOperacion;
        }

        public String getCodTipoProgramaProd() {
            return codTipoProgramaProd;
        }

        public void setCodTipoProgramaProd(String codTipoProgramaProd) {
            this.codTipoProgramaProd = codTipoProgramaProd;
        }

        public String getCodLoteProduccion() {
            return codLoteProduccion;
        }

        public void setCodLoteProduccion(String codLoteProduccion) {
            this.codLoteProduccion = codLoteProduccion;
        }

        public String getCodPresentacion() {
            return codPresentacion;
        }

        public void setCodPresentacion(String codPresentacion) {
            this.codPresentacion = codPresentacion;
        }

        public String getIconoEstadoSimulacion() {
            return iconoEstadoSimulacion;
        }

        public void setIconoEstadoSimulacion(String iconoEstadoSimulacion) {
            this.iconoEstadoSimulacion = iconoEstadoSimulacion;
        }

        public String getTieneIconoEstadoSimulacion() {
            return tieneIconoEstadoSimulacion;
        }

        public void setTieneIconoEstadoSimulacion(String tieneIconoEstadoSimulacion) {
            this.tieneIconoEstadoSimulacion = tieneIconoEstadoSimulacion;
        }

        public String getEstiloEstado() {
            return estiloEstado;
        }

        public void setEstiloEstado(String estiloEstado) {
            this.estiloEstado = estiloEstado;
        }

        public String getConInputTextCantLoteProduccion() {
            return conInputTextCantLoteProduccion;
        }

        public void setConInputTextCantLoteProduccion(String conInputTextCantLoteProduccion) {
            this.conInputTextCantLoteProduccion = conInputTextCantLoteProduccion;
        }

        public String getCodFormulaMaestra() {
            return codFormulaMaestra;
        }

        public void setCodFormulaMaestra(String codFormulaMaestra) {
            this.codFormulaMaestra = codFormulaMaestra;
        }

        public String getInputTextCantLoteProduccionSoloLectura() {
            return inputTextCantLoteProduccionSoloLectura;
        }

        public void setInputTextCantLoteProduccionSoloLectura(String inputTextCantLoteProduccionSoloLectura) {
            this.inputTextCantLoteProduccionSoloLectura = inputTextCantLoteProduccionSoloLectura;
        }

        public String getConMateriales() {
            return conMateriales;
        }

        public void setConMateriales(String conMateriales) {
            this.conMateriales = conMateriales;
        }

        public String getCodTipoAprobacionProgramaProduccion() {
            return codTipoAprobacionProgramaProduccion;
        }

        public void setCodTipoAprobacionProgramaProduccion(String codTipoAprobacionProgramaProduccion) {
            this.codTipoAprobacionProgramaProduccion = codTipoAprobacionProgramaProduccion;
        }

        public String getNombreTipoAprobacionProgramaProduccion() {
            return nombreTipoAprobacionProgramaProduccion;
        }

        public void setNombreTipoAprobacionProgramaProduccion(String nombreTipoAprobacionProgramaProduccion) {
            this.nombreTipoAprobacionProgramaProduccion = nombreTipoAprobacionProgramaProduccion;
        }

        public void copiarAtributos(Componente componente){
        this.cantLoteProduccion=componente.cantLoteProduccion;
        this.codProgramaProd = componente.codProgramaProd;
        this.codCompProd = componente.codCompProd;
        this.nombreCompProd = componente.nombreCompProd;
        this.codMaterial = componente.codMaterial;
        this.nombreMaterial = componente.nombreMaterial;
        this.cantidadAUtilizar = componente.cantidadAUtilizar;
        this.cantidadDisponible = componente.cantidadDisponible;
        this.cantidadEnTransito = componente.cantidadEnTransito;
        this.stockMinimoMaterial = componente.stockMinimoMaterial;
        this.cantLoteProduccion = componente.cantLoteProduccion;
        this.codTipoProgramaProd = componente.codTipoProgramaProd;
        this.nombreTipoProgramaProd = componente.nombreTipoProgramaProd;
        this.categoria = componente.categoria;
        this.conCheck = componente.conCheck;
        this.seleccionadoCheck = componente.seleccionadoCheck;
        this.cantidadAUtilizarRef = componente.cantidadAUtilizarRef;
        this.cantidadDisponibleRef = componente.cantidadDisponibleRef;
        this.cantidadEnTransitoRef = componente.cantidadEnTransitoRef;
        this.cantLoteProduccionRef = componente.cantLoteProduccionRef;
        this.nombreTipoProgramaProdRef = componente.nombreTipoProgramaProdRef;
        this.linkOperacion = componente.linkOperacion;
        this.codLoteProduccion = componente.codLoteProduccion;
        this.codPresentacion = componente.codPresentacion;
        this.iconoEstadoSimulacion = componente.iconoEstadoSimulacion;
        this.tieneIconoEstadoSimulacion = componente.tieneIconoEstadoSimulacion;
        this.estiloEstado = componente.estiloEstado;
        this.conInputTextCantLoteProduccion = componente.conInputTextCantLoteProduccion;
        this.inputTextCantLoteProduccionSoloLectura = componente.inputTextCantLoteProduccionSoloLectura;
        this.codFormulaMaestra = componente.codFormulaMaestra;
        this.conMateriales = componente.conMateriales;
        this.codTipoAprobacionProgramaProduccion=componente.codTipoAprobacionProgramaProduccion;
        this.nombreTipoAprobacionProgramaProduccion=componente.nombreTipoAprobacionProgramaProduccion;

        }
    }
    public class HorasMaquinaHombre extends AbstractBean{
        Maquinaria maquinaria = new Maquinaria();
        Double horasMaquina = 0.0;
        Double horasHombre = 0.0;
        Double horasHDisponible = 0.0;
        Double horasMDisponible = 0.0;

        public Double getHorasHDisponible() {
            return horasHDisponible;
        }

        public void setHorasHDisponible(Double horasHDisponible) {
            this.horasHDisponible = horasHDisponible;
        }

        public Double getHorasHombre() {
            return horasHombre;
        }

        public void setHorasHombre(Double horasHombre) {
            this.horasHombre = horasHombre;
        }

        public Double getHorasMDisponible() {
            return horasMDisponible;
        }

        public void setHorasMDisponible(Double horasMDisponible) {
            this.horasMDisponible = horasMDisponible;
        }

        public Double getHorasMaquina() {
            return horasMaquina;
        }

        public void setHorasMaquina(Double horasMaquina) {
            this.horasMaquina = horasMaquina;
        }

        public Maquinaria getMaquinaria() {
            return maquinaria;
        }

        public void setMaquinaria(Maquinaria maquinaria) {
            this.maquinaria = maquinaria;
        }

        

        
    }
    private Connection con;
    private ProgramaProduccion itemProgramaProduccion;
    private ProgramaProduccion subItemProgramaProduccion;
    private String codProgramaProduccion;
    private List<Componente> componentesList = new ArrayList<Componente>();
    private Componente itemComponente;
    private Componente subItemComponente;
    private HtmlDataTable componentesDataTable;
    private HtmlDataTable componentesConMaterialesDataTable;
    private Componente seleccionadoComponente;
    private Componente iteraComponente;
    NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
    DecimalFormat formato = (DecimalFormat) numeroformato;
    NumberFormat numeroformatoEntero = NumberFormat.getNumberInstance(Locale.ENGLISH);
    DecimalFormat formatoEntero = (DecimalFormat) numeroformatoEntero;
    private transient UIInput alert;
    private List<Componente> componentesNoSePuedenProducirList = new ArrayList<Componente>();
    private HtmlDataTable componentesNoSePuedenProducirDataTable;
    private List<Componente> componentesSiSePuedenProducirList = new ArrayList<Componente>();
    private HtmlDataTable componentesSiSePuedenProducirDataTable;
    private String mensajes = "";
    private String componenteIdFocus = "";
    private List<Componente> materialesFaltantesList=new ArrayList<Componente>();
    private List<Componente> componentesConMaterialesList=new ArrayList<Componente>();
    private Date fechaLote;
    SimpleDateFormat fechaFormat=new SimpleDateFormat("yyyy/MM/dd");
    List programaProduccionList = new ArrayList();
    HtmlDataTable programaProduccionDataTable = new HtmlDataTable();
    List programaProduccionDetalleList = new ArrayList();
    HtmlDataTable programaProduccionDetalleDataTable = new HtmlDataTable();
    List programaProduccionProductosPresentacionesList = new ArrayList();
    HtmlDataTable programaProduccionProductosPresentacionesDataTable = new HtmlDataTable();
    /** Creates a new instance of ManagedProgramaProduccionVerificarProducto */
    List horasHombreMaquinaList = new ArrayList();
    public ManagedProgramaProduccionVerificarProducto() {
        this.initialize();
    }

    public List<Componente> getComponentesList() {
        return componentesList;
    }

    public void setComponentesList(List<Componente> componentesList) {
        this.componentesList = componentesList;
    }

    public HtmlDataTable getComponentesDataTable() {
        return componentesDataTable;
    }

    public void setComponentesDataTable(HtmlDataTable componentesDataTable) {
        this.componentesDataTable = componentesDataTable;
    }

    public UIInput getAlert() {
        return alert;
    }

    public void setAlert(UIInput alert) {
        this.alert = alert;
    }

    public HtmlDataTable getComponentesNoSePuedenProducirDataTable() {
        return componentesNoSePuedenProducirDataTable;
    }

    public void setComponentesNoSePuedenProducirDataTable(HtmlDataTable componentesNoSePuedenProducirDataTable) {
        this.componentesNoSePuedenProducirDataTable = componentesNoSePuedenProducirDataTable;
    }

    public List<Componente> getComponentesNoSePuedenProducirList() {
        return componentesNoSePuedenProducirList;
    }

    public void setComponentesNoSePuedenProducirList(List<Componente> componentesNoSePuedenProducirList) {
        this.componentesNoSePuedenProducirList = componentesNoSePuedenProducirList;
    }

    public HtmlDataTable getComponentesSiSePuedenProducirDataTable() {
        return componentesSiSePuedenProducirDataTable;
    }

    public void setComponentesSiSePuedenProducirDataTable(HtmlDataTable componentesSiSePuedenProducirDataTable) {
        this.componentesSiSePuedenProducirDataTable = componentesSiSePuedenProducirDataTable;
    }

    public List<Componente> getComponentesSiSePuedenProducirList() {
        return componentesSiSePuedenProducirList;
    }

    public void setComponentesSiSePuedenProducirList(List<Componente> componentesSiSePuedenProducirList) {
        this.componentesSiSePuedenProducirList = componentesSiSePuedenProducirList;
    }

    public String getMensajes() {
        return mensajes;
    }

    public void setMensajes(String mensajes) {
        this.mensajes = mensajes;
    }

    public String getComponenteIdFocus() {
        return componenteIdFocus;
    }

    public void setComponenteIdFocus(String componenteIdFocus) {
        this.componenteIdFocus = componenteIdFocus;
    }

    public List<Componente> getMaterialesFaltantesList() {
        return materialesFaltantesList;
    }

    public void setMaterialesFaltantesList(List<Componente> materialesFaltantesList) {
        this.materialesFaltantesList = materialesFaltantesList;
    }

    public Componente getSeleccionadoComponente() {
        return seleccionadoComponente;
    }

    public void setSeleccionadoComponente(Componente seleccionadoComponente) {
        this.seleccionadoComponente = seleccionadoComponente;
    }

    public List<Componente> getComponentesConMaterialesList() {
        return componentesConMaterialesList;
    }

    public void setComponentesConMaterialesList(List<Componente> componentesConMaterialesList) {
        this.componentesConMaterialesList = componentesConMaterialesList;
    }

    public HtmlDataTable getComponentesConMaterialesDataTable() {
        return componentesConMaterialesDataTable;
    }

    public void setComponentesConMaterialesDataTable(HtmlDataTable componentesConMaterialesDataTable) {
        this.componentesConMaterialesDataTable = componentesConMaterialesDataTable;
    }

    public Date getFechaLote() {
        return fechaLote;
    }

    public void setFechaLote(Date fechaLote) {
        this.fechaLote = fechaLote;
    }

    public List getProgramaProduccionList() {
        return programaProduccionList;
    }

    public void setProgramaProduccionList(List programaProduccionList) {
        this.programaProduccionList = programaProduccionList;
    }

    public HtmlDataTable getProgramaProduccionDataTable() {
        return programaProduccionDataTable;
    }

    public void setProgramaProduccionDataTable(HtmlDataTable programaProduccionDataTable) {
        this.programaProduccionDataTable = programaProduccionDataTable;
    }

    public List getProgramaProduccionDetalleList() {
        return programaProduccionDetalleList;
    }

    public void setProgramaProduccionDetalleList(List programaProduccionDetalleList) {
        this.programaProduccionDetalleList = programaProduccionDetalleList;
    }

    public HtmlDataTable getProgramaProduccionDetalleDataTable() {
        return programaProduccionDetalleDataTable;
    }

    public void setProgramaProduccionDetalleDataTable(HtmlDataTable programaProduccionDetalleDataTable) {
        this.programaProduccionDetalleDataTable = programaProduccionDetalleDataTable;
    }

    public HtmlDataTable getProgramaProduccionProductosPresentacionesDataTable() {
        return programaProduccionProductosPresentacionesDataTable;
    }

    public void setProgramaProduccionProductosPresentacionesDataTable(HtmlDataTable programaProduccionProductosPresentacionesDataTable) {
        this.programaProduccionProductosPresentacionesDataTable = programaProduccionProductosPresentacionesDataTable;
    }

    public List getProgramaProduccionProductosPresentacionesList() {
        return programaProduccionProductosPresentacionesList;
    }

    public void setProgramaProduccionProductosPresentacionesList(List programaProduccionProductosPresentacionesList) {
        this.programaProduccionProductosPresentacionesList = programaProduccionProductosPresentacionesList;
    }

    public List getHorasHombreMaquinaList() {
        return horasHombreMaquinaList;
    }

    public void setHorasHombreMaquinaList(List horasHombreMaquinaList) {
        this.horasHombreMaquinaList = horasHombreMaquinaList;
    }

    
    
    //metodo init cuando los materiales dependen de el componente
    void init() {
        try {


            //primero listado de productos que tienen espera de materiales

            System.out.println("entro al init de programa produccion verificar producto");
            codProgramaProduccion = "28";
            HttpServletRequest request = (HttpServletRequest) FacesContext.getCurrentInstance().getExternalContext().getRequest();
            if (request.getParameter("codProgramaPeriodo") != null) {
                codProgramaProduccion = request.getParameter("codProgramaPeriodo");
            }
            
            fechaFormat=new SimpleDateFormat("yyyy/MM/dd");
            
            
            formato.applyPattern("#,###.##;(#,###.##)");//("#,##0.00");         

            con = (Util.openConnection(con));
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            String consulta = "";
            //se lista los componentes a fabricar para programa_produccion


            consulta = " SELECT PP.COD_PROGRAMA_PROD,CP.COD_COMPPROD, CP.nombre_prod_semiterminado,PP.COD_LOTE_PRODUCCION,PP.CANT_LOTE_PRODUCCION, PP.COD_TIPO_PROGRAMA_PROD ,TPP.NOMBRE_TIPO_PROGRAMA_PROD, " +
                    " isnull((select ca.NOMBRE_CATEGORIACOMPPROD from  CATEGORIAS_COMPPROD CA WHERE CA.COD_CATEGORIACOMPPROD = CP.COD_CATEGORIACOMPPROD),'') AS CATEGORIA, PP.COD_PRESENTACION " +
                    " FROM PROGRAMA_PRODUCCION PP INNER JOIN COMPONENTES_PROD CP ON PP.COD_COMPPROD=CP.COD_COMPPROD " +
                    " INNER JOIN TIPOS_PROGRAMA_PRODUCCION TPP ON TPP.COD_TIPO_PROGRAMA_PROD = PP.COD_TIPO_PROGRAMA_PROD " +
                    " WHERE PP.COD_PROGRAMA_PROD='" + codProgramaProduccion + "' AND PP.COD_ESTADO_PROGRAMA=4" +
                    " ORDER BY CP.nombre_prod_semiterminado ASC";

            ResultSet rs = st.executeQuery(consulta);
            //System.out.println("el query de cabecera para programa produccion" + consulta);
            rs.last();
            int filas = rs.getRow();
            //programaProduccionList.clear();
            rs.first();
            componentesList.clear();
            for (int i = 0; i < filas; i++) {
                //se debe verificar que los materiales de un producto esten en transito

                itemComponente = new Componente();
                itemComponente.setCodProgramaProd(rs.getString("COD_PROGRAMA_PROD"));
                itemComponente.setCodCompProd(rs.getString("COD_COMPPROD"));
                itemComponente.setNombreCompProd(rs.getString("nombre_prod_semiterminado"));
                itemComponente.setCodLoteProduccion(rs.getString("COD_LOTE_PRODUCCION"));
                itemComponente.setCantLoteProduccion(rs.getString("CANT_LOTE_PRODUCCION"));
                itemComponente.setNombreTipoProgramaProd(rs.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                itemComponente.setCategoria(rs.getString("CATEGORIA"));
                itemComponente.setCodTipoProgramaProd(rs.getString("COD_TIPO_PROGRAMA_PROD"));
                itemComponente.setCodPresentacion(rs.getString("COD_PRESENTACION") == null ? "0" : rs.getString("COD_PRESENTACION"));

                itemComponente.setLinkOperacion("Producir");


                //if (this.tieneMaterialesEnTransito(itemComponente)) {
                if (this.tieneDisponibleMenorQueUtilizar(itemComponente)) {
                    itemComponente.setConCheck("true");

                    componentesList.add(itemComponente);
                    //llenado del detalle de materiales por cada componente
                    this.materialesComponente(itemComponente);
                }
                //}
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

    public void materialesComponente(Componente itemComponente) {
        try {
            con = (Util.openConnection(con));
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            Componente filaComponente = new Componente();

            String consulta = "";

            consulta = " SELECT EM.COD_PROGRAMA_PRODUCCION,EM.COD_MATERIAL,EM.COD_UNIDAD_MEDIDA,EM.CANTIDAD_A_UTILIZAR,EM.CANTIDAD_DISPONIBLE, EM.CANTIDAD_TRANSITO " +
                    "  FROM EXPLOSION_MATERIALES EM " +
                    " WHERE EM.COD_PROGRAMA_PRODUCCION='" + codProgramaProduccion + "'" +
                    " AND EM.COD_MATERIAL IN ( SELECT PPD.COD_MATERIAL FROM PROGRAMA_PRODUCCION_DETALLE PPD " +
                    " WHERE PPD.COD_COMPPROD = '" + itemComponente.getCodCompProd() + "' " +
                    " AND PPD.COD_PROGRAMA_PROD='" + codProgramaProduccion + "' ) " +
                    " AND EM.CANTIDAD_DISPONIBLE<EM.CANTIDAD_A_UTILIZAR ";

            consulta = " SELECT EM.COD_MATERIAL,M.NOMBRE_MATERIAL,EM.CANTIDAD_A_UTILIZAR,EM.CANTIDAD_DISPONIBLE, EM.CANTIDAD_TRANSITO,M.STOCK_MINIMO_MATERIAL " +
                    " FROM EXPLOSION_MATERIALES EM  INNER JOIN MATERIALES M ON EM.COD_MATERIAL=M.COD_MATERIAL " +
                    " WHERE EM.COD_PROGRAMA_PRODUCCION='" + codProgramaProduccion + "' " +
                    " AND EM.COD_MATERIAL IN (SELECT PPD.COD_MATERIAL FROM PROGRAMA_PRODUCCION_DETALLE PPD  " +
                    " WHERE PPD.COD_COMPPROD = '" + itemComponente.getCodCompProd() + "'  AND PPD.COD_PROGRAMA_PROD='" + codProgramaProduccion + "' ) ";

            consulta = " SELECT  PPD.COD_COMPPROD,EM.COD_MATERIAL,M.NOMBRE_MATERIAL,FMDMP.CANTIDAD,EM.CANTIDAD_DISPONIBLE, EM.CANTIDAD_TRANSITO,M.STOCK_MINIMO_MATERIAL  " +
                    " FROM PROGRAMA_PRODUCCION PP INNER JOIN PROGRAMA_PRODUCCION_DETALLE PPD ON PPD.COD_PROGRAMA_PROD=PP.COD_PROGRAMA_PROD AND PPD.COD_COMPPROD=PP.COD_COMPPROD " +
                    " INNER JOIN FORMULA_MAESTRA FM ON FM.COD_FORMULA_MAESTRA=PP.COD_FORMULA_MAESTRA AND FM.COD_COMPPROD=PP.COD_COMPPROD " +
                    " INNER JOIN FORMULA_MAESTRA_DETALLE_MP FMDMP ON FMDMP.COD_FORMULA_MAESTRA=FM.COD_FORMULA_MAESTRA AND FMDMP.CANTIDAD=PPD.CANTIDAD " +
                    " INNER JOIN EXPLOSION_MATERIALES EM ON EM.COD_PROGRAMA_PRODUCCION=PP.COD_PROGRAMA_PROD " +
                    " AND EM.COD_MATERIAL=PPD.COD_MATERIAL AND EM.COD_MATERIAL=FMDMP.COD_MATERIAL " +
                    " INNER JOIN MATERIALES M ON M.COD_MATERIAL=EM.COD_MATERIAL " +
                    " WHERE PP.COD_PROGRAMA_PROD='" + codProgramaProduccion + "'  AND PP.COD_ESTADO_PROGRAMA='4' AND PP.CANT_LOTE_PRODUCCION='" + itemComponente.getCantLoteProduccion() + "' AND PPD.COD_COMPPROD='" + itemComponente.getCodCompProd() + "' " +
                    " AND PP.COD_TIPO_PROGRAMA_PROD='" + itemComponente.getCodTipoProgramaProd() + "' " +
                    " AND PP.COD_LOTE_PRODUCCION = '" + itemComponente.getCodLoteProduccion() + "' UNION ALL " +
                    " SELECT  PPD.COD_COMPPROD,EM.COD_MATERIAL,M.NOMBRE_MATERIAL,FMDMP.CANTIDAD,EM.CANTIDAD_DISPONIBLE, EM.CANTIDAD_TRANSITO,M.STOCK_MINIMO_MATERIAL  " +
                    " FROM PROGRAMA_PRODUCCION PP INNER JOIN PROGRAMA_PRODUCCION_DETALLE PPD ON PPD.COD_PROGRAMA_PROD=PP.COD_PROGRAMA_PROD AND PPD.COD_COMPPROD=PP.COD_COMPPROD " +
                    " INNER JOIN FORMULA_MAESTRA FM ON FM.COD_FORMULA_MAESTRA=PP.COD_FORMULA_MAESTRA AND FM.COD_COMPPROD=PP.COD_COMPPROD " +
                    " INNER JOIN FORMULA_MAESTRA_DETALLE_EP FMDMP ON FMDMP.COD_FORMULA_MAESTRA=FM.COD_FORMULA_MAESTRA AND FMDMP.CANTIDAD=PPD.CANTIDAD " +
                    " INNER JOIN EXPLOSION_MATERIALES EM ON EM.COD_PROGRAMA_PRODUCCION=PP.COD_PROGRAMA_PROD " +
                    " AND EM.COD_MATERIAL=PPD.COD_MATERIAL AND EM.COD_MATERIAL=FMDMP.COD_MATERIAL " +
                    " INNER JOIN MATERIALES M ON M.COD_MATERIAL=EM.COD_MATERIAL " +
                    " WHERE PP.COD_PROGRAMA_PROD='" + codProgramaProduccion + "' AND PP.COD_ESTADO_PROGRAMA='4' AND PP.CANT_LOTE_PRODUCCION='" + itemComponente.getCantLoteProduccion() + "' AND PPD.COD_COMPPROD='" + itemComponente.getCodCompProd() + "' " +
                    " AND PP.COD_TIPO_PROGRAMA_PROD='" + itemComponente.getCodTipoProgramaProd() + "' " +
                    " AND PP.COD_LOTE_PRODUCCION = '" + itemComponente.getCodLoteProduccion() + "' " +
                    " AND FMDMP.COD_PRESENTACION_PRIMARIA = '" + itemComponente.getCodPresentacion() + "' UNION ALL " +
                    " SELECT  PPD.COD_COMPPROD,EM.COD_MATERIAL,M.NOMBRE_MATERIAL,FMDMP.CANTIDAD,EM.CANTIDAD_DISPONIBLE, EM.CANTIDAD_TRANSITO,M.STOCK_MINIMO_MATERIAL " +
                    " FROM PROGRAMA_PRODUCCION PP INNER JOIN PROGRAMA_PRODUCCION_DETALLE PPD ON PPD.COD_PROGRAMA_PROD=PP.COD_PROGRAMA_PROD AND PPD.COD_COMPPROD=PP.COD_COMPPROD " +
                    " INNER JOIN FORMULA_MAESTRA FM ON FM.COD_FORMULA_MAESTRA=PP.COD_FORMULA_MAESTRA AND FM.COD_COMPPROD=PP.COD_COMPPROD " +
                    " INNER JOIN FORMULA_MAESTRA_DETALLE_ES FMDMP ON FMDMP.COD_FORMULA_MAESTRA=FM.COD_FORMULA_MAESTRA AND FMDMP.CANTIDAD=PPD.CANTIDAD " +
                    " INNER JOIN EXPLOSION_MATERIALES EM ON EM.COD_PROGRAMA_PRODUCCION=PP.COD_PROGRAMA_PROD  " +
                    " AND EM.COD_MATERIAL=PPD.COD_MATERIAL AND EM.COD_MATERIAL=FMDMP.COD_MATERIAL " +
                    " INNER JOIN MATERIALES M ON M.COD_MATERIAL=EM.COD_MATERIAL " +
                    " WHERE PP.COD_PROGRAMA_PROD='" + codProgramaProduccion + "' AND PP.COD_ESTADO_PROGRAMA='4' AND PP.CANT_LOTE_PRODUCCION='" + itemComponente.getCantLoteProduccion() + "' AND PPD.COD_COMPPROD='" + itemComponente.getCodCompProd() + "'" +
                    " AND PP.COD_TIPO_PROGRAMA_PROD='" + itemComponente.getCodTipoProgramaProd() + "' " +
                    " AND PP.COD_LOTE_PRODUCCION = '" + itemComponente.getCodLoteProduccion() + "' " +
                    " AND FMDMP.COD_PRESENTACION_PRODUCTO = '" + itemComponente.getCodPresentacion() + "' ";

            consulta = "SELECT 'MP',EM.COD_MATERIAL,M.NOMBRE_MATERIAL,FMDMP.CANTIDAD,EM.CANTIDAD_DISPONIBLE, EM.CANTIDAD_TRANSITO,M.STOCK_MINIMO_MATERIAL " +
                    " FROM PROGRAMA_PRODUCCION PP INNER JOIN FORMULA_MAESTRA FM ON FM.COD_FORMULA_MAESTRA=PP.COD_FORMULA_MAESTRA AND FM.COD_COMPPROD=PP.COD_COMPPROD " +
                    " INNER JOIN FORMULA_MAESTRA_DETALLE_MP FMDMP ON FMDMP.COD_FORMULA_MAESTRA=FM.COD_FORMULA_MAESTRA " +
                    " INNER JOIN EXPLOSION_MATERIALES EM ON EM.COD_PROGRAMA_PRODUCCION=PP.COD_PROGRAMA_PROD  " +
                    " AND EM.COD_MATERIAL=FMDMP.COD_MATERIAL INNER JOIN MATERIALES M ON M.COD_MATERIAL=EM.COD_MATERIAL " +
                    " WHERE PP.COD_PROGRAMA_PROD='" + codProgramaProduccion + "' AND PP.COD_ESTADO_PROGRAMA='4' " +
                    " AND EM.COD_MATERIAL IN (SELECT PPD.COD_MATERIAL FROM  PROGRAMA_PRODUCCION_DETALLE PPD  " +
                    " WHERE PPD.COD_PROGRAMA_PROD=PP.COD_PROGRAMA_PROD AND PPD.COD_COMPPROD=PP.COD_COMPPROD AND PPD.COD_COMPPROD='" + itemComponente.getCodCompProd() + "') " +
                    " AND PP.COD_COMPPROD='" + itemComponente.getCodCompProd() + "' " +
                    " AND PP.CANT_LOTE_PRODUCCION='" + itemComponente.getCantLoteProduccion() + "' " +
                    " AND PP.COD_TIPO_PROGRAMA_PROD='" + itemComponente.getCodTipoProgramaProd() + "' " +
                    " AND PP.COD_LOTE_PRODUCCION = '" + itemComponente.getCodLoteProduccion() + "'  UNION ALL " +
                    " SELECT 'ES',EM.COD_MATERIAL,M.NOMBRE_MATERIAL,FMDMP.CANTIDAD,EM.CANTIDAD_DISPONIBLE, EM.CANTIDAD_TRANSITO,M.STOCK_MINIMO_MATERIAL  " +
                    " FROM PROGRAMA_PRODUCCION PP " +
                    " INNER JOIN FORMULA_MAESTRA FM ON FM.COD_FORMULA_MAESTRA=PP.COD_FORMULA_MAESTRA AND FM.COD_COMPPROD=PP.COD_COMPPROD " +
                    " INNER JOIN FORMULA_MAESTRA_DETALLE_ES FMDMP ON FMDMP.COD_FORMULA_MAESTRA=FM.COD_FORMULA_MAESTRA " +
                    " INNER JOIN EXPLOSION_MATERIALES EM ON EM.COD_PROGRAMA_PRODUCCION=PP.COD_PROGRAMA_PROD  " +
                    " AND EM.COD_MATERIAL=FMDMP.COD_MATERIAL INNER JOIN MATERIALES M ON M.COD_MATERIAL=EM.COD_MATERIAL " +
                    " WHERE PP.COD_PROGRAMA_PROD='" + codProgramaProduccion + "' AND PP.COD_ESTADO_PROGRAMA='4' " +
                    " AND EM.COD_MATERIAL IN (SELECT PPD.COD_MATERIAL FROM  PROGRAMA_PRODUCCION_DETALLE PPD " +
                    " WHERE PPD.COD_PROGRAMA_PROD=PP.COD_PROGRAMA_PROD AND PPD.COD_COMPPROD=PP.COD_COMPPROD AND PPD.COD_COMPPROD='" + itemComponente.getCodCompProd() + "') " +
                    " AND PP.COD_COMPPROD='" + itemComponente.getCodCompProd() + "' " +
                    " AND PP.CANT_LOTE_PRODUCCION='" + itemComponente.getCantLoteProduccion() + "' " +
                    " AND PP.COD_TIPO_PROGRAMA_PROD='" + itemComponente.getCodTipoProgramaProd() + "' " +
                    " AND PP.COD_LOTE_PRODUCCION = '" + itemComponente.getCodLoteProduccion() + "' " +
                    " AND FMDMP.COD_PRESENTACION_PRODUCTO = '" + itemComponente.getCodPresentacion() + "' UNION ALL  " +
                    " SELECT 'EP',EM.COD_MATERIAL,M.NOMBRE_MATERIAL,FMDMP.CANTIDAD,EM.CANTIDAD_DISPONIBLE, EM.CANTIDAD_TRANSITO,M.STOCK_MINIMO_MATERIAL  " +
                    " FROM PROGRAMA_PRODUCCION PP  INNER JOIN FORMULA_MAESTRA FM ON FM.COD_FORMULA_MAESTRA=PP.COD_FORMULA_MAESTRA AND FM.COD_COMPPROD=PP.COD_COMPPROD  " +
                    " INNER JOIN FORMULA_MAESTRA_DETALLE_EP FMDMP ON FMDMP.COD_FORMULA_MAESTRA=FM.COD_FORMULA_MAESTRA " +
                    " INNER JOIN EXPLOSION_MATERIALES EM ON EM.COD_PROGRAMA_PRODUCCION=PP.COD_PROGRAMA_PROD  " +
                    " AND EM.COD_MATERIAL=FMDMP.COD_MATERIAL INNER JOIN MATERIALES M ON M.COD_MATERIAL=EM.COD_MATERIAL " +
                    " WHERE PP.COD_PROGRAMA_PROD='" + codProgramaProduccion + "' AND PP.COD_ESTADO_PROGRAMA='4'" +
                    " AND EM.COD_MATERIAL IN (SELECT PPD.COD_MATERIAL FROM  PROGRAMA_PRODUCCION_DETALLE PPD  " +
                    " WHERE PPD.COD_PROGRAMA_PROD=PP.COD_PROGRAMA_PROD AND PPD.COD_COMPPROD=PP.COD_COMPPROD AND PPD.COD_COMPPROD='" + itemComponente.getCodCompProd() + "') " +
                    " AND PP.COD_COMPPROD='" + itemComponente.getCodCompProd() + "' " +
                    " AND PP.CANT_LOTE_PRODUCCION='" + itemComponente.getCantLoteProduccion() + "' " +
                    " AND PP.COD_TIPO_PROGRAMA_PROD='" + itemComponente.getCodTipoProgramaProd() + "' " +
                    " AND PP.COD_LOTE_PRODUCCION = '" + itemComponente.getCodLoteProduccion() + "' " +
                    " AND FMDMP.COD_PRESENTACION_PRIMARIA = '" + itemComponente.getCodPresentacion() + "' ";

            System.out.println("la consulta que se ejecutara al principio para el detalle de materiales " + consulta);

            ResultSet rs = st.executeQuery(consulta);

            while (rs.next()) {
                filaComponente = new Componente();
                filaComponente.setCodProgramaProd(itemComponente.getCodProgramaProd());
                filaComponente.setCodCompProd(itemComponente.getCodCompProd());
                filaComponente.setCodMaterial(rs.getString("COD_MATERIAL"));
                filaComponente.setNombreMaterial(rs.getString("NOMBRE_MATERIAL"));
                filaComponente.setCantidadAUtilizar(formato.format(rs.getDouble("CANTIDAD"))); //se colocan en los datos de Referencia
                filaComponente.setCantidadDisponible(formato.format(rs.getDouble("CANTIDAD_DISPONIBLE")));
                filaComponente.setCantidadEnTransito(formato.format(rs.getDouble("CANTIDAD_TRANSITO")));
                filaComponente.setCantidadAUtilizarRef(formato.format(rs.getDouble("CANTIDAD"))); //se colocan en los datos de Referencia
                filaComponente.setCantidadDisponibleRef(formato.format(rs.getDouble("CANTIDAD_DISPONIBLE")));
                filaComponente.setCantidadEnTransitoRef(formato.format(rs.getDouble("CANTIDAD_TRANSITO")));
                filaComponente.setStockMinimoMaterial(String.valueOf(rs.getDouble("STOCK_MINIMO_MATERIAL")));
                filaComponente.setNombreTipoProgramaProdRef(itemComponente.getNombreTipoProgramaProd());
                filaComponente.setCantLoteProduccionRef(itemComponente.getCantLoteProduccion());
                filaComponente.setTieneIconoEstadoSimulacion("false");
                this.colocaEstiloEstado(filaComponente);
                componentesList.add(filaComponente);
            }

            if (rs != null) {
                rs.close();
                st.close();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    public void colocaEstiloEstado(Componente componente) {
        Double cantidadDisponible = Double.parseDouble(componente.getCantidadDisponible() == null ? "0" : componente.getCantidadDisponible().replace(",",""));
        Double cantidadTransito = Double.parseDouble(componente.getCantidadEnTransito() == null ? "0" : componente.getCantidadEnTransito().replace(",",""));
        Double cantidadAUtilizar = Double.parseDouble(componente.getCantidadAUtilizar() == null ? "0" : componente.getCantidadAUtilizar().replace(",",""));

        try {
            if (cantidadDisponible >= cantidadAUtilizar) {
                componente.setEstiloEstado("background-color: #EFFBEF;"); //alcanza
            } else if ((cantidadDisponible + cantidadTransito) >= cantidadAUtilizar) { //alcanza
                componente.setEstiloEstado("background-color: #F7F8E0;");
            } else if ((cantidadDisponible + cantidadTransito) < cantidadAUtilizar) { //alcanza
                componente.setEstiloEstado("background-color: #FBEFEF;");
            }
//(cantidadDisponible + cantidadTransito) >= cantidadAUtilizar
        // rojo #FBEFEF
        //verde #EFFBEF
        //naranja #FBF5EF
//background-color: #F6E3CE;
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void recorreMaterialesColocaEstilo() {

        Componente iteraComponentes;
        try {
            for (int i = 0; i < componentesDataTable.getRowCount(); i++) {
                // solo los registros con el codComponente
                componentesDataTable.setRowIndex(i);
                iteraComponentes = (Componente) componentesDataTable.getRowData();
                this.colocaEstiloEstado(iteraComponentes);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void check_change(ValueChangeEvent event) {
        try {
            //System.out.println("entro evento check" + event.getNewValue());
            seleccionadoComponente = new Componente();
            seleccionadoComponente = (Componente) componentesDataTable.getRowData();
            if (event.getNewValue().toString().equals("true")) {
                if (this.alcanzaMateriales(seleccionadoComponente) == true) {
                    //si alcanza restar
                    System.out.println("alcanza materiales");
                    this.restaCantidadMateriales(seleccionadoComponente);
                } else {
                    //si no alcanza materiales colocar el check en false                    
                    seleccionadoComponente.setSeleccionadoCheck("false");

                }
            } else {
                //se debe devolver las cantidades
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String seleccionaComponente() {
        try {
            seleccionadoComponente = new Componente();
            seleccionadoComponente = (Componente) componentesDataTable.getRowData();
            if (seleccionadoComponente.getLinkOperacion().equals("Producir")) {
                if (this.alcanzaMateriales(seleccionadoComponente) == true) {
                    //si alcanza restar
                    System.out.println("alcanza materiales");
                    this.restaCantidadMateriales(seleccionadoComponente);
                    seleccionadoComponente.setLinkOperacion("No Producir");
                } else {
                    this.mensaje("no existen materiales suficientes para el componente seleccionado");
                }
            } else if (seleccionadoComponente.getLinkOperacion().equals("No Producir")) {
                System.out.println("entro en devolver");
                //se debe devolver las cantidades
                this.devuelveCantidadesMateriales(seleccionadoComponente);
                seleccionadoComponente.setLinkOperacion("Producir");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void retornaCantidades() {
        try {
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void mensaje(String mensajes) {
        try {
            FacesContext facesContext = FacesContext.getCurrentInstance();
            facesContext.addMessage(alert.getClientId(facesContext),
                    new FacesMessage(FacesMessage.SEVERITY_INFO, mensajes, ""));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void devuelveCantidadesMateriales(Componente seleccionadoComponente) {
        try {
            //iterar el datatable y encontrar los materiales para preguntar si todos alcanzan
            Double selecCantidadDisponible = 0.0d;
            Double selecCantidadAUtilizar = 0.0d;
            Double selecCantidadEnTransito = 0.0d;

            Double iteraCantidadDisponible = 0.0d;
            Double iteraCantidadAUtilizar = 0.0d;
            Double iteraCantidadEnTransito = 0.0d;

            Componente iteraComponentes;
            Componente hallaComponente;

            boolean esElComponente = false;

            // recorrer los materiales del componente
            //recorrer el resto de los materiales

            for (int i = 0; i < componentesDataTable.getRowCount(); i++) {
                // solo los materiales con el codComponente
                componentesDataTable.setRowIndex(i);
                hallaComponente = (Componente) componentesDataTable.getRowData();
                //verificar que es el componente con el lote y tipo mercaderia iguales


                if (hallaComponente.getCodCompProd().equals(seleccionadoComponente.getCodCompProd()) && !hallaComponente.getNombreMaterial().equals("") && hallaComponente.getCantLoteProduccionRef().equals(seleccionadoComponente.getCantLoteProduccion()) && hallaComponente.getNombreTipoProgramaProdRef().equals(seleccionadoComponente.getNombreTipoProgramaProd())) {

                    //obtenemos los datos del material
                    //luego restar
                    selecCantidadDisponible = Double.parseDouble(hallaComponente.getCantidadDisponible().replace(",",""));
                    selecCantidadAUtilizar = Double.parseDouble(hallaComponente.getCantidadAUtilizar().replace(",",""));
                    selecCantidadEnTransito = Double.parseDouble(hallaComponente.getCantidadEnTransito().replace(",",""));

                    for (int j = 0; j < componentesDataTable.getRowCount(); j++) {
                        componentesDataTable.setRowIndex(j);
                        iteraComponentes = (Componente) componentesDataTable.getRowData();
                        if (!iteraComponentes.getNombreMaterial().equals("") && iteraComponentes.getCodMaterial().equals(hallaComponente.getCodMaterial())) {

                            iteraCantidadDisponible = Double.parseDouble(iteraComponentes.getCantidadDisponible().replace(",",""));
                            iteraCantidadAUtilizar = Double.parseDouble(iteraComponentes.getCantidadAUtilizar().replace(",",""));
                            iteraCantidadEnTransito = Double.parseDouble(iteraComponentes.getCantidadEnTransito().replace(",",""));
                            //restar las cantidades
                            //ver si el disponible alcanza
                            //restar la cantidad del componente seleccionado al resto de los materiales
                            //preguntar si es el componente o si es del restante
//                            System.out.println("iteraCantidadDisponible " + iteraCantidadDisponible +
//                                    " iteraCantidadAUtilizar " + iteraCantidadAUtilizar +
//                                    " iteraCantidadEnTransito " + iteraCantidadEnTransito);

                            //preguntar si la cantidad disponible es mayor que cero


                            if (iteraCantidadDisponible > 0) {

                                //el disponible alcanza entonces restar de disponible
                                Double cantidadDisponible = iteraCantidadDisponible + selecCantidadAUtilizar;
                                iteraComponentes.setCantidadDisponible(formato.format(cantidadDisponible));

//                                System.out.println(" cantidadDisponibleRestante  " + cantidadDisponible.toString());

                            } else {
                                //la cantidad disponible es igual a cero
                                //sumar en transito y a utilizar y si sobrepasa en transito ref pasarlo a disponible



                                Double TransitoRef = Double.parseDouble(iteraComponentes.getCantidadEnTransitoRef().replace(",",""));


                                Double cantidadTransito = iteraCantidadEnTransito + selecCantidadAUtilizar;
                                if (cantidadTransito > TransitoRef) {
                                    iteraComponentes.setCantidadEnTransito(formato.format(Double.parseDouble(iteraComponentes.getCantidadEnTransitoRef().replace(",",""))));
                                    iteraComponentes.setCantidadDisponible(formato.format(cantidadTransito - TransitoRef));
                                } else {
                                    iteraComponentes.setCantidadEnTransito(formato.format(cantidadTransito));
                                }

                            }

                        }
                    }

                }
            //primero verificar si le alcanza

            //se debe verificar y restar si alcanza
            // 1:disponible es mayor a cantidad a utilizar
            // 2: disponible+en Transito es mayor a cantidad a utilizar
            //primero analizar la fila seleccionada debe cumplir los dos primeros requisitos
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void restaCantidadMateriales(Componente seleccionadoComponente) {
        try {
            //iterar el datatable y encontrar los materiales para preguntar si todos alcanzan
            Double selecCantidadDisponible = 0.0d;
            Double selecCantidadAUtilizar = 0.0d;
            Double selecCantidadEnTransito = 0.0d;

            Double iteraCantidadDisponible = 0.0d;
            Double iteraCantidadAUtilizar = 0.0d;
            Double iteraCantidadEnTransito = 0.0d;

            Componente iteraComponentes;
            Componente hallaComponente;

            boolean esElComponente = false;

            // recorrer los materiales del componente
            //recorrer el resto de los materiales

            for (int i = 0; i < componentesDataTable.getRowCount(); i++) {
                // solo los materiales con el codComponente
                componentesDataTable.setRowIndex(i);
                hallaComponente = (Componente) componentesDataTable.getRowData();
                //verificar que es el componente con el lote y tipo mercaderia iguales


                if (hallaComponente.getCodCompProd().equals(seleccionadoComponente.getCodCompProd()) && !hallaComponente.getNombreMaterial().equals("") && hallaComponente.getCantLoteProduccionRef().equals(seleccionadoComponente.getCantLoteProduccion()) && hallaComponente.getNombreTipoProgramaProdRef().equals(seleccionadoComponente.getNombreTipoProgramaProd())) {

                    //obtenemos los datos del material
                    //luego restar
                    selecCantidadDisponible = Double.parseDouble(hallaComponente.getCantidadDisponible().replace(",",""));
                    selecCantidadAUtilizar = Double.parseDouble(hallaComponente.getCantidadAUtilizar().replace(",",""));
                    selecCantidadEnTransito = Double.parseDouble(hallaComponente.getCantidadEnTransito().replace(",",""));

                    for (int j = 0; j < componentesDataTable.getRowCount(); j++) {
                        componentesDataTable.setRowIndex(j);
                        iteraComponentes = (Componente) componentesDataTable.getRowData();
                        if (!iteraComponentes.getNombreMaterial().equals("") && iteraComponentes.getCodMaterial().equals(hallaComponente.getCodMaterial())) {

                            iteraCantidadDisponible = Double.parseDouble(iteraComponentes.getCantidadDisponible().replace(",",""));
                            iteraCantidadAUtilizar = Double.parseDouble(iteraComponentes.getCantidadAUtilizar().replace(",",""));
                            iteraCantidadEnTransito = Double.parseDouble(iteraComponentes.getCantidadEnTransito().replace(",",""));
                            //restar las cantidades
                            //ver si el disponible alcanza
                            //restar la cantidad del componente seleccionado al resto de los materiales
                            //preguntar si es el componente o si es del restante
//                            System.out.println("iteraCantidadDisponible " + iteraCantidadDisponible +
//                                    " iteraCantidadAUtilizar " + iteraCantidadAUtilizar +
//                                    " iteraCantidadEnTransito " + iteraCantidadEnTransito);

                            if (iteraCantidadDisponible >= iteraCantidadAUtilizar) {
                                //el disponible alcanza entonces restar de disponible
                                Double cantidadDisponibleRestante = iteraCantidadDisponible - selecCantidadAUtilizar;
                                iteraComponentes.setCantidadDisponible(formato.format(cantidadDisponibleRestante));

                            //  System.out.println(" cantidadDisponibleRestante  " + cantidadDisponibleRestante.toString());

                            } else {
                                //si no le alcanza con el disponible, sumar ambos y restar
                                Double sumaDisponibleTransito = iteraCantidadDisponible + iteraCantidadEnTransito;
                                //restar de la suma lo requerido
                                Double cantidadTransitoRestante = sumaDisponibleTransito - selecCantidadAUtilizar;
                                iteraComponentes.setCantidadDisponible("0.0");
                                iteraComponentes.setCantidadEnTransito(formato.format(cantidadTransitoRestante));
                            // System.out.println(" cantidadTransitoRestante  " + cantidadTransitoRestante);

                            }

                        }
                    }

                }
            //primero verificar si le alcanza

            //se debe verificar y restar si alcanza
            // 1:disponible es mayor a cantidad a utilizar
            // 2: disponible+en Transito es mayor a cantidad a utilizar
            //primero analizar la fila seleccionada debe cumplir los dos primeros requisitos
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean alcanzaMateriales(Componente itemComponente) {
        boolean alcanzaMaterial = true;
        int i = 0;

        try {
            //iterar el datatable y encontrar los materiales para preguntar si todos alcanzan
            Double selecDisponible = 0.0d;
            Double selecCantidadAUtilizar = 0.0d;
            Double selecCantidadEnTransito = 0.0d;



            for (i = 0; i < componentesDataTable.getRowCount(); i++) {
                // solo los registros con el codComponente
                componentesDataTable.setRowIndex(i);
                iteraComponente = (Componente) componentesDataTable.getRowData();
                if (iteraComponente.getCodCompProd().equals(itemComponente.getCodCompProd()) && !iteraComponente.getNombreMaterial().equals("")) {

                    selecDisponible = Double.parseDouble(iteraComponente.getCantidadDisponible().replace(",",""));
                    selecCantidadAUtilizar = Double.parseDouble(iteraComponente.getCantidadAUtilizar().replace(",",""));
                    selecCantidadEnTransito = Double.parseDouble(iteraComponente.getCantidadEnTransito().replace(",",""));

                    if ((selecDisponible + selecCantidadEnTransito) < selecCantidadAUtilizar) {
                        alcanzaMaterial = false;
                    //alcanza para usar
                    }
                }
            //primero verificar si le alcanza

            //se debe verificar y restar si alcanza
            // 1:disponible es mayor a cantidad a utilizar
            // 2: disponible+en Transito es mayor a cantidad a utilizar
            //primero analizar la fila seleccionada debe cumplir los dos primeros requisitos
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        //se toma en cuenta el registro 1 de el componente

        if (i <= 1) {
            alcanzaMaterial = false;
        }
        return alcanzaMaterial;
    }

    public boolean tieneMaterialesEnTransito(Componente itemComponente) {
        boolean tieneMaterialesEntransito = true;
        try {
            con = (Util.openConnection(con));
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            String consulta = "";
            //se lista los componentes a fabricar para programa_produccion

//            String sqlEstadoProd = "select em.COD_MATERIAL, em.CANTIDAD_A_UTILIZAR, em.CANTIDAD_DISPONIBLE, em.CANTIDAD_TRANSITO " +
//                    " from EXPLOSION_MATERIALES em where " +
//                    " em.cod_programa_produccion =" + bean.getCodProgramaProduccion() + " and em.cod_material " +
//                    " in(select p.cod_material from PROGRAMA_PRODUCCION_DETALLE p where " +
//                    " p.COD_COMPPROD=" + bean.getFormulaMaestra().getComponentesProd().getCodCompprod() + " " +
//                    " and p.COD_PROGRAMA_PROD=" + bean.getCodProgramaProduccion() + ") and em.cantidad_disponible<em.cantidad_a_utilizar ";


            consulta = " SELECT EM.COD_PROGRAMA_PRODUCCION,EM.COD_MATERIAL,EM.COD_UNIDAD_MEDIDA,EM.CANTIDAD_A_UTILIZAR,EM.CANTIDAD_DISPONIBLE, EM.CANTIDAD_TRANSITO " +
                    "  FROM EXPLOSION_MATERIALES EM " +
                    " WHERE EM.COD_PROGRAMA_PRODUCCION='" + codProgramaProduccion + "'" +
                    " AND EM.COD_MATERIAL IN ( SELECT PPD.COD_MATERIAL FROM PROGRAMA_PRODUCCION_DETALLE PPD " +
                    " WHERE PPD.COD_COMPPROD = '" + itemComponente.getCodCompProd() + "' " +
                    " AND PPD.COD_PROGRAMA_PROD='" + codProgramaProduccion + "' ) " +
                    " AND EM.CANTIDAD_DISPONIBLE<EM.CANTIDAD_A_UTILIZAR ";


            //se debe iterar todos los items y comprobar que todos los items tienen cantidades que cumplen
            //  System.out.println("la consulta de tiene materiales en transito " + consulta);

            ResultSet rs = st.executeQuery(consulta);



            while (rs.next()) {
                double cantidadAUtilizar = rs.getDouble("CANTIDAD_A_UTILIZAR");
                double cantidadDisponible = rs.getDouble("CANTIDAD_DISPONIBLE");
                double cantidadTransito = rs.getDouble("CANTIDAD_TRANSITO");
                if ((cantidadDisponible + cantidadTransito) < cantidadAUtilizar) {
                    tieneMaterialesEntransito = false;
                    break;
                }
            // System.out.println("codComponente: " + itemComponente.getCodCompProd() + "cantidad a utilizar :" + cantidadAUtilizar + "cantidad disponible: " + cantidadDisponible + "cantidad transito: " + cantidadTransito + " estado materiales en transito " + tieneMaterialesEntransito);

            }

            //verificar que si tiene registros
            rs.last();
            int filas = rs.getRow();
            rs.first();
            if (filas == 0) {
                tieneMaterialesEntransito = false;
            }

            if (rs != null) {
                rs.close();
                st.close();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return tieneMaterialesEntransito;
    }

    public boolean tieneDisponibleMenorQueUtilizar(Componente itemComponente) {
        boolean tieneMaterialesEntransito = true;

        String iconoEstadoSimulacion = "";

        try {
            con = (Util.openConnection(con));
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            String consulta = "";
            //se lista los componentes a fabricar para programa_produccion

//            String sqlEstadoProd = "select em.COD_MATERIAL, em.CANTIDAD_A_UTILIZAR, em.CANTIDAD_DISPONIBLE, em.CANTIDAD_TRANSITO " +
//                    " from EXPLOSION_MATERIALES em where " +
//                    " em.cod_programa_produccion =" + bean.getCodProgramaProduccion() + " and em.cod_material " +
//                    " in(select p.cod_material from PROGRAMA_PRODUCCION_DETALLE p where " +
//                    " p.COD_COMPPROD=" + bean.getFormulaMaestra().getComponentesProd().getCodCompprod() + " " +
//                    " and p.COD_PROGRAMA_PROD=" + bean.getCodProgramaProduccion() + ") and em.cantidad_disponible<em.cantidad_a_utilizar ";


            consulta = " SELECT EM.COD_PROGRAMA_PRODUCCION,EM.COD_MATERIAL,EM.COD_UNIDAD_MEDIDA,EM.CANTIDAD_A_UTILIZAR,EM.CANTIDAD_DISPONIBLE, EM.CANTIDAD_TRANSITO " +
                    "  FROM EXPLOSION_MATERIALES EM " +
                    " WHERE EM.COD_PROGRAMA_PRODUCCION='" + codProgramaProduccion + "'" +
                    " AND EM.COD_MATERIAL IN ( SELECT PPD.COD_MATERIAL FROM PROGRAMA_PRODUCCION_DETALLE PPD " +
                    " WHERE PPD.COD_COMPPROD = '" + itemComponente.getCodCompProd() + "' " +
                    " AND PPD.COD_PROGRAMA_PROD='" + codProgramaProduccion + "' ) " +
                    " AND EM.CANTIDAD_DISPONIBLE<EM.CANTIDAD_A_UTILIZAR ";


            //se debe iterar todos los items y comprobar que todos los items tienen cantidades que cumplen
            //System.out.println("la consulta de tieneDisponibleMenorQueUtilizar " + consulta);

            ResultSet rs = st.executeQuery(consulta);



            //2: no alcanza , 1: en transito
            int indicador = 0;
            while (rs.next() && (indicador == 0 || indicador == 1)) {
                double cantidadAUtilizar = rs.getDouble("CANTIDAD_A_UTILIZAR");
                double cantidadDisponible = rs.getDouble("CANTIDAD_DISPONIBLE");
                double cantidadTransito = rs.getDouble("CANTIDAD_TRANSITO");
                if ((cantidadDisponible + cantidadTransito) >= cantidadAUtilizar) {
                    indicador = 1;
                } else {
                    indicador = 2;
                }
            }
            if (indicador == 1) {
                iconoEstadoSimulacion = "../img/error.png";

            }
            if (indicador == 2) {
                iconoEstadoSimulacion = "../img/mal.png";
            }

            //verificar que si tiene registros
            rs.last();
            int filas = rs.getRow();
            rs.first();
            if (filas == 0) {
                tieneMaterialesEntransito = false;
            }

            if (rs != null) {
                rs.close();
                st.close();
            }
            itemComponente.setIconoEstadoSimulacion(iconoEstadoSimulacion);
            itemComponente.setTieneIconoEstadoSimulacion("true");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return tieneMaterialesEntransito;
    }

    public String verificarParaAprobarProgramaProduccion() {
        try {
            this.initVerificarParaAprobarProgramaProduccion();
            this.redireccionar("aprobar_verificar_programar_produccion.jsf");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }

    public String cancelarAprobacion_action() {
        try {
            this.redireccionar("programar_produccion_verificar_producto.jsf");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }

    public String cancelarProgramarProduccion_action() {
        try {
            this.redireccionar("navgador_programa_periodo.jsf");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }

    public void initVerificarParaAprobarProgramaProduccion() {
        Componente iteraComponentes = new Componente();
        componentesSiSePuedenProducirList.clear();
        componentesNoSePuedenProducirList.clear();
        componentesNoSePuedenProducirDataTable = new HtmlDataTable();
        componentesSiSePuedenProducirDataTable = new HtmlDataTable();
        fechaLote=new Date();

        try {
            this.cargarParaAprobarProgramaProduccionNormal();

            for (int i = 0; i < componentesDataTable.getRowCount(); i++) {
                // solo los materiales con el codComponente
                componentesDataTable.setRowIndex(i);
                iteraComponentes = (Componente) componentesDataTable.getRowData();
                //verificar que es el componente con el lote y tipo mercaderia iguales
                //evaluar para ver si puede entrar en la lista de los que si se pueden
                if (iteraComponentes.getNombreMaterial().equals("")) {
                    if (iteraComponentes.getConCheck().equals("true") && iteraComponentes.getSeleccionadoCheck().equals("true")) {
                        if (!this.estaEnListaSiSePuedenProducirList(iteraComponentes)) {
                            //redondeo de lote
                            iteraComponentes.setCantLoteProduccionRef(iteraComponentes.getCantLoteProduccion()); //dato de referencia para la comparacion de lista
                            if (iteraComponentes.getCantLoteProduccion().lastIndexOf(".") > -1) {
                                String valorEntero = iteraComponentes.getCantLoteProduccion().substring(0, iteraComponentes.getCantLoteProduccion().lastIndexOf("."));
                                String valorDecimal = iteraComponentes.getCantLoteProduccion().substring(iteraComponentes.getCantLoteProduccion().lastIndexOf(".") + 1);
                                valorEntero = valorEntero.equals("") ? "0" : valorEntero;
                                valorDecimal = valorDecimal.equals("") ? "0" : valorDecimal;
                                System.out.println("el valor de la fraccion" + valorDecimal);
                                if (Integer.valueOf(valorDecimal) > 0) {
                                    iteraComponentes.setCantLoteProduccion(String.valueOf(Integer.valueOf(valorEntero) + 1));
                                } else {
                                    iteraComponentes.setCantLoteProduccion(String.valueOf(Integer.valueOf(valorEntero)));
                                }
                            }
                            componentesSiSePuedenProducirList.add(iteraComponentes);
                        }
                    } else if (iteraComponentes.getConCheck().equals("true") && iteraComponentes.getSeleccionadoCheck().equals("false")) {
                        if (!this.estaEnListaNoSePuedenProducirList(iteraComponentes)) {
                            componentesNoSePuedenProducirList.add(iteraComponentes);
                        }
                    }

                }

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    
    public void cargarParaAprobarProgramaProduccionNormal() {
        
        Componente iteraComponentes = new Componente();

        try {
            for (int i = 0; i < componentesConMaterialesDataTable.getRowCount(); i++) {
                // solo los materiales con el codComponente
                componentesConMaterialesDataTable.setRowIndex(i);
                iteraComponentes = (Componente) componentesConMaterialesDataTable.getRowData();
                componentesSiSePuedenProducirList.add(iteraComponentes);
                }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public String aceptarAprobacion_action() {
        try {
            // se tiene que actualizar las cantidades que se seleccionaron  de la tabla y trabajar con estos datos
            this.actualizarLotesdeProduccion();
            this.generaAprobacionProduccion(codProgramaProduccion, this.deduceComponentesAprobados(), this.deduceComponentesAprobados());
            this.redireccionar("navgador_programa_periodo.jsf");
        //this.redireccionar("programar_produccion_verificar_producto.jsf");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }

    public void actualizarLotesdeProduccion() {
        try {
            // recorrer los elementos de la tabla de aprobacion y actualizar los valores
            String consulta = "";

            con = (Util.openConnection(con));
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            Componente iteraComponentes;

            for (int i = 0; i < componentesSiSePuedenProducirList.size(); i++) {
                // solo los materiales con el codComponente

                iteraComponentes = (Componente) componentesSiSePuedenProducirList.get(i);

                consulta = "UPDATE PROGRAMA_PRODUCCION SET  " +
                        "   CANT_LOTE_PRODUCCION = '" + iteraComponentes.getCantLoteProduccion() + "'  " +
                        "  WHERE COD_COMPPROD='" + iteraComponentes.getCodCompProd() + "' " +
                        " AND COD_FORMULA_MAESTRA='" + iteraComponentes.getCodFormulaMaestra() + "'  " +
                        " AND COD_PRESENTACION='" + iteraComponentes.getCodPresentacion() + "' " +
                        " AND COD_PROGRAMA_PROD='" + codProgramaProduccion + "'";
                System.out.println("la consulta de actualizacion " + consulta);

                st.executeUpdate(consulta);

            }
            st.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String redireccionar(String direccion) {
        try {

            FacesContext facesContext = FacesContext.getCurrentInstance();
            ExternalContext ext = facesContext.getExternalContext();
            ext.redirect(direccion);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean estaEnListaSiSePuedenProducirList(Componente componente) {
        boolean estaEnLista = false;
        try {
            Componente iteraComponentes;
            for (int i = 0; i < componentesSiSePuedenProducirList.size(); i++) {
                // solo los materiales con el codComponente

                iteraComponentes = (Componente) componentesSiSePuedenProducirList.get(i); // en la lista de componentes que si se pueden producir comparar la cantidades con los datos de referencia



                if (iteraComponentes.getNombreMaterial().equals("") && iteraComponentes.getCodCompProd().equals(componente.getCodCompProd()) && iteraComponentes.getCantLoteProduccionRef().equals(componente.getCantLoteProduccion())) {

//                    System.out.println("valores a comparar en lista si se puede producir" +
//                            iteraComponentes.getNombreMaterial() + " - " +
//                            iteraComponentes.getCodCompProd() + "  " +
//                            componente.getCodCompProd() +
//                            iteraComponentes.getCantLoteProduccion() + "  " +
//                            componente.getCantLoteProduccion());


                    estaEnLista = true;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return estaEnLista;
    }

    public boolean estaEnListaNoSePuedenProducirList(Componente componente) {
        boolean estaEnLista = false;
        try {

            Componente iteraComponentes;
            for (int i = 0; i < componentesNoSePuedenProducirList.size(); i++) {
                // solo los materiales con el codComponente                
                iteraComponentes = (Componente) componentesNoSePuedenProducirList.get(i);
                if (iteraComponentes.getNombreMaterial().equals("") && iteraComponentes.getCodCompProd().equals(componente.getCodCompProd()) && iteraComponentes.getCantLoteProduccion().equals(componente.getCantLoteProduccion())) {
                    estaEnLista = true;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return estaEnLista;
    }

    public String deduceComponentesAprobados() {
        String codComponentesAprobados = "''";
        try {

            Componente iteraComponentes;
            for (int i = 0; i < componentesSiSePuedenProducirDataTable.getRowCount(); i++) {
                // solo los materiales con el codComponente
                componentesSiSePuedenProducirDataTable.setRowIndex(i);
                iteraComponentes = (Componente) componentesSiSePuedenProducirDataTable.getRowData();
                codComponentesAprobados = codComponentesAprobados + "," + iteraComponentes.getCodCompProd();

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return codComponentesAprobados;
    }

    public String generaAprobacionProduccion(String codProgramaPeriodo, String codAprobados, String transito) {
        try {
            con = Util.openConnection(con);

            //String codProgramaPeriodo = request.getParameter("codProgramaPeriodo");
            //String codAprobados = request.getParameter("cod_aprobados");
            //String transito = request.getParameter("transito");

            System.out.println("codProgramaPeriodo:" + codProgramaPeriodo);
            System.out.println("codAprobados:" + codAprobados);
            System.out.println("transito:" + transito);
            String loteProduccion = "";
            String material_transito = "0";
            int loteProduccionLiquidos = 0;
            String aprobados = "";
            String codLote = "";
            /*ManagedProgramaProduccionSimulacion obj=(ManagedProgramaProduccionSimulacion)Util.getSessionBean("ManagedProgramaProduccionSimulacion");
            System.out.println("codProgramaPeriodo:"+obj.getProgramaProduccionList());
            List<ProgramaProduccion> iter = obj.getProgramaProduccionList();*/
            String sqlUpdProgProd = "update programa_produccion_periodo set cod_estado_programa=2 where cod_programa_prod=" + codProgramaPeriodo;
            Statement stUpdProgProd = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            stUpdProgProd.executeUpdate(sqlUpdProgProd);

            sqlUpdProgProd = "select  pp.COD_COMPPROD,pp.CANT_LOTE_PRODUCCION,pp.FECHA_INICIO,pp.FECHA_FINAL," +
                    " pp.COD_FORMULA_MAESTRA,pp.OBSERVACION,pp.COD_TIPO_PROGRAMA_PROD,pp.COD_PRESENTACION";
            sqlUpdProgProd += " from PROGRAMA_PRODUCCION pp";
            sqlUpdProgProd += " where pp.COD_COMPPROD in (" + codAprobados + ")";
            sqlUpdProgProd += " and pp.cod_programa_prod='" + codProgramaPeriodo + "'";
            System.out.println("sqlUpdProgProd ***** ::::" + sqlUpdProgProd);
            stUpdProgProd = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rsUpdProgProd = stUpdProgProd.executeQuery(sqlUpdProgProd);
            while (rsUpdProgProd.next()) {
                String codCompProd = rsUpdProgProd.getString(1);
                int cantidad_lote = rsUpdProgProd.getInt(2);
                String codFormulaMaestra = rsUpdProgProd.getString(5);
                String obsProgProd = rsUpdProgProd.getString(6);
                String codPresentacion = rsUpdProgProd.getString("COD_PRESENTACION");
                codLote = rsUpdProgProd.getString(7);
                if (codLote.equals("1")) {
                    codLote = "-";
                }
                if (codLote.equals("2")) {
                    codLote = "--";
                }
                if (codLote.equals("3")) {
                    codLote = "---";
                }

                System.out.println("cantidad_lote*****************************:" + cantidad_lote);
                String loteFormaFarmaceutica = "";

                System.out.println("ENTRO");
                //GENERAMOS EL NUMERO DE LOTE
                String sqlFormaFar = "select cod_forma,cod_area_empresa from componentes_prod where cod_compprod=" + codCompProd;
                Statement stFormaFar = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                ResultSet rsFormaFar = stFormaFar.executeQuery(sqlFormaFar);
                String formaFarmaceutica = "";
                String codAreaEmpresaComponente="";
                if (rsFormaFar.next()) {
                    formaFarmaceutica = rsFormaFar.getString(1);
                    codAreaEmpresaComponente= rsFormaFar.getString("cod_area_empresa");
                }
                String formaFarmaceuticaComparar = "";
                System.out.println("FORMA FARMACEUTICA 1: " + formaFarmaceutica);
                if (formaFarmaceutica.equals("2")) {
                    loteFormaFarmaceutica = "1";
                    formaFarmaceuticaComparar = "2";
                }
                if (formaFarmaceutica.equals("1")) {
                    loteFormaFarmaceutica = "2";
                    formaFarmaceuticaComparar = "1";
                }
                if (formaFarmaceutica.equals("7") || formaFarmaceutica.equals("10") || formaFarmaceutica.equals("16") || formaFarmaceutica.equals("17") || formaFarmaceutica.equals("26") || formaFarmaceutica.equals("29")) {
                    loteFormaFarmaceutica = "3";
                    formaFarmaceuticaComparar = "7,10,16,26,29";
                }
                if (formaFarmaceutica.equals("11") || formaFarmaceutica.equals("12") || formaFarmaceutica.equals("13") || formaFarmaceutica.equals("31")) {
                    loteFormaFarmaceutica = "4";
                    formaFarmaceuticaComparar = "11,12,13,31";
                }
                if (formaFarmaceutica.equals("25") || formaFarmaceutica.equals("27")) {
                    loteFormaFarmaceutica = "7";
                    formaFarmaceuticaComparar = "25,27";
                }
                if (formaFarmaceutica.equals("6") || formaFarmaceutica.equals("8") || formaFarmaceutica.equals("14") || formaFarmaceutica.equals("15") || formaFarmaceutica.equals("32")) {
                    loteFormaFarmaceutica = "8";
                    formaFarmaceuticaComparar = "6,8,14,15,32";
                }
                if (formaFarmaceutica.equals("20") || formaFarmaceutica.equals("30")) {
                    loteFormaFarmaceutica = "9";
                    formaFarmaceuticaComparar = "20,30";
                }

                DateTime dt = new DateTime();
                int loteMes = dt.getMonthOfYear();
                int loteAnio = dt.getYear();
                String loteAnio2 = Integer.toString(loteAnio).substring(3, 4);
                String loteMes2 = "";
                if (loteMes < 10) {
                    loteMes2 = "0" + Integer.toString(loteMes);
                } else {
                    loteMes2 = Integer.toString(loteMes);
                }
                //personalizacion del mes de lote
                SimpleDateFormat sdf = new SimpleDateFormat("MM");
                loteMes2=sdf.format(fechaLote);
                System.out.println("el lote de Mes:" + loteMes2);

                //sacamos el ultimo dia del mes
                DateTime dt1 = dt.plusMonths(1);
                dt1 = dt1.minusDays(1);
                DateTime dt2 = new DateTime(dt1.getYear(), dt1.getMonthOfYear(), 1, 12, 0, 0, 0);
                dt2 = dt2.minusDays(1);
                String primerDiaMes = Integer.toString(dt2.getYear()) + "-" + Integer.toString(dt2.getMonthOfYear()) + "-1";
                String ultimoDiaMes = Integer.toString(dt2.getYear()) + "-" + Integer.toString(dt2.getMonthOfYear()) + "-" + Integer.toString(dt2.getDayOfMonth());
                System.out.println("ULTIMO DIA MES: " + ultimoDiaMes);
                System.out.println("loteMes: " + loteMes);
                System.out.println("loteAnio2: " + loteAnio2);
                
                /**********************************************/
                /***********************************************/
                loteProduccion = "";
                loteProduccionLiquidos = 0;
                String codReserva = "";


                for (int i = 1; i <= cantidad_lote; i++) {


                    System.out.println("****************************************i: " + i);
                    String sqlNumProduccion = "select count(*)+1 from PROGRAMA_PRODUCCION p, componentes_prod c where p.COD_PROGRAMA_PROD = " + codProgramaPeriodo + " and " +
                            " p.COD_ESTADO_PROGRAMA=2  and" +
                            " c.cod_compprod=p.cod_compprod and c.cod_forma in (" + formaFarmaceuticaComparar + ")";
                    
                    sqlNumProduccion = "select count(*)+1 from PROGRAMA_PRODUCCION p, componentes_prod c where p.COD_PROGRAMA_PROD = " + codProgramaPeriodo + " and " +
                            " p.COD_ESTADO_PROGRAMA=2  and" +
                            " c.cod_compprod=p.cod_compprod and c.cod_area_empresa in (" + codAreaEmpresaComponente + ") ";
                    
                    if(loteFormaFarmaceutica.equals("7")){ //en el caso de oftalmicos su correlativo debe ser individual
                            sqlNumProduccion  = sqlNumProduccion + " and c.COD_FORMA = 25 " ;}
                    


                    Statement stNumProduccion = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    System.out.println("SQL NUM PRODUCCION: " + sqlNumProduccion);
                    ResultSet rsNumProduccion = stNumProduccion.executeQuery(sqlNumProduccion);

                    int numProduccion = 0;
                    while (rsNumProduccion.next()) {
                        numProduccion = rsNumProduccion.getInt(1);
                    }
                    String numProduccionString = "";
                    if (numProduccion < 10) {
                        numProduccionString = "0" + numProduccion;
                    } else {
                        numProduccionString = "" + numProduccion;
                    }
                    if (loteFormaFarmaceutica.equals("1")) {
                        loteProduccion=this.codLoteProveedor(codCompProd,codFormulaMaestra,i);
                        if(loteProduccion.equals(""))
                        {loteProduccionLiquidos = loteProduccionLiquidos + 1;
                        loteProduccion = "S-L " + loteProduccionLiquidos;}
                        //se debe generar el lote predeterminado para el programa de produccion
                        
                    } else {
                        loteProduccion = loteFormaFarmaceutica + loteMes2 + numProduccionString + loteAnio2;
                    }
                    System.out.println("FORMA FARMACEUTICA: " + loteFormaFarmaceutica);
                    System.out.println("LOTE MES: " + loteMes);
                    System.out.println("LOTE ANIO: " + loteAnio2);

                    System.out.println("LOTE DE PRODUCCION:  " + loteProduccion);
                    //ACTUALIZAR EL LOTE DEL PRODUCTO


                    String sql = "select pp.COD_TIPO_PROGRAMA_PROD";
                    sql += " from PROGRAMA_PRODUCCION pp";
                    sql += " where  pp.COD_FORMULA_MAESTRA='" + codFormulaMaestra + "' and pp.cod_programa_prod=" + codProgramaPeriodo + "";
                    sql += " and pp.COD_COMPPROD=" + codCompProd + " and pp.COD_LOTE_PRODUCCION='" + codLote + "'";
                    Statement st_form1 = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    System.out.println("SQL NUM Detalle  " + sql);
                    ResultSet rs_form1 = st_form1.executeQuery(sql);
                    Statement stUpdLote = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

                    while (rs_form1.next()) {
                        String codTipoPrograma = rs_form1.getString(1);
                        String sql_transito = " select COUNT(COD_COMPPROD) from programa_produccion where COD_COMPPROD in (" + transito + ") AND COD_FORMULA_MAESTRA='" + codFormulaMaestra + "'";
                        sql_transito += " AND cod_programa_prod='" + codProgramaPeriodo + "' AND COD_COMPPROD='" + codCompProd + "' AND cod_lote_produccion='" + codLote + "'";
                        System.out.println("sql_transito  " + sql_transito);
                        Statement st_transito = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                        ResultSet rs_transito = st_transito.executeQuery(sql_transito);
                        int sw_transito = 0;
                        while (rs_transito.next()) {
                            sw_transito = rs_transito.getInt(1);
                            System.out.println(":" + sw_transito);
                        }
                        material_transito = "0";
                        if (sw_transito != 0) {
                            System.out.println("ENTRO QQQQ:  " + material_transito);
                            material_transito = "1";
                        }
                        String codTipoAprobacionProgramaProduccion = this.buscaCodTipoAprobacionProgramaProduccion(codProgramaPeriodo, codCompProd, codFormulaMaestra, codLote);
                        
                        System.out.println("material_transito:  " + material_transito);
                        sql = "insert into programa_produccion(cod_programa_prod,cod_formula_maestra,FECHA_INICIO,FECHA_FINAL,cod_lote_produccion,";
                        sql += " cod_estado_programa,observacion,CANT_LOTE_PRODUCCION,VERSION_LOTE,COD_COMPPROD,COD_TIPO_PROGRAMA_PROD,MATERIAL_TRANSITO,COD_TIPO_APROBACION,COD_PRESENTACION)values(";
                        sql += " " + codProgramaPeriodo + ",'" + codFormulaMaestra + "','"+fechaFormat.format(new Date())+"','"+fechaFormat.format(new Date())+"','" + loteProduccion + "',";
                        sql += " 2,'" + obsProgProd + "','1',1," + codCompProd + ",'" + codTipoPrograma + "'," + material_transito + ",'"+codTipoAprobacionProgramaProduccion+"','"+codPresentacion+"')";
                        System.out.println("insert 1:" + sql);
                        
                        stUpdLote.executeUpdate(sql);
                    }

                    sql = "select ppd.COD_MATERIAL,ppd.COD_UNIDAD_MEDIDA,(ppd.CANTIDAD /pp.CANT_LOTE_PRODUCCION)";
                    sql += " from PROGRAMA_PRODUCCION_DETALLE ppd,PROGRAMA_PRODUCCION pp";
                    sql += " where pp.COD_PROGRAMA_PROD=ppd.COD_PROGRAMA_PROD AND";
                    sql += " pp.COD_LOTE_PRODUCCION=ppd.COD_LOTE_PRODUCCION";
                    sql += " and ppd.COD_COMPPROD=pp.COD_COMPPROD and pp.COD_FORMULA_MAESTRA='" + codFormulaMaestra + "'";
                    sql += " and ppd.COD_COMPPROD=" + codCompProd + " and ppd.COD_LOTE_PRODUCCION='" + codLote + "' and pp.cod_programa_prod=" + codProgramaPeriodo + "";
                    Statement st_form = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    System.out.println("SQL NUM Detalle  " + sql);
                    ResultSet rs_form = st_form.executeQuery(sql);
                    while (rs_form.next()) {
                        String cod_material = rs_form.getString(1);
                        String cod_unidad_medida = rs_form.getString(2);
                        double cantidad = rs_form.getDouble(3);
                        sql = " insert into programa_produccion_detalle(cod_programa_prod,cod_material,cod_unidad_medida,cantidad," +
                                " COD_COMPPROD,cod_lote_produccion,cod_estado_registro) values(";
                        sql += " " + codProgramaPeriodo + ",'" + cod_material + "','" + cod_unidad_medida + "'," + cantidad + ",";
                        sql += " " + codCompProd + ",'" + loteProduccion + "',1)";
                        System.out.println("insert ep:" + sql);
                        stUpdLote = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                        stUpdLote.executeUpdate(sql);

                    }

                }
                String sqlUpdLote = "delete from programa_produccion  " +
                        " where cod_programa_prod=" + codProgramaPeriodo + " " +
                        " and cod_compprod=" + codCompProd + "" +
                        " and cod_lote_produccion='" + codLote + "'";
                Statement stUpdLote = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                stUpdLote.executeUpdate(sqlUpdLote);
                System.out.println("ACTUALIZA LOTE: " + sqlUpdLote);

                sqlUpdLote = "delete from programa_produccion_detalle  " +
                        " where cod_programa_prod=" + codProgramaPeriodo + " " +
                        " and cod_compprod=" + codCompProd + "" +
                        " and cod_lote_produccion='" + codLote + "'";
                stUpdLote = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                stUpdLote.executeUpdate(sqlUpdLote);
                System.out.println("ACTUALIZA LOTE Detalle--: " + sqlUpdLote);

            }

            // for(String c:estadoMal){
            String sql = "select c.COD_COMPPROD,c.nombre_prod_semiterminado,pp.cod_lote_produccion,pp.cant_lote_produccion,tp.NOMBRE_TIPO_PROGRAMA_PROD,";
            sql += " pp.CANT_LOTE_PRODUCCION";
            sql += " from COMPONENTES_PROD c,programa_produccion pp,TIPOS_PROGRAMA_PRODUCCION tp";
            sql += " where c.COD_COMPPROD in (" + codAprobados + ") and c.COD_COMPPROD <> -1 and pp.cod_programa_prod=" + codProgramaPeriodo + "";
            sql += " and c.cod_forma = 2 and pp.cod_compprod=c.cod_compprod and tp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD";
            System.out.println("sql navegador Mal:" + sql);
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rs = st.executeQuery(sql);
            rs.last();
            int rows = rs.getRow();

            rs.first();
            String cod = "";
            for (int i = 0; i < rows; i++) {
                System.out.println("rs.getString(2):" + rs.getString(2));

                aprobados = aprobados + "," + rs.getString(3);
                rs.next();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String codLoteProveedor(String codComprod,String codFormulaMaestra, int numeroRegistro){
            String codLote="";
        try {
            con = (Util.openConnection(con));
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

           String consulta = " SELECT  DISTINCT IADE.COD_MATERIAL,IADE.LOTE_MATERIAL_PROVEEDOR,IADE.FECHA_VENCIMIENTO  " +
                    " FROM COMPONENTES_PROD CP INNER JOIN FORMULA_MAESTRA FM ON CP.COD_COMPPROD= FM.COD_COMPPROD " +
                    " INNER JOIN FORMULA_MAESTRA_DETALLE_EP FMEP ON FMEP.COD_FORMULA_MAESTRA = FM.COD_FORMULA_MAESTRA " +
                    " INNER JOIN INGRESOS_ALMACEN_DETALLE_ESTADO IADE ON IADE.COD_MATERIAL=FMEP.COD_MATERIAL " +
                    " WHERE IADE.CANTIDAD_RESTANTE>0 AND IADE.FECHA_VENCIMIENTO>=GETDATE() " +
                    " AND CP.COD_COMPPROD='"+codComprod+"' ORDER BY IADE.FECHA_VENCIMIENTO ASC ";

           consulta = " select sum(iade.CANTIDAD_RESTANTE)as cantidad ,iad.cod_material, ia.COD_PROVEEDOR,isnull(iade.LOTE_MATERIAL_PROVEEDOR,'-')as LOTE_MATERIAL_PROVEEDOR,iade.FECHA_VENCIMIENTO, iade.COD_ESTADO_MATERIAL " +
                    " from INGRESOS_ALMACEN ia,INGRESOS_ALMACEN_DETALLE iad, " +
                    " INGRESOS_ALMACEN_DETALLE_ESTADO iade, proveedores p,FORMULA_MAESTRA FM,FORMULA_MAESTRA_DETALLE_EP FMDEP " +
                    " where ia.COD_INGRESO_ALMACEN=iad.COD_INGRESO_ALMACEN  " +
                    " and iad.COD_INGRESO_ALMACEN=iade.COD_INGRESO_ALMACEN  " +
                    " and ia.cod_proveedor=p.cod_proveedor  " +
                    " AND ia.cod_estado_ingreso_almacen=1 " +
                    " and iad.cod_material=iade.cod_material  " +
                    " AND FMDEP.COD_MATERIAL = IADE.COD_MATERIAL " +
                    " AND FM.COD_FORMULA_MAESTRA = FMDEP.COD_FORMULA_MAESTRA  " +
                    " and iade.CANTIDAD_RESTANTE>0 AND FM.COD_COMPPROD='"+codComprod+"' " +
                    " AND IADE.FECHA_VENCIMIENTO>=GETDATE() " +
                    " AND FMDEP.COD_MATERIAL IN ( select m1.COD_MATERIAL   from MATERIALES m1,grupos g where g.COD_GRUPO=m1.COD_GRUPO and g.COD_CAPITULO=3 ) " +
                    " GROUP BY iad.cod_material, ia.COD_PROVEEDOR,iade.LOTE_MATERIAL_PROVEEDOR,iade.FECHA_VENCIMIENTO, iade.COD_ESTADO_MATERIAL ";


            System.out.println("consulta busqueda de codigo lote proveedor" + consulta);
            ResultSet rs = st.executeQuery(consulta);

            while (rs.next()) {
                //extraer los materiales con fecha de vencimiento recientes e ir al numero de registro para obtenerlo
                if(rs.getRow()==numeroRegistro){                    
                    codLote=rs.getString("LOTE_MATERIAL_PROVEEDOR")+"";
                    System.out.println("se asigno el codigo de lote predeterminado" + codLote);
                    break;
                }
            }
            


        } catch (Exception e) {
            e.printStackTrace();
        }
    return codLote;
    }

    
    public String codLoteProveedorEnProgramaProduccion(String codProgramaProduccion, String codComprod,String codFormulaMaestra){
            String codLote="";
            String restrColumnas="''";
        try {
            con = (Util.openConnection(con));
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);


            String consulta = " SELECT  DISTINCT IADE.COD_MATERIAL,IADE.LOTE_MATERIAL_PROVEEDOR,IADE.FECHA_VENCIMIENTO  " +
                    " FROM COMPONENTES_PROD CP INNER JOIN FORMULA_MAESTRA FM ON CP.COD_COMPPROD= FM.COD_COMPPROD " +
                    " INNER JOIN FORMULA_MAESTRA_DETALLE_EP FMEP ON FMEP.COD_FORMULA_MAESTRA = FM.COD_FORMULA_MAESTRA " +
                    " INNER JOIN INGRESOS_ALMACEN_DETALLE_ESTADO IADE ON IADE.COD_MATERIAL=FMEP.COD_MATERIAL " +
                    " WHERE IADE.CANTIDAD_RESTANTE>0 AND IADE.FECHA_VENCIMIENTO>=GETDATE() " +
                    " AND CP.COD_COMPPROD='"+codComprod+"' ORDER BY IADE.FECHA_VENCIMIENTO ASC ";

            consulta = "SELECT PPR.COD_COMPPROD,PPR.COD_FORMULA_MAESTRA,PPR.COD_LOTE_PRODUCCION " +
                    " FROM  PROGRAMA_PRODUCCION PPR WHERE PPR.COD_ESTADO_PROGRAMA = 2 " +
                    " AND PPR.COD_PROGRAMA_PROD = '"+codProgramaProduccion+"' " +
                    " AND PPR.COD_COMPPROD='"+codComprod+"'";
                    
            ResultSet rs = st.executeQuery(consulta);            

            while (rs.next()) {
                restrColumnas = restrColumnas +",'"+ rs.getString("COD_COMPPROD") + rs.getString("COD_FORMULA_MAESTRA") + rs.getString("COD_LOTE_PRODUCCION")+"'" ;
            }

            consulta = " SELECT DISTINCT IADE.COD_MATERIAL,IADE.LOTE_MATERIAL_PROVEEDOR,IADE.FECHA_VENCIMIENTO, IADE.CANTIDAD_RESTANTE,CP.nombre_prod_semiterminado   " +
                    " FROM COMPONENTES_PROD CP INNER JOIN FORMULA_MAESTRA FM ON CP.COD_COMPPROD= FM.COD_COMPPROD   " +
                    " INNER JOIN FORMULA_MAESTRA_DETALLE_EP FMEP ON FMEP.COD_FORMULA_MAESTRA = FM.COD_FORMULA_MAESTRA   " +
                    " INNER JOIN INGRESOS_ALMACEN_DETALLE_ESTADO IADE ON IADE.COD_MATERIAL=FMEP.COD_MATERIAL   " +
                    " WHERE IADE.CANTIDAD_RESTANTE>0 AND IADE.FECHA_VENCIMIENTO>=GETDATE()   " +
                    " AND CP.COD_COMPPROD='"+codComprod+"' " +
                    " AND convert(varchar,CP.COD_COMPPROD)+CONVERT(varchar,FM.COD_FORMULA_MAESTRA)+convert(varchar,IADE.LOTE_MATERIAL_PROVEEDOR) NOT IN("+restrColumnas+") " +
                    " ORDER BY IADE.FECHA_VENCIMIENTO ASC ";
            
            System.out.println("la consulta armada " + consulta );
            
            rs = st.executeQuery(consulta);
            if(rs.next()){
                codLote = rs.getString("LOTE_MATERIAL_PROVEEDOR");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    return codLote;
    }



    //metodo init cuando los componentes dependen del material
    //@PostConstruct
      void initialize() {
        try {
            //primero listado de productos que tienen espera de materiales

            System.out.println("entro al init de programa produccion verificar producto");
            codProgramaProduccion = "39";
            HttpServletRequest request = (HttpServletRequest) FacesContext.getCurrentInstance().getExternalContext().getRequest();
            if (request.getParameter("codProgramaPeriodo") != null) {
                codProgramaProduccion = request.getParameter("codProgramaPeriodo");
            }
            formatoEntero.applyPattern("####.0");
            formato.applyPattern("#,###.##;(#,###.##)");//("#,##0.00");
            formato.applyPattern("###,###.00");
            

            con = (Util.openConnection(con));
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            String consulta = "";
            //se lista los componentes a fabricar para programa_produccion


            consulta = " SELECT PP.COD_PROGRAMA_PROD,CP.COD_COMPPROD, CP.nombre_prod_semiterminado,PP.COD_LOTE_PRODUCCION,PP.CANT_LOTE_PRODUCCION, PP.COD_TIPO_PROGRAMA_PROD ,TPP.NOMBRE_TIPO_PROGRAMA_PROD, " +
                    " isnull((select ca.NOMBRE_CATEGORIACOMPPROD from  CATEGORIAS_COMPPROD CA WHERE CA.COD_CATEGORIACOMPPROD = CP.COD_CATEGORIACOMPPROD),'') AS CATEGORIA, PP.COD_PRESENTACION " +
                    " FROM PROGRAMA_PRODUCCION PP INNER JOIN COMPONENTES_PROD CP ON PP.COD_COMPPROD=CP.COD_COMPPROD " +
                    " INNER JOIN TIPOS_PROGRAMA_PRODUCCION TPP ON TPP.COD_TIPO_PROGRAMA_PROD = PP.COD_TIPO_PROGRAMA_PROD " +
                    " WHERE PP.COD_PROGRAMA_PROD='" + codProgramaProduccion + "' AND PP.COD_ESTADO_PROGRAMA=4" +
                    " ORDER BY CP.nombre_prod_semiterminado ASC";

            //" where e.CANTIDAD_A_UTILIZAR>(e.CANTIDAD_DISPONIBLE + e.CANTIDAD_TRANSITO) " +
            consulta = "select e.cod_material,m.nombre_material,e.CANTIDAD_A_UTILIZAR,e.CANTIDAD_DISPONIBLE,e.cantidad_transito,m.stock_minimo_material " +
                    " from EXPLOSION_MATERIALES e,materiales m " +
                    " where  e.cod_programa_produccion='" + codProgramaProduccion+"'" +
                    " and e.CANTIDAD_A_UTILIZAR>(e.CANTIDAD_DISPONIBLE + e.CANTIDAD_TRANSITO)" +
                    " and  m.cod_material=e.cod_material ORDER BY m.nombre_material";



            ResultSet rs = st.executeQuery(consulta);
            System.out.println("el query de cabecera para programa produccion" + consulta);
            rs.last();
            int filas = rs.getRow();
            //programaProduccionList.clear();
            rs.first();
            componentesList.clear();
            for (int i = 0; i < filas; i++) {
                //se debe verificar que los materiales de un producto esten en transito

                itemComponente = new Componente();
                itemComponente.setCodMaterial(rs.getString("cod_material"));
                itemComponente.setNombreMaterial(rs.getString("nombre_material"));
                itemComponente.setCantidadAUtilizar(formato.format(rs.getDouble("CANTIDAD_A_UTILIZAR")));
                itemComponente.setCantidadDisponible(formato.format(rs.getDouble("CANTIDAD_DISPONIBLE")));
                itemComponente.setCantidadEnTransito(formato.format(rs.getDouble("cantidad_transito")));
                itemComponente.setStockMinimoMaterial(formato.format(rs.getDouble("stock_minimo_material")));
                itemComponente.setCantidadAUtilizarRef(formato.format(rs.getDouble("CANTIDAD_A_UTILIZAR")));
                itemComponente.setCantidadDisponibleRef(formato.format(rs.getDouble("CANTIDAD_DISPONIBLE")));
                itemComponente.setCantidadEnTransitoRef(formato.format(rs.getDouble("cantidad_transito")));
                itemComponente.setConInputTextCantLoteProduccion("false");
                itemComponente.setEstiloEstado("background-color: #E3CEF6;");
                itemComponente.setLinkOperacion("Producir");
               
                //if (this.tieneMaterialesEnTransito(itemComponente)) {

//                if (this.tieneDisponibleMenorQueUtilizar(itemComponente)) {                

                componentesList.add(itemComponente);
                //llenado del detalle de materiales por cada componente
                //this.materialesComponente(itemComponente);
                this.componentesMaterial(itemComponente);
                //  }
                //}

                rs.next();

            }
                        
            if (rs != null) {
                rs.close();
                st.close();
            }
            this.cargaComponentesConMateriales();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

        public void componentesMaterial(Componente itemComponente) {
        try {
            con = (Util.openConnection(con));
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            Componente filaComponente = new Componente();

            String consulta = "";
            
            consulta = " SELECT cp.cod_compprod,p.CANT_LOTE_PRODUCCION,cp.nombre_prod_semiterminado,ppd.CANTIDAD,tp.COD_TIPO_PROGRAMA_PROD,tp.NOMBRE_TIPO_PROGRAMA_PROD, " +
                    " isnull((select ca.NOMBRE_CATEGORIACOMPPROD from  CATEGORIAS_COMPPROD ca WHERE ca.COD_CATEGORIACOMPPROD = cp.COD_CATEGORIACOMPPROD),'') as NOMBRE_CATEGORIACOMPPROD," +
                    " p.COD_FORMULA_MAESTRA, p.COD_PRESENTACION,p.COD_LOTE_PRODUCCION  " +
                    " FROM PROGRAMA_PRODUCCION p,COMPONENTES_PROD cp,PROGRAMA_PRODUCCION_DETALLE ppd,TIPOS_PROGRAMA_PRODUCCION tp " +
                    " where p.COD_PROGRAMA_PROD='" + codProgramaProduccion + "' and p.COD_ESTADO_PROGRAMA=4 " +
                    " and cp.COD_COMPPROD=p.COD_COMPPROD and cp.COD_COMPPROD=ppd.COD_COMPPROD " +
                    " and ppd.COD_COMPPROD=p.COD_COMPPROD and ppd.COD_MATERIAL='" + itemComponente.getCodMaterial() + "' " +
                    " and ppd.cod_lote_produccion=p.cod_lote_produccion and tp.COD_TIPO_PROGRAMA_PROD=p.COD_TIPO_PROGRAMA_PROD " +
                    " and p.COD_PROGRAMA_PROD=ppd.COD_PROGRAMA_PROD ";




            //System.out.println("la consulta que se ejecutara al principio para el detalle de componentes " + consulta);

            ResultSet rs = st.executeQuery(consulta);

            while (rs.next()) {
                filaComponente = new Componente();
                filaComponente.setCodMaterial(itemComponente.getCodMaterial()); //codMaterial de referencia
                //filaComponente.setCantidadDisponible(itemComponente.getCantidadDisponible()); //cantidad disponible de referencia
                //filaComponente.setCantidadEnTransito(itemComponente.getCantidadEnTransito()); // cantidad en transito de referencia
                filaComponente.setCodProgramaProd(codProgramaProduccion);
                filaComponente.setCodCompProd(rs.getString("cod_compprod"));
                filaComponente.setCantLoteProduccion(formatoEntero.format(rs.getDouble("CANT_LOTE_PRODUCCION")));
                filaComponente.setNombreCompProd(rs.getString("nombre_prod_semiterminado"));
                filaComponente.setCantidadAUtilizar(formato.format(rs.getDouble("CANTIDAD")));
                filaComponente.setCodTipoProgramaProd(rs.getString("COD_TIPO_PROGRAMA_PROD"));
                filaComponente.setNombreTipoProgramaProd(rs.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                filaComponente.setCategoria(rs.getString("NOMBRE_CATEGORIACOMPPROD"));
                filaComponente.setCodFormulaMaestra(rs.getString("COD_FORMULA_MAESTRA"));
                filaComponente.setCodPresentacion(rs.getString("COD_PRESENTACION"));
                filaComponente.setCodLoteProduccion(rs.getString("COD_LOTE_PRODUCCION"));
                filaComponente.setConCheck("true");
                filaComponente.setConInputTextCantLoteProduccion("true");
                filaComponente.setConMateriales("false");
                filaComponente.setTieneIconoEstadoSimulacion("false");
                //this.colocaEstiloEstado(filaComponente);
                componentesList.add(filaComponente);
            }

            if (rs != null) {
                rs.close();
                st.close();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    /*
    <h:commandLink action="#{ManagedProgramaProduccionVerificarProducto.seleccionaComponente}" >
    <h:outputText value="#{fila.linkOperacion}"/>
    </h:commandLink>

     */
    public String seleccionaComponente_action(ActionEvent event) {
        try {//ActionEvent
            //System.out.println("entro evento check" + evt.getComponent().toString());
            seleccionadoComponente = new Componente();

            seleccionadoComponente = (Componente) componentesDataTable.getRowData();
            System.out.println("entro evento check" + seleccionadoComponente.getNombreCompProd() + "   " + seleccionadoComponente.getSeleccionadoCheck());


            this.cambiaCantLoteProduccionComponente();

            mensajes = "";
            materialesFaltantesList.clear();
            //se debe seleccionar o deseleccionar
            if (seleccionadoComponente.getSeleccionadoCheck().equals("true") && seleccionadoComponente.conMateriales.equals("false")) {
                if (this.alcanzaMaterial(seleccionadoComponente) == true) {
                    //si alcanza restar
                    System.out.println("alcanza materiales");
                    //this.restaCantidadMateriales(seleccionadoComponente);
                    this.restaCantidadMaterial(seleccionadoComponente);
                    this.seleccionaComponentes(seleccionadoComponente); // se seleccionan los componentes

                    mensajes = "";
                } else {
                    // this.mensaje("no existen materiales suficientes para el componente seleccionado");
                    System.out.println("no alcanza materiales para el item seleccionado");
                    mensajes = "no existen materiales suficientes para el componente seleccionado " + mensajes;
                    seleccionadoComponente.setSeleccionadoCheck("false");
                }
            } else if (seleccionadoComponente.getSeleccionadoCheck().equals("false") && seleccionadoComponente.getConMateriales().equals("true")) {
                System.out.println("entro en devolver cantidades");
                this.devuelveCantidadesMaterial(seleccionadoComponente);
                this.deseleccionaComponentes(seleccionadoComponente);
            }


//            if (event.getNewValue().toString().equals("true")) {
//                if (this.alcanzaMateriales(seleccionadoComponente) == true) {
//                    //si alcanza restar
//                    System.out.println("alcanza materiales");
//                    this.restaCantidadMateriales(seleccionadoComponente);
//
//                } else {
//                    //si no alcanza materiales colocar el check en false
//                    seleccionadoComponente.setSeleccionadoCheck("false");
//
//                }
//            } else {
//                //se debe devolver las cantidades
//            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // verificar si alcanza material
    public boolean alcanzaMaterial(Componente itemComponente) {
        boolean alcanzaMaterial = true;
        int i = 0;

        Componente iteraComponentes;
        Componente hallaComponente;
        try {
            //iterar el datatable y encontrar los materiales para preguntar si todos alcanzan
            Double selecDisponible = 0.0d;
            Double selecCantidadAUtilizar = 0.0d;
            Double selecCantidadEnTransito = 0.0d;

            for (i = 0; i < componentesDataTable.getRowCount(); i++) {
                // solo los registros con el codComponente
                componentesDataTable.setRowIndex(i);
                hallaComponente = (Componente) componentesDataTable.getRowData();
                //recorrido de materiales
                //primero se halla el componente
                //luego se halla el material en el registro padre

                if (hallaComponente.getCodCompProd().equals(itemComponente.getCodCompProd()) && hallaComponente.getCantLoteProduccion().equals(itemComponente.getCantLoteProduccion()) && hallaComponente.getCodTipoProgramaProd().equals(itemComponente.getCodTipoProgramaProd()) && hallaComponente.getNombreMaterial().equals("")) {

                    // se obtienen las cantidades de referencia



                    //se itera hasta encontrar al componente del material

                    for (int j = 0; j < componentesDataTable.getRowCount(); j++) {
                        componentesDataTable.setRowIndex(j);
                        iteraComponentes = (Componente) componentesDataTable.getRowData();
                        if (!iteraComponentes.getNombreMaterial().equals("") && iteraComponentes.getCodMaterial().equals(hallaComponente.getCodMaterial())) {

                            selecDisponible = Double.parseDouble(iteraComponentes.getCantidadDisponible().replace(",",""));
                            selecCantidadAUtilizar = Double.parseDouble(hallaComponente.getCantidadAUtilizar().replace(",",""));
                            selecCantidadEnTransito = Double.parseDouble(iteraComponentes.getCantidadEnTransito().replace(",",""));

                            if ((selecDisponible + selecCantidadEnTransito) < selecCantidadAUtilizar) {
                                alcanzaMaterial = false;
                                mensajes = mensajes + iteraComponentes.getNombreMaterial() + ","; // para mostrar el mensaje

                                Componente componenteFaltaMateriales = new Componente();
                                
                                componenteFaltaMateriales.copiarAtributos(iteraComponentes);
                                                                
                                componenteFaltaMateriales.setCantidadAUtilizar(hallaComponente.getCantidadAUtilizar());
                                materialesFaltantesList.add(componenteFaltaMateriales); // se adiciona el material para mostrar en el mensaje
                                
                            //alcanza para usar
                            }
                        }
                    }

                }

            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        //se toma en cuenta el registro 1 de el componente

        if (i <= 1) {
            alcanzaMaterial = false;
        }
        return alcanzaMaterial;
    }

    public void seleccionaComponentes(Componente componenteSeleccionado) {

        Componente iteraComponentes;
        try {
            for (int i = 0; i < componentesDataTable.getRowCount(); i++) {
                // solo los registros con el codComponente
                componentesDataTable.setRowIndex(i);
                iteraComponentes = (Componente) componentesDataTable.getRowData();
                if (componenteSeleccionado.getCodCompProd().equals(iteraComponentes.getCodCompProd()) && componenteSeleccionado.getCantLoteProduccion().equals(iteraComponentes.getCantLoteProduccion()) && componenteSeleccionado.getCodTipoProgramaProd().equals(iteraComponentes.getCodTipoProgramaProd())) {
                    iteraComponentes.setSeleccionadoCheck("true");
                    iteraComponentes.setInputTextCantLoteProduccionSoloLectura("true");
                    iteraComponentes.setConMateriales("true");
                    iteraComponentes.setCodTipoAprobacionProgramaProduccion("1"); // aprobacion de programa produccion normal
                    iteraComponentes.setNombreTipoAprobacionProgramaProduccion("NORMAL");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public void seleccionaComponentesBajoRiesgo(Componente componenteSeleccionado) {

        Componente iteraComponentes;
        try {
            for (int i = 0; i < componentesDataTable.getRowCount(); i++) {
                // solo los registros con el codComponente
                componentesDataTable.setRowIndex(i);
                iteraComponentes = (Componente) componentesDataTable.getRowData();
                if (componenteSeleccionado.getCodCompProd().equals(iteraComponentes.getCodCompProd()) && componenteSeleccionado.getCantLoteProduccion().equals(iteraComponentes.getCantLoteProduccion()) && componenteSeleccionado.getCodTipoProgramaProd().equals(iteraComponentes.getCodTipoProgramaProd())) {
                    iteraComponentes.setSeleccionadoCheck("true");
                    iteraComponentes.setInputTextCantLoteProduccionSoloLectura("true");
                    iteraComponentes.setConMateriales("true");
                    iteraComponentes.setCodTipoAprobacionProgramaProduccion("2"); //aprobacion de programa produccion bajo riesgo
                    iteraComponentes.setNombreTipoAprobacionProgramaProduccion("BAJO RIESGO");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deseleccionaComponentes(Componente componenteSeleccionado) {

        Componente iteraComponentes;
        try {
            for (int i = 0; i < componentesDataTable.getRowCount(); i++) {
                // solo los registros con el codComponente
                componentesDataTable.setRowIndex(i);
                iteraComponentes = (Componente) componentesDataTable.getRowData();
                if (componenteSeleccionado.getCodCompProd().equals(iteraComponentes.getCodCompProd()) && componenteSeleccionado.getCantLoteProduccion().equals(iteraComponentes.getCantLoteProduccion()) && componenteSeleccionado.getCodTipoProgramaProd().equals(iteraComponentes.getCodTipoProgramaProd())) {
                    iteraComponentes.setSeleccionadoCheck("false");
                    iteraComponentes.setInputTextCantLoteProduccionSoloLectura("false");
                    iteraComponentes.setConMateriales("false");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void restaCantidadMaterial(Componente seleccionadoComponente) {
        try {
            //iterar el datatable y encontrar los materiales para preguntar si todos alcanzan
            Double selecCantidadDisponible = 0.0d;
            Double selecCantidadAUtilizar = 0.0d;
            Double selecCantidadEnTransito = 0.0d;

            Double iteraCantidadDisponible = 0.0d;
            Double iteraCantidadAUtilizar = 0.0d;
            Double iteraCantidadEnTransito = 0.0d;

            Componente iteraComponentes;
            Componente hallaComponente;

            // recorrer los materiales del componente
            //recorrer el resto de los materiales

            for (int i = 0; i < componentesDataTable.getRowCount(); i++) {
                // solo los materiales con el codComponente
                componentesDataTable.setRowIndex(i);
                hallaComponente = (Componente) componentesDataTable.getRowData();
                //verificar que es el componente con el lote y tipo mercaderia iguales


                if (hallaComponente.getCodCompProd().equals(seleccionadoComponente.getCodCompProd()) && hallaComponente.getNombreMaterial().equals("") && hallaComponente.getCantLoteProduccion().equals(seleccionadoComponente.getCantLoteProduccion()) && hallaComponente.getNombreTipoProgramaProd().equals(seleccionadoComponente.getNombreTipoProgramaProd()) && hallaComponente.getCodTipoProgramaProd().equals(seleccionadoComponente.getCodTipoProgramaProd())) {

                    //obtenemos los datos del material
                    //luego restar
                    //selecCantidadDisponible = Double.parseDouble(hallaComponente.getCantidadDisponible());
                    selecCantidadAUtilizar = Double.parseDouble(hallaComponente.getCantidadAUtilizar().replace(",",""));
                    //selecCantidadEnTransito = Double.parseDouble(hallaComponente.getCantidadEnTransito());

                    for (int j = 0; j < componentesDataTable.getRowCount(); j++) {
                        componentesDataTable.setRowIndex(j);
                        iteraComponentes = (Componente) componentesDataTable.getRowData();
                        if (!iteraComponentes.getNombreMaterial().equals("") && iteraComponentes.getCodMaterial().equals(hallaComponente.getCodMaterial())) {

                            iteraCantidadDisponible = Double.parseDouble(iteraComponentes.getCantidadDisponible().replace(",",""));
                            iteraCantidadAUtilizar = Double.parseDouble(iteraComponentes.getCantidadAUtilizar().replace(",",""));
                            iteraCantidadEnTransito = Double.parseDouble(iteraComponentes.getCantidadEnTransito().replace(",",""));
                            //restar las cantidades
                            //ver si el disponible alcanza
                            //restar la cantidad del componente seleccionado al resto de los materiales
                            //preguntar si es el componente o si es del restante
//                            System.out.println("iteraCantidadDisponible " + iteraCantidadDisponible +
//                                    " iteraCantidadAUtilizar " + iteraCantidadAUtilizar +
//                                    " iteraCantidadEnTransito " + iteraCantidadEnTransito);

                            if (iteraCantidadDisponible >= selecCantidadAUtilizar) {
                                //el disponible alcanza entonces restar de disponible
                                Double cantidadDisponibleRestante = iteraCantidadDisponible - selecCantidadAUtilizar;
                                iteraComponentes.setCantidadDisponible(formato.format(cantidadDisponibleRestante));



                            //  System.out.println(" cantidadDisponibleRestante  " + cantidadDisponibleRestante.toString());

                            } else {
                                //si no le alcanza con el disponible, sumar ambos y restar
                                Double sumaDisponibleTransito = iteraCantidadDisponible + iteraCantidadEnTransito;
                                //restar de la suma lo requerido
                                Double cantidadTransitoRestante = sumaDisponibleTransito - selecCantidadAUtilizar;
                                iteraComponentes.setCantidadDisponible("0.0");
                                iteraComponentes.setCantidadEnTransito(formato.format(cantidadTransitoRestante));
                            // System.out.println(" cantidadTransitoRestante  " + cantidadTransitoRestante);


                            }

                        }
                    }

                }
            //primero verificar si le alcanza

            //se debe verificar y restar si alcanza
            // 1:disponible es mayor a cantidad a utilizar
            // 2: disponible+en Transito es mayor a cantidad a utilizar
            //primero analizar la fila seleccionada debe cumplir los dos primeros requisitos
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void devuelveCantidadesMaterial(Componente seleccionadoComponente) {
        try {
            //iterar el datatable y encontrar los materiales para preguntar si todos alcanzan
            Double selecCantidadDisponible = 0.0d;
            Double selecCantidadAUtilizar = 0.0d;
            Double selecCantidadEnTransito = 0.0d;

            Double iteraCantidadDisponible = 0.0d;
            Double iteraCantidadAUtilizar = 0.0d;
            Double iteraCantidadEnTransito = 0.0d;

            Componente iteraComponentes;
            Componente hallaComponente;

            boolean esElComponente = false;

            // recorrer los materiales del componente
            //recorrer el resto de los materiales

            for (int i = 0; i < componentesDataTable.getRowCount(); i++) {
                // solo los materiales con el codComponente
                componentesDataTable.setRowIndex(i);
                hallaComponente = (Componente) componentesDataTable.getRowData();
                //verificar que es el componente con el lote y tipo mercaderia iguales


                if (hallaComponente.getCodCompProd().equals(seleccionadoComponente.getCodCompProd()) && hallaComponente.getNombreMaterial().equals("") && hallaComponente.getCantLoteProduccion().equals(seleccionadoComponente.getCantLoteProduccion()) && hallaComponente.getNombreTipoProgramaProd().equals(seleccionadoComponente.getNombreTipoProgramaProd()) && hallaComponente.getCodTipoProgramaProd().equals(seleccionadoComponente.getCodTipoProgramaProd())) {

                    //obtenemos los datos del material
                    //luego restar
                    //selecCantidadDisponible = Double.parseDouble(hallaComponente.getCantidadDisponible());
                    selecCantidadAUtilizar = Double.parseDouble(hallaComponente.getCantidadAUtilizar().replace(",",""));
                    //selecCantidadEnTransito = Double.parseDouble(hallaComponente.getCantidadEnTransito());

                    for (int j = 0; j < componentesDataTable.getRowCount(); j++) {
                        componentesDataTable.setRowIndex(j);
                        iteraComponentes = (Componente) componentesDataTable.getRowData();
                        if (!iteraComponentes.getNombreMaterial().equals("") && iteraComponentes.getCodMaterial().equals(hallaComponente.getCodMaterial())) {

                            iteraCantidadDisponible = Double.parseDouble(iteraComponentes.getCantidadDisponible().replace(",",""));
                            iteraCantidadAUtilizar = Double.parseDouble(iteraComponentes.getCantidadAUtilizar().replace(",",""));
                            iteraCantidadEnTransito = Double.parseDouble(iteraComponentes.getCantidadEnTransito().replace(",",""));
                            //restar las cantidades
                            //ver si el disponible alcanza
                            //restar la cantidad del componente seleccionado al resto de los materiales
                            //preguntar si es el componente o si es del restante
//                            System.out.println("iteraCantidadDisponible " + iteraCantidadDisponible +
//                                    " iteraCantidadAUtilizar " + iteraCantidadAUtilizar +
//                                    " iteraCantidadEnTransito " + iteraCantidadEnTransito);

                            //preguntar si la cantidad disponible es mayor que cero


                            if (iteraCantidadDisponible > 0) {

                                //el disponible alcanza entonces restar de disponible
                                Double cantidadDisponible = iteraCantidadDisponible + selecCantidadAUtilizar;
                                iteraComponentes.setCantidadDisponible(formato.format(cantidadDisponible));


//                                System.out.println(" cantidadDisponibleRestante  " + cantidadDisponible.toString());

                            } else {
                                //la cantidad disponible es igual a cero
                                //sumar en transito y a utilizar y si sobrepasa en transito ref pasarlo a disponible



                                Double TransitoRef = Double.parseDouble(iteraComponentes.getCantidadEnTransitoRef().replace(",",""));


                                Double cantidadTransito = iteraCantidadEnTransito + selecCantidadAUtilizar;
                                if (cantidadTransito > TransitoRef) {
                                    iteraComponentes.setCantidadEnTransito(formato.format(Double.parseDouble(iteraComponentes.getCantidadEnTransitoRef().replace(",",""))));
                                    iteraComponentes.setCantidadDisponible(formato.format(cantidadTransito - TransitoRef));



                                } else {
                                    iteraComponentes.setCantidadEnTransito(formato.format(cantidadTransito));


                                }

                            }

                        }
                    }

                }
            //primero verificar si le alcanza

            //se debe verificar y restar si alcanza
            // 1:disponible es mayor a cantidad a utilizar
            // 2: disponible+en Transito es mayor a cantidad a utilizar
            //primero analizar la fila seleccionada debe cumplir los dos primeros requisitos
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void cambiaCantLoteProduccionComponente_action2(ValueChangeEvent evt) {
        if (evt.getNewValue() != null) {
            System.out.println("evt:" + evt.getNewValue().toString());



            try {

                seleccionadoComponente = new Componente();
                String consulta = "";
                double cantidadFormulaMaestra = 0.0d;
                double cantidadLote = 0.0d;

                if (componentesDataTable.getRowData() != null) {
                    seleccionadoComponente = (Componente) componentesDataTable.getRowData();
                }

                System.out.println("entro evento onchange" + seleccionadoComponente.getNombreCompProd() + "   " + seleccionadoComponente.getSeleccionadoCheck() + "  la cantidad de lote produccion " + seleccionadoComponente.getCantLoteProduccion());
                seleccionadoComponente.setCantLoteProduccion(evt.getNewValue().toString());
                cantidadLote = Double.parseDouble(seleccionadoComponente.getCantLoteProduccion().equals("") ? "0" : seleccionadoComponente.getCantLoteProduccion().replace(",",""));
                //recorrer los componentes que son similares al componente con la misma cantidad de numero de lote

                //se tiene que revisar los tres ep , es, mp para ver en donde se encuentra la cantidad
                con = (Util.openConnection(con));
                Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                Componente iteraComponentes;
                ResultSet rs = null;


                for (int i = 0; i < componentesDataTable.getRowCount(); i++) {
                    // solo los registros con el codComponente
                    componentesDataTable.setRowIndex(i);
                    iteraComponentes = (Componente) componentesDataTable.getRowData();
                    //System.out.println("valores a compara" + seleccionadoComponente.getCodCompProd() + " " + iteraComponentes.getCodCompProd());
                    if (seleccionadoComponente.getCodCompProd().equals(iteraComponentes.getCodCompProd())) {

                        //&& seleccionadoComponente.getCantLoteProduccion().equals(iteraComponentes.getCantLoteProduccion())

                        iteraComponentes.setCantLoteProduccion(seleccionadoComponente.getCantLoteProduccion());
                        iteraComponentes.setCantLoteProduccion(evt.getNewValue().toString());
                    }
                }

                if (rs != null) {
                    rs.close();
                    st.close();
                }

            } catch (Exception e) {
                e.printStackTrace();
            }

        }




    }

    public void cambiaCantLoteProduccionComponente_action(ActionEvent evt) {
        this.cambiaCantLoteProduccionComponente();
    }

    public void cambiaCantLoteProduccionComponente() {
        try {
            // FacesContext facesContext = FacesContext.getCurrentInstance();


            //componenteIdFocus = evt.getComponent().getClientId(facesContext);
            //componenteIdFocus = evt.getComponent().getParent().getClientId(facesContext);

//            System.out.println("el componente id" + componenteIdFocus + "  " + evt.getSource().getClass() + "   " + evt.getComponent().getParent().getClass().toString() + "  "
//                    +"  " +evt.getComponent().getParent().getClientId(facesContext) );
//
            Componente seleccionadoComponente = new Componente();
            String consulta = "";
            double cantidadFormulaMaestra = 0.0d;
            double cantidadLote = 0.0d;


            seleccionadoComponente = (Componente) componentesDataTable.getRowData();
            System.out.println("entro evento onchange" + seleccionadoComponente.getNombreCompProd() + "   " + seleccionadoComponente.getSeleccionadoCheck() + "  la cantidad de lote produccion " + seleccionadoComponente.getCantLoteProduccion());

            cantidadLote = Double.parseDouble(seleccionadoComponente.getCantLoteProduccion().equals("") ? "0" : seleccionadoComponente.getCantLoteProduccion().replace(",",""));
            //recorrer los componentes que son similares al componente con la misma cantidad de numero de lote

            //se tiene que revisar los tres ep , es, mp para ver en donde se encuentra la cantidad
            con = (Util.openConnection(con));
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            Componente iteraComponentes;
            ResultSet rs = null;

            for (int i = 0; i < componentesDataTable.getRowCount(); i++) {
                // solo los registros con el codComponente
                componentesDataTable.setRowIndex(i);
                iteraComponentes = (Componente) componentesDataTable.getRowData();
                if (seleccionadoComponente.getCodCompProd().equals(iteraComponentes.getCodCompProd()) && seleccionadoComponente.getNombreTipoProgramaProd().equals(iteraComponentes.getNombreTipoProgramaProd()) && seleccionadoComponente.getCodTipoProgramaProd().equals(iteraComponentes.getCodTipoProgramaProd())) {

                    //&& seleccionadoComponente.getCantLoteProduccion().equals(iteraComponentes.getCantLoteProduccion())



                    consulta = "   select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA,m.cod_grupo " +
                            " from FORMULA_MAESTRA_DETALLE_MP mp,MATERIALES m,UNIDADES_MEDIDA um " +
                            " where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA " +
                            " and mp.cod_formula_maestra = '" + iteraComponentes.getCodFormulaMaestra() + "'" +
                            " and mp.COD_MATERIAL = '" + iteraComponentes.getCodMaterial() + "' " +
                            " order by m.NOMBRE_MATERIAL ";



                    rs = st.executeQuery(consulta);

                    if (rs.next()) {
                        System.out.println("la consulta que se ejecuto para cantidad por formula maestra " + consulta);
                        cantidadFormulaMaestra = rs.getDouble("CANTIDAD");
                        iteraComponentes.setCantidadAUtilizar(formato.format(cantidadLote * cantidadFormulaMaestra));
                    }



                    consulta = "select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA,m.cod_grupo  " +
                            " from FORMULA_MAESTRA_DETALLE_MR mp,MATERIALES m,UNIDADES_MEDIDA um " +
                            " where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA and mp.cod_formula_maestra='" + iteraComponentes.getCodFormulaMaestra() + "'" +
                            " and m.COD_MATERIAL='" + iteraComponentes.getCodMaterial() + "'" +
                            " order by m.NOMBRE_MATERIAL";


                    rs = st.executeQuery(consulta);
                    if (rs.next()) {
                        System.out.println("la consulta que se ejecuto para cantidad por formula maestra " + consulta);
                        cantidadFormulaMaestra = rs.getDouble("CANTIDAD");
                        iteraComponentes.setCantidadAUtilizar(formato.format(cantidadLote * cantidadFormulaMaestra));
                    }


                    consulta = "select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA " +
                            " from FORMULA_MAESTRA_DETALLE_EP mp,MATERIALES m,UNIDADES_MEDIDA um " +
                            " where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA " +
                            " and mp.cod_formula_maestra='" + iteraComponentes.getCodFormulaMaestra() + "' and mp.COD_MATERIAL = '" + iteraComponentes.getCodMaterial() + "'" +
                            " order by m.NOMBRE_MATERIAL";


                    rs = st.executeQuery(consulta);
                    if (rs.next()) {
                        System.out.println("la consulta que se ejecuto para cantidad por formula maestra " + consulta);
                        cantidadFormulaMaestra = rs.getDouble("CANTIDAD");
                        iteraComponentes.setCantidadAUtilizar(formato.format(cantidadLote * cantidadFormulaMaestra));
                    }


                    consulta = "select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA " +
                            " from FORMULA_MAESTRA_DETALLE_EP mp,MATERIALES m,UNIDADES_MEDIDA um " +
                            " where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA " +
                            "and mp.cod_formula_maestra='" + iteraComponentes.getCodFormulaMaestra() + "' and mp.cod_material = '" + iteraComponentes.getCodMaterial() + "'" +
                            "order by m.NOMBRE_MATERIAL";


                    rs = st.executeQuery(consulta);
                    if (rs.next()) {
                        System.out.println("la consulta que se ejecuto para cantidad por formula maestra " + consulta);
                        cantidadFormulaMaestra = rs.getDouble("CANTIDAD");
                        iteraComponentes.setCantidadAUtilizar(formato.format(cantidadLote * cantidadFormulaMaestra));
                    }

                    consulta = "select m.cod_material,m.NOMBRE_MATERIAL,um.NOMBRE_UNIDAD_MEDIDA,mp.CANTIDAD,um.COD_UNIDAD_MEDIDA " +
                            " from FORMULA_MAESTRA_DETALLE_ES mp,MATERIALES m,UNIDADES_MEDIDA um " +
                            " where  m.COD_MATERIAL=mp.cod_material and um.COD_UNIDAD_MEDIDA=m.COD_UNIDAD_MEDIDA " +
                            " and mp.cod_formula_maestra='" + iteraComponentes.getCodFormulaMaestra() + "' and mp.cod_material='" + iteraComponentes.getCodMaterial() + "'" +
                            " order by m.NOMBRE_MATERIAL";


                    rs = st.executeQuery(consulta);

                    if (rs.next()) {
                        System.out.println(" la consulta que se ejecuto para cantidad por formula maestra " + consulta);
                        cantidadFormulaMaestra = rs.getDouble("CANTIDAD");
                        iteraComponentes.setCantidadAUtilizar(formato.format(cantidadLote * cantidadFormulaMaestra));
                    }

                    iteraComponentes.setCantLoteProduccion(seleccionadoComponente.getCantLoteProduccion());
                    this.sumaTotalUtilizarMaterial(iteraComponentes);

                }
            }


            if (rs != null) {
                rs.close();
                st.close();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void sumaTotalUtilizarMaterial(Componente itemComponente) {
        int i = 0;

        Componente iteraComponentes;
        Componente hallaComponente;
        try {
            //iterar el datatable y encontrar los materiales para preguntar si todos alcanzan

            Double cantidadAUtilizarTotal = 0.0d;

            for (i = 0; i < componentesDataTable.getRowCount(); i++) {
                // solo los registros con el codComponente
                componentesDataTable.setRowIndex(i);
                hallaComponente = (Componente) componentesDataTable.getRowData();

                // se halla el material del componente
                if (hallaComponente.getCodMaterial().equals(itemComponente.getCodMaterial()) && !hallaComponente.getNombreMaterial().equals("")) {
                    // se obtienen las cantidades de referencia
                    //se itera hasta encontrar al material del componente
                    //se sumaran las cantidades de los componentes que corresponden al material

                    for (int j = 0; j < componentesDataTable.getRowCount(); j++) {
                        componentesDataTable.setRowIndex(j);
                        iteraComponentes = (Componente) componentesDataTable.getRowData();


                        if (iteraComponentes.getCodMaterial().equals(hallaComponente.getCodMaterial()) && !iteraComponentes.getNombreCompProd().equals("")) {
                            cantidadAUtilizarTotal = cantidadAUtilizarTotal + Double.parseDouble(iteraComponentes.getCantidadAUtilizar().replace(",",""));

                        //System.out.println("las cantidades de total" + iteraComponentes.getCantidadAUtilizar() + " el acumulado " + cantidadAUtilizarTotal);
                        }
                    }

                    hallaComponente.setCantidadAUtilizar(formato.format(cantidadAUtilizarTotal));

                }

            }

        } catch (Exception e) {
            e.printStackTrace();
        }

    }
    public String aprobarBajoRiesgo_action(){
        try {
            System.out.println("entro aprobar bajo riesgo" + seleccionadoComponente.getCodCompProd());
            
            this.restaCantidadMaterial(seleccionadoComponente);
            this.seleccionaComponentesBajoRiesgo(seleccionadoComponente); // se seleccionan los componentes
            mensajes = "";
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public void cargaComponentesConMateriales(){
        
        //se selecciona los componentes que tiene materiales suficientes para su produccion        
        try {
            con = (Util.openConnection(con));
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            Componente filaComponente = new Componente();

            String consulta = "";
                        
            
//            consulta = " SELECT cp.cod_compprod,p.CANT_LOTE_PRODUCCION,cp.nombre_prod_semiterminado,ppd.CANTIDAD,tp.COD_TIPO_PROGRAMA_PROD,tp.NOMBRE_TIPO_PROGRAMA_PROD, " +
//                    " isnull((select ca.NOMBRE_CATEGORIACOMPPROD from  CATEGORIAS_COMPPROD ca WHERE ca.COD_CATEGORIACOMPPROD = cp.COD_CATEGORIACOMPPROD),'') as NOMBRE_CATEGORIACOMPPROD," +
//                    " p.COD_FORMULA_MAESTRA, p.COD_PRESENTACION  " +
//                    " FROM PROGRAMA_PRODUCCION p,COMPONENTES_PROD cp,PROGRAMA_PRODUCCION_DETALLE ppd,TIPOS_PROGRAMA_PRODUCCION tp " +
//                    " where p.COD_PROGRAMA_PROD='" + codProgramaProduccion + "' and p.COD_ESTADO_PROGRAMA=4 " +
//                    " and cp.COD_COMPPROD=p.COD_COMPPROD and cp.COD_COMPPROD=ppd.COD_COMPPROD " +
//                    " and ppd.COD_COMPPROD=p.COD_COMPPROD and ppd.COD_MATERIAL='" + itemComponente.getCodMaterial() + "' " +
//                    " and ppd.cod_lote_produccion=p.cod_lote_produccion and tp.COD_TIPO_PROGRAMA_PROD=p.COD_TIPO_PROGRAMA_PROD " +
//                    " and p.COD_PROGRAMA_PROD=ppd.COD_PROGRAMA_PROD ";
//
//
//            //seleccion de los materiales que no tienen cantidad suficiente
//
//            consulta=" select e.cod_material " +
//                    " from EXPLOSION_MATERIALES e,materiales m " +
//                    " where  e.cod_programa_produccion='" + codProgramaProduccion+"'" +
//                    " and e.CANTIDAD_A_UTILIZAR>(e.CANTIDAD_DISPONIBLE + e.CANTIDAD_TRANSITO)" +
//                    " and  m.cod_material=e.cod_material ORDER BY m.nombre_material";
//
//            consulta = " SELECT cp.cod_compprod,p.CANT_LOTE_PRODUCCION,cp.nombre_prod_semiterminado,ppd.CANTIDAD,tp.COD_TIPO_PROGRAMA_PROD,tp.NOMBRE_TIPO_PROGRAMA_PROD, " +
//                    " isnull((select ca.NOMBRE_CATEGORIACOMPPROD from  CATEGORIAS_COMPPROD ca WHERE ca.COD_CATEGORIACOMPPROD = cp.COD_CATEGORIACOMPPROD),'') as NOMBRE_CATEGORIACOMPPROD," +
//                    " p.COD_FORMULA_MAESTRA, p.COD_PRESENTACION " +
//                    " FROM PROGRAMA_PRODUCCION p,COMPONENTES_PROD cp,PROGRAMA_PRODUCCION_DETALLE ppd,TIPOS_PROGRAMA_PRODUCCION tp " +
//                    " where p.COD_PROGRAMA_PROD='" + codProgramaProduccion + "' and p.COD_ESTADO_PROGRAMA=4 " +
//                    " and cp.COD_COMPPROD=p.COD_COMPPROD and cp.COD_COMPPROD=ppd.COD_COMPPROD " +
//                    " and ppd.COD_COMPPROD=p.COD_COMPPROD and ppd.COD_MATERIAL in (select e.cod_material from EXPLOSION_MATERIALES e,materiales m where  e.cod_programa_produccion='" + codProgramaProduccion+"' and e.CANTIDAD_A_UTILIZAR>(e.CANTIDAD_DISPONIBLE + e.CANTIDAD_TRANSITO) " +
//                    " and  m.cod_material=e.cod_material) " +
//                    " and ppd.cod_lote_produccion=p.cod_lote_produccion and tp.COD_TIPO_PROGRAMA_PROD=p.COD_TIPO_PROGRAMA_PROD " +
//                    " and p.COD_PROGRAMA_PROD=ppd.COD_PROGRAMA_PROD ";


            consulta = " SELECT distinct p.COD_PROGRAMA_PROD,cp.cod_compprod,p.CANT_LOTE_PRODUCCION,cp.nombre_prod_semiterminado,tp.COD_TIPO_PROGRAMA_PROD,tp.NOMBRE_TIPO_PROGRAMA_PROD, " +
                    " isnull((select ca.NOMBRE_CATEGORIACOMPPROD from  CATEGORIAS_COMPPROD ca WHERE ca.COD_CATEGORIACOMPPROD = cp.COD_CATEGORIACOMPPROD),'') as NOMBRE_CATEGORIACOMPPROD," +
                    " p.COD_FORMULA_MAESTRA, p.COD_PRESENTACION,p.COD_FORMULA_MAESTRA,p.COD_LOTE_PRODUCCION  " +
                    " FROM PROGRAMA_PRODUCCION p,COMPONENTES_PROD cp,PROGRAMA_PRODUCCION_DETALLE ppd,TIPOS_PROGRAMA_PRODUCCION tp " +
                    " where p.COD_PROGRAMA_PROD='" + codProgramaProduccion + "' and p.COD_ESTADO_PROGRAMA=4 " +
                    " and cp.COD_COMPPROD=p.COD_COMPPROD and cp.COD_COMPPROD=ppd.COD_COMPPROD " +
                    " and ppd.COD_COMPPROD=p.COD_COMPPROD " +
                    " and ppd.cod_lote_produccion=p.cod_lote_produccion and tp.COD_TIPO_PROGRAMA_PROD=p.COD_TIPO_PROGRAMA_PROD " +
                    " and p.COD_PROGRAMA_PROD=ppd.COD_PROGRAMA_PROD and cp.cod_compprod not in" +
                    " (SELECT cp1.cod_compprod FROM PROGRAMA_PRODUCCION p1,COMPONENTES_PROD cp1,PROGRAMA_PRODUCCION_DETALLE ppd1,TIPOS_PROGRAMA_PRODUCCION tp1 " +
                    " where p1.COD_PROGRAMA_PROD='" + codProgramaProduccion + "' and p1.COD_ESTADO_PROGRAMA=4 " +
                    " and cp1.COD_COMPPROD=p1.COD_COMPPROD and cp1.COD_COMPPROD=ppd1.COD_COMPPROD " +
                    " and ppd1.COD_COMPPROD=p1.COD_COMPPROD and ppd1.COD_MATERIAL in (select e1.cod_material from EXPLOSION_MATERIALES e1,materiales m1 where  e1.cod_programa_produccion='" + codProgramaProduccion+"' and e1.CANTIDAD_A_UTILIZAR>(e1.CANTIDAD_DISPONIBLE + e1.CANTIDAD_TRANSITO) " +
                    " and  m1.cod_material=e1.cod_material) " +
                    " and ppd1.cod_lote_produccion=p1.cod_lote_produccion and tp1.COD_TIPO_PROGRAMA_PROD=p1.COD_TIPO_PROGRAMA_PROD " +
                    " and p1.COD_PROGRAMA_PROD=ppd1.COD_PROGRAMA_PROD )";




            System.out.println("la consulta que se ejecutara al principio para el detalle de componentes " + consulta);

            ResultSet rs = st.executeQuery(consulta);

            while (rs.next()) {
                filaComponente = new Componente();                
                //filaComponente.setCantidadDisponible(itemComponente.getCantidadDisponible()); //cantidad disponible de referencia
                //filaComponente.setCantidadEnTransito(itemComponente.getCantidadEnTransito()); // cantidad en transito de referencia
                //nombre_prod_semiterminado
                filaComponente.setCodProgramaProd(rs.getString("COD_PROGRAMA_PROD"));
                filaComponente.setCodCompProd(rs.getString("cod_compprod"));
                filaComponente.setNombreCompProd(rs.getString("nombre_prod_semiterminado"));
                filaComponente.setCantLoteProduccion(formatoEntero.format(rs.getDouble("CANT_LOTE_PRODUCCION")));
                filaComponente.setNombreTipoProgramaProd(rs.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                filaComponente.setCategoria(rs.getString("NOMBRE_CATEGORIACOMPPROD"));
                filaComponente.setCodFormulaMaestra(rs.getString("COD_FORMULA_MAESTRA"));
                filaComponente.setCodLoteProduccion(rs.getString("COD_LOTE_PRODUCCION"));
                filaComponente.setCodTipoAprobacionProgramaProduccion("1"); //aprobacion de programa produccion normal
                filaComponente.setNombreTipoAprobacionProgramaProduccion("NORMAL"); //aprobacion de programa produccion normal
                
                //this.colocaEstiloEstado(filaComponente);
                componentesConMaterialesList.add(filaComponente);
            }

            if (rs != null) {
                rs.close();
                st.close();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }


    }

    public String buscaCodTipoAprobacionProgramaProduccion(String codProgramaProduccion,String codCompProd,String codFormulaMaestra,String codLoteProduccion){
       Componente iteraComponentes = new Componente();
       String codTipoAprobacionProgramaProduccion="";
        try {

            for (int i = 0; i < componentesSiSePuedenProducirDataTable.getRowCount(); i++) {
                // solo los materiales con el codComponente
                componentesSiSePuedenProducirDataTable.setRowIndex(i);
                iteraComponentes = (Componente) componentesSiSePuedenProducirDataTable.getRowData();
                //comparacion de valores para encontrar la aprobacion del elemento

//                System.out.println("valores a comparar en la busqueda de la aprobacion de programa produccion " + iteraComponentes.getCodProgramaProd() + " = " +  codProgramaProduccion.trim() + " " +
//                        iteraComponentes.getCodCompProd()+" = " + codCompProd.trim() + " " +
//                        iteraComponentes.getCodFormulaMaestra() +" = " + codFormulaMaestra.trim() + " " +
//                        iteraComponentes.getCodLoteProduccion() +" = " + codLoteProduccion.trim() );
//                

                if(iteraComponentes.getCodProgramaProd().trim().equals(codProgramaProduccion.trim()) &&
                        iteraComponentes.getCodCompProd().trim().equals(codCompProd.trim()) &&
                        iteraComponentes.getCodFormulaMaestra().trim().equals(codFormulaMaestra.trim()) &&
                        iteraComponentes.getCodLoteProduccion().trim().equals(codLoteProduccion.trim())){
                        System.out.println("valores comparados en la busqueda de la aprobacion de programa produccion " + iteraComponentes.getCodProgramaProd() + " = " +  codProgramaProduccion.trim() + " " +
                        iteraComponentes.getCodCompProd()+" = " + codCompProd.trim() + " " +
                        iteraComponentes.getCodFormulaMaestra() +" = " + codFormulaMaestra.trim() + " " +
                        iteraComponentes.getCodLoteProduccion() +" = " + codLoteProduccion.trim() );

                        codTipoAprobacionProgramaProduccion=iteraComponentes.getCodTipoAprobacionProgramaProduccion();
                }                
                }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return codTipoAprobacionProgramaProduccion;
    }

    public String getCargarContenidoVerificarProductos(){
        try {
            HttpServletRequest request = (HttpServletRequest) FacesContext.getCurrentInstance().getExternalContext().getRequest();
            if (request.getParameter("codProgramaPeriodo") != null) {
                codProgramaProduccion = request.getParameter("codProgramaPeriodo");
            }

            con = (Util.openConnection(con));
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            this.cargarExplosionMateriales(codProgramaProduccion);

            String consulta = " select ppr.COD_COMPPROD, cp.nombre_prod_semiterminado, ppr.CANT_LOTE_PRODUCCION," +
                    " ppr.COD_LOTE_PRODUCCION,tppr.COD_TIPO_PROGRAMA_PROD,tppr.NOMBRE_TIPO_PROGRAMA_PROD, eppr.NOMBRE_ESTADO_PROGRAMA_PROD," +
                    " ppr.NRO_LOTES,ppr.COD_FORMULA_MAESTRA,cp.COD_AREA_EMPRESA " +
                    " from PROGRAMA_PRODUCCION ppr  " +
                    " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = ppr.COD_COMPPROD " +
                    " inner join TIPOS_PROGRAMA_PRODUCCION tppr on tppr.COD_TIPO_PROGRAMA_PROD = ppr.COD_TIPO_PROGRAMA_PROD " +
                    " inner join ESTADOS_PROGRAMA_PRODUCCION eppr on eppr.COD_ESTADO_PROGRAMA_PROD= ppr.COD_ESTADO_PROGRAMA " +
                    " where ppr.COD_PROGRAMA_PROD = '"+codProgramaProduccion+"' " +
                    " order by ppr.COD_COMPPROD, ppr.COD_LOTE_PRODUCCION asc ";
            
            System.out.println("consulta " + consulta);
            ResultSet rs = st.executeQuery(consulta);
            programaProduccionList.clear();
            while(rs.next()){
                ProgramaProduccion programaProduccion = new ProgramaProduccion();
                programaProduccion.setCodProgramaProduccion(codProgramaProduccion);
                programaProduccion.getFormulaMaestra().getComponentesProd().setCodCompprod(rs.getString("COD_COMPPROD"));
                programaProduccion.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(rs.getString("nombre_prod_semiterminado"));
                programaProduccion.setCantidadLote(rs.getDouble("CANT_LOTE_PRODUCCION"));
                programaProduccion.setCodLoteProduccion(rs.getString("COD_LOTE_PRODUCCION"));
                programaProduccion.getTiposProgramaProduccion().setCodTipoProgramaProd(rs.getString("COD_TIPO_PROGRAMA_PROD"));
                programaProduccion.getTiposProgramaProduccion().setNombreTipoProgramaProd(rs.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                programaProduccion.getEstadoProgramaProduccion().setNombreEstadoProgramaProd(rs.getString("NOMBRE_ESTADO_PROGRAMA_PROD"));
                programaProduccion.getFormulaMaestra().setCodFormulaMaestra(rs.getString("COD_FORMULA_MAESTRA"));
                programaProduccion.getFormulaMaestra().getComponentesProd().getAreasEmpresa().setCodAreaEmpresa(rs.getString("COD_AREA_EMPRESA"));
                programaProduccion.setNroLotes(rs.getInt("NRO_LOTES"));
                programaProduccion.setProgramaProduccionDetalleList(this.programaProduccionDetalle(programaProduccion));
                programaProduccion.setHorasHombreMaquinaList(this.programaProduccionMaquinarias(programaProduccion));
                programaProduccionList.add(programaProduccion);
            }
            st.close();
            rs.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public void cargarExplosionMateriales(String codProgramaProduccion){
        try {
            Connection con  = null;
            con = Util.openConnection(con);
            Statement st = con.createStatement();
            String consulta = " delete from explosion_materiales where cod_programa_produccion = '"+codProgramaProduccion+"' ";
            System.out.println("consulta " + consulta);
            st.executeUpdate(consulta);
            Date fecha = new Date();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/yy");

            

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
                                    "        ia.fecha_ingreso_almacen <= '2014/01/08 23:59:00' and"+
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
                                    "        ia.fecha_ingreso_almacen <= '2014/01/08 23:59:00' and"+
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
                                    "        ia.fecha_ingreso_almacen <= '2014/01/08 23:59:00' and"+
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
                                    "        ia.fecha_ingreso_almacen <= '2014/01/08 23:59:00' and"+
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
                                    "			cod_material=m.COD_MATERIAL and oc.FECHA_ENTREGA >= '2013/12/12 00:00:00'  order by oc.FECHA_EMISION asc			"+
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
    public String getCargarContenidoVerificarProductos1(){
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
            Date fechaActual = new Date();
             HttpServletRequest request = (HttpServletRequest) FacesContext.getCurrentInstance().getExternalContext().getRequest();
            if (request.getParameter("codProgramaPeriodo") != null) {
                codProgramaProduccion = request.getParameter("codProgramaPeriodo");
            }
            
            con = (Util.openConnection(con));
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            String consulta = " select TABLA.*,(cant_ingreso-cant_salida)-stock_reposicion diferencia_reposicion,(cant_ingreso-cant_salida)-stock_minimo diferencia_minima from (" +
                    " select ppr.COD_COMPPROD,  cp.nombre_prod_semiterminado,   sum(ppr.CANT_LOTE_PRODUCCION) CANT_LOTE_PRODUCCION,  tppr.COD_TIPO_PROGRAMA_PROD," +
                    " tppr.NOMBRE_TIPO_PROGRAMA_PROD,   eppr.NOMBRE_ESTADO_PROGRAMA_PROD,  ppr.COD_FORMULA_MAESTRA,  cp.COD_AREA_EMPRESA," +
                    " count(distinct(ppr.COD_LOTE_PRODUCCION)) NRO_LOTES,  (select sum(id.cantidad_unitaria)+sum(id.CANTIDAD*pp.cantidad_presentacion)" +
                    " from ingresos_detalleventas id, ingresos_ventas iv, PRESENTACIONES_PRODUCTO pp where id.cod_ingresoventas = iv.cod_ingresoventas and " +
                    " iv.COD_AREA_EMPRESA = id.COD_AREA_EMPRESA and id.cod_presentacion = prp.cod_presentacion  " +
                    " and iv.fecha_ingresoventas <= '"+sdf.format(fechaActual)+" 23:59:59' and  pp.cod_presentacion = id.cod_presentacion " +
                    " and iv.cod_estado_ingresoventas <> 2 and  iv.cod_almacen_venta in(54,56,28,27) and iv.cod_area_empresa = 1 ) cant_ingreso," +
                    " (select sum(cantidad_unitariatotal)+sum(sd.CANTIDAD_TOTAL*pp.cantidad_presentacion) from salidas_detalleventas sd, salidas_ventas sa, " +
                    " PRESENTACIONES_PRODUCTO pp where sd.cod_salidaventas = sa.cod_salidaventa and sa.COD_AREA_EMPRESA = sd.COD_AREA_EMPRESA " +
                    " and sd.cod_presentacion = prp.cod_presentacion and  sa.fecha_salidaventa <= '"+sdf.format(fechaActual)+" 23:59:59' and pp.cod_presentacion = sd.cod_presentacion " +
                    " and sa.cod_estado_salidaventa <> 2 and sa.cod_almacen_venta in (54,56,28,27) and sa.cod_area_empresa = 1) cant_salida ,prp.cod_presentacion,prp.NOMBRE_PRODUCTO_PRESENTACION, " +
                    " sp.STOCK_REPOSICION*prp.cantidad_presentacion stock_reposicion,  sp.STOCK_MINIMO*prp.cantidad_presentacion stock_minimo " +
                    " from PROGRAMA_PRODUCCION ppr inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = ppr.COD_COMPPROD " +
                    " inner join TIPOS_PROGRAMA_PRODUCCION tppr on tppr.COD_TIPO_PROGRAMA_PROD = ppr.COD_TIPO_PROGRAMA_PROD " +
                    " inner join ESTADOS_PROGRAMA_PRODUCCION eppr on  eppr.COD_ESTADO_PROGRAMA_PROD = ppr.COD_ESTADO_PROGRAMA " +
                    " inner join COMPONENTES_PRESPROD cprp on cprp.COD_COMPPROD = cp.COD_COMPPROD and cprp.COD_TIPO_PROGRAMA_PROD = tppr.COD_TIPO_PROGRAMA_PROD " +
                    " and cprp.COD_ESTADO_REGISTRO = 1 " +
                    " inner join PRESENTACIONES_PRODUCTO prp on prp.cod_presentacion = cprp.COD_PRESENTACION and prp.cod_estado_registro = 1 " +
                    " left outer join STOCK_PRESENTACIONES sp on sp.COD_PRESENTACION = prp.cod_presentacion and sp.COD_AREA_EMPRESA = 1 " +
                    " where ppr.COD_PROGRAMA_PROD = '"+codProgramaProduccion+"' group by ppr.COD_COMPPROD,cp.nombre_prod_semiterminado,tppr.COD_TIPO_PROGRAMA_PROD,tppr.NOMBRE_TIPO_PROGRAMA_PROD," +
                    " eppr.NOMBRE_ESTADO_PROGRAMA_PROD,ppr.COD_FORMULA_MAESTRA,cp.COD_AREA_EMPRESA,prp.cod_presentacion,prp.NOMBRE_PRODUCTO_PRESENTACION ,sp.STOCK_REPOSICION,sp.STOCK_MINIMO,sp.STOCK_SEGURIDAD " +
                    ",prp.cantidad_presentacion ) as tabla order by diferencia_minima,diferencia_reposicion desc ";
            System.out.println("consulta " + consulta);
            programaProduccionProductosPresentacionesList.clear();
            ResultSet rs = st.executeQuery(consulta);
            while(rs.next()){
                ProgramaProduccion programaProduccion = new ProgramaProduccion();
                programaProduccion.setCodProgramaProduccion(codProgramaProduccion);
                programaProduccion.getFormulaMaestra().getComponentesProd().setCodCompprod(rs.getString("COD_COMPPROD"));
                programaProduccion.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(rs.getString("nombre_prod_semiterminado"));
                programaProduccion.setCantidadLote(rs.getDouble("CANT_LOTE_PRODUCCION"));
                //programaProduccion.setCodLoteProduccion(rs.getString("COD_LOTE_PRODUCCION"));
                programaProduccion.getTiposProgramaProduccion().setCodTipoProgramaProd(rs.getString("COD_TIPO_PROGRAMA_PROD"));
                programaProduccion.getTiposProgramaProduccion().setNombreTipoProgramaProd(rs.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                programaProduccion.getEstadoProgramaProduccion().setNombreEstadoProgramaProd(rs.getString("NOMBRE_ESTADO_PROGRAMA_PROD"));
                programaProduccion.getFormulaMaestra().setCodFormulaMaestra(rs.getString("COD_FORMULA_MAESTRA"));
                programaProduccion.getFormulaMaestra().getComponentesProd().getAreasEmpresa().setCodAreaEmpresa(rs.getString("COD_AREA_EMPRESA"));
                programaProduccion.setNroLotes(rs.getInt("NRO_LOTES"));
                programaProduccion.getPresentacionesProducto().setCodPresentacion(rs.getString("cod_presentacion"));
                programaProduccion.getPresentacionesProducto().setNombreProductoPresentacion(rs.getString("NOMBRE_PRODUCTO_PRESENTACION"));
                programaProduccion.getPresentacionesProducto().getStockPresentaciones().setStockReposicion(rs.getDouble("stock_reposicion"));
                programaProduccion.getPresentacionesProducto().getStockPresentaciones().setStockMinimo(rs.getDouble("stock_minimo"));
                programaProduccion.getPresentacionesProducto().getStockPresentaciones().setDiferenciaReposicion(rs.getDouble("diferencia_reposicion"));
                programaProduccion.getPresentacionesProducto().getStockPresentaciones().setDiferenciaMinima(rs.getDouble("diferencia_minima"));
                programaProduccion.getPresentacionesProducto().getStockPresentaciones().setCantDisponible(rs.getDouble("cant_ingreso") - rs.getDouble("cant_salida"));
                programaProduccion.setProductosTipoProgramaProduccionList(this.cargarProgramaProduccionProductosTipoProducto(programaProduccion));
                // colocado de color de fila
                if(rs.getDouble("stock_reposicion")<=(rs.getDouble("cant_ingreso") - rs.getDouble("cant_salida"))){
                    programaProduccion.setColorFila("#00FF00"); //verde
                }
                if(rs.getDouble("stock_minimo")<=(rs.getDouble("cant_ingreso") - rs.getDouble("cant_salida")) &&  (rs.getDouble("cant_ingreso") - rs.getDouble("cant_salida"))< rs.getDouble("stock_reposicion")){
                    programaProduccion.setColorFila("#FE9A2E"); //naranja
                }
                if((rs.getDouble("cant_ingreso") - rs.getDouble("cant_salida"))< rs.getDouble("stock_minimo")){
                    programaProduccion.setColorFila("#FF0000"); //rojo
                }
                programaProduccionProductosPresentacionesList.add(programaProduccion);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public List cargarProgramaProduccionProductosTipoProducto(ProgramaProduccion programaProduccion){
        List programaProduccionList = new ArrayList();
        try {
            

            con = (Util.openConnection(con));
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            String consulta = " select ppr.COD_COMPPROD, cp.nombre_prod_semiterminado, ppr.CANT_LOTE_PRODUCCION," +
                    " ppr.COD_LOTE_PRODUCCION,tppr.COD_TIPO_PROGRAMA_PROD,tppr.NOMBRE_TIPO_PROGRAMA_PROD, eppr.NOMBRE_ESTADO_PROGRAMA_PROD," +
                    " ppr.NRO_LOTES,ppr.COD_FORMULA_MAESTRA,cp.COD_AREA_EMPRESA " +
                    " from PROGRAMA_PRODUCCION ppr  " +
                    " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = ppr.COD_COMPPROD " +
                    " inner join TIPOS_PROGRAMA_PRODUCCION tppr on tppr.COD_TIPO_PROGRAMA_PROD = ppr.COD_TIPO_PROGRAMA_PROD " +
                    " inner join ESTADOS_PROGRAMA_PRODUCCION eppr on eppr.COD_ESTADO_PROGRAMA_PROD= ppr.COD_ESTADO_PROGRAMA " +
                    " where ppr.COD_PROGRAMA_PROD = '"+programaProduccion.getCodProgramaProduccion()+"'" +
                    " and ppr.cod_tipo_programa_prod = '"+programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd() +"'" +
                    " and ppr.cod_compprod = '"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod() +"' " +
                    " order by ppr.COD_COMPPROD, ppr.COD_LOTE_PRODUCCION asc ";


            System.out.println("consulta " + consulta);
            ResultSet rs = st.executeQuery(consulta);
            programaProduccionList.clear();
            while(rs.next()){
                ProgramaProduccion programaProduccion1 = new ProgramaProduccion();
                programaProduccion1.setCodProgramaProduccion(codProgramaProduccion);
                programaProduccion1.getFormulaMaestra().getComponentesProd().setCodCompprod(rs.getString("COD_COMPPROD"));
                programaProduccion1.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(rs.getString("nombre_prod_semiterminado"));
                programaProduccion1.setCantidadLote(rs.getDouble("CANT_LOTE_PRODUCCION"));
                programaProduccion1.setCodLoteProduccion(rs.getString("COD_LOTE_PRODUCCION"));
                programaProduccion1.getTiposProgramaProduccion().setCodTipoProgramaProd(rs.getString("COD_TIPO_PROGRAMA_PROD"));
                programaProduccion1.getTiposProgramaProduccion().setNombreTipoProgramaProd(rs.getString("NOMBRE_TIPO_PROGRAMA_PROD"));
                programaProduccion1.getEstadoProgramaProduccion().setNombreEstadoProgramaProd(rs.getString("NOMBRE_ESTADO_PROGRAMA_PROD"));
                programaProduccion1.getFormulaMaestra().setCodFormulaMaestra(rs.getString("COD_FORMULA_MAESTRA"));
                programaProduccion1.getFormulaMaestra().getComponentesProd().getAreasEmpresa().setCodAreaEmpresa(rs.getString("COD_AREA_EMPRESA"));
                programaProduccion1.setNroLotes(rs.getInt("NRO_LOTES"));
                programaProduccion1.setProgramaProduccionDetalleList(this.programaProduccionDetalle(programaProduccion1));
                
                programaProduccion1.setHorasHombreMaquinaList(this.programaProduccionMaquinarias(programaProduccion1));
                
                programaProduccionList.add(programaProduccion1);
            }

            st.close();
            rs.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return programaProduccionList;
    }


    public List programaProduccionDetalle(ProgramaProduccion programaProduccion){
        List programaProduccionDetalleList = new ArrayList();
        try {
            con = (Util.openConnection(con));
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

            String consulta = " select m.COD_MATERIAL,m.NOMBRE_MATERIAL,pprd.CANTIDAD,um.COD_UNIDAD_MEDIDA,um.NOMBRE_UNIDAD_MEDIDA," +
                    " em.CANTIDAD_DISPONIBLE,em.CANTIDAD_TRANSITO " +
                    " from PROGRAMA_PRODUCCION_DETALLE pprd  " +
                    " inner join MATERIALES m on m.COD_MATERIAL= pprd.COD_MATERIAL " +
                    " inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA = pprd.COD_UNIDAD_MEDIDA " +
                    " inner join EXPLOSION_MATERIALES em on em.COD_PROGRAMA_PRODUCCION = pprd.COD_PROGRAMA_PROD " +
                    " and em.COD_MATERIAL = pprd.COD_MATERIAL " +
                    " where pprd.COD_PROGRAMA_PROD = '"+programaProduccion.getCodProgramaProduccion()+"' " +
                    " and pprd.COD_COMPPROD = '"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'" +
                    " and pprd.COD_LOTE_PRODUCCION = '"+programaProduccion.getCodLoteProduccion()+"' " +
                    " and pprd.COD_TIPO_PROGRAMA_PROD = '"+programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' ";
            System.out.println("consulta " + consulta);
            ResultSet rs = st.executeQuery(consulta);
            programaProduccionDetalleList.clear();
            while(rs.next()){
                ProgramaProduccionDetalle programaProduccionDetalle = new ProgramaProduccionDetalle();
                programaProduccionDetalle.getMateriales().setCodMaterial(rs.getString("COD_MATERIAL"));
                programaProduccionDetalle.getMateriales().setNombreMaterial(rs.getString("NOMBRE_MATERIAL"));
                programaProduccionDetalle.setCantidad(rs.getDouble("CANTIDAD"));
                programaProduccionDetalle.getUnidadesMedida().setCodUnidadMedida(rs.getString("COD_UNIDAD_MEDIDA"));
                programaProduccionDetalle.getUnidadesMedida().setNombreUnidadMedida(rs.getString("NOMBRE_UNIDAD_MEDIDA"));
                programaProduccionDetalle.setCantidadDisponible(rs.getDouble("CANTIDAD_DISPONIBLE"));
                programaProduccionDetalle.setCantidadTransito(rs.getDouble("CANTIDAD_TRANSITO"));
                programaProduccionDetalleList.add(programaProduccionDetalle);
            }
            rs.close();
            st.close();
            

        } catch (Exception e) {
            e.printStackTrace();
        }
        return programaProduccionDetalleList;
    }
    public List programaProduccionMaquinarias(ProgramaProduccion p){
        List hrsList = new ArrayList();
        try {
            Connection con = null;
            con = Util.openConnection(con);
            String consulta = " select m.COD_MAQUINA,m1.NOMBRE_MAQUINA,sum(isnull(m.HORAS_HOMBRE,0)) horas_hombre,sum(isnull(m.HORAS_MAQUINA,0)) horas_maquina" +
                    " from ACTIVIDADES_FORMULA_MAESTRA a" +
                    " inner join MAQUINARIA_ACTIVIDADES_FORMULA m on m.COD_ACTIVIDAD_FORMULA = a.COD_ACTIVIDAD_FORMULA" +
                    " inner join MAQUINARIAS m1 on m1.COD_MAQUINA = m.COD_MAQUINA" +
                    " where a.COD_FORMULA_MAESTRA = '"+p.getFormulaMaestra().getCodFormulaMaestra()+"' and a.COD_ESTADO_REGISTRO = 1 and a.COD_AREA_EMPRESA = 96" +
                    " group by m.cod_maquina,m1.NOMBRE_MAQUINA ";
            System.out.println("consulta " + consulta);
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery(consulta);
            while(rs.next()){
                HorasMaquinaHombre horasMaquinaHombre = new HorasMaquinaHombre();
                horasMaquinaHombre.getMaquinaria().setCodMaquina(rs.getString("cod_maquina"));
                horasMaquinaHombre.getMaquinaria().setNombreMaquina(rs.getString("nombre_maquina"));
                horasMaquinaHombre.setHorasHombre(rs.getDouble("horas_hombre"));
                horasMaquinaHombre.setHorasMaquina(rs.getDouble("horas_maquina"));
                horasMaquinaHombre.setHorasHDisponible(280.0);
                horasMaquinaHombre.setHorasMDisponible(280.0);
                hrsList.add(horasMaquinaHombre);
            }
        } catch (Exception e) {
        }
        return hrsList;
    }
    public String verProductosProgramaProduccionDetalle_action(){
        ProgramaProduccion programaProduccionItem = (ProgramaProduccion)programaProduccionProductosPresentacionesDataTable.getRowData();
        programaProduccionList = programaProduccionItem.getProductosTipoProgramaProduccionList();
        return null;
    }

    



    public String verProgramaProduccionDetalle_action(){
        try {
            ProgramaProduccion programaProduccionItem = (ProgramaProduccion)programaProduccionDataTable.getRowData();
            programaProduccionDetalleList = programaProduccionItem.getProgramaProduccionDetalleList();

        } catch (Exception e) {
            e.printStackTrace();
        }
       return null;
    }
    public String verHorasHombreMaquina_action(){
        try {
            ProgramaProduccion programaProduccionItem = (ProgramaProduccion)programaProduccionDataTable.getRowData();
            horasHombreMaquinaList = programaProduccionItem.getHorasHombreMaquinaList();

        } catch (Exception e) {
            e.printStackTrace();
        }
       return null;
    }
    public String seleccionarMaterial_action(){
        try {
            
            // se itera para restar del disponible
            int conDisponible = 1;
            ProgramaProduccion programaProduccion= (ProgramaProduccion)programaProduccionDataTable.getRowData();
            if(programaProduccion.getChecked().booleanValue()==true){

                Iterator i1 = programaProduccionList.iterator();
                while(i1.hasNext()){
                    ProgramaProduccion programaProduccionItem = (ProgramaProduccion)i1.next();
                    Iterator i = programaProduccion.getProgramaProduccionDetalleList().iterator();
                    while(i.hasNext()){
                    ProgramaProduccionDetalle programaProduccionDetalleItem = (ProgramaProduccionDetalle)i.next() ;
                    //se itera el detalle de los items

                    Iterator i2 = programaProduccionItem.getProgramaProduccionDetalleList().iterator();


                    while(i2.hasNext()){
                        // tratamiento de materiales
                        ProgramaProduccionDetalle programaProduccionDetalleItem1 = (ProgramaProduccionDetalle)i2.next();
                        double cantidadTotal = programaProduccionDetalleItem1.getCantidadDisponible() + programaProduccionDetalleItem1.getCantidadTransito();
                        
                        if(programaProduccionDetalleItem.getMateriales().getCodMaterial().equals(programaProduccionDetalleItem1.getMateriales().getCodMaterial())){
                           programaProduccionDetalleItem1.setCantidadDisponible(cantidadTotal- programaProduccionDetalleItem1.getCantidadTransito()-programaProduccionDetalleItem.getCantidad());
                           programaProduccionDetalleItem1.setCantidadTransito(cantidadTotal- programaProduccionDetalleItem1.getCantidadDisponible()-programaProduccionDetalleItem.getCantidad());
//                           double cantidadDisponible = programaProduccionDetalleItem1.getCantidadDisponible()-programaProduccionDetalleItem.getCantidad();
//                           cantidadDisponible = cantidadDisponible>0?cantidadDisponible:0;
//                           programaProduccionDetalleItem1.setCantidadDisponible(cantidadDisponible);
//                           programaProduccionDetalleItem1.setCantidadTransito(programaProduccionDetalleItem1.getCantidadDisponible()-programaProduccionDetalleItem.getCantidad()+programaProduccionDetalleItem1.getCantidadTransito());
                        }
                        //tratamiento de horas hombre maquina

                    }
                    if(programaProduccionDetalleItem.getCantidadDisponible()<0){
                         programaProduccionDetalleItem.setColorFila("#FF0000");
                         conDisponible = 0;
                    }else{
                         programaProduccionDetalleItem.setColorFila("#00FF00");
                         conDisponible = conDisponible==0?0:1;
                    }
                    
                    }
                    if(conDisponible==0){
                           programaProduccion.setColorFila("#FF0000"); // color rojo
                    }else{
                          programaProduccion.setColorFila("#00FF00"); // color verde
                    }

                    Iterator ii = programaProduccionItem.getHorasHombreMaquinaList().iterator();
                    while(ii.hasNext()){
                        HorasMaquinaHombre horasMaquinaHombre = (HorasMaquinaHombre)ii.next();

                        Iterator ii1 = programaProduccion.getHorasHombreMaquinaList().iterator(); //pp iterado
                        while(ii1.hasNext()){
                            HorasMaquinaHombre horasMaquinaHombre1 = (HorasMaquinaHombre)ii1.next();

                            if(horasMaquinaHombre.getMaquinaria().getCodMaquina().equals(horasMaquinaHombre1.getMaquinaria().getCodMaquina())){
                               horasMaquinaHombre.setHorasHDisponible(horasMaquinaHombre.getHorasHDisponible()-horasMaquinaHombre1.getHorasHombre());
                               horasMaquinaHombre.setHorasMDisponible(horasMaquinaHombre.getHorasMDisponible()-horasMaquinaHombre1.getHorasMaquina());
                            }
                            if(horasMaquinaHombre1.getHorasHDisponible()<0 || horasMaquinaHombre1.getHorasMDisponible()<0){
                                horasMaquinaHombre1.setColorFila("#FF0000");
                                conDisponible = 0;
                                }else{
                                horasMaquinaHombre1.setColorFila("#00FF00");
                                conDisponible = conDisponible==0?0:1;
                                }
                        }
                        
                    }
                    if(conDisponible==0){
                           programaProduccion.setColorFila("#FF0000"); // color rojo
                    }else{
                          programaProduccion.setColorFila("#00FF00"); // color verde
                    }
                }

                

//                Iterator i=programaProduccionList.iterator();
//                while(i.hasNext()){
//                    ProgramaProduccion programaProduccionItem = (ProgramaProduccion)i.next();
//                    Iterator i1 = programaProduccionItem.getProgramaProduccionDetalleList().iterator();
//                    while(i1.hasNext()){
//                        ProgramaProduccionDetalle programaProduccionDetalleItem1 = (ProgramaProduccionDetalle)i1.next();
//                        //se comparan los materiales
//                        double cantidadTotal = programaProduccionDetalleItem1.getCantidadDisponible() + programaProduccionDetalleItem1.getCantidadTransito();
//                        if(programaProduccion.getMateriales().getCodMaterial().equals(programaProduccionDetalleItem1.getMateriales().getCodMaterial())){
//
//                           programaProduccionDetalleItem1.setCantidadDisponible(cantidadTotal- programaProduccionDetalleItem1.getCantidadTransito()-programaProduccionDetalleItem1.getCantidad());
//                           programaProduccionDetalleItem1.setCantidadTransito(cantidadTotal- programaProduccionDetalleItem1.getCantidadDisponible()-programaProduccionDetalleItem1.getCantidad());
//
//                        }
//                    }
//                }

                    

            }else{
                programaProduccion.setColorFila("");
                Iterator i1 = programaProduccionList.iterator();
                while(i1.hasNext()){
                    ProgramaProduccion programaProduccionItem = (ProgramaProduccion)i1.next();                    
                    Iterator i = programaProduccion.getProgramaProduccionDetalleList().iterator();
                    while(i.hasNext()){
                    ProgramaProduccionDetalle programaProduccionDetalleItem = (ProgramaProduccionDetalle)i.next() ;
                    //se itera el detalle de los items

                    Iterator i2 = programaProduccionItem.getProgramaProduccionDetalleList().iterator();
                    while(i2.hasNext()){
                        ProgramaProduccionDetalle programaProduccionDetalleItem1 = (ProgramaProduccionDetalle)i2.next();
                        double cantidadTotal = programaProduccionDetalleItem1.getCantidadDisponible() + programaProduccionDetalleItem1.getCantidadTransito();
                        
                        if(programaProduccionDetalleItem.getMateriales().getCodMaterial().equals(programaProduccionDetalleItem1.getMateriales().getCodMaterial())){
                           programaProduccionDetalleItem1.setCantidadDisponible(cantidadTotal- programaProduccionDetalleItem1.getCantidadTransito()+programaProduccionDetalleItem.getCantidad());
                           programaProduccionDetalleItem1.setCantidadTransito(cantidadTotal- programaProduccionDetalleItem1.getCantidadDisponible()+programaProduccionDetalleItem.getCantidad());
                        }
                        programaProduccionDetalleItem1.setColorFila("");
                       
                    }

                    }

                    Iterator ii = programaProduccionItem.getHorasHombreMaquinaList().iterator();
                    while(ii.hasNext()){
                        HorasMaquinaHombre horasMaquinaHombre = (HorasMaquinaHombre)ii.next();

                        Iterator ii1 = programaProduccion.getHorasHombreMaquinaList().iterator(); //pp iterado
                        while(ii1.hasNext()){
                            HorasMaquinaHombre horasMaquinaHombre1 = (HorasMaquinaHombre)ii1.next();

                            if(horasMaquinaHombre.getMaquinaria().getCodMaquina().equals(horasMaquinaHombre1.getMaquinaria().getCodMaquina())){
                               horasMaquinaHombre.setHorasHDisponible(horasMaquinaHombre.getHorasHDisponible()+horasMaquinaHombre1.getHorasHombre());
                               horasMaquinaHombre.setHorasMDisponible(horasMaquinaHombre.getHorasMDisponible()+horasMaquinaHombre1.getHorasMaquina());
                            }
                            horasMaquinaHombre.setColorFila("");
                        }
                    }
                }

            }



            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String seleccionarProducto_action(){
        try {

            // se itera para restar del disponible
            int conDisponible = 1;
            ProgramaProduccion programaProduccion= (ProgramaProduccion)programaProduccionDataTable.getRowData();
            if(programaProduccion.getChecked().booleanValue()==true){

                Iterator i1 = programaProduccionList.iterator();
                while(i1.hasNext()){
                    ProgramaProduccion programaProduccionItem = (ProgramaProduccion)i1.next();
                    Iterator i = programaProduccion.getProgramaProduccionDetalleList().iterator();
                    while(i.hasNext()){
                    ProgramaProduccionDetalle programaProduccionDetalleItem = (ProgramaProduccionDetalle)i.next() ;
                    //se itera el detalle de los items

                    Iterator i2 = programaProduccionItem.getProgramaProduccionDetalleList().iterator();
                    while(i2.hasNext()){
                        ProgramaProduccionDetalle programaProduccionDetalleItem1 = (ProgramaProduccionDetalle)i2.next();
                        double cantidadTotal = programaProduccionDetalleItem1.getCantidadDisponible() + programaProduccionDetalleItem1.getCantidadTransito();

                        if(programaProduccionDetalleItem.getMateriales().getCodMaterial().equals(programaProduccionDetalleItem1.getMateriales().getCodMaterial())){
                           programaProduccionDetalleItem1.setCantidadDisponible(cantidadTotal- programaProduccionDetalleItem1.getCantidadTransito()-programaProduccionDetalleItem.getCantidad());
                           programaProduccionDetalleItem1.setCantidadTransito(cantidadTotal- programaProduccionDetalleItem1.getCantidadDisponible()-programaProduccionDetalleItem.getCantidad());
                        }
                    }


                    if(programaProduccionDetalleItem.getCantidadDisponible()<0){
                         programaProduccionDetalleItem.setColorFila("#FF0000");
                         conDisponible = 0;
                    }else{
                         programaProduccionDetalleItem.setColorFila("#00FF00");
                         conDisponible = conDisponible==0?0:1;
                    }

                    }
                    if(conDisponible==0){
                           programaProduccion.setColorFila("#FF0000"); // color rojo
                    }else{
                          programaProduccion.setColorFila("#00FF00"); // color verde
                    }
                }



//                Iterator i=programaProduccionList.iterator();
//                while(i.hasNext()){
//                    ProgramaProduccion programaProduccionItem = (ProgramaProduccion)i.next();
//                    Iterator i1 = programaProduccionItem.getProgramaProduccionDetalleList().iterator();
//                    while(i1.hasNext()){
//                        ProgramaProduccionDetalle programaProduccionDetalleItem1 = (ProgramaProduccionDetalle)i1.next();
//                        //se comparan los materiales
//                        double cantidadTotal = programaProduccionDetalleItem1.getCantidadDisponible() + programaProduccionDetalleItem1.getCantidadTransito();
//                        if(programaProduccion.getMateriales().getCodMaterial().equals(programaProduccionDetalleItem1.getMateriales().getCodMaterial())){
//
//                           programaProduccionDetalleItem1.setCantidadDisponible(cantidadTotal- programaProduccionDetalleItem1.getCantidadTransito()-programaProduccionDetalleItem1.getCantidad());
//                           programaProduccionDetalleItem1.setCantidadTransito(cantidadTotal- programaProduccionDetalleItem1.getCantidadDisponible()-programaProduccionDetalleItem1.getCantidad());
//
//                        }
//                    }
//                }
            }else{
                programaProduccion.setColorFila("");
                Iterator i1 = programaProduccionList.iterator();
                while(i1.hasNext()){
                    ProgramaProduccion programaProduccionItem = (ProgramaProduccion)i1.next();
                    Iterator i = programaProduccion.getProgramaProduccionDetalleList().iterator();
                    while(i.hasNext()){
                    ProgramaProduccionDetalle programaProduccionDetalleItem = (ProgramaProduccionDetalle)i.next() ;
                    //se itera el detalle de los items

                    Iterator i2 = programaProduccionItem.getProgramaProduccionDetalleList().iterator();
                    while(i2.hasNext()){
                        ProgramaProduccionDetalle programaProduccionDetalleItem1 = (ProgramaProduccionDetalle)i2.next();
                        double cantidadTotal = programaProduccionDetalleItem1.getCantidadDisponible() + programaProduccionDetalleItem1.getCantidadTransito();

                        if(programaProduccionDetalleItem.getMateriales().getCodMaterial().equals(programaProduccionDetalleItem1.getMateriales().getCodMaterial())){
                           programaProduccionDetalleItem1.setCantidadDisponible(cantidadTotal- programaProduccionDetalleItem1.getCantidadTransito()+programaProduccionDetalleItem.getCantidad());
                           programaProduccionDetalleItem1.setCantidadTransito(cantidadTotal- programaProduccionDetalleItem1.getCantidadDisponible()+programaProduccionDetalleItem.getCantidad());
                        }
                        programaProduccionDetalleItem1.setColorFila("");

                    }

                    }

                }

            }




        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public String generarLotes_action(){
        try {
            Iterator i = programaProduccionList.iterator();
            while(i.hasNext()){
                
            }
            

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String generarLotes_action1(){
        try {
            Iterator i = programaProduccionList.iterator();
            while(i.hasNext()){
                ProgramaProduccion programaProduccion = (ProgramaProduccion)i.next();
                if(programaProduccion.getChecked().booleanValue()==true){
                    // se genera el lote de acuerdo al area y al producto
                    

                }

                
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public String aprobarProgramaProduccion_action2(){
        try {
            //List programaProduccionList = new ArrayList();
            //obtenemos los lotes de los productos seleccionados para producirse
//            Iterator i1 = programaProduccionProductosPresentacionesList.iterator();
//            while(i1.hasNext()){
//                ProgramaProduccion programaProduccionProductoPresentacion = (ProgramaProduccion) i1.next();
//                if(programaProduccionProductoPresentacion.getChecked().booleanValue()==true){
//                    String consulta = " select ppr.COD_PROGRAMA_PROD,ppr.COD_COMPPROD,ppr.COD_FORMULA_MAESTRA,ppr.COD_LOTE_PRODUCCION," +
//                            " ppr.COD_TIPO_PROGRAMA_PROD " +
//                            " from PROGRAMA_PRODUCCION ppr where ppr.COD_PROGRAMA_PROD = '"+programaProduccionProductoPresentacion.getCodProgramaProduccion()+"' " +
//                            " and ppr.COD_COMPPROD = '"+programaProduccionProductoPresentacion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' " +
//                            " and ppr.COD_FORMULA_MAESTRA = '"+programaProduccionProductoPresentacion.getFormulaMaestra().getCodFormulaMaestra()+"' ";
//                    System.out.println("consulta " + consulta );
//                    con = (Util.openConnection(con));
//                    Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
//                    ResultSet rs = st.executeQuery(consulta);
//                    while(rs.next()){
//                        ProgramaProduccion programaProduccion1 = new ProgramaProduccion();
//                        programaProduccion1.setChecked(true);
//                        programaProduccion1.setCodProgramaProduccion(rs.getString("COD_PROGRAMA_PROD"));
//                        programaProduccion1.getFormulaMaestra().getComponentesProd().setCodCompprod(rs.getString("COD_COMPPROD"));
//                        programaProduccion1.getFormulaMaestra().setCodFormulaMaestra(rs.getString("COD_FORMULA_MAESTRA"));
//                        programaProduccion1.setCodLoteProduccion(rs.getString("COD_LOTE_PRODUCCION"));
//                        programaProduccion1.getTiposProgramaProduccion().setCodTipoProgramaProd(rs.getString("COD_TIPO_PROGRAMA_PROD"));
//                        programaProduccionList.add(programaProduccion1);
//                    }
//                }
//            }


            Iterator i = programaProduccionList.iterator();
            String codLoteProduccionRef = "";
            String codLoteProduccion = "";
            // se obtiene el primer lote
            while(i.hasNext()){
                ProgramaProduccion programaProduccion = (ProgramaProduccion) i.next();
                if(programaProduccion.getChecked().booleanValue()==true){
                    codLoteProduccionRef = programaProduccion.getCodLoteProduccion();
                    codLoteProduccion = this.generaCodLoteProduccion(programaProduccion); // se genera el primer lote
                    break;
                }
            }
            
            i = programaProduccionList.iterator();
            while(i.hasNext()){
                ProgramaProduccion programaProduccion = (ProgramaProduccion) i.next();
                if(programaProduccion.getChecked().booleanValue()==true){
                    System.out.println("valores comparados " + codLoteProduccionRef + " " + programaProduccion.getCodLoteProduccion() );
                    //para que se actualizen lotes del mismo conjunto de lotes
                    if(!codLoteProduccionRef.equals(programaProduccion.getCodLoteProduccion())){
                        codLoteProduccion = this.generaCodLoteProduccion(programaProduccion);
                        codLoteProduccionRef = programaProduccion.getCodLoteProduccion();                                                
                    }
                    this.actualizaLoteProgramaProduccion(programaProduccion, codLoteProduccion);
                }
            }

            this.actualizaProgramaProduccion();
            this.redireccionar("../programaProduccion/navgador_programa_periodo.jsf");


        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public void actualizaProgramaProduccion(){
        try {
            con = (Util.openConnection(con));
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = " UPDATE PROGRAMA_PRODUCCION_PERIODO  SET " +
                    " COD_ESTADO_PROGRAMA = 2 WHERE " +
                    " COD_PROGRAMA_PROD = '"+codProgramaProduccion+"'  ";
                    System.out.println("consulta " + consulta);
            st.executeUpdate(consulta);
            st.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void actualizaLoteProgramaProduccion(ProgramaProduccion programaProduccion, String codLoteProduccion){
        try {

            con = (Util.openConnection(con));
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            String consulta = " UPDATE PROGRAMA_PRODUCCION  SET COD_LOTE_PRODUCCION = '"+codLoteProduccion+"',COD_ESTADO_PROGRAMA = 2  " +
                    " where " +
                    " COD_PROGRAMA_PROD = '"+programaProduccion.getCodProgramaProduccion()+"' and " +
                    " COD_COMPPROD = '"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"'  and " +
                    " COD_FORMULA_MAESTRA = '"+programaProduccion.getFormulaMaestra().getCodFormulaMaestra()+"'  and  " +
                    " COD_LOTE_PRODUCCION = '"+programaProduccion.getCodLoteProduccion()+"'  and  " +
                    " COD_TIPO_PROGRAMA_PROD = '"+programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd()+"'  ";
            System.out.println("consulta " + consulta);
            st.executeUpdate(consulta);
            consulta = " UPDATE PROGRAMA_PRODUCCION_DETALLE SET COD_LOTE_PRODUCCION = '"+codLoteProduccion+"' " +
                    " WHERE COD_PROGRAMA_PROD = '"+programaProduccion.getCodProgramaProduccion()+"' " +
                    " AND COD_COMPPROD = '"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' " +                    
                    " AND COD_LOTE_PRODUCCION = '"+programaProduccion.getCodLoteProduccion()+"' " +
                    " AND COD_TIPO_PROGRAMA_PROD = '"+programaProduccion.getTiposProgramaProduccion().getCodTipoProgramaProd()+"' ";

            //" AND COD_FORMULA_MAESTRA = '"+programaProduccion.getFormulaMaestra().getCodFormulaMaestra()+"' " +
            System.out.println("consulta " + consulta);
            st.executeUpdate(consulta);
            st.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }



    public String generaCodLoteProduccion(ProgramaProduccion programaProduccion) {
         String codLoteProduccion="";
        try {

            con = Util.openConnection(con);

            // deducir el prefijo para la forma farmaceutica
            String consulta = " select ffl.COD_LOTE_FORMA,cp.COD_AREA_EMPRESA from COMPONENTES_PROD cp  " +
                    "  inner join FORMAS_FARMACEUTICAS ff on ff.cod_forma = cp.COD_FORMA " +
                    " inner join FORMAS_FARMACEUTICAS_LOTE ffl on ffl.COD_FORMA = ff.cod_forma " +
                    " where cp.COD_COMPPROD = "+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+" ";

            System.out.println("consulta" + consulta);
            Statement stLoteForma = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
            ResultSet rsLoteForma= stLoteForma.executeQuery(consulta);
            String codLoteForma = "";
            String codAreaEmpresa = "";
            if(rsLoteForma.next()){
                codLoteForma = rsLoteForma.getString("COD_LOTE_FORMA");
                codAreaEmpresa = rsLoteForma.getString("COD_AREA_EMPRESA");
            }

            fechaLote = new Date();

            // el mes de la gestion

            DateTime dt = new DateTime(fechaLote);



            SimpleDateFormat sdf = new SimpleDateFormat("MM");
            dt=dt.withMonthOfYear(Integer.valueOf(sdf.format(fechaLote)));
            String loteMes = "";
                if (dt.getMonthOfYear() < 10) {
                    loteMes = "0" + Integer.toString(dt.getMonthOfYear());
                } else {
                    loteMes = Integer.toString(dt.getMonthOfYear());
                }



            System.out.println("la fecha de lote que generara" +fechaLote.toString() +" lote mes " + loteMes );

            //el caso de liquidos esteriles
            if(codAreaEmpresa.equals("81") && codLoteForma.equals("1")){
                    codLoteProduccion=this.codLoteProveedorEnProgramaProduccion(programaProduccion);
            }else{
                        // el correlativo
                        consulta = " SELECT MAX(CAST(SUBSTRING(PPR.COD_LOTE_PRODUCCION,4,LEN(SUBSTRING(PPR.COD_LOTE_PRODUCCION,4,50))-1) AS INT)) +1 correlativo " +
                            " FROM PROGRAMA_PRODUCCION PPR  " +
                            " INNER JOIN COMPONENTES_PROD CP ON CP.COD_COMPPROD = PPR.COD_COMPPROD " +
                            " INNER JOIN AREAS_EMPRESA AE ON AE.COD_AREA_EMPRESA = CP.COD_AREA_EMPRESA " +
                            " INNER JOIN FORMAS_FARMACEUTICAS FF ON FF.cod_forma = CP.COD_FORMA " +
                            " WHERE PPR.COD_PROGRAMA_PROD = "+programaProduccion.getCodProgramaProduccion()+" " +
                            " AND AE.COD_AREA_EMPRESA in (select cp.COD_AREA_EMPRESA from COMPONENTES_PROD cp where cp.COD_COMPPROD = "+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+") " +
                            " AND LEN(PPR.COD_LOTE_PRODUCCION)>=6 " ;
                        //correlativo individual para oftalmicos
                            System.out.println("consulta " + consulta);
                        if(codLoteForma.equals("7")){
                            consulta = consulta + " and  CP.COD_FORMA = 25 ";
                        }
                    //el caso de inyectables

                    System.out.println("consulta" + consulta);
                    Statement stCorrelativo = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                    ResultSet rsCorrelativo= stCorrelativo.executeQuery(consulta);
                    int correlativo = 0;
                    if(rsCorrelativo.next()){
                        correlativo = rsCorrelativo.getInt("correlativo");
                    }
                    if(correlativo==0){
                        correlativo = 1;
                    }
                    String correlativoLote = "";
                    if(correlativo<10){
                        correlativoLote = "0"+String.valueOf(correlativo);
                    }else{
                        correlativoLote = String.valueOf(correlativo);
                    }

                    //calculo del año
                    dt = new DateTime(fechaLote);
                    String gestionLote = Integer.toString(dt.getYear()).substring(3, 4);

                    codLoteProduccion = codLoteForma+ loteMes + correlativoLote + gestionLote ;
                    System.out.println("codLoteProduccion " + codLoteProduccion);
            if(rsCorrelativo !=null) {
                rsCorrelativo.close();
                rsCorrelativo = null;
                stCorrelativo.close();
                stCorrelativo=null;
            }
            }

            System.out.println("codLoteProduccion " + codLoteProduccion);
            if(rsLoteForma !=null ) {
                rsLoteForma.close();
                rsLoteForma=null;
                stLoteForma.close();
                stLoteForma=null;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return codLoteProduccion;
    }

    public String codLoteProveedorEnProgramaProduccion(ProgramaProduccion programaProduccion){
            String codLote="";
            String restrColumnas="''";
        try {
            con = (Util.openConnection(con));
            Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);


            String consulta = " SELECT  DISTINCT IADE.COD_MATERIAL,IADE.LOTE_MATERIAL_PROVEEDOR,IADE.FECHA_VENCIMIENTO  " +
                    " FROM COMPONENTES_PROD CP INNER JOIN FORMULA_MAESTRA FM ON CP.COD_COMPPROD= FM.COD_COMPPROD " +
                    " INNER JOIN FORMULA_MAESTRA_DETALLE_EP FMEP ON FMEP.COD_FORMULA_MAESTRA = FM.COD_FORMULA_MAESTRA " +
                    " INNER JOIN INGRESOS_ALMACEN_DETALLE_ESTADO IADE ON IADE.COD_MATERIAL=FMEP.COD_MATERIAL " +
                    " WHERE IADE.CANTIDAD_RESTANTE>0 AND IADE.FECHA_VENCIMIENTO>=GETDATE() " +
                    " AND CP.COD_COMPPROD='"+programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' ORDER BY IADE.FECHA_VENCIMIENTO ASC ";

            //AND PPR.COD_ESTADO_PROGRAMA = 2
            
            consulta = " SELECT PPR.COD_COMPPROD,PPR.COD_FORMULA_MAESTRA,PPR.COD_LOTE_PRODUCCION " +
                    " FROM  PROGRAMA_PRODUCCION PPR WHERE  " +
                    " PPR.COD_PROGRAMA_PROD = '"+codProgramaProduccion+"' " +
                    " AND PPR.COD_COMPPROD='"+ programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' ";
            
                    System.out.println("consulta" + consulta);
            ResultSet rs = st.executeQuery(consulta);

            while (rs.next()) {
                restrColumnas = restrColumnas +",'"+ rs.getString("COD_COMPPROD") + rs.getString("COD_FORMULA_MAESTRA") + rs.getString("COD_LOTE_PRODUCCION")+"'" ;
            }

            // MAYOR O IGUAL AL TAMAÑO DE LOTE 1 = 1000

            consulta = " SELECT DISTINCT IADE.COD_MATERIAL,IADE.LOTE_MATERIAL_PROVEEDOR,IADE.FECHA_VENCIMIENTO, IADE.CANTIDAD_RESTANTE,CP.nombre_prod_semiterminado   " +
                    " FROM COMPONENTES_PROD CP INNER JOIN FORMULA_MAESTRA FM ON CP.COD_COMPPROD= FM.COD_COMPPROD   " +
                    " INNER JOIN FORMULA_MAESTRA_DETALLE_EP FMEP ON FMEP.COD_FORMULA_MAESTRA = FM.COD_FORMULA_MAESTRA   " +
                    " INNER JOIN INGRESOS_ALMACEN_DETALLE_ESTADO IADE ON IADE.COD_MATERIAL=FMEP.COD_MATERIAL   " +
                    " WHERE IADE.CANTIDAD_RESTANTE>0 AND IADE.FECHA_VENCIMIENTO>=GETDATE()   " +
                    " AND CP.COD_COMPPROD='"+ programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' " +
                    " AND convert(varchar,CP.COD_COMPPROD)+CONVERT(varchar,FM.COD_FORMULA_MAESTRA)+convert(varchar,IADE.LOTE_MATERIAL_PROVEEDOR) NOT IN("+restrColumnas+") " +
                    " ORDER BY IADE.FECHA_VENCIMIENTO ASC ";

            consulta = "select sum(iade.CANTIDAD_RESTANTE)as cantidad ,iad.cod_material, ia.COD_PROVEEDOR,isnull(iade.LOTE_MATERIAL_PROVEEDOR,'-')as LOTE_MATERIAL_PROVEEDOR,iade.FECHA_VENCIMIENTO, iade.COD_ESTADO_MATERIAL " +
                    " from INGRESOS_ALMACEN ia,INGRESOS_ALMACEN_DETALLE iad, " +
                    " INGRESOS_ALMACEN_DETALLE_ESTADO iade, proveedores p,FORMULA_MAESTRA FM,FORMULA_MAESTRA_DETALLE_EP FMDEP " +
                    " where ia.COD_INGRESO_ALMACEN=iad.COD_INGRESO_ALMACEN  " +
                    " and iad.COD_INGRESO_ALMACEN=iade.COD_INGRESO_ALMACEN  " +
                    " and ia.cod_proveedor=p.cod_proveedor  " +
                    " AND ia.cod_estado_ingreso_almacen=1 " +
                    " and iad.cod_material=iade.cod_material  " +
                    " AND FMDEP.COD_MATERIAL = IADE.COD_MATERIAL " +
                    " AND FM.COD_FORMULA_MAESTRA = FMDEP.COD_FORMULA_MAESTRA  " +
                    " and iade.CANTIDAD_RESTANTE>0 AND FM.COD_COMPPROD='"+ programaProduccion.getFormulaMaestra().getComponentesProd().getCodCompprod()+"' " +
                    " AND IADE.FECHA_VENCIMIENTO>=GETDATE() " +
                    " AND convert(varchar,FM.COD_COMPPROD)+CONVERT(varchar,FM.COD_FORMULA_MAESTRA)+convert(varchar,IADE.LOTE_MATERIAL_PROVEEDOR) NOT IN("+restrColumnas+") " +
                    " AND FMDEP.COD_MATERIAL IN ( select m1.COD_MATERIAL   from MATERIALES m1,grupos g where g.COD_GRUPO=m1.COD_GRUPO and g.COD_CAPITULO=3 ) " +
                    " GROUP BY iad.cod_material, ia.COD_PROVEEDOR,iade.LOTE_MATERIAL_PROVEEDOR,iade.FECHA_VENCIMIENTO, iade.COD_ESTADO_MATERIAL " +
                    " order by iade.FECHA_VENCIMIENTO asc ";

            System.out.println("la consulta armada " + consulta);

            rs = st.executeQuery(consulta);
            if(rs.next()){
                codLote = rs.getString("LOTE_MATERIAL_PROVEEDOR");
            }

            if(codLote.equals("")){
                        consulta= " select max(cast(SUBSTRING(p.COD_LOTE_PRODUCCION,5,LEN(p.COD_LOTE_PRODUCCION)+1) as int))+1 COD_LOTE_PRODUCCION from PROGRAMA_PRODUCCION p, componentes_prod c " +
                                        " where p.COD_PROGRAMA_PROD = " + codProgramaProduccion + " and " +
                                        " p.COD_ESTADO_PROGRAMA in (1,2,6)  and" +
                                        " c.cod_compprod=p.cod_compprod and c.cod_area_empresa in (" + programaProduccion.getFormulaMaestra().getComponentesProd().getAreasEmpresa().getCodAreaEmpresa() + ") " +
                                        " and p.COD_LOTE_PRODUCCION like 'S%' " +
                                        " union all " +
                                        " select count(*)+1 COD_LOTE_PRODUCCION from PROGRAMA_PRODUCCION p, componentes_prod c " +
                                        " where p.COD_PROGRAMA_PROD = " + codProgramaProduccion + " and " +
                                        " p.COD_ESTADO_PROGRAMA in (1,2,6)  and" +
                                        " c.cod_compprod=p.cod_compprod and c.cod_area_empresa in (" +  programaProduccion.getFormulaMaestra().getComponentesProd().getAreasEmpresa().getCodAreaEmpresa()+ ") " +
                                        " and p.COD_LOTE_PRODUCCION like 'S%' ";

                        System.out.println("consulta lote" + consulta);
                        st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
                        rs = st.executeQuery(consulta);
                        if(rs.next()){
                            codLote = "S-L " + (rs.getString("COD_LOTE_PRODUCCION")==null?"1":rs.getString("COD_LOTE_PRODUCCION"));
                        }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    return codLote;
    }

    List demandaProductosList = new ArrayList();
    HtmlDataTable demandaProductosDataTable = new HtmlDataTable();
    DemandaProductos demandaProductos = new DemandaProductos();
    List demandaProductosDetalleList = new ArrayList();
    
    
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
            String consulta = " select c.nombre_prod_semiterminado,f.CANTIDAD_LOTE,d.COD_COMPPROD,d.CANT_A_PROD_MC,d.CANT_A_PROD_MM,d.CANT_A_PROD_MI" +
                    " from DEMANDA_DEPRODUCTOSDETALLE d inner join FORMULA_MAESTRA f on f.COD_COMPPROD = d.COD_COMPPROD" +
                    " inner join componentes_prod c on c.cod_compprod = d.cod_compprod " +
                    " where d.COD_DEMANDA = '"+demandaProductos.getCodDemanda()+"' ";
            System.out.println("consulta " + consulta);
            ResultSet rs = st.executeQuery(consulta);
            while(rs.next()){
                DemandaProductosDetalle d = new DemandaProductosDetalle();
                d.getFormulaMaestra().setCantidadLote(rs.getDouble("cantidad_lote"));
                d.getFormulaMaestra().getComponentesProd().setNombreProdSemiterminado(rs.getString("nombre_prod_semiterminado"));
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

            String consulta = " select isnull(max(cod_programa_prod))+1 cod_programa_prod from programa_produccion_periodo ";
            ResultSet rs = st.executeQuery(consulta);
            int codProgramaProd = 0;
            if(rs.next()){
                codProgramaProd = rs.getInt("cod_programa_prod");
            }
            Date fecha = new Date();
            SimpleDateFormat sdf = new SimpleDateFormat();

            consulta =  " INSERT INTO PROGRAMA_PRODUCCION_PERIODO(  COD_PROGRAMA_PROD,  NOMBRE_PROGRAMA_PROD,  OBSERVACIONES,  COD_ESTADO_PROGRAMA," +
                    "  FECHA_INICIO,  FECHA_FINAL,  COD_TIPO_PRODUCCION) " +
                    "VALUES ( '"+codProgramaProd+"' ,  'DEMANDA PROGRAMA PRODUCCION',  '',  '4',  '"+sdf.format(fecha)+"',  '"+sdf.format(fecha)+"'," +
                    "  '1'); ";
            
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
                    st.executeUpdate(consulta);
                    correlativo ++;
                }
            }
            
        } catch (Exception e) {
        }
        return null;
    }
    


}
