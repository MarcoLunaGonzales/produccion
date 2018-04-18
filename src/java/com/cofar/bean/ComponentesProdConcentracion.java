/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author aquispe
 */
public class ComponentesProdConcentracion extends AbstractBean{
    private ComponentesProd componentesProd=new ComponentesProd();
    private double  cantidad=0d;
    private Materiales materiales=new Materiales();
    private UnidadesMedida unidadesMedida=new UnidadesMedida();
    private String unidadProducto="";
    private EstadoReferencial estadoRegistro=new EstadoReferencial();
    private String nombreMaterialEquivalencia="";
    private Double cantidadEquivalencia=0d;
    private UnidadesMedida unidadMedidaEquivalencia=new UnidadesMedida();
    private boolean excipiente=false;
    private Double pesoMolecular = 0d;
    private TiposReferenciaCc tiposReferenciaCc = new TiposReferenciaCc();
    public ComponentesProdConcentracion() {
    }

    public double getCantidad() {
        return cantidad;
    }

    public void setCantidad(double cantidad) {
        this.cantidad = cantidad;
    }

    public ComponentesProd getComponentesProd() {
        return componentesProd;
    }

    public void setComponentesProd(ComponentesProd componentesProd) {
        this.componentesProd = componentesProd;
    }

    public Materiales getMateriales() {
        return materiales;
    }

    public void setMateriales(Materiales materiales) {
        this.materiales = materiales;
    }

    public String getUnidadProducto() {
        return unidadProducto;
    }

    public void setUnidadProducto(String unidadProducto) {
        this.unidadProducto = unidadProducto;
    }

    public UnidadesMedida getUnidadesMedida() {
        return unidadesMedida;
    }

    public void setUnidadesMedida(UnidadesMedida unidadesMedida) {
        this.unidadesMedida = unidadesMedida;
    }

    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }

    public Double getCantidadEquivalencia() {
        return cantidadEquivalencia;
    }

    public void setCantidadEquivalencia(Double cantidadEquivalencia) {
        this.cantidadEquivalencia = cantidadEquivalencia;
    }

    public String getNombreMaterialEquivalencia() {
        return nombreMaterialEquivalencia;
    }

    public void setNombreMaterialEquivalencia(String nombreMaterialEquivalencia) {
        this.nombreMaterialEquivalencia = nombreMaterialEquivalencia;
    }

    public UnidadesMedida getUnidadMedidaEquivalencia() {
        return unidadMedidaEquivalencia;
    }

    public void setUnidadMedidaEquivalencia(UnidadesMedida unidadMedidaEquivalencia) {
        this.unidadMedidaEquivalencia = unidadMedidaEquivalencia;
    }

    public boolean isExcipiente() {
        return excipiente;
    }

    public void setExcipiente(boolean excipiente) {
        this.excipiente = excipiente;
    }

    public Double getPesoMolecular() {
        return pesoMolecular;
    }

    public void setPesoMolecular(Double pesoMolecular) {
        this.pesoMolecular = pesoMolecular;
    }

    public TiposReferenciaCc getTiposReferenciaCc() {
        return tiposReferenciaCc;
    }

    public void setTiposReferenciaCc(TiposReferenciaCc tiposReferenciaCc) {
        this.tiposReferenciaCc = tiposReferenciaCc;
    }
    
    
    

}
