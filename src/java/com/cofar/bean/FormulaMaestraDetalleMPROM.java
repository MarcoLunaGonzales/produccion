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
public class FormulaMaestraDetalleMPROM extends AbstractBean {
    
    /** Creates a new instance of ComponentesProd */
    private FormulaMaestra formulaMaestra=new FormulaMaestra();
    private Materiales materiales=new Materiales();
    private String cantidad="";
    private UnidadesMedida unidadesMedida=new UnidadesMedida();

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

    public String getCantidad() {
        return cantidad;
    }

    public void setCantidad(String cantidad) {
        this.cantidad = cantidad;
    }

    public UnidadesMedida getUnidadesMedida() {
        return unidadesMedida;
    }

    public void setUnidadesMedida(UnidadesMedida unidadesMedida) {
        this.unidadesMedida = unidadesMedida;
    }

}
