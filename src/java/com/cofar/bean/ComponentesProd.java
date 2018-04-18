/*
 * ComponentesProd.java
 *
 * Created on 25 de mayo de 2008, 19:26
 */

package com.cofar.bean;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 *
 * @author Wilmer Manzaneda chavez
 * @company COFAR
 */
public class ComponentesProd extends AbstractBean implements Cloneable {

    /** Creates a new instance of ComponentesProd */
    private String nombreComercial="";
    private String codCompprod="";
    private String nombreProdSemiterminado="";
    private Producto producto=new Producto();
    private FormasFarmaceuticas forma=new FormasFarmaceuticas();
    private String concentracionForma="";
    private String codEnvaseprim="";
    private String codColorpresPrimaria="";
    private String volumenPesoEnvasePrim="";
    private String cantidadCompprod="";
    private SaboresProducto saboresProductos=new SaboresProducto();
    private PrincipiosActivosProducto principiosActivosProducto=new PrincipiosActivosProducto();
    private AccionesTerapeuticas accionesTerapeuticas=new AccionesTerapeuticas();
    private AreasEmpresa areasEmpresa=new AreasEmpresa();
    private EnvasesPrimarios envasesPrimarios=new EnvasesPrimarios();
    private ColoresPresentacion coloresPresentacion=new ColoresPresentacion();
    private EstadoCompProd estadoCompProd=new EstadoCompProd();
    private List principiosList=new ArrayList();
    private int codTemp0=0;
    private int cantidadComponente=0;
    private String codcompuestoprod="";
    private String columnStyle="";
    private String nombreGenerico="";
    private String regSanitario="";
    private int vidaUtil = 0;
    private Date fechaVencimientoRS=new Date();
    CategoriasCompProd categoriasCompProd = new CategoriasCompProd();
    private double rendimientoProducto=0d;
    private String volumenEnvasePrimario="";
    private String concentracionEnvasePrimario="";
    private String pesoEnvasePrimario="";
    private TiposProduccion tipoProduccion=new TiposProduccion();
    private String direccionArchivoSanitario="";
    private ViasAdministracionProducto viasAdministracionProducto=new ViasAdministracionProducto();
    
    private Double toleranciaVolumenfabricar=0d;
    private TiposCompProdFormato tiposCompProdFormato = new TiposCompProdFormato();
    private int nroVersionComponenteProdActivo = 0;
    private boolean productoSemiterminado=false;
    private int nroUltimaVersion = 0;
    private int codVersionActiva=0;
    private Date fechaInicioVigenciaComponentesProdActivo=new Date();
    protected TamaniosCapsulasProduccion tamaniosCapsulasProduccion=new TamaniosCapsulasProduccion();
    // mientras se revisa programa produccion
    private int codVersion = 0;
    private int nroVersion = 0;
    private int codTemp=0;
    //nuevos campos para Rs
    private CondicionesVentasProducto condicionesVentasProducto=new CondicionesVentasProducto();
    private String presentacionesRegistradasRs="";
    //para saber el tipo de modificacion
    private TiposModificacionProducto tiposModificacionProducto=new TiposModificacionProducto();
    //para asociar fm con producto
    private int codFormulaMaestra=0;
    private int codFormulaMaestraVersion=0;
    private int tamanioLoteProduccion=0;
    //<editor-fold defaultstate="collapsed" desc=" variables liquidos esteriles">
        private Double cantidadVolumen=0d;
        private Double cantidadVolumenDeDosificado=0d;
        private UnidadesMedida unidadMedidaVolumen=new UnidadesMedida();
    //</editor-fold>
    private Double pesoTeorico = 0d;
    private UnidadesMedida unidadMedidaPesoTeorico=new UnidadesMedida();
    private TiposComponentesProdVersion tiposComponentesProdVersion=new TiposComponentesProdVersion();
    private Double porcientoLimiteAlerta = 0d;
    private Double porcientoLimiteAccion = 0d;
    private TiposProduccion tiposProduccion = new TiposProduccion();
    private boolean informacionCompleta = false;
    //<editor-fold desc="variables para validar aplicacion de especificaciones de control de calidad">
        private boolean aplicaEspecificacionesQuimicas=false;
        private boolean aplicaEspecificacionesFisicas=false;
        private boolean aplicaEspecificacionesMicrobiologicas=false;
    //</editor-fold>
    //<editor-fold desc="variable para navegador de desviacion de mp" defaultstate="collapsed">
        private FormulaMaestraEsVersion formulaMaestraEsVersion;
        private List<TiposMaterialProduccion> desviacionFormulaMaestraDetalleMpList;
    //</editor-fold>
    
    public ComponentesProd() {
    }

    public String getCodCompprod() {
        return codCompprod;
    }

    public void setCodCompprod(String codCompprod) {
        this.codCompprod = codCompprod;
    }

    public Producto getProducto() {
        return producto;
    }

    public void setProducto(Producto producto) {
        this.producto = producto;
    }

    public FormasFarmaceuticas getForma() {
        return forma;
    }

    public void setForma(FormasFarmaceuticas forma) {
        this.forma = forma;
    }

    public String getConcentracionForma() {
        return concentracionForma;
    }

    public void setConcentracionForma(String concentracionForma) {
        this.concentracionForma = concentracionForma;
    }

    public String getCodEnvaseprim() {
        return codEnvaseprim;
    }

    public void setCodEnvaseprim(String codEnvaseprim) {
        this.codEnvaseprim = codEnvaseprim;
    }

    public String getCodColorpresPrimaria() {
        return codColorpresPrimaria;
    }

    public void setCodColorpresPrimaria(String codColorpresPrimaria) {
        this.codColorpresPrimaria = codColorpresPrimaria;
    }

    public String getVolumenPesoEnvasePrim() {
        return volumenPesoEnvasePrim;
    }

    public void setVolumenPesoEnvasePrim(String volumenPesoEnvasePrim) {
        this.volumenPesoEnvasePrim = volumenPesoEnvasePrim;
    }

    public String getCantidadCompprod() {
        return cantidadCompprod;
    }

    public void setCantidadCompprod(String cantidadCompprod) {
        this.cantidadCompprod = cantidadCompprod;
    }

    public SaboresProducto getSaboresProductos() {
        return saboresProductos;
    }

    public void setSaboresProductos(SaboresProducto saboresProductos) {
        this.saboresProductos = saboresProductos;
    }

    public EnvasesPrimarios getEnvasesPrimarios() {
        return envasesPrimarios;
    }

    public void setEnvasesPrimarios(EnvasesPrimarios envasesPrimarios) {
        this.envasesPrimarios = envasesPrimarios;
    }

    public ColoresPresentacion getColoresPresentacion() {

        return coloresPresentacion;
    }

    public void setColoresPresentacion(ColoresPresentacion coloresPresentacion) {
        this.coloresPresentacion = coloresPresentacion;
    }

    public AreasEmpresa getAreasEmpresa() {
        return areasEmpresa;
    }

    public void setAreasEmpresa(AreasEmpresa areasEmpresa) {
        this.areasEmpresa = areasEmpresa;
    }

    public PrincipiosActivosProducto getPrincipiosActivosProducto() {
        return principiosActivosProducto;
    }

    public void setPrincipiosActivosProducto(PrincipiosActivosProducto principiosActivosProducto) {
        this.principiosActivosProducto = principiosActivosProducto;
    }

    public List getPrincipiosList() {
        return principiosList;
    }

    public void setPrincipiosList(List principiosList) {
        this.principiosList = principiosList;
    }

    public int getCodTemp0() {
        return codTemp0;
    }

    public void setCodTemp0(int codTemp0) {
        this.codTemp0 = codTemp0;
    }

    public int getCantidadComponente() {
        return cantidadComponente;
    }

    public void setCantidadComponente(int cantidadComponente) {
        this.cantidadComponente = cantidadComponente;
    }

    public String getCodcompuestoprod() {

        return codcompuestoprod;
    }

    public void setCodcompuestoprod(String codcompuestoprod) {
        //System.out.println("setCodcompuestoprod:"+codcompuestoprod);
        this.codcompuestoprod = codcompuestoprod;
    }

    public String getColumnStyle() {
        return columnStyle;
    }

    public void setColumnStyle(String columnStyle) {
        this.columnStyle = columnStyle;
    }

    public String getNombreProdSemiterminado() {
        return nombreProdSemiterminado;
    }

    public void setNombreProdSemiterminado(String nombreProdSemiterminado) {
        this.nombreProdSemiterminado = nombreProdSemiterminado;
    }

    public String getNombreGenerico() {
        return nombreGenerico;
    }

    public void setNombreGenerico(String nombreGenerico) {
        this.nombreGenerico = nombreGenerico;
    }

    public String getRegSanitario() {
        return regSanitario;
    }

    public void setRegSanitario(String regSanitario) {
        this.regSanitario = regSanitario;
    }

    public int getVidaUtil() {
        return vidaUtil;
    }

    public void setVidaUtil(int vidaUtil) {
        this.vidaUtil = vidaUtil;
    }

   

    public AccionesTerapeuticas getAccionesTerapeuticas() {
        return accionesTerapeuticas;
    }

    public void setAccionesTerapeuticas(AccionesTerapeuticas accionesTerapeuticas) {
        this.accionesTerapeuticas = accionesTerapeuticas;
    }

    /**
     * @return the fechaVencimientoRS
     */
    public Date getFechaVencimientoRS() {
        return fechaVencimientoRS;
    }

    /**
     * @param fechaVencimientoRS the fechaVencimientoRS to set
     */
    public void setFechaVencimientoRS(Date fechaVencimientoRS) {
        this.fechaVencimientoRS = fechaVencimientoRS;
    }

    public EstadoCompProd getEstadoCompProd() {
        return estadoCompProd;
    }

    public void setEstadoCompProd(EstadoCompProd estadoCompProd) {
        this.estadoCompProd = estadoCompProd;
    }

    public CategoriasCompProd getCategoriasCompProd() {
        return categoriasCompProd;
    }

    public void setCategoriasCompProd(CategoriasCompProd categoriasCompProd) {
        this.categoriasCompProd = categoriasCompProd;
    }

    public double getRendimientoProducto() {
        return rendimientoProducto;
    }

    public void setRendimientoProducto(double rendimientoProducto) {
        this.rendimientoProducto = rendimientoProducto;
    }



    public String getConcentracionEnvasePrimario() {
        return concentracionEnvasePrimario;
    }

    public void setConcentracionEnvasePrimario(String concentracionEnvasePrimario) {
        this.concentracionEnvasePrimario = concentracionEnvasePrimario;
    }

    public String getPesoEnvasePrimario() {
        return pesoEnvasePrimario;
    }

    public void setPesoEnvasePrimario(String pesoEnvasePrimario) {
        this.pesoEnvasePrimario = pesoEnvasePrimario;
    }

    public String getVolumenEnvasePrimario() {
        return volumenEnvasePrimario;
    }

    public void setVolumenEnvasePrimario(String volumenEnvasePrimario) {
        this.volumenEnvasePrimario = volumenEnvasePrimario;
    }

    public TiposProduccion getTipoProduccion() {
        return tipoProduccion;
    }

    public void setTipoProduccion(TiposProduccion tipoProduccion) {
        this.tipoProduccion = tipoProduccion;
    }

    public String getDireccionArchivoSanitario() {
        return direccionArchivoSanitario;
    }

    public void setDireccionArchivoSanitario(String direccionArchivoSanitario) {
        this.direccionArchivoSanitario = direccionArchivoSanitario;
    }

    public ViasAdministracionProducto getViasAdministracionProducto() {
        return viasAdministracionProducto;
    }

    public void setViasAdministracionProducto(ViasAdministracionProducto viasAdministracionProducto) {
        this.viasAdministracionProducto = viasAdministracionProducto;
    }

    public Double getCantidadVolumen() {
        return cantidadVolumen;
    }

    public void setCantidadVolumen(Double cantidadVolumen) {
        this.cantidadVolumen = cantidadVolumen;
    }

    public Double getToleranciaVolumenfabricar() {
        return toleranciaVolumenfabricar;
    }

    public void setToleranciaVolumenfabricar(Double toleranciaVolumenfabricar) {
        this.toleranciaVolumenfabricar = toleranciaVolumenfabricar;
    }

    public UnidadesMedida getUnidadMedidaVolumen() {
        return unidadMedidaVolumen;
    }

    public void setUnidadMedidaVolumen(UnidadesMedida unidadMedidaVolumen) {
        this.unidadMedidaVolumen = unidadMedidaVolumen;
    }

    public TiposCompProdFormato getTiposCompProdFormato() {
        return tiposCompProdFormato;
    }

    public void setTiposCompProdFormato(TiposCompProdFormato tiposCompProdFormato) {
        this.tiposCompProdFormato = tiposCompProdFormato;
    }

   

    public int getNroUltimaVersion() {
        return nroUltimaVersion;
    }

    public void setNroUltimaVersion(int nroUltimaVersion) {
        this.nroUltimaVersion = nroUltimaVersion;
    }

    public boolean isProductoSemiterminado() {
        return productoSemiterminado;
    }

    public void setProductoSemiterminado(boolean productoSemiterminado) {
        this.productoSemiterminado = productoSemiterminado;
    }

    public int getNroVersionComponenteProdActivo() {
        return nroVersionComponenteProdActivo;
    }

    public void setNroVersionComponenteProdActivo(int nroVersionComponenteProdActivo) {
        this.nroVersionComponenteProdActivo = nroVersionComponenteProdActivo;
    }

    public Date getFechaInicioVigenciaComponentesProdActivo() {
        return fechaInicioVigenciaComponentesProdActivo;
    }

    public void setFechaInicioVigenciaComponentesProdActivo(Date fechaInicioVigenciaComponentesProdActivo) {
        this.fechaInicioVigenciaComponentesProdActivo = fechaInicioVigenciaComponentesProdActivo;
    }

    public int getCodVersionActiva() {
        return codVersionActiva;
    }

    public void setCodVersionActiva(int codVersionActiva) {
        this.codVersionActiva = codVersionActiva;
    }

    public TamaniosCapsulasProduccion getTamaniosCapsulasProduccion() {
        return tamaniosCapsulasProduccion;
    }

    public void setTamaniosCapsulasProduccion(TamaniosCapsulasProduccion tamaniosCapsulasProduccion) {
        this.tamaniosCapsulasProduccion = tamaniosCapsulasProduccion;
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
        return obj;
    }

    public int getCodTemp() {
        return codTemp;
    }

    public void setCodTemp(int codTemp) {
        this.codTemp = codTemp;
    }

    public int getCodVersion() {
        return codVersion;
    }

    public void setCodVersion(int codVersion) {
        this.codVersion = codVersion;
    }

    public int getNroVersion() {
        return nroVersion;
    }

    public void setNroVersion(int nroVersion) {
        this.nroVersion = nroVersion;
    }

    public String getNombreComercial() {
        return nombreComercial;
    }

    public void setNombreComercial(String nombreComercial) {
        this.nombreComercial = nombreComercial;
    }

    public CondicionesVentasProducto getCondicionesVentasProducto() {
        return condicionesVentasProducto;
    }

    public void setCondicionesVentasProducto(CondicionesVentasProducto condicionesVentasProducto) {
        this.condicionesVentasProducto = condicionesVentasProducto;
    }

    public String getPresentacionesRegistradasRs() {
        return presentacionesRegistradasRs;
    }

    public void setPresentacionesRegistradasRs(String presentacionesRegistradasRs) {
        this.presentacionesRegistradasRs = presentacionesRegistradasRs;
    }

    public int getCodFormulaMaestra() {
        return codFormulaMaestra;
    }

    public void setCodFormulaMaestra(int codFormulaMaestra) {
        this.codFormulaMaestra = codFormulaMaestra;
    }

    public int getCodFormulaMaestraVersion() {
        return codFormulaMaestraVersion;
    }

    public void setCodFormulaMaestraVersion(int codFormulaMaestraVersion) {
        this.codFormulaMaestraVersion = codFormulaMaestraVersion;
    }

    public int getTamanioLoteProduccion() {
        return tamanioLoteProduccion;
    }

    public void setTamanioLoteProduccion(int tamanioLoteProduccion) {
        this.tamanioLoteProduccion = tamanioLoteProduccion;
    }

    public Double getCantidadVolumenDeDosificado() {
        return cantidadVolumenDeDosificado;
    }

    public void setCantidadVolumenDeDosificado(Double cantidadVolumenDeDosificado) {
        this.cantidadVolumenDeDosificado = cantidadVolumenDeDosificado;
    }

    public TiposModificacionProducto getTiposModificacionProducto() {
        return tiposModificacionProducto;
    }

    public void setTiposModificacionProducto(TiposModificacionProducto tiposModificacionProducto) {
        this.tiposModificacionProducto = tiposModificacionProducto;
    }

    public boolean isAplicaEspecificacionesQuimicas() {
        return aplicaEspecificacionesQuimicas;
    }

    public void setAplicaEspecificacionesQuimicas(boolean aplicaEspecificacionesQuimicas) {
        this.aplicaEspecificacionesQuimicas = aplicaEspecificacionesQuimicas;
    }

    public boolean isAplicaEspecificacionesFisicas() {
        return aplicaEspecificacionesFisicas;
    }

    public void setAplicaEspecificacionesFisicas(boolean aplicaEspecificacionesFisicas) {
        this.aplicaEspecificacionesFisicas = aplicaEspecificacionesFisicas;
    }

    public boolean isAplicaEspecificacionesMicrobiologicas() {
        return aplicaEspecificacionesMicrobiologicas;
    }

    public void setAplicaEspecificacionesMicrobiologicas(boolean aplicaEspecificacionesMicrobiologicas) {
        this.aplicaEspecificacionesMicrobiologicas = aplicaEspecificacionesMicrobiologicas;
    }

    public UnidadesMedida getUnidadMedidaPesoTeorico() {
        return unidadMedidaPesoTeorico;
    }

    public void setUnidadMedidaPesoTeorico(UnidadesMedida unidadMedidaPesoTeorico) {
        this.unidadMedidaPesoTeorico = unidadMedidaPesoTeorico;
    }

    
    
    public int getDesviacionFormulaMaestraDetalleMpListSize() {
        return (this.desviacionFormulaMaestraDetalleMpList!=null?this.desviacionFormulaMaestraDetalleMpList.size():0);
    }

    public List<TiposMaterialProduccion> getDesviacionFormulaMaestraDetalleMpList() {
        return desviacionFormulaMaestraDetalleMpList;
    }

    public void setDesviacionFormulaMaestraDetalleMpList(List<TiposMaterialProduccion> desviacionFormulaMaestraDetalleMpList) {
        this.desviacionFormulaMaestraDetalleMpList = desviacionFormulaMaestraDetalleMpList;
    }

    public TiposComponentesProdVersion getTiposComponentesProdVersion() {
        return tiposComponentesProdVersion;
    }

    public void setTiposComponentesProdVersion(TiposComponentesProdVersion tiposComponentesProdVersion) {
        this.tiposComponentesProdVersion = tiposComponentesProdVersion;
    }

    public FormulaMaestraEsVersion getFormulaMaestraEsVersion() {
        return formulaMaestraEsVersion;
    }

    public void setFormulaMaestraEsVersion(FormulaMaestraEsVersion formulaMaestraEsVersion) {
        this.formulaMaestraEsVersion = formulaMaestraEsVersion;
    }

    public Double getPesoTeorico() {
        return pesoTeorico;
    }

    public void setPesoTeorico(Double pesoTeorico) {
        this.pesoTeorico = pesoTeorico;
    }

    public Double getPorcientoLimiteAlerta() {
        return porcientoLimiteAlerta;
    }

    public void setPorcientoLimiteAlerta(Double porcientoLimiteAlerta) {
        this.porcientoLimiteAlerta = porcientoLimiteAlerta;
    }

    public Double getPorcientoLimiteAccion() {
        return porcientoLimiteAccion;
    }

    public void setPorcientoLimiteAccion(Double porcientoLimiteAccion) {
        this.porcientoLimiteAccion = porcientoLimiteAccion;
    }

    public TiposProduccion getTiposProduccion() {
        return tiposProduccion;
    }

    public void setTiposProduccion(TiposProduccion tiposProduccion) {
        this.tiposProduccion = tiposProduccion;
    }

    public boolean isInformacionCompleta() {
        return informacionCompleta;
    }

    public void setInformacionCompleta(boolean informacionCompleta) {
        this.informacionCompleta = informacionCompleta;
    }

}
