/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author aquispe
 */
public class ProgramaProduccionControlCalidadDetalle extends AbstractBean{

    private Materiales material=new Materiales();
    private UnidadesMedida unidadMedida=new UnidadesMedida();
    private TiposAnalisisMaterialReactivo tiposAnalisisMaterialReactivo=new TiposAnalisisMaterialReactivo();
    private Double cantidad=0d;

    public ProgramaProduccionControlCalidadDetalle() {
    }

    public Double getCantidad() {
        return cantidad;
    }

    public void setCantidad(Double cantidad) {
        this.cantidad = cantidad;
    }

    public Materiales getMaterial() {
        return material;
    }

    public void setMaterial(Materiales material) {
        this.material = material;
    }

    public TiposAnalisisMaterialReactivo getTiposAnalisisMaterialReactivo() {
        return tiposAnalisisMaterialReactivo;
    }

    public void setTiposAnalisisMaterialReactivo(TiposAnalisisMaterialReactivo tiposAnalisisMaterialReactivo) {
        this.tiposAnalisisMaterialReactivo = tiposAnalisisMaterialReactivo;
    }

    public UnidadesMedida getUnidadMedida() {
        return unidadMedida;
    }

    public void setUnidadMedida(UnidadesMedida unidadMedida) {
        this.unidadMedida = unidadMedida;
    }

    
}
