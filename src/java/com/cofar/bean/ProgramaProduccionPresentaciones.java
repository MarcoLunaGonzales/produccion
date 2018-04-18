/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author hvaldivia
 */
public class ProgramaProduccionPresentaciones extends  AbstractBean {
    FormulaMaestra formulaMaestra = new FormulaMaestra();
    TiposProgramaProduccion tiposProgramaProduccion = new TiposProgramaProduccion();
    PresentacionesPrimarias presentacionesPrimarias = new PresentacionesPrimarias();
    PresentacionesProducto presentacionesProducto = new PresentacionesProducto();
    

    public FormulaMaestra getFormulaMaestra() {
        return formulaMaestra;
    }

    public void setFormulaMaestra(FormulaMaestra formulaMaestra) {
        this.formulaMaestra = formulaMaestra;
    }

    public PresentacionesPrimarias getPresentacionesPrimarias() {
        return presentacionesPrimarias;
    }

    public void setPresentacionesPrimarias(PresentacionesPrimarias presentacionesPrimarias) {
        this.presentacionesPrimarias = presentacionesPrimarias;
    }

    public PresentacionesProducto getPresentacionesProducto() {
        return presentacionesProducto;
    }

    public void setPresentacionesProducto(PresentacionesProducto presentacionesProducto) {
        this.presentacionesProducto = presentacionesProducto;
    }

    public TiposProgramaProduccion getTiposProgramaProduccion() {
        return tiposProgramaProduccion;
    }

    public void setTiposProgramaProduccion(TiposProgramaProduccion tiposProgramaProduccion) {
        this.tiposProgramaProduccion = tiposProgramaProduccion;
    }


    

}
