/*
 * EnvasesSecundarios.java
 *
 * Created on 18 de marzo de 2008, 17:38
 */

package com.cofar.bean;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.faces.model.SelectItem;

/**
 *
 * @author Wilson Choquehuanca Gonzales
 * @company COFAR
 */
public class ProgramaProduccion extends AbstractBean implements Cloneable{
    
    /** Creates a new instance of TiposMercaderia */
    private String codProgramaProduccion="";
    private String codCompProd="";
    private String codLoteProduccion="";
    private String codLoteProduccionAnterior="";
    private String fechaInicio="";
    private String fechaFinal="";
    private String codEstadoPrograma="";
    private String observacion="";   
    private String versionLote="";
    private String  materialTransito="";
    private String styleClass="";
    private int estadoProductoSimulacion=0;
    
    
    private double cantidadLote=0;
    private double totalLote = 0;
    
    private FormulaMaestra formulaMaestra=new FormulaMaestra();
    private FormulaMaestraEsVersion formulaMaestraEsVersion=new FormulaMaestraEsVersion();
    private TiposProgramaProduccion tiposProgramaProduccion=new TiposProgramaProduccion();
    private EstadoProgramaProduccion estadoProgramaProduccion=new EstadoProgramaProduccion();
    private CategoriasCompProd categoriasCompProd=new CategoriasCompProd();
    private PresentacionesProducto presentacionesProducto = new PresentacionesProducto();
    List programaProduccionDetalleList = new ArrayList();
    private int nroLotes = 0;
    int codSecuenciaProgramaProd = 0;
    int nroCompProd = 0;
    double totalCantidadLote = 0;
    double cantRefLote = 0;
    List tiposProgramaProduccionList = new ArrayList();
    List productosTipoProgramaProduccionList = new ArrayList();
    Date fechaVencimiento = new Date();
    //inicio ale
    ProgramaProduccionPeriodo programaProduccionPeriodo = new ProgramaProduccionPeriodo();
	//final ale
    private List<SelectItem> productosList= new ArrayList<SelectItem>();
    private List lugaresAcondList = new ArrayList();
    LugaresAcond lugaresAcond = new LugaresAcond();
    private double productosPorLote = 0.0;
    List horasHombreMaquinaList = new ArrayList();
    List presentacionesProductoList = new ArrayList();
    ComponentesProd componentesProd = new ComponentesProd();
    ComponentesProdVersion componentesProdVersion=new ComponentesProdVersion();
    FormulaMaestraVersion formulaMaestraVersion = new FormulaMaestraVersion();
    int conDesviacion = 0;
    List componentesProdVersionList = new ArrayList();
    List formulaMaestraVersionList = new ArrayList();
    //para verificar si el lote ya tiene otras transacciones
    private boolean loteConRegistros=false;
    //para verificar la cantidad de salidas en baco del lote y producto
    private int cantidadSalidasBaco=0;
    

    private RegistroOOS registroOOS=new RegistroOOS();
    private Date fechaRegistro=new Date();
    //para verificar la cantidad de desviaciones del lote producto
    private int cantidadDesviaciones=0;
    //para verificar registro de emsion de om
    private EstadosProgramaProduccionImpresionOm estadosProgramaProduccionImpresionOm = new EstadosProgramaProduccionImpresionOm();
    
    
    //para registro de tiempos
    private Double horasProduccion=0d;
    private Double horasMicrobiologia=0d;
    private Double horasAcondicionamiento=0d;
    private Double horasSoporteManufactura=0d;
    private Double horasControlCalidad=0d;
    
    
    public String getCodProgramaProduccion() {
        return codProgramaProduccion;
    }

    public void setCodProgramaProduccion(String codProgramaProduccion) {
        this.codProgramaProduccion = codProgramaProduccion;
    }

    public String getCodLoteProduccion() {
        return codLoteProduccion;
    }

    public void setCodLoteProduccion(String codLoteProduccion) {
        this.codLoteProduccion = codLoteProduccion;
    }

    public String getFechaInicio() {
        return fechaInicio;
    }

    public void setFechaInicio(String fechaInicio) {
        this.fechaInicio = fechaInicio;
    }

    public String getFechaFinal() {
        return fechaFinal;
    }

    public void setFechaFinal(String fechaFinal) {
        this.fechaFinal = fechaFinal;
    }

    public String getCodEstadoPrograma() {
        return codEstadoPrograma;
    }

    public void setCodEstadoPrograma(String codEstadoPrograma) {
        this.codEstadoPrograma = codEstadoPrograma;
    }

    public String getObservacion() {
        return observacion;
    }

    public void setObservacion(String observacion) {
        this.observacion = observacion;
    }

    public FormulaMaestra getFormulaMaestra() {
        return formulaMaestra;
    }

    public void setFormulaMaestra(FormulaMaestra formulaMaestra) {
        this.formulaMaestra = formulaMaestra;
    }

    public EstadoProgramaProduccion getEstadoProgramaProduccion() {
        return estadoProgramaProduccion;
    }

    public void setEstadoProgramaProduccion(EstadoProgramaProduccion estadoProgramaProduccion) {
        this.estadoProgramaProduccion = estadoProgramaProduccion;
    }

    public double getCantidadLote() {
        return cantidadLote;
    }

    public void setCantidadLote(double cantidadLote) {
        this.cantidadLote = cantidadLote;
    }
    
    public String getVersionLote() {
        return versionLote;
    }

    public void setVersionLote(String versionLote) {
        this.versionLote = versionLote;
    }

    public int getEstadoProductoSimulacion() {
        return estadoProductoSimulacion;
    }

    public void setEstadoProductoSimulacion(int estadoProductoSimulacion) {
        this.estadoProductoSimulacion = estadoProductoSimulacion;
    }

    public String getCodCompProd() {
        return codCompProd;
    }

    public void setCodCompProd(String codCompProd) {
        this.codCompProd = codCompProd;
    }

    public String getCodLoteProduccionAnterior() {
        return codLoteProduccionAnterior;
    }

    public void setCodLoteProduccionAnterior(String codLoteProduccionAnterior) {
        this.codLoteProduccionAnterior = codLoteProduccionAnterior;
    }

    public TiposProgramaProduccion getTiposProgramaProduccion() {
        return tiposProgramaProduccion;
    }

    public void setTiposProgramaProduccion(TiposProgramaProduccion tiposProgramaProduccion) {
        this.tiposProgramaProduccion = tiposProgramaProduccion;
    }

    public CategoriasCompProd getCategoriasCompProd() {
        return categoriasCompProd;
    }

    public void setCategoriasCompProd(CategoriasCompProd categoriasCompProd) {
        this.categoriasCompProd = categoriasCompProd;
    }

    public String getMaterialTransito() {
        return materialTransito;
    }

    public void setMaterialTransito(String materialTransito) {
        this.materialTransito = materialTransito;
    }

    public String getStyleClass() {
        return styleClass;
    }

    public void setStyleClass(String styleClass) {
        this.styleClass = styleClass;
    }

    public double getTotalLote() {
        return totalLote;
    }

    public void setTotalLote(double totalLote) {
        this.totalLote = totalLote;
    }

    public PresentacionesProducto getPresentacionesProducto() {
        return presentacionesProducto;
    }

    public void setPresentacionesProducto(PresentacionesProducto presentacionesProducto) {
        this.presentacionesProducto = presentacionesProducto;
    }

    public List getProgramaProduccionDetalleList() {
        return programaProduccionDetalleList;
    }

    public void setProgramaProduccionDetalleList(List programaProduccionDetalleList) {
        this.programaProduccionDetalleList = programaProduccionDetalleList;
    }

    public int getNroLotes() {
        return nroLotes;
    }

    public void setNroLotes(int nroLotes) {
        this.nroLotes = nroLotes;
    }

    public int getCodSecuenciaProgramaProd() {
        return codSecuenciaProgramaProd;
    }

    public void setCodSecuenciaProgramaProd(int codSecuenciaProgramaProd) {
        this.codSecuenciaProgramaProd = codSecuenciaProgramaProd;
    }

    public int getNroCompProd() {
        return nroCompProd;
    }

    public void setNroCompProd(int nroCompProd) {
        this.nroCompProd = nroCompProd;
    }

    public double getTotalCantidadLote() {
        return totalCantidadLote;
    }

    public void setTotalCantidadLote(double totalCantidadLote) {
        this.totalCantidadLote = totalCantidadLote;
    }

    public double getCantRefLote() {
        return cantRefLote;
    }

    public void setCantRefLote(double cantRefLote) {
        this.cantRefLote = cantRefLote;
    }

    public List getTiposProgramaProduccionList() {
        return tiposProgramaProduccionList;
    }

    public void setTiposProgramaProduccionList(List tiposProgramaProduccionList) {
        this.tiposProgramaProduccionList = tiposProgramaProduccionList;
    }

    public List getProductosTipoProgramaProduccionList() {
        return productosTipoProgramaProduccionList;
    }

    public void setProductosTipoProgramaProduccionList(List productosTipoProgramaProduccionList) {
        this.productosTipoProgramaProduccionList = productosTipoProgramaProduccionList;
    }

    public Date getFechaVencimiento() {
        return fechaVencimiento;
    }

    public void setFechaVencimiento(Date fechaVencimiento) {
        this.fechaVencimiento = fechaVencimiento;
    }

    public ProgramaProduccionPeriodo getProgramaProduccionPeriodo() {
        return programaProduccionPeriodo;
    }

    public void setProgramaProduccionPeriodo(ProgramaProduccionPeriodo programaProduccionPeriodo) {
        this.programaProduccionPeriodo = programaProduccionPeriodo;
    }

    public List<SelectItem> getProductosList() {
        return productosList;
    }

    public void setProductosList(List<SelectItem> productosList) {
        this.productosList = productosList;
    }

    public List getLugaresAcondList() {
        return lugaresAcondList;
    }

    public void setLugaresAcondList(List lugaresAcondList) {
        this.lugaresAcondList = lugaresAcondList;
    }

    public LugaresAcond getLugaresAcond() {
        return lugaresAcond;
    }

    public void setLugaresAcond(LugaresAcond lugaresAcond) {
        this.lugaresAcond = lugaresAcond;
    }

    public double getProductosPorLote() {
        return productosPorLote;
    }

    public void setProductosPorLote(double productosPorLote) {
        this.productosPorLote = productosPorLote;
    }

    public List getHorasHombreMaquinaList() {
        return horasHombreMaquinaList;
    }

    public void setHorasHombreMaquinaList(List horasHombreMaquinaList) {
        this.horasHombreMaquinaList = horasHombreMaquinaList;
    }

    public List getPresentacionesProductoList() {
        return presentacionesProductoList;
    }

    public void setPresentacionesProductoList(List presentacionesProductoList) {
        this.presentacionesProductoList = presentacionesProductoList;
    }
    public RegistroOOS getRegistroOOS() {
        return registroOOS;
    }

    public void setRegistroOOS(RegistroOOS registroOOS) {
        this.registroOOS = registroOOS;
    }

    public ComponentesProd getComponentesProd() {
        return componentesProd;
    }

    public void setComponentesProd(ComponentesProd componentesProd) {
        this.componentesProd = componentesProd;
    }

    public ComponentesProdVersion getComponentesProdVersion() {
        return componentesProdVersion;
    }

    public void setComponentesProdVersion(ComponentesProdVersion componentesProdVersion) {
        this.componentesProdVersion = componentesProdVersion;
    }

  

    public FormulaMaestraVersion getFormulaMaestraVersion() {
        return formulaMaestraVersion;
    }

    public void setFormulaMaestraVersion(FormulaMaestraVersion formulaMaestraVersion) {
        this.formulaMaestraVersion = formulaMaestraVersion;
    }

    public int getConDesviacion() {
        return conDesviacion;
    }

    public void setConDesviacion(int conDesviacion) {
        this.conDesviacion = conDesviacion;
    }

    public List getComponentesProdVersionList() {
        return componentesProdVersionList;
    }

    public void setComponentesProdVersionList(List componentesProdVersionList) {
        this.componentesProdVersionList = componentesProdVersionList;
    }

    public List getFormulaMaestraVersionList() {
        return formulaMaestraVersionList;
    }

    public void setFormulaMaestraVersionList(List formulaMaestraVersionList) {
        this.formulaMaestraVersionList = formulaMaestraVersionList;
    }

    public boolean isLoteConRegistros() {
        return loteConRegistros;
    }

    public void setLoteConRegistros(boolean loteConRegistros) {
        this.loteConRegistros = loteConRegistros;
    }

    public Date getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(Date fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    public int getCantidadSalidasBaco() {
        return cantidadSalidasBaco;
    }

    public void setCantidadSalidasBaco(int cantidadSalidasBaco) {
        this.cantidadSalidasBaco = cantidadSalidasBaco;
    }

    public int getCantidadDesviaciones() {
        return cantidadDesviaciones;
    }

    public void setCantidadDesviaciones(int cantidadDesviaciones) {
        this.cantidadDesviaciones = cantidadDesviaciones;
    }

    
    public FormulaMaestraEsVersion getFormulaMaestraEsVersion() {
        return formulaMaestraEsVersion;
    }

    public void setFormulaMaestraEsVersion(FormulaMaestraEsVersion formulaMaestraEsVersion) {
        this.formulaMaestraEsVersion = formulaMaestraEsVersion;
    }

    public Double getHorasProduccion() {
        return horasProduccion;
    }

    public void setHorasProduccion(Double horasProduccion) {
        this.horasProduccion = horasProduccion;
    }

    public Double getHorasMicrobiologia() {
        return horasMicrobiologia;
    }

    public void setHorasMicrobiologia(Double horasMicrobiologia) {
        this.horasMicrobiologia = horasMicrobiologia;
    }

    public Double getHorasAcondicionamiento() {
        return horasAcondicionamiento;
    }

    public void setHorasAcondicionamiento(Double horasAcondicionamiento) {
        this.horasAcondicionamiento = horasAcondicionamiento;
    }

    public Double getHorasSoporteManufactura() {
        return horasSoporteManufactura;
    }

    public void setHorasSoporteManufactura(Double horasSoporteManufactura) {
        this.horasSoporteManufactura = horasSoporteManufactura;
    }

    public Double getHorasControlCalidad() {
        return horasControlCalidad;
    }

    public void setHorasControlCalidad(Double horasControlCalidad) {
        this.horasControlCalidad = horasControlCalidad;
    }

    public EstadosProgramaProduccionImpresionOm getEstadosProgramaProduccionImpresionOm() {
        return estadosProgramaProduccionImpresionOm;
    }

    public void setEstadosProgramaProduccionImpresionOm(EstadosProgramaProduccionImpresionOm estadosProgramaProduccionImpresionOm) {
        this.estadosProgramaProduccionImpresionOm = estadosProgramaProduccionImpresionOm;
    }
    
    
    
    
    

    public Object clone()
    {
        Object obj=null;
        try
        {
            obj=super.clone();
        }
        catch(CloneNotSupportedException ex)
        {
            ex.printStackTrace();
            System.out.println("no se puede clonar");
        }
        ((ProgramaProduccion)obj).setEstadoProgramaProduccion((EstadoProgramaProduccion)((ProgramaProduccion)obj).getEstadoProgramaProduccion().clone());
        ((ProgramaProduccion)obj).setTiposProgramaProduccion((TiposProgramaProduccion)((ProgramaProduccion)obj).getTiposProgramaProduccion().clone());
        ((ProgramaProduccion)obj).setFormulaMaestraVersion((FormulaMaestraVersion)((ProgramaProduccion)obj).getFormulaMaestraVersion().clone());
        ((ProgramaProduccion)obj).setPresentacionesProducto((PresentacionesProducto)((ProgramaProduccion)obj).getPresentacionesProducto().clone());
        ((ProgramaProduccion)obj).setComponentesProdVersion((ComponentesProdVersion)((ProgramaProduccion)obj).getComponentesProdVersion().clone());
        ((ProgramaProduccion)obj).setComponentesProdVersion((ComponentesProdVersion)((ProgramaProduccion)obj).getComponentesProdVersion().clone());
        ((ProgramaProduccion)obj).setLugaresAcond((LugaresAcond)((ProgramaProduccion)obj).getLugaresAcond().clone());
        ((ProgramaProduccion)obj).setComponentesProd((ComponentesProd)((ProgramaProduccion)obj).getComponentesProd().clone());
        ((ProgramaProduccion)obj).setFormulaMaestra((FormulaMaestra)((ProgramaProduccion)obj).getFormulaMaestra().clone());
        ((ProgramaProduccion)obj).setFormulaMaestraEsVersion((FormulaMaestraEsVersion)((ProgramaProduccion)obj).getFormulaMaestraEsVersion().clone());
        return obj;
    }





}
