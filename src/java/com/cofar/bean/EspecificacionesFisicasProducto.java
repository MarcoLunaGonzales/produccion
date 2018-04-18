/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author wchoquehuanca
 */
public class EspecificacionesFisicasProducto extends AbstractBean {

    private ComponentesProd componenteProd=new ComponentesProd();
    private double limiteInferior=0;
    private double limiteSuperior=0;
    private double valorExacto=0d;
    private String descripcion="";
    private EspecificacionesFisicasCc especificacionFisicaCC= new EspecificacionesFisicasCc();
    private EstadoReferencial estado= new EstadoReferencial();
    private TiposEspecificacionesFisicas tiposEspecificacionesFisicas=new TiposEspecificacionesFisicas();
    public EspecificacionesFisicasProducto() {
    }

    public ComponentesProd getComponenteProd() {
        return componenteProd;
    }

    public void setComponenteProd(ComponentesProd componenteProd) {
        this.componenteProd = componenteProd;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public double getLimiteInferior() {
        return limiteInferior;
    }

    public void setLimiteInferior(double limiteInferior) {
        this.limiteInferior = limiteInferior;
    }

    public double getLimiteSuperior() {
        return limiteSuperior;
    }

    public void setLimiteSuperior(double limiteSuperior) {
        this.limiteSuperior = limiteSuperior;
    }

    public EspecificacionesFisicasCc getEspecificacionFisicaCC() {
        return especificacionFisicaCC;
    }

    public void setEspecificacionFisicaCC(EspecificacionesFisicasCc especificacionFisicaCC) {
        this.especificacionFisicaCC = especificacionFisicaCC;
    }

    public EstadoReferencial getEstado() {
        return estado;
    }

    public void setEstado(EstadoReferencial estado) {
        this.estado = estado;
    }

    public double getValorExacto() {
        return valorExacto;
    }

    public void setValorExacto(double valorExacto) {
        this.valorExacto = valorExacto;
    }

    public TiposEspecificacionesFisicas getTiposEspecificacionesFisicas() {
        return tiposEspecificacionesFisicas;
    }

    public void setTiposEspecificacionesFisicas(TiposEspecificacionesFisicas tiposEspecificacionesFisicas) {
        this.tiposEspecificacionesFisicas = tiposEspecificacionesFisicas;
    }


}
