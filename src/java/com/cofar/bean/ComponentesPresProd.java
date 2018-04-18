/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.List;

/**
 *
 * @author hvaldivia
 */
public class ComponentesPresProd extends AbstractBean {
    ComponentesProd componentesProd = new ComponentesProd();
    PresentacionesProducto presentacionesProducto = new PresentacionesProducto();
    float cantCompProd = 0;
    TiposProgramaProduccion tiposProgramaProduccion = new TiposProgramaProduccion();
    EstadoReferencial estadoReferencial = new EstadoReferencial();

    private List<DesviacionFormulaMaestraDetalleEs> desviacionFormulaMaestraDetalleEsList;

    public float getCantCompProd() {
        return cantCompProd;
    }

    public void setCantCompProd(float cantCompProd) {
        this.cantCompProd = cantCompProd;
    }

    public ComponentesProd getComponentesProd() {
        return componentesProd;
    }

    public void setComponentesProd(ComponentesProd componentesProd) {
        this.componentesProd = componentesProd;
    }

    public PresentacionesProducto getPresentacionesProducto() {
        return presentacionesProducto;
    }

    public void setPresentacionesProducto(PresentacionesProducto presentacionesProducto) {
        this.presentacionesProducto = presentacionesProducto;
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

    public List<DesviacionFormulaMaestraDetalleEs> getDesviacionFormulaMaestraDetalleEsList() {
        return desviacionFormulaMaestraDetalleEsList;
    }

    public void setDesviacionFormulaMaestraDetalleEsList(List<DesviacionFormulaMaestraDetalleEs> desviacionFormulaMaestraDetalleEsList) {
        this.desviacionFormulaMaestraDetalleEsList = desviacionFormulaMaestraDetalleEsList;
    }
    
    
    


}
