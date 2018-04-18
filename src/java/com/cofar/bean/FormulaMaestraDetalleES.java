/*
 * ComponentesProd.java
 *
 * Created on 25 de mayo de 2008, 19:26
 */

package com.cofar.bean;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Wilson Choquehuanca Gonzales
 * @company COFAR
 */
public class FormulaMaestraDetalleES extends AbstractBean {
    
    /** Creates a new instance of ComponentesProd */
    private FormulaMaestra formulaMaestra=new FormulaMaestra();
    private Materiales materiales=new Materiales();
    private Double cantidad=0d;
    private UnidadesMedida unidadesMedida=new UnidadesMedida();
    private Materiales materialAnterior = new Materiales();
    private Boolean defineNumeroLote = false;

    public FormulaMaestra getFormulaMaestra() {
        return formulaMaestra;
    }

    public void setFormulaMaestra(FormulaMaestra formulaMaestra) {
        this.formulaMaestra = formulaMaestra;
    }

    public Materiales getMateriales() {
        return materiales;
    }

    public void setMateriales(Materiales materiales) {
        this.materiales = materiales;
    }

    public Double getCantidad() {
        return cantidad;
    }

    public void setCantidad(Double cantidad) {
        this.cantidad = cantidad;
    }

    

    public UnidadesMedida getUnidadesMedida() {
        return unidadesMedida;
    }

    public void setUnidadesMedida(UnidadesMedida unidadesMedida) {
        this.unidadesMedida = unidadesMedida;
    }

    public Materiales getMaterialAnterior() {
        return materialAnterior;
    }

    public void setMaterialAnterior(Materiales materialAnterior) {
        this.materialAnterior = materialAnterior;
    }

    public Boolean getDefineNumeroLote() {
        return defineNumeroLote;
    }

    public void setDefineNumeroLote(Boolean defineNumeroLote) {
        this.defineNumeroLote = defineNumeroLote;
    }
    
    
    


}
