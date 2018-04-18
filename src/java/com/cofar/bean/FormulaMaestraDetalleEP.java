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
public class FormulaMaestraDetalleEP extends AbstractBean {
    
    /** Creates a new instance of ComponentesProd */
    private FormulaMaestra formulaMaestra=new FormulaMaestra();
    private PresentacionesPrimarias presentacionesPrimarias=new PresentacionesPrimarias();
    private Materiales materiales=new Materiales();
    private String cantidad="";
    private double cantidadUnitaria=0d;
    private double porcientoExceso=0d;
    private boolean cantidadUnitariaPorUnidadDeProducto=false;
    Materiales materialAnterior = new Materiales();
    


  
    
  
    private UnidadesMedida unidadesMedida=new UnidadesMedida();

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

    public Materiales getMaterialAnterior() {
        return materialAnterior;
    }

    public void setMaterialAnterior(Materiales materialAnterior) {
        this.materialAnterior = materialAnterior;
    }

    public boolean isCantidadUnitariaPorUnidadDeProducto() {
        return cantidadUnitariaPorUnidadDeProducto;
    }

    public void setCantidadUnitariaPorUnidadDeProducto(boolean cantidadUnitariaPorUnidadDeProducto) {
        this.cantidadUnitariaPorUnidadDeProducto = cantidadUnitariaPorUnidadDeProducto;
    }

    public double getCantidadUnitaria() {
        return cantidadUnitaria;
    }

    public void setCantidadUnitaria(double cantidadUnitaria) {
        this.cantidadUnitaria = cantidadUnitaria;
    }

    public double getPorcientoExceso() {
        return porcientoExceso;
    }

    public void setPorcientoExceso(double porcientoExceso) {
        this.porcientoExceso = porcientoExceso;
    }
    
    
  
}
