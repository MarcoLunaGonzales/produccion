/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean;

/**
 *
 * @author DASISAQ
 */
public class MesesStockGrupo extends AbstractBean
{
    private Grupos grupos=new Grupos();
    private TiposTransporte tiposTransporte=new TiposTransporte();
    private TiposCompra tiposCompra=new TiposCompra();
    private Double nroMesesStockMinimo=0d;
    private Double nroMesesStockReposicion=0d;
    private Double nivelMaximoStock=0d;
    private Double nivelMinimoStock=0d;
    private Double nroCiclos=0d;
    private Boolean verificarStockHermes=false;
    private Boolean verificarCantidadLote=false;

    public MesesStockGrupo() {
    }

    public Grupos getGrupos() {
        return grupos;
    }

    public void setGrupos(Grupos grupos) {
        this.grupos = grupos;
    }

    public TiposTransporte getTiposTransporte() {
        return tiposTransporte;
    }

    public void setTiposTransporte(TiposTransporte tiposTransporte) {
        this.tiposTransporte = tiposTransporte;
    }

    public TiposCompra getTiposCompra() {
        return tiposCompra;
    }

    public void setTiposCompra(TiposCompra tiposCompra) {
        this.tiposCompra = tiposCompra;
    }

    public Double getNroMesesStockMinimo() {
        return nroMesesStockMinimo;
    }

    public void setNroMesesStockMinimo(Double nroMesesStockMinimo) {
        this.nroMesesStockMinimo = nroMesesStockMinimo;
    }

    public Double getNroMesesStockReposicion() {
        return nroMesesStockReposicion;
    }

    public void setNroMesesStockReposicion(Double nroMesesStockReposicion) {
        this.nroMesesStockReposicion = nroMesesStockReposicion;
    }

    public Double getNivelMaximoStock() {
        return nivelMaximoStock;
    }

    public void setNivelMaximoStock(Double nivelMaximoStock) {
        this.nivelMaximoStock = nivelMaximoStock;
    }

    public Double getNivelMinimoStock() {
        return nivelMinimoStock;
    }

    public void setNivelMinimoStock(Double nivelMinimoStock) {
        this.nivelMinimoStock = nivelMinimoStock;
    }

    public Double getNroCiclos() {
        return nroCiclos;
    }

    public void setNroCiclos(Double nroCiclos) {
        this.nroCiclos = nroCiclos;
    }

    public Boolean getVerificarStockHermes() {
        return verificarStockHermes;
    }

    public void setVerificarStockHermes(Boolean verificarStockHermes) {
        this.verificarStockHermes = verificarStockHermes;
    }

    public Boolean getVerificarCantidadLote() {
        return verificarCantidadLote;
    }

    public void setVerificarCantidadLote(Boolean verificarCantidadLote) {
        this.verificarCantidadLote = verificarCantidadLote;
    }
    
    
}
