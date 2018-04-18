/*
 * EnvasesSecundarios.java
 *
 * Created on 18 de marzo de 2008, 17:38
 */

package com.cofar.bean;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Wilson Choquehuanca Gonzales
 * @company COFAR
 */
public class ProgramaProduccionDetalle extends AbstractBean{
    
    /** Creates a new instance of TiposMercaderia */
    
    private ProgramaProduccion programaProduccion=new ProgramaProduccion();
    private Materiales materiales=new Materiales();
    private UnidadesMedida unidadesMedida=new UnidadesMedida();
    private double cantidad = 0 ;
    double cantidadDisponible = 0;
    double cantidadTransito = 0;
    private TiposMaterialProduccion tiposMaterialProduccion = new TiposMaterialProduccion();
    Materiales materialAnterior = new Materiales();
    
    List<ProgramaProduccionDetalleFracciones> fraccionesDetalleList = new ArrayList<ProgramaProduccionDetalleFracciones>();

    

    

    public double getCantidad() {
        return cantidad;
    }

    public void setCantidad(double cantidad) {
        this.cantidad = cantidad;
    }

    public double getCantidadDisponible() {
        return cantidadDisponible;
    }

    public void setCantidadDisponible(double cantidadDisponible) {
        this.cantidadDisponible = cantidadDisponible;
    }

    public double getCantidadTransito() {
        return cantidadTransito;
    }

    public void setCantidadTransito(double cantidadTransito) {
        this.cantidadTransito = cantidadTransito;
    }

    public Materiales getMaterialAnterior() {
        return materialAnterior;
    }

    public void setMaterialAnterior(Materiales materialAnterior) {
        this.materialAnterior = materialAnterior;
    }

    public Materiales getMateriales() {
        return materiales;
    }

    public void setMateriales(Materiales materiales) {
        this.materiales = materiales;
    }

    public ProgramaProduccion getProgramaProduccion() {
        return programaProduccion;
    }

    public void setProgramaProduccion(ProgramaProduccion programaProduccion) {
        this.programaProduccion = programaProduccion;
    }

    public TiposMaterialProduccion getTiposMaterialProduccion() {
        return tiposMaterialProduccion;
    }

    public void setTiposMaterialProduccion(TiposMaterialProduccion tiposMaterialProduccion) {
        this.tiposMaterialProduccion = tiposMaterialProduccion;
    }

    public UnidadesMedida getUnidadesMedida() {
        return unidadesMedida;
    }

    public void setUnidadesMedida(UnidadesMedida unidadesMedida) {
        this.unidadesMedida = unidadesMedida;
    }

    public List<ProgramaProduccionDetalleFracciones> getFraccionesDetalleList() {
        return fraccionesDetalleList;
    }

    public void setFraccionesDetalleList(List<ProgramaProduccionDetalleFracciones> fraccionesDetalleList) {
        this.fraccionesDetalleList = fraccionesDetalleList;
    }

    
    public int getFraccionesDetalleSize() {
        return fraccionesDetalleList.size();
    }



    
}
