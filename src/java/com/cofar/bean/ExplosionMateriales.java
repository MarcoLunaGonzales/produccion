/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author hvaldivia
 */
public class ExplosionMateriales {
    ProgramaProduccion programaProduccion = new ProgramaProduccion();
    Materiales materiales = new Materiales();
    UnidadesMedida unidadesMedida = new UnidadesMedida();
    double cantidadUtilizar = 0.0;
    double cantidadDisponible = 0.0;
    double cantidadTransito = 0.0;

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

    public double getCantidadUtilizar() {
        return cantidadUtilizar;
    }

    public void setCantidadUtilizar(double cantidadUtilizar) {
        this.cantidadUtilizar = cantidadUtilizar;
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

    public UnidadesMedida getUnidadesMedida() {
        return unidadesMedida;
    }

    public void setUnidadesMedida(UnidadesMedida unidadesMedida) {
        this.unidadesMedida = unidadesMedida;
    }
    

}
