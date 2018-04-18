/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean;

/**
 *
 * @author DASISAQ-
 */
public class FiltrosProduccion extends AbstractBean
{
    private int codFiltroProduccion=0;
    private int codigoFiltroProduccion=0;
    private String presionAprobación="";
    private MediosFiltracion mediosFiltracion=new MediosFiltracion();
    private String cantidadFiltro="";
    private UnidadesMedida unidadesMedida=new UnidadesMedida();
    private EstadoReferencial estadoRegistro=new EstadoReferencial();
    private UnidadesMedida unidadesMedidaPresion=new UnidadesMedida();

    public FiltrosProduccion() {
    }

    public int getCodFiltroProduccion() {
        return codFiltroProduccion;
    }

    public void setCodFiltroProduccion(int codFiltroProduccion) {
        this.codFiltroProduccion = codFiltroProduccion;
    }

    public int getCodigoFiltroProduccion() {
        return codigoFiltroProduccion;
    }

    public void setCodigoFiltroProduccion(int codigoFiltroProduccion) {
        this.codigoFiltroProduccion = codigoFiltroProduccion;
    }

    public String getPresionAprobación() {
        return presionAprobación;
    }

    public void setPresionAprobación(String presionAprobación) {
        this.presionAprobación = presionAprobación;
    }

    public MediosFiltracion getMediosFiltracion() {
        return mediosFiltracion;
    }

    public void setMediosFiltracion(MediosFiltracion mediosFiltracion) {
        this.mediosFiltracion = mediosFiltracion;
    }

    public String getCantidadFiltro() {
        return cantidadFiltro;
    }

    public void setCantidadFiltro(String cantidadFiltro) {
        this.cantidadFiltro = cantidadFiltro;
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

    public UnidadesMedida getUnidadesMedidaPresion() {
        return unidadesMedidaPresion;
    }

    public void setUnidadesMedidaPresion(UnidadesMedida unidadesMedidaPresion) {
        this.unidadesMedidaPresion = unidadesMedidaPresion;
    }
    
    
}
