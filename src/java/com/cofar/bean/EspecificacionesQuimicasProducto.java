/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author wchoquehuanca
 */
public class EspecificacionesQuimicasProducto extends AbstractBean{

    private ComponentesProd componenteProd= new ComponentesProd();
    private EspecificacionesQuimicasCc especificacionQuimica= new EspecificacionesQuimicasCc();
    private Materiales material= new Materiales();
    private double limiteInferior=0;
    private double limiteSuperior=0;
    private String descripcion="";
    private EstadoReferencial estado= new EstadoReferencial();
    private TiposReferenciaCc tiposReferenciaCc= new TiposReferenciaCc();
    private double valorExacto=0d;
    private MaterialesCompuestosCc materialesCompuestosCc=new MaterialesCompuestosCc();
    public EspecificacionesQuimicasProducto() {
    }

    public EstadoReferencial getEstado() {
        return estado;
    }

    public void setEstado(EstadoReferencial estado) {
        this.estado = estado;
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

    public EspecificacionesQuimicasCc getEspecificacionQuimica() {
        return especificacionQuimica;
    }

    public void setEspecificacionQuimica(EspecificacionesQuimicasCc especificacionQuimica) {
        this.especificacionQuimica = especificacionQuimica;
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

    public Materiales getMaterial() {
        return material;
    }

    public void setMaterial(Materiales material) {
        this.material = material;
    }

    public TiposReferenciaCc getTiposReferenciaCc() {
        return tiposReferenciaCc;
    }

    public void setTiposReferenciaCc(TiposReferenciaCc tiposReferenciaCc) {
        this.tiposReferenciaCc = tiposReferenciaCc;
    }

    public double getValorExacto() {
        return valorExacto;
    }

    public void setValorExacto(double valorExacto) {
        this.valorExacto = valorExacto;
    }

    public MaterialesCompuestosCc getMaterialesCompuestosCc() {
        return materialesCompuestosCc;
    }

    public void setMaterialesCompuestosCc(MaterialesCompuestosCc materialesCompuestosCc) {
        this.materialesCompuestosCc = materialesCompuestosCc;
    }

    

}
