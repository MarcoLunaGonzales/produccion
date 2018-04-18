/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author wchoquehuanca
 */
public class EspecificacionesMicrobiologiaProducto extends AbstractBean{

    private ComponentesProd componenteProd= new ComponentesProd();
    private EspecificacionesMicrobiologiaCc especificacionMicrobiologiaCc= new EspecificacionesMicrobiologiaCc();
    private double limiteInferior=0;
    private double limiteSuperior=0;
    private double valorExacto=0d;
    private String descripcion="";
    private EstadoReferencial estado= new EstadoReferencial();
    public EspecificacionesMicrobiologiaProducto() {

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

    public EspecificacionesMicrobiologiaCc getEspecificacionMicrobiologiaCc() {
        return especificacionMicrobiologiaCc;
    }

    public void setEspecificacionMicrobiologiaCc(EspecificacionesMicrobiologiaCc especificacionMicrobiologiaCc) {
        this.especificacionMicrobiologiaCc = especificacionMicrobiologiaCc;
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


}
