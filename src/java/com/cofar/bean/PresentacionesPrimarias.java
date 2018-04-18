/*
 * Permiso.java
 *
 * Created on 4 de marzo de 2008, 10:08 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.List;


/**
 *
 *  @author Rene Ergueta Illanes
 *  @company COFAR
 */public class PresentacionesPrimarias {
    
    /**
     * Creates a new instance of Permiso
     */
    private String codPresentacionPrimaria="0";
    private ComponentesProd componentesProd=new ComponentesProd();
    private EnvasesPrimarios envasesPrimarios=new EnvasesPrimarios();
    private int cantidad=0;
    private Boolean checked=new Boolean(false);
    private TiposProgramaProduccion tiposProgramaProduccion = new TiposProgramaProduccion();
    private EstadoReferencial estadoReferencial = new EstadoReferencial();
    private List<DesviacionFormulaMaestraDetalleEp> desviacionFormulaMaestraDetalleEpList;
    private List<FormulaMaestraDetalleEP> formulaMaestraDetalleEPList;
    //<editor-fold desc="para desviaciones" defaultstate="collapsed">
        private Double cantidadPresentacionesPrimarias=0d;
        private Double cantidadLote=0d;
    //</editor-fold>
    public PresentacionesPrimarias() {
    }

    public ComponentesProd getComponentesProd() {
        return componentesProd;
    }

    public void setComponentesProd(ComponentesProd componentesProd) {
        this.componentesProd = componentesProd;
    }

    public EnvasesPrimarios getEnvasesPrimarios() {
        return envasesPrimarios;
    }

    public void setEnvasesPrimarios(EnvasesPrimarios envasesPrimarios) {
        this.envasesPrimarios = envasesPrimarios;
    }

    public int getCantidad() {
        return cantidad;
    }

    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
    }

    public Boolean getChecked() {
        return checked;
    }

    public void setChecked(Boolean checked) {
        this.checked = checked;
    }

    public String getCodPresentacionPrimaria() {
        return codPresentacionPrimaria;
    }

    public void setCodPresentacionPrimaria(String codPresentacionPrimaria) {
        this.codPresentacionPrimaria = codPresentacionPrimaria;
    }
        public EstadoReferencial getEstadoReferencial() {
        return estadoReferencial;
    }

    public void setEstadoReferencial(EstadoReferencial estadoReferencial) {
        this.estadoReferencial = estadoReferencial;
    }

    public TiposProgramaProduccion getTiposProgramaProduccion() {
        return tiposProgramaProduccion;
    }

    public void setTiposProgramaProduccion(TiposProgramaProduccion tiposProgramaProduccion) {
        this.tiposProgramaProduccion = tiposProgramaProduccion;
    }

    public List<DesviacionFormulaMaestraDetalleEp> getDesviacionFormulaMaestraDetalleEpList() {
        return desviacionFormulaMaestraDetalleEpList;
    }

    public void setDesviacionFormulaMaestraDetalleEpList(List<DesviacionFormulaMaestraDetalleEp> desviacionFormulaMaestraDetalleEpList) {
        this.desviacionFormulaMaestraDetalleEpList = desviacionFormulaMaestraDetalleEpList;
    }

    public int getDesviacionFormulaMaestraDetalleEpListSize()
    {
        return (this.desviacionFormulaMaestraDetalleEpList!=null?this.desviacionFormulaMaestraDetalleEpList.size():0);
    }

    public int getFormulaMaestraDetalleEPListSize() {
        return (this.formulaMaestraDetalleEPList!=null?this.formulaMaestraDetalleEPList.size():0);
    }
    
    public List<FormulaMaestraDetalleEP> getFormulaMaestraDetalleEPList() {
        return formulaMaestraDetalleEPList;
    }

    public void setFormulaMaestraDetalleEPList(List<FormulaMaestraDetalleEP> formulaMaestraDetalleEPList) {
        this.formulaMaestraDetalleEPList = formulaMaestraDetalleEPList;
    }

    public Double getCantidadPresentacionesPrimarias() {
        return cantidadPresentacionesPrimarias;
    }

    public void setCantidadPresentacionesPrimarias(Double cantidadPresentacionesPrimarias) {
        this.cantidadPresentacionesPrimarias = cantidadPresentacionesPrimarias;
    }

    public Double getCantidadLote() {
        return cantidadLote;
    }

    public void setCantidadLote(Double cantidadLote) {
        this.cantidadLote = cantidadLote;
    }
    
    
    
    
}
