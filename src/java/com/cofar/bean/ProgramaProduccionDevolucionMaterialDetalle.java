/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author wchoquehuanca
 */
public class ProgramaProduccionDevolucionMaterialDetalle  extends AbstractBean{

    private Materiales materiales= new Materiales();
    private double cantidadBuenos=0d;
    private double cantidadMalos=0d;
    private double cantidadBuenosEntregados=0d;
    private double cantidadMalosEntregados=0d;
    private String observacion="";
    private ProgramaProduccionDevolucionMaterial programaProduccionDevolucionMaterial= new ProgramaProduccionDevolucionMaterial();
    public ProgramaProduccionDevolucionMaterialDetalle() {

    }

    public double getCantidadBuenos() {
        return cantidadBuenos;
    }

    public void setCantidadBuenos(double cantidadBuenos) {
        this.cantidadBuenos = cantidadBuenos;
    }

    public double getCantidadBuenosEntregados() {
        return cantidadBuenosEntregados;
    }

    public void setCantidadBuenosEntregados(double cantidadBuenosEntregados) {
        this.cantidadBuenosEntregados = cantidadBuenosEntregados;
    }

    public double getCantidadMalos() {
        return cantidadMalos;
    }

    public void setCantidadMalos(double cantidadMalos) {
        this.cantidadMalos = cantidadMalos;
    }

    public double getCantidadMalosEntregados() {
        return cantidadMalosEntregados;
    }

    public void setCantidadMalosEntregados(double cantidadMalosEntregados) {
        this.cantidadMalosEntregados = cantidadMalosEntregados;
    }

    public Materiales getMateriales() {
        return materiales;
    }

    public void setMateriales(Materiales materiales) {
        this.materiales = materiales;
    }

    public String getObservacion() {
        return observacion;
    }

    public void setObservacion(String observacion) {
        this.observacion = observacion;
    }

    public ProgramaProduccionDevolucionMaterial getProgramaProduccionDevolucionMaterial() {
        return programaProduccionDevolucionMaterial;
    }

    public void setProgramaProduccionDevolucionMaterial(ProgramaProduccionDevolucionMaterial programaProduccionDevolucionMaterial) {
        this.programaProduccionDevolucionMaterial = programaProduccionDevolucionMaterial;
    }

    

}
