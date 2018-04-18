/*
 * PresentacionesProducto.java
 *
 * Created on 19 de marzo de 2008, 17:38
 */

package com.cofar.bean;

import java.util.ArrayList;
import java.util.List;
import java.util.Iterator;

/**
 *
 * @author Osmar Hinojosa Miranda
 * @company COFAR
 */
public class PresentacionesProducto extends AbstractBean implements Cloneable{
    
    /** Creates a new instance of TiposMercaderia */
    private String codPresentacion="";
    private String codAnterior="";
    private Producto producto=new Producto ();
    private String cantEnvaseSecundario="";
    private EnvasesSecundarios envasesSecundarios= new EnvasesSecundarios(); 
    private EnvasesTerciarios envasesTerciarios= new EnvasesTerciarios(); 
    private LineaMKT lineaMKT=new LineaMKT();
    private String cantidadPresentacion=""; 
    private TiposMercaderia tiposMercaderia=new TiposMercaderia ();
    private CartonesCorrugados cartonesCorrugados=new CartonesCorrugados();
    private String obsPresentacion="";
    private EstadoReferencial estadoReferencial=new EstadoReferencial();
    private Boolean checked=new Boolean(false);
    private List componentesList=new ArrayList();
    private SaboresProducto saboresProducto=new SaboresProducto();
    private String nombreCompletoPresentacion="";
    private String nombreProductoPresentacion="";
    private MaterialPromocional materialPromocional=new MaterialPromocional();
    private TiposPresentacion tiposPresentacion= new TiposPresentacion();
    private CategoriasProducto categoriasProducto = new CategoriasProducto();
    private TiposProgramaProduccion tiposProgramaProduccion = new TiposProgramaProduccion();
    private StockPresentaciones stockPresentaciones = new StockPresentaciones();
    
    public PresentacionesProducto() {
        
    }

    public String getCodPresentacion() {
        return codPresentacion;
    }

    public void setCodPresentacion(String codPresentacion) {
        this.codPresentacion = codPresentacion;
    }

    public Producto getProducto() {
        return producto;
    }

    public void setProducto(Producto producto) {
        this.producto = producto;
    }

    public EnvasesSecundarios getEnvasesSecundarios() {
        return envasesSecundarios;
    }

    public void setEnvasesSecundarios(EnvasesSecundarios envasesSecundarios) {
        this.envasesSecundarios = envasesSecundarios;
    }

    public EnvasesTerciarios getEnvasesTerciarios() {
        return envasesTerciarios;
    }

    public void setEnvasesTerciarios(EnvasesTerciarios envasesTerciarios) {
        this.envasesTerciarios = envasesTerciarios;
    }

    public LineaMKT getLineaMKT() {
        return lineaMKT;
    }

    public void setLineaMKT(LineaMKT lineaMKT) {
        this.lineaMKT = lineaMKT;
    }

    public String getCantidadPresentacion() {
        return cantidadPresentacion;
    }

    public void setCantidadPresentacion(String cantidadPresentacion) {
        this.cantidadPresentacion = cantidadPresentacion;
    }

    public TiposMercaderia getTiposMercaderia() {
        return tiposMercaderia;
    }

    public void setTiposMercaderia(TiposMercaderia tiposMercaderia) {
        this.tiposMercaderia = tiposMercaderia;
    }

    public CartonesCorrugados getCartonesCorrugados() {
        return cartonesCorrugados;
    }

    public void setCartonesCorrugados(CartonesCorrugados cartonesCorrugados) {
        this.cartonesCorrugados = cartonesCorrugados;
    }

    public String getObsPresentacion() {
        return obsPresentacion;
    }

    public void setObsPresentacion(String obsPresentacion) {
        this.obsPresentacion = obsPresentacion;
    }

    public EstadoReferencial getEstadoReferencial() {
        return estadoReferencial;
    }

    public void setEstadoReferencial(EstadoReferencial estadoReferencial) {
        this.estadoReferencial = estadoReferencial;
    }

    public Boolean getChecked() {
        return checked;
    }

    public void setChecked(Boolean checked) {
        this.checked = checked;
    }

    public List getComponentesList() {
        return componentesList;
    }

    public void setComponentesList(List componentesList) {
        this.componentesList = componentesList;
    }

    public SaboresProducto getSaboresProducto() {
        return saboresProducto;
    }

    public void setSaboresProducto(SaboresProducto saboresProducto) {
        this.saboresProducto = saboresProducto;
    }

    public String getCodAnterior() {
        return codAnterior;
    }

    public void setCodAnterior(String codAnterior) {
        this.codAnterior = codAnterior;
    }

    public String getNombreCompletoPresentacion() {
        return nombreCompletoPresentacion;
    }

    public void setNombreCompletoPresentacion(String nombreCompletoPresentacion) {
        this.nombreCompletoPresentacion = nombreCompletoPresentacion;
    }

    public String getNombreProductoPresentacion() {
        return nombreProductoPresentacion;
    }

    public void setNombreProductoPresentacion(String nombreProductoPresentacion) {
        this.nombreProductoPresentacion = nombreProductoPresentacion;
    }

    public MaterialPromocional getMaterialPromocional() {
        return materialPromocional;
    }

    public void setMaterialPromocional(MaterialPromocional materialPromocional) {
        this.materialPromocional = materialPromocional;
    }

    public String getCantEnvaseSecundario() {
        return cantEnvaseSecundario;
    }

    public void setCantEnvaseSecundario(String cantEnvaseSecundario) {
        this.cantEnvaseSecundario = cantEnvaseSecundario;
    }

    public TiposPresentacion getTiposPresentacion() {
        return tiposPresentacion;
    }

    public void setTiposPresentacion(TiposPresentacion tiposPresentacion) {
        this.tiposPresentacion = tiposPresentacion;
    }


    public CategoriasProducto getCategoriasProducto() {
        return categoriasProducto;
    }

    public void setCategoriasProducto(CategoriasProducto categoriasProducto) {
        this.categoriasProducto = categoriasProducto;
    }

    public TiposProgramaProduccion getTiposProgramaProduccion() {
        return tiposProgramaProduccion;
    }

    public void setTiposProgramaProduccion(TiposProgramaProduccion tiposProgramaProduccion) {
        this.tiposProgramaProduccion = tiposProgramaProduccion;
    }

    public StockPresentaciones getStockPresentaciones() {
        return stockPresentaciones;
    }

    public void setStockPresentaciones(StockPresentaciones stockPresentaciones) {
        this.stockPresentaciones = stockPresentaciones;
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


    
    
}
