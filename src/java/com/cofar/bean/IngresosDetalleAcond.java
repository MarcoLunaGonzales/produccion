/*
 * IngresosDetalleAcond.java
 *
 * Created on 23 de marzo de 2008, 18:36
 */

package com.cofar.bean;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.faces.event.ValueChangeEvent;

/**
 *
 * @author Wilmer Manzaneda chavez
 * @company COFAR
 */
public class IngresosDetalleAcond extends AbstractBean{
    
    /** Creates a new instance of IngresosDetalleAcond */
    private IngresosAcond ingresosAcondicionamiento;
    private int cantTotalIngreso = 0;
    private int cantIngresoBuenos = 0;
    private int cantIngresoFallados = 0;
    private String obsIngresoDetalleAcond="";
    private String codLoteProduccion="";
    private int cantRestante = 0;
    private int codTemp=0;
    private Date fechaVencimiento= new Date();
    private List formaFarmaceuticaList=new ArrayList();
    private ProductosFormasFar productosformas;
    private ComponentesProd componentesProd=new ComponentesProd();
    private int cantIngresoProduccion= 0;
    private Double pesoProduccion = 0d;
    private Double pesoConfirmado = 0d;
    private List cantidadEnvases=new ArrayList();
    private int cantidadEnvase = 0;
    private List tiposEnvases=new ArrayList();
    private TiposEnvase tiposEnvase=new TiposEnvase();
    private int cantidadAproximado=0;
    private String volumenPesoAproximado=""; 
    private String ingresoCantidadPeso="c";    
    private String cantAuxiliar="0";
    private String pesoAuxiliar="0";
    private String cantidadReferencial="0";    
    private int vijenciaLote=0;
    private String fechaVencimientoDetalle="";
    private Date fechaPesaje = new Date();
    
    
    private List<IngresosdetalleCantidadPeso> listadoCantidadPeso=new ArrayList<IngresosdetalleCantidadPeso>();
    
    
    /* -------------------------------------------------------------------------
     /* -------------------------------------------------------------------------
     /* -------------------------------------------------------------------------*/
     
    public IngresosDetalleAcond() {
    }
     
    public IngresosAcond getIngresosAcondicionamiento() {
        if(ingresosAcondicionamiento==null){
            ingresosAcondicionamiento=new IngresosAcond();
        }
        return ingresosAcondicionamiento;
    }
     
    public void setIngresosAcondicionamiento(IngresosAcond ingresosAcondicionamiento) {
        this.ingresosAcondicionamiento = ingresosAcondicionamiento;
    }

    public int getCantTotalIngreso() {
        return cantTotalIngreso;
    }

    public void setCantTotalIngreso(int cantTotalIngreso) {
        this.cantTotalIngreso = cantTotalIngreso;
    }

    public int getCantIngresoBuenos() {
        return cantIngresoBuenos;
    }

    public void setCantIngresoBuenos(int cantIngresoBuenos) {
        this.cantIngresoBuenos = cantIngresoBuenos;
    }

    public int getCantIngresoFallados() {
        return cantIngresoFallados;
    }

    public void setCantIngresoFallados(int cantIngresoFallados) {
        this.cantIngresoFallados = cantIngresoFallados;
    }
     
     
    public String getObsIngresoDetalleAcond() {
        return obsIngresoDetalleAcond;
    }
     
    public void setObsIngresoDetalleAcond(String obsIngresoDetalleAcond) {
        this.obsIngresoDetalleAcond = obsIngresoDetalleAcond;
    }
    public int getCodTemp() {
        return codTemp;
    }
     
    public void setCodTemp(int codTemp) {
        this.codTemp = codTemp;
    }
     
    public String getCodLoteProduccion() {
        return codLoteProduccion;
    }
     
    public void setCodLoteProduccion(String codLoteProduccion) {
        this.codLoteProduccion = codLoteProduccion;
    }
     
    public List getFormaFarmaceuticaList() {
        return formaFarmaceuticaList;
    }
     
    public void setFormaFarmaceuticaList(List formaFarmaceuticaList) {
        this.formaFarmaceuticaList = formaFarmaceuticaList;
    }
    public Date getFechaVencimiento() {
        return fechaVencimiento;
    }
     
    public void setFechaVencimiento(Date fechaVencimiento) {
        this.fechaVencimiento = fechaVencimiento;
    }
     
    public ProductosFormasFar getProductosformas() {
        if(productosformas==null)
            productosformas=new ProductosFormasFar();
     
        return productosformas;
    }
     
    public void setProductosformas(ProductosFormasFar productosformas) {
        this.productosformas = productosformas;
    }

    public int getCantRestante() {
        return cantRestante;
    }

    public void setCantRestante(int cantRestante) {
        this.cantRestante = cantRestante;
    }
     
    public ComponentesProd getComponentesProd() {
        return componentesProd;
    }
     
    public void setComponentesProd(ComponentesProd componentesProd) {
        this.componentesProd = componentesProd;
    }

    public int getCantIngresoProduccion() {
        return cantIngresoProduccion;
    }

    public void setCantIngresoProduccion(int cantIngresoProduccion) {
        this.cantIngresoProduccion = cantIngresoProduccion;
    }

    public Double getPesoProduccion() {
        return pesoProduccion;
    }

    public void setPesoProduccion(Double pesoProduccion) {
        this.pesoProduccion = pesoProduccion;
    }

    public Double getPesoConfirmado() {
        return pesoConfirmado;
    }

    public void setPesoConfirmado(Double pesoConfirmado) {
        this.pesoConfirmado = pesoConfirmado;
    }
    
    public List getCantidadEnvases() {
        return cantidadEnvases;
    }
     
    public void setCantidadEnvases(List cantidadEnvases) {
        this.cantidadEnvases = cantidadEnvases;
    }
     
    public List getTiposEnvases() {
        return tiposEnvases;
    }
     
    public void setTiposEnvases(List tiposEnvases) {
        this.tiposEnvases = tiposEnvases;
    }
     
    public TiposEnvase getTiposEnvase() {
        return tiposEnvase;
    }
     
    public void setTiposEnvase(TiposEnvase tiposEnvase) {
        this.tiposEnvase = tiposEnvase;
    }

    public int getCantidadEnvase() {
        return cantidadEnvase;
    }

    public void setCantidadEnvase(int cantidadEnvase) {
        this.cantidadEnvase = cantidadEnvase;
    }
     
    
    public String getVolumenPesoAproximado() {
        return volumenPesoAproximado;
    }
     
    public void setVolumenPesoAproximado(String volumenPesoAproximado) {
        this.volumenPesoAproximado = volumenPesoAproximado;
    }
     
    public int getCantidadAproximado() {
        return cantidadAproximado;
    }
     
    public void setCantidadAproximado(int cantidadAproximado) {
        this.cantidadAproximado = cantidadAproximado;
    }

    public String getIngresoCantidadPeso() {
        return ingresoCantidadPeso;
    }

    public void setIngresoCantidadPeso(String ingresoCantidadPeso) {
        this.ingresoCantidadPeso = ingresoCantidadPeso;
    }

    public String getCantAuxiliar() {
        return cantAuxiliar;
    }

    public void setCantAuxiliar(String cantAuxiliar) {
        this.cantAuxiliar = cantAuxiliar;
    }

    public String getPesoAuxiliar() {
        return pesoAuxiliar;
    }

    public void setPesoAuxiliar(String pesoAuxiliar) {
        this.pesoAuxiliar = pesoAuxiliar;
    }

    public String getCantidadReferencial() {
        return cantidadReferencial;
    }

    public void setCantidadReferencial(String cantidadReferencial) {
        this.cantidadReferencial = cantidadReferencial;
    }

    public int getVijenciaLote() {
        return vijenciaLote;
    }

    public void setVijenciaLote(int vijenciaLote) {
        this.vijenciaLote = vijenciaLote;
    }

    public String getFechaVencimientoDetalle() {
        return fechaVencimientoDetalle;
    }

    public void setFechaVencimientoDetalle(String fechaVencimientoDetalle) {
        this.fechaVencimientoDetalle = fechaVencimientoDetalle;
    }

    public List<IngresosdetalleCantidadPeso> getListadoCantidadPeso() {
        return listadoCantidadPeso;
    }

    public void setListadoCantidadPeso(List<IngresosdetalleCantidadPeso> listadoCantidadPeso) {
        this.listadoCantidadPeso = listadoCantidadPeso;
    }

    public Date getFechaPesaje() {
        return fechaPesaje;
    }

    public void setFechaPesaje(Date fechaPesaje) {
        this.fechaPesaje = fechaPesaje;
    }

    

   

}
